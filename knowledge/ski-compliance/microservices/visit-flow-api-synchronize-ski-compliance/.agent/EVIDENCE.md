# Repository evidence refresh — 2026-09-27

Captured local HEAD: `42d46c39ff303b1d84e77306fccf44b6e42ab83b`. Working-tree source is the evidence, including pre-existing user edits; no application source was changed by this documentation task.

## Route and auth scope

The AST inventory found **10 literal route declarations** under `route/`. Imported auth packages in those handler expressions: No imported auth wrapper found in the scanned handler expressions.

Counts are declarations with the named import, not production endpoint or vulnerability counts. See the [workspace route index](../../.agent/generated/ROUTE_INDEX.md) for exact paths and registration functions. Check app/router.go, global middleware, prefixes, and deployment routing before claiming reachability. Route functions are only statically matched to router calls; no server was started.

## Representative flow

The scanned sync routes register handlers directly with no route-level auth wrapper. `SyncCustomer` creates DB and DBSki transaction handles, reads SKI data using YYYY-MM, maps to an external VisitFlow domain model, handles SourceAction DELETE, and calls the external destination repository. The destination implementation is a pinned dependency. Two handles alone do not prove both stores are written. In `service/customer_position_service_impl.go`, `SyncCustomerPosition` defers `CommitOrRollback(tx.Write)` twice after creating tx and txSki; there is no corresponding txSki.Write finalizer in that method. This is a concrete local handle mismatch; runtime impact still depends on the shared helper and executed paths.

Source chain:

- [route/customer.go](../route/customer.go)
- [controller/customer_controller_impl.go](../controller/customer_controller_impl.go)
- [service/customer_service_impl.go](../service/customer_service_impl.go)
- [repository/customer_repository_impl.go](../repository/customer_repository_impl.go)

## Schema and data questions

Use the workspace [schema catalog](../../DATABASE_SCHEMA_CATALOG.md) for actual captured columns/indexes/FKs and [data access](../../.agent/DATA_ACCESS.md) for authorized reads. Do not imply every table in SKI_MF_PROD is owned by this service or that every deployment uses the captured connection. Actual-data answers must present retrieved results before executed SQL.

## Confidence limits

This is a representative source trace, not exhaustive behavior coverage. Business rules, auth enforcement, shared helper semantics, and deployment configuration must be checked on the affected path. Tests, service startup and live business queries were not run for this documentation refresh. See the [workspace accuracy audit](../../.agent/ACCURACY_AUDIT.md).

## Agent-guidance rollout — 2026-09-27

Current local HEAD: `42d46c39ff303b1d84e77306fccf44b6e42ab83b`; Go directive: `1.23`. Synchronization between SKI, VisitFlow and ERP; source/destination handles and field mapping are operation-specific.

Inspect these current source entry points before applying inherited rules:

- [app/router.go](../app/router.go)
- [go.mod](../go.mod)
- [main.go](../main.go)
- [app/database.go](../app/database.go)

Observed source, desired design and unresolved behavior must remain separate. Transaction ownership and query scope are determined from actual callers/handles; not every route has the same envelope, auth wrapper or mutation behavior. Source/model tags do not prove physical database constraints. Shared module versions must be checked in go.mod. No deployment, test execution or current business totals are established by this refresh.

[Workspace schema catalog](../../DATABASE_SCHEMA_CATALOG.md) · [Read-only access](../../.agent/DATA_ACCESS.md) · [Testing inventory](TESTING.md)

Synchronization may write destinations and explicitly reference production schema names. Selecting a DEV default connection alone does not redirect qualified SQL. Inspect each read/write handle and pinned VisitFlow dependency before execution.
