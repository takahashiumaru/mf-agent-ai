# System Architecture — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## 1. High-Level Architecture

The service follows a layered architecture with explicit interfaces separating Controllers, Services, and Repositories.

```
                  +-----------------------------------+
                  |         HTTP Client / API         |
                  +-----------------------------------+
                                    |
                                    v
                  +-----------------------------------+
                  |        Gin Router & Routes        |
                  |     (app/router.go, route/*.go)    |
                  +-----------------------------------+
                                    |
            +-----------------------+-----------------------+
            |                       |                       |
            v                       v                       v
     [otelgin Tracer]     [app.ErrorHandler()]        [auth.Auth()]
            |                       |                       |
            +-----------------------+-----------------------+
                                    |
                                    v
                  +-----------------------------------+
                  |         Controller Layer          |
                  |     (controller/*_impl.go)        |
                  +-----------------------------------+
                                    |
                                    v
                  +-----------------------------------+
                  |           Service Layer           |
                  |       (service/*_impl.go)         |
                  |  - Validator Struct Validation    |
                  |  - Begins & Commits DB Tx         |
                  |  - Business Logic & Orchestration |
                  +-----------------------------------+
                                    |
                                    v
                  +-----------------------------------+
                  |         Repository Layer          |
                  |      (repository/*_impl.go)       |
                  |  - Executes GORM DB queries       |
                  |  - Logs History (helper.Create...) |
                  |  - Returns ETL sync closures      |
                  +-----------------------------------+
                                    |
                     +--------------+--------------+
                     |                             |
                     v                             v
           +-------------------+         +-------------------+
           |    MySQL (GORM)   |         |   External Sync   |
           |  (model/domain)   |         |    (MSSQL ETL)    |
           +-------------------+         +-------------------+
```

---

## 2. Layer Responsibilities & Boundaries

### A. Router & Middleware Layer ([app/](../app), [route/](../route), [auth/](../auth))
- **Responsibilities**:
  - Registers URL endpoints and HTTP verbs onto `gin.Engine`.
  - Attaches global OpenTelemetry tracing (`otelgin.Middleware`) and Panic Recovery (`app.ErrorHandler()`).
  - Enforces JWT authentication and extracts user claims into `auth.AccessDetails`.
- **Forbidden**: No database queries, no business rules, no direct payload mutation.

### B. Controller Layer ([controller/](../controller))
- **Structure**: Each module defines an interface (e.g., `BridgingOutletController`) and an implementation (e.g., `BridgingOutletControllerImpl`).
- **Responsibilities**:
  - Reads URL path parameters, query filters (`helper.FilterFromQueryString`), and parses JSON request bodies (`helper.ReadFromRequestBody`).
  - Calls corresponding service method passing `auth *auth.AccessDetails` and request DTOs.
  - Formats output using `web.WebResponse{Success: true, Message: "...", Data: ...}` and returns `c.JSON(http.StatusOK, webResponse)`.
- **Forbidden**: Must NEVER interact with `*gorm.DB` directly; must NEVER execute business calculations.

### C. Service Layer ([service/](../service))
- **Structure**: Interface (e.g., `BridgingOutletService`) and implementation (e.g., `BridgingOutletServiceImpl`).
- **Dependencies Injected**: `repository.XxxRepository`, `DB *gorm.DB`, `Validate *validator.Validate`.
- **Responsibilities**:
  - **Validates Input**: `err := service.Validate.Struct(request)` followed by `helper.PanicIfError(err)`.
  - **Owns Database Transactions**:
    ```go
    tx := service.DB.Begin()
    err := tx.Error
    helper.PanicIfError(err)
    defer helper.CommitOrRollback(tx)
    ```
  - **Orchestrates Business Logic**: Evaluates period closing locks (`helper.ValidateClosing`), constructs domain models, and calls repositories.
  - **Executes Existing ETL Callbacks Before Commit**: If a repository returns an ETL callback, the service invokes it after DB work but before its deferred transaction finalizer. Preserve this ordering during structural refactors.
  - **Transforms Output**: Calls `.ToXxxResponse()` on domain entity/slice to produce response DTO.
- **Forbidden**: Must not construct raw SQL strings; must not send HTTP responses.

