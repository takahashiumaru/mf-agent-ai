# Service Readability Refactor Implementation Plan

**Goal:** Make every `service/` implementation easier to read by extracting cohesive functions while preserving existing API, business rules, persistence effects, and error behavior.

**Architecture:** Keep the existing `service` package, exported interfaces, constructors, route wiring, and repository boundaries. Each public service method remains the readable workflow entry point; private functions own one named calculation, mapping, validation step, or side effect. Split only the large implementations into files by workflow, within the same package.

**Tech Stack:** Go 1.23, Gin, GORM/MySQL, validator, existing Testify and sqlmock tests.

## Global constraints

- Execution was authorized after plan review. Leave every change uncommitted, as requested.
- No change to routes, DTO JSON, status strings, error types/text, response ordering, filter semantics, SQL shape, query count, transaction boundaries, read/write handles, or notification timing as part of a mechanical extraction.
- Preserve company/user/structure scope, file naming and upload limits, timezone conversions, soft/hard delete semantics, and the existing `qouta` spelling.
- Keep a method's validation and transaction ownership visible at its top level. Pass the existing transaction/DB handle into private functions; never open a second transaction inside an extracted function.
- Avoid generic base services, new public interfaces, new dependencies, and one line wrappers. Prefer names that explain domain intent.
- A discovered bug requiring changed behavior becomes a separately reviewed change with its own regression test, not an incidental part of this refactor.

## Baseline and acceptance

- As of 2026-09-24, `go test ./...` passes. The `service` package itself has no local tests; relevant service tests live in `test/`.
- For each task: run the named focused tests, `go test ./...`, `go vet ./...`, and `gofmt` on touched files. Compare the public signatures and `git diff` before moving to the next task. Where a workflow includes a transaction, assert the existing begin/write/commit/rollback sequence in a behavior test before extraction.
- A stage is accepted when reviewers can read each public method as a short sequence of business steps; private functions have a single reason to change; no behavior or test expectation has been weakened; and the checks above pass.
- Preserve the current uncommitted state. No commits are part of this plan.

## File map and implementation order

### Task 1: Characterize complex behavior before extraction

**Files:** Add focused cases beside existing `test/leave_service_*test.go`, `test/presence_service_*test.go`, `test/attendance_correction_*service*test.go`, `test/meeting_member_service_coverage_test.go`, `test/user_csv_service_coverage_test.go`, and `test/leave_quota_service_process_coverage_test.go` only where the scenario is not already covered.

- [ ] Record observable inputs, responses, repository calls, and failure behavior for leave creation (full/half day, prior/current quota, existing leave reuse), every manager/HR decision, correction HR approval with presence history, check-in/check-out, Pondasi merge, CSV replacement, and yearly quota processing.
- [ ] Add only missing high-value regression cases: transaction rollback after a downstream panic, half-day quota selection, merge precedence/time conversion, CSV empty/malformed row behavior, and approval/status transitions. Use in-memory notifications or mocks; no live DB or real external delivery.
- [ ] Run each new focused case and the full suite before any production edit. Capture failures as baseline issues; do not change behavior to make a characterization test pass.

### Task 2: Compact CRUD services

**Files:** `service/office_service_impl.go`, `service/work_hour_service_impl.go`, `service/leave_category_service_impl.go`, `service/leave_period_service_impl.go`, `service/leave_qouta_category_service_impl.go`; test in `test/crud_services_coverage_test.go` and the matching service coverage files.

- [ ] Keep simple reads/deletes inline. Extract repeated, meaningful request-to-domain construction into private `newOfficeForCreate`, `officeForUpdate`, `newWorkHourForCreate`, and corresponding domain-specific builders only when they remove substantial method body and keep zero-value semantics visible.
- [ ] Preserve each constructor, interface method, validation point, transaction call, and repository call. Do not introduce a shared CRUD abstraction.
- [ ] Check create/update response mapping, validation failure, zero values, and delete call scope through existing tests, then run the full gates.

### Task 3: CSV assignments and calendar

**Files:** `service/office_user_service_impl.go`, `service/work_hour_user_service_impl.go`, `service/calendar_service_impl.go`; create `service/office_user_csv.go`, `service/work_hour_user_csv.go`, and `service/calendar_csv.go` if extraction materially shortens the entry methods. Tests: `test/user_csv_service_coverage_test.go`, `test/calendar_repository_coverage_test.go`, and a focused calendar service case.

