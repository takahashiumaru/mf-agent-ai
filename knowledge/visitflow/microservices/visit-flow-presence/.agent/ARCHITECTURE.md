# Architecture

## High-Level Architecture

The repository uses a manually wired, layer-oriented structure:

`HTTP → Gin router/middleware → controller interface/implementation → service interface/implementation → repository interface/implementation → GORM/MySQL`

It resembles a conventional controller/service/repository architecture, but the domain structs are also persistence models and services know about GORM transaction objects. Do not label it strict Clean Architecture.

## Layer Responsibilities

### `route/`

- Creates concrete repositories, services, and controllers with `NewXxx` constructors.
- Registers HTTP methods/paths and wraps most handlers with `auth.Auth`.
- May inject repositories from shared Visit Flow modules.
- Should not contain request parsing, business rules, or queries.

### `controller/`

- Implements controller interfaces defined in sibling non-`_impl.go` files.
- Parses path/query/body/multipart input, obtains pagination, invokes services, and writes `web.WebResponse` via `c.JSON`.
- Relies on panics for error propagation to `app.ErrorHandler`.
- Should not issue GORM queries or own transaction boundaries.

### `service/`

- Implements service interfaces, validates DTOs, enforces business rules/status transitions, constructs domain models, maps them to web responses, coordinates shared-module repositories, files, and notifications.
- Owns transaction creation in established flows.
- Owns business decisions around shared helpers: CSV assignment mapping, office selection, notification timing, and transaction orchestration.
- Receives `*gorm.DB` and `*validator.Validate` through constructors.
- Should not write HTTP responses.

### `repository/`

- Interfaces live in `repository/<module>_repository.go`; implementations in `<module>_repository_impl.go`.
- Receives a `*gorm.DB` or shared `*goHelper.DatabaseResolver` per call.
- Builds GORM/SQL queries and panics on query errors through `helper.PanicIfError`.
- Returns `model/domain` values and does not produce HTTP DTOs.

### `model/domain/`

- Combines business records and GORM persistence models. GORM tags, associations, table overrides, and `ToXResponse` mapping methods are here.
- Some report structs are scan targets rather than writable tables.
- Depends on `model/web`, so mapping direction is `GORM/domain model → web response` inside this package.

### `model/web/`

- API request/response shapes and JSON/validation tags.
- Has no GORM queries.

### Shared support

- `auth/`: parses HMAC JWT claims into `auth.AccessDetails` and adapts a two-argument authenticated controller to Gin.
- `exception/`: maps recovered panics to JSON responses.
- `helper/`: reused generic mechanisms such as CSV row iteration, distance math, nil-token conversion, filtering, transaction finalization, logging, notification transport, and filesystem work. It does not import `service`, `auth`, `model/domain`, or `model/web`.

## Dependency Direction

Typical local direction is `route → controller → service → repository → model/domain`; controllers/services also use `model/web` and `helper`. `model/domain` maps into `model/web`, so domain does not form an independent inner core. Complex services/repositories import the external API-gateway and Visit Flow shared modules.

Shared mechanism calls flow `service → helper`; business policy and transaction ownership remain in `service`.

Do not introduce reverse calls such as repositories invoking services or controllers invoking repositories unless an existing module explicitly demonstrates it.

## Dependency Injection

Dependency injection is manual. `app.NewRouter` calls each `route.XRoute`; each route constructs repositories, passes them with DB/validator to a service constructor, then passes the service to a controller constructor. See `route/office_route.go` for the smallest example and `route/attendance_correction_route.go` for a multi-repository example. No Wire/Fx container or generated DI code is present.

Keep service orchestration in the existing `service` package and group files by workflow responsibility. Routes are the composition root: pass each service only the dependencies it uses. Define a small consumer interface or function dependency when a real substitution seam needs it; avoid generic repositories and interfaces added only for symmetry. Pondasi HTTP/parsing lives in `internal/pondasi`; presence-specific ERP merge and fallback rules remain in `service`.

## Request Lifecycle: Create Office

1. `app/router.go` calls `route.OfficeRoute`.
2. `route/office_route.go` registers `POST /offices` through `auth.Auth`.
3. `auth/auth.go` verifies JWT claims and passes `*auth.AccessDetails` to the controller.
4. `controller/office_controller_impl.go` decodes `web.OfficeCreateRequest`.
5. `service/office_service_impl.go` validates it, opens a context-bound transaction, builds `domain.Office`, and calls the repository.
6. `repository/office_repository_impl.go` calls GORM `Create`.
7. The service maps with `ToOfficeResponse`; the controller wraps it in `web.WebResponse` and returns HTTP 200.
8. A panic at any stage is recovered by `app.ErrorHandler` and mapped by `exception.ErrorHandler`.

## Transaction Ownership

Independent office reads use a context-bound DB without Begin. Office writes own local transactions. HRD approval in `service/leave_hrd.go` selects one writer transaction, shares it across resolver fields, locks rows and schedules notifications after commit.

Other resolver-based service writes use `service/transaction.go` to share one writer transaction across dependent reads and writes. Repositories use their supplied handle. Preserve transaction ownership, finalization and context propagation per flow. Changing a helper/resolver requires dedicated review and integration verification.

## Shared Infrastructure

- Logging: `helper.LoggerMiddleware` writes asynchronous JSON lines under `logs/`; it records request metadata and a query collector.
- Authentication: `auth.Auth`; role slices are passed by routes, but permission checking is commented out in `auth/auth.go`.
- Validation: a shared `validator.Validate` instance, usually called in services.
- Tracing: `otelgorm` plugin and selected `goHelper.SignozSpan` calls.
- Notifications: FCM and HTTP email helpers, sometimes through `helper.RunAsyncNotification` with a detached 15-second context; older direct goroutines also exist.
- No cache or message broker abstraction was found.
