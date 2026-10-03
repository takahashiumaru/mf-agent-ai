# Tenant Query Safety Implementation Plan

> **For agentic workers:** Execute inline with test-driven development. Do not commit, amend, or push.

**Goal:** Preserve successful endpoint response data and JSON while preventing cross-company composite-ID access, stale city datasets, and replica-stale update responses.

**Architecture:** Keep the existing controller/service/repository flow. Pass authenticated company IDs into affected repository reads and writes, add them as independent SQL predicates, keep the existing exact composite-ID predicate, and reload dependent writes through `db.Write`. Restore the pre-cache behavior for structure-city data by rebuilding the existing JSON file from the same query on every call.

**Tech Stack:** Go 1.23, GORM 1.25, MySQL, `testing`, `testify`, `go-sqlmock`.

## Global Constraints

- Do not change response DTOs, JSON tags, status codes, successful-row ordering, or null/empty behavior.
- Do not change schema, migrations, auth parsing, or unrelated repositories.
- Do not commit, amend, or push.
- Preserve parameterized SQL and the current panic/error middleware contract.

---

### Task 1: Enforce authenticated company scope

**Files:**
- Modify: `repository/public_id_scope.go`
- Modify: `repository/customer_location_repository.go`
- Modify: `repository/customer_location_repository_impl.go`
- Modify: `repository/structure_location_repository.go`
- Modify: `repository/structure_location_repository_impl.go`
- Modify: `service/customer_location_service_impl.go`
- Modify: `service/structure_location_service_impl.go`
- Modify: `service/visit_service_impl.go`
- Modify: affected mocks/tests under `test/` and `repository/query_compatibility_test.go`

- [x] Write SQLMock tests proving URL suffix company `2` cannot replace authenticated company `1`; expected SQL always contains `company_id = 1` plus the exact composite-ID predicate.
- [x] Run the focused tests and confirm failure because current scopes derive company from the URL or signatures lack authenticated company.
- [x] Change public-ID scopes to accept authenticated company ID and use only that value for `company_id = ?`.
- [x] Pass authenticated company IDs through service/repository interfaces and mocks.
- [x] Check `RowsAffected` for tenant-scoped deletes; retain reload-based not-found behavior for updates so idempotent updates remain successful.
- [x] Run focused repository and service tests until green.

### Task 2: Preserve write-consistent structure-location response

**Files:**
- Modify: `repository/structure_location_repository_impl.go`
- Test: `repository/query_compatibility_test.go`

- [x] Write a test with separate read/write SQLMock handles expecting the reload only on `db.Write`.
- [x] Run it against the old `db.Read` behavior and confirm the expected failure.
- [x] Reload the updated row through `db.Write`, keeping the same response mapper and fields.
- [x] Run the focused test until green.

### Task 3: Restore fresh structure-city datasets

**Files:**
- Modify: `repository/structure_cities_repository_impl.go`
- Test: repository/service test covering `CreateFileJsonCityData`

- [x] Write a test that seeds an existing stale JSON file and expects the current database rows to replace it.
- [x] Run it and confirm the old cache behavior fails the fresh-data expectation.
- [x] Always execute the existing filtered query and rewrite the same JSON payload before reading it.
- [x] Run the focused test until green and confirm output province/city values are unchanged for identical database rows.

### Task 4: Verification

- [x] Run `gofmt` on changed Go files.
- [x] Run focused repository and service tests without cache.
- [x] Run `go test -count=1 ./...`.
- [x] Run `go vet ./...` and `gocritic check ./...` when installed.
- [x] Run `git diff --check` and inspect `git diff` for DTO/JSON/business-flow drift.
- [x] Confirm `git status` contains only intended uncommitted files and no commit was created.
