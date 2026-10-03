# GORM Conventions

## Version and Initialization

- GORM: `gorm.io/gorm` v1.25.4.
- Driver: `gorm.io/driver/mysql` v1.5.1 (indirect dependency used by `go-helper`).
- Read/write routing: `gorm.io/plugin/dbresolver` v1.4.7.
- Tracing: `otelgorm` v0.2.2 installed on the Visit Flow handle in `app/database.go`.

`main.go` loads configuration and calls `app.ConnectDatabase`. That function delegates to `goHelper.ConnectMysqlDatabaseResolver` for both returned handles. The helper opens MySQL, selects Info/Warn logging from `DEBUG`, configures 10 idle/100 open connections with one-hour max lifetime, and registers a random-policy replica.

Prepared statements are not enabled in the visible configuration.

## Model Strategy

The project uses the same `model/domain` structs as GORM persistence models. These structs contain GORM tags/associations and usually `To...Response` methods:

```text
GORM query -> model/domain struct -> To...Response -> model/web DTO
```

There is no separate database-model-to-domain mapper layer. Query projections such as `VisitTemp` and report structs also live in `model/domain`.

## Tags and Table Names

Observed tags include `primaryKey`/`primarykey`, `autoIncrement`, `column`, `size`, `type`, `default`, `not null`, `index`, `uniqueIndex`, priority on composite unique indexes, `foreignKey`, and `references`.

Most table names use GORM's default pluralization. Explicit `TableName()` overrides exist for projections or historical names, including:

- `VisitTemp` -> `visits`
- `VisitMemberTemp` -> `visit_members`
- `ApprovalTemp` -> `approvals`
- `VisitDailyCall` -> `call_daily_visit_all`
- `VisitCallDetail` -> `call_details`
- `MaterCustomerList` -> `master_call_list`

Repositories also use explicit `Table(...)` aliases for joins and views.

## Keys and Nullable Fields

Key strategy varies:

- Many models embed `gorm.Model`, adding a numeric auto-increment `ID` and timestamps.
- Customer/location/product/structure records use string business IDs.
- Numerous models mark period/company/foreign business fields as additional primary or unique keys.

Do not assume `ID` alone defines uniqueness. Inspect tags plus the relevant `OnConflict.Columns` or query `Where` clauses.

Nullable values are represented by pointers in many models. `Structure` uses a nullable GORM timestamp, while some custom models use `*time.Time`; `ConfirmationStatus` declares plain timestamps in addition to embedded fields. Match the local model rather than standardizing.

## Timestamps and Soft Delete

Most mutable models embed `gorm.Model` (`ID`, `CreatedAt`, `UpdatedAt`, `DeletedAt`). They add `CreatedByID`, `UpdatedByID`, and `DeletedByID` audit fields.

Normal `Delete` on these models is soft delete. Repository delete methods often first write `DeletedByID`, then call `Delete`. Some flows intentionally use `Unscoped().Delete` for period rebuilds, mapping cleanup, or other hard deletes. Examples include `repository/structure_location_repository_impl.go` and `repository/product_recommendation_estimation_repository_impl.go`.

Several models define custom timestamps/deleted-at pointers instead of `gorm.Model`; explicit `deleted_at IS NULL` filters may therefore be required. No actual GORM lifecycle hook method was found.

## Associations, Preload, and Joins

Associations declare mainly `foreignKey`, `references`, and `OnUpdate:CASCADE`. No `many2many` tag was found; linking tables are explicit models.

`Preload` is uncommon. Proven examples:

- `repository/visit_product_repository_impl.go`: preloads `Product` with only `id` and `name`.
- `repository/location_location__categories_repository_impl.go`: preloads `Location` and `LocationCategory`.
- `repository/customer_customer_category_repository_impl.go`: preloads `Customer` and `CustomerCategory`.

The double underscore in `repository/location_location__categories_repository_impl.go` is the actual historical filename.

Complex reads more often use explicit `Joins`, `Select`, `Table`, and projection structs. Prefer the nearest query pattern. Avoid broad/unbounded preload chains.

## Create and Batch Operations

- Ordinary creation uses `db.Write.Create(&model)`.
- Batch processes use `CreateInBatches`, commonly with fixed sizes such as 100 or 500.
- Upserts use `Clauses(clause.OnConflict{...}).Create/CreateInBatches` with explicit conflict columns and assignment lists. See `repository/visit_customer_repository_impl.go`, `repository/customer_repository_impl.go`, and recommendation-estimation repositories.

Conflict columns encode business uniqueness; do not change them without checking indexes/schema and callers.

## Update Strategy and Zero Values

