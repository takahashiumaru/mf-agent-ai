# GORM practices observed

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

- Initialization is centralized in `app/database.go`; version is `v1.25.2` (`go.mod`).
- Repository implementations live in `repository/*_repository_impl.go`; inspect both interface and implementation before changing a query.
- Model tags and custom table names are the authority for mapping, not Go type names alone.
- Transaction helper code exists at `helper/tx.go`; actual transaction ownership varies by call path and must be verified before moving writes.
- Update zero-value behavior, delete scope, association/preload/join choices, raw SQL, locking, and batching are query-specific. Inspect the exact method and its tests; a global policy is Not clearly established in the current repository.
- Check `RowsAffected` and GORM errors where the existing operation does so. Do not silently change not-found or duplicate behavior.
