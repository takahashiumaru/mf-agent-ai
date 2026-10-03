# GORM Best Practices

Use this guide for new queries and for reviewing or improving existing persistence code. `GORM.md` describes what exists; this file defines what future code should prefer.

## Mandatory Pre-Implementation Check

Before writing or modifying GORM code:

1. Understand the required behavior and not-found semantics.
2. Trace the service transaction boundary.
3. Inspect the nearest sound repository implementation.
4. Confirm context propagation.
5. Confirm update/delete semantics, especially zero values and soft delete.
6. Review query shape, selected columns, joins, pagination, and indexes.
7. Inspect relevant tests.
8. Implement the smallest safe change.

## Context

Use the caller's context:

```go
result := tx.WithContext(ctx).Where("id = ?", id).First(&user)
```

- Do not lose request cancellation or deadlines.
- If a transaction was created with `WithContext`, reuse that transaction.
- Prefer repository methods that accept `context.Context` for new APIs.
- Do not call `context.Background()` for request-bound queries.

Repository status: resolver transactions created by go-helper are context-bound. Plain user/session repository calls are not; migrate them when those signatures and callers are already being changed.

## Error Handling

Always inspect `result.Error`.

```go
result := db.WithContext(ctx).First(&user, id)
switch {
case errors.Is(result.Error, gorm.ErrRecordNotFound):
    return domain.User{}, ErrUserNotFound
case result.Error != nil:
    return domain.User{}, fmt.Errorf("find user %d: %w", id, result.Error)
default:
    return user, nil
}
```

- Treat not-found according to business behavior; it is not automatically a 500.
- Preserve `gorm.ErrRecordNotFound` identity when callers need it, or translate it once to a domain error.
- Do not use panic for expected database outcomes in new APIs.
- Do not parse driver message strings in repositories when a stable driver error type/code is available. Current centralized MySQL string matching is legacy compatibility.

## Create

- Pass the intended model and check the result error.
- Remember GORM populates generated primary keys and timestamps on the passed model.
- Validate required business fields before persistence.
- Keep automatic association saving out of creates unless it is explicitly required and tested.
- Use the transaction supplied by the service.

Current examples: simple creates in `repository/users_repository_impl.go` and `repository/role_repository_impl.go`. Their error-panic style is legacy; their explicit passed-DB ownership is sound.

## Partial Updates

`Updates(struct)` skips zero-value fields. This is unsafe when `0`, `false`, or `""` means “set this value.”

Preferred choices:

1. Use a typed update DTO with pointer fields to represent omitted versus supplied values, then build an allowlisted map.
2. Use `map[string]interface{}` for a small explicit set of columns, as in `UserRepositoryImpl.UpdateNullTelegram`.
3. Use `Select("field_a", "field_b").Updates(model)` when a struct is useful and the selected columns must include zero values.
4. Use `Update("column", value)` for one explicit column.

Example:

```go
updates := map[string]interface{}{
    "telegram_id": nil,
    "device_id":   "",
}
result := tx.WithContext(ctx).
    Model(&domain.User{}).
    Where("id = ?", id).
    Updates(updates)
if result.Error != nil {
    return fmt.Errorf("clear user device fields: %w", result.Error)
}
```

Never pass arbitrary request maps directly to `Updates`; allowlist columns in application code. Re-read the row only when the caller needs database-generated/default values.

## `Save`

`Save` is not used in this repository and must not be introduced casually. It writes all fields and may insert when the primary key is absent, which can persist stale/default values or change more columns than intended. Prefer explicit `Updates`, `Update`, or `Select(...).Updates(...)` for partial modifications.

## Delete

- Know whether the model uses `gorm.DeletedAt`.
- Users and roles are soft-deleted through `gorm.Model`.
- Sessions are deliberately hard-deleted with `Unscoped()` for revocation.
- `UserRole` and `RoleMenuPermission` are hard-deleted because their models do not implement GORM soft-delete clauses.
- Do not use `Unscoped()` outside an explicit hard-delete requirement.
- If deletion is actually a business state transition, update the state rather than deleting the row.
- Use `RowsAffected` when correctness requires proving a row was deleted or transitioned.

Current preferred correctness example: `SessionRepositoryImpl.ConsumeByRefreshUUID` checks `RowsAffected == 1` to enforce one-time refresh consumption.

## Transactions

The transaction owner must be obvious—normally the service orchestrating the business operation.

Preferred new multi-write pattern:

```go
err := db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
    if err := repoA.Write(ctx, tx, input); err != nil {
        return err
    }
    if err := repoB.Write(ctx, tx, input); err != nil {
        return err
    }
    return nil
})
```

Rules:

- Use the callback's `tx` for every query in the transaction.
- Return errors so GORM rolls back.
- Do not call the root/global DB from inside the callback.
- Keep the transaction short; perform bcrypt, file I/O, notifications, and remote calls outside unless correctness requires otherwise.
- Avoid nested transactions unless their savepoint behavior is explicitly required and tested.
- Do not start transactions for simple reads by default.

Preferred repository example: atomic session deletion/creation and token update in `service/user_service_impl.go` login/refresh flows.

Legacy patterns:

- Manual `Begin` plus panic-based deferred commit/rollback throughout user CRUD.
- Preliminary unused `Begin()` calls in role services.
- `goHelper.CreateTransaction` begins both read and write transactions, while callers close only the handle used. Do not copy this for new code. Migrate resolver flows carefully when touched, preserving read/write routing requirements and updating tests.

## Chainable Methods

GORM methods such as `Where`, `Select`, `Order`, `Limit`, and `Offset` return a new chain handle. Retain it:

