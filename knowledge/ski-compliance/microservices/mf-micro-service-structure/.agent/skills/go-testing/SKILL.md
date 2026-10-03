---
name: go-testing
description: Write, organize, and execute meaningful unit and integration tests using testify and Go test tooling. Use whenever adding new features, fixing bugs, or expanding test coverage.
---

# Go Testing Skill

## Purpose
Guide the creation of deterministic, meaningful unit tests for services, repositories, validators, and helpers in `mf-micro-service-structure`.

## When to Use
Use when writing new unit tests, adding regression tests for bug fixes, or improving codebase coverage.

## Workflow
1. **Understand**: Identify target function, edge cases, error conditions, and expected panic/response behavior.
2. **Inspect**: Check existing tests in `helper/operator_test.go`.
3. **Plan**: Formulate table-driven test cases covering both success and error paths.
4. **Implement**:
   - Use `github.com/stretchr/testify/assert`.
   - Test panic conditions using `assert.Panics` or `assert.PanicsWithValue`.
   - Use mocks or isolated in-memory databases for database-dependent services.
5. **Verify**:
   - Execute `go test -v -race ./...`.

## Hard Rules
- Tests must be deterministic and must not rely on external live network endpoints.
- Tests must clean up any temporary files or states.

## References
- [.agent/TESTING.md](../../TESTING.md)
- [.agent/QUALITY_GATES.md](../../QUALITY_GATES.md)
