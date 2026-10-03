# Presence Package Design and SOLID Completion Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `executing-plans` task by task. Checkboxes track work; this document authorizes no code change, commit, or push by itself.

**Goal:** Close the remaining package/dependency evidence gaps in presence while preserving attendance, leave, meeting, and office behavior.

**Architecture:** Keep the current layer packages and `service` as business/transaction owner. Keep Pondasi transport/parsing in `internal/pondasi`, generic mechanics in `helper`, and manual construction in `route`. Introduce or split an interface only for a demonstrated consumer and alternative adapter.

**Tech Stack:** Go 1.23 directive, Gin, GORM/MySQL, go-helper resolver, validator, sqlmock, testify, Pondasi HTTP client.

## Global Constraints

- Work from branch `refactor/presence-helper-boundary`; preserve the existing deleted/untracked PNG files under `test/file/leave/` as user state. This is a plan only; do not commit, push, or mutate a live DB.
- Preserve route/JSON/status/error identity, leave quota and approval transitions, company/user/period scope, transaction handle and locks, Pondasi fallback, and notification order. Do not move business decisions into `helper` or `internal/pondasi`.
- No feature-package split, generic repository, DI framework, redundant interfaces, new model layer, or global error migration merely to claim SOLID compliance.
- For each executable task: red regression test → minimal change → focused package tests → `go test ./... -count=1` → `go vet ./...` → isolated `make check-all`; run race checks for concurrent/client work. SQL mocks do not prove MySQL locking or live Pondasi behavior.

## Baseline

The existing [package-design plan](2026-09-27-service-package-design.md) and [SOLID re-audit](../../audits/2026-09-27-solid-patterns-reaudit.md) document the completed service/Pondasi extraction. Current source has narrow `UserLookup` and `OfficeUserLookup` seams in `service/presence_service_impl.go`, a typed Pondasi client in `internal/pondasi`, and a helper package without service/domain imports. This is a pragmatic layered design, not framework-independent Clean Architecture. On 2026-09-28, isolated `make check-all` and `go vet ./...` passed; this is not proof of every state transition or MySQL isolation.

### Task 1: Freeze the observed contracts

**Files:** `test/presence_workflow_test.go`, `test/leave_hrd_integrity_test.go`, `test/presence_pondasi_workflow_test.go`, `internal/pondasi/client_test.go`, `.agent/TESTING.md`.

- [x] Record representative attendance check-in/out, leave create/manager/HRD/cancel, office selection, and Pondasi fallback cases with exact status/response fields and repository calls.
- [x] Add a failing regression only for an observed missing invariant before changing its flow. Prioritize quota debit/refund, status retry, same-writer transaction identity, and Pondasi parse/fallback errors.
- [x] Run `go test ./test ./internal/pondasi -count=1` and `go test -race ./test ./internal/pondasi -count=1`; preserve temporary-file and local-HTTP isolation.

### Task 2: Audit constructor and interface ownership

**Files:** `service/presence_service_impl.go`, `service/leave_service_impl.go`, `service/meeting_service_impl.go`, `service/user_lookup.go`, `route/presence_route.go`, `route/leave_route.go`, `route/meeting_route.go`.

- [x] Trace each constructor argument to methods that actually use it. Confirm every repository/client/status function is constructed in route wiring, not inside request methods.
- [x] For each interface, name its consumer and at least the production implementation plus the test fake. Retain `UserLookup`/`OfficeUserLookup` while they serve real substitutions; remove only an interface proved unused after compiling every caller.
- [x] If a hidden dependency remains, add a focused red test and move only that construction to the owning route. Preserve exported constructor compatibility where external Go callers may exist.
- [x] Check `go list ./...` and import direction: `route → controller → service → repository`; `service → helper/internal/pondasi`; no reverse import or cycle.

### Task 3: Verify cohesion where business and transport meet

**Files:** `service/presence_pondasi.go`, `internal/pondasi/client.go`, `internal/pondasi/parse.go`, `service/leave_notification.go`, `helper/csv.go`, `service/office_user_csv.go`.

- [x] Keep HTTP request, envelope decoding, and primitive parsing in Pondasi; keep ERP merge, absence policy, office choice, leave notification decisions, and transaction ownership in service.
- [x] Compare each shared helper's callers. Extract only mechanics reused with the same semantics; do not move quota/status/tenant logic into helper because it is pure or short.
- [x] If a file has multiple independent reasons to change, split it by workflow inside the current package first. Re-run its caller tests; do not create a new package without an independent consumer or stable interface.

### Task 4: Resolve transaction evidence separately from package moves

**Files:** `service/transaction.go`, `service/leave_hrd.go`, `service/leave_quota_allocation.go`, `repository/leave_repository_impl.go`, `repository/leave_quota_repository_impl.go`, `test/leave_hrd_integrity_test.go`.

- [x] Map begin/read/write/commit/rollback and row locks for HRD approval, rejection, and cancellation. Assert the exact writer handle and failure behavior in sqlmock tests.
- [ ] Treat resolver redesign, real MySQL lock/isolation checks, and notification-after-commit changes as separate correctness work, not mechanical SOLID cleanup. Record any unverifiable live behavior as an explicit gap.

### Task 5: Closure gate

- [ ] Confirm all selected dependencies are explicit at route wiring, interfaces correspond to real consumers, package imports remain acyclic, and each workflow has one clear transaction owner.
- [x] Run focused tests, `go test ./... -count=1`, `go test -race ./test ./internal/pondasi -count=1`, `go vet ./...`, `go build ./...`, and isolated `make check-all`. Review route/DTO/SQL/error diffs and preserve all pre-existing worktree files.
- [ ] Update architecture/testing guidance only for decisions actually implemented. Completion means the inspected flows satisfy the criteria, not that every theoretical SOLID interpretation or production integration has been proven.

## Execution record (2026-09-28)

- Existing package boundaries and narrow `UserLookup`/`OfficeUserLookup` seams have concrete consumers. Route constructors supply repositories and the Pondasi client; service request methods do not construct concrete repositories. No package split or extra interface was justified.
- Existing workflow tests cover attendance, leave transitions, office selection, Pondasi fallback, quota/status paths, rollback, and writer identity. No missing unit-test invariant requiring a behavior change was identified.
- Scratch-copy `make check-all`, `go vet ./...`, `go build ./...`, `go test ./test ./internal/pondasi -count=1`, and `go test -race ./test ./internal/pondasi -count=1` passed; coverage was 97.9%. Package imports were acyclic.
- Remaining gap: live MySQL locking/isolation and resolver read-handle lifecycle are not established by SQLMock. No source behavior was changed in this repository. Pre-existing deleted/untracked leave PNG worktree state was preserved; no commit or push was made.
