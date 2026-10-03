---
name: go-testing
description: Use whenever Go behavior changes, including features, bug fixes, refactors, API changes, database logic, authorization, transactions, or concurrency.
---

# Go Testing

## Outcome

Protect observable behavior and important failure modes with the repository's existing `testing` and `testify` conventions.

## Before Implementation

1. Read `../../../AGENTS.md`, `../../TESTING.md`, and relevant existing tests.
2. State the behavior to preserve or add.
3. Write a focused failing regression test where practical; confirm it fails for the intended reason.
4. Inspect `../../../test/mocks_test.go` before changing shared interfaces.

## Test Scope

Cover cases relevant to the change:

- successful behavior;
- malformed input and validation errors;
- not found and database failures;
- authorization, ownership, company/structure/period isolation;
- transaction commit and rollback;
- zero, false, empty, omitted, and nullable patch semantics;
- ordering, pagination, and boundary conditions;
- regression for the reported bug;
- cancellation, errors, and races for concurrency.

Use table-driven tests when they make related cases easier to read, not mechanically.

## Execution Order

Run the narrowest useful command, then broaden by risk:

1. focused test;
2. affected package;
3. dependent packages;
4. `go test ./...` when practical;
5. `go test -race` for concurrency-sensitive changes.

Do not chase coverage percentage with assertions that do not protect behavior.

## Repository Reality

- PREFERRED: handwritten interfaces and mocks in `../../../test/mocks_test.go` support focused service tests.
- ACCEPTABLE: `../../../test/visit_service_test.go` demonstrates the current unit-style testing approach.
- AVAILABLE: `go-sqlmock` with `../../../test/test_db_helper_test.go` verifies expected generated SQL/arguments, configured rows/errors, and transaction calls. Current `newMockResolver` shares Read/Write handles: use distinct handles or transaction identity assertions when testing visibility.
- LIMITATION: no established live MySQL integration harness was identified. Mocked results do not prove actual affected rows, indexes, locking/isolation, replica routing, stored procedures, or rollback effects.
- COMMANDS: `../../TESTING.md` owns command details. Current `make check-cov` enforces 70%; coverage targets can update docs. Verify Makefile before reporting a current threshold.
- LIMITATION: green unit tests do not prove router/middleware/API contracts unless the HTTP path is exercised.

For SQL-sensitive behavior, use an established compatible integration environment if available. Otherwise report the verification gap explicitly; do not claim database behavior is proven.

## Security Rule

Never weaken authentication, authorization, ownership checks, validation, lint, or test assertions merely to obtain a green result. A failing security test is a requirement signal, not an obstacle to remove.

## Completion Gate

- New test failed before the implementation and passed afterward, where TDD is practical.
- Affected existing tests pass.
- Mocks and interfaces remain aligned.
- Test output has no unexplained failures or warnings.
- Unverified integration, production-data, race, or performance claims are disclosed.
