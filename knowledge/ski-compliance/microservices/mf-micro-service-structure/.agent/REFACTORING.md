# Safe Refactoring & Migration Guide — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document defines the safe, incremental refactoring methodology for evolving code in `mf-micro-service-structure`.

## Migrate-When-Touched Methodology

Apply refactorings only to code that is already in scope for an active feature or bug fix:

```text
1. CHARACTERIZE   → Understand existing behavior, callers, query SQL, and error responses.
2. PROTECT        → Add characterization unit tests for the current behavior.
3. ISOLATE        → Make one focused, incremental change adhering to preferred patterns.
4. VERIFY         → Run tests, vet, and check query execution.
5. DIFF REVIEW    → Ensure no unrelated contracts, response envelopes, or database side effects changed.
```

## Safe Improvement Opportunities (When Touching Code)

1. **Add `http.Client` Timeouts**: When modifying `helper/etl_to_mssql.go` or `helper/sync_visitflow.go`, ensure timeout is set to 10–15 seconds.
2. **Eliminate Read Transactions**: When touching a query service method, evaluate running on `service.DB` directly rather than `service.DB.Begin()`.
3. **Refactor In-Loop Queries to Batch Queries**: Replace N+1 loops with GORM `Where("id IN ?", ids)` or joins.
4. **Add Zero-Value Updates Protection**: Replace any ambiguous struct updates with explicit `.Select(...)` or map updates.

## Changes Requiring Dedicated Tasks (Do Not Refactor opportunistically)

The following changes carry high blast radius and **must never** be executed as part of routine tasks:
1. **Global Panic-Recovery Removal**: Converting the repository from `helper.PanicIfError` to returned errors across all layers requires rewriting every service, repository, and controller.
2. **HTTP Status Code Changes**: Altering `exception.recordNotFoundError` from `200 OK` to `404 Not Found` breaks existing mobile/web client contracts.
3. **Database Schema / View Restructuring**: Modifying `view_marketing_structure_all_levels` or altering table constraints requires DBA review and cross-service verification.
4. **JWT Auth Layer Restructuring**: Modifying token parsing or claim keys affects all incoming API traffic.
