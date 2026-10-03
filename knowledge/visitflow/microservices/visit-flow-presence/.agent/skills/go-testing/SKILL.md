---
name: go-testing
description: Use when Go behavior changes, bugs are fixed, transactions or queries change, or tests and mocks need to be added or reviewed.
---

# Go Testing

## Core Principle

Tests protect observable behavior and failure modes. Inspect existing tests before implementation and add the smallest meaningful regression coverage.

## Required Workflow

`UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW`

Run tests in widening scope: focused case → affected package → dependent packages → full suite when practical.

## Repository Pattern Classification

- **PREFERRED:** controller contract/mocking style in `test/office_controller_coverage_test.go`.
- **PREFERRED:** MySQL GORM/sqlmock setup in `test/repository_mock_db_test.go`.
- **PREFERRED:** repository predicate assertions in `test/presence_repository_coverage_test.go`.
- **PREFERRED:** service transaction and safe-update coverage in `test/leave_service_safe_updates_coverage_test.go`.
- **ACCEPTABLE:** standard `testing`, `testify`, `httptest`, and `go-sqlmock`; use the library already used by the affected tests.
- **MIGRATE-WHEN-TOUCHED:** oversized coverage files or mocks that assert implementation trivia rather than behavior.

## What to Test

Choose cases relevant to the change:

- success and validation failure;
- not found and repository/database failure;
- authorization, ownership, and tenant isolation;
- transaction commit, rollback, and use of the correct transaction DB;
- zero-value partial updates (`0`, `false`, `""`, null);
- pagination/filter/order contract and query predicates;
- regression edge cases and concurrency-sensitive state changes.

For API handlers, assert route input, status, response envelope, and error shape. For repositories, assert SQL shape and arguments, but remember sqlmock cannot prove an index is effective or MySQL-specific SQL executes successfully.

## Rules

- Prefer behavior assertions over testing mocks themselves.
- Use table-driven tests when cases share a clear setup; do not force every test into a table.
- Keep fixtures minimal and deterministic.
- Do not weaken validation, authorization, or assertions to make tests pass.
- When mocks are handwritten, update all affected interface implementations and compile-time callers.
- Consider `go test -race` for actual concurrency changes, not as a substitute for lifecycle reasoning.

## Commands

- Focused: `go test ./test -run TestName`
- Package: `go test ./test` (repository tests also live here)
- Full: `go test ./...` or `make test`
- Coverage: `make cover`

The current Makefile check-cov threshold is 70%; TESTING.md documents command side effects. Always use fresh output; do not hide a failing package through exclusions or weakened assertions.

Read `.agent/TESTING.md` before selecting test placement and helpers.

## Facilities and commands

Use `../../TESTING.md` for current test paths, sqlmock evidence limits, the 70% Makefile gate, and coverage commands that can update README. A package run without matching tests is not verification.
