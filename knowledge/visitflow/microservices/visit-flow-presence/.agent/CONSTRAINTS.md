# Constraints

## MUST

- Keep changes scoped to the requested module and preserve the controller/service/repository separation.
- Pass context-bound or transactional DB handles through repository calls.
- Check GORM `.Error` and preserve panic/error mapping behavior.
- Validate request DTOs where the corresponding service pattern validates them.
- Preserve company/user/structure scoping present in the affected query or workflow.
- Inspect all callers, mocks, and tests before changing an interface.
- Preserve response envelope fields and established HTTP status behavior.
- Treat status strings, table names, stored procedure names, filter keys, and the `qouta` spelling as compatibility-sensitive.
- Parameterize Raw/Exec/Where values.
- Protect configuration, JWT secrets, database DSNs, Firebase credentials, and tokens.
- Modify source definitions rather than generated outputs if generated code is introduced later. No generated Go files are currently established.

## MUST NOT

- Do not modify unrelated modules or perform broad refactoring for a small task.
- Do not move business logic into controllers.
- Do not bypass repository interfaces unless the existing affected architecture explicitly does so.
- Do not return GORM domain structs directly from HTTP controllers; use `model/web` responses.
- Do not introduce a separate persistence model layer as an incidental change; this repository intentionally uses domain structs as GORM models.
- Do not change public interfaces without checking routes, implementations, mocks, and tests.
- Do not introduce a dependency when Gin/GORM/validator/go-helper or another existing solution already covers the need.
- Do not silently change status transitions, quota calculations, tenant filtering, or approval routing.
- Do not remove validation to make tests pass.
- Do not change transaction boundaries casually or use the root DB inside an existing transaction.
- Do not ignore GORM errors.
- Do not use request/user input in SQL through string concatenation.
- Do not use `Unscoped()` without confirming hard deletion is the intended module behavior.
- Do not add `Save()` for partial updates; it is not an established repository pattern.
- Do not expose secrets or commit new credential material.
- Do not edit generated code manually.
- Do not make destructive schema changes without an explicit requirement and an identified deployment/migration process.
- Do not enable `AutoMigrate` models at startup as a substitute for an absent migration plan.
- Do not assume role arrays passed to `auth.Auth` are enforced; the check is currently commented out.

## SHOULD

- Prefer minimal, focused changes and the closest working module as a template.
- Use `WithContext(c)` or the existing `goHelper.CreateTransaction` flow.
- Use explicit pointers/maps/`Select` when an update must persist zero values; first inspect local tests and repository behavior.
- Add regression tests near the affected layer.
- Return empty list DTOs rather than nil where conversion helpers already do so.
- Keep SQL-heavy report logic in repositories and cover important SQL shape with `go-sqlmock`.
- Use `helper.RunAsyncNotification` for new detached notification work when consistent with the affected flow.

## INVESTIGATE FIRST

- Schema/table/index changes: no migration source of truth exists in this repository.
- Authentication/authorization changes: JWT parsing is local, but role enforcement is disabled and claims come from another service.
- Tenant/company filtering: application is multi-company, but filtering is not uniform across repositories.
- Leave and attendance-correction workflows: they coordinate local and external approvals, notifications, and quotas.
- Read/write transaction changes: `go-helper.DatabaseResolver` opens distinct read and write transactions; verify external repository expectations.
- Delete changes: modules mix GORM soft delete and `Unscoped` hard delete.
- Shared model changes: several domain models embed types from private external modules.
- Report query changes: presence/leave reports use MySQL-specific functions, force indexes, scan structs, and stored procedures.
- File upload changes: leave proof files are local and currently limited to 1 MiB in service logic.
