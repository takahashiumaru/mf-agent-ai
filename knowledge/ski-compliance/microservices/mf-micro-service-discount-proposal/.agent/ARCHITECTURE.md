# .agent/ARCHITECTURE.md — System Architecture & Request Lifecycle

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

## 1. Architectural Pattern: 5-Tier MVC + Service + Repository

This repository follows a strict 5-tier architecture:

```text
[HTTP Client]
      │
      ▼
 ┌──────────┐
 │  Route   │  (route/*.go)
 └────┬─────┘  - Registers URL endpoints
      │        - Manually wires dependencies (Repository -> Service -> Controller)
      ▼
 ┌────────────┐
 │ Controller │  (controller/*_controller_impl.go)
 └────┬───────┘  - Extracts URL params, query filters, and JSON request bodies
      │          - Validates permissions / hierarchy tokens
      │          - Calls Service methods
      │          - Formats response into `web.WebResponse` envelope
      ▼
 ┌──────────┐
 │ Service  │  (service/*_service_impl.go)
 └────┬─────┘  - Owns business rules and complex calculation logic
      │        - Owns Database Transactions (`tx := s.DB.Begin()`, `defer helper.CommitOrRollback(tx)`)
      │        - Executes DTO validation (`s.Validate.Struct(req)`)
      │        - Calls external validation APIs (e.g. `helper.ValidateClosing`)
      │        - Calls Repositories and triggers side-effect closures
      ▼
 ┌────────────┐
 │ Repository │  (repository/*_repository_impl.go)
 └────┬───────┘  - Executes GORM queries, joins, and raw SQL
      │          - Records audit history via `helper.CreateHistory`
      │          - Dispatches async ETL syncs (`go helper.EtlToMssql(...)`)
      ▼
 ┌──────────┐
 │ Database │  (MySQL / GORM Models in model/domain/)
 └──────────┘
```

---

## 2. Dependency Direction & Layer Separation Rules

1. **Route (`route/`)**:
   - May depend on Controllers, Services, Repositories, `*gin.Engine`, `*gorm.DB`, and `*validator.Validate`.
   - Responsible for assembling the dependency graph manually (Dependency Injection).
   - Example: `route/discount_proposal_route.go`.

2. **Controller (`controller/`)**:
   - Depends only on Service interfaces, helper functions, and DTOs (`model/web`).
   - MUST NOT depend on Repositories or directly query `*gorm.DB`.
   - Extracts request input via `helper.ReadFromRequestBody(c, &request)` and `helper.FilterFromQueryString(c, ...)`.
   - Returns responses using `c.JSON(http.StatusOK, webResponse)`.

3. **Service (`service/`)**:
   - Depends on Repository interfaces, `*gorm.DB` (for transaction boundary management), `*validator.Validate`, domain entities (`model/domain`), and DTOs (`model/web`).
   - MUST NOT import or reference Gin (`*gin.Context`). User context is passed explicitly as `auth *auth.AccessDetails`.
   - Owns transactions and rollback guarantees.

4. **Repository (`repository/`)**:
   - Depends on `*gorm.DB`, domain entities (`model/domain`), DTOs (`model/web`), and helper functions.
   - Accepts `db *gorm.DB` as the first argument in every method so it can seamlessly operate inside or outside an active transaction.
   - Returns entities, slices, or callback closures (`func()`) for post-commit side effects.

5. **Model (`model/`)**:
   - Pure data structures.
   - `model/domain`: Database entities with GORM tags and response mapper methods (`To*Response`).
   - `model/web`: Request payloads with validation tags and response DTOs.

---

## 3. Request Lifecycle Trace

Tracing a representative mutation request (e.g. `POST /discount-proposals`):

