# Survey Package Design and SOLID Completion Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `executing-plans` task by task. Checkboxes track work; this document authorizes no code change, commit, or push by itself.

**Goal:** Verify and finish survey package cohesion, dependency ownership, and meaningful Go interfaces without changing survey/report behavior.

**Architecture:** Retain the existing route → controller → service → repository packages. Route composes dependencies, service owns survey upsert and audit policy, repository owns GORM queries, and `helper/survey_id.go` owns only ID/key formatting. Keep the shared core product model contract explicit; do not duplicate it without a proven versioning need.

**Tech Stack:** Go 1.23 directive, Gin, GORM/MySQL, go-helper resolver, validator, sqlmock, testify.

## Global Constraints

- Work from branch `refactor/survey-helper-placement`. This is a plan only: do not commit, push, change schema, or run live DB mutations.
- Preserve `/outlet-surveys` and `/outlet_surveys/all` route spellings, all DTO/JSON fields, tenant/company filter, generated IDs and period, create-versus-update rule, query order, response mapping, panic identity, and transaction calls.
- Do not introduce feature packages, a generic CRUD service/repository, duplicate core product types, a clock interface, or a DI framework without a concrete second consumer.
- Every executable task uses a failing characterization test where a gap exists, then a scoped change, focused tests, `go test ./... -count=1`, `go vet ./...`, isolated `make check-all`, and diff review. SQL mocks do not prove live MySQL isolation or constraints.

## Baseline

The current [architecture guide](../../../.agent/ARCHITECTURE.md) documents manual route composition, service-owned business decisions, and repository methods receiving `*gorm.DB`. The package-level survey key helper is already implemented. Core product domain/response types are imported by `model/domain/outlet_survey_customer_product.go` and `model/web/outlet_survey_customer_product_response.go`; this is a deliberate inter-repo contract, not an import cycle. On 2026-09-28, isolated `make check-all` and `go vet ./...` passed.

### Task 1: Establish the dependency and behavior inventory

**Files:** `route/outlet_survey_route.go`, `route/outlet_survey_customer_route.go`, `route/outlet_survey_customer_product_route.go`, `service/outlet_survey_service_impl.go`, `service/outlet_survey_customer_service_impl.go`, `service/outlet_survey_customer_product_service_impl.go`, `test/service_response_contract_test.go`, `test/router_test.go`.

- [x] Map each route through controller, service, repository, model, and response. Capture company/period filters, generated key, status/error, result order, and exact create/update decision in existing tests.
- [x] Record the current import graph with `go list ./...` and identify any constructor argument unused by its workflow or concrete dependency constructed inside a request. Do not infer a problem from file length alone.
- [x] Add a red test only for a missing contract; run `go test ./test -count=1` before changing the corresponding code.

### Task 2: Keep survey workflow cohesion without a generic CRUD abstraction

**Files:** `service/outlet_survey_service_impl.go`, `service/outlet_survey_mapping.go`, `service/outlet_survey_customer_service_impl.go`, `service/outlet_survey_customer_product_service_impl.go`, `helper/survey_id.go`, `helper/survey_id_test.go`, `test/survey_refactor_test.go`.

- [x] Compare nested `CreateSurveyOutlet` methods: input ID, created/updated audit fields, lookup scope, period semantics, and result mapping. Extract only identical formatting mechanics; leave different upsert policy with the owning service.
- [x] Keep request-to-domain mapping beside the use case when it chooses company, audit, or status values. Move a function to helper only if it is business-neutral, reused with identical semantics, and its package imports remain narrow.
- [x] If a service method contains independent workflow stages, split private functions in that same package. Preserve order and transaction handle, then run `go test ./test -run 'Survey|Customer|Product' -count=1` and package-level helper tests.

### Task 3: Decide interface and cross-repo model ownership by consumer

**Files:** `service/outlet_survey_service.go`, `service/outlet_survey_customer_service.go`, `service/outlet_survey_customer_product_service.go`, `service/outlet_survey_question_service.go`, `service/distributor_service.go`, `service/material_service.go`, corresponding named files in `repository/`, `model/domain/outlet_survey_customer_product.go`, `model/web/outlet_survey_customer_product_response.go`, `test/mocks_test.go`.

- [x] For every interface proposed for change, list production callers, controller/service consumers, and existing fake implementations. Keep interfaces that are actual substitution seams; do not create one for a pure formatter or a single struct.
- [x] Document which core product fields/tags the survey code consumes, plus the pinned module version in `go.mod`. Add a JSON/mapping regression test for those fields before any dependency-version change.
- [x] Retain the shared product types unless an actual ownership/version conflict is reproduced. A local copy would introduce drift and is not a SOLID improvement by itself.

### Task 4: Separate transaction correctness from package tidying

**Files:** `service/outlet_survey_service_impl.go`, `service/outlet_survey_customer_service_impl.go`, `repository/outlet_survey_repository_impl.go`, `test/repository_test.go`, `test/survey_refactor_test.go`.

- [ ] Trace the existing `goHelper.CreateTransaction` read/write handles, context propagation, and finalization in nested create/upsert paths. Assert transaction identity and rollback at each failing write in focused mocks.
- [ ] If reader finalization or read-your-writes is wrong, implement a dedicated transaction fix with real MySQL integration verification when available. Do not silently change resolver semantics during a file/package move.

### Task 5: Closure gate

- [x] Verify acyclic imports, route-owned construction, service-owned policy, repository-owned SQL, no unused new interface, and unchanged shared-core contract.
- [x] Run focused tests, `go test ./... -count=1`, `go vet ./...`, `go build ./...`, and isolated `make check-all`; compare route/JSON/SQL/transaction behavior to Task 1. Record integration gaps explicitly.
- [ ] If Tasks 1–4 find no concrete coupling problem, close this plan with evidence and no additional abstraction. Completion is measured by the stated invariants, not by increasing package count.

## Execution record (2026-09-28)

- Route/service/repository ownership and test contracts were traced. Services use injected repositories; no new interface or package was justified. The `helper` package's broader imports remain existing shared support, while survey ID formatting stays a small business-neutral helper. Nested survey upserts differ in ID, scope, period, and audit policy, so they remain in their respective services.
- Shared core product domain/response types remain pinned by `go.mod` as an intentional contract; tests cover mapping/JSON usage. No source changes were needed.
- Scratch-copy focused/full tests, `go vet ./...`, `go build ./...`, and `make check-all` passed; coverage was 95.4%. Import graph is acyclic.
- Remaining gap: SQLMock cannot prove actual MySQL resolver lifecycle, read-your-writes, constraints, or isolation. No live database integration was run and no commit or push was made.
