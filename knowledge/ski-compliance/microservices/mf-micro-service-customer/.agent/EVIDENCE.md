# Repository evidence refresh — 2026-09-27

Captured local HEAD: `d5e2bf1db02b997eea208e620f5517afc7210c39`. Working-tree source is the evidence, including pre-existing user edits; no application source was changed by this documentation task.

## Route and auth scope

The AST inventory found **43 literal route declarations** under `route/`. Imported auth packages in those handler expressions: `gitlab.com/VNEU/mf-micro-service-customer/auth`: 42 declarations

Counts are declarations with the named import, not production endpoint or vulnerability counts. See the [workspace route index](../../.agent/generated/ROUTE_INDEX.md) for exact paths and registration functions. Check app/router.go, global middleware, prefixes, and deployment routing before claiming reachability. Route functions are only statically matched to router calls; no server was started.

## Representative flow

`CustomerTerritoryProductRoute` uses local auth. The service receives Gin context and passes it to imported `goHelper.CreateTransaction`; inspect that pinned helper before diagnosing missing cancellation. FindAll selects a reporting response when page is nonzero. Create validates a batch and assembles customer/period/product mappings. Period-dependent mapping grain must be preserved in joins and totals.

Source chain:

- [route/customer_territory_product.go](../route/customer_territory_product.go)
- [controller/customer_territory_product_controller_impl.go](../controller/customer_territory_product_controller_impl.go)
- [service/customer_territory_product_service_impl.go](../service/customer_territory_product_service_impl.go)
- [repository/customer_territory_product_repository_impl.go](../repository/customer_territory_product_repository_impl.go)

## Schema and data questions

Use the workspace [schema catalog](../../DATABASE_SCHEMA_CATALOG.md) for actual captured columns/indexes/FKs and [data access](../../.agent/DATA_ACCESS.md) for authorized reads. Do not imply every table in SKI_MF_PROD is owned by this service or that every deployment uses the captured connection. Actual-data answers must present retrieved results before executed SQL.

## Confidence limits

This is a representative source trace, not exhaustive behavior coverage. Business rules, auth enforcement, shared helper semantics, and deployment configuration must be checked on the affected path. Tests, service startup and live business queries were not run for this documentation refresh. See the [workspace accuracy audit](../../.agent/ACCURACY_AUDIT.md).

## Agent-guidance rollout — 2026-09-27

Current local HEAD: `d5e2bf1db02b997eea208e620f5517afc7210c39`; Go directive: `1.23`. Customer master data, classifications, profiles and territory assignments.

Inspect these current source entry points before applying inherited rules:

- [app/router.go](../app/router.go)
- [go.mod](../go.mod)
- [main.go](../main.go)
- [app/database.go](../app/database.go)

Observed source, desired design and unresolved behavior must remain separate. Transaction ownership and query scope are determined from actual callers/handles; not every route has the same envelope, auth wrapper or mutation behavior. Source/model tags do not prove physical database constraints. Shared module versions must be checked in go.mod. No deployment, test execution or current business totals are established by this refresh.

[Workspace schema catalog](../../DATABASE_SCHEMA_CATALOG.md) · [Read-only access](../../.agent/DATA_ACCESS.md) · [Testing inventory](TESTING.md)
