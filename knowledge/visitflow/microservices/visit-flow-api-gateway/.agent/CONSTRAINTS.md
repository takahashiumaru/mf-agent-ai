# Constraints

## MUST

- Determine whether a task targets KrakenD proxy configuration or the local Gin identity API before editing.
- Keep local HTTP parsing in controllers, business/authentication orchestration in services, and database access in repositories.
- Use the transaction supplied by the service for every repository call in that operation.
- Check every GORM operation's `.Error` or deliberately return it to the caller.
- Preserve intentional error identity for `exception.ErrUnauthorized`, `ErrRefreshTokenExpired`, and `ErrPermissionDenied`.
- Validate request DTOs in the same service-level manner as neighboring code.
- Hash new passwords with bcrypt; never persist or log plaintext passwords.
- Parameterize dynamic SQL values.
- Preserve the established `web.WebResponse` envelope for local JSON endpoints.
- Treat environment files, JWT secrets, database credentials, SMTP credentials, Firebase credentials, and tokens as secrets.
- Inspect usages, mocks, and tests before changing an interface.

## MUST NOT

- Do not modify unrelated modules or perform broad refactoring for a small task.
- Do not move business logic into handlers/controllers.
- Do not bypass repository abstractions unless the existing affected flow explicitly does so.
- Do not invent a separate persistence model inside a focused change; current `model/domain` structs are GORM models.
- Do not expose GORM structs directly as new HTTP contracts; use or add `model/web` DTOs and mapping consistent with the module.
- Do not silently change transaction boundaries or mix root DB calls with a transaction inside an atomic operation.
- Do not use `Save` for partial updates; it is not an established repository pattern.
- Do not expect `Updates(struct)` to persist zero values. Use a map or explicit column update when zero/NULL is intended.
- Do not ignore GORM errors.
- Do not put user input into raw SQL through string concatenation.
- Do not use `Unscoped()` unless hard deletion is an explicit domain requirement; current intentional uses revoke session rows.
- Do not enable `AutoMigrate` at startup.
- Do not create a destructive migration without an explicit requirement. This repository has no established migration mechanism.
- Do not remove validation to make tests pass.
- Do not silently enable or claim role authorization. The check in `auth.Auth` is currently disabled.
- Do not edit generated code manually. No generated files were detected; re-check if new tooling is introduced.
- Do not expose secrets or copy real local secret values into docs/tests.

## SHOULD

- Prefer minimal, focused changes.
- Follow the transaction pattern of the affected module.
- Use `DB.Transaction` for new multi-write atomic workflows when it matches the user authentication flows and no resolver requirement applies.
- Use allowed filter names at the controller boundary and bound values in repositories.
- Return empty response slices through existing conversion methods.
- Add focused regression tests and run the affected package before `go test ./...`.
- Preserve response messages/status codes unless the requested behavior includes an API contract change.

## INVESTIGATE FIRST

- Changes to `main.go`: it controls two servers, shared middleware, two DB connections, and global token verification state.
- Changes to `configuration.json`: it is a large external API contract spanning multiple upstream services.
- Changes to `auth/auth.go`: JWT claims, access-token revocation, and route wrappers depend on it.
- Changes to `service/user_service_impl.go`: it owns login concurrency, password hashing, session rotation, token persistence, and notifications.
- Changes to user/session transactions: refresh-token consumption must remain atomic to prevent replay.
- Changes to resolver-based transactions or generic filters: current helper patterns have unresolved sibling transactions and discarded chain results; inspect the dependency and generated SQL first.
- Changes to soft deletion or primary keys in `model/domain`: GORM behavior and external schema assumptions are embedded there.
- Changes to repository interfaces: manual mocks in `test/` must be updated.
- Schema changes: no schema source of truth is present locally; identify the external database/migration owner first.
- Authorization changes: some routes are intentionally unauthenticated and role enforcement is commented out. Confirm desired behavior explicitly.
- File and notification changes: check path safety, request size/type validation, credential handling, goroutine lifetime, and error visibility.
