---
name: go-testing
description: Author, execute, and verify unit and integration tests using Go standard testing, Testify assertions, and mock boundaries. Use whenever adding new features, fixing bugs, or expanding test coverage.
---

# go-testing

Guides testing strategy and test authoring for `mf-micro-service-discount-proposal`.

## Core References
- [TESTING.md](../../TESTING.md) — Test baseline, verified commands, mock strategies.
- [QUALITY_GATES.md](../../QUALITY_GATES.md) — Pre-completion test requirements.
- [WORKFLOWS.md](../../WORKFLOWS.md) — Workflow 4: Fixing a bug with regression tests.

## Standard Workflow
1. **Identify Test Level**:
   - Pure helpers & utilities: Standard Go table-driven unit tests.
   - Services: Unit tests with mock repositories.
   - Controllers: HTTP test recorder tests (`httptest.NewRecorder`).
   - Repositories: Integration / characterization tests with isolated test database or `sqlmock`.
2. **Author Test File (`<package>/<target>_test.go`)**:
   - Use table-driven test cases (`struct{ name, input, expected }`).
   - Use Testify assertions (`assert.Equal(t, expected, actual)`).
3. **Execute & Verify**:
   ```bash
   # Run all tests
   go test ./...

   # Run verbose package tests
   go test -v ./helper/...

   # Run specific test function
   go test -v ./helper -run TestAddMonth
   ```
4. **Inspect Coverage**:
   ```bash
   go test -cover ./...
   ```

## Hard Guardrails
- **NEVER** write flaky tests dependent on live external network endpoints or non-deterministic time.
- **NEVER** run tests that alter production database records.
- **DO NOT** claim tests passed without executing them in the current terminal session.
