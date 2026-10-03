# Testing

## Available facilities

Checked against source and Makefile on 2026-09-27. This records available facilities, not a claim that tests passed today.

| Layer | Facility and example | Evidence limit |
| --- | --- | --- |
| Pure logic/DTO/mapping | Standard `testing`, `testify`; package-local tests and `test/` | Only exercised inputs and assertions |
| Service | Handwritten repository mocks in `test/mocks_test.go` | Mocked interactions, not live persistence |
| GORM/repository | `go-sqlmock`; `test/test_db_helper_test.go`, `test/repository_core_test.go`, `test/repository_visit_test.go` | Generated SQL/arguments, configured results/errors and expected transaction calls |
| Controller/auth | Gin + `httptest`; `test/controller_deep_test.go`, auth tests | Exercised handlers/middleware only; not every gateway/deployed route |

No established live MySQL integration harness was identified in the inspected test setup. SQL mocks do not prove MySQL locking, isolation, replica lag, indexes/plans, constraints, stored procedures, or real rollback effects. They can verify the SQL and error/transaction calls they explicitly expect.

`newMockResolver` currently assigns the same GORM DB to Read and Write. That helper alone cannot detect a writer/replica mix-up. For read-your-writes regressions, use distinct handles or assert the exact transaction passed into the affected calls. `expectTransaction` mirrors legacy calls; it does not prove that every opened handle is finalized.

## Test organization

- Pure helper behavior and domain response mapping tests live beside their packages in `helper/` and `model/domain/`; they use external test packages to exercise exported APIs. Repository tests that exercise package implementation details remain package-local in `repository/`.
- Cross-package workflows live in `test/` with package `test`. Use this for service/repository/controller regression tests that need shared mocks, route wiring, or the common DB/Gin harness. Do not relocate unrelated tests as part of a bug fix.
- Inspect `test/main_test.go`, `test/test_db_helper_test.go`, and relevant mocks before relying on setup; the DB helper can change the test process working directory.
- Mocks are handwritten. Some embed interfaces: an unexpected unimplemented call can panic. Update implementations and interaction assertions together.
- Use table-driven cases where they clarify related behavior. Do not loosen assertions or add implementation-mirroring tests solely to increase coverage.

## Select meaningful regression cases

Use [QUALITY_GATES Gate 8](QUALITY_GATES.md#gate-8-tests) for the risk checklist. For API-preserving work, test JSON key/type/value, null versus zero, empty collections, ordering, and HTTP/error mapping as relevant. For a DB change, test scope/arguments, zero-value writes, query/write failures and transaction handles. Assert errors and rollback paths as well as successful output.

## Commands and side effects

Run in the repository root. Start with the affected named test and broaden according to risk; verify the selected command actually runs matching tests.

```sh
go test ./test -run TestVisitRepository_BasicCRUD -count=1
go test ./test -count=1
go test ./...
go vet ./...
go test -race ./test -count=1
```

| Command | Effect |
| --- | --- |
| `make test` | Runs `go test ./...` |
| `make cover` | Writes `coverage.out`, reports coverage, invokes `scripts/update_coverage.py` which can update documentation |
| `make check-cov` | Same coverage workflow plus a 70% minimum threshold in current Makefile |
| `make fmt` | Formats Go source; review resulting diff |
| `make lint`, `make static`, `make critic` | Require installed golangci-lint, staticcheck, gocritic respectively |
| `make check-all` / `make check` | Current dependencies: staticcheck, gocritic, coverage gate; does not itself run every tool above, including golangci-lint |
| `make tidy` | Mutates go.mod/go.sum, then verifies modules; not a read-only check |

For coverage without the documentation updater:

```sh
go test ./... -count=1 -coverpkg=./... -coverprofile=/tmp/visitflow-go-coverage.out
go tool cover -func=/tmp/visitflow-go-coverage.out
```

Thresholds come from Makefile/CI, not from a badge. A passing coverage percentage is not proof of correct SQL, JSON, concurrency, or deployment behavior. Report the actual commands/results and missing integration coverage. Do not execute live DB write tests without the workspace's required target verification and concrete mutation approval.
