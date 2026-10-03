# mf-micro-service-product

Product catalog, principals, categories, packaging, units, types, pictures, prices, programs and maximum discounts.

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

- Module: `gitlab.com/VNEU/mf-micro-service-product`.
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
| `SYNC_URL` |
| `OTEL_EXPORTER_OTLP_ENDPOINT` |
| `INSECURE_MODE` |


## Complete API endpoint reference

**51 source declarations** are listed below, including declarations not called by the current router. Paths preserve the source spelling and parameters. This inventory describes the local checkout, not a verified deployed API.

“Registered” means the route function has a call in `app/router.go`. “Declaration only” means no such call was found there. Auth names show the exact route wrapper, not a claim that the endpoint is public when no wrapper appears. Global middleware and gateway policy can still apply. Handler names link behavior to its implementation without inventing business rules.

### Principal Route

Source: [route/principal_route.go](route/principal_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/principals/:id` | authentication.Auth | Registered | `authentication.Auth(principalController.Delete, []string{}, "/principals")` | [L23](route/principal_route.go#L23) |
| `GET` | `/principals` | authentication.Auth | Registered | `authentication.Auth(principalController.FindAll, []string{}, "/principals")` | [L24](route/principal_route.go#L24) |
| `GET` | `/principals/:id` | authentication.Auth | Registered | `authentication.Auth(principalController.FindByID, []string{}, "/principals")` | [L25](route/principal_route.go#L25) |
| `POST` | `/principals` | authentication.Auth | Registered | `authentication.Auth(principalController.Create, []string{}, "/principals")` | [L26](route/principal_route.go#L26) |
| `PUT` | `/principals/:id` | authentication.Auth | Registered | `authentication.Auth(principalController.Update, []string{}, "/principals")` | [L27](route/principal_route.go#L27) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Product Category Route

Source: [route/product_category_route.go](route/product_category_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/products/categories/:id` | authentication.Auth | Registered | `authentication.Auth(productCategoryController.Delete, []string{}, "/products/categories")` | [L23](route/product_category_route.go#L23) |
| `GET` | `/products/categories` | authentication.Auth | Registered | `authentication.Auth(productCategoryController.FindAll, []string{}, "/products/categories")` | [L24](route/product_category_route.go#L24) |
| `GET` | `/products/categories/:id` | authentication.Auth | Registered | `authentication.Auth(productCategoryController.FindByID, []string{}, "/products/categories")` | [L25](route/product_category_route.go#L25) |
| `POST` | `/products/categories` | authentication.Auth | Registered | `authentication.Auth(productCategoryController.Create, []string{}, "/products/categories")` | [L26](route/product_category_route.go#L26) |
| `PUT` | `/products/categories/:id` | authentication.Auth | Registered | `authentication.Auth(productCategoryController.Update, []string{}, "/products/categories")` | [L27](route/product_category_route.go#L27) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Product Max Discount Route

Source: [route/product_max_discount_route.go](route/product_max_discount_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/products/max-discounts/:id` | authentication.Auth | Registered | `authentication.Auth(ProductMaxDiscountController.Delete, []string{}, "/products/max-discounts")` | [L23](route/product_max_discount_route.go#L23) |
| `GET` | `/products/max-discounts` | authentication.Auth | Registered | `authentication.Auth(ProductMaxDiscountController.FindAll, []string{}, "/products/max-discounts")` | [L24](route/product_max_discount_route.go#L24) |
| `GET` | `/products/max-discounts/:id` | authentication.Auth | Registered | `authentication.Auth(ProductMaxDiscountController.FindByID, []string{}, "/products/max-discounts")` | [L25](route/product_max_discount_route.go#L25) |
| `POST` | `/products/max-discounts` | authentication.Auth | Registered | `authentication.Auth(ProductMaxDiscountController.Create, []string{}, "/products/max-discounts")` | [L26](route/product_max_discount_route.go#L26) |
| `PUT` | `/products/max-discounts/:programID/:maxDiscount/:periodStart/:periodEnd` | authentication.Auth | Registered | `authentication.Auth(ProductMaxDiscountController.Update, []string{}, "/products/max-discounts")` | [L27](route/product_max_discount_route.go#L27) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Product Packing Route

Source: [route/product_packing_route.go](route/product_packing_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/products/packings/:id` | authentication.Auth | Registered | `authentication.Auth(productPackingController.Delete, []string{}, "/products/packings")` | [L23](route/product_packing_route.go#L23) |
| `GET` | `/products/packings` | authentication.Auth | Registered | `authentication.Auth(productPackingController.FindAll, []string{}, "/products/packings")` | [L24](route/product_packing_route.go#L24) |
| `GET` | `/products/packings/:id` | authentication.Auth | Registered | `authentication.Auth(productPackingController.FindByID, []string{}, "/products/packings")` | [L25](route/product_packing_route.go#L25) |
| `POST` | `/products/packings` | authentication.Auth | Registered | `authentication.Auth(productPackingController.Create, []string{}, "/products/packings")` | [L26](route/product_packing_route.go#L26) |
| `PUT` | `/products/packings/:id` | authentication.Auth | Registered | `authentication.Auth(productPackingController.Update, []string{}, "/products/packings")` | [L27](route/product_packing_route.go#L27) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Product Picture Route

Source: [route/product_picture_route.go](route/product_picture_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/products/pictures/:id` | authentication.Auth | Registered | `authentication.Auth(productPictureController.Delete, []string{}, "/products/pictures")` | [L23](route/product_picture_route.go#L23) |
| `GET` | `/products/pictures` | authentication.Auth | Registered | `authentication.Auth(productPictureController.FindAll, []string{}, "/products/pictures")` | [L24](route/product_picture_route.go#L24) |
| `GET` | `/products/pictures/:id` | authentication.Auth | Registered | `authentication.Auth(productPictureController.FindByID, []string{}, "/products/pictures")` | [L25](route/product_picture_route.go#L25) |
| `POST` | `/products/pictures` | authentication.Auth | Registered | `authentication.Auth(productPictureController.Create, []string{}, "/products/pictures")` | [L26](route/product_picture_route.go#L26) |
| `PUT` | `/products/pictures/:id` | authentication.Auth | Registered | `authentication.Auth(productPictureController.Update, []string{}, "/products/pictures")` | [L27](route/product_picture_route.go#L27) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Product Price Route

Source: [route/product_price_route.go](route/product_price_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/products/prices/:id` | authentication.Auth | Registered | `authentication.Auth(productPriceController.Delete, []string{}, "/products/prices")` | [L23](route/product_price_route.go#L23) |
| `GET` | `/products/prices` | authentication.Auth | Registered | `authentication.Auth(productPriceController.FindAll, []string{}, "/products/prices")` | [L24](route/product_price_route.go#L24) |
| `GET` | `/products/prices/:id` | authentication.Auth | Registered | `authentication.Auth(productPriceController.FindByID, []string{}, "/products/prices")` | [L25](route/product_price_route.go#L25) |
| `POST` | `/products/prices` | authentication.Auth | Registered | `authentication.Auth(productPriceController.Create, []string{}, "/products/prices")` | [L26](route/product_price_route.go#L26) |
| `PUT` | `/products/prices/:id` | authentication.Auth | Registered | `authentication.Auth(productPriceController.Update, []string{}, "/products/prices")` | [L27](route/product_price_route.go#L27) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Product Program Route

Source: [route/product_program_route.go](route/product_program_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/products/programs/:id` | authentication.Auth | Registered | `authentication.Auth(productProgramController.Delete, []string{}, "/products/programs")` | [L31](route/product_program_route.go#L31) |
| `GET` | `/products/programs` | authentication.Auth | Registered | `authentication.Auth(productProgramController.FindAll, []string{}, "/products/programs")` | [L32](route/product_program_route.go#L32) |
| `GET` | `/products/programs/:id` | authentication.Auth | Registered | `authentication.Auth(productProgramController.FindByID, []string{}, "/products/programs")` | [L33](route/product_program_route.go#L33) |
| `POST` | `/products/programs` | authentication.Auth | Registered | `authentication.Auth(productProgramController.Create, []string{}, "/products/programs")` | [L34](route/product_program_route.go#L34) |
| `PUT` | `/products/programs/:id` | authentication.Auth | Registered | `authentication.Auth(productProgramController.Update, []string{}, "/products/programs")` | [L35](route/product_program_route.go#L35) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Product Route

Source: [route/product_route.go](route/product_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/products/:id` | authentication.Auth | Registered | `authentication.Auth(productController.Delete, []string{}, "/products")` | [L23](route/product_route.go#L23) |
| `GET` | `/products` | authentication.Auth | Registered | `authentication.Auth(productController.FindAll, []string{}, "/products")` | [L24](route/product_route.go#L24) |
| `GET` | `/products/no-auth` | No route-level Auth wrapper | Registered | `productController.FindAllNoAuth` | [L25](route/product_route.go#L25) |
| `GET` | `/products/:id` | authentication.Auth | Registered | `authentication.Auth(productController.FindByID, []string{}, "/products")` | [L26](route/product_route.go#L26) |
| `POST` | `/products` | authentication.Auth | Registered | `authentication.Auth(productController.Create, []string{}, "/products")` | [L27](route/product_route.go#L27) |
| `PUT` | `/products/:id` | authentication.Auth | Registered | `authentication.Auth(productController.Update, []string{}, "/products")` | [L28](route/product_route.go#L28) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Product Type Route

Source: [route/product_type_route.go](route/product_type_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/products/types/:id` | authentication.Auth | Registered | `authentication.Auth(productTypeController.Delete, []string{}, "/products/types")` | [L23](route/product_type_route.go#L23) |
| `GET` | `/products/types` | authentication.Auth | Registered | `authentication.Auth(productTypeController.FindAll, []string{}, "/products/types")` | [L24](route/product_type_route.go#L24) |
| `GET` | `/products/types/:id` | authentication.Auth | Registered | `authentication.Auth(productTypeController.FindByID, []string{}, "/products/types")` | [L25](route/product_type_route.go#L25) |
| `POST` | `/products/types` | authentication.Auth | Registered | `authentication.Auth(productTypeController.Create, []string{}, "/products/types")` | [L26](route/product_type_route.go#L26) |
| `PUT` | `/products/types/:id` | authentication.Auth | Registered | `authentication.Auth(productTypeController.Update, []string{}, "/products/types")` | [L27](route/product_type_route.go#L27) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

### Product Unit Route

Source: [route/product_unit_route.go](route/product_unit_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `DELETE` | `/products/units/:id` | authentication.Auth | Registered | `authentication.Auth(productUnitController.Delete, []string{}, "/products/units")` | [L23](route/product_unit_route.go#L23) |
| `GET` | `/products/units` | authentication.Auth | Registered | `authentication.Auth(productUnitController.FindAll, []string{}, "/products/units")` | [L24](route/product_unit_route.go#L24) |
| `GET` | `/products/units/:id` | authentication.Auth | Registered | `authentication.Auth(productUnitController.FindByID, []string{}, "/products/units")` | [L25](route/product_unit_route.go#L25) |
| `POST` | `/products/units` | authentication.Auth | Registered | `authentication.Auth(productUnitController.Create, []string{}, "/products/units")` | [L26](route/product_unit_route.go#L26) |
| `PUT` | `/products/units/:id` | authentication.Auth | Registered | `authentication.Auth(productUnitController.Update, []string{}, "/products/units")` | [L27](route/product_unit_route.go#L27) |

Auth imports: `authentication` → `gitlab.com/VNEU/ski-api-gateway/pkg/auth`.

## Database and integration notes

Persistence/bootstrap source: [app/database.go](app/database.go). Active AST calls include `helper.RunSQLFromFile`, `helper.RunSQLFromFile`, `helper.RunSQLFromFile`. Review the exact bootstrap before running against any database.
Additional product/product-price database columns are mapped read-only and excluded from JSON/migration in the current local models. Program IDs use size 8. These local changes do not imply deployed services or pinned consumers already use them.

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
docker build -t mf-micro-service-product:local .
```

Review [docker-compose.yml](docker-compose.yml) for environment files, mounts, networks and host port mapping before running Compose.

## Documentation provenance

Updated on 2026-09-27 from the current local source/configuration. The discount-proposal README supplied the section structure; endpoint, version and configuration facts were extracted from this repository. Source declarations and local changes are not deployment verification.

Additional investigation guidance: [AGENTS.md](AGENTS.md).
