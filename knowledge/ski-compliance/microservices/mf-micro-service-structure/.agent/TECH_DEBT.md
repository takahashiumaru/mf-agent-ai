# Technical Debt Assessment — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document catalogs technical debt items identified across the repository with their classification, evidence, concrete risk, and recommended remediation.

---

## TD-001 — Transaction Opened for Read-Only Queries

- **Classification**: ACCEPTABLE / LEGACY
- **Evidence**: `service/marketing_structure_service_impl.go:93` (`tx := service.DB.Begin()`), `service/office_service_impl.go:35`
- **Impact**: Read-only operations (`FindAll`, `FindByID`) unnecessarily allocate transaction handles and issue `COMMIT` statements on the database connection pool, increasing connection holding time and pool contention under high read loads.
- **Scope**: All service read methods (`service/*_service_impl.go`).
- **Recommended action**: When touching individual read methods during maintenance, migrate to executing queries directly on `service.DB` without `Begin()` / `Commit()`.
- **Verification**: Benchmark read query throughput and verify error propagation behaves identically.
- **Priority**: Medium

---

## TD-002 — Panic/Recover-Driven Control Flow Across All Layers

- **Classification**: LEGACY
- **Evidence**: `helper/error.go:3` (`PanicIfError`), `helper/tx.go:8` (`CommitOrRollback`), `app/router.go:26` (`ErrorHandler`)
- **Impact**: Using panics for non-exceptional control flow (such as validation or record-not-found) diverges from idiomatic Go error returns (`val, err := ...`). However, it is deeply established as the core architectural pattern in this service.
- **Scope**: Repository-wide (all controllers, services, repositories, helpers).
- **Recommended action**: Retain the pattern across existing code. Do not attempt a wholesale rewrite to value-based error returns without a dedicated project mandate. Ensure all new functions adhere to the existing panic-recovery error handler contract.
- **Verification**: Verify `app.ErrorHandler()` and `exception.ErrorHandler()` correctly catch and translate panics into HTTP responses.
- **Priority**: Low (architectural consistency overrides stylistic preference)

---

## TD-003 — `record not found` Mapped to HTTP 200 OK

- **Classification**: LEGACY
- **Evidence**: `exception/error_handler.go:63` (`recordNotFoundError` returns `http.StatusOK` with `{"success": true, "message": "Record not found"}`)
- **Impact**: Diverges from standard RESTful HTTP status code semantics (`404 Not Found`), but existing frontend/mobile and service consumers depend on this exact JSON envelope and 200 status code.
- **Scope**: All `FindByID` and single-record retrieval endpoints.
- **Recommended action**: Preserve contract for existing endpoints. Any change to `404` must be explicitly coordinated across consumer clients.
- **Verification**: Verify client response parsing and existing API contracts.
- **Priority**: Low

---

## TD-004 — Missing Unit and Integration Test Coverage

- **Classification**: MIGRATE-WHEN-TOUCHED
- **Evidence**: Only `helper/operator_test.go` exists. Services, repositories, and controllers lack test files.
- **Impact**: Changes to complex business logic (such as `MergeStructure`, `CreateDuplicate`, or `FindMarketingStructureAllLevel`) carry high regression risk.
- **Scope**: `service/`, `controller/`, `repository/`, `helper/`.
- **Recommended action**: Add characterization unit tests for each service and helper module when modifying or adding functionality.
- **Verification**: Achieve >80% statement coverage on touched packages using `go test -cover ./...`.
- **Priority**: High

---

## TD-005 — Multi-Level Hierarchy SQL View Performance under Large Datasets

- **Classification**: MIGRATE-WHEN-TOUCHED
- **Evidence**: `app/database/after_auto_migrate.sql:25` (`view_marketing_structure_all_levels` performing 5 sequential left self-joins on `view_marketing_structure_positions`), `repository/marketing_structure_repository_impl.go:210`
- **Impact**: As historical period records grow, recursive view evaluations without filtering push heavy CPU and memory load onto MySQL.
- **Scope**: All-level hierarchy queries (`FindMarketingStructureAllLevel`).
- **Recommended action**: Ensure queries against `view_marketing_structure_all_levels` always supply a strict `period = ?` equality predicate to allow MySQL optimizer to push down predicates.
- **Verification**: Run `EXPLAIN` on filtered view queries to confirm indexed range scans on `marketing_structures(period, id)`.
- **Priority**: Medium

---

## TD-006 — Hardcoded `http.Client` in Synchronous ETL and Sync Helpers

- **Classification**: MIGRATE-WHEN-TOUCHED
- **Evidence**: `helper/etl_to_mssql.go:71` (`client := &http.Client{}` with no timeout), `helper/sync_visitflow.go:50`
- **Impact**: If the external MSSQL sync or VisitFlow endpoint hangs, worker goroutines in the service can block indefinitely without timeout, leading to connection pool exhaustion.
- **Scope**: `helper/etl_to_mssql.go`, `helper/sync_visitflow.go`.
- **Recommended action**: Add explicit timeout (`http.Client{Timeout: 10 * time.Second}`) or context propagation.
- **Verification**: Test behavior when target URL is unreachable or unresponsive.
- **Priority**: High
