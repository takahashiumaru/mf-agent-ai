# GORM Conventions

## Version

- `gorm.io/gorm` v1.25.2
- `gorm.io/driver/mysql` v1.5.1
- `gorm.io/plugin/dbresolver` v1.4.7 is indirect and used by `gitlab.com/VNEU/go-helper`'s resolver.

## Initialization

`config.DBConnect` builds a MySQL DSN from typed configuration and calls `gorm.Open(mysql.Open(dsn), &gorm.Config{Logger: newLogger})`.

Observed settings:

- GORM logger writes to stdout.
- Log level is `logger.Info`.
- Slow-query threshold is one second.
- Color output is enabled.
- No prepared-statement option is set.
- No connection-pool limits are configured by local `DBConnect`.
- Startup creates two root connections: one for gateway token checks and one for the local Gin service.

The role-related resolver comes from `go-helper.CreateTransaction`; it applies request context, `dbresolver.Write`/`Read`, and begins two transactions. Local startup does not register replicas itself, so actual read/write routing beyond those clauses is not clearly established.

## Database Model Strategy

Domain and persistence structs are the same objects:

`model/domain GORM struct -> To...Response method -> model/web response DTO`

There is no persistence mapper layer. Raw join projections sometimes scan directly into `model/web` structs. New GORM tags belong on `model/domain` structs under the current architecture, not on `model/web` DTOs.

## GORM Tags

Observed tags include:

- `primarykey` / `primaryKey`
- `unique` and `uniqueIndex:<name>`
- `index` and `index:<name>`
- `size:<n>` and `type:varchar(<n>)`
- `column:<name>`
- `default:<value>`, `not null`
- `foreignKey:RoleID;OnUpdate:CASCADE`

Several audit fields carry empty `gorm:""` tags. Preserve nearby style, but do not assume an empty tag changes behavior.

## Table Names

No `TableName()` methods exist. Normal CRUD relies on GORM default pluralization (`User` -> `users`, `Role` -> `roles`, etc.). Complex queries use explicit `Table("users")`, `Table("user_roles")`, and literal join table names.

## Primary Keys

- Users, roles, and sessions embed `gorm.Model` with `uint ID`.
- `User.CompanyID` is additionally marked as a primary key.
- `UserRole` and `RoleMenuPermission` use composite primary-key tags.
- Refresh UUIDs are application-generated strings using `gofrs/uuid` and are unique but not the GORM primary key.

Inspect the deployed schema before altering keys because no migrations are present.

## Nullable Fields

The code uses pointers (`*string`, `*uint`, `*int`, `*time.Time`) and `gorm.DeletedAt`. No `sql.Null*` or custom nullable type is used. Intentional SQL NULL writes use a map, as in `UpdateNullTelegram`.

## Timestamps and Soft Delete

- `gorm.Model` provides timestamps and soft deletion for `User`, `Role`, and `Session`.
- `Department` explicitly uses `gorm.DeletedAt`.
- `RoleMenuPermission` uses `*time.Time DeletedAt`, not `gorm.DeletedAt`; it does not implement GORM's soft-delete clauses.
- `UserRole` has no `DeletedAt` field.
- Session revocation deliberately uses `Unscoped().Delete`, so session rows are hard-deleted.
- User and role deletes chain an audit-field `Updates(...)` with `Delete(...)`, preserving GORM soft-delete behavior.

## Associations, Joins, and Preload

Associations are declared on `Role` and joined with `Joins("Role")` for role-menu and user-role reads. Complex reporting/login uses explicit SQL joins.

No `Preload`, `clause.Associations`, or many-to-many tag usage was found. Follow the established `Joins` or explicit query pattern; do not add broad/unbounded preload chains without verifying payload and query behavior.

## Select and Omit

`Select(...)` is used for report projections. GORM `Omit(...)` is not used. Update whitelisting through `Select` is not established.

## Create

Normal creates use `Create(&value)` and check `.Error`. `CreateInBatches` is not used. User upsert uses `Clauses(clause.OnConflict{Columns: ..., DoUpdates: clause.Assignments(...) }).Create(&user)`.

## Update and Zero Values

The dominant partial-update pattern is `Updates(structPointer)`. GORM omits zero-value fields in this form.

Consequences:

- Construct a domain struct containing only intended non-zero changes and its ID for ordinary partial updates.
- Use `Updates(map[string]interface{}{...})` when zero or NULL is intentional. `UpdateNullTelegram` uses a map to write `telegram_id: nil`.
- `UpdateAccessToken` uses non-zero `"-"` sentinels to invalidate token/device fields.
- Repository update methods often re-read with `First` before returning.
- `Save` is not used and should not be introduced for partial updates.

## Delete

- Users and roles use GORM soft delete and attempt to write `deleted_by_id` first/in the same chain.
- Role-menu permissions call `Updates(...).Delete(...)` on the composite predicate. Because the model does not use `gorm.DeletedAt`, the delete is hard.
- User roles use the same pattern and are also hard-deleted because their model has no soft-delete field.
- Sessions use explicit `Unscoped().Delete` for revocation and refresh consumption.
- No other `Unscoped` query is present.

