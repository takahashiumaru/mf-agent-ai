# Testing inventory and execution policy

Inventory date: 2026-09-27. HEAD: `ecd39670cfa70c56925cb7428ab520e5921396bb`. Found **1 test source files**. Directory counts do not establish behavior coverage. No application test or build was run for this documentation rollout.

| Directory | Test files |
| --- | ---: |
| `helper` | 1 |

## Select checks by task

Run application tests only when requested. Inspect test fixtures and configuration first; use mocks or isolated test data. Never start the application or mutate production to validate documentation. Search assertions and callers for the affected behavior rather than inferring coverage from file names.

Commands available when appropriate (not execution evidence):

```sh
go build ./...
go vet ./...
go test ./...
```

Record command, revision, timestamp, exit status, package scope and limitations for actual runs. Coverage artifacts/badges may be historical. Preserve JSON/file/proxy contracts, transaction handles and zero/NULL semantics in relevant checks.
