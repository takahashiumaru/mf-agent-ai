# Database

## Engine and Connection

The service uses MySQL through GORM's MySQL driver. An exact server version is not declared. Configuration supports a write/source DSN and a read-replica DSN. The shared `go-helper` connection registers GORM `dbresolver` with random replica selection.

## Schema Source of Truth

Not clearly established in the current repository.

There are no SQL/Go migration files, migration-tool dependencies, or migration commands. `app/database.go` contains an `AutoMigrate` call with all model entries commented out, so startup currently migrates nothing. Commented references to `before_auto_migrate.sql` and `after_auto_migrate.sql` point to files that do not exist.

Do not treat model tags alone as proof of the deployed schema. Any schema change requires identifying the external operational migration process with maintainers/deployment context.

## Important Tables and Read Sources

Core tables inferred from models and queries:

- `presences`, `presence_historys`: attendance records/history.
- `offices`, `office_users`: workplaces and user assignments.
- `work_hours`, `work_hour_users`: schedules and user assignments.
- `calendars`, `calendar_historys`: work calendars/history.
- `leave_categories`, `leave_periods`, `leave_qouta_categories`, `leave_quota`, `leaves`: leave configuration, balances, and requests.
- `attendance_corrections`: requested attendance corrections.
- `visits`, `visit_members`: meeting/visit records and participants.
- Shared/external tables queried here include `users`, `structures`, and `approvals`.
- Report/read targets include `attendance_user` and `attendance_user_deduction`.

The spellings `presence_historys`, `calendar_historys`, `leave_qouta_categories`, and singular `leave_quota` are present in code/tests and are compatibility-sensitive.

## Important Relationships

- Presence and attendance correction belong to an office; presence also belongs to a user by ID.
- Office-user and work-hour-user are assignment/join records.
- Leave belongs to a user, leave category, company, and structure context; approvals link by content ID in shared tables.
- Leave quota belongs to user/category/company and may reference a leave period.
- Meeting maps to `visits`; meeting members map structures to a visit, period, and company.

See `model/domain/*.go` for tags and `repository/leave_repository_impl.go` / `repository/presence_repository_impl.go` for report relationships.

## IDs

- Offices use string primary keys via `domain.Model`.
- Most local business tables use unsigned integer IDs or `gorm.Model`.
- Meetings/members include additional fields tagged as primary/composite business keys (period, customer/location/company depending on model).
- User IDs are unsigned integers; structure IDs are strings; company IDs are integer/unsigned integer depending on the domain model.

Copy the affected model's types rather than normalizing them.

## Index and Constraint Strategy

GORM tags declare single and composite indexes, including:

- Presence: user/time and time indexes.
- Offices: unique name and coordinate composite index.
- Calendars: company/date uniqueness.
- Work hours: name/start/end/company composite uniqueness.
- Leave: user/category/date composite uniqueness plus status/end/company indexes.
- Leave quotas and assignments: composite uniqueness by their business dimensions.
- Meetings/members: composite visit/member indexes.

Report SQL also assumes deployed indexes by name, including `idx_cal_company_date`, `idx_presences_user_in`, and `idx_leaves_user_date` through `FORCE INDEX` in `repository/presence_repository_impl.go`. Verify the deployed schema before renaming/removing an index.

Foreign-key/association constraints are expressed in several GORM tags, especially audit user associations and office relationships. Because migrations are external/unknown, confirm actual DB constraints before relying on tags.

## Auditing and Deletion

Common fields are `created_at`, `updated_at`, optional `deleted_at`, `created_by_id`, `updated_by_id`, and `deleted_by_id`. Coverage differs by model. Delete repositories often set `DeletedByID` before a soft or hard delete.

## Stored Procedures and Raw Database Logic

Observed stored procedures:

- `sp_regenerate_calendar` (`repository/calendar_repository_impl.go`).
- `updateNameDeptEmpty` (`repository/presence_repository_impl.go`).
- `sp_late_user_deduction_summary` and `sp_late_user_deduction` (`repository/presence_repository_impl.go`).

Leave reports/quota generation also embed MySQL-specific calculations and updates in repository code. Procedure definitions are not present, so behavior beyond call signatures is not clearly established.

## Schema Change Rules

Before changing schema:

1. Inspect the existing domain/GORM struct and all table-name overrides.
2. Inspect repository queries, raw SQL, reports, stored procedures, and external shared-module use.
3. Inspect index/constraint tags and any named `FORCE INDEX` clauses.
4. Inspect domain-to-web mappings and request DTOs.
5. Identify the real external migration/deployment mechanism; none exists locally.
6. Add migration work only through that established mechanism.
7. Update models, queries, mappings, DTOs, and tests together as required.
8. Avoid destructive changes without explicit requirements and recovery planning.

## Performance Considerations

- List/report repositories use Limit/Offset/Order pagination.
- Presence reports use explicit projections, joins, force-index hints, and stored procedures.
- Leave quota creation chunks 100 records and uses conflict-do-nothing.
- Association reads generally use joins; avoid N+1 repository calls and broad preloads.
- Filters often wrap date columns in MySQL functions, while newer presence date-range queries use range predicates; follow the affected query and its tests.
