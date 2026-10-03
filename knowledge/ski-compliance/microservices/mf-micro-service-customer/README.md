# mf-micro-service-customer

Customer master data, specialist and position classifications, territory outlet/product assignments, customer profiles and VisitFlow synchronization entry points.

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

- Module: `gitlab.com/VNEU/mf-micro-service-customer`.
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

**43 source declarations** are listed below, including declarations not called by the current router. Paths preserve the source spelling and parameters. This inventory describes the local checkout, not a verified deployed API.

“Registered” means the route function has a call in `app/router.go`. “Declaration only” means no such call was found there. Auth names show the exact route wrapper, not a claim that the endpoint is public when no wrapper appears. Global middleware and gateway policy can still apply. Handler names link behavior to its implementation without inventing business rules.

### Customer Group Specialist Route

Source: [route/customer_group_specialist_route.go](route/customer_group_specialist_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/customers/group/specialists/:id` | auth.Auth | Registered | `auth.Auth(CustomerGroupSpecialistController.Delete, []string{})` | [L23](route/customer_group_specialist_route.go#L23) |
| `GET` | `/customers/group/specialists` | auth.Auth | Registered | `auth.Auth(CustomerGroupSpecialistController.FindAll, []string{})` | [L24](route/customer_group_specialist_route.go#L24) |
| `GET` | `/customers/group/specialists/:id` | auth.Auth | Registered | `auth.Auth(CustomerGroupSpecialistController.FindByID, []string{})` | [L25](route/customer_group_specialist_route.go#L25) |
| `POST` | `/customers/group/specialists` | auth.Auth | Registered | `auth.Auth(CustomerGroupSpecialistController.Create, []string{})` | [L26](route/customer_group_specialist_route.go#L26) |
| `PUT` | `/customers/group/specialists/:id` | auth.Auth | Registered | `auth.Auth(CustomerGroupSpecialistController.Update, []string{})` | [L27](route/customer_group_specialist_route.go#L27) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-customer/auth`.

### Customer Inactive Status Route

Source: [route/customer_inactive_status_route.go](route/customer_inactive_status_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/customers/inactive-statuses/:id` | auth.Auth | Registered | `auth.Auth(customerInactiveStatusController.Delete, []string{})` | [L23](route/customer_inactive_status_route.go#L23) |
| `GET` | `/customers/inactive-statuses` | auth.Auth | Registered | `auth.Auth(customerInactiveStatusController.FindAll, []string{})` | [L24](route/customer_inactive_status_route.go#L24) |
| `GET` | `/customers/inactive-statuses/:id` | auth.Auth | Registered | `auth.Auth(customerInactiveStatusController.FindByID, []string{})` | [L25](route/customer_inactive_status_route.go#L25) |
| `POST` | `/customers/inactive-statuses` | auth.Auth | Registered | `auth.Auth(customerInactiveStatusController.Create, []string{})` | [L26](route/customer_inactive_status_route.go#L26) |
| `PUT` | `/customers/inactive-statuses/:id` | auth.Auth | Registered | `auth.Auth(customerInactiveStatusController.Update, []string{})` | [L27](route/customer_inactive_status_route.go#L27) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-customer/auth`.

### Customer Position Route

Source: [route/customer_position_route.go](route/customer_position_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/customers/positions/:id` | auth.Auth | Registered | `auth.Auth(customerPositionController.Delete, []string{})` | [L23](route/customer_position_route.go#L23) |
| `GET` | `/customers/positions` | auth.Auth | Registered | `auth.Auth(customerPositionController.FindAll, []string{})` | [L24](route/customer_position_route.go#L24) |
| `GET` | `/customers/positions/:id` | auth.Auth | Registered | `auth.Auth(customerPositionController.FindByID, []string{})` | [L25](route/customer_position_route.go#L25) |
| `POST` | `/customers/positions` | auth.Auth | Registered | `auth.Auth(customerPositionController.Create, []string{})` | [L26](route/customer_position_route.go#L26) |
| `PUT` | `/customers/positions/:id` | auth.Auth | Registered | `auth.Auth(customerPositionController.Update, []string{})` | [L27](route/customer_position_route.go#L27) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-customer/auth`.

### Customer Profile Route

Source: [route/customer_profile_route.go](route/customer_profile_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/customers/profile` | auth.Auth | Registered | `auth.Auth(customerProfile.Create, []string{})` | [L23](route/customer_profile_route.go#L23) |
| `DELETE` | `/customers/profile/:customerID/:category/:flag/:data/:value` | auth.Auth | Registered | `auth.Auth(customerProfile.Delete, []string{})` | [L24](route/customer_profile_route.go#L24) |
| `PUT` | `/customers/profile/:customerID` | auth.Auth | Registered | `auth.Auth(customerProfile.Update, []string{})` | [L25](route/customer_profile_route.go#L25) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-customer/auth`.

### Customer Route

Source: [route/customer_route.go](route/customer_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/customers/:id` | auth.Auth | Registered | `auth.Auth(customerController.Delete, []string{})` | [L40](route/customer_route.go#L40) |
| `GET` | `/customers` | auth.Auth | Registered | `auth.Auth(customerController.FindAll, []string{})` | [L41](route/customer_route.go#L41) |
| `GET` | `/customers/no-auth` | No route-level Auth wrapper | Registered | `customerController.FindAllNoAuth` | [L42](route/customer_route.go#L42) |
| `GET` | `/customers/events/specialists` | auth.Auth | Registered | `auth.Auth(customerController.FindCustomerEventSpecialists, []string{})` | [L43](route/customer_route.go#L43) |
| `GET` | `/customers/:id` | auth.Auth | Registered | `auth.Auth(customerController.FindByID, []string{})` | [L44](route/customer_route.go#L44) |
| `POST` | `/customers` | auth.Auth | Registered | `auth.Auth(customerController.Create, []string{})` | [L45](route/customer_route.go#L45) |
| `PUT` | `/customers/:id` | auth.Auth | Registered | `auth.Auth(customerController.Update, []string{})` | [L46](route/customer_route.go#L46) |
| `PUT` | `/customers/:id/sync-visitflow` | auth.Auth | Registered | `auth.Auth(customerController.UpdateCustomerVisitFlow, []string{})` | [L47](route/customer_route.go#L47) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-customer/auth`.

### Customer Specialist Route

Source: [route/customer_specialist_route.go](route/customer_specialist_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/customers/specialists/:id` | auth.Auth | Registered | `auth.Auth(customerSpecialistController.Delete, []string{})` | [L24](route/customer_specialist_route.go#L24) |
| `GET` | `/customers/specialists` | auth.Auth | Registered | `auth.Auth(customerSpecialistController.FindAll, []string{})` | [L25](route/customer_specialist_route.go#L25) |
| `GET` | `/customers/specialists/:id` | auth.Auth | Registered | `auth.Auth(customerSpecialistController.FindByID, []string{})` | [L26](route/customer_specialist_route.go#L26) |
| `POST` | `/customers/specialists` | auth.Auth | Registered | `auth.Auth(customerSpecialistController.Create, []string{})` | [L27](route/customer_specialist_route.go#L27) |
| `PUT` | `/customers/specialists/:id` | auth.Auth | Registered | `auth.Auth(customerSpecialistController.Update, []string{})` | [L28](route/customer_specialist_route.go#L28) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-customer/auth`.

### Customer Territory Outlet

Source: [route/customer_territory_outlet.go](route/customer_territory_outlet.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/customers/territories/outlets/:id` | auth.Auth | Registered | `auth.Auth(customerTerritoryOutletController.Delete, []string{})` | [L23](route/customer_territory_outlet.go#L23) |
| `GET` | `/customers/territories/outlets` | auth.Auth | Registered | `auth.Auth(customerTerritoryOutletController.FindAll, []string{})` | [L24](route/customer_territory_outlet.go#L24) |
| `GET` | `/customers/territories/outlets/cust` | auth.Auth | Registered | `auth.Auth(customerTerritoryOutletController.FindCustomer, []string{})` | [L25](route/customer_territory_outlet.go#L25) |
| `GET` | `/customers/territories/outlets/:id` | auth.Auth | Registered | `auth.Auth(customerTerritoryOutletController.FindByID, []string{})` | [L26](route/customer_territory_outlet.go#L26) |
| `POST` | `/customers/territories/outlets` | auth.Auth | Registered | `auth.Auth(customerTerritoryOutletController.Create, []string{})` | [L27](route/customer_territory_outlet.go#L27) |
| `PUT` | `/customers/territories/outlets/:id` | auth.Auth | Registered | `auth.Auth(customerTerritoryOutletController.Update, []string{})` | [L28](route/customer_territory_outlet.go#L28) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-customer/auth`.

### Customer Territory Product

Source: [route/customer_territory_product.go](route/customer_territory_product.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/customers/territories/products/:id` | auth.Auth | Registered | `auth.Auth(customerTerritoryProductController.Delete, []string{})` | [L25](route/customer_territory_product.go#L25) |
| `GET` | `/customers/territories/products` | auth.Auth | Registered | `auth.Auth(customerTerritoryProductController.FindAll, []string{})` | [L26](route/customer_territory_product.go#L26) |
| `GET` | `/customers/territories/products/:id` | auth.Auth | Registered | `auth.Auth(customerTerritoryProductController.FindByID, []string{})` | [L27](route/customer_territory_product.go#L27) |
| `GET` | `/customers/territories/products/program/:programID/:period` | auth.Auth | Registered | `auth.Auth(customerTerritoryProductController.FindByProgram, []string{})` | [L28](route/customer_territory_product.go#L28) |
| `POST` | `/customers/territories/products` | auth.Auth | Registered | `auth.Auth(customerTerritoryProductController.Create, []string{})` | [L29](route/customer_territory_product.go#L29) |
| `PUT` | `/customers/territories/products/:id` | auth.Auth | Registered | `auth.Auth(customerTerritoryProductController.Update, []string{})` | [L30](route/customer_territory_product.go#L30) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-customer/auth`.

## Database and integration notes

Persistence/bootstrap source: [app/database.go](app/database.go). Active AST calls include `database.AutoMigrate`, `helper.RunSQLFromFile`. Review the exact bootstrap before running against any database.
Known schema gap from the 2026-09-27 SKI_MF_PROD snapshot: CustomerProfile writes target `summary_customers`, which was not visible. Verify the intended object before using that flow.

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
docker build -t mf-micro-service-customer:local .
```

Review [docker-compose.yml](docker-compose.yml) for environment files, mounts, networks and host port mapping before running Compose.

## Documentation provenance

Updated on 2026-09-27 from the current local source/configuration. The discount-proposal README supplied the section structure; endpoint, version and configuration facts were extracted from this repository. Source declarations and local changes are not deployment verification.

Additional investigation guidance: [AGENTS.md](AGENTS.md).
