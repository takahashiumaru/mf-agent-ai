---
name: gorm-quality
description: "Implement or review GORM models, repositories, CRUD, transactions, associations, joins, hooks, raw SQL, and database-backed behavior in this repository."
---

# GORM Quality

Use with `go-quality` for Go changes and `mysql-performance` for significant queries.

Follow `UNDERSTAND -> INSPECT -> PLAN -> IMPLEMENT -> TEST -> REVIEW`.

## Before Editing

1. Trace controller/service/repository behavior and not-found semantics.
2. Identify transaction ownership and the exact DB handle used.
3. Inspect the model, schema assumptions, callers, and tests.
4. Review zero values, associations, soft delete, query shape, and indexes.
5. Make the smallest compatible change.

## Context and Errors

- Use `db.WithContext(ctx)` when the DB is not already context-bound.
- Always inspect `.Error`.
- Handle `gorm.ErrRecordNotFound` according to domain/API semantics; it is not automatically a 500.
- Prefer explicit returned errors for new APIs and preserve error identity.

## Transactions

The service orchestrating a business operation owns its transaction.

PREFERRED — callback transactions used for login, logout, and refresh rotation in `service/user_service_impl.go`.

```go
return db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
    // Every participating DB operation uses tx.
    return nil
})
```

- Never use the root/global DB inside the callback.
- Return errors to trigger rollback.
- Keep transactions short; keep bcrypt, filesystem, notification, and network work outside.
- Avoid nested transactions unless savepoint semantics are required and tested.
- Never trade atomicity for theoretical speed.

LEGACY — manual `Begin` plus panic-based deferred commit/rollback.

DANGEROUS — unused preliminary `Begin()` calls and `goHelper.CreateTransaction`, which opens read and write transactions while current callers finish only one. Do not copy for new code.

## Creates and Updates

- Check create errors and understand generated IDs/timestamps/hooks.
- `Updates(struct)` skips zero values. Review `0`, `false`, `""`, and NULL explicitly.
- Prefer an allowlisted map, `Select(...).Updates(...)`, `Update(...)`, or pointer patch DTO according to semantics.
- PREFERRED zero/NULL example: `UserRepositoryImpl.UpdateNullTelegram` in `repository/users_repository_impl.go`.
- Do not pass arbitrary request maps to GORM.
- Do not use `Save` as the default partial-update method; it can persist unintended fields or insert unexpectedly.

## Chain Semantics

GORM chain methods return a new handle. Retain it:

```go
tx = tx.Where("department_id = ?", departmentID)
```

DANGEROUS — `helper.ApplyFilter` and optional filters in `UserAccessReport` discard returned handles, so predicates do not reach the final query. Do not copy.

## Deletes and Affected Rows

- Confirm soft versus hard delete from the model.
- Users/roles are soft-deleted; session revocation intentionally uses `Unscoped` hard deletes.
- `UserRole` and `RoleMenuPermission` deletes are hard because their models lack GORM soft-delete clauses.
- Never use `Unscoped` casually.
- Check `RowsAffected` when zero or multiple affected rows change correctness.

PREFERRED — `SessionRepositoryImpl.ConsumeByRefreshUUID` enforces one-time refresh consumption with `RowsAffected == 1`.

## Associations, Preload, and N+1

- Load only required relations.
- Never add `Preload(clause.Associations)` or deep preload trees blindly.
- Check loops for hidden repository/database calls.
- Choose bounded `Preload`, `Joins`, `IN` batching, or aggregation based on cardinality and output needs.
- Avoid automatic association persistence unless the object graph is intentionally saved and tested.
- Search lifecycle hooks before changing create/update/delete behavior; none currently exist.

## Queries and Raw SQL

- Retrieve only needed rows/columns; use projections when materially useful.
- Parameterize values in `Where`, `Raw`, and `Exec`.
- Never pass unvalidated request input to `Order`, `Select`, `Table`, or SQL fragments.
- Existing recursive SQL binds values correctly but needs performance review when changed.
- No obvious N+1 loop exists; preserve the current set-based approach.

## Review Gate

- Correct `tx` and context used.
- `.Error`, not-found, zero values, soft delete, hooks, and associations reviewed.
- No obvious N+1 or unbounded relation loading.
- Transaction rollback and important SQL behavior tested.

Read `../../GORM.md` for current behavior and `../../GORM_BEST_PRACTICES.md` for detailed guidance when relevant.
