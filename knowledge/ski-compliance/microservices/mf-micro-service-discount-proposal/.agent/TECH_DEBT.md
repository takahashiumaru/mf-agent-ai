# .agent/TECH_DEBT.md — Technical Debt & Risk Register

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

This document catalogs verified technical debt, security risks, integrity pitfalls, and architectural legacy patterns in `mf-micro-service-discount-proposal`.

---

## 1. Technical Debt Inventory

### TD-001 — Unparameterized SQL String Interpolation in Repository Joins
- **Classification**: `DANGEROUS`
- **Evidence**: `repository/credit_note_amortization_repository_impl.go:182-220` embeds variables (`rangkumanNo`, `memoNo`, `saldoAll`) directly into SQL JOIN clauses using `fmt.Sprintf` rather than GORM parameter placeholders (`?`).
- **Impact**: Potential SQL injection vulnerability and query plan cache pollution in MySQL.
- **Scope**: `repository/credit_note_amortization_repository_impl.go`
- **Recommended action**: Replace `fmt.Sprintf` with parameterized GORM `.Joins(query, args...)` or subquery bindings with `?`.
- **Verification**: Run unit/integration tests with inputs containing special characters and verify query plan via database logs.
- **Priority**: Critical

---

### TD-002 — Double Pointer References & Unqualified Post-Update Finds
- **Classification**: `DANGEROUS`
- **Evidence**: `repository/discount_proposal_estimation_repository_impl.go:64` invokes `.Where(&where).Updates(&set).Find(&estimation)` where `where` and `set` are already pointers (`*domain.DiscountProposalEstimation`), resulting in `**struct` references and an unqualified `.Find()` that can scan unintended records.
- **Impact**: Unpredictable query results, runtime GORM reflection errors, or silent update failures.
- **Scope**: `repository/discount_proposal_estimation_repository_impl.go`, `repository/discount_proposal_limit_by_outlet_product_repository_impl.go:110`
- **Recommended action**: Pass `where` directly (not `&where`) and use explicit ID/primary key scoping for the follow-up `.Find()` query.
- **Verification**: Add repository integration test for `UpdateDiscountProduct` verifying exact row modification.
- **Priority**: High

---

### TD-003 — Disabled Endpoint Role Authorization Checks
- **Classification**: `DANGEROUS`
- **Evidence**: `auth/auth.go:58-61` has the permission check commented out (`// if !helper.Contains(roles, tokenAuth.Role) ...`), and all route definitions in `route/*.go` pass empty role slices `[]string{}`.
- **Impact**: Any authenticated user with a valid JWT can access administrative endpoints regardless of their role level (`MKT`, `FSM`, `ASM`, etc.).
- **Scope**: `auth/auth.go`, all files in `route/`
- **Recommended action**: Re-enable role validation in `auth.Auth` and populate explicit allowed roles in route definitions.
- **Verification**: Add HTTP test cases verifying 403 Forbidden responses when an unauthorized role attempts access.
- **Priority**: High

---

### TD-004 — Inconsistent Soft Delete Strategy (`gorm.DeletedAt` vs `*time.Time`)
- **Classification**: `MIGRATE-WHEN-TOUCHED`
- **Evidence**: `model/domain/discount_proposal.go` uses `gorm.DeletedAt`, whereas `model/domain/credit_note.go`, `model/domain/customer_balance.go`, and `model/domain/credit_note_amortization.go` use `*time.Time`.
- **Impact**: GORM automatically filters out deleted records for `gorm.DeletedAt` models, but does **NOT** for `*time.Time` models. Queries omitting manual `Where("deleted_at IS NULL")` leak soft-deleted records.
- **Scope**: `model/domain/credit_note.go`, `model/domain/customer_balance.go`, `repository/credit_note_repository_impl.go`, `repository/customer_balance_repository_impl.go`
- **Recommended action**: Standardize all domain models to use `gorm.DeletedAt` or strictly enforce explicit `Where("table.deleted_at IS NULL")` in all joins and raw queries.
- **Verification**: Review all query WHERE clauses involving `credit_notes` and `customer_balances`.
- **Priority**: Medium

---

