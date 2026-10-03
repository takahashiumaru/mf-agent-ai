# Database

## Database Engine

The application uses MySQL through `gorm.io/driver/mysql`. The server version is not declared in repository configuration. SQL uses MySQL-specific features including `DATE_FORMAT`, `DATE_SUB`, `GROUP_CONCAT`, `FORCE INDEX`, `WITH RECURSIVE`, and `ON DUPLICATE` behavior through GORM `OnConflict`.

`github.com/lib/pq` is imported blank in `config/db.go`, but the active GORM dialector is MySQL; no PostgreSQL connection is used.

## Schema Source of Truth

Not clearly established in the current repository.

- No migration directory or SQL migration files are present.
- No migration library is declared.
- `AutoMigrate` exists only as commented code in `config/db.go`.
- Domain structs contain GORM tags, but startup does not apply them as schema migrations.

Assume the schema is managed externally until the owning migration repository/process is identified.

## Migration System and Location

No migration tool, migration command, naming convention, or migration location is present. Do not invent one inside a feature change.

## Important Local Tables

Inferred from GORM default naming and explicit table references:

- `users`: identity data, hashed password, company/department attributes, device and current token values, employment dates, notification token, soft delete/audit fields.
- `sessions`: single-use refresh sessions and request metadata.
- `roles`: named roles and audit fields.
- `user_roles`: user/role assignments.
- `role_menu_permissions`: role/permission assignments.

Tables queried but not modeled comprehensively here include `companies`, `structures`, `structure_positions`, `departments`, and `user_departments`. Their schemas are external assumptions visible in raw/join queries.

## Important Relationships

- `roles.id` -> `user_roles.role_id` through `Role.UserRole` and `Joins("Role")`.
- `roles.id` -> `role_menu_permissions.role_id` through `Role.RoleMenuPermission` and `Joins("Role")`.
- `users.id` -> `sessions.user_id` logically; the struct has an index but no explicit association tag.
- Access reporting joins `user_roles`, `role_menu_permissions`, `user_departments`, `users`, and `departments` in `repository/user_role_repository_impl.go`.
- Login joins `users`, `companies`, `structures`, and `structure_positions`, then uses recursive `structures` CTEs.

## Index Strategy

Observed GORM tags and SQL assumptions include:

- `users`: composite-named unique index `idx_users` is attached to `UserName`, `Email`, and `CompanyID`; `CompanyID` is also marked primary key. Confirm the deployed schema before changing this unusual key/index combination.
- `sessions.refresh_uuid`: unique; `sessions.user_id`: `idx_sessions_user_id` and non-null.
- `roles.name`: unique index; `roles.description`: `idx_description`.
- `user_roles`: composite primary-key fields and individual named indexes `idx_role`/`idx_user`.
- `role_menu_permissions`: composite primary-key fields and indexes `idx_role`/`idx_permission`.
- `departments.deleted_at` and `role_menu_permissions.deleted_at`: indexed.
- Login SQL forces `companies_id_index`; this index must exist in the external schema.

Whether the deployed schema exactly matches every GORM tag is not established because migrations are absent.

## Foreign Keys

`Role` declares `foreignKey:RoleID;OnUpdate:CASCADE` associations. Other relationships are expressed in join SQL or naming conventions. Actual database foreign-key definitions are not available.

The HTTP error mapper recognizes MySQL error 1451 for parent-row delete/update restrictions, so deployed foreign keys exist somewhere, but their complete set is not established.

## IDs

- `gorm.Model` supplies auto-increment-style `uint ID` for users, roles, and sessions.
- `User.CompanyID` is additionally marked `primarykey`, making the model key declaration unusual/composite.
- `UserRole` uses `(RoleID int, UserID int)` as a composite primary key.
- `RoleMenuPermission` uses `(RoleID string, PermissionID string)` as a composite primary key, even though service/controller inputs represent role ID as `int` before conversion.
- Session refresh identity is a generated UUID string with a unique constraint.

## Auditing Fields

- `gorm.Model` adds `CreatedAt`, `UpdatedAt`, and `DeletedAt`; `Role` redundantly declares `CreatedAt`/`UpdatedAt` again.
- Models commonly add `CreatedByID`, `UpdatedByID`, and `DeletedByID`.
- `RoleMenuPermission` has custom `*time.Time DeletedAt` rather than `gorm.DeletedAt`; this does not install GORM's soft-delete callbacks.
- `UserRole` has no `DeletedAt` field in its Go struct. Current GORM deletes for both assignment models are therefore hard deletes, even though related-table report joins explicitly filter other tables' `deleted_at` columns.

## Schema Change Rules

Before any schema change:

1. Identify the external schema/migration owner; none exists here.
2. Inspect the relevant `model/domain` struct.
3. Inspect repository queries, including raw SQL and explicit column names.
4. Inspect indexes, composite keys, and constraints in the deployed schema/migration source.
5. Inspect domain-to-web mapping and DTOs.
6. Add the migration in the actual owning system using its convention.
7. Update this repository's model/query/DTO/tests as required.
8. Avoid destructive operations without explicit authorization and a rollback plan.

## Performance Considerations

- List repositories use `Limit`, `Offset`, `Order`, and a separate count query via go-helper.
- Login hierarchy queries use MySQL recursive CTEs and `GROUP_CONCAT`; one flow raises `group_concat_max_len` for the session.
- Login intentionally runs the normal and MR hierarchy queries concurrently before opening the write transaction.
- Role/permission repositories use GORM association joins; access reports use explicit joins.
- Batch create/update is not present.
- Large `Preload` chains are not used; do not introduce them without checking query size and established join behavior.
