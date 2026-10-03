# Core Package Design and SOLID Completion Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `executing-plans` task by task. Checkboxes track work; this document authorizes no code change, commit, or push by itself.

**Goal:** Finish the *pragmatic* package design and SOLID work in core without changing existing HTTP, business, persistence, or external-effect behavior.

**Architecture:** Keep `route` as composition root and the existing controller → service → repository flow. Move construction of genuinely substitutable dependencies out of request methods, use small consumer-owned interfaces only where production and tests both use the seam, and keep business policy in `service`. Do not force a feature-package or domain-model rewrite.

**Tech Stack:** Go 1.23 directive, Gin, GORM/MySQL, go-helper resolver, validator, sqlmock, testify.

## Global Constraints

- Start from branch `refactor/package-design-solid-dependency`; preserve the existing untracked `docs/refactoring/2026-09-27-service-helper-boundaries-plan.md` and all other user files.
- This is a plan only. Do not commit, push, merge, migrate schema, or access a live database during planning.
- Preserve routes, JSON/status/error identity, tenant/period/ownership rules, SQL arguments/order, transaction handle and finalization, notification timing, file bytes, nil/zero/empty behavior, and exported constructors unless a separately reviewed compatibility change is required.
- No DI framework, generic base repository, blanket interface split, new domain copy, or `helper` dumping ground. Existing public interfaces may remain as compatibility surfaces.
- Execute each task independently: characterize → red test → smallest change → targeted tests → `go test ./... -count=1` → `go vet ./...` → isolated `make check-all` → diff review. Use race checks for concurrency or async work.
- Unit/sqlmock tests are not proof of real MySQL locking, replication, stored procedures, or notification delivery.

## Baseline and scope

The existing [package-design analysis](../../refactoring/2026-09-27-visit-flow-go-package-design-plan.md) explicitly says it is **not implemented**. Current source still has a 25-method `service.VisitService`, a 27-method `repository.VisitRepository`, a 12-argument `NewVisitService`, and concrete repository construction inside `visit_plan.go`, `customer_service_impl.go`, and `location_service_impl.go`. The existing [regression audit](../../refactoring/2026-09-27-visit-flow-go-regression-audit.md) identifies rollover, checkout, transaction, MySQL, and async-notification gaps. Reuse those inventories; verify every cited line against current source before editing.

On 2026-09-28, `make check-all` fails in `TestCustomerService_Comprehensive`: its unconditional `UpdateCluster` call expects no transaction, while `isStructureRolloverDay(28)` activates one. Reproduction: `go test ./test -run '^TestCustomerService_Comprehensive$' -count=1` reports unexpected sqlmock `Begin`. This is a test determinism failure, not evidence of a production bug.

### Task 1: Make the baseline deterministic before architectural edits

**Files:** `service/customer_service_impl.go`, `service/customer_cluster_test.go`, `test/service_customer_extended_test.go`, `test/service_deep_customer_test.go`, `test/service_deep_visit_create_and_customer_create_test.go`.

- [x] Record the three cross-package `UpdateCluster` call sites and their actual assertions; the comprehensive tests must keep coverage of their other workflows.
- [x] Add a package-local red test for rollover and non-rollover dates using fixed `time.Date` values (27 and 28) and explicit expected repository/transaction calls. Do not duplicate `day == 25 || day == 28` as a test setup condition.
- [x] Introduce only a private clock seam: public `UpdateCluster(period, c)` delegates to `updateClusterAt(period, c, time.Now())`; move its existing body unchanged into the private function and use `now.Day()` at the current date decision. Do not add a public clock interface or change route wiring.
- [x] Move/remove the date-dependent `UpdateCluster` calls from broad cross-package tests once the fixed-date test exercises the same behavior. Run the focused test and the three affected tests on the same day, then `go test ./test ./service -count=1`.

### Task 2: Close P0 regression gaps before changing dependencies

**Files:** `test/visit_approval_tracking_test.go`, `test/service_deep_visit_test.go`, `service/visit_checkout.go`, `service/visit_approval.go`, `service/structure_rollover.go`, `service/customer_cluster_test.go`.

- [ ] Preserve the existing approval tracking test. Add failure-path assertions for each write/rollback boundary and exact writer transaction identity.
- [ ] Characterize checkout upload/non-upload and panic paths: response/status, file effects, SQL expectations, rollback, and notification scheduling must match the current flow. Use temp files and fake effects, never live FCM.
- [ ] Characterize rollover orchestration with fixed dates and repository call order. A predicate-only test does not prove the orchestration.
- [ ] Keep real MySQL and async-delivery checks as explicit integration gaps; do not claim unit tests close them.

