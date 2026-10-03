# Testing inventory and execution policy

Inventory refreshed 2026-09-27 at HEAD `5dde98ade3b1136eb6750c3c2bf225417f60259c`: **86 test source files**. Files may cover multiple layers regardless of their directory. No tests were executed during this documentation refresh; current pass/fail and coverage are unverified.

| Directory | Test files |
| --- | ---: |
| `test` | 86 |

## Select tests by behavior

Search test names, constructors and mocks for the affected endpoint/service/repository. Do not infer zero service/controller coverage from package placement. Existing tests in test/ include service and workflow scenarios. Inspect assertions and fixtures before relying on them.

## Commands when tests are requested

```sh
go test ./...
go test -v ./helper/...
go test -cover ./...
```

These commands were not executed for this inventory. Preserve test isolation, inspect connection setup, and use mocks or an isolated development fixture database. Production writes require their own authorization and are not test fixtures.

For each run record revision, command, time, exit status, package scope and output summary. Coverage filenames/badges alone do not establish measured coverage of the current checkout. Verify JSON and file responses separately; include error paths, transaction scope, zero/NULL updates and business filters when relevant.