- [ ] Extract `parseOfficeUserCSV` and `parseWorkHourUserCSV` as private parsers returning ordered assignments and user IDs. Keep file close/error behavior, header handling, whitespace rules, duplicate rows, and parsing errors identical.
- [ ] Let `UploadCsv` visibly perform parse → delete previous assignments → create replacements → response mapping under the same transaction. Do not batch writes or move parsing outside the transaction in this task.
- [ ] Extract `parseCalendarCSV` and `replaceCalendarDates` while preserving the current per-row delete order, company scope, returned first item, and failure behavior. Record the empty-input risk separately rather than changing its response contract during extraction.
- [ ] Check valid, malformed, duplicate, and empty inputs against the baseline; run the full gates.

### Task 4: Quota processing

**Files:** `service/leave_quota_service_impl.go`; create `service/leave_quota_processing.go` for nontrivial extracted logic. Tests: `test/leave_quota_service_coverage_test.go` and `test/leave_quota_service_process_coverage_test.go`.

- [ ] Extract private `buildQuotasForMembers` from `Create`, preserving split/parse behavior, member order, and `countData` semantics.
- [ ] Extract `processQuotaForYear` for the repeated delete/find/create sequence. Keep `ProcessQuota` responsible for selecting current year and December next year; keep `Process`'s existing no-delete behavior.
- [ ] Leave `UpdateNonActive` as its own workflow and extract a named regulation lookup only if it clarifies its decision. Preserve `db.Read`/`db.Write` use and current dates.
- [ ] Verify December and non-December call sequences, rollback, and output count; run the full gates.

### Task 5: Meetings and member location rules

**Files:** `service/meeting_service_impl.go`, `service/meeting_member_service_impl.go`; create `service/meeting_members.go` if needed. Tests: `test/meeting_member_service_coverage_test.go` and a meeting creation service case.

- [ ] In meeting creation, extract `buildMeeting`, `buildMeetingApproval`, and `expandMeetingMembers` so the public method shows lookup → meeting create → approval create → member create → notification. Keep member deduplication and `ALL-` expansion order intact.
- [ ] In check-in/out, extract a private location check and separate domain update builders. Keep the distinct check-out prerequisite, 60-meter boundary, exact error text, and UTC fallback times.
- [ ] Preserve the current transaction and notification scheduling. Log the request-context goroutine risk for a separate fix; do not silently change delivery timing here.
- [ ] Verify member expansion, radius edge, check-out-before-check-in, rollback, and responses; run the full gates.

### Task 6: Presence and Pondasi merge

**Files:** `service/presence_service_impl.go`; create `service/presence_create.go`, `service/presence_pondasi.go`, and `service/presence_location.go` as cohesive files. Tests: `test/presence_service_test.go`, `test/presence_service_query_coverage_test.go`, plus focused create/merge service cases.

- [ ] In `Create`, extract `resolvePresenceOffice`, `buildCheckInPresence`, and `buildCheckOutPresence`. Keep regulation lookup, office mapping/radius decision, Jakarta date lookup, existing-record decision, and write transaction order unchanged.
- [ ] In `FindByUserAndDate`, extract Pondasi retrieval/parsing and a pure merge function that takes ERP/Pondasi records and returns the same response order. Preserve `Masuk`/out mapping, seven-hour conversion, duplicate handling, and fallback for empty sources.
- [ ] Move existing parsing/distance functions to the owning cohesive file without changing exported names (`ParsePondasiPresence`, `ParsePondasiTime`, `ParseFloatValue`, `CheckIsInOffice`, `CalculateDistanceBetweenLocations`). Preserve current external API error handling as behavior; record ignored errors separately.
- [ ] Verify check-in vs check-out, missing office, radius boundary, timezone/duplicate merge, and Pondasi parsing; run the full gates.

### Task 7: Attendance correction approvals

**Files:** `service/attendance_correction_service_impl.go`; create `service/attendance_correction_approval.go` and `service/attendance_correction_presence.go`. Tests: `test/attendance_correction_approval_coverage_test.go`, `test/attendance_correction_service_coverage_test.go`.

