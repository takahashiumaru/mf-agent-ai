# GORM Conventions

## Version and Initialization

- GORM: `gorm.io/gorm v1.25.10`.
- Driver: `gorm.io/driver/mysql v1.5.1` (indirect dependency used by `go-helper`).
- Initialization: `main.go` → `app.ConnectDatabase` → `go-helper`'s `ConnectMysqlDatabaseResolver`.
- `go-helper` v0.5.9 opens the MySQL source, registers a random-policy read replica with `gorm.io/plugin/dbresolver`, selects Info logging when `DEBUG=true` and Warn otherwise, and configures 10 idle connections, 100 open connections, and one-hour max lifetime.
- `app/database.go` registers `otelgorm.NewPlugin()`.
- Prepared statement mode is not configured.
- `app/database.go` calls `AutoMigrate`, but its model list is empty. It currently performs no schema migration.

## Database Model Strategy

The repository uses domain structs directly as GORM models (strategy A), not separate persistence structs.

`model/domain` contains GORM tags, associations, embedded `gorm.Model`/custom `Model`, table overrides, scan-only report structs, and `ToXResponse` methods. Request/response DTOs remain separate under `model/web`.

Mapping is normally:

`web request → service constructs domain/GORM model → repository persists → domain.ToXResponse() → web response`

Do not add a parallel database model or mapper layer as an incidental change.

## Models, IDs, Tables, and Tags

Two base styles coexist:

- `model/domain/model.go` defines a string primary key plus `CreatedAt`, `UpdatedAt`, and `gorm.DeletedAt`; `Office` embeds it.
- Many models declare a `uint` primary key manually or embed `gorm.Model` (`Presence`, `Meeting`, `MeetingMember`, `LeavePeriod`).

Default GORM pluralization is usual. Explicit overrides exist:

- `Meeting.TableName()` → `visits`.
- `MeetingMember.TableName()` → `visit_members`.
- `AttendanceUser.TableName()` → `attendance_user`.
- `AttendanceUserDeduction.TableName()` → `attendance_user_deduction`.

Observed tags include `primarykey`, `column`, `size`, `type`, `not null`, `default`, `index`, `unique`, `uniqueIndex`, `foreignKey`, `references`, and `constraint`. Representative files: `model/domain/office.go`, `model/domain/leave.go`, `model/domain/leave_category.go`, `model/domain/work_hour.go`, `model/domain/meeting.go`, and `model/domain/presence.go`.

Composite unique indexes are built by repeating the same `uniqueIndex` name across fields, e.g. `idx_leave`, `idx_leave_quota`, `idx_calendar`, and `idx_visit_member`.

## Nullable Fields and Timestamps

Optional values use pointers (`*time.Time`, `*string`, `*float64`, `*float32`, `*uint`, `*bool`). No `sql.Null*` convention was found.

Models use either embedded `gorm.Model`, embedded custom `domain.Model`, or explicit `CreatedAt`/`UpdatedAt`/sometimes `DeletedAt`. Audit IDs are typically `CreatedByID`, `UpdatedByID`, and nullable `DeletedByID`. Services frequently set user audit IDs explicitly.

## Soft and Hard Delete

Delete behavior is module-specific:

- Soft delete examples: `repository/office_repository_impl.go` and `repository/leave_quota_repository_impl.go` set `DeletedByID` and call normal `Delete` where the model has `gorm.DeletedAt`.
- Hard delete examples: leave categories, calendars, work hours, work-hour users, attendance corrections, leaves, and quota-category cleanup call `Unscoped().Delete` in their repositories.
- `LeaveQuota.DeleteByYearCategory` is hard delete, while `LeaveQuota.Delete` is soft delete.

Never infer delete semantics from another module.

## Associations, Joins, and Preload

Associations are declared in domain structs, including office/users, leave/user/category/structure, leave quota/user/category, and work-hour relationships. Repositories predominantly load relations with `Joins("Association")`, for example:

- `repository/leave_repository_impl.go`: `Joins("User").Joins("LeaveCategory").Joins("Structure")`.
- `repository/attendance_correction_repository_impl.go`: `Joins("Office")`.
- `repository/office_user_repository_impl.go`: `Joins("Office")`.

Only one local `Preload` usage was found: `LeaveQuotaRepository.Validate` preloads `LeaveCategory`. `clause.Associations` is not used. Report queries use explicit SQL joins and selected columns. Prefer the affected repository's style and avoid adding broad/unbounded preload chains.

## Create and Batch Operations

Most creates call `db.Create(&model)` and panic on `.Error`. `MeetingMemberRepository.Create` accepts a slice, allowing GORM's multi-row insert. Leave-quota generation chunks slices in batches of 100 and executes `Clauses(clause.OnConflict{DoNothing: true}).Create(&chunk)` in `repository/leave_quota_repository_impl.go`; `CreateInBatches` is not used.

## Update and Zero Values

