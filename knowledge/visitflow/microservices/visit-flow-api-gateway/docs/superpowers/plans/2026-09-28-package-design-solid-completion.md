# Gateway Package Design and SOLID Completion Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `executing-plans` task by task. Checkboxes track work; this document authorizes no code change, commit, or push by itself.

**Goal:** Finish gateway dependency and package boundaries around identity/session, roles, and file handling while preserving both the KrakenD proxy and local Gin API.

**Architecture:** Keep the local route → controller → service → repository flow and the proxy configuration as a separate surface. `route` owns construction; `service` owns identity/session policy and transactions; `helper` owns shared mechanics. Use existing per-instance `UserEffects` for genuine external substitutions instead of adding a container or interface per function.

**Tech Stack:** Go 1.23 directive, Gin/KrakenD, GORM/MySQL, Redis, Firebase, SMTP, validator, sqlmock, testify.

## Global Constraints

- Work from branch `refactor/service-helper-responsibilities`. This is a plan only: do not commit, push, change `configuration.json`, mutate a database, send real email/FCM, or connect to production cache.
- Preserve login/refresh/logout responses, JWT claims, session revocation/replay behavior, sentinel values, role filters, DB write order, panic/error mapping, filesystem bytes, and asynchronous notification timing.
- Keep public constructors and interfaces compatible until every route/controller/test caller is inventoried. No blanket `UserService` split, DI framework, generic repository, plugin registry, or extra adapter with no real consumer.
- For each executable task: characterize → failing focused test → minimal change → targeted tests → `go test ./... -count=1` → `go vet ./...` → isolated `make check-all` → diff review. Use race checks for notification/cache/session concurrency.

## Baseline

The [existing package-design plan](2026-09-27-service-package-design-solid-dependencies.md) records the completed login/session effect seam and deliberately retained Gin/GORM and domain→web coupling. Current source has `service/user_login.go`, `service/user_session.go`, and `service/user_effects.go`; the latter has production helper and test-fake adapters. Role services still have legacy preliminary `DB.Begin()` behavior identified by that plan. On 2026-09-28, isolated `make check-all` and `go vet ./...` passed. A green test does not prove real Redis/Firebase/SMTP delivery or MySQL rollback.

### Task 1: Freeze both HTTP surfaces and identity flow

**Files:** `configuration.json`, `main.go`, `route/users_route.go`, `service/user_login.go`, `service/user_session.go`, `test/user_login_device_test.go`, `test/session_refresh_coverage_test.go`, `test/users_controller_coverage_test.go`.

- [x] Inventory proxy routes separately from local Gin routes. Record login lookup/password failure, device notification scheduling, JWT/session writes, refresh replay/period validation, logout sentinel, cache timing, HTTP response/error fields.
- [x] Add a red regression test for any missing selected behavior before changing its implementation. Keep effects fake and instance-scoped; use local SMTP/HTTP fixtures and no service-account file.
- [x] Run `go test ./test -run 'Login|Refresh|Session|UsersController' -count=1` and targeted race checks. Do not infer delivery from scheduling.

### Task 2: Audit the existing external-effect seam and service interfaces

**Files:** `service/user_effects.go`, `service/user_service_impl.go`, `service/user_service.go`, `repository/users_repository.go`, `repository/session_repository.go`, `route/users_route.go`, `test/user_service_test.go`.

- [x] Confirm production construction uses default `UserEffects` and tests use fakes without process-global replacement. Check FCM, Redis set/invalidate, JWT, and file effects for any remaining hidden construction inside request methods.
- [x] List actual consumers of each `UserService` and repository method. Keep the broad public interface where controller and mocks still use it; add a smaller consumer-owned interface only where two real adapters or an independently testable consumer need it.
- [x] If one hidden effect remains, add a failing test, extend only the existing per-instance seam, and preserve effect order/error identity. Do not add an interface for bcrypt, environment access, or every helper call without evidence.

### Task 3: Isolate role transaction debt as a correctness task

**Files:** `service/role_service_impl.go`, `service/user_role_service_impl.go`, `service/role_menu_permission_service_impl.go`, `repository/role_repository_impl.go`, `repository/user_role_repository_impl.go`, `repository/role_menu_permission_repository_impl.go`, `test/role_services_coverage_test.go`.

- [x] Trace every preliminary `DB.Begin()`, resolver transaction, repository DB argument, commit, and rollback. Record current SQLMock expectations and the exact current panic/status behavior.
- [x] Add a failing test that detects an unused/unfinalized begin without accepting a changed business write order. Change one role operation at a time only after its transaction ownership is proven; review whether an existing transaction helper can be used safely.
- [x] Run focused role tests, `go test -race ./test -run 'Role|Permission' -count=1`, and full gates. If MySQL lifecycle semantics remain uncertain, keep the issue open for a dedicated integration check rather than claiming a structural fix.

### Task 4: Close file/helper package ownership without package proliferation

**Files:** `service/file_service_impl.go`, `service/slow_endpoint_parser_test.go`, `helper/slow_endpoint_parser.go`, `helper/notification_helper.go`, `helper/notification_test.go`, `service/file_service_test.go`.

- [x] Confirm parsing is pure in helper and file access/error mapping stays with its caller. Keep mail/FCM transport out of identity policy, but do not split helper merely because it has several files.
- [x] If an independent consumer or import-cost problem is measured, propose one focused subpackage with its concrete callers and compatibility tests. Otherwise retain existing package layout and document the rationale.

### Task 5: Closure gate

- [x] Verify acyclic imports, route-owned construction, meaningful substitution seams, no new interface without a consumer, and preserved proxy/local API contracts.
- [x] Run `go test ./... -count=1`, `go test -race ./test ./helper -count=1`, `go vet ./...`, `go build ./...`, and isolated `make check-all`; compare HTTP/SQL/Redis/notification timing with Task 1.
- [x] Update architecture/testing guidance only for implemented decisions. Retained Gin/GORM and domain→web edges are explicit compatibility choices, not proof of strict Clean Architecture.

## Execution record (2026-09-28)

- Login/session external effects remain behind the existing per-instance `UserEffects` seam, with production defaults and test fakes. Proxy and local Gin route surfaces were left unchanged. File parsing is pure in `helper`; file I/O and error mapping remain in `service`.
- Removed only four redundant preliminary `DB.Begin()` calls from `Role.FindByID` and `UserRole.Delete`, `FindUserID`, and `UserAccessReport`, in addition to the separately reviewed `Role.FindAll`/`Delete` and `UserRole.FindAll` substeps. Each expectation was changed first and produced a focused failing test before its paired removal. Repository handoff, role filters, response mapping, and resolver finalization were retained.
- Latest scratch-copy checks passed: `make check-all` (95.2%), focused login/refresh/session tests, `go test -race ./test ./helper -count=1`, `go test -race ./test -run 'Role|Permission' -count=1`, `go vet ./...`, and `go build ./...`.
- Remaining integration gap: pinned go-helper `CreateTransaction` opens both read and write handles, while these service operations finalize only the handle they use. SQLMock cannot establish whether the unused handle is harmless with the production resolver/database setup. Keep a dedicated MySQL lifecycle check open; no resolver behavior was changed. No commit or push was made.
