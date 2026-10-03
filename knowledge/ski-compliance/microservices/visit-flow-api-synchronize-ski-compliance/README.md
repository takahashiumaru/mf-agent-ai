# visit-flow-api-synchronize-ski-compliance

Synchronization entry points between SKI, VisitFlow and ERP for customers, locations, structures, user records and related master data.

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

- Module: `gitlab.com/VNEU/visit-flow-api-synchronize-ski-compliance`.
- Go language version declared by [go.mod](go.mod): **1.23**.
- Gin: `v1.9.1`.
- GORM: `v1.25.4`.
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

Configuration is loaded through the pinned `gitlab.com/VNEU/go-helper/helper` module in `main.go`. Inspect that version for its complete configuration contract. This checkout directly reads `DB_DSN_SOURCE_3` for the ERP connection. `app/database.go` opens the primary and SKI resolver handles. Do not infer credentials or a complete key list from another service.

## Complete API endpoint reference

**10 source declarations** are listed below, including declarations not called by the current router. Paths preserve the source spelling and parameters. This inventory describes the local checkout, not a verified deployed API.

“Registered” means the route function has a call in `app/router.go`. “Declaration only” means no such call was found there. Auth names show the exact route wrapper, not a claim that the endpoint is public when no wrapper appears. Global middleware and gateway policy can still apply. Handler names link behavior to its implementation without inventing business rules.

### Customer

Source: [route/customer.go](route/customer.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/sync-customers/:isAll` | No route-level Auth wrapper | Registered | `customerController.SyncCustomer` | [L25](route/customer.go#L25) |


### Customer Location

Source: [route/customer_location.go](route/customer_location.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/sync-customer-locations/:period/:isAll` | No route-level Auth wrapper | Registered | `customerLocationController.SyncCustomerLocation` | [L25](route/customer_location.go#L25) |


### Customer Postion

Source: [route/customer_postion.go](route/customer_postion.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/sync-customer-positions/:isAll` | No route-level Auth wrapper | Registered | `customerPositionController.SyncCustomerPosition` | [L25](route/customer_postion.go#L25) |


### Customer Specialist

Source: [route/customer_specialist.go](route/customer_specialist.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/sync-customer-specialists/:isAll` | No route-level Auth wrapper | Registered | `customerSpecialistController.SyncCustomerSpecialist` | [L25](route/customer_specialist.go#L25) |


### Location

Source: [route/location.go](route/location.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/sync-locations/:isAll` | No route-level Auth wrapper | Registered | `locationController.SyncLocation` | [L26](route/location.go#L26) |


### Structure

Source: [route/structure.go](route/structure.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/sync-structures/:period/:isAll` | No route-level Auth wrapper | Registered | `structureController.SyncStructure` | [L25](route/structure.go#L25) |


### Structure Location

Source: [route/structure_location.go](route/structure_location.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/sync-structure-locations/:period/:isAll` | No route-level Auth wrapper | Registered | `structureLocationController.SyncStructureLocation` | [L25](route/structure_location.go#L25) |


### User

Source: [route/user.go](route/user.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/sync-users/:isAll` | No route-level Auth wrapper | Registered | `UserController.SyncUser` | [L25](route/user.go#L25) |
| `POST` | `/sync-users-telegram` | No route-level Auth wrapper | Registered | `UserController.SyncUserTelegram` | [L26](route/user.go#L26) |


### User Erp

Source: [route/user_erp.go](route/user_erp.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/sync-erp-users/:isAll` | No route-level Auth wrapper | Registered | `UserErpController.SyncErpUser` | [L25](route/user_erp.go#L25) |


## Database and integration notes

Persistence/bootstrap source: [app/database.go](app/database.go). No active AutoMigrate/RunSQLFromFile call was found in the inspected app source; commented migration snippets do not execute.
Synchronization endpoints can modify destination databases. Trace each service/repository pair and the specific resolver handle before invoking them. Source and destination freshness, transaction ownership and retries are operation-specific.

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
docker build -t visit-flow-api-synchronize-ski-compliance:local .
```

Review [docker-compose.yml](docker-compose.yml) for environment files, mounts, networks and host port mapping before running Compose.

Project-specific commands are defined in [Makefile](Makefile). Inspect prerequisites and side effects before invoking deployment or generation targets.

## Documentation provenance

Updated on 2026-09-27 from the current local source/configuration. The discount-proposal README supplied the section structure; endpoint, version and configuration facts were extracted from this repository. Source declarations and local changes are not deployment verification.

Additional investigation guidance: [AGENTS.md](AGENTS.md).