```go
tx = tx.Where("department_id = ?", departmentID)
```

Do not copy current discarded-chain patterns:

- `helper.ApplyFilter` reassigns `tx` locally but does not return it.
- `UserAccessReport` calls `tx.Where(...)` without assignment.

Those filters are not carried into the later query with GORM v1.25. Prefer a helper that returns `(*gorm.DB, error)` or build the chain directly.

## Preload and Associations

No `Preload` convention currently exists; relations use `Joins` or explicit SQL.

- Use `Preload` only when the complete related records are required.
- Add conditions/selects to limit relation size where appropriate.
- Never add `Preload(clause.Associations)` blindly on large lists.
- Account for extra queries, memory, and response size.
- Avoid automatic association create/update unless the complete object graph is intentionally persisted.
- Inspect hooks and association behavior before changing lifecycle operations.

No GORM model hooks were found. Re-check before adding or changing one.

## Joins

Use joins for filtering, aggregation, or compact projections when they produce the desired cardinality. Existing examples include `repository/user_role_repository_impl.go` and `repository/users_repository_impl.go`.

- Select only required columns.
- Qualify ambiguous columns.
- Verify one-to-many joins do not duplicate root rows or corrupt counts.
- Ensure soft-delete/tenant/ownership predicates are present for every relevant joined table.
- Use `Distinct` or aggregation only when semantically correct, not to hide a bad join.

## N+1 Queries

Actively search for database calls inside loops:

```go
for _, item := range items {
    db.Where("parent_id = ?", item.ID).Find(&children)
}
```

Choose based on the data shape:

- `Preload` for bounded full associations;
- `Joins` for filtering/projection;
- one `WHERE parent_id IN ?` batch query, then group results in Go;
- database aggregation for counts/sums;
- a dedicated bulk repository method.

No clear N+1 repository loop was found in the current code. Preserve that property; the existing join and recursive-CTE approaches are preferable to per-row queries.

## Select Columns

Every query should retrieve only the fields and relationships the operation needs.

- Use `Select` for list/report/login projections when it materially reduces transfer, scanning, memory, or sensitive-field exposure.
- Do not add `Select` mechanically to trivial low-volume lookups.
- Keep projection structs aligned with selected aliases.

Current optimization candidates: `UserRepositoryImpl.FindAll` loads full `domain.User` rows before returning a response subset, and `JoinUserAndStructure` selects `users.*`, including sensitive token fields that the login query does not need.

## Pagination and Sorting

- List endpoints must have a validated positive limit with a defensible maximum.
- Allowlist sort columns and direction before calling `Order`; never pass raw query text.
- Use stable ordering, normally including a unique key.
- OFFSET pagination is acceptable for modest datasets; large offsets become increasingly expensive.
- Consider keyset/cursor pagination only when row counts and execution plans justify it and the API contract can support it.

Current pagination uses go-helper `Limit`/`Offset`/`Order`. Its raw `sort` input and default page/offset behavior require validation before reuse in new endpoints.

## Count Queries

- Run `COUNT(*)` only when the response needs a total.
- Remove pagination ordering/limits from the count query.
- With joins, count the intended root rows and use `Distinct(root_id)` when necessary.
- Avoid repeating the same expensive filtered join solely for a count when the product can use “has more” semantics.

Current role/user lists calculate a total for every request. Preserve the API contract, but review the count plan when those tables or filters become expensive.

## Batch Operations

- Avoid one insert/update per row in a large loop.
- Use `CreateInBatches`, a bounded `IN` query, or a deliberate bulk statement when atomicity and hooks are understood.
- Pick a bounded batch size based on payload/parameter limits and observed workload; do not guess a universal size.
- Verify whether hooks, timestamps, IDs, and conflicts must be handled per row.

No established batch-operation pattern exists in this repository.

## Upsert

`UserRepositoryImpl.InsertUpdateOnDuplicate` uses `clause.OnConflict` on `(id, company_id)` with an explicit assignment map. When extending it:

- confirm the deployed unique/primary constraint matches the conflict columns;
- preserve the intended column allowlist;
- decide explicitly how empty/null values and deleted rows behave;
- use `RowsAffected` if inserted-versus-updated outcome matters;
- test the generated SQL or real MySQL behavior.

Do not invent different upsert semantics for the same entity.

## Locking

No `clause.Locking` usage exists. Add row locking only for a proven correctness race and only inside a transaction. Keep the locked transaction short, use the weakest sufficient lock, and test concurrent behavior. Do not add locks as speculative performance fixes.

## Raw SQL

- Bind values: `db.Raw("SELECT ... WHERE id = ?", id)`.
- Never concatenate untrusted values into SQL.
- Keep SQL in repositories and explain non-obvious MySQL-specific behavior.
- Select explicit columns and align aliases with scan structs.
- Test parameter ordering and empty results.

Current recursive hierarchy SQL correctly binds periods and IDs. Current generic search/sort helpers construct SQL fragments from request strings and are dangerous unless columns/directions are allowlisted and search values are bound.

## Hooks

Before changing lifecycle behavior, search for `BeforeCreate`, `BeforeUpdate`, `AfterCreate`, `AfterUpdate`, `BeforeDelete`, `AfterDelete`, and `AfterFind`. None were found during this analysis, but future additions can change create/update/delete cost and side effects.

## `RowsAffected`

Check `RowsAffected` when business correctness depends on exactly one row changing—for example token consumption, optimistic transitions, or ownership-constrained updates. A nil error with zero affected rows is not always success.

## Performance Principle

Every query must retrieve only the rows, columns, and relationships required for that operation. Confirm behavior first, then optimize from evidence rather than intuition.
