# Constraints

## MUST

- Preserve the route -> controller -> service -> repository division for normal modules.
- Pass request/tenant identity (`company_id`, `structure_id`, subordinate scope, period) through all relevant queries.
- Use the service-owned `DatabaseResolver` and its `Read`/`Write` handles for repository operations.
- Check every GORM result error or explicitly return it where the local interface does so.
- Preserve zero-value intent in updates; use an explicit map/`Select` when false, zero, empty, or nil must be persisted.
- Inspect status/approval/config logic and callers before changing visit, customer-location, or master-customer-list flows.
- Keep raw SQL values parameterized.
- Modify interface, implementation, route wiring, handwritten mocks, and tests together when a contract changes.
- Treat `configuration/.env`, JWT secrets, database DSNs, Firebase credentials, and API keys as sensitive.
- Use the nearest module's response/status-code convention unless an API contract explicitly changes it.

## MUST NOT

- Do not modify unrelated modules or perform a broad refactor for a small task.
- Do not move business logic into controllers.
- Do not query a new global `*gorm.DB` from controllers or bypass repositories when the module already has one.
- Do not introduce a separate domain/persistence mapping architecture in a focused change; current domain structs are GORM models.
- Do not change public interfaces without checking all callers, route constructors, and `test/mocks_test.go`.
- Do not replace panic/recovery error propagation piecemeal.
- Do not ignore GORM errors.
- Do not use user input in raw SQL through string concatenation. Controller filter allowlists are part of the safety boundary.
- Do not add `Unscoped()` or hard deletes without an explicit lifecycle requirement.
- Do not change transaction boundaries casually or add nested/manual transactions inside the standard resolver flow.
- Do not remove validation to make tests pass.
- Do not silently change status transitions, approval sequences, tenant filters, or date/time offsets.
- Do not manually edit generated code. None is currently detected; if generated artifacts appear, find their source and command.
- Do not enable/add production `AutoMigrate` models or destructive migration operations without an explicit, verified schema plan.
- Do not expose or commit secret values. A credential-bearing JSON file and an in-source API key already exist; do not duplicate their contents in docs/logs/tests.
- Do not commit runtime/debug artifacts such as `bin/`, `coverage.out`, or `__debug_bin*`.

## SHOULD

- Prefer minimal, focused changes and existing constructors/interfaces.
- Inspect one simple and one complex sibling implementation when behavior crosses layers.
- Use `db.Read` for reads and `db.Write` for writes.
- Forward the existing Gin/request context into database and external calls.
- Use explicit DTOs and `To...Response` mappers rather than serializing a GORM model directly.
- Add focused regression tests, run the affected package, then run `go test ./...` when practical.
- Keep empty-list response behavior consistent with the existing mapper.
- Log asynchronous notification failures; do not let goroutine panics escape.

## INVESTIGATE FIRST

- Schema/table/index changes: no migration directory or command establishes the source of truth.
- Changes to `go-helper` transaction behavior: read and write transactions are created separately and only the write handle is routinely finalized here.
- Any use of `Unscoped`, stored procedures, cross-schema SQL, or bulk period deletion.
- Changes to `auth.Auth`: role enforcement is currently commented out and IP bypass behavior exists.
- Visit lifecycle or approval state changes: some transitions are data-driven through `confirmation_statuses`.
- Date/time calculations: visit flows deliberately add/subtract seven hours in several places.
- File upload/removal and runtime directories under `file/`.
- Changes to Firebase goroutines or code that passes Gin contexts across goroutine lifetimes.
- External private-module models/repositories from API Gateway and Survey Location.
- Legacy methods that manually commit and recreate transactions mid-service.