### D. Repository Layer ([repository/](../repository))
- **Structure**: Interface (e.g., `BridgingOutletRepository`) and implementation (e.g., `BridgingOutletRepositoryImpl`).
- **Responsibilities**:
  - Receives the active `*gorm.DB` instance (which is the transaction `tx` passed from the service).
  - Applies dynamic filters via `helper.ApplyFilter(tx, filters)`.
  - Executes GORM operations (`Create`, `Updates`, `First`, `Find`, `Delete`).
  - Creates change audit records via `helper.CreateHistory(db, model, action, userId)`.
  - Prepares and returns ETL sync closures (`func() { go helper.EtlToMssql(...) }`).
- **Forbidden**: Must NEVER call `db.Begin()` internally; must not perform HTTP parameter parsing.

---

## 3. Dependency Injection & Object Construction

Dependency injection is handled manually in the `route/` package functions when bootstrapping the router:

Example from [route/bridging_outlet_route.go](../route/bridging_outlet_route.go):
```go
func BridgingOutletRoute(router *gin.Engine, db *gorm.DB, validate *validator.Validate) {
    repo := repository.NewBridgingOutletRepository()
    svc := service.NewBridgingOutletService(repo, db, validate)
    ctrl := controller.NewBridgingOutletController(svc)

    router.GET("/bridging-outlets", auth.Auth(ctrl.FindAll, []string{}))
    router.POST("/bridging-outlets", auth.Auth(ctrl.Create, []string{}))
    router.GET("/bridging-outlets/:id", auth.Auth(ctrl.FindByID, []string{}))
    router.PUT("/bridging-outlets/status/:id", auth.Auth(ctrl.UpdateStatus, []string{}))
    router.DELETE("/bridging-outlets/:id", auth.Auth(ctrl.Delete, []string{}))
}
```

---

## 4. Request Lifecycle Trace

Tracing `POST /bridging-outlets`:
1. **Gin Router**: Incoming HTTP request matches `route.BridgingOutletRoute`.
2. **`auth.Auth` Middleware**: Parses Bearer token from header `Authorization`, validates JWT signature with `configuration.AccessSecret`, and attaches `*auth.AccessDetails` to the handler call.
3. **`BridgingOutletControllerImpl.Create`**:
   - Parses request body JSON into `web.BridgingOutletCreateRequest{}` via `helper.ReadFromRequestBody(c, &request)`.
   - Calls `BridgingOutletService.Create(auth, &request)`.
4. **`BridgingOutletServiceImpl.Create`**:
   - Calls `service.Validate.Struct(request)` (panics on validation failure -> caught by error middleware -> HTTP 400).
   - Starts transaction `tx := service.DB.Begin()` with `defer helper.CommitOrRollback(tx)`.
   - Maps DTO fields to `&domain.BridgingOutlet{}`.
   - Calls `service.BridgingOutletRepository.Create(tx, bridgingOutlet)`.
5. **`BridgingOutletRepositoryImpl.Create`**:
   - Executes `db.Create(&bridgingOutlet).Joins("Outlet").Joins("Distributor").First(&bridgingOutlet)`.
   - Returns updated domain pointer and a background closure:
     `func() { go helper.EtlToMssql("bridging_outlets", sourceID, "INSERT", ...) }`.
6. **Service Completion & Commit**:
   - Service executes `updateEtl()` closure.
   - Deferred `helper.CommitOrRollback(tx)` commits transaction `tx.Commit()`.
   - Converts domain object to DTO via `bridgingOutlet.ToBridgingOutletResponse()`.
7. **Controller Response**:
   - Wraps DTO in `web.WebResponse{Success: true, Message: "...", Data: response}` and returns HTTP 200 OK.

---

## 5. Transaction Ownership

- **Owner**: Exclusively the **Service layer**.
- **Pattern**:
  ```go
  tx := service.DB.Begin()
  err := tx.Error
  helper.PanicIfError(err)
  defer helper.CommitOrRollback(tx)
  ```
- **Propagation**: The service passes `tx *gorm.DB` as the first argument to repository methods.
- **Rollback / Commit Mechanism**: [helper/tx.go](../helper/tx.go) uses `recover()`:
  - If a panic occurs, it executes `tx.Rollback()` and re-panics to be caught by `app.ErrorHandler()`.
  - If no panic occurs, it executes `tx.Commit()`.


## Package responsibility update — 2026-09-29

See [package and dependency ownership](../docs/architecture/package-dependencies.md) for the current FF repository file split, internal workbook package, public compatibility wrappers, and cross-module import constraints. Route remains the manual composition root. Public service and repository contracts are unchanged.
