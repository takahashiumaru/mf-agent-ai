# mf-micro-service-outlet-2

Outlet master data, outlet types, groups, group mappings and outlet sharing.

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

- Module: `gitlab.com/VNEU/mf-micro-service-outlet-2`.
- Go language version declared by [go.mod](go.mod): **1.23**.
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
| `SYNC_URL` |
| `VISIT_URL` |
| `OTEL_EXPORTER_OTLP_ENDPOINT` |
| `INSECURE_MODE` |


## Complete API endpoint reference

**28 source declarations** are listed below, including declarations not called by the current router. Paths preserve the source spelling and parameters. This inventory describes the local checkout, not a verified deployed API.

“Registered” means the route function has a call in `app/router.go`. “Declaration only” means no such call was found there. Auth names show the exact route wrapper, not a claim that the endpoint is public when no wrapper appears. Global middleware and gateway policy can still apply. Handler names link behavior to its implementation without inventing business rules.

### Outlet Group Mapping Route

Source: [route/outlet_group_mapping_route.go](route/outlet_group_mapping_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/outlets/group-mappings/:id` | auth.Auth | Registered | `auth.Auth(mappingController.Delete, []string{})` | [L23](route/outlet_group_mapping_route.go#L23) |
| `GET` | `/outlets/group-mappings` | auth.Auth | Registered | `auth.Auth(mappingController.FindAll, []string{})` | [L24](route/outlet_group_mapping_route.go#L24) |
| `GET` | `/outlets/group-mappings/:id` | auth.Auth | Registered | `auth.Auth(mappingController.FindByID, []string{})` | [L25](route/outlet_group_mapping_route.go#L25) |
| `POST` | `/outlets/group-mappings` | auth.Auth | Registered | `auth.Auth(mappingController.CreateBatch, []string{})` | [L26](route/outlet_group_mapping_route.go#L26) |
| `PUT` | `/outlets/group-mappings/:id` | auth.Auth | Registered | `auth.Auth(mappingController.Update, []string{})` | [L27](route/outlet_group_mapping_route.go#L27) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-outlet-2/auth`.

### Outlet Group Route

Source: [route/outlet_group_route.go](route/outlet_group_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/outlets/groups/:id` | auth.Auth | Registered | `auth.Auth(outletGroupController.Delete, []string{})` | [L23](route/outlet_group_route.go#L23) |
| `GET` | `/outlets/groups` | auth.Auth | Registered | `auth.Auth(outletGroupController.FindAll, []string{})` | [L24](route/outlet_group_route.go#L24) |
| `GET` | `/outlets/groups/:id` | auth.Auth | Registered | `auth.Auth(outletGroupController.FindByID, []string{})` | [L25](route/outlet_group_route.go#L25) |
| `POST` | `/outlets/groups` | auth.Auth | Registered | `auth.Auth(outletGroupController.Create, []string{})` | [L26](route/outlet_group_route.go#L26) |
| `PUT` | `/outlets/groups/:id` | auth.Auth | Registered | `auth.Auth(outletGroupController.Update, []string{})` | [L27](route/outlet_group_route.go#L27) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-outlet-2/auth`.

### Outlet Route

Source: [route/outlet_route.go](route/outlet_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/outlets/:id` | auth.Auth | Registered | `auth.Auth(outletController.Delete, []string{})` | [L39](route/outlet_route.go#L39) |
| `GET` | `/outlets` | auth.Auth | Registered | `auth.Auth(outletController.FindAll, []string{})` | [L40](route/outlet_route.go#L40) |
| `GET` | `/outlets/:id` | auth.Auth | Registered | `auth.Auth(outletController.FindByID, []string{})` | [L41](route/outlet_route.go#L41) |
| `GET` | `/outlets/bridging-outlets` | auth.Auth | Registered | `auth.Auth(outletController.FindBridgingOutlet, []string{})` | [L42](route/outlet_route.go#L42) |
| `GET` | `/outlets/mapping-customers` | auth.Auth | Registered | `auth.Auth(outletController.FindOutletMappingCustomer, []string{})` | [L43](route/outlet_route.go#L43) |
| `POST` | `/outlets` | auth.Auth | Registered | `auth.Auth(outletController.Create, []string{})` | [L44](route/outlet_route.go#L44) |
| `PUT` | `/outlets/:id` | auth.Auth | Registered | `auth.Auth(outletController.Update, []string{})` | [L45](route/outlet_route.go#L45) |
| `PUT` | `/outlets/:id/merge/:idTarget` | auth.Auth | Registered | `auth.Auth(outletController.MergeOutlet, []string{})` | [L46](route/outlet_route.go#L46) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-outlet-2/auth`.

### Outlet Share Route

Source: [route/outlet_share_route.go](route/outlet_share_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/outlets/shares/:id` | auth.Auth | Registered | `auth.Auth(outletShareController.Delete, []string{})` | [L37](route/outlet_share_route.go#L37) |
| `GET` | `/outlets/shares` | auth.Auth | Registered | `auth.Auth(outletShareController.FindAll, []string{})` | [L38](route/outlet_share_route.go#L38) |
| `GET` | `/outlets/shares/:id` | auth.Auth | Registered | `auth.Auth(outletShareController.FindByID, []string{})` | [L39](route/outlet_share_route.go#L39) |
| `POST` | `/outlets/shares` | auth.Auth | Registered | `auth.Auth(outletShareController.Create, []string{})` | [L40](route/outlet_share_route.go#L40) |
| `PUT` | `/outlets/shares/:id` | auth.Auth | Registered | `auth.Auth(outletShareController.Update, []string{})` | [L41](route/outlet_share_route.go#L41) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-outlet-2/auth`.

### Outlet Type Route

Source: [route/outlet_type_route.go](route/outlet_type_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/outlets/types/:id` | auth.Auth | Registered | `auth.Auth(outletTypeController.Delete, []string{})` | [L23](route/outlet_type_route.go#L23) |
| `GET` | `/outlets/types` | auth.Auth | Registered | `auth.Auth(outletTypeController.FindAll, []string{})` | [L24](route/outlet_type_route.go#L24) |
| `GET` | `/outlets/types/:id` | auth.Auth | Registered | `auth.Auth(outletTypeController.FindByID, []string{})` | [L25](route/outlet_type_route.go#L25) |
| `POST` | `/outlets/types` | auth.Auth | Registered | `auth.Auth(outletTypeController.Create, []string{})` | [L26](route/outlet_type_route.go#L26) |
| `PUT` | `/outlets/types/:id` | auth.Auth | Registered | `auth.Auth(outletTypeController.Update, []string{})` | [L27](route/outlet_type_route.go#L27) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-outlet-2/auth`.

## Database and integration notes

Persistence/bootstrap source: [app/database.go](app/database.go). Active AST calls include `helper.RunSQLFromFile`, `database.AutoMigrate`. Review the exact bootstrap before running against any database.

## Quality and deployment

Useful checks, to run in an appropriate development environment:

```sh
go build ./...
go test ./...
go vet ./...
```

No application tests, service startup, deployment or database mutations were performed for this README update. Existing coverage files or badges are not a fresh coverage measurement.

Container definition: [Dockerfile](Dockerfile). Base stages: `golang:1.23`.

```sh
docker build -t mf-micro-service-outlet-2:local .
```

Review [docker-compose.yml](docker-compose.yml) for environment files, mounts, networks and host port mapping before running Compose.

## Documentation provenance

Updated on 2026-09-27 from the current local source/configuration. The discount-proposal README supplied the section structure; endpoint, version and configuration facts were extracted from this repository. Source declarations and local changes are not deployment verification.

Additional investigation guidance: [AGENTS.md](AGENTS.md).
