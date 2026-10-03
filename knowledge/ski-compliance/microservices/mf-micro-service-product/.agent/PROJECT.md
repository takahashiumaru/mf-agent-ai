# Project

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Purpose

The route registrations and package names identify this service as responsible for principals, products, categories, units, packing, pricing, pictures, discount limits, and programs. The README is the generated GitLab starter template and does not establish additional product behavior.

## Modules and entrypoints

The Go module is `gitlab.com/VNEU/mf-micro-service-product` (Go directive `1.19`), with `main.go` as the executable entrypoint. `app/router.go` composes Gin middleware and route registration. Registered route constructors include: `PrincipalRoute`, `ProductCategoryRouter`, `ProductPackingRoute`, `ProductPriceRoute`, `ProductPictureRoute`, `ProductRoute`, `ProductTypeRoute`, `ProductUnitRoute`, `ProductMaxDiscountRoute`, `ProductProgramRoute`.

Implementation areas are `route/`, `controller/`, `service/`, `repository/`, `model/`, `helper/`, `auth/`, `exception/`, and `configuration/`. Configuration keys and external dependencies must be checked in `configuration/` and the consuming code. Never print or reproduce secret values. Authorized connection tooling may read the needed values in memory under the workspace read-only access contract.

## External systems

The module directly declares GORM and the MySQL GORM driver. Other remote services, queues, and external system responsibilities: Not clearly established in the current repository; trace concrete call sites before documenting or changing them.
