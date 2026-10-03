---
name: ci-quality-gate
description: Use when changing or reviewing CI, build and test workflows, release readiness, quality tooling, deployment gates, or checks that may be disabled or bypassed.
---

# CI Quality Gate

## Outcome

Turn repository-supported checks into enforceable pre-deployment gates without blindly adding every possible tool.

## Required Inspection

Read `../../../AGENTS.md`, `../../QUALITY_GATES.md`, `../../../Makefile`, `../../../.gitlab-ci.yml`, `../../../Dockerfile`, `../../../docker-compose.yml`, `../../../deploy.sh`, and `../../../go.mod`. Determine which tools are already supported and which require installation or credentials.

## Required Gates

For changed Go code, normally enforce:

- formatting check that does not mutate the checkout;
- `go vet`;
- targeted and/or full `go test` appropriate to repository risk;
- `go build`;
- protection against deploying when required checks fail.

Use repository commands where they correctly express the check. Pin newly installed CI tools when practical.

## Conditional Gates

- `go test -race` for concurrency changes;
- golangci-lint/staticcheck/gocritic when configured and relevant;
- Docker build/smoke test for container changes;
- migration/schema validation for database changes;
- MySQL integration tests for repository/transaction semantics when an environment exists;
- security or secret scanning when the workflow/tooling is established.

Conditional does not mean optional without explanation: select checks from the change's risk.

## Failure Handling

- Never disable tests, auth checks, lint, security controls, or meaningful assertions merely to green the pipeline.
- Do not hide failures with `allow_failure`, ignored exit codes, commented commands, or deploy-only rebuilds.
- Separate flaky-test diagnosis from feature implementation; record an owner and containment if an external failure truly blocks the gate.
- Promote the artifact/image that passed checks instead of rebuilding unchecked code on the deployment host when the platform supports it.
- Protect production deployment with appropriate branch/environment approvals and post-deploy verification.

## Current Repository Risks

- Current CI has a tag-filtered quality job. Read `../../TESTING.md` and actual CI rules before reporting enforcement.
- DANGEROUS: development CI and `../../../deploy.sh` print token/environment material.
- LEGACY — DO NOT COPY: staticcheck installation with its execution commented out is not a gate.
- LEGACY — DO NOT COPY: a Docker build that runs `go vet` but no tests is not a complete CI quality stage.

## Verification

- Validate pipeline syntax and job dependencies.
- Demonstrate required jobs fail on a controlled failure and block deploy.
- Confirm secrets are masked and never echoed or embedded in artifacts/images.
- Report cache, runner, protected-variable, and environment-approval assumptions needing human confirmation.
