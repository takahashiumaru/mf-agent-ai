# Database

## Engine and Connections

The service uses MySQL through GORM. The exact server version is not declared.

`go-helper` configures one source DSN and one replica DSN per GORM handle using `dbresolver`. `app.ConnectDatabase` returns a Visit Flow database and a second handle named `skiDatabase`; selected routes use both.

## Schema Source of Truth

Not clearly established in the current repository.

- No SQL migration directory, Goose/golang-migrate/gormigrate dependency, or migration command was found.
- `app/database.go` calls `AutoMigrate`, but all listed models are commented out, so the active call has no models.
- `helper/sql.go` can execute SQL files, but the only bootstrap references to before/after migration SQL are commented and those files are absent.

Therefore, do not claim that application startup or repository migrations control the production schema. Establish the operational schema process with maintainers before a schema change.

The owning team/system, schema artifact location, approval path, deployment order, and rollback procedure are not clearly established in the current repository. A schema-changing task is blocked on obtaining those facts; do not invent an in-repository migration workflow.

## Important Tables and Relationships

Major table/model groups visible in source:

- `companies` -> areas, structures, structure locations/positions/cities, locations and categories.
- `structures` -> users from the API Gateway model, boss hierarchy, assigned cities/locations, period/company scope.
- `customers` and `locations` -> `customer_locations`; categories use explicit mapping tables.
- `visits` -> `visit_members`, `visit_products`, `visit_api_logs`, and approval content references.
- `visit_customers` -> period/structure/customer/location master-list planning and coverage.
- `approvals` and `confirmation_statuses` -> ordered approval workflow.
- `configs` -> database-configured thresholds and flags.
- report tables/views such as `call_daily_visit_all`, `call_details`, and `master_call_list`.
- recommendation-estimation, dashboard, target, history, and HTML/report support tables.

Relationships are expressed through a mixture of GORM tags and explicit joins; database foreign-key definitions cannot be confirmed without external schema/migrations.

## IDs, Indexes, and Constraints

- Many entities embed `gorm.Model` with numeric IDs.
- Customer/location/product/structure identifiers are frequently strings with fixed sizes.
- Period (`YYYYMM`), company, structure, customer, and location columns commonly participate in composite uniqueness.
- Tags declare numerous single/composite `index` and `uniqueIndex` definitions.
- `OnConflict` clauses explicitly identify business keys for batch/upsert paths.

Because startup AutoMigrate is effectively empty, GORM tags describe intended mappings but do not prove production indexes. Verify the actual schema before performance or constraint changes.

## Auditing and Deletion

Common audit fields are `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, and `deleted_by_id`.

Most `gorm.Model` entities are soft-deleted. Repositories often update `deleted_by_id` first. Batch rebuilds and mapping cleanup sometimes use `Unscoped` hard deletion. Some custom models use `*time.Time` for deleted-at and explicit null filters.

## Stored Procedures, Views, and Cross-Schema Data

The repository invokes stored procedures such as visit report processing and MCL summary through parameterized `CALL ... (?)`. Reporting models map nonstandard table/view names through `TableName()`.

`repository/visit_customer_repository_impl.go` contains cross-schema reads from fixed `SKI_MF_PROD` tables. Changes require checking availability/permissions in every deployment database.

## Schema Change Rules

Before adding/changing a column or table:

1. Confirm the real production migration/source-of-truth process outside this repository.
2. Inspect existing table constraints and stored procedures/views.
3. Inspect the corresponding `model/domain` struct and its nullable/timestamp convention.
4. Search all repository queries, raw SQL, `Select`, scans, upserts, and reports that name the column.
5. Inspect request/response DTOs and `To...Response` mapping.
6. Preserve composite unique keys, tenant fields, and audit behavior.
7. Add the schema change through the verified external mechanism; do not merely uncomment `AutoMigrate`.
8. Add focused tests and run broader tests.
9. Avoid destructive changes unless explicitly required and reviewed.

## Performance Patterns

- Read replicas via `dbresolver`.
- Pagination with limit/offset and total calculation.
- Explicit selected columns for some preloads/projections.
- Joins for relation-heavy listing to avoid repeated lookups.
- Batch inserts/upserts with sizes such as 100/500.
- Index tags on period, structure, customer, location, status, schedule, and names.
- Stored procedures/raw set-based updates for report and batch processing.

No formal query latency, table-size, or coverage target is documented. Inspect execution plans and the real schema for high-volume changes.
