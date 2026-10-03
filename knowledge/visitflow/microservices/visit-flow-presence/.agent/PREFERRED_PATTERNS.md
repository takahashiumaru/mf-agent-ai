# Presence Preferred Patterns

Follow [AGENTS](../AGENTS.md) for mandatory rules and [QUALITY_GATES](QUALITY_GATES.md) for completion. Keep pure validation/calculation/mapping separate from I/O when this improves the affected code; avoid trivial wrappers and broad frameworks.

## Error and transaction decisions

- Preserve the affected public error/status contract. New internal error-returning functions must be handled at the caller; keep existing panic-driven rollback boundaries until an explicit end-to-end migration.
- Services own transaction scope. Repositories reuse the supplied handle. Dependent response reads must see the writes in that same transaction; an independent reader can be stale.
- Resolver-based write flows use `service/transaction.go` to share a writer transaction across dependent reads and writes. Preserve the caller's handle and finalization; do not create another resolver lifecycle in a service or repository.
- Check zero/false/empty/null updates deliberately. Guard ownership, status transitions, retries and affected rows where correctness depends on them.
- Examples endorse only the stated technique. Existing tests may characterize a defect; passing them does not make that behavior preferred.

## Package and dependency decisions

- Keep business orchestration in `service`; split workflow declarations into focused files before splitting packages.
- Let `route/` construct concrete implementations and inject only dependencies a service uses.
- Put isolated external transport/parsing in `internal/` when it has a clear boundary. Keep business fallback and merge rules in the owning service.
- Add consumer-owned narrow interfaces or function dependencies only for an actual substitution seam. Do not introduce general-purpose interfaces, base services, or a DI framework for consistency alone.

## Scoped source examples

- CRUD wiring: `route/office_route.go` through `repository/office_repository_impl.go`.
- Attendance/check-out/Pondasi: `service/presence_service_impl.go`, `repository/presence_repository_impl.go`.
- HRD quota approval: `service/leave_hrd.go`, `service/leave_quota_allocation.go`; preserve the shared writer transaction and scoped locks.
- SQL tests: `test/repository_mock_db_test.go`, `test/presence_repository_coverage_test.go`. JSON/service tests: `test/presence_workflow_test.go`, `test/leave_hrd_integrity_test.go`.

See [TESTING](TESTING.md) for what mocks can and cannot establish. No example is blanket approval of its auth, deletion, context or transaction behavior.
