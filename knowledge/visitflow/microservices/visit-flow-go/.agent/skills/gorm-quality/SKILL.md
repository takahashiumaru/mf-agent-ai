---
name: gorm-quality
description: Use when changing GORM models, repository implementations, CRUD, transactions, associations, Preload, Joins, hooks, or raw SQL.
---

# GORM Quality

## Outcome

Keep persistence behavior correct under Visit Flow's read/write resolver, transaction model, soft deletes, and partial-update semantics.

## Required Reading

Read `../../../AGENTS.md`, `../../GORM.md`, `../../GORM_BEST_PRACTICES.md`, and the affected repository. Load `../../DATABASE_PERFORMANCE.md` for significant queries.

## Workflow

1. Identify transaction ownership in the calling service.
2. Trace whether each operation must use `db.Read` or `db.Write`; use the write handle for read-your-writes.
3. Inspect model fields, GORM tags, associations, hooks, soft-delete behavior, and callers.
4. Decide not-found and zero-value semantics before selecting an API.
5. Review generated SQL and query count when performance matters.

## Rules

- Use the repository-established `DB.WithContext(c)` and `DatabaseResolver`; do not create a separate global DB path.
- Check every meaningful `.Error`. Map `gorm.ErrRecordNotFound` according to existing domain/error behavior.
- Operations in a transaction must use its handle. Do not silently use the root DB or a replica mid-transaction.
- Keep transactions short; avoid network calls inside them unless atomic business behavior requires it.
- Treat `Save` as a full persistence operation, not the default patch mechanism.
- Remember `Updates(struct)` skips zero values such as `0`, `false`, and `""`. Use `Select`, `Update`, a map, or pointer patch DTO when semantics require them.
- Inspect `RowsAffected` when a missing target or no-op write is semantically significant; `.Error == nil` alone does not prove a row changed.
- Load only required associations. Avoid `Preload(clause.Associations)` and unbounded nested preload trees.
- Treat database calls in loops as an N+1 warning; consider `IN`, batching, joins, preload, or aggregation without changing semantics.
- Understand automatic association persistence and inspect relevant lifecycle hooks before model changes.
- Parameterize values in `Raw`, `Exec`, `Where`, and joins. Dynamic identifiers require a closed allowlist.
- Select only needed columns for important queries, but do not micro-optimize trivial operations.
- Ordinary `Delete` is generally soft delete because models embed `gorm.Model`; `Unscoped()` requires explicit business intent.

## Repository Examples

- PREFERRED ONLY for its explicit assignment-map shape: `../../../repository/visit_repository_impl.go` `UpdateApproved`. Its identifier-only scope, missing `RowsAffected` check, and `db.Read` reload still require correction when relevant.
- PREFERRED: `../../../repository/visit_customer_repository_impl.go` `UpsertInBatches` uses `OnConflict` and batch-oriented persistence.
- ACCEPTABLE: `../../../repository/visit_product_repository_impl.go` `FindByVisit` preloads a required relation with selected columns.
- LEGACY — DO NOT COPY FOR NEW CODE: `../../../repository/visit_customer_repository_impl.go` `Update` uses `Save`; inspect full-field persistence before touching it.
- MIGRATE-WHEN-TOUCHED: read-after-write paths that read through `db.Read` may be stale under replica lag; use the transaction's write connection when consistency requires it.

## Verification

- Test success, not found, DB failure, rollback, and intentional zero-value updates.
- Confirm tenant/company/structure/period predicates are preserved.
- Review SQL, query count, association loading, and soft-delete predicates.
- Apply `../mysql-performance/SKILL.md` for a high-volume or suspected expensive query.

## Red Flags

- Ignored `.Error`; root DB used inside a transaction; `Save` on a partial object; `Updates(struct)` expected to write false/zero; request-driven SQL identifiers; queries in loops; casual `Unscoped()`.