## Query Patterns

Observed methods:

- `Where`, `First`, `Find`, `Model`, `Distinct`, `Count`
- `Joins`, `Table`, `Select`
- `Limit`, `Offset`, `Order`
- `Raw`, `Exec`, `Scan`
- `Clauses(clause.OnConflict)`

`Take`, `Scopes`, `Pluck`, `Omit`, `Save`, and `CreateInBatches` were not found.

`First` produces not-found errors; `Find` returns a zero value/empty slice without `ErrRecordNotFound`. The code deliberately uses `FindByIDNonFirst` to detect a missing row by checking `ID == 0`.

## Pagination, Sorting, and Filtering

- Controllers call `goHelper.GetPagination`: query parameters are `page`, `limit`, `sort`, `ascending`, and `search`.
- Repositories apply `Limit`, `Offset`, and `Order`, then count with `goHelper.CalculateTotalPages`.
- Controllers build filters from explicit allowlists such as `name.like`, `company_id.eq`, and `join_date.gte`.
- Local `helper.ApplyFilter` translates operator suffixes and binds the filter value.
- Search and sort SQL are built by the external go-helper library; inspect and constrain inputs before extending this surface.

Important current caveat: `helper.ApplyFilter` reassigns its local `tx` but returns only an error, so callers continue using the original GORM handle; `UserAccessReport` likewise calls `tx.Where(...)` without retaining the returned handle. With GORM v1.25's chainable API, those generic/report filter clauses are not carried into the later query. Tests cover accepted operators but do not assert those SQL predicates. Verify or fix this deliberately when working on filtering; do not assume the apparent filters are effective.

## Transactions

### Plain `*gorm.DB` pattern

User CRUD methods in `service/user_service_impl.go`:

```go
tx := service.DB.Begin()
helper.PanicIfError(tx.Error)
defer helper.CommitOrRollback(tx)
// pass tx to every repository call
```

`helper.CommitOrRollback` recovers a panic, rolls back, then re-panics; otherwise it commits. Commit/rollback errors themselves panic.

### Read/write resolver pattern

Role-related services call `goHelper.CreateTransaction(service.DB, c)`, producing:

- `db.Read`: request-context-bound read transaction with `dbresolver.Read`
- `db.Write`: request-context-bound write transaction with `dbresolver.Write`

The service defers `goHelper.CommitOrRollback` on the handle actually used and repository methods accept `*goHelper.DatabaseResolver`.

The helper begins both handles on every call, but current services complete only the used one. This leaves the sibling transaction lifecycle unresolved in the current pattern. Inspect the dependency implementation and affected tests before adding more resolver-based code; do not add extra unused `Begin()` calls.

### Callback transaction pattern

Login, refresh, and access-token invalidation use:

```go
err := service.DB.Transaction(func(tx *gorm.DB) error {
    // all writes use tx
    return nil
})
```

Returning an error rolls back; nil commits. Refresh replay protection depends on this atomic boundary.

No nested-transaction policy is established. Do not open a new root transaction inside an existing transaction.

## Hooks and Scopes

No GORM model hooks (`BeforeCreate`, `AfterFind`, etc.) or reusable GORM scopes were found.

## Raw SQL

Raw SQL is concentrated in `repository/users_repository_impl.go` for MySQL recursive structure queries and session configuration. Runtime values are supplied as bind parameters. Explicit joins use bound parameters for period/IDs.

Local `helper.RunSQLFromFile` executes semicolon-split statements and is not wired into startup or a migration command.

## Locking and Upsert

- No `clause.Locking` or explicit row lock is present.
- `clause.OnConflict` is used only by `UserRepositoryImpl.InsertUpdateOnDuplicate`, targeting `(id, company_id)` and using an explicit assignment map. `dept` is updated only when non-empty; its deleted-field condition is unusual and should be preserved/tested carefully.

## Batch Operations

No batch insert or batch update pattern was found.

## Error Handling

- Most database errors are immediately passed to a panic helper.
- User lookup by username/email maps `gorm.ErrRecordNotFound` to `exception.ErrUnauthorized`.
- Session lookup maps not-found to unauthorized.
- General `First` errors propagate as their original GORM error and are mapped by message in HTTP middleware.
- Duplicate and foreign-key errors are identified by MySQL error-message substrings in `exception/error_handler.go`.
- Transaction callback errors are checked after `DB.Transaction` and then panicked.

See `ERROR_HANDLING.md`.

## Repository-Specific Anti-Patterns

- Do not call a global/root DB inside an operation that already received a transaction.
- Do not copy the unused preliminary `Begin()` calls found in some role services.
- Do not use `Save` for partial updates.
- Do not assume struct updates persist zero values.
- Do not enable startup `AutoMigrate`.
- Do not leak GORM structs as new response contracts.
- Do not ignore `.Error`.
- Do not concatenate user data into `Raw`, `Exec`, `Where`, search, or sort SQL.
- Do not add N+1 association loops when current code uses joins.
- Do not use `Unscoped` outside explicit hard-delete/revocation behavior.
