---
name: go-testing
description: "Add or update tests for changed Go behavior, bugs, transactions, repositories, HTTP handlers, authentication, concurrency, or database failure paths."
---

# Go Testing

Use whenever behavior changes. Inspect existing tests before implementation.

Follow `UNDERSTAND -> INSPECT -> PLAN -> IMPLEMENT -> TEST -> REVIEW`; tests inform the plan rather than being postponed until after coding.

## Test Strategy

Choose the narrowest test that protects the behavior, then expand by risk:

`targeted test -> affected package -> dependent packages -> go test ./...`

For concurrency changes, consider `go test -race` on the affected packages or broader suite. Do not claim a check passed unless it was run successfully.

## Repository Tooling

- Standard `testing`.
- Testify `assert` and handwritten `mock.Mock` implementations.
- `go-sqlmock` with GORM's MySQL driver.
- `httptest` and Gin test contexts/routers.
- No real-MySQL/testcontainer suite is established.

PREFERRED examples:

- Manual service seams: `test/user_service_test.go`.
- Atomic refresh/rollback and SQL expectations: `test/session_refresh_coverage_test.go`.
- Repository joins/raw queries: `test/repository_coverage_test.go`.
- HTTP/middleware behavior: `main_coverage_test.go` and `test/users_controller_coverage_test.go`.
- Domain mapping: `model/domain/user_test.go` and `model/domain/role_test.go`.

## Behavior Matrix

Test relevant cases, not every possible case mechanically:

- success and important edge conditions;
- validation failure;
- not found and domain translation;
- database/commit/rollback failure;
- zero/false/empty/NULL partial updates;
- authentication, authorization, ownership, and revocation;
- transaction rollback/no partial writes;
- pagination/filter/sort contracts;
- regression reproducing a bug before fixing it.

## Database Tests

- Assert important SQL predicates and parameters when correctness depends on them.
- Do not rely only on GORM DryRun for transaction behavior.
- Verify begin/commit/rollback and `RowsAffected` semantics for atomic flows.
- sqlmock cannot prove MySQL syntax, indexes, constraints, or execution plans; request an integration environment for those claims.
- Specifically test retained GORM chain filters when fixing current discarded-chain bugs.

## HTTP/API Tests

Assert status, response envelope, JSON field behavior, validation, auth middleware, and error shape. Preserve the local `web.WebResponse` versus `gin.H{"error": ...}` compatibility unless intentionally changed.

## Test Quality

- Use table-driven tests when cases share setup and assertions; do not force the style.
- Name tests by subject and behavior.
- Avoid assertions that merely mirror implementation details without protecting a contract.
- Do not weaken validation/security or over-mock to get green tests.
- Do not chase coverage percentage with meaningless cases.
- Update every handwritten mock when an interface changes.

## Commands

```text
go test ./test -run '^TestName$'
go test ./<affected-package>
go test ./...
go test -race ./...   # concurrency-sensitive work, when practical
make cover            # when coverage inspection is useful
```

## Completion Gate

- Regression test exists when practical.
- Important failure and transaction paths covered.
- Affected tests run fresh and pass.
- Broader suite run according to risk.
- Any missing real-MySQL/integration evidence stated honestly.

Read `../../TESTING.md` and `../../ERROR_HANDLING.md` when deeper patterns are needed.

## Facilities and commands

Use `../../TESTING.md` for current test paths, sqlmock evidence limits, the 70% Makefile gate, and coverage commands that can update README. A package run without matching tests is not verification.
