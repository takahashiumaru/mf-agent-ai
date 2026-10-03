# .agent/GORM_BEST_PRACTICES.md — GORM Persistence Standards & Query Safety

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

This document establishes verified GORM and data-access standards for `mf-micro-service-discount-proposal`.

---

## 1. Context, Errors & Result Verification

### GORM Error Inspection
- **Classification**: `PREFERRED`
- **Applies when**: Executing any GORM query, mutation, or transaction step.
- **Rule**: Always assign and inspect `tx.Error` or `db.Error`. Immediately evaluate with `helper.PanicIfError(err)`.
- **Why**: GORM stores execution failures inside `*gorm.DB.Error` rather than returning them as standard second return values on method chains.
- **Repository evidence**: `repository/discount_proposal_repository_impl.go:83`, `helper/error.go`
- **Verification**: Ensure every GORM call assigns `.Error` and tests it.

### `ErrRecordNotFound` Handling
- **Classification**: `PREFERRED`
- **Applies when**: Querying single records by primary key or criteria.
- **Rule**:
  - Distinguish expected empty results from fatal database infrastructure errors.
  - In this API contract, "Record not found" returns HTTP 200 OK with `Success: true, Message: "Record not found"` rather than crashing or returning HTTP 500.
- **Why**: Conforms to the SKI API response contract expected by downstream clients.
- **Repository evidence**: `exception/error_handler.go:63-75`, `helper/model.go:17-35`

---

## 2. Creates & Zero-Value Safe Updates

### Explicit Map Updates for Zero / Nil Values
- **Classification**: `PREFERRED`
- **Applies when**: Updating records where fields must be set to `0`, `""`, `false`, or `nil`.
- **Rule**:
  - You MUST use `db.Updates(map[string]interface{}{"column": value})` or `.Select("col1", "col2").Updates(&struct)` when zero values must be persisted.
  - NEVER use `db.Updates(&struct)` when attempting to clear/nullify columns.
- **Why**: GORM struct updates (`db.Updates(&struct)`) omit all Go zero values by design, silently ignoring requested changes.
- **Repository evidence**: `repository/discount_proposal_repository_impl.go:511-519`
- **Verification**: Add test asserting that `status_over_budget = nil` persists to MySQL.

```go
// Preferred: Explicit map updates for zero values
err := tx.Model(&domain.DiscountProposal{}).
    Where("id = ?", id).
    Updates(map[string]interface{}{
        "status_over_budget":            nil,
        "marketing_structure_budget_id": nil,
        "updated_by_id":                 auth.UserID,
        "updated_at":                    time.Now(),
    }).Error
helper.PanicIfError(err)
```

### Avoid `db.Save()` for Partial Updates
- **Classification**: `DANGEROUS`
- **Applies when**: Performing updates on existing records.
- **Rule**: Do NOT use `db.Save(&struct)` for partial updates. Use targeted `db.Model(&entity).Where(...).Updates(...)`.
- **Why**: `db.Save` overwrites all columns in the table, potentially overwriting concurrent changes or resetting unpopulated struct fields.
- **Repository evidence**: `repository/discount_proposal_repository_impl.go:443`

---

## 3. Deletes & Soft-Delete Consistency

### Preserving Soft-Delete Semantics
- **Classification**: `PREFERRED`
- **Applies when**: Querying or deleting records.
- **Rule**:
  - For models with `gorm.DeletedAt` (`DiscountProposal`): GORM automatically adds `deleted_at IS NULL`.
  - For models with `*time.Time` (`CreditNote`, `CustomerBalance`, `CreditNoteAmortization`): Queries and joins MUST explicitly append `Where("table.deleted_at IS NULL")`.
  - Never call `db.Unscoped()` without explicit business justification and safety review.
- **Why**: Prevents soft-deleted records from leaking into active financial balances and reports.
- **Repository evidence**: `model/domain/discount_proposal.go:32`, `model/domain/credit_note.go:25`, `repository/credit_note_repository_impl.go`

---

## 4. Transaction Boundaries & Safety

### Service-Owned Transactions
- **Classification**: `PREFERRED`
- **Applies when**: Implementing multi-step mutations (e.g. creating proposal with estimations and events).
- **Rule**:
  - Open transaction in Service: `tx := s.DB.Begin()`.
  - Register immediate rollback guard: `defer helper.CommitOrRollback(tx)`.
  - Pass `tx *gorm.DB` to all repository methods participating in the unit of work.
  - NEVER fall back to `s.DB` inside a transaction.
  - Avoid making slow external HTTP network calls while database locks are held.
- **Why**: Prevents race conditions, inconsistent state, and database deadlocks.
- **Repository evidence**: `service/discount_proposal_service_impl.go:130`, `helper/tx.go`
- **Verification**: Code review verifying all repository calls in a mutation use `tx`.

---

## 5. Parameterized Queries & Preloading

### Parameterized SQL Joins & Dynamic Filters
- **Classification**: `PREFERRED`
- **Applies when**: Writing custom raw SQL, joins, or dynamic filters.
- **Rule**:
  - Always use `?` parameter placeholders: `db.Where("period = ? AND division_id = ?", period, divisionID)`.
  - NEVER format SQL queries using `fmt.Sprintf` or string concatenation.
  - Dynamic query filtering must use `helper.ApplyFilter(tx, filters)`.
- **Why**: Eliminates SQL injection vulnerabilities and enables MySQL query plan caching.
- **Repository evidence**: `helper/apply_filter.go:39`, `repository/discount_proposal_repository_impl.go:67`
- **Verification**: Static analysis and security reviews.

### Bounded List Queries
- **Classification**: `PREFERRED`
- **Applies when**: Querying lists of records.
- **Rule**: Always include `.Limit(N)` or explicit pagination filters on list queries to prevent memory exhaustion.
- **Why**: Tables like `credit_notes` and `discount_proposal_estimations` contain hundreds of thousands of rows.
- **Repository evidence**: `repository/discount_proposal_repository_impl.go:47` (`.Limit(100)`), `repository/credit_note_repository_impl.go`
