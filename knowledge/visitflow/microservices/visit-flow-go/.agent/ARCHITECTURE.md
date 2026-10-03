# Architecture

## High-Level Architecture

The repository uses a conventional layered package layout with manual composition:

```text
HTTP request
  -> Gin engine and global middleware (`app/router.go`)
  -> per-module route and `auth.Auth` wrapper (`route/`)
  -> controller interface/implementation (`controller/`)
  -> service interface/implementation (`service/`)
  -> repository interface/implementation (`repository/`)
  -> GORM domain model and MySQL (`model/domain/`)
  -> web response DTO (`model/web/`)
```

It resembles layered architecture, but it is not strict Clean Architecture: services accept `*gin.Context`, domain models import web DTOs for mapping, and some services instantiate repository implementations directly.

## Layer Responsibilities

### `route/`

- Constructs dependencies with `New...Repository`, `New...Service`, and `New...Controller`.
- Registers HTTP methods/paths and wraps most handlers with `auth.Auth`.
- May inject repositories from external private modules.
- Should not contain business rules or GORM queries.

### `controller/`

- Defines controller interfaces separately from `*_impl.go` implementations.
- Reads path/query/body/multipart input, obtains pagination, calls one service method, and creates `web.WebResponse`.
- Should not query GORM directly or decide business transitions.
- A few proxy controllers/services return `gin.H` directly; copy the nearest module rather than forcing uniformity.

### `service/`

- Defines service interfaces and implementations.
- Validates request structs, owns normal transaction setup, orchestrates repositories/external systems, and implements business/authorization rules.
- Often starts OpenTelemetry spans with `goHelper.SignozSpan`.
- Some complex services instantiate additional concrete repositories locally; this is existing legacy coupling, not a preferred reason to bypass injected interfaces in new code.

### `repository/`

- Defines interfaces in `*_repository.go` and stateless implementations in `*_repository_impl.go`.
- Owns GORM queries, joins, stored procedure calls, upserts, batch operations, and soft/hard deletion mechanics.
- Receives `*goHelper.DatabaseResolver` rather than retaining a global `*gorm.DB`.
- Most errors are sent upward by panic via `helper.PanicIfError`; newer estimation repositories sometimes return `error` explicitly.

### `model/domain/`

- Contains the structs used directly by GORM, including tags, associations, timestamps, and table overrides.
- Also contains slice aliases and `To...Response` methods. There is no separate persistence/entity mapping layer.
- Some query-only projection structs live here as well.

### `model/web/`

- Contains JSON request/response DTOs, validation tags, and the common response envelope.
- DTO names normally end in `CreateRequest`, `UpdateRequest`, or `Response`.

### `helper/`, `auth/`, `app/`

- `helper/`: shared filtering, errors, file and notification utilities, constants.
- `auth/`: validates HMAC JWTs and builds `AccessDetails`.
- `app/`: database and router bootstrap.

## Dependency Direction

The normal direction is route -> controller -> service -> repository -> model. Controllers depend on service interfaces; services depend on repository interfaces; repository implementations depend on domain models and GORM.

Known cross-layer exceptions:

- `model/domain` imports `model/web` for response mapping.
- Services use Gin contexts and occasionally construct concrete repository implementations.
- `service/google_maps_service_impl.go` writes HTTP responses directly.
- Some repository methods return `model/web` projections.

Preserve these facts when making focused changes; do not perform architectural cleanup incidentally.

## Dependency Injection

Dependency injection is manual in every `route/*_route.go`. For example, `route/company_route.go` creates a repository, passes it with `*gorm.DB` and validator to the service, then passes the service to the controller. There is no Wire, Fx, or generated container.

`app/router.go` is the top-level registry. A new route module must be called there.

## Representative Request Lifecycle

For `POST /companies`:

1. `route/company_route.go` registers `auth.Auth(companyController.Create, ...)`.
2. `auth/auth.go` validates the JWT, fills `AccessDetails`, and invokes the controller.
3. `controller/company_controller_impl.go` decodes `web.CompanyCreateRequest`.
4. `service/company_service_impl.go` validates the DTO, opens the resolver transaction, fills audit fields, and calls the repository.
5. `repository/company_repository_impl.go` calls `db.Write.Create` on `domain.Company`.
6. `model/domain/company.go` maps the model to `web.CompanyResponse`.
7. The controller returns a `web.WebResponse` JSON envelope.

## Transaction Ownership

Services normally call:

```go
tx := goHelper.CreateTransaction(service.DB.WithContext(c), c)
tx.Read = tx.Read.WithContext(c)
tx.Write = tx.Write.WithContext(c)
defer goHelper.CommitOrRollback(tx.Write)
```

The external helper begins separate read and write transactions using GORM `dbresolver`. Only the write handle is passed to the deferred commit/rollback helper in the repeated pattern. Repositories use the passed resolver. `service/call_target_service_impl.go` is a legacy exception using manual `Begin`/`Rollback`/`Commit`.

Panics cause the deferred write helper to roll back and re-panic. Do not casually add manual commits inside this pattern; a few existing long flows do so and then replace the resolver, which must be inspected locally.

The finalization of the separately begun read transaction is not visible in the repository or `go-helper` v0.5.9 implementation. Treat this as a known unresolved behavior, not a pattern to redesign incidentally.

## Shared Infrastructure

- Logging/recovery: `gitlab.com/VNEU/logger` middleware in `app/router.go`.
- Tracing: `goHelper.InitTracer`, `otelgin.Middleware`, and `otelgorm.NewPlugin`.
- Authentication: local JWT middleware in `auth/auth.go`.
- Authorization/tenancy: service/repository filtering using `AccessDetails`; the `roles` argument in `auth.Auth` is currently not enforced because the permission check is commented out.
- Configuration: `go-helper` Viper/godotenv loader.
- Notifications: Firebase calls, commonly launched as fire-and-forget goroutines from services.
- Cache/metrics/message broker: not clearly established in the current repository.
