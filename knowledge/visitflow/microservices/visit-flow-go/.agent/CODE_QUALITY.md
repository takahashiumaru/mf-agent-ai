# Code Quality

## Primary Goals

Every change should improve or preserve:

- correctness and business invariants;
- readability and maintainability;
- testability;
- observability without secret exposure;
- database and transaction safety;
- query efficiency;
- compatibility with callers and clients.

The smallest coherent change is usually better than an opportunistic rewrite.

## Where the rules live

This document owns pattern classification and review wording. Use `../AGENTS.md` for mandatory rules/work sequence, `PREFERRED_PATTERNS.md` for implementation choices, `QUALITY_GATES.md` for the completion checklist, and `TESTING.md` for commands and evidence limits. Apply those sources without repeating their full checklists here.

## Do Not Over-Engineer

Do not introduce these without a demonstrated problem that current patterns cannot solve:

- generic/base repositories or services;
- extra abstraction layers and one-implementation interfaces;
- reflection-heavy mapping/filter frameworks;
- global service locators;
- CQRS or event sourcing;
- DDD or Clean Architecture rewrites;
- premature caching/concurrency;
- generic helper packages with mixed responsibilities.

The current horizontal layered architecture has imperfections, but a feature or bug fix does not authorize redesigning it.

## Pattern Classification

### PREFERRED

- Explicit route constructor injection (`route/company_route.go`).
- Controller request translation, service business logic, repository GORM ownership.
- DTO validation before writes.
- Explicit update maps for zero-value fields (`VisitRepository.UpdateApproved`).
- Batch reads plus in-memory maps (`service/html_service_service_impl.go`, `service/structure_service_impl.go`).
- `CreateInBatches`/`OnConflict` with explicit business keys and checked errors.
- Parameterized raw SQL and allowlisted filters.
- Focused tests and handwritten mocks at current abstraction boundaries.

### ACCEPTABLE

- Existing layer interfaces even when broad, because route wiring/tests depend on them.
- Small unpaginated lookup lists when table size is demonstrably bounded.
- `Save` after loading and deliberately modifying a complete row.
- Simple `SELECT *` for small single-row CRUD when it improves maintainability and cost is immaterial.

### LEGACY

- Panic-based recoverable error propagation.
- Services accepting/storing Gin-specific context contracts deep in business code.
- Concrete repository construction inside service methods.
- Fire-and-forget goroutines that capture request context.
- Manual transaction commits/restarts inside normal service flows.
- Repository methods returning HTTP-layer projections and services writing Gin responses.
- Repeated query/write calls inside input/data loops.

Preserve legacy behavior when required, but do not copy it into a new module.

### MIGRATE-WHEN-TOUCHED

- Oversized service functions mixing validation, queries, file work, calculation, notifications, and mapping.
- Unbounded list queries on tables whose cardinality may grow.
- Wide join projections using `alias.*`.
- Long batch/template processing inside transactions.
- Exact-string not-found/error classification.
- Inconsistent pointer-to-scalar and naming conventions.

Local improvement requires regression tests and must not expand into an unrelated refactor.

### DANGEROUS

- `Unscoped()` hard deletes without verified business intent, selective scope, and recovery/authorization safeguards.
- User-controlled SQL identifiers/order fragments.
- Ignored GORM/batch/commit errors.
- Cross-tenant queries without company/structure/period scope.
- Base-DB operations inside an active transaction.
- Avoidable remote calls while locks/transactions are held.
- Unbounded goroutines or goroutines using Gin context after handler return.
- Enabling `AutoMigrate` without the production schema process.
- Exposing secrets or copying existing embedded credentials.

## Review Outcome Language

When reporting a finding, state:

1. the concrete behavior/risk;
2. the evidence path;
3. the failure mode or cost;
4. the smallest safe correction;
5. the verification required.

Avoid style-only recommendations presented as correctness requirements.
