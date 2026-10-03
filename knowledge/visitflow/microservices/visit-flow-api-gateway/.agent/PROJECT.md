# Project

## Project Purpose

`visit-flow-api-gateway` is the public-facing gateway and identity/access component for the Visit Flow system. `main.go` starts:

1. a KrakenD proxy on the port declared in `configuration.json` (currently 9000), and
2. a Gin service for local user, role, permission, token/session, and file endpoints (the `-jwt-port` flag defaults to 8090).

The Docker Compose mapping exposes those two listeners separately. The repository does not contain the downstream Visit Flow implementations proxied by KrakenD.

## Main Responsibilities

- Parse `configuration.json` and proxy its declared endpoints to downstream HTTP services.
- Forward selected headers and query parameters as configured per endpoint.
- Issue and refresh HMAC JWT access/refresh tokens.
- Validate an access token against the current token stored on the user row.
- Persist users, roles, role-menu permissions, user-role assignments, and refresh sessions.
- Serve user image files and parse a local slow-endpoint report.
- Send asynchronous Firebase login alerts and SMTP email notifications through helpers.

## Main Modules

- Users and departments: `model/domain/users.go`, `service/user_service_impl.go`, `repository/users_repository_impl.go`.
- Sessions and token rotation: `model/domain/session.go`, `repository/session_repository_impl.go`, `service/user_service_impl.go`.
- Roles: `model/domain/role.go` and corresponding controller/service/repository files.
- User-role assignments: `model/domain/user_role.go` and corresponding layers.
- Role-menu permissions: `model/domain/role_menu_permission.go` and corresponding layers.
- Authentication/JWT metadata: `auth/auth.go`.
- Gateway proxy surface: `configuration.json`; it contains hundreds of routes, mainly for Visit Flow, survey/location, synchronization, presence, payroll, and a small set of other upstreams.

The proxied domain names describe downstream responsibilities, not local domain implementations.

## External Systems

- MySQL through GORM (`config/db.go`).
- HTTP upstream services declared in `configuration.json`. Service discovery is expressed as Docker/network hostnames and a small number of explicit hosts.
- Firebase Cloud Messaging, using credentials selected by `FIREBASE_CREDENTIALS_FILE` or `FIREBASE_SERVICE_ACCOUNT`, falling back to `helper/service-account.json` (`helper/notification_helper.go`).
- SMTP, using `MAIL_*` variables with `SMTP_*` fallbacks (`helper/notification_helper.go`).
- SigNoz/OpenTelemetry spans are annotated through `gitlab.com/VNEU/go-helper/helper.SignozSpan` in role-related services. This repository does not initialize an OpenTelemetry exporter directly.

No Redis or message broker usage was found.

## Entrypoints

- `main.go`: only Go application entrypoint.
- `main()`: loads local configuration, starts the Gin identity service in a goroutine, then runs KrakenD.
- `runJWTGeneratorHTTPService(...)`: opens its own database connection and runs the Gin identity service.
- `setupJWTRouter(...)`: assembles middleware and local routes; it is also used by tests.

## Configuration

- `configuration.LoadConfig` calls `godotenv.Overload("./configuration/.env")`, then Viper reads and unmarshals the same file.
- Typed configuration covers `PORT`, `HOST_DB`, `PORT_DB`, `USER_DB`, `PASSWORD_DB`, and `DATABASE_DB`; only the database fields are passed to `DBConnect` in current startup code.
- JWT signing reads `ACCESS_SECRET` and `REFRESH_SECRET` directly from the environment.
- Notification settings are read lazily by `helper/notification_helper.go`.
- KrakenD reads the file given by `-c` (default `configuration.json`), plus command-line flags for gateway port, log level, debug, and local JWT-service settings.
- `configuration/.env` and service-account credentials are sensitive. Never reproduce their values in documentation, logs, fixtures, or commits.

There is no README in the analyzed repository.
