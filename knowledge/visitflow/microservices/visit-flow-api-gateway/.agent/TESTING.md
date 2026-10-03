# Gateway Testing

Facilities and command definitions inspected on 2026-09-27; this is not a current passing-test/coverage claim.

## Facilities and examples

Pure package tests live beside their owner: helper behavior in `helper/`, domain response mapping in `model/domain/`, and file service/parser behavior in `service/`. Cross-package session/repository/service workflows and controller/route contracts remain under `test/` (package `test`); main gateway/middleware tests remain at the module root. Examples: `test/session_refresh_coverage_test.go` (transaction/replay cases), `test/user_service_test.go`, `test/users_controller_coverage_test.go`, `main_coverage_test.go` (gateway/local middleware). Inspect the actual handler/middleware exercised before claiming full gateway coverage.

SQL mocks can check generated SQL/arguments, configured rows/errors and expected begin/commit/rollback calls. They cannot prove actual MySQL isolation/locks, replica lag, constraints, query plans, stored procedures or rollback effects. No established live-MySQL integration harness was identified in the inspected setup. For transaction visibility use distinct handles or exact transaction identity assertions; shared mock connections can hide a reader/writer mix-up.

## Commands and side effects

Run from the repository root. Select actual matching tests; an empty package run does not verify service behavior. Start targeted, broaden according to risk, and disclose missing integration coverage.

| Command | Actual effect |
| --- | --- |
| `make test` | `go test ./...` |
| `make build` | Builds the service binary under `bin/` |
| `make cover` / `make cov` | Writes `coverage.out`, reports coverage and invokes `scripts/update_coverage.py`, which can rewrite README |
| `make check-cov` | Coverage workflow plus current **70%** Makefile threshold |
| `make check-all` / `make check` | staticcheck, gocritic and coverage; does not itself run golangci-lint |
| `make fmt` | Modifies Go formatting |
| `make lint`, `make static`, `make critic` | Require installed golangci-lint, staticcheck, gocritic |
| `make tidy` | Mutates module files, then verifies them; not a read-only check |

For coverage without README updates, use `go test ./... -count=1 -coverpkg=./... -coverprofile=/tmp/visit-flow-api-gateway-coverage.out`, then `go tool cover -func=/tmp/visit-flow-api-gateway-coverage.out`. For concurrency changes use `go test -race` on relevant packages when practical.

Current `.gitlab-ci.yml` contains a tag-filtered Test & Quality Gate job using module verification, vet, gocritic and `make check-cov`. Read its rules before claiming it runs for every branch or push.

## Regression scope

Use QUALITY_GATES.md. Cover success and relevant invalid input, not-found/error, owner/tenant/period, null/zero/empty, ordering, rollback or partial external failure. Keep mocks aligned with interfaces; do not loosen assertions for coverage. Mock HTTP does not prove live delivery, and unit tests do not prove deployment. Real DB mutation tests require workspace DEV target checks and explicit concrete approval. Do not contact real mailboxes, send OTPs or publish notifications without authorization.
