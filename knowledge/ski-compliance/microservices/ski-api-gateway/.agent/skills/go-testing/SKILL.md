---
name: go-testing
description: Write comprehensive, deterministic unit and integration tests targeting >=90% statement coverage for ski-api-gateway. Use when authoring or improving tests.
---

# Go Testing Skill

## Purpose & Trigger
Maintain high test coverage (`>= 90%`) and deterministic test suites for all packages in `ski-api-gateway`.

## Workflow
1. **Understand**: Identify target packages and uncovered statements via `go tool cover -func`.
2. **Inspect**: Trace boundary conditions: success, validation errors, auth failures, panic recovery, edge cases.
3. **Plan**: Design isolated table-driven tests in `test/` using `httptest.NewRecorder` and mock upstreams.
4. **Implement**: Write assertions checking status codes, headers, and `WebResponse` JSON structures.
5. **Verify**: Measure coverage with `go test ./... -covermode=atomic -coverpkg=./...` and ensure race-free execution.

## Hard Rules
- Achieve at least **90.0%** statement coverage.
- Never write tests that depend on live external networks or shared production databases.
- Clean up test artifacts via `t.Cleanup`.
