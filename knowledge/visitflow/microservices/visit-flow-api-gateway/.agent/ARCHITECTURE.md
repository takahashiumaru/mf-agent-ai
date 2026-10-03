# Architecture

## High-Level Architecture

The process contains two HTTP paths with different responsibilities.

Gateway path:

`HTTP -> KrakenD Gin router -> gateway middleware -> KrakenD proxy -> configured downstream service`

Local identity path:

`HTTP -> Gin middleware -> route/auth wrapper -> controller -> service -> repository -> GORM -> MySQL`

This is a manually layered codebase, but the layers are coupled to Gin and GORM in places. Do not label it Clean Architecture: service interfaces accept `*gin.Context`, and repository interfaces expose `*gorm.DB` or the go-helper database resolver.

## Layer Responsibilities

### `route`

- Registers local Gin paths and HTTP methods.
- Constructs repository, service, and controller instances manually.
- Applies `auth.Auth` to protected routes.
- Must not contain business rules or GORM queries.

Examples: `route/users_route.go`, `route/role_route.go`.

### `controller`

- Reads path/query/form/body input from `*gin.Context`.
- Calls a service interface.
- Produces `model/web.WebResponse` or raw file bytes.
- Uses helpers for pagination, filters, JSON decode, and panicking on parse errors.
- Must not query GORM directly.

Examples: `controller/role_controller_impl.go`, `controller/users_controller_impl.go`.

### `service`

- Validates DTOs with `validator.Validate`.
- Applies business/authentication rules.
- Builds `model/domain` values and maps them to web responses.
- Usually opens and closes transactions.
- May orchestrate several repository operations atomically.
- In existing role modules, also annotates the request trace with `goHelper.SignozSpan`.

Examples: `service/user_service_impl.go`, `service/role_service_impl.go`.

### `repository`

- Defines interfaces beside their implementations in the same package.
- Executes GORM queries and raw SQL.
- Receives its database/transaction dependency per method; repository structs are stateless.
- Typically calls `PanicIfError` rather than returning errors. A few user lookup methods return an error or translate not-found into `exception.ErrUnauthorized`.
- Must not build HTTP responses.

Examples: `repository/users_repository_impl.go`, `repository/role_repository_impl.go`.

### `model/domain`

- Contains the GORM-backed persistence structs.
- Contains collection aliases and `To...Response` mapping methods.
- Despite the package name, these are not persistence-independent domain entities.

### `model/web`

- Contains request DTOs, response DTOs, validation tags, and the shared response envelope.
- Must not be used as the primary persistence model, although raw join projections use `web.UserFindResponse` and `web.UserRoleJoinResponse` directly.

### `auth`, `exception`, `helper`, `config`, `configuration`

- `auth`: token creation/parsing, database-backed token revocation check, and Gin auth wrapper.
- `exception`: sentinel/custom errors and centralized panic-to-response mapping.
- `helper`: cross-cutting filter, transaction, file, JSON, blocking, notification, and error utilities.
- `config`: GORM/MySQL construction.
- `configuration`: `.env`/Viper loading.

## Dependency Direction

The local API normally depends in this direction:

- `route` -> `controller`, `service`, `repository`, `auth`
- `controller` -> service interfaces, `model/web`, HTTP helpers, `auth.AccessDetails`
- `service` -> repository interfaces, `model/domain`, `model/web`, `auth`, helpers, Gin/GORM/validator
- `repository` -> `model/domain`, selected `model/web` projections, GORM, helpers
- `model/domain` -> `model/web` for mapping

The `model/domain -> model/web` dependency means mapping is owned by the persistence/domain struct, not a separate mapper package.

## Dependency Injection

Dependency injection is manual. Each function in `route/` calls `New...Repository`, then `New...Service`, then `New...Controller`. Constructors return their interface type in most cases. There is no Wire, Fx, or generated DI code.

`main.go` passes the same root `*gorm.DB` and `*validator.Validate` into all route builders. It also stores a database pointer globally through `auth.SetDB` for token-revocation checks.

## Request Lifecycle

Representative local role creation (`POST /roles`):

1. `route/role_route.go` applies `auth.Auth` and invokes `RoleControllerImpl.Create`.
2. `auth.Auth` extracts and verifies the JWT, including the database token check, then passes `*auth.AccessDetails` to the controller. The requested role list is currently not enforced.
3. `controller/role_controller_impl.go` decodes `web.RoleCreateRequest` and calls `RoleService.Create`.
4. `service/role_service_impl.go` validates the request, creates a read/write transaction resolver, and defers commit/rollback of the write transaction.
5. `repository/role_repository_impl.go` calls `db.Write.Create` for `domain.Role`.
6. `domain.Role.ToRoleResponse` maps the persisted struct into the response DTO.
7. The controller returns HTTP 200 with `web.WebResponse`.

Representative proxy request:

1. KrakenD parses `configuration.json` during startup.
2. The KrakenD Gin engine applies CORS, secure headers, rate limiting, and `GatewayAuthMiddleware`.
3. Requests with no Authorization header continue; requests with a header must pass token verification/revocation checks.
4. KrakenD forwards to the endpoint's configured backend host/path.

## Transaction Ownership

Services normally own transactions. Two patterns coexist:

- User CRUD: `service/user_service_impl.go` calls `service.DB.Begin()` and defers local `helper.CommitOrRollback(tx)`.
- Role/permission assignments: services call `goHelper.CreateTransaction(service.DB, c)`, receiving separate `Read` and `Write` transactions bound to `c.Request.Context()`, then defer `goHelper.CommitOrRollback` on the used handle.
- Atomic authentication operations: login, logout/token clearing, and refresh rotation use `service.DB.Transaction(func(tx *gorm.DB) error { ... })`.

Do not mix handles from different transactions inside one operation. `goHelper.CreateTransaction` begins both a read and a write transaction, while current services defer completion only for the handle they use; inspect this dependency behavior before extending resolver-based flows. Several older role methods also create an initial `tx := service.DB.Begin()` only to check `tx.Error`, then create a separate resolver transaction; this is existing behavior, not a pattern to copy into new code.

## Shared Infrastructure

- Logging: standard `log`, `fmt` debug output, GORM's logger, and KrakenD's logger coexist.
- Middleware: CORS, secure headers, rate limiting, optional gateway token validation, local IP blocking, and panic recovery are assembled in `main.go`.
- Authentication: HMAC JWT plus an access-token equality check against `users.access_token`.
- Authorization: route declarations pass role names, but the role check in `auth.Auth` is commented out.
- Tracing: role-related services call `goHelper.SignozSpan`; no local tracer setup was found.
- Cache: none found.
- Concurrency: `main.go` starts the local identity server in a goroutine; login runs two independent structure queries concurrently; notification sends are fire-and-forget goroutines.
