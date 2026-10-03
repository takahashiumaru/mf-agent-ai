---
name: ci-quality-gate
description: "Modify CI/build workflows, introduce quality tooling, or review release readiness and choose required versus conditional Go, Docker, migration, and integration checks."
---

# CI Quality Gate

Follow `UNDERSTAND -> INSPECT -> PLAN -> IMPLEMENT -> TEST -> REVIEW`.

## Detect Existing Tooling

Inspect `Makefile`, `.golangci.yml`, `.gitlab-ci.yml`, `Dockerfile`, and available tool versions before changing CI.

Current state:

- Makefile supports run/build/test/coverage/format/lint/staticcheck/gocritic/module verification.
- `.golangci.yml` defines a broad lint set.
Current coverage commands and thresholds are documented in TESTING.md; inspect Makefile/CI before making an enforcement claim.
- Dockerfile quality commands are commented out; Docker build is therefore not a substitute for CI gates.
- Deployment uses tag patterns and runs a remote destructive checkout/build script.

PREFERRED local command sources — `Makefile` for reproducible developer commands and `.golangci.yml` for the established lint policy. CI should invoke these rather than inventing divergent checks.

## Required Gates for Changed Go Code

At minimum, when available/configured:

- `gofmt` cleanliness;
- `go test` for affected packages and `go test ./...` according to risk;
- `go vet ./...`;
- `go build` or `make build`;
- repository `golangci-lint`/`staticcheck` when their supported versions are available.

Do not introduce every possible tool automatically. Pin/install tools reproducibly before making them required.

## Conditional Gates

- `go test -race`: concurrency/shared-state changes.
- Coverage inspection: important behavior additions; no arbitrary percentage target.
- Docker build/runtime smoke test: Docker/build/dependency changes.
- MySQL integration/generated-SQL/plan validation: repository/schema/performance changes.
- Migration validation and compatibility checks: schema changes.
- API contract tests: routes/DTO/status/filter/sort changes.
- Security/static/dependency scanning: when tooling and ownership are established.

## Gate Design

- Keep feedback fast: formatting/unit checks before expensive image/integration work.
- Cache Go modules/build artifacts safely.
- Use the same commands developers can run locally.
- Make failures actionable and retain test artifacts only when useful.
- Protect deploy jobs so they depend on required successful gates for the same revision.
- Never print environment files or secrets; current development CI runs `cat $ENV_FILE`, which is DANGEROUS and must not be copied.

## Failure Handling

- Do not “fix” CI by disabling meaningful tests/lints/security checks.
- Distinguish a real defect from tool/version/config drift.
- If baseline failures pre-exist, report them and scope remediation; do not hide them with broad excludes.
- Never claim a gate passed unless the exact command ran successfully.

## Review Gate

- Required versus conditional checks justified.
- Tool versions and private-module authentication reproducible.
- Deploy cannot bypass intended validation.
- Secrets are masked and absent from logs/artifacts/images.
- CI config syntax and changed commands validated.

Read `../../TESTING.md` and `../../CODE_QUALITY.md` for repository commands and definition of done.

## Current gate reference

Read `../../TESTING.md`: current Makefile check-cov is 70%; CI contains a tag-filtered quality job. Coverage commands can update README. Verify actual job rules before claiming every push is tested.
