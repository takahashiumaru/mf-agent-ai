# Payroll Testing

Facilities and command definitions inspected on 2026-09-27; this is not a current passing-test/coverage claim.

## Facilities and examples

Only `helper/operator_test.go` and `helper/model_test.go` were identified in the current source. No service/controller/IMAP/OTP harness or sqlmock setup was found. Do not infer payroll security, PDF retrieval or delivery correctness from these helper tests. Add focused tests using synthetic data, temporary directories and faked network/filesystem boundaries when implementing relevant changes; do not run real IMAP or OTP delivery for verification.

## Commands and side effects

Run from the repository root. Select actual matching tests; an empty package run does not verify service behavior. Start targeted, broaden according to risk, and disclose missing integration coverage.

| Command | Actual effect |
| --- | --- |
| `make test` | `go test ./...` |
| `make build` | Builds the service binary under `bin/` |
| `make cover` / `make cov` | Writes `coverage.out`, reports coverage and invokes `scripts/update_coverage.py`, which can rewrite README |
| `make check-cov` | Coverage workflow plus current **1%** Makefile threshold |
| `make fmt` | Modifies Go formatting |
| `make lint` | Requires installed golangci-lint |

For coverage without README updates, use `go test ./... -count=1 -coverpkg=./... -coverprofile=/tmp/visit-flow-payroll-coverage.out`, then `go tool cover -func=/tmp/visit-flow-payroll-coverage.out`. For concurrency changes use `go test -race` on relevant packages when practical.

Current `.gitlab-ci.yml` contains deployment jobs; a local Makefile gate does not prove that CI executes it. The 1% threshold is existing configuration, not a recommended quality target or adequate payroll behavior coverage.

## Regression scope

Use QUALITY_GATES.md. Cover success and relevant invalid input, not-found/error, owner/tenant/period, null/zero/empty, ordering, rollback or partial external failure. Keep mocks aligned with interfaces; do not loosen assertions for coverage. Mock HTTP does not prove live delivery, and unit tests do not prove deployment. Real DB mutation tests require workspace DEV target checks and explicit concrete approval. Do not contact real mailboxes, send OTPs or publish notifications without authorization.

Payroll does not define Makefile targets check/check-all/static/critic/tidy. Use direct Go build/vet/test commands when needed; optional external analyzers require separate availability checks. Do not run make deploy as verification: it changes live container state.
