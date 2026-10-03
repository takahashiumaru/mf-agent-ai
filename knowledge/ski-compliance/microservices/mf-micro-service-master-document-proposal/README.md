# mf-micro-service-master-document-proposal

Proposal master documents, file operations and discount-proposal category detail endpoints.

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

- Module: `gitlab.com/VNEU/mf-micro-service-master-document-proposal`.
- Go language version declared by [go.mod](go.mod): **1.23**.
- Gin: `v1.9.1`.
- GORM: `v1.24.2`.
- GORM MySQL driver: `v1.4.4`.
- Validator: `v10.14.0`.
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
| `OTEL_EXPORTER_OTLP_ENDPOINT` |
| `INSECURE_MODE` |


## Complete API endpoint reference

**19 source declarations** are listed below, including declarations not called by the current router. Paths preserve the source spelling and parameters. This inventory describes the local checkout, not a verified deployed API.

“Registered” means the route function has a call in `app/router.go`. “Declaration only” means no such call was found there. Auth names show the exact route wrapper, not a claim that the endpoint is public when no wrapper appears. Global middleware and gateway policy can still apply. Handler names link behavior to its implementation without inventing business rules.

### Discount Proposal Category Detail Route

Source: [route/discount_proposal_category_detail_route.go](route/discount_proposal_category_detail_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/discount-proposals/category-details/:id` | auth.Auth | Registered | `auth.Auth(discountProposalCategoryDetailController.Delete, []string{})` | [L23](route/discount_proposal_category_detail_route.go#L23) |
| `GET` | `/discount-proposals/category-details` | auth.Auth | Registered | `auth.Auth(discountProposalCategoryDetailController.FindAll, []string{})` | [L24](route/discount_proposal_category_detail_route.go#L24) |
| `GET` | `/discount-proposals/category-details/:id` | auth.Auth | Registered | `auth.Auth(discountProposalCategoryDetailController.FindByID, []string{})` | [L25](route/discount_proposal_category_detail_route.go#L25) |
| `POST` | `/discount-proposals/category-details` | auth.Auth | Registered | `auth.Auth(discountProposalCategoryDetailController.Create, []string{})` | [L26](route/discount_proposal_category_detail_route.go#L26) |
| `PUT` | `/discount-proposals/category-details/:id` | auth.Auth | Registered | `auth.Auth(discountProposalCategoryDetailController.Update, []string{})` | [L27](route/discount_proposal_category_detail_route.go#L27) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-master-document-proposal/auth`.

### Discount Proposal Category Header Route

Source: [route/discount_proposal_category_header_route.go](route/discount_proposal_category_header_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/discount-proposals/category-headers/:id` | auth.Auth | Declaration only | `auth.Auth(discountProposalCategoryHeaderController.Delete, []string{})` | [L23](route/discount_proposal_category_header_route.go#L23) |
| `GET` | `/discount-proposals/category-headers` | auth.Auth | Declaration only | `auth.Auth(discountProposalCategoryHeaderController.FindAll, []string{})` | [L24](route/discount_proposal_category_header_route.go#L24) |
| `GET` | `/discount-proposals/category-headers/:id` | auth.Auth | Declaration only | `auth.Auth(discountProposalCategoryHeaderController.FindByID, []string{})` | [L25](route/discount_proposal_category_header_route.go#L25) |
| `POST` | `/discount-proposals/category-headers` | auth.Auth | Declaration only | `auth.Auth(discountProposalCategoryHeaderController.Create, []string{})` | [L26](route/discount_proposal_category_header_route.go#L26) |
| `PUT` | `/discount-proposals/category-headers/:id` | auth.Auth | Declaration only | `auth.Auth(discountProposalCategoryHeaderController.Update, []string{})` | [L27](route/discount_proposal_category_header_route.go#L27) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-master-document-proposal/auth`.

### File Route

Source: [route/file_route.go](route/file_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/file/masters-documents/:file` | auth.Auth | Registered | `auth.Auth(fileController.FindMasterDocument, []string{})` | [L18](route/file_route.go#L18) |
| `GET` | `/file/withholding-tax-proof/:file` | auth.Auth | Registered | `auth.Auth(fileController.FindTaxProof, []string{})` | [L19](route/file_route.go#L19) |
| `GET` | `/file/discount-proposal-return/:file` | auth.Auth | Registered | `auth.Auth(fileController.FindDiscountProposalReturn, []string{})` | [L20](route/file_route.go#L20) |
| `GET` | `/file/cancel-transfer-proof/:file` | auth.Auth | Registered | `auth.Auth(fileController.FindCancelTransferProof, []string{})` | [L21](route/file_route.go#L21) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-master-document-proposal/auth`.

### Master Document Route

Source: [route/master_document_route.go](route/master_document_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/masters/documents/:id` | auth.Auth | Registered | `auth.Auth(masterDocumentController.Delete, []string{})` | [L23](route/master_document_route.go#L23) |
| `GET` | `/masters/documents` | auth.Auth | Registered | `auth.Auth(masterDocumentController.FindAll, []string{})` | [L24](route/master_document_route.go#L24) |
| `GET` | `/masters/documents/:id` | auth.Auth | Registered | `auth.Auth(masterDocumentController.FindByID, []string{})` | [L25](route/master_document_route.go#L25) |
| `POST` | `/masters/documents` | auth.Auth | Registered | `auth.Auth(masterDocumentController.Create, []string{})` | [L26](route/master_document_route.go#L26) |
| `PUT` | `/masters/documents/:id` | auth.Auth | Registered | `auth.Auth(masterDocumentController.Update, []string{})` | [L27](route/master_document_route.go#L27) |

Auth imports: `auth` → `gitlab.com/VNEU/mf-micro-service-master-document-proposal/auth`.

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

Container definition: [Dockerfile](Dockerfile). Base stages: `golang:1.23`.

```sh
docker build -t mf-micro-service-master-document-proposal:local .
```

Review [docker-compose.yml](docker-compose.yml) for environment files, mounts, networks and host port mapping before running Compose.

## Documentation provenance

Updated on 2026-09-27 from the current local source/configuration. The discount-proposal README supplied the section structure; endpoint, version and configuration facts were extracted from this repository. Source declarations and local changes are not deployment verification.

Additional investigation guidance: [AGENTS.md](AGENTS.md).
