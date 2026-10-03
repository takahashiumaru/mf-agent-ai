# Testing inventory and execution policy

Current inventory: 2026-09-29, HEAD `30a0b121b1fc11f14b414c184ab092abf453d521` plus uncommitted refactors and test adjustments. Found **26 test source files**. Directory counts do not establish behavior coverage. The original 2026-09-27 documentation inventory was 13 files and did not execute tests.

| Directory | Test files |
| --- | ---: |
| `test` | 24 |
| `internal/reportexcel` | 2 |

## Select checks by task

Run application tests only when requested. Inspect test fixtures and configuration first; use mocks or isolated test data. Never start the application or mutate production to validate documentation. Search assertions and callers for the affected behavior rather than inferring coverage from file names.

Commands available when appropriate (not execution evidence):

```sh
go build ./...
go vet ./...
go test ./...
```

Record command, revision, timestamp, exit status, package scope and limitations for actual runs. Coverage artifacts/badges may be historical. Preserve JSON/file/proxy contracts, transaction handles and zero/NULL semantics in relevant checks.

## Unit-test ownership after package refactor

- [Workbook contract tests](../internal/reportexcel/workbook_contract_test.go) call `reportexcel` directly. They run without the service-test HTTP harness. Fixture inputs are in `workbook_fixture_test.go`; frozen original XML expectations are in `internal/reportexcel/testdata/`. Do not regenerate expectations merely to make a failed test pass.
- [Public helper compatibility](../test/report_excel_contract_test.go) verifies populated all-area/per-area argument forwarding by comparing decompressed workbook parts with the package implementation. Detailed baseline semantics remain covered by the package-local golden tests.
- Queue, email and calendar scenarios live respectively in `test/job_redis_behavior_test.go`, `test/report_email_behavior_test.go`, and `test/work_calendar_behavior_test.go`. `test/queue_test_helpers_test.go` centralizes queue decoding and pre-commit assertions.
- [Target failure tests](../test/target_marketing_update_behavior_test.go) assert rollback and zero queued requests when prices are absent/invalid or deletion fails.
- The target header test uses a unique `t.TempDir`, temporarily changes the process working directory because the pinned hierarchy path is constant/relative, and restores it in cleanup. It checks the actual hierarchy IDs passed to SQL. This subtest must remain serial: `os.Chdir` is process-global. Go 1.23 lacks `t.Chdir`, hence the explicit cleanup.
- Tests using global HTTP transport, environment variables, URLs or queue capture remain serial within the service-test process. Separate workbook package tests need no such harness.

## Latest executed checks — 2026-09-29

- Go 1.23 full suite with `-race -shuffle=20261001 -count=3 -coverpkg=./...`: PASS, **88 distinct top-level tests**, 1,362 passing test/subtest events across the three iterations, zero failures. Aggregate statement coverage: **92.3% on Go 1.23**, above the 70% gate.
- Targeted package/service checks: PASS. Two concurrent processes running only the target header test, three iterations each: PASS, confirming filesystem fixtures no longer share a path across processes.
- Go 1.23 vet, GoCritic v0.13.0, Staticcheck and whitespace checks: PASS.
- Production Go files, module files and golden fixture contents are unchanged by this test-only adjustment. Test package membership/file paths changed; existing named scenarios were retained.
- Logs and execution-start snapshots: `/tmp/sales-test-adjustment`.

These checks use SQL mocks and local HTTP stubs. They do not establish deployment or real database/warehouse/email behavior. Coverage percentages depend on toolchain instrumentation; do not compare the earlier local-toolchain 95.5% directly with Go 1.23's statement set.

## Local query experiment harness — 2026-09-29

[Run instructions](../tools/SALES_QUERY_LAB.md) describe an opt-in socket-only synthetic MySQL fixture. It is separate from the Go/sqlmock suite and never reads application dotenv. [Execution results](../docs/refactoring/sales-query-plan-execution.md) record passed fixture comparisons and rejected/open optimization gates. Local MySQL 26.7.0 optimizer results are not production 8.4.2 benchmarks or DEV migration validation.
