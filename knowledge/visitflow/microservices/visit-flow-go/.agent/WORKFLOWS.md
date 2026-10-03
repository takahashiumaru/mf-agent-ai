# Workflows

Use these task recipes after the routing in `INDEX.md`. Mandatory rules live in `../AGENTS.md`; completion checks live in `QUALITY_GATES.md`.

## Adding a New API Endpoint

For an endpoint in an existing module:

1. Add/update request and response DTOs in `model/web`.
2. Add the method to the controller interface and implement request parsing/response mapping in `controller/*_controller_impl.go`.
3. Add the method to the service interface and implement validation/business logic in `service/*_service_impl.go`.
4. Add repository interface/implementation methods only when persistence behavior is needed.
5. Register the path in the existing `route/*_route.go`, normally through `auth.Auth`.
6. Preserve company/structure/period filters and use the request context.
7. Update mocks and add tests.

For a new module, also add its route function to `app/router.go`.

Use the company files for CRUD wiring/layer shape only; see `PREFERRED_PATTERNS.md#example-boundaries` before copying transaction or reload code. Use visit files for pagination, filters, multipart files, approval/checkpoint rules, and multi-repository transactions.

## Adding a Business Feature

Start from the affected route and trace inward. Keep request mechanics in the controller, validation/orchestration in the service, and data mechanics in the repository. Reuse existing status constants/config rows and response mappers. If a rule depends on `Config` or `ConfirmationStatus`, do not replace it with a hard-coded value.

For multi-entity work, the service owns one atomic transaction boundary and passes its writer transaction through all participating writes and dependent reads. Existing resolver interfaces can remain for compatibility; do not adopt the legacy two-transaction lifecycle as a new template. Follow the transactional section below and `PREFERRED_PATTERNS.md`. Send success notifications only after commit; external effects cannot be rolled back with MySQL.

## Adding a Repository Method

1. Add the signature to `repository/<module>_repository.go`.
2. Implement it in the corresponding `_impl.go`.
3. Match the affected repository interface: existing methods commonly accept `*goHelper.DatabaseResolver`. Ordinary independent reads can use `db.Read`; mutations and reads requiring transaction visibility use the same `db.Write`. New interfaces follow `PREFERRED_PATTERNS.md` rather than introducing another resolver lifecycle.
4. Use placeholders for values and retain tenant/soft-delete conditions.
5. Decide absence behavior based on the module: `First` + panic is common; newer repositories return `error`.
6. Return a domain model/projection and map it above the repository unless the existing interface already uses a web projection.
7. Update handwritten mocks and tests.

## Adding a Database Column

The schema migration mechanism is not present in this repository. First establish how production schema changes are deployed. Then update, as applicable:

`verified external schema change -> model/domain struct -> raw Select/Scan/upsert lists -> DTO -> To...Response mapper -> service mapping -> tests`

Check nullability, zero-value update behavior, composite indexes, stored procedures/views, and audit fields. Do not simply add the model to startup `AutoMigrate`.

## Adding a New Table

After confirming the external schema process:

1. Define the table and constraints through that mechanism.
2. Add the GORM model under `model/domain`, using the nearest model's ID/audit/deletion conventions.
3. Add `TableName()` only when default pluralization is not the actual name.
4. Add repository interface/implementation and constructor.
5. Add service/controller/route only if exposed through HTTP.
6. Register a new route module in `app/router.go`.
7. Add tests; verify actual MySQL behavior in a safe environment.

## Partial Updates

`Updates(struct)` omits zero values. Use it only when that omission matches API semantics. When the client must set `false`, `0`, `""`, or `NULL`, follow patterns such as:

- explicit map updates in `repository/visit_repository_impl.go` (`UpdateApproved`);
- conditional assignment maps in customer/location upserts;
- load-and-save only when the complete existing row is deliberately preserved, as in `VisitCustomerRepository.Update`.

Pointer fields in update DTOs are useful when “not provided” must differ from “provided as zero,” but only introduce them consistently across decoding, service mapping, and repository update.

## Transactional Operations

For an existing resolver-based call chain, preserve its public error and transaction contract while inspecting the affected helper. The legacy sequence is:

1. start the span if the module does so;
2. create `goHelper.CreateTransaction(service.DB.WithContext(c), c)`;
3. attach context to both resolver handles;
4. defer `goHelper.CommitOrRollback(tx.Write)` immediately;
5. pass the same resolver to every repository in the logical unit;
6. let errors panic/re-panic so rollback runs;
7. avoid external side effects before commit where consistency matters.

This describes existing code, not a recommended new transaction template: the separate read transaction has unresolved finalization. For new transaction design follow `PREFERRED_PATTERNS.md`; helper/resolver changes need dedicated review and MySQL integration evidence. Every read that depends on a write must use the same writer transaction. A commit failure must prevent a success response/notification. Inspect manual commit/restart patterns before touching them; do not introduce accidental nested transactions.

## Fetching Relations

- Use a small `Preload` for declared associations when the module already does so; select only required child columns when possible (`visit_product`).
- Use `Joins` plus a projection for filtering, aggregation, aliases, or report-shaped results (`visit`, `visit_customer`).
- Use a separate repository lookup where business validation needs one related entity before writing (common in services).

Avoid N+1 repository calls for unbounded lists and avoid loading all associations by default.

## Raw SQL, Stored Procedures, and Batches

Keep these in repositories. Bind every variable value with placeholders. For batch rebuilds, inspect hard deletes, upsert conflict keys, batch sizes, and whether the operation manually commits/restarts transactions. Review cross-schema names and deployment permissions.

## Bug Fix Workflow

1. Identify the affected endpoint/service behavior.
2. Reproduce it with a focused test where feasible.
3. Inspect the controller input contract and service caller.
4. Inspect the repository/GORM behavior, especially zero values, soft delete, replica reads, and not-found behavior.
5. Check tenant filters, status/config rules, and timezone conversions.
6. Make the smallest coherent change.
7. Add a regression test.
8. Run the targeted test, then broaden according to risk using `TESTING.md` and `QUALITY_GATES.md`. Run `go test ./...` when practical; disclose omitted required verification and its impact.

## Refactoring Workflow

Before refactoring, search:

- route constructors and `app/router.go`;
- controller/service/repository interfaces and implementations;
- concrete repository instantiations inside services;
- external private-module types;
- `test/mocks_test.go` and package-local tests;
- raw SQL/projections and response mappers;
- API/status/error compatibility;
- transaction boundaries and asynchronous side effects.

Do not combine architecture redesign, public interface changes, schema changes, and business behavior changes unless the task explicitly requires that scope.
