---
name: gorm-quality
description: Use when changing GORM models, repositories, CRUD, associations, transactions, hooks, Preload, Joins, or raw SQL.
---

# GORM Quality

## Core Principle

Make SQL, transaction, and update semantics explicit. Clean ORM chains do not prove efficient SQL.

## Required Workflow

`UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW`

Trace the transaction boundary, repository chain, model tags, indexes, and SQL-shape tests before editing.

## Repository Pattern Classification

- **PREFERRED:** context-bound service transactions that pass the same `*gorm.DB` through every atomic operation, as in `OfficeServiceImpl.Create`, `Update`, and `Delete` in `service/office_service_impl.go`.
- **PREFERRED:** explicit model, key predicate, update, then reload in `repository/leave_repository_impl.go`.
- **PREFERRED:** targeted joins and parameter placeholders in `repository/presence_repository_impl.go`.
- **PREFERRED:** chunked insert/upsert with `clause.OnConflict{DoNothing: true}` in `repository/leave_quota_repository_impl.go` when duplicate-ignore is intended.
- **MIGRATE-WHEN-TOUCHED:** `Updates(&pointer)` and broad struct updates; make intended columns explicit where practical.
- **DANGEROUS:** using `DatabaseResolver.Read` for a decision that controls a write in the same business operation; replica state may be stale and is not part of the write transaction.
- **DANGEROUS:** unassigned GORM chains, such as the conditional `tx.Joins(...)` in `repository/leave_repository_impl.go`; chain-returning calls must be reassigned.

## Context and Errors

- Bind request context before starting the transaction: `db.WithContext(ctx)`. Existing services often pass `*gin.Context`; prefer `c.Request.Context()` for new standard-`context.Context` boundaries without broad signature churn.
- Check `Begin().Error`, every operation's `.Error`, and commit/rollback outcomes under the repository's transaction helper.
- Handle `gorm.ErrRecordNotFound` according to current API semantics; this service often uses panic/string mapping.
- Use `RowsAffected` when correctness depends on matching or changing a row.

## Updates and Creates

- `Updates(struct)` omits zero values. For intentional `0`, `false`, `""`, or nulling, use an explicit column map, `Select(...).Updates(...)`, `Update`, or pointer patch fields after checking the local contract.
- Do not introduce `Save()` for partial updates; it can persist fields the caller did not intend to change.
- On create, check `.Error`, understand generated IDs, and inspect association behavior. Do not pass an object graph unless those associations should be persisted.

## Transactions

- The service owns transaction boundaries. Pass the exact `tx` to repositories; never fall back to the root DB inside the atomic flow.
- Return/propagate failures so rollback occurs. Keep transactions short and avoid file parsing or remote calls while locks are held.
- Do not add nested transactions or disable GORM transaction guarantees for theoretical speed.
- For read-modify-write quota/state changes, inspect concurrency requirements; use atomic SQL or locking only when business correctness requires it.

## Relations and Query Scope

- Prefer targeted `Joins` for filtering/projection and narrow `Preload` only for relations actually returned.
- Do not use `Preload(clause.Associations)` or deep preload trees by default.
- Treat DB calls inside loops as an N+1 warning; consider an `IN` query, batch operation, join, preload, or aggregation.
- Parameterize `Raw`, `Exec`, `Where`, and join values. Allowlist any dynamic identifier used by `Order`, `Select`, `Table`, or `Joins`.

No GORM lifecycle hooks or `clause.Locking` convention is clearly established. Search again before relying on either.

Read `.agent/GORM.md` and `.agent/GORM_BEST_PRACTICES.md` for repository details.
