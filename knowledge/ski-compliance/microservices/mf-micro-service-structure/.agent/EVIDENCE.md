# Repository evidence and exceptions

## Agent-guidance rollout — 2026-09-27

Current local HEAD: `82963b5f7a8c65f8a46e703fce3190ebf1df97ae`; Go directive: `1.23`. Marketing hierarchy, territory/area assignments and period-dependent organization.

Inspect these current source entry points before applying inherited rules:

- [app/router.go](../app/router.go)
- [go.mod](../go.mod)
- [main.go](../main.go)
- [app/database.go](../app/database.go)

Observed source, desired design and unresolved behavior must remain separate. Transaction ownership and query scope are determined from actual callers/handles; not every route has the same envelope, auth wrapper or mutation behavior. Source/model tags do not prove physical database constraints. Shared module versions must be checked in go.mod. No deployment, test execution or current business totals are established by this refresh.

[Workspace schema catalog](../../DATABASE_SCHEMA_CATALOG.md) · [Read-only access](../../.agent/DATA_ACCESS.md) · [Testing inventory](TESTING.md)