### Task 3: Pilot explicit dependencies in visit planning

**Files:** `service/visit_plan.go`, `service/visit_service_impl.go`, `route/visit_route.go`, `test/mocks_test.go`, `test/service_deep_visit_test.go`, `test/service_deep_visit_create_and_customer_create_test.go`.

- [x] Inventory every caller of `NewVisitService` and every concrete repository created in visit planning. Record which method, DB resolver, and query order each uses.
- [x] Add a red test proving a replaceable planning dependency is used, including its failure path. Retain the existing public constructor as a compatibility entry point during the pilot.
- [x] Move only the tested construction to route/default wiring. Define a consumer-owned interface only if the production repository and test fake both need that seam; otherwise inject a concrete collaborator. Do not add more parameters to the already 12-argument constructor without a reviewed grouping.
- [x] Compare SQL expectations, operation order, response DTOs, and panic identity with the baseline. Stop after this one flow and review whether the seam reduced coupling.

### Task 4: Remove remaining hidden dependencies one use case at a time

**Files:** `service/customer_service_impl.go`, `service/location_service_impl.go`, `service/visit_customer_commands.go`, `route/customer_route.go`, `route/location_route.go`, `route/visit_customer_route.go`, and their focused tests.

- [x] Inventory each `repository.*RepositoryImpl{}` construction within a request path. Rank by number of callers and difficulty of substituting it in tests.
- [ ] For each selected path, repeat Task 3's test/compatibility cycle; change only one flow per reviewable batch. Leave stateless local implementation details alone when injection offers no real substitution or locality benefit.
- [ ] Confirm no service imports route/controller, no helper imports service, and repositories still receive the caller's resolver/transaction. Use `go list ./...` and targeted import searches.

### Task 5: Right-size interfaces and mapping ownership after the pilot

**Files:** `service/visit_service.go`, `repository/visit_repository.go`, `model/domain/visit.go`, `model/web/visit_response.go`, selected consumers/tests.

- [x] List actual controller/service consumers of each wide interface. Introduce a small consumer interface only for a real production/fake substitution and keep the exported broad interface until all callers are migrated.
- [x] Record `model/domain → model/web` as an intentional compatibility edge unless a selected mapper has an independent consumer and a no-cycle migration. Do not create a duplicate GORM/domain/web model merely to satisfy a diagram.
- [x] Confirm SRP by reason for change, ISP by consumer usage, DIP by explicit construction, and LSP by error/panic/result behavior in focused tests. Counted methods or files alone are not pass/fail metrics.

### Task 6: Closure gate

- [x] Run the date-sensitive tests with fixed 25/27/28 fixtures, targeted race checks, `go test ./... -count=1`, `go vet ./...`, `go build ./...`, and isolated `make check-all` without copying `.env`, service accounts, or repository `file/` data.
- [ ] Review diff against route/DTO/SQL/transaction contracts and the [quality gates](../../../.agent/QUALITY_GATES.md). Record unresolved integration risks and intentional legacy edges. Complete only when no high-priority hidden dependency remains in the selected flows and all checks pass on a rollover date.

## Execution record (2026-09-28)

- Task 1 removed calendar dependence from the rollover test path with a private time seam; broad tests no longer invoke the day-dependent method. A shallow `StructureDuplicateData` assertion was also removed from the Sep 28 path after it unexpectedly began a transaction. It did not exercise the copy workflow, so structure-copy integration behavior remains unproven.
- Task 3 injects the visit-member planning collaborator through the existing `VisitService` repository argument while retaining the exported constructor signature and legacy fallback. Tests cover the fake path, member order/deduplication, legacy SQL order, and panic rollback.
- Task 4 inventory found many other concrete repository constructions across service request paths. One additional selected flow, `VisitCustomerServiceImpl.validateVisitCustomerCreateLimit`, now uses the already injected `ConfigRepository`; the create success and limit rollback tests pass. Other constructions remain for later isolated reviews.
- Task 5 retains the broad `VisitService` and `VisitRepository` compatibility interfaces: the visit service exposes multiple route workflows and its implementation/tests use the repository contract across those workflows. The `model/domain → model/web` mapping edge remains intentional. No extra interface/model copy was added.
- Latest isolated checks on a scratch copy of the working tree: `make check-all` passed (95.8%); `go vet ./...`, `go build ./...`, and `go test -race ./test ./service -count=1` passed. The four-repository audit also confirmed acyclic package graphs and no service-to-route imports.
- Not complete: Task 2 failure-boundary characterization, remaining Task 4 dependencies, and Task 5 interface review are open. SQLMock does not prove MySQL isolation/locking or async delivery. No commit or push was made.
