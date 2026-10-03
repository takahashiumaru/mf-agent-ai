# Repository evidence and exceptions

## Agent-guidance rollout — 2026-09-27

Current local HEAD: `5e34afeedfe77f181324d842b69c259d7a04a227`; Go directive: `1.23`. Sales transactions/reporting, targets, stock, bridging and integration processing.

Inspect these current source entry points before applying inherited rules:

- [app/router.go](../app/router.go)
- [go.mod](../go.mod)
- [main.go](../main.go)
- [app/database.go](../app/database.go)

Observed source, desired design and unresolved behavior must remain separate. Transaction ownership and query scope are determined from actual callers/handles; not every route has the same envelope, auth wrapper or mutation behavior. Source/model tags do not prove physical database constraints. Shared module versions must be checked in go.mod. No deployment, test execution or current business totals are established by this refresh.

[Workspace schema catalog](../../DATABASE_SCHEMA_CATALOG.md) · [Read-only access](../../.agent/DATA_ACCESS.md) · [Testing inventory](TESTING.md)

## Package refactor — 2026-09-29

Current execution baseline: `30a0b121b1fc11f14b414c184ab092abf453d521`, with the previously authorized service refactor already uncommitted. See [package dependency ownership](../docs/architecture/package-dependencies.md). The pinned Structure and Discount Proposal modules import Sales packages back; preserve public paths and avoid introducing package cycles. Bridging ETL callbacks execute before deferred commit in the current source. Historical descriptions of post-commit execution are not authoritative.
