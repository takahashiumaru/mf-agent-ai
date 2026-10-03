---
name: ci-quality-gate
description: Use when modifying CI/CD, build or test workflows, release readiness checks, linters, static analysis, Docker build gates, or migration validation.
---

# CI Quality Gate

## Core Principle

CI must run reproducible checks that prevent unsafe code from reaching deployment. Do not create a green pipeline by disabling meaningful checks.

## Required Workflow

`UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW`

Inventory configured tools and versions before adding gates. Run a check locally or in an equivalent container before requiring it.

## Repository Pattern Classification

- **ACCEPTABLE:** `Makefile` exposes run/build/test/coverage/format/lint/static/critic/tidy commands for local use.
- **LEGACY:** `.gitlab-ci.yml` declares a test stage but currently contains deployment jobs rather than an active Go test quality gate.
- **LEGACY:** the `Dockerfile` performs formatter/static-analysis checks during image construction.
- **DANGEROUS:** `deploy.sh` performs hard reset/checkout and can expose deployment credentials in command output; CI changes must preserve authorization boundaries and mask secrets.
- **NOT CLEARLY ESTABLISHED:** pinned versions/availability for all local lint tools and a migration validation command.

## Required Gates for Changed Go

- formatting is clean (`gofmt`, plus `goimports` only if repository support is made reproducible);
- affected tests pass, with `go test ./...` as the broad gate when the suite is healthy;
- `go build` succeeds;
- configured vet/lint/static checks pass when their versions and configuration are supported.

Do not automatically add every possible tool. A flaky, unpinned, or obsolete linter is not a reliable gate; fix/pin it deliberately rather than silently ignoring it.

## Conditional Gates

| Change | Additional gate |
| --- | --- |
| Concurrency | focused `go test -race` |
| Repository/GORM | repository/service tests; integration test when MySQL semantics matter |
| Schema/migration | migration syntax/apply validation and compatibility review in the real migration system |
| Docker | image build and runtime smoke test |
| API contract | handler/contract tests |
| Performance claim | repeatable before/after evidence |

## Pipeline Design

- Tests/quality gates must complete before deploy jobs and artifacts/images should flow from verified stages.
- Cache dependencies safely; do not cache or print secrets.
- Fail with actionable output and retain relevant test/build reports where supported.
- Do not auto-fix source in CI; report the required change.
- Preserve branch/environment protections and do not broaden deploy permissions as part of a quality edit.

Use fresh full-suite output for every release. If a required gate is red, do not exclude the package or add a silent waiver; fix the cause or obtain an explicit, time-bounded release decision from the responsible owner.

Read `.agent/TESTING.md` and use `docker-production` or `migration-safety` for their conditional gates.

## Current gate reference

Read `../../TESTING.md`: current Makefile check-cov is 70%; CI contains a tag-filtered quality job. Coverage commands can update README. Verify actual job rules before claiming every push is tested.
