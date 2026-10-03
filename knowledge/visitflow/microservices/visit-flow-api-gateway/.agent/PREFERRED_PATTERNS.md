# Gateway Preferred Patterns

Follow [AGENTS](../AGENTS.md) for mandatory rules and [QUALITY_GATES](QUALITY_GATES.md) for completion. Keep pure validation/calculation/mapping separate from I/O when this improves the affected code; avoid trivial wrappers and broad frameworks.

## Error and transaction decisions

- Preserve the affected public error/status contract. New internal error-returning functions must be handled at the caller; keep existing panic-driven rollback boundaries until an explicit end-to-end migration.
- Services own transaction scope. Repositories reuse the supplied handle. Dependent response reads must see the writes in that same transaction; an independent reader can be stale.
- Treat separate read/write resolver finalization as a legacy concern to investigate. Do not copy it into new infrastructure or replace a working flow incidentally.
- Check zero/false/empty/null updates deliberately. Guard ownership, status transitions, retries and affected rows where correctness depends on them.
- Examples endorse only the stated technique. Existing tests may characterize a defect; passing them does not make that behavior preferred.

## Scoped source examples

- Proxy routes: `configuration.json`; inspect only relevant method/path/upstream metadata, without exposing credentials. Local Gin assembly: `main.go`, then `route/users_route.go`.
- Identity/session workflow: `service/user_service_impl.go`; callback login/refresh transactions are scoped examples, not approval of every legacy method.
- Writer reload: `repository/role_repository_impl.go`; resolver lifecycle still requires inspection.
- Regression tests: `test/session_refresh_coverage_test.go`, `test/user_service_test.go`, `main_coverage_test.go`.

See [TESTING](TESTING.md) for what mocks can and cannot establish. No example is blanket approval of its auth, deletion, context or transaction behavior.