```text
1. Client sends HTTP POST /discount-proposals with Bearer JWT token in Authorization header.
2. Gin Engine receives request in `app/router.go`:
   a. OpenTelemetry middleware (`otelgin.Middleware`) generates/propagates trace span.
   b. Error Handler middleware (`app.ErrorHandler()`) sets deferred recover().
3. Route layer (`route/discount_proposal_route.go`):
   a. `auth.Auth` middleware invokes `ExtractTokenMetadata(ExtractToken(req))`.
   b. JWT is verified via `configuration.AccessSecret`; claims populate `*auth.AccessDetails`.
4. Controller (`controller/discount_proposal_controller_impl.go:Create`):
   a. Unmarshals JSON body: `helper.ReadFromRequestBody(c, &request)`.
   b. Invokes `controller.DiscountProposalService.Create(auth, &request)`.
5. Service (`service/discount_proposal_service_impl.go:Create`):
   a. Begins transaction: `tx := service.DB.Begin()`.
   b. Defers cleanup: `defer helper.CommitOrRollback(tx)`.
   c. Validates input: `err := service.Validate.Struct(request)`.
   d. Checks business constraints (period logic, dates, closing status).
   e. Calls `service.CounterRepository.FindByID(...)` to generate proposal ID.
   f. Calls `service.DiscountProposalRepository.Create(tx, &discountProposal)` -> receives entity & callback closure.
   g. Calls related child repositories (`DiscountProposalEventRepository`, `ProposalDocumentStatusRepository`, etc.).
6. Repository (`repository/discount_proposal_repository_impl.go:Create`):
   a. Executes `tx.Create(&discountProposal)`.
   b. Records audit history: `helper.CreateHistory(db, discountProposal, helper.HistoryUpdate, userId)`.
   c. Prepares ETL payload and returns callback closure: `func() { go helper.EtlToMssql(...) }`.
7. Service finishes:
   a. Defer executes `helper.CommitOrRollback(tx)` -> `tx.Commit()`.
   b. Executes post-commit callback closures.
   c. Converts domain model to DTO: `discountProposal.ToDiscountProposalResponse()`.
8. Controller completes:
   a. Builds `web.WebResponse{Success: true, Message: "Discount Proposal created successfully", Data: response}`.
   b. Returns `c.JSON(http.StatusOK, webResponse)`.
```

---

## 4. Transaction Management & Boundaries

### Core Rules
- **Boundary Location**: Exclusively in the `service/` layer.
- **Pattern**:
  ```go
  tx := service.DB.Begin()
  defer helper.CommitOrRollback(tx)

  // Pass tx to all repository methods involved in the unit of work
  res, sideEffect := service.SomeRepository.Create(tx, &entity)
  // ... other repository operations ...

  // helper.CommitOrRollback will automatically commit on clean exit,
  // or rollback and re-panic if any error/panic was raised.
  ```

### `helper.CommitOrRollback` (`helper/tx.go`)
```go
func CommitOrRollback(tx *gorm.DB) {
    err := recover()
    if err != nil {
        errorRollback := tx.Rollback().Error
        PanicIfError(errorRollback)
        panic(err) // Re-panic to bubble up to Gin ErrorHandler
    } else {
        errorCommit := tx.Commit().Error
        if errorCommit != nil && strings.Contains(errorCommit.Error(), "transaction has already been committed or rolled back") {
            return
        }
        PanicIfError(errorCommit)
    }
}
```

---

## 5. Side Effects & External Sync

1. **Audit Logging (`helper/history.go`)**:
   - Captured synchronously within the transaction.
   - Serializes changed fields to JSON and inserts into the `histories` table (`domain.History`).
   - Triggered on `Create`, `Update`, `Delete` across repositories.

2. **MSSQL ETL Sync (`helper/etl_to_mssql.go`)**:
   - Executed asynchronously in a detached goroutine via closures:
     ```go
     return discountProposal, func() {
         sourceID := discountProposal.ID
         go helper.EtlToMssql("vw_migrasi_ski_discount_proposal", sourceID, "UPDATE", 0, sourceSet, sourceID, "H_DiscountProposal_Foxpro", "HDP_KodeDiskon")
     }
     ```
   - Syncs MySQL mutations to legacy FoxPro/MSSQL systems without blocking the client response.

3. **External Period & Budget Checks**:
   - `helper.ValidateClosing`: Synchronous HTTP call to `NOCODE_URL/status_closings` to prevent mutations on locked periods.
   - `helper.ValidateBudget`: Synchronous HTTP call to check remaining budget thresholds before approving proposals.
