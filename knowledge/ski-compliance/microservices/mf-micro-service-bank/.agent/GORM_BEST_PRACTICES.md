# GORM best practices

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

The module uses GORM's traditional API; check the exact version in `go.mod` and `.agent/PROJECT.md`.

## Context and errors

- **MUST** inspect `Error` after finisher methods and relevant `RowsAffected` when write outcome matters.
- Map `gorm.ErrRecordNotFound` to the endpoint/domain contract; it is not automatically an infrastructure failure.
- Use `db.WithContext(ctx)` when request context reaches the persistence layer. Broad propagation is a migration here.
- Official references: https://gorm.io/docs/error_handling.html and https://gorm.io/docs/context.html

## Create and update

- Check create errors and generated-key/audit effects.
- Traditional `Updates(struct)` omits zero-valued fields by default. Use a specific map or `Select` for approved fields when `0`, `false`, or `""` must persist.
- Avoid `Save` for partial/user-controlled updates; it writes all fields and may fall back to create when no rows update.
- Whitelist writable columns. Check predicates, errors, and `RowsAffected` against the contract.
- Existing code in `repository/account_repository_impl.go` is evidence, not a blanket recommendation.
- Official reference: https://gorm.io/docs/update.html

## Delete and soft delete

- Preserve model soft-delete/audit semantics after checking tags and hooks.
- `Unscoped().Delete` appears in `repository/account_repository_impl.go` and may physically delete when the model supports soft deletion. Do not copy without explicit retention/compatibility evidence.
- Separate deletion from business-state transitions; require explicit policy for hard delete.
- Official reference: https://gorm.io/docs/delete.html

## Transactions

- Service flows use `Begin` or resolver write handles with `helper.CommitOrRollback`; see `helper/tx.go` and [TECH_DEBT.md](TECH_DEBT.md).
- Use one owner and pass the same transaction handle to every participating repository. Never fall back to the base DB inside a transaction.
- Test begin/commit/rollback failures; keep external I/O outside held locks where consistency permits.
- Separate database transactions are not distributed atomic transactions; verify failure/reconciliation behavior.
- Official reference: https://gorm.io/docs/transactions.html

## Reads and advanced behavior

- Bound list queries and keep ordering stable when the API contract allows.
- Choose `Preload`, joins, batching, and projections based on association semantics and query evidence.
- Parameterize values; allowlist SQL identifiers and sort directions.
- Inspect raw SQL, hooks, scopes, association writes, upserts, locks, batching, and soft-delete behavior individually.
