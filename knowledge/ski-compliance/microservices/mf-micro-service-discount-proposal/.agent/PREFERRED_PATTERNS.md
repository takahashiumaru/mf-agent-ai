# .agent/PREFERRED_PATTERNS.md — Preferred Engineering Patterns & Architectural Direction

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

This document establishes the **PREFERRED** patterns for writing new code and refactoring existing code in `mf-micro-service-discount-proposal`.

---

## 1. Architectural Boundaries & Dependency Injection

### Preferred Pattern
- Strict 5-tier layer separation: `Route` -> `Controller` -> `Service` -> `Repository` -> `Database`.
- Repositories accept `db *gorm.DB` as their first argument.
- Services accept `auth *auth.AccessDetails` for authorization and user context.
- Constructors return interface types (`New<Name>Service(...) <Name>Service`).

```go
// Preferred: Constructor returning interface and accepting repository interfaces
func NewDiscountProposalService(
    repo repository.DiscountProposalRepository,
    db *gorm.DB,
    validate *validator.Validate,
) DiscountProposalService {
    return &DiscountProposalServiceImpl{
        DiscountProposalRepository: repo,
        DB:                         db,
        Validate:                   validate,
    }
}
```

- **Why Preferred**: Enables unit testing via mock repositories and isolates layer responsibilities.
- **Legacy Alternative to Avoid**: Instantiating concrete repositories or global DB instances inside services.

---

## 2. Transaction Management & Boundaries

### Preferred Pattern
- Transactions MUST be initiated in the `service/` layer using `tx := s.DB.Begin()` with immediate `defer helper.CommitOrRollback(tx)`.
- Pass `tx` down to all repository methods participating in the unit of work.

```go
// Preferred: Transaction owned by Service
func (s *DiscountProposalServiceImpl) Create(auth *auth.AccessDetails, req *web.DiscountProposalCreateRequest) web.DiscountProposalResponse {
    tx := s.DB.Begin()
    defer helper.CommitOrRollback(tx)

    // Validation
    err := s.Validate.Struct(req)
    helper.PanicIfError(err)

    // Call repositories with tx
    res, sideEffect := s.DiscountProposalRepository.Create(tx, &entity)

    // Trigger side effects after transaction logic
    if sideEffect != nil {
        defer sideEffect()
    }

    return res.ToDiscountProposalResponse()
}
```

- **Why Preferred**: Guarantees atomic rollback on any error or panic, avoiding partial database writes.
- **Legacy Alternative to Avoid**: Opening separate transactions inside individual repositories or mixing `s.DB` and `tx` in the same operation.

---

## 3. Safe GORM Reads, Updates & Deletes

### Preferred Read Pattern (Parameterized & Bounded)
- Always use parameterized bindings (`?`) for WHERE conditions.
- Include `deleted_at IS NULL` for models using `*time.Time` for soft deletes.
- Use `.Limit(N)` or pagination on list queries to prevent full table scans.

```go
// Preferred: Parameterized query with explicit soft-delete check
func (r *CreditNoteRepositoryImpl) FindByInvoice(db *gorm.DB, invoiceNo string) ([]domain.CreditNote, error) {
    var creditNotes []domain.CreditNote
    err := db.Where("invoice_no = ? AND deleted_at IS NULL", invoiceNo).
        Limit(500).
        Find(&creditNotes).Error
    return creditNotes, err
}
```

- **Legacy Alternative to Avoid**: String concatenation or `fmt.Sprintf` inside SQL JOIN or WHERE clauses (e.g. `TD-001`).

### Preferred Update Pattern (Zero-Value Safe)
- Use `db.Updates(map[string]interface{}{...})` or `.Select("columns...").Updates(&struct)` when zero values, `false`, or `nil` must be persisted.

```go
// Preferred: Explicit map updates for nullable fields
func (r *DiscountProposalRepositoryImpl) ResetOverBudget(db *gorm.DB, id string, updatedByID uint) error {
    return db.Model(&domain.DiscountProposal{}).
        Where("id = ?", id).
        Updates(map[string]interface{}{
            "status_over_budget":            nil,
            "marketing_structure_budget_id": nil,
            "updated_by_id":                 updatedByID,
            "updated_at":                    time.Now(),
        }).Error
}
```

- **Legacy Alternative to Avoid**: Calling `db.Updates(&struct)` when attempting to clear/nullify fields (e.g. `TD-005`).

---

## 4. Error Handling & Response Mapping

### Preferred Error Pattern
- Abort business flow with clear, user-facing error messages using `panic(&exception.ErrorSendToResponse{Err: "message"})`.
- Propagate unexpected infrastructure errors via `helper.PanicIfError(err)`.
- Return `web.WebResponse` with HTTP 200 for all successful operations and empty query results.

```go
// Preferred: Standard Business Rule Panic
if request.PeriodEnd < request.PeriodStart {
    panic(&exception.ErrorSendToResponse{
        Err: "Period end yang kamu input harus lebih besar dari period start",
    })
}
```

- **Why Preferred**: Integrates seamlessly with `app.ErrorHandler()` and `helper.CommitOrRollback(tx)`.
- **Legacy Alternative to Avoid**: Swallowing errors, returning raw HTTP 500 for validation errors, or returning HTTP 404 for empty queries.

---

## 5. Domain-to-DTO Conversion

### Preferred Pattern
- Implement conversion methods on domain models (`To<Model>Response()` and `To<Model>Responses()`).
- Keep presentation mapping logic inside `model/domain/` rather than spreading manual struct mappings across services or controllers.

```go
// Preferred: Encapsulated mapper method
func (dp *DiscountProposal) ToDiscountProposalResponse() web.DiscountProposalResponse {
    return web.DiscountProposalResponse{
        ID:        dp.ID,
        Period:    IfNullString(dp.Period),
        Status:    IfNullString(dp.Status),
        CreatedAt: dp.CreatedAt,
        CreatedBy: dp.CreatedBy.ToUserShortResponse(),
        // ...
    }
}
```

---

## 6. Audit Logging & Side Effect Closures

### Preferred Pattern
- Repositories record historical audit changes synchronously within the transaction via `helper.CreateHistory(db, entity, action, userId)`.
- External syncs (like MSSQL ETL) should be returned as callback closures (`func()`) to be executed after the database commit.

```go
// Preferred: Repository returns callback closure for post-commit execution
return entity, func() {
    go helper.EtlToMssql(tableName, id, "UPDATE", 0, sourceSet, id, destTable, destKey)
}
```
