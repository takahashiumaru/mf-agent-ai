# mf-micro-service-event

Promotional event headers, details, classes, organizers and specialist associations.

## Table of Contents

- [Overview and architecture](#overview-and-architecture)
- [Technology stack](#technology-stack)
- [Directory structure](#directory-structure)
- [Getting started](#getting-started)
- [Complete API endpoint reference](#complete-api-endpoint-reference)
- [Database and integration notes](#database-and-integration-notes)
- [Quality and deployment](#quality-and-deployment)

## Overview and architecture

`main.go` wires database handles and validation, then `app/router.go` registers functions in `route/`. Requests pass through the registered middleware and controllers to services, repositories and model/response mapping. Transaction and synchronization behavior must be read in the owning service and repository.

## Technology stack

- Module: `gitlab.com/VNEU/mf-micro-service-event`.
- Go language version declared by [go.mod](go.mod): **1.19**.
- Gin: `v1.9.1`.
- GORM: `v1.25.2`.
- GORM MySQL driver: `v1.5.1`.
- Validator: `v10.14.1`.
- Viper: `v1.16.0`.

Internal/private modules are pinned in `go.mod`; access to those module versions is required. A sibling checkout does not automatically replace a pinned dependency.

## Directory structure

| Path | Purpose |
| --- | --- |
| [app/](app/) | Database bootstrap and router composition |
| [route/](route/) | HTTP route registration and dependency wiring |
| [controller/](controller/) | HTTP binding and response handling |
| [service/](service/) | Business rules and orchestration |
| [repository/](repository/) | Database queries and persistence |
| [model/](model/) | Persistence models and API DTOs |
| [configuration/](configuration/) | Local configuration loader/files |
| [auth/](auth/) | Local authentication helpers; routes may import another module instead |
| [helper/](helper/) | Shared utilities and integrations |
| [exception/](exception/) | Error definitions and response handling |
| [Auth/](Auth/) | Custom mux and authentication |

## Getting started

1. Install the Go version required by `go.mod` and configure access to private module dependencies.
2. Prepare local configuration from the loader below. Obtain secrets through the approved secret-management process; do not copy production credentials into README examples.
3. Use an isolated development database and review bootstrap/integration side effects before starting the application.
4. Run from the repository root:

```sh
go mod download
go run .
```

These are documented commands, not commands executed during this README refresh.

### Configuration

Loader: [configuration/configuration.go](configuration/configuration.go).
The loader reads `configuration/.env`. `main.go` uses `":" + PORT` for its HTTP address.

Declared configuration keys (names only):

| Key |
| --- |
| `ACCESS_SECRET` |
| `REFRESH_SECRET` |
| `PORT` |
| `PORT_DB` |
| `HOST_DB` |
| `PASSWORD_DB` |
| `USER_DB` |
| `DATABASE_DB` |
| `OTEL_EXPORTER_OTLP_ENDPOINT` |
| `INSECURE_MODE` |


## Complete API endpoint reference

**27 source declarations** are listed below, including declarations not called by the current router. Paths preserve the source spelling and parameters. This inventory describes the local checkout, not a verified deployed API.

“Registered” means the route function has a call in `app/router.go`. “Declaration only” means no such call was found there. Auth names show the exact route wrapper, not a claim that the endpoint is public when no wrapper appears. Global middleware and gateway policy can still apply. Handler names link behavior to its implementation without inventing business rules.

### Event Class Route

Source: [route/event_class_route.go](route/event_class_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/events/classes/:id` | authentication.Auth | Registered | `authentication.Auth(eventClassController.Delete, []string{}, "/events/classes")` | [L23](route/event_class_route.go#L23) |
| `GET` | `/events/classes` | authentication.Auth | Registered | `authentication.Auth(eventClassController.FindAll, []string{}, "/events/classes")` | [L24](route/event_class_route.go#L24) |
| `GET` | `/events/classes/:id` | authentication.Auth | Registered | `authentication.Auth(eventClassController.FindByID, []string{}, "/events/classes")` | [L25](route/event_class_route.go#L25) |
| `POST` | `/events/classes` | authentication.Auth | Registered | `authentication.Auth(eventClassController.Create, []string{}, "/events/classes")` | [L26](route/event_class_route.go#L26) |
| `PUT` | `/events/classes/:id` | authentication.Auth | Registered | `authentication.Auth(eventClassController.Update, []string{}, "/events/classes")` | [L27](route/event_class_route.go#L27) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Event Detail Route

Source: [route/event_detail_route.go](route/event_detail_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/events/details/:id` | authentication.Auth | Registered | `authentication.Auth(eventDetailController.Delete, []string{}, "/events/details")` | [L24](route/event_detail_route.go#L24) |
| `GET` | `/events/details` | authentication.Auth | Registered | `authentication.Auth(eventDetailController.FindAll, []string{}, "/events/details")` | [L25](route/event_detail_route.go#L25) |
| `GET` | `/events/details/:id` | authentication.Auth | Registered | `authentication.Auth(eventDetailController.FindByID, []string{}, "/events/details")` | [L26](route/event_detail_route.go#L26) |
| `POST` | `/events/details` | authentication.Auth | Registered | `authentication.Auth(eventDetailController.Create, []string{}, "/events/details")` | [L27](route/event_detail_route.go#L27) |
| `PUT` | `/events/details/:id` | authentication.Auth | Registered | `authentication.Auth(eventDetailController.Update, []string{}, "/events/details")` | [L28](route/event_detail_route.go#L28) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Event Header Route

Source: [route/event_header_route.go](route/event_header_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/events/headers/:id` | authentication.Auth | Registered | `authentication.Auth(eventHeaderController.Delete, []string{}, "/events/headers")` | [L25](route/event_header_route.go#L25) |
| `GET` | `/events/headers` | authentication.Auth | Registered | `authentication.Auth(eventHeaderController.FindAll, []string{}, "/events/headers")` | [L26](route/event_header_route.go#L26) |
| `GET` | `/events/headers-to-class` | authentication.Auth | Registered | `authentication.Auth(eventHeaderController.FindEventClassFromHeader, []string{}, "/events/headers")` | [L27](route/event_header_route.go#L27) |
| `GET` | `/events/headers/:id` | authentication.Auth | Registered | `authentication.Auth(eventHeaderController.FindByID, []string{}, "/events/headers")` | [L28](route/event_header_route.go#L28) |
| `POST` | `/events/headers` | authentication.Auth | Registered | `authentication.Auth(eventHeaderController.Create, []string{}, "/events/headers")` | [L29](route/event_header_route.go#L29) |
| `PUT` | `/events/headers/:id/:periodStart/:periodEnd` | authentication.Auth | Registered | `authentication.Auth(eventHeaderController.Update, []string{}, "/events/headers")` | [L30](route/event_header_route.go#L30) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Event Organizer Route

Source: [route/event_organizer_route.go](route/event_organizer_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/events/organizers/:id` | authentication.Auth | Registered | `authentication.Auth(eventOrganizerController.Delete, []string{}, "/events/organizers")` | [L24](route/event_organizer_route.go#L24) |
| `GET` | `/events/organizers` | authentication.Auth | Registered | `authentication.Auth(eventOrganizerController.FindAll, []string{}, "/events/organizers")` | [L25](route/event_organizer_route.go#L25) |
| `GET` | `/events/organizers/:id` | authentication.Auth | Registered | `authentication.Auth(eventOrganizerController.FindByID, []string{}, "/events/organizers")` | [L26](route/event_organizer_route.go#L26) |
| `POST` | `/events/organizers` | authentication.Auth | Registered | `authentication.Auth(eventOrganizerController.Create, []string{}, "/events/organizers")` | [L27](route/event_organizer_route.go#L27) |
| `PUT` | `/events/organizers/:id` | authentication.Auth | Registered | `authentication.Auth(eventOrganizerController.Update, []string{}, "/events/organizers")` | [L28](route/event_organizer_route.go#L28) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Event Specialist Route

Source: [route/event_specialist_route.go](route/event_specialist_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/events/specialists/:id` | authentication.Auth | Registered | `authentication.Auth(eventSpecialistController.Delete, []string{}, "/events/specialists")` | [L26](route/event_specialist_route.go#L26) |
| `GET` | `/events/specialists` | authentication.Auth | Registered | `authentication.Auth(eventSpecialistController.FindAll, []string{}, "/events/specialists")` | [L27](route/event_specialist_route.go#L27) |
| `GET` | `/events/specialists-find-by-customer/:customer_id/:period` | authentication.Auth | Registered | `authentication.Auth(eventSpecialistController.FindByCustomer, []string{}, "/events/specialists")` | [L28](route/event_specialist_route.go#L28) |
| `GET` | `/events/specialists/:id` | authentication.Auth | Registered | `authentication.Auth(eventSpecialistController.FindByID, []string{}, "/events/specialists")` | [L29](route/event_specialist_route.go#L29) |
| `POST` | `/events/specialists` | authentication.Auth | Registered | `authentication.Auth(eventSpecialistController.Create, []string{}, "/events/specialists")` | [L30](route/event_specialist_route.go#L30) |
| `PUT` | `/events/specialists/:id` | authentication.Auth | Registered | `authentication.Auth(eventSpecialistController.Update, []string{}, "/events/specialists")` | [L31](route/event_specialist_route.go#L31) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

## Database and integration notes

Persistence/bootstrap source: [app/database.go](app/database.go). No active AutoMigrate/RunSQLFromFile call was found in the inspected app source; commented migration snippets do not execute.

## Quality and deployment

Useful checks, to run in an appropriate development environment:

```sh
go build ./...
go test ./...
go vet ./...
```

No application tests, service startup, deployment or database mutations were performed for this README update. Existing coverage files or badges are not a fresh coverage measurement.

Container definition: [Dockerfile](Dockerfile). Base stages: `golang:1.19`.

```sh
docker build -t mf-micro-service-event:local .
```

Review [docker-compose.yml](docker-compose.yml) for environment files, mounts, networks and host port mapping before running Compose.

## Documentation provenance

Updated on 2026-09-27 from the current local source/configuration. The discount-proposal README supplied the section structure; endpoint, version and configuration facts were extracted from this repository. Source declarations and local changes are not deployment verification.

Additional investigation guidance: [AGENTS.md](AGENTS.md).
