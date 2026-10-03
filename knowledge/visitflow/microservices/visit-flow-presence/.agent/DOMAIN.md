# Domain

## Major Domains

- Presence: employee check-in/out, recognition/geolocation metadata, history, monthly attendance, lateness/deduction reports.
- Offices: office coordinates/radius/address and user assignments.
- Work hours: dated weekly schedules and user assignments.
- Calendar: company work/holiday dates and regeneration.
- Leave: categories, periods, quota configuration, per-user balances, requests, approvals/rejections/cancellation, security entry/exit, reports.
- Attendance correction: corrections to in/out time followed by boss/HR approval and presence create/update.
- Meeting: visit/meeting creation, approvals, selected members, and member check-in/out.

## Domain Entities

Primary writable models are under `model/domain/`: `Presence`, `PresenceHistory`, `Office`, `OfficeUser`, `Calendar`, `WorkHour`, `WorkHourUser`, `LeaveCategory`, `LeaveQoutaCategory`, `LeavePeriod`, `LeaveQuota`, `Leave`, `AttendanceCorrection`, `Meeting`, and `MeetingMember`.

`AttendanceUser`, `TotalAttendanceUser`, `LateDeductionUser`, `AttendanceUserDeduction`, `LateUserDeduction`, `TotalLeave`, and `LeaveDetail` are primarily report/scan models.

User and structure/approval entities are imported from `visit-flow-api-gateway` and `visit-flow-go` rather than redefined here.

## Proven Business Rules

### Leave creation and quota

From `service/leave_service_impl.go`:

- A request is split into one record per full day plus an optional half-day record (`0.5`).
- Full-day end time is start + 24 hours - 1 ms; half-day is start + 4 hours - 1 ms.
- New leave records begin with status `input`.
- Previous-year active quota is consumed before current-year quota.
- A day is marked `paid` when enough active quota exists; otherwise `unpaid`.
- An existing same user/category/start/end record in `input`, `rejected hrd`, `rejected area`, or `cancel` is updated/reused; otherwise a new record and approval are created.
- Leave proof upload is optional and limited to 1 MiB; files are stored under `file/leave/`.
- Update of note/proof is permitted only in `input` or `approved hrd`.
- User cancellation is permitted only in `input` and sets status `cancel`.
- HR cancellation is permitted only in `approved hrd`.
- HR approval sets `approved hrd` and decreases the applicable paid quota; rejection/certain cancellation paths restore quota in the service flow.

Approval routing also depends on shared `visit-flow-go/service.Approval`, employee structure, and `auth.IsMkt`; its full transition algorithm lives outside this repository.

### Attendance correction

From `service/attendance_correction_service_impl.go`:

- Creation starts at `input` and creates a shared approval for the employee's boss.
- Observable statuses are `input`, `approved boss`, `rejected boss`, `approved hrd`, and `rejected hrd`.
- Boss approval routes the approval to the next approver; HR approval writes the corrected attendance into the presence data path.
- Missing boss structure produces a user-facing business error.

### Meetings and members

- Meeting creation sets status `draft`, type `meeting`, derives period as `YYYYMM`, persists to `visits`, and creates a shared approval (`service/meeting_service_impl.go`).
- Member strings are comma-separated and deduplicated. `ALL-<structure>` expands subordinates using a recursive MySQL CTE.
- Member check-in/out validates distance from the meeting location against a fixed 60-meter threshold, and checkout requires prior check-in (`service/meeting_member_service_impl.go`).

### Offices, calendars, schedules

- Office coordinates are uniquely paired by the model index; office name is unique in `model/domain/office.go`.
- Calendar uniqueness is by date/company; work-hour uniqueness combines name/start/end/company.
- Office/work-hour assignment records use composite uniqueness with user and assigned entity.

## Statuses and Transitions

The statuses are string literals, not a centralized enum.

Leave transitions observed locally:

`input → confirm 1 / confirm 2 → approved hrd`

Rejection branches end in `rejected area` or `rejected hrd`; cancellation ends in `cancel`. The exact manager transition may be delegated to `visit-flow-go/service.Approval`, so the complete state machine is not fully local.

Attendance correction:

`input → approved boss → approved hrd`

with rejection branches `rejected boss` and `rejected hrd`.

Meeting request creation begins at `draft`; request validation also recognizes `approved`, `checkin`, `checkout`, `complete`, and `closed`, but local transition implementations for all these states are not present.

## Invariants and Caution Areas

- Leave balance changes, leave status updates, and shared approval updates are intended to occur in one service-owned write transaction.
- Previous-year quota has priority during leave creation.
- Paid leave must have sufficient active quota at the relevant step; unpaid is the fallback during creation.
- Company, user, period, structure, and category dimensions are part of many uniqueness/filter rules.
- Attendance timestamps/reporting deliberately apply Jakarta/UTC+7 transformations in multiple queries/tests.
- Meeting member check-in/out is geofence-sensitive.

Sensitive modules: `service/leave_service_impl.go`, `service/attendance_correction_service_impl.go`, `service/presence_service_impl.go`, `repository/presence_repository_impl.go`, and `repository/leave_quota_repository_impl.go`.

## Terminology

- Presence: attendance/check-in record.
- HRD: human-resources approval stage.
- MKT/non-MKT: employee/company grouping used in calendar and approval behavior.
- Structure/boss code: organizational hierarchy from the shared Visit Flow module.
- NIP: employee identifier used in office-user routes/imports.
- Qouta: existing misspelling used by quota-category code/table/routes; do not rename casually.
- Period: context-dependent year (`YYYY`) or year-month (`YYYYMM`). Inspect the affected model.

Rules not listed here are not clearly established; inspect the relevant service and tests before changing behavior.
