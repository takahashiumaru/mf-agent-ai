# mf-micro-service-bank

Bank, branch, transfer-fee and customer-account management, including account verification and proposal transfer-type routes.

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

- Module: `gitlab.com/VNEU/mf-micro-service-bank`.
- Go language version declared by [go.mod](go.mod): **1.19**.
- Gin: `v1.9.0`.
- GORM: `v1.25.1`.
- GORM MySQL driver: `v1.5.1`.
- Validator: `v10.14.0`.
- Viper: `v1.15.0`.

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
| `OTEL_EXPORTER_OTLP_ENDPOINT` |
| `INSECURE_MODE` |


## Complete API endpoint reference

**27 source declarations** are listed below, including declarations not called by the current router. Paths preserve the source spelling and parameters. This inventory describes the local checkout, not a verified deployed API.

“Registered” means the route function has a call in `app/router.go`. “Declaration only” means no such call was found there. Auth names show the exact route wrapper, not a claim that the endpoint is public when no wrapper appears. Global middleware and gateway policy can still apply. Handler names link behavior to its implementation without inventing business rules.

### Account Route

Source: [route/account_route.go](route/account_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/accounts/:id` | authentication.Auth | Registered | `authentication.Auth(accountController.Delete, []string{}, "/accounts")` | [L22](route/account_route.go#L22) |
| `GET` | `/accounts` | authentication.Auth | Registered | `authentication.Auth(accountController.FindAll, []string{}, "/accounts")` | [L23](route/account_route.go#L23) |
| `GET` | `/accounts/:id` | authentication.Auth | Registered | `authentication.Auth(accountController.FindByID, []string{}, "/accounts")` | [L24](route/account_route.go#L24) |
| `GET` | `/accounts/verify/:biCode/:account` | authentication.Auth | Registered | `authentication.Auth(accountController.FindByAccount, []string{}, "/accounts")` | [L25](route/account_route.go#L25) |
| `POST` | `/accounts` | authentication.Auth | Registered | `authentication.Auth(accountController.Create, []string{}, "/accounts")` | [L26](route/account_route.go#L26) |
| `PUT` | `/accounts/:id` | authentication.Auth | Registered | `authentication.Auth(accountController.Update, []string{}, "/accounts")` | [L27](route/account_route.go#L27) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Bank Branch Route

Source: [route/bank_branch_route.go](route/bank_branch_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/banks/branches/:id` | authentication.Auth | Registered | `authentication.Auth(bankBranchController.Delete, []string{}, "/banks/branches")` | [L24](route/bank_branch_route.go#L24) |
| `GET` | `/banks/branches` | authentication.Auth | Registered | `authentication.Auth(bankBranchController.FindAll, []string{}, "/banks/branches")` | [L25](route/bank_branch_route.go#L25) |
| `GET` | `/banks/branches/:id` | authentication.Auth | Registered | `authentication.Auth(bankBranchController.FindByID, []string{}, "/banks/branches")` | [L26](route/bank_branch_route.go#L26) |
| `POST` | `/banks/branches` | authentication.Auth | Registered | `authentication.Auth(bankBranchController.Create, []string{}, "/banks/branches")` | [L27](route/bank_branch_route.go#L27) |
| `PUT` | `/banks/branches/:id` | authentication.Auth | Registered | `authentication.Auth(bankBranchController.Update, []string{}, "/banks/branches")` | [L28](route/bank_branch_route.go#L28) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Bank Route

Source: [route/bank_route.go](route/bank_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/banks/:id` | authentication.Auth | Registered | `authentication.Auth(bankController.Delete, []string{}, "/banks")` | [L24](route/bank_route.go#L24) |
| `GET` | `/banks` | authentication.Auth | Registered | `authentication.Auth(bankController.FindAll, []string{}, "/banks")` | [L25](route/bank_route.go#L25) |
| `GET` | `/banks/:id` | authentication.Auth | Registered | `authentication.Auth(bankController.FindByID, []string{}, "/banks")` | [L26](route/bank_route.go#L26) |
| `POST` | `/banks` | authentication.Auth | Registered | `authentication.Auth(bankController.Create, []string{}, "/banks")` | [L27](route/bank_route.go#L27) |
| `PUT` | `/banks/:id` | authentication.Auth | Registered | `authentication.Auth(bankController.Update, []string{}, "/banks")` | [L28](route/bank_route.go#L28) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Bank Transfer Fee Route

Source: [route/bank_transfer_fee_route.go](route/bank_transfer_fee_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/banks/transfer-fees/:id` | authentication.Auth | Registered | `authentication.Auth(bankTransferFeeController.Delete, []string{}, "/banks/transfer-fees")` | [L23](route/bank_transfer_fee_route.go#L23) |
| `GET` | `/banks/transfer-fees` | authentication.Auth | Registered | `authentication.Auth(bankTransferFeeController.FindAll, []string{}, "/banks/transfer-fees")` | [L24](route/bank_transfer_fee_route.go#L24) |
| `GET` | `/banks/transfer-fees/:id` | authentication.Auth | Registered | `authentication.Auth(bankTransferFeeController.FindByID, []string{}, "/banks/transfer-fees")` | [L25](route/bank_transfer_fee_route.go#L25) |
| `POST` | `/banks/transfer-fees` | authentication.Auth | Registered | `authentication.Auth(bankTransferFeeController.Create, []string{}, "/banks/transfer-fees")` | [L26](route/bank_transfer_fee_route.go#L26) |
| `PUT` | `/banks/transfer-fees/:id` | authentication.Auth | Registered | `authentication.Auth(bankTransferFeeController.Update, []string{}, "/banks/transfer-fees")` | [L27](route/bank_transfer_fee_route.go#L27) |
| `GET` | `banks/:id/transfer-fees/date/:period` | authentication.Auth | Registered | `authentication.Auth(bankTransferFeeController.FindByBankIDAndPeriod, []string{}, "/banks/transfer-fees")` | [L29](route/bank_transfer_fee_route.go#L29) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Discount Proposal Transferred Type Route

Source: [route/discount_proposal_transferred_type_route.go](route/discount_proposal_transferred_type_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/discount-proposals/transferred-types/:id` | auth.Auth | Registered | `auth.Auth(discountProposalTransferredTypeController.Delete, []string{}, "/discount-proposals/transferred-types")` | [L23](route/discount_proposal_transferred_type_route.go#L23) |
| `GET` | `/discount-proposals/transferred-types` | auth.Auth | Registered | `auth.Auth(discountProposalTransferredTypeController.FindAll, []string{}, "/discount-proposals/transferred-types")` | [L24](route/discount_proposal_transferred_type_route.go#L24) |
| `GET` | `/discount-proposals/transferred-types/:id` | auth.Auth | Registered | `auth.Auth(discountProposalTransferredTypeController.FindByID, []string{}, "/discount-proposals/transferred-types")` | [L25](route/discount_proposal_transferred_type_route.go#L25) |
| `POST` | `/discount-proposals/transferred-types` | auth.Auth | Registered | `auth.Auth(discountProposalTransferredTypeController.Create, []string{}, "/discount-proposals/transferred-types")` | [L26](route/discount_proposal_transferred_type_route.go#L26) |
| `PUT` | `/discount-proposals/transferred-types/:id` | auth.Auth | Registered | `auth.Auth(discountProposalTransferredTypeController.Update, []string{}, "/discount-proposals/transferred-types")` | [L27](route/discount_proposal_transferred_type_route.go#L27) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-bank/auth`.

## Database and integration notes

Persistence/bootstrap source: [app/database.go](app/database.go). Active AST calls include `helper.RunSQLFromFile`, `database.AutoMigrate`, `helper.RunSQLFromFile`. Review the exact bootstrap before running against any database.
Known schema gap from the 2026-09-27 SKI_MF_PROD snapshot: `discount_proposal_transferred_types` was not visible. Its declared account association also needs investigation. Do not infer these routes are usable merely because they are registered.

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
docker build -t mf-micro-service-bank:local .
```

Review [docker-compose.yml](docker-compose.yml) for environment files, mounts, networks and host port mapping before running Compose.

## Documentation provenance

Updated on 2026-09-27 from the current local source/configuration. The discount-proposal README supplied the section structure; endpoint, version and configuration facts were extracted from this repository. Source declarations and local changes are not deployment verification.

Additional investigation guidance: [AGENTS.md](AGENTS.md).
