# Common Workflows

## Adding a New API Endpoint

1. Find the business stem across `route/`, `controller/`, `service/`, `repository/`, `model/domain`, and `model/web`.
2. Add request/response DTOs under `model/web` only when existing DTOs do not fit.
3. Extend the controller interface and implementation for parsing and `web.WebResponse` output.
4. Extend the service interface/implementation for validation, business rules, mapping, and transaction ownership.
5. Extend the repository interface/implementation only if a new query/write is needed.
6. Wire dependencies and register the path in the module's route file.
7. Apply `auth.Auth` consistently with neighboring endpoints; remember role slices are not currently enforced.
8. Add controller/service/repository tests as applicable.

Use the office flow as the default CRUD template. Use presence for pagination/reporting and leave for multipart/action endpoints.

## Adding a Business Feature

Start in the service for business behavior. Identify status strings, audit fields, company/user/structure constraints, external approval/user/config repositories, notifications, and transaction boundaries. Keep controllers thin and queries in repositories. For leave or attendance correction, trace the whole approval/quota path before editing.

## Adding a Repository Method

1. Add the method to `repository/<module>_repository.go`.
2. Implement it in `<module>_repository_impl.go`.
3. Accept the passed `*gorm.DB` (or `*goHelper.DatabaseResolver` only if the module already needs it); do not capture a global DB.
4. Use parameterized conditions and check `.Error` through `helper.PanicIfError`.
5. Decide absence behavior by matching the local contract: `First` usually panics; a deliberate zero-value absence pattern must be explicit (e.g. quota validation).
6. Preserve the supplied transaction handle for every query in the operation.
7. Add a sqlmock test in `test/`, alongside relevant repository tests.

## Adding a Database Column

The repository has no migration mechanism, so first identify the actual external schema-deployment process. Then follow:

`external migration → model/domain GORM field/tag → repository projections/queries → ToXResponse mapping → web DTO (if exposed) → service construction/update logic → tests`

Also inspect raw SQL, stored procedures, named indexes, uniqueness, nullable/zero-value behavior, and audit/company filtering. Do not enable the field in `AutoMigrate` as an improvised migration.

## Adding a New Table

1. Identify and follow the external migration process.
2. Add the GORM-backed domain model under `model/domain` using the closest ID/timestamp/audit pattern.
3. Add `TableName()` only if the actual table differs from GORM naming.
4. Add repository interface/implementation and sqlmock tests.
5. Add service/controller/route/DTO layers only if HTTP behavior requires them.
6. Verify indexes, foreign keys, deletion policy, tenant key, and update semantics.

## Safe Partial Update

Existing repositories use `Updates(struct)`, which skips zero values. For non-zero sparse updates, build a model containing ID and intended fields, as leave status methods do, then reload if a full response is required.

If `0`, `false`, empty string, or explicit null must be written:

1. Check whether the domain already uses a pointer field.
2. Prefer a pointer for optional values when consistent with the model.
3. Otherwise use a column map or explicit `Select` in the repository, scoped by explicit ID/conditions.
4. Add a regression test proving the zero value is persisted.

Do not use `Save()` as a shortcut; it is not used and can overwrite unintended columns.

## Transactional Operation

Independent reads can use a context-bound DB (office reads are examples). Atomic writes need a service-owned writer transaction; dependent reads use that same handle. Repositories must not escape to a base DB or independent reader.

HRD approval in `service/leave_hrd.go` explicitly selects the writer and shares one transaction across resolver fields, with scoped locks and post-commit notification. Meeting/correction write flows also share a writer via `service/transaction.go`; preserve each flow's transaction and notification order.

Inspect begin/commit/rollback/errors and the pinned helper lifecycle before changing it. Do not introduce nested transactions or swallow failures. Interface compatibility does not require duplicating unsafe lifecycle mechanics.

## Fetching Relations

- Use association `Joins` for the prevalent one-query load pattern (`Leave`, `AttendanceCorrection`, `OfficeUser`, `WorkHourUser`).
- Use `Preload` only where the affected repository already establishes it or separate queries are demonstrably needed; current local use is rare.
- Use explicit `Table`/`Select`/`Joins` for report scan structs.
- Avoid per-row repository calls and broad `clause.Associations` preloads.

## Adding/Changing Filters or Pagination

1. Add the external filter key to the controller's `FilterFromQueryString` allowlist.
2. Use `helper.ApplyFilter` only for supported simple suffix operators.
3. Implement date/association/special logic in the repository.
4. Preserve pagination query names and response `total_data` behavior of that endpoint.
5. Validate/allowlist new sort/search columns where possible; inspect the shared helper's string construction.
6. Add query-shape/controller tests.

## Bug Fix Workflow

1. Identify the exact observable behavior and affected layer.
2. Inspect the nearest test and 1–3 similar implementations.
3. Inspect callers and interfaces.
4. Reproduce the root cause, including GORM zero-value/not-found/transaction behavior.
5. Make the smallest focused change.
6. Add a regression test at the lowest useful layer.
7. Run the targeted test/package, then `go test ./...`.

## Refactoring Workflow

Before refactoring, check interfaces, route wiring, all callers, handwritten mocks, tests, API response/status compatibility, GORM SQL behavior, transaction boundaries, external shared-module contracts, table/status/filter spelling, and tenant/authorization behavior. Keep refactoring separate from business behavior changes whenever possible.
