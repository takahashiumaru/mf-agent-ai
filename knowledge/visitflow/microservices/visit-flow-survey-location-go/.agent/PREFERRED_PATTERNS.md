# Survey Preferred Patterns

Follow [AGENTS](../AGENTS.md) for mandatory rules and [QUALITY_GATES](QUALITY_GATES.md) for completion. Keep pure validation/calculation/mapping separate from I/O when this improves the affected code; avoid trivial wrappers and broad frameworks.

## Error and transaction decisions

- Preserve the affected public error/status contract. New internal error-returning functions must be handled at the caller; keep existing panic-driven rollback boundaries until an explicit end-to-end migration.
- Services own transaction scope. Repositories reuse the supplied handle. Dependent response reads must see the writes in that same transaction; an independent reader can be stale.
- Treat separate read/write resolver finalization as a legacy concern to investigate. Do not copy it into new infrastructure or replace a working flow incidentally.
- Check zero/false/empty/null updates deliberately. Guard ownership, status transitions, retries and affected rows where correctness depends on them.
- Examples endorse only the stated technique. Existing tests may characterize a defect; passing them does not make that behavior preferred.

## Scoped source examples

- CRUD wiring: `route/distributor_route.go` through `repository/distributor_repository_impl.go`.
- Survey aggregate: `route/outlet_survey_route.go`, `controller/outlet_survey_controller_impl.go`, `service/outlet_survey_service_impl.go`, `repository/outlet_survey_repository_impl.go`.
- Customer-product repository files use the same `outlet_survey_customer_product` naming as route/controller/service; report SQL may still reference the legacy `customer_materials` table.
- Reports: `FindDataReport` in `repository/outlet_survey_repository_impl.go`.
- Tests: `test/service_test.go`, `test/repository_test.go`, `test/controller_test.go`, `test/router_test.go`, `test/test_db_helper_test.go`.

See [TESTING](TESTING.md) for what mocks can and cannot establish. No example is blanket approval of its auth, deletion, context or transaction behavior.
