# Workflows

## Adding a New Local API Endpoint

1. Decide whether it belongs to the local identity API. If it only proxies a downstream service, use the gateway workflow instead.
2. Add/reuse DTOs in `model/web` with JSON and validation tags.
3. Add a method to the relevant service interface and controller interface.
4. Implement controller parsing and `web.WebResponse` output.
5. Implement validation and business logic in the service.
6. Add a repository interface/implementation method only if database access is required.
7. Register the method and explicit auth wrapper in `route/`.
8. Add focused tests and run the affected package plus `go test ./...`.

Use the roles flow as the preferred simple example: `route/role_route.go` -> `controller/role_controller_impl.go` -> `service/role_service_impl.go` -> `repository/role_repository_impl.go`.

For multipart user operations, follow `controller/users_controller_impl.go` and `service/user_service_impl.go`, including its current single-file behavior.

## Adding a Gateway Proxy Endpoint

1. Find the nearest endpoint for the same upstream in `configuration.json`.
2. Confirm public method/path, backend host/method/path, response encoding, forwarded headers, and query parameters.
3. Check whether a matching path conflicts with the local Gin listener; the listeners use different ports.
4. Validate the KrakenD configuration by building/running the application in an environment with its upstream network when available.
5. Do not add local layers for a pure proxy route.

## Adding a New Business Feature

Normally touch only the required vertical slice:

`model/web -> controller -> service -> repository interface/implementation -> model/domain (if persisted) -> route -> tests`

Keep gateway configuration separate unless the feature must also be publicly proxied. Preserve current API responses, authentication, transaction behavior, and persistence mapping unless the feature explicitly changes them.

## Adding a Repository Method

1. Add the interface method in the matching `repository/*_repository.go` file.
2. Implement it in `*_repository_impl.go`.
3. Use the database type already used by that repository: plain `*gorm.DB` for users/sessions, or `*goHelper.DatabaseResolver` for role-related repositories.
4. Use `db.Read` for reads and `db.Write` for writes when using the resolver.
5. Accept and use the transaction passed by the service; do not access a global DB.
6. Use bound query parameters and check `.Error`.
7. Decide intentionally between `First` (not-found error) and `Find` (zero/empty result).
8. Update all manual mocks and add a focused service/repository test.

## Adding a Database Column

The repository has no migration system. First locate and use the external schema owner. Then follow:

`external migration -> model/domain GORM field/tag -> raw/select/update queries -> model/web DTO if public -> To...Response mapping -> tests`

Check zero/null behavior, composite indexes, audit fields, soft deletion, and backward compatibility. Do not enable `AutoMigrate` as a substitute.

## Adding a New Table

1. Identify the external migration location/process.
2. Define keys, indexes, constraints, nullable fields, and audit/soft-delete behavior there.
3. Add the GORM struct in `model/domain` following nearby model conventions.
4. Add repository interface and implementation.
5. Add a service/controller/route only if locally exposed.
6. Add web DTOs rather than returning the GORM struct as a new contract.
7. Add mock-backed service tests and sqlmock/DryRun repository tests.

## Partial Update

`Updates(struct)` omits zero values. Use it only when omission is desired.

For explicit zero or SQL NULL updates, use a column map or an explicit `Update` call. The repository's concrete example is:

```go
db.Model(&domain.User{}).
    Where("id = ?", user.ID).
    Updates(map[string]interface{}{"telegram_id": nil})
```

Do not use `Save` for a partial update. If using an update map, allowlist columns in code rather than accepting arbitrary request keys.

## Transactional Operation

For a focused compatibility fix, existing manual begin/deferred recovery in user CRUD may remain, but it is LEGACY and must not be copied into new code. For a new multi-write atomic user/session flow, the preferred established example is callback-based `DB.Transaction` in login/refresh/logout:

1. Perform non-transactional CPU/external/read preparation only when consistency permits.
2. Call `service.DB.Transaction`.
3. Pass its `tx` to every write repository method.
4. Return the first error to roll back.
5. Check the error returned by `Transaction`.

- Existing role methods use the legacy resolver for compatibility; inspect its paired transaction lifecycle before extending it. New atomic flows should follow the scoped callback examples in PREFERRED_PATTERNS. All dependent response reads use the writer transaction.

Never open a new root transaction inside the callback or mix resolver/root handles. No nested-transaction convention is established.

## Fetching Relations

- For `Role` associations, follow `Joins("Role")` in role-menu/user-role repositories.
- For report projections, use explicit `Select`, `Table`, and `Joins` as in `UserAccessReport`.
- For complex structure hierarchy behavior, raw parameterized SQL is already isolated in `repository/users_repository_impl.go`.
- `Preload` is not used. Before introducing it, confirm that it will not create large payloads or additional query costs and that joins cannot follow the existing pattern.

## Not-Found Behavior

Choose based on the existing contract:

- Authentication lookups translate GORM not-found into unauthorized.
- Ordinary `First` errors panic and eventually map record-not-found to HTTP 200/success.
- `FindByIDNonFirst` uses `Find` and an `ID == 0` check for upsert-like behavior.
- Collections return empty slices.

Do not normalize these differences inside an unrelated feature.

## Bug Fix Workflow

1. Identify whether the failure is gateway, controller, service, repository, GORM/schema, or external-upstream behavior.
2. Inspect the closest relevant test.
3. Inspect the caller and callee, especially interface mocks.
4. Inspect transaction and zero-value behavior for database bugs.
5. Reproduce the root cause with a focused test.
6. Make the smallest change that fixes it.
7. Add/retain a regression test.
8. Run targeted tests, then `go test ./...`.

## Refactoring Workflow

Before refactoring, inspect:

- controller/service/repository interfaces,
- every route constructor/caller,
- handwritten mocks,
- transaction ownership and database-handle types,
- HTTP status/response compatibility,
- raw SQL and deployed schema assumptions,
- tests in the package and `test/`.

Do not combine architectural cleanup with a focused feature or fix unless explicitly requested.
