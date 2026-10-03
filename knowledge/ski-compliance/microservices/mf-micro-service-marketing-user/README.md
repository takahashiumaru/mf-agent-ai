# mf-micro-service-marketing-user

Marketing users, divisions, sidebar menus, authentication groups and menu permissions.

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

- Module: `gitlab.com/VNEU/mf-micro-service-marketing-user`.
- Go language version declared by [go.mod](go.mod): **1.23**.
- Gin: `v1.8.2`.
- GORM: `v1.24.2`.
- GORM MySQL driver: `v1.4.4`.
- Validator: `v10.11.1`.
- Viper: `v1.14.0`.

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

**35 source declarations** are listed below, including declarations not called by the current router. Paths preserve the source spelling and parameters. This inventory describes the local checkout, not a verified deployed API.

“Registered” means the route function has a call in `app/router.go`. “Declaration only” means no such call was found there. Auth names show the exact route wrapper, not a claim that the endpoint is public when no wrapper appears. Global middleware and gateway policy can still apply. Handler names link behavior to its implementation without inventing business rules.

### Division Route

Source: [route/division_route.go](route/division_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/divisions/:id` | auth.Auth | Registered | `auth.Auth(divisionController.Delete, []string{})` | [L23](route/division_route.go#L23) |
| `GET` | `/divisions` | auth.Auth | Registered | `auth.Auth(divisionController.FindAll, []string{})` | [L24](route/division_route.go#L24) |
| `GET` | `/divisions/:id` | auth.Auth | Registered | `auth.Auth(divisionController.FindByID, []string{})` | [L25](route/division_route.go#L25) |
| `POST` | `/divisions` | auth.Auth | Registered | `auth.Auth(divisionController.Create, []string{})` | [L26](route/division_route.go#L26) |
| `PUT` | `/divisions/:id` | auth.Auth | Registered | `auth.Auth(divisionController.Update, []string{})` | [L27](route/division_route.go#L27) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-marketing-user/auth`.

### Group Authentication Route

Source: [route/group_authentication_route.go](route/group_authentication_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `group/authentications` | auth.Auth | Registered | `auth.Auth(groupAuthenticationController.FindAll, []string{})` | [L23](route/group_authentication_route.go#L23) |
| `GET` | `group/authentications/:id` | auth.Auth | Registered | `auth.Auth(groupAuthenticationController.FindByID, []string{})` | [L24](route/group_authentication_route.go#L24) |
| `POST` | `group/authentications` | auth.Auth | Registered | `auth.Auth(groupAuthenticationController.Create, []string{})` | [L25](route/group_authentication_route.go#L25) |
| `PUT` | `group/authentications/:id` | auth.Auth | Registered | `auth.Auth(groupAuthenticationController.Update, []string{})` | [L26](route/group_authentication_route.go#L26) |
| `DELETE` | `group/authentications/:id` | auth.Auth | Registered | `auth.Auth(groupAuthenticationController.Delete, []string{})` | [L27](route/group_authentication_route.go#L27) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-marketing-user/auth`.

### Group Menu Authentication Route

Source: [route/group_menu_authentication_route.go](route/group_menu_authentication_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `group/menus/authentications` | auth.Auth | Registered | `auth.Auth(groupMenuAuthenticationController.FindAll, []string{})` | [L26](route/group_menu_authentication_route.go#L26) |
| `GET` | `group/menus/authentications/:id` | auth.Auth | Registered | `auth.Auth(groupMenuAuthenticationController.FindByID, []string{})` | [L27](route/group_menu_authentication_route.go#L27) |
| `POST` | `group/menus/authentications/:menuGroupID` | auth.Auth | Registered | `auth.Auth(groupMenuAuthenticationController.Create, []string{})` | [L28](route/group_menu_authentication_route.go#L28) |
| `PUT` | `group/menus/authentications/:id` | auth.Auth | Registered | `auth.Auth(groupMenuAuthenticationController.Update, []string{})` | [L29](route/group_menu_authentication_route.go#L29) |
| `DELETE` | `group/menus/authentications/:id` | auth.Auth | Registered | `auth.Auth(groupMenuAuthenticationController.Delete, []string{})` | [L30](route/group_menu_authentication_route.go#L30) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-marketing-user/auth`.

### Menu Authentication Route

Source: [route/menu_authentication_route.go](route/menu_authentication_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/menus/authentications/:id` | auth.Auth | Registered | `auth.Auth(menuAuthenticationController.Delete, []string{})` | [L32](route/menu_authentication_route.go#L32) |
| `GET` | `/menus/authentications` | auth.Auth | Registered | `auth.Auth(menuAuthenticationController.FindAll, []string{})` | [L33](route/menu_authentication_route.go#L33) |
| `GET` | `/menus/authentications/:id` | auth.Auth | Registered | `auth.Auth(menuAuthenticationController.FindByID, []string{})` | [L34](route/menu_authentication_route.go#L34) |
| `POST` | `/menus/authentications` | auth.Auth | Registered | `auth.Auth(menuAuthenticationController.Create, []string{})` | [L35](route/menu_authentication_route.go#L35) |
| `PUT` | `/menus/authentications/:id` | auth.Auth | Registered | `auth.Auth(menuAuthenticationController.Update, []string{})` | [L36](route/menu_authentication_route.go#L36) |
| `GET` | `/menus/authentications-csv` | No route-level Auth wrapper | Registered | `auth.AuthCsv(menuAuthenticationController.FindMenuAuthByCsv, []string{})` | [L37](route/menu_authentication_route.go#L37) |
| `PUT` | `group/position/menus/authentications/:groupID` | auth.Auth | Registered | `auth.Auth(menuAuthenticationController.UpdateGroupMenu, []string{})` | [L38](route/menu_authentication_route.go#L38) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-marketing-user/auth`.

### Menu Sidebar Route

Source: [route/menu_sidebar_route.go](route/menu_sidebar_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/menu_sidebars/:id` | auth.Auth | Registered | `auth.Auth(menuSidebarController.Delete, []string{})` | [L23](route/menu_sidebar_route.go#L23) |
| `GET` | `/menu_sidebars` | auth.Auth | Registered | `auth.Auth(menuSidebarController.FindAll, []string{})` | [L24](route/menu_sidebar_route.go#L24) |
| `GET` | `/menu_sidebars/:id` | auth.Auth | Registered | `auth.Auth(menuSidebarController.FindByID, []string{})` | [L25](route/menu_sidebar_route.go#L25) |
| `POST` | `/menu_sidebars` | auth.Auth | Registered | `auth.Auth(menuSidebarController.Create, []string{})` | [L26](route/menu_sidebar_route.go#L26) |
| `PUT` | `/menu_sidebars/:id` | auth.Auth | Registered | `auth.Auth(menuSidebarController.Update, []string{})` | [L27](route/menu_sidebar_route.go#L27) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-marketing-user/auth`.

### User Route

Source: [route/user_route.go](route/user_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/users/:id` | auth.Auth | Registered | `auth.Auth(userController.Delete, []string{auth.RoleAdministrator})` | [L23](route/user_route.go#L23) |
| `GET` | `/users` | auth.Auth | Registered | `auth.Auth(userController.FindAll, []string{auth.RoleAdministrator})` | [L24](route/user_route.go#L24) |
| `POST` | `/users` | auth.Auth | Registered | `auth.Auth(userController.Create, []string{auth.RoleAdministrator})` | [L25](route/user_route.go#L25) |
| `PUT` | `/users/:id` | auth.Auth | Registered | `auth.Auth(userController.Update, []string{auth.RoleAdministrator})` | [L26](route/user_route.go#L26) |
| `PUT` | `/users-change-password/:id` | auth.Auth | Registered | `auth.Auth(userController.ChangePassword, []string{})` | [L27](route/user_route.go#L27) |
| `PUT` | `/users-reset-password/:id` | auth.Auth | Registered | `auth.Auth(userController.ResetPassword, []string{})` | [L28](route/user_route.go#L28) |
| `GET` | `/users/login` | No route-level Auth wrapper | Registered | `userController.Login` | [L30](route/user_route.go#L30) |
| `POST` | `/users/refresh-token` | No route-level Auth wrapper | Registered | `userController.RefreshToken` | [L31](route/user_route.go#L31) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-marketing-user/auth`.

## Database and integration notes

Persistence/bootstrap source: [app/database.go](app/database.go). Active AST calls include `helper.RunSQLFromFile`, `database.AutoMigrate`, `helper.RunSQLFromFile`. Review the exact bootstrap before running against any database.

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
docker build -t mf-micro-service-marketing-user:local .
```

Review [docker-compose.yml](docker-compose.yml) for environment files, mounts, networks and host port mapping before running Compose.

## Documentation provenance

Updated on 2026-09-27 from the current local source/configuration. The discount-proposal README supplied the section structure; endpoint, version and configuration facts were extracted from this repository. Source declarations and local changes are not deployment verification.

Additional investigation guidance: [AGENTS.md](AGENTS.md).
