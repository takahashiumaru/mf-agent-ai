# Repository evidence refresh — 2026-09-27

Captured local HEAD: `cf92969c29c768e42b2a376e896b0bf0f90c2e55`. Working-tree source is the evidence, including pre-existing user edits; no application source was changed by this documentation task.

## Route and auth scope

The AST inventory found **51 literal route declarations** under `route/`. Imported auth packages in those handler expressions: `gitlab.com/VNEU/ski-api-gateway/pkg/auth`: 50 declarations

Counts are declarations with the named import, not production endpoint or vulnerability counts. See the [workspace route index](../../.agent/generated/ROUTE_INDEX.md) for exact paths and registration functions. Check app/router.go, global middleware, prefixes, and deployment routing before claiming reachability. Route functions are only statically matched to router calls; no server was started.

## Representative flow

`ProductProgramRoute` imports gateway auth and wires a city dependency. Repository FindAll uses aggregation and city joins; when validate is ACTIVE it also uses product-max-discount period filtering with YYYYMMDD formatting. This validation mode is a query-specific rule, not a universal active status. Update uses struct-based GORM Updates, so intended zero-value changes need method-specific review.

Source chain:

- [route/product_program_route.go](../route/product_program_route.go)
- [controller/product_program_controller_impl.go](../controller/product_program_controller_impl.go)
- [service/product_program_service_impl.go](../service/product_program_service_impl.go)
- [repository/product_program_repository_impl.go](../repository/product_program_repository_impl.go)

## Schema and data questions

Use the workspace [schema catalog](../../DATABASE_SCHEMA_CATALOG.md) for actual captured columns/indexes/FKs and [data access](../../.agent/DATA_ACCESS.md) for authorized reads. Do not imply every table in SKI_MF_PROD is owned by this service or that every deployment uses the captured connection. Actual-data answers must present retrieved results before executed SQL.

## Confidence limits

This is a representative source trace, not exhaustive behavior coverage. Business rules, auth enforcement, shared helper semantics, and deployment configuration must be checked on the affected path. Tests, service startup and live business queries were not run for this documentation refresh. See the [workspace accuracy audit](../../.agent/ACCURACY_AUDIT.md).

## Agent-guidance rollout — 2026-09-27

Current local HEAD: `cf92969c29c768e42b2a376e896b0bf0f90c2e55`; Go directive: `1.19`. Product catalog, prices, programs, pictures and maximum discounts.

Inspect these current source entry points before applying inherited rules:

- [app/router.go](../app/router.go)
- [go.mod](../go.mod)
- [main.go](../main.go)
- [app/database.go](../app/database.go)

Observed source, desired design and unresolved behavior must remain separate. Transaction ownership and query scope are determined from actual callers/handles; not every route has the same envelope, auth wrapper or mutation behavior. Source/model tags do not prove physical database constraints. Shared module versions must be checked in go.mod. No deployment, test execution or current business totals are established by this refresh.

[Workspace schema catalog](../../DATABASE_SCHEMA_CATALOG.md) · [Read-only access](../../.agent/DATA_ACCESS.md) · [Testing inventory](TESTING.md)
