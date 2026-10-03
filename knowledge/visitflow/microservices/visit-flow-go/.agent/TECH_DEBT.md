# Technical Debt Register

This register describes recurring debt visible in the current repository. It is not authorization to fix everything in one change. Prioritize by correctness/security risk, frequency of change, and available tests.

## Classification

- **PREFERRED:** safe direction for new code.
- **ACCEPTABLE:** locally sound and compatible, though not ideal everywhere.
- **LEGACY:** preserve behavior when necessary; do not copy.
- **MIGRATE-WHEN-TOUCHED:** improve locally when the affected behavior already changes and tests can protect it.
- **DANGEROUS:** requires explicit justification, focused review, and verification.

## Highest-Risk Debt

### Transaction resolver lifecycle and consistency — DANGEROUS

Most services call `goHelper.CreateTransaction`, which starts separate read and write transactions, but routinely defer finalization only for `tx.Write`. The read transaction lifecycle is not finalized in repository code. Reads after writes often use `db.Read`, which may route to a replica and may not observe the write.

Evidence:

- repeated setup in `service/company_service_impl.go` and most services;
- write-then-read patterns in `repository/company_repository_impl.go` and `repository/visit_repository_impl.go`;
- manual commit/restart exceptions in `service/location_service_impl.go` and `service/visit_customer_service_impl.go`;
- manual GORM transaction in `service/call_target_service_impl.go`.

Direction: keep existing behavior for unrelated changes. For a correctness-sensitive read-after-write, use the same `tx.Write` transaction. Treat redesigning `go-helper` resolver lifecycle as a dedicated task with integration tests.

### Panic-based recoverable errors — LEGACY

Repositories/services commonly call `helper.PanicIfError`; middleware recovers and maps types or exact strings. This couples error semantics to HTTP middleware and transaction recovery. Wrapped not-found errors can become 500 because the external middleware compares exact text.

Newer estimation repositories partly return errors explicitly, but their services still convert them to the panic flow. This coexistence is evidence of transition, not a stable mixed pattern.

Direction: new internal code should return/wrap errors. Migrate a public call chain only when interface, implementation, service/controller, transaction handling, mocks, and HTTP mapping can change together.

### Authorization depends on service/query discipline — DANGEROUS

The `roles` argument passed to `auth.Auth` is not currently enforced. Effective access control relies on `AccessDetails` plus company/structure/subordinate/period filters scattered across services and repositories.

Direction: every changed endpoint must verify tenant and ownership predicates. Authentication/role redesign is a separate security task.

### Ignored or weakly handled errors — DANGEROUS

Examples include fallback scans assigned to `_` in `AreaRecomendationEstimationRepository.GetHnaProductPrice`, direct `CreateInBatches` calls without checking `.Error` in `service/structure_service_impl.go`, and some ignored parse/conversion errors.

Direction: never copy ignored-error patterns. When touching the flow, define whether fallback failure is expected, return/log it appropriately, and add regression tests.

### Hard deletes and rebuilds — DANGEROUS

`Unscoped().Delete` appears in mapping cleanup, history/report rebuilds, approvals, structures, product estimation, and master customer flows. Some deletion scopes operate by period or broad predicates.

Direction: preserve verified rebuild semantics, but require explicit scope, audit/recovery expectation, `RowsAffected` review, and a rollback/restore plan for changes.

## Recurring Maintainability Debt

### Concrete dependencies created inside services — LEGACY

Many services instantiate `repository.XImpl{}` directly, including visit, customer, location, customer-location, and structure flows. This hides dependencies from constructors and makes focused tests harder.

Direction: inject a new/changed dependency through the service constructor and route wiring. Do not expand constructors with unrelated repositories during a small fix.

### Oversized orchestration functions — MIGRATE-WHEN-TOUCHED

`service/visit_service_impl.go`, `service/visit_customer_service_impl.go`, `service/structure_service_impl.go`, and `service/html_service_service_impl.go` mix validation, configuration lookup, mapping, query orchestration, file/template work, notifications, and status transitions.

Direction: extract pure calculation/validation/mapping helpers first. Keep the transaction and business sequence visible. Avoid creating generic workflow frameworks.

### Duplicated customer/location/approval synchronization — MIGRATE-WHEN-TOUCHED

Customer/location updates propagate into visits and customer-location records through service-level helpers such as:

- `CreateDataCustomerMapping` and `UpdateVisitAndCustomerLocation` in `service/customer_service_impl.go`;
- `CreateUpdateCustomerLocation` in `service/visit_service_impl.go`;
- `UpdateDataVisitAndCustomerLocation` in `service/location_service_impl.go`;
- approval/notification sequences across visit, customer-location, location, and structure-city services.