The dominant CRUD pattern uses `Updates(&struct)` followed by a read. GORM omits zero-value fields from struct updates. Existing code handles required zero/false/null updates in several ways:

- explicit `map[string]interface{}` assignments, e.g. `VisitRepository.UpdateApproved`;
- building assignment maps for upserts, e.g. customer/location repositories;
- loading the existing record, assigning fields conditionally, then `Save`, used by `VisitCustomerRepository.Update`;
- targeted `Update(column, value)`.

For partial updates, identify whether the API means “omitted” versus an explicit zero/false/empty value. Use a map or explicit selection when zero values must be persisted. Do not use `Save` as a generic partial-update shortcut; only one inspected update flow uses it after loading the full row.

## Delete Strategy

- Standard CRUD entities generally set `DeletedByID` and soft delete.
- Some mapping/batch tables are hard-deleted with `Unscoped()` before replacement.
- Some “delete” behavior is a status transition rather than row deletion, especially business workflows.

Always inspect the service rule and nearest repository before choosing a delete method.

## Query Patterns

- `First` is the usual single-row query and naturally returns `gorm.ErrRecordNotFound`.
- `Find` is used for collections and, sometimes, single projections where absence is accepted.
- `Take` is used in newer estimation repositories that return errors.
- `Where` uses placeholders for values.
- `Select`/`Joins`/`Group` are common for reporting and composite responses.
- `Scan` is used for projections/raw SQL.
- `Raw` and `Exec` are concentrated in batch/report repositories and stored-procedure calls.
- No reusable GORM `Scopes` convention or row locking with `clause.Locking` was found.

Raw SQL values are parameterized with `?`. Some SQL contains fixed schema/table identifiers, such as `SKI_MF_PROD`; do not interpolate request values into SQL strings.

## Pagination, Filtering, and Sorting

Controllers whitelist filter keys through `helper.FilterFromQueryString`. `helper.ApplyFilter` derives the column/operator from those keys and binds values. Supported suffixes include `eq`, `like`, comparisons, `ne`, `in`, and null checks.

Pagination comes from `goHelper.GetPagination`; repositories apply `Limit`, `Offset`, `Order`, and `goHelper.SearchCondition`, then calculate totals. See `repository/location_repository_impl.go`, `repository/visit_repository_impl.go`, and report repositories.

Because filter columns and sort expressions become SQL fragments, never pass arbitrary request keys/order expressions around the existing validation/allowlist mechanism.

## Transactions

The standard service pattern creates a `goHelper.DatabaseResolver`:

```go
tx := goHelper.CreateTransaction(service.DB.WithContext(c), c)
tx.Read = tx.Read.WithContext(c)
tx.Write = tx.Write.WithContext(c)
defer goHelper.CommitOrRollback(tx.Write)
```

The helper starts separate resolver-selected read and write transactions. Repository methods receive `tx` and use `tx.Read` or `tx.Write`. A panic triggers rollback of the write transaction and is rethrown; normal return commits it.

Important caveats:

- The repeated repository code does not explicitly commit/rollback `tx.Read`.
- Some long services explicitly commit `tx.Write`, recreate a resolver, and then defer another commit.
- `service/call_target_service_impl.go` manually begins, rolls back, and commits a GORM transaction.
- A repository-wide read-after-write consistency rule is not clearly established. Existing flows often write through `db.Write` and reload through `db.Read`, which may route to a replica. Do not switch handles speculatively; for consistency-sensitive changes, inspect the nearest workflow and verify `dbresolver` routing/replica-lag expectations with the runtime environment.

Follow the exact surrounding workflow. Do not add nested transactions or mix the base DB into an active multi-write operation.

## Error Handling

Most repository methods call `helper.PanicIfError(result.Error)`. `First` not-found therefore becomes a panic and global middleware maps an error whose text is exactly `record not found` to HTTP 200 with a not-found message. Newer estimation repositories return `error`, and their services translate absence into `ErrorSendToResponse`.

Duplicate and FK errors are matched by middleware using MySQL error text. See `ERROR_HANDLING.md`.

## Repository-Specific Anti-Patterns

- Do not access GORM from a controller.
- Do not ignore `result.Error`.
- Do not use the write handle for incidental reads or the read replica for mutations.
- Do not assume struct `Updates` writes zero values.
- Do not hard-delete with `Unscoped` unless the existing business flow requires it.
- Do not introduce unbounded preloads or N+1 loops where existing joins/batches solve the query.
- Do not concatenate user values into `Raw`, `Exec`, `Where`, or `Order` SQL.
- Do not enable models in startup `AutoMigrate` without a verified schema/migration requirement.
- Do not expose a GORM/domain struct directly as a new HTTP response when an established DTO/mapper exists.