The dominant pattern is `Updates(struct-or-pointer)` followed by `First` when the updated record is returned. Examples: `repository/office_repository_impl.go`, `repository/leave_repository_impl.go`, and `repository/leave_quota_repository_impl.go`.

Important consequence: GORM `Updates` with a struct skips zero-valued fields. Existing services often construct sparse models specifically to update non-zero fields. Boolean zero writes use pointers in places such as `LeaveQuota.IsActive`. If a task must persist `false`, `0`, `""`, or `nil`, use a pointer field, `map[string]interface{}`, or explicit `Select` only after matching the local method and adding a regression test.

`Save` and `Omit` are not used. Existing `Select` calls are report projections, not partial-update controls. `Update` singular is not an established write pattern.

## Query Patterns

- `First`: ID/single-record reads; errors normally panic.
- `Find`: collections and several single-struct lookups where absence yields a zero value instead of an error.
- `Where`: parameterized filters and structured conditions.
- `Joins`: association loading and explicit reporting joins.
- `Select`, `Table`, `Scan`: report projections.
- `Raw`: recursive structure lookup and stored-procedure calls.
- `Exec`: stored procedures and maintenance updates.
- `Take`, `Scopes`, and `Pluck` are not established in application code.

Filtering starts from controller allowlists using `helper.FilterFromQueryString`, then `helper.ApplyFilter`. More complex date/filter handling is repository-specific. MySQL functions (`DATE_FORMAT`, `DATE_ADD`, `TIMESTAMPDIFF`), CTEs, stored procedures, and `FORCE INDEX` are intentionally used in report repositories.

## Pagination and Sorting

Controllers call external `goHelper.GetPagination`; repositories apply `Limit`, `Offset`, `Order`. Query parameters are `page`, `limit`, `sort`, `ascending`, and `search`. Some methods allow nil pagination; others dereference it. Total count is only returned by selected presence/report flows, and count behavior is not consistent across all list endpoints.

The helper constructs `OrderBy` and search SQL from request values. Preserve the current behavior when making focused changes, but inspect security/allowlisting implications before adding new sortable/searchable fields.

## Transactions

### Simple transaction

```go
tx := service.DB.WithContext(c).Begin()
helper.PanicIfError(tx.Error)
defer helper.CommitOrRollback(tx)
// pass tx to every repository write/read that belongs to the operation
```

Examples: `service/office_service_impl.go`, `service/leave_category_service_impl.go`, `service/work_hour_service_impl.go`.

`helper.CommitOrRollback` recovers a panic, rolls back, and re-panics; otherwise it commits and panics on commit failure.

### Read/write resolver transaction

```go
db := beginWriteResolver(service.DB, c)
defer goHelper.CommitOrRollback(db.Write)
// db.Read and db.Write reference the same writer transaction.
// Pass that transaction to dependent reads and writes.
```

Examples: `service/transaction.go`, `service/meeting_service_impl.go`, `service/attendance_correction_service_impl.go`, `service/leave_hrd.go`.

`beginWriteResolver` starts one source/writer transaction and places the same handle in `Read` and `Write`. Preserve this identity for dependent reads and writes. There is no `WithTx` repository wrapper; the DB/transaction is an explicit method argument. Do not create another resolver lifecycle or nest transactions in a repository.

## Hooks, Locking, and Upsert

- No GORM lifecycle hooks were found.
- Leave and leave-quota approval repositories use `clause.Locking{Strength: "UPDATE"}` to serialize balance/state changes; see `repository/leave_repository_impl.go` and `repository/leave_quota_repository_impl.go`. SQLMock verifies generated query behavior, not live MySQL locking.
- Upsert-like behavior exists only as `clause.OnConflict{DoNothing: true}` for chunked leave-quota creation.
- `Unscoped` is used only for explicit hard-delete paths.

## Error Handling

Repositories typically pass every GORM error to `helper.PanicIfError`. `gorm.ErrRecordNotFound` therefore reaches the global panic handler; `exception/error_handler.go` recognizes it by the message string `"record not found"` and returns HTTP 200 with `success: true`.

One deliberate exception is `LeaveQuotaRepository.Validate`, which ignores `gorm.ErrRecordNotFound` and returns a zero `domain.Leave` as a non-error absence signal.

Duplicate key and foreign-key failures are recognized later by matching MySQL error strings. See `ERROR_HANDLING.md`.

## Repository-Specific Anti-Patterns

- Do not query GORM from controllers.
- Do not use a root/global DB when a service has supplied a transaction.
- Do not use `Save` for partial changes.
- Do not assume struct updates write zero values.
- Do not add runtime `AutoMigrate` models without an explicit schema-deployment decision.
- Do not return domain/GORM models directly as API JSON.
- Do not ignore `.Error` from `Create`, `Updates`, `Delete`, `First`, `Find`, `Raw`, `Scan`, or `Exec`.
- Do not concatenate user values into raw SQL.
- Do not add broad association preloads or N+1 loops without inspecting the reporting/query pattern.
- Do not use `Unscoped` unless hard deletion is explicitly required.
