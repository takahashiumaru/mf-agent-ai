# Presence Coverage 90% Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Raise `visit-flow-presence` aggregate Go coverage to at least 90% without changing production behaviour or committing changes.

**Architecture:** Add focused behaviour tests around repository SQL, service decision paths, controllers, helpers, routes, and authentication. SQL is exercised through `sqlmock`; network integrations use local fakes or safe error paths only. Production implementations and schema are not altered solely for coverage.

**Tech Stack:** Go, GORM, go-sqlmock, Gin, testify.

## Global Constraints

- Do not commit or stage any file.
- Do not execute mutating SQL against a real database.
- Preserve API and business behaviour; test-only changes are preferred.
- Verify with `go test ./...`, `go test -race ./...`, `go vet ./...`, and `go test ./... -coverpkg=./...`.

---

### Task 1: Complete repository behaviour coverage

**Files:**
- Modify: `repository/*_repository_test.go`

**Interfaces:**
- Consumes: public repository interfaces and GORM database handles.
- Produces: SQL-mock coverage for CRUD, filters, reports, and stored-procedure calls.

- [ ] **Step 1: Write a failing SQL expectation test**

```go
mock.ExpectQuery("SELECT .*FROM `offices`").WillReturnRows(sqlmock.NewRows([]string{"id"}))
rows := repository.NewOfficeRepository().FindAll(db, &filters, pagination)
assert.NotNil(t, rows)
```

- [ ] **Step 2: Run test to verify it fails**

Run: `go test ./repository -run TestOfficeRepository -count=1`

- [ ] **Step 3: Add only the SQL expectation or fixture needed by the existing implementation**

```go
mock.ExpectQuery("SELECT .*FROM `offices`").WillReturnRows(sqlmock.NewRows([]string{"id"}).AddRow(1))
```

- [ ] **Step 4: Run the targeted repository test**

Run: `go test ./repository -run TestOfficeRepository -count=1`

### Task 2: Cover service business branches with repository mocks

**Files:**
- Modify: `test/*_service_test.go`

**Interfaces:**
- Consumes: service constructors and repository interfaces.
- Produces: tests for validation, success, empty-result, and transaction-error branches.

- [ ] **Step 1: Write a failing service behaviour test**

```go
result := service.FindByID(auth, &id)
assert.Equal(t, uint(id), result.ID)
```

- [ ] **Step 2: Run the specific test**

Run: `go test ./test -run TestPresenceService -count=1`

- [ ] **Step 3: Configure only existing mocks and database expectations**

```go
repo.On("FindByID", mock.Anything, &id).Return(domain.Presence{Model: gorm.Model{ID: uint(id)}})
```

- [ ] **Step 4: Re-run the service tests**

Run: `go test ./test -run TestPresenceService -count=1`

### Task 3: Cover controllers, routes, auth, and helper response behaviour

**Files:**
- Create: `test/*_controller_coverage_test.go`
- Create: `helper/*_coverage_test.go`

**Interfaces:**
- Consumes: Gin handlers and public helper functions.
- Produces: HTTP status/body assertions and middleware behaviour tests.

- [ ] **Step 1: Write a failing HTTP handler test**

```go
router.ServeHTTP(recorder, httptest.NewRequest(http.MethodGet, "/presence/1", nil))
assert.Equal(t, http.StatusOK, recorder.Code)
```

- [ ] **Step 2: Run the target test**

Run: `go test ./test -run TestPresenceController -count=1`

- [ ] **Step 3: Provide a mock implementation of the existing service interface**

```go
func (s controllerPresenceService) FindByID(*auth.AccessDetails, *int) web.PresenceResponse { return web.PresenceResponse{ID: 1} }
```

- [ ] **Step 4: Re-run controller/helper tests**

Run: `go test ./test ./helper -count=1`

### Task 4: Verify coverage and safety

**Files:**
- Modify: test files only, as required by failing verification.

- [ ] **Step 1: Measure aggregate coverage**

Run: `go test ./... -count=1 -coverpkg=./... -coverprofile=/tmp/presence.cover && go tool cover -func=/tmp/presence.cover | tail -1`

- [ ] **Step 2: Run static and race verification**

Run: `go test ./... -count=1 && go test -race ./... -count=1 && go vet ./...`

- [ ] **Step 3: Confirm no staged files**

Run: `git diff --cached --quiet && git status --short`

## Self-Review

- Spec coverage: Tasks 1–3 cover all executable layers; Task 4 validates the 90% target and race safety.
- Placeholder scan: every task has concrete files, commands, and a representative test fixture.
- Type consistency: test mocks implement existing exported interfaces and only return existing domain/web response types.