Direction: before extracting shared logic, document each variant's status, audit, tenant, and notification behavior. Extract only genuinely identical policy into a focused service/helper with tests. Similar names do not prove identical business rules.

### Repeated transaction boilerplate — ACCEPTABLE, not a refactor target by itself

The repeated resolver/context/defer block is verbose, but it makes ownership visible. Do not introduce a generic transaction framework until resolver lifecycle and error semantics are deliberately redesigned.

### Inconsistent naming and file spelling — ACCEPTABLE legacy

Examples include `recomendation`, `Bos`, `Id`, plural types such as `Companys`, and double-underscore repository filenames. Renaming public symbols/files creates noisy compatibility changes.

Direction: use idiomatic spelling/initialisms for new private code; rename legacy APIs only in a dedicated compatibility-aware task.

## Data and GORM Debt

### Domain and persistence concerns are combined — ACCEPTABLE legacy architecture

`model/domain` structs contain GORM tags/associations and import `model/web` for `To...Response` mapping. Some repositories also return web projections.

Direction: do not add more HTTP behavior to persistence models. Prefer DTO mapping in the service/domain mapper convention already used. Separating domain/persistence models repository-wide would be a large architecture migration and is not justified for routine work.

### Zero-value update ambiguity — DANGEROUS

Many repositories use `Updates(struct)`, which skips zero values. Some methods correctly use explicit maps, while one `VisitCustomer` flow loads the complete row then uses `Save`.

Direction: new partial updates use pointer DTOs and allowlisted update maps/selected columns. Do not copy broad `Save` or struct updates when false/zero/empty/null are valid.

### Not-found semantics are inconsistent — MIGRATE-WHEN-TOUCHED

Single-row queries use a mixture of `First`, `Take`, and `Find`. `Find` on a struct does not return `gorm.ErrRecordNotFound`; middleware maps exact `record not found` to HTTP 200, while newer services return a 400 business error.

Direction: define absence behavior per endpoint and test it. Prefer `First`/`Take` plus `errors.Is` in explicit-error code. Changing the public HTTP contract must be a separate, intentional decision.

### Soft-delete conventions vary — DANGEROUS when changing lifecycle

Most models embed `gorm.Model`; others use pointer/plain timestamps and explicit `deleted_at IS NULL`. Some repositories rely on GORM scope, others add manual filters, and some use `Unscoped`.

Direction: inspect the exact model/table/query before modifying deletion or uniqueness behavior.

### N+1 and per-item writes — MIGRATE-WHEN-TOUCHED

Candidates include per-structure processing in `service/process_data_visit_service_impl.go`, per-member structure lookup in `service/visit_service_impl.go`, and customer log operations inside family/address loops in `service/customer_service_impl.go`.

Preferred counterexamples are batch-fetch/map enrichment in `service/html_service_service_impl.go` and `service/structure_service_impl.go`.

### Unbounded/wide queries — MIGRATE-WHEN-TOUCHED

Several master/reference repositories use unbounded `Find`; join-heavy visit/customer queries select `alias.*`. Some may be small by design, but no row-count evidence is stored in the repository.

Direction: bound public lists, select materially useful columns for proven hot paths, and validate with query plans.

### Raw SQL and stored procedures — ACCEPTABLE with risk controls

Raw SQL is concentrated in reporting/batch repositories and generally parameterizes values. Risks remain around fixed cross-schema dependencies, large queries, stored procedure contracts, and deployment permissions.

Direction: keep raw SQL in repositories, bind every value, test result mappings, and verify compatible schemas. Never concatenate user input.

## Testing and Observability Debt

- Tests emphasize constructors, validation tags, mappings, auth helpers, and pure functions.
- Database repositories, transaction/rollback behavior, replica consistency, stored procedures, and SQL constraints lack integration coverage.
- Handwritten mocks in `test/mocks_test.go` are useful but broad interfaces allow unexpected embedded methods to escape compile-time expectations.
- Fire-and-forget notification failures are only logged and cannot affect the committed business operation.

Direction: add characterization tests around the exact legacy behavior before refactoring. For DB-sensitive work, add safe MySQL integration verification when infrastructure is available; otherwise state the coverage gap.

## Dedicated Tasks, Not Incidental Refactors

Create separate design/implementation tasks for:

- replacing the resolver/transaction lifecycle;
- standardizing the application error contract and HTTP mapping;
- enforcing route roles and formalizing authorization policy;
- splitting persistence models from domain/API models;
- introducing durable notification delivery;
- redesigning pagination contracts;
- schema/migration ownership and tooling;
- modularizing the largest visit/customer/structure services;
- adding a database integration-test harness.
