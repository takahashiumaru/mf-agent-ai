# Payroll Preferred Patterns

Follow [AGENTS](../AGENTS.md) for mandatory rules and [QUALITY_GATES](QUALITY_GATES.md) for completion. Keep pure validation/calculation/mapping separate from I/O when this improves the affected code; avoid trivial wrappers and broad frameworks.

## File and external-I/O decisions

Separate path/period parsing and response mapping from filesystem, mailbox and notification operations. Use dependency seams only where they enable deterministic tests. Preserve PDF bytes versus JSON responses and existing error boundaries. Do not invent SQL transaction guarantees for file/email work.

## Scoped source examples

- Startup/wiring: `main.go`, `app/router.go`, `route/payroll_route.go`.
- Requests/output: `controller/payroll_controller_impl.go`, `model/web/`.
- PDF/search/count/ingest/OTP: `service/payroll_service_impl.go`; path/period construction: `helper/path_payroll.go`.
- Auth: `auth/auth.go`; distinguish wrapped routes from unwrapped ingest/OTP routes.
- Existing tests: `helper/operator_test.go`, `helper/model_test.go`; no service/controller test harness was identified.

See [TESTING](TESTING.md) for what mocks can and cannot establish. No example is blanket approval of its auth, deletion, context or transaction behavior.
