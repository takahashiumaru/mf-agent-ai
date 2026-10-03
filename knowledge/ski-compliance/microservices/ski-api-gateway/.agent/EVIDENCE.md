# Repository evidence and exceptions

## Agent-guidance rollout — 2026-09-27

Current local HEAD: `5f810f17396b7c78a7d7f07fb9ee89c88c035df2`; Go directive: `1.23`. Gateway route collections, reverse proxying, API-key/JWT middleware and upstream integration.

Inspect these current source entry points before applying inherited rules:

- [pkg/app/router.go](../pkg/app/router.go)
- [go.mod](../go.mod)
- [helper/reverse_proxy.go](../helper/reverse_proxy.go)
- [pkg/auth/auth.go](../pkg/auth/auth.go)

Observed source, desired design and unresolved behavior must remain separate. Transaction ownership and query scope are determined from actual callers/handles; not every route has the same envelope, auth wrapper or mutation behavior. Source/model tags do not prove physical database constraints. Shared module versions must be checked in go.mod. No deployment, test execution or current business totals are established by this refresh.

[Workspace schema catalog](../../DATABASE_SCHEMA_CATALOG.md) · [Read-only access](../../.agent/DATA_ACCESS.md) · [Testing inventory](TESTING.md)

Gateway routes are declared as Backend values in pkg/app/routes_*.go. Public/protected collections are registered at different points relative to middleware; do not infer downstream auth or deployment from these declarations alone.