- [ ] Extract correction model builders for create/update and separate approval construction/updating from the boss and HR handlers. Keep each public transition explicit; do not hide the four status decisions in a generic status engine.
- [ ] Extract `applyApprovedCorrectionToPresence` from `UpdateApprovedHrd`: preserve lookup, history creation before update, create-if-absent branch, seven-hour date lookup, and use of `tx.Write`.
- [ ] Keep the exact panic/error mapping, approval identity, FCM arguments, and timing. Record raw goroutine/request-context and nil-token risks for separately reviewed fixes.
- [ ] Verify boss approve/reject, HR approve/reject, presence history, create-if-absent, rollback, and response shapes; run the full gates.

### Task 8: Leave creation and transitions

**Files:** `service/leave_service_impl.go`; create `service/leave_create.go`, `service/leave_quota_allocation.go`, `service/leave_approval.go`, and `service/leave_notification.go` only where they hold cohesive logic. Tests: `test/leave_service_*test.go`.

- [ ] Split `Create` into named steps: proof file preparation, category/quota lookup, day allocation, existing leave reuse or create, approval creation, and notification scheduling. Keep each day's full/half-day end time, prior-year quota priority, unpaid fallback, period/flag selection, write order, and returned last leave identical.
- [ ] Keep `UpdateCanceled`, `UpdateCanceledHrd`, manager approve/reject, HR approve/reject, and security entry/exit as separate entry points. Extract repeated approval lookup/update and quota adjustment only where the inputs and effects are truly identical; do not collapse distinct transition rules.
- [ ] Keep report/validate methods small unless a real calculation can be named. Preserve their filters and `db.Read`/`db.Write` choices.
- [ ] Treat proof files and async notifications as external effects. Do not move them across the transaction's commit boundary during readability extraction. Record file cleanup and notification timing concerns as separate behavior changes.
- [ ] Verify validation, upload limit/path, full/half days, quota priority and restoration/consumption, every status text, approval endpoints, rollback, and response mapping; run the full gates.

### Task 9: Final review of the entire folder

**Files:** All 14 `service/*_service_impl.go`, their 14 public interface files, new cohesive service files, and affected `test/` files.

- [ ] Compare each exported interface/constructor before and after. Confirm no route/controller/repository/model changes were pulled into the refactor and no new dependency was added.
- [ ] Read every public service method top to bottom. Remove helpers that merely rename one line or force readers to jump files without clarifying intent. Keep names domain-specific and parameters explicit.
- [ ] Run `gofmt` on touched Go files, focused tests, `go test ./...`, and `go vet ./...`; run configured lint if available. Review `git diff --check` and the diff for status, tenant, context, transaction, query, file, and notification drift.
- [ ] Report any baseline or environment failure with the exact command and output. Leave changes uncommitted for review.

## Risks to keep separate from readability work

- Attendance correction and meeting use goroutines that capture `*gin.Context`; changing them requires a notification lifecycle decision and focused behavior tests.
- Presence ignores a Pondasi API error in `FindByUserAndDate`; changing fallback/error behavior is an API decision.
- Calendar CSV indexes `records[1:]` and returns index 0 of the response; empty/malformed file handling needs a separate contract decision.
- Leave proof file writes and async notifications are not rolled back by the database transaction. A delivery/cleanup redesign is a separate task.
- Broad changes to read-replica choices, query batching, SQL, zero-value update behavior, or auth scope require their own evidence and tests.

## Execution record — 2026-09-24

- Tasks 1–8 were implemented and reviewed by domain. The three already-compact services (`leave_category`, `leave_period`, `leave_qouta_category`) stayed inline; their public methods did not need extra helper jumps.
- Task 9 review found no production behavior regression. Public presence create and quota processing success/rollback tests were added after final review identified coverage gaps.
- Final checks: `go test ./...`, `go vet ./...`, `go build ./...`, `gofmt -l service/*.go test/*.go`, and `git diff --check` passed. `make lint` could not load the repository's older `.golangci.yml` with the installed golangci-lint v2.13.2. Generated untracked leave test images were removed after the final test run.
- All source, test, and plan changes remain uncommitted.
- Follow-up: all Go tests now live under `test/`. Service-private helper tests were replaced with public workflow tests; `make cover` passes with 97.7% total statement coverage.
