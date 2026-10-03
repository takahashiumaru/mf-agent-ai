# .agent/CODE_QUALITY.md — Code Quality, Review Checklist & Definition of Done

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

This document defines the review checklist and Definition of Done for verifying all code changes in `mf-micro-service-discount-proposal`.

---

## 1. Proportional Code Review Checklist

Review every pull request and code modification against these 10 dimensions:

### 1. Requirements & Backward Compatibility
- [ ] Code strictly satisfies the user's requested scope without unrequested feature changes.
- [ ] JSON response property names, types, and envelope structures remain 100% backward-compatible.
- [ ] API status codes align with conventions (HTTP 200 for OK / Record not found; HTTP 400 for validation / business error).

### 2. Architecture & Layer Discipline
- [ ] Strict 5-tier layer separation is preserved (`Route` -> `Controller` -> `Service` -> `Repository` -> `Database`).
- [ ] Controller contains no database queries or business calculations.
- [ ] Service does not import Gin (`*gin.Context`) and receives user context via `*auth.AccessDetails`.

### 3. Go Idioms & Error Flow
- [ ] Errors are checked immediately and never ignored silently.
- [ ] Panics are used appropriately for bailing out to `app.ErrorHandler()` and `helper.CommitOrRollback(tx)`.
- [ ] No unbounded goroutines spawned without panic recovery or lifecycle ownership.

### 4. Transaction & Write Safety
- [ ] All database mutations in services use `tx := s.DB.Begin()` with immediate `defer helper.CommitOrRollback(tx)`.
- [ ] Repositories consistently use the passed `tx *gorm.DB` instance rather than falling back to `s.DB`.
- [ ] GORM updates use `Updates(map[string]interface{}{...})` whenever zero values (`0`, `""`, `false`, `nil`) must be persisted.

### 5. Security & Trust Boundaries
- [ ] All dynamic SQL queries, joins, and filters use `?` parameterization (0 `fmt.Sprintf` query interpolations).
- [ ] User permissions and marketing hierarchy are derived from `*auth.AccessDetails`, not client-supplied request body fields.
- [ ] 0 secrets, tokens, or credentials added to code, fixtures, or logs.

### 6. Database Performance & Bounds
- [ ] List queries include `.Limit(N)` or explicit date/period filtering to prevent full table scans.
- [ ] No N+1 database queries executed inside Go loops.
- [ ] Where conditions query indexed columns in left-prefix order (`period`, `id`, `discount_proposal_id`).

### 7. Soft Delete & Data Integrity
- [ ] Queries on models with `*time.Time` soft deletes (`CreditNote`, `CustomerBalance`) explicitly include `deleted_at IS NULL`.
- [ ] Audit history is created via `helper.CreateHistory` for all entity mutations.

### 8. Testing & Regression Protection
- [ ] Unit or characterization tests cover new or modified business logic and edge cases.
- [ ] Tests are deterministic and execute cleanly in `go test ./...`.

### 9. Scope Discipline (No Unrelated Refactoring)
- [ ] Only files directly required for the task were touched.
- [ ] Untouched legacy code remains untouched to prevent regression blast radius.

### 10. Documentation & Changelog
- [ ] Engineering guidance changes are documented in `.agent/` and indexed in `AGENTS.md` and `.agent/INDEX.md`.
- [ ] Material rule changes are recorded in `.agent/CHANGELOG.md`.

---

## 2. Definition of Done (DoD)

A task in `mf-micro-service-discount-proposal` is **DONE** only when all criteria below are verified with fresh empirical evidence:

```text
[ ] 1. Static Verification: `go fmt ./...` and `go vet ./...` report 0 warnings.
[ ] 2. Build Verification:  `go build -o /dev/null .` compiles successfully (Go 1.23).
[ ] 3. Test Verification:   `go test ./...` passes with 0 failures.
[ ] 4. Security Check:     0 credentials or unparameterized SQL queries introduced.
[ ] 5. Git Diff Review:    `git diff` confirms only intended changes are present.
```