### TD-005 — Zero-Value Field Dropping on GORM Struct Updates
- **Classification**: `MIGRATE-WHEN-TOUCHED`
- **Evidence**: In multiple service and repository methods, updates are executed via `db.Updates(&struct)` which automatically omits zero values (`0`, `""`, `false`, `nil`).
- **Impact**: Attempts to reset flags or nullify foreign keys (e.g. `event_header_id`, `status_over_budget`, `is_closed = false`) fail silently without explicit map updates.
- **Scope**: `repository/discount_proposal_repository_impl.go`, `service/discount_proposal_service_impl.go`
- **Recommended action**: Use `db.Updates(map[string]interface{}{...})` or `.Select("field1", "field2").Updates(&struct)` whenever nullable or boolean fields are modified.
- **Verification**: Write unit/characterization tests asserting that zero-value updates persist correctly to the database.
- **Priority**: Medium

---

### TD-006 — Missing Test Coverage for Core Business Logic
- **Classification**: `LEGACY`
- **Evidence**: Only `helper/operator_test.go` exists. `controller/`, `service/`, and `repository/` packages have 0 unit or integration tests.
- **Impact**: High risk of regressions during refactoring or business logic updates.
- **Scope**: Repository-wide (`service/`, `controller/`, `repository/`)
- **Recommended action**: Incrementally introduce unit tests for business calculations and mock repository interfaces (referencing Prompt `07`).
- **Verification**: Track code coverage with `go test -cover ./...`.
- **Priority**: High

---

### TD-007 — Missing `context.Context` in Service and Repository Signatures
- **Classification**: `LEGACY`
- **Evidence**: All service and repository functions accept `auth *auth.AccessDetails` or `db *gorm.DB` but omit `ctx context.Context`.
- **Impact**: Cannot propagate request timeouts, handle client cancellations, or pass OpenTelemetry trace context down to database operations (`db.WithContext(ctx)`).
- **Scope**: Repository-wide
- **Recommended action**: Maintain current signature for compatibility; in dedicated refactoring tasks, introduce `context.Context` as the first argument across layers.
- **Verification**: Verify OpenTelemetry span linkage and DB cancellation behavior.
- **Priority**: Low

---

### TD-008 — Fire-and-Forget Background ETL Sync Without Retry Queue
- **Classification**: `MIGRATE-WHEN-TOUCHED`
- **Evidence**: Repositories dispatch MSSQL synchronization using detached goroutines `go helper.EtlToMssql(...)` (`repository/discount_proposal_repository_impl.go:469`, `repository/discount_proposal_estimation_repository_impl.go:59`).
- **Impact**: If the MSSQL server or network is unavailable, the ETL sync fails silently with no retry mechanism, persistent queue, or reconciliation alert.
- **Scope**: `helper/etl_to_mssql.go`, `repository/*_impl.go`
- **Recommended action**: Transition fire-and-forget goroutines to an outbox pattern or reliable Redis/message queue (`helper/send_redis_jobs.go`).
- **Verification**: Simulate network failure during ETL sync and verify replay capability.
- **Priority**: Medium

---

### TD-009 — Monolithic God Services with High Complexity
- **Classification**: `LEGACY`
- **Evidence**: `service/discount_proposal_service_impl.go` contains 2,345 lines and handles validation, counter generation, calculation, reporting, Excel generation, and multi-entity orchestrations.
- **Impact**: Difficult to test, maintain, and reason about isolated edge cases.
- **Scope**: `service/discount_proposal_service_impl.go`, `service/credit_note_service_impl.go`
- **Recommended action**: Extract discrete domain calculators (e.g. pricing calculations, Excel generators) into focused helper functions or domain services.
- **Verification**: Refactor with characterization tests protecting behavior before splitting.
- **Priority**: Low

---

### TD-010 — Repetitive Dependency Wiring in Route Definitions
- **Classification**: `LEGACY`
- **Evidence**: Each file in `route/*.go` manually instantiates 10–20 repositories and services (e.g. `route/discount_proposal_route.go` constructs 20 instances).
- **Impact**: Excessive boilerplate and duplicated initialization code across routes.
- **Scope**: `route/*.go`
- **Recommended action**: Centralize dependency creation in a lightweight container or bootstrap factory in `app/`.
- **Verification**: Compile cleanly with `go build -o /dev/null .` and verify all endpoints resolve properly.
- **Priority**: Low
