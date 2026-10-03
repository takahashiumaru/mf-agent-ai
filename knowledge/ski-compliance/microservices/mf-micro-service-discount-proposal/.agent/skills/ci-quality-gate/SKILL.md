---
name: ci-quality-gate
description: Validate and maintain GitLab CI/CD pipelines, static analysis linters, build stages, and automated quality gates. Use whenever modifying .gitlab-ci.yml, .golangci.yml, or release deployment configurations.
---

# ci-quality-gate

Guides continuous integration and pipeline verification for `mf-micro-service-discount-proposal`.

## Core References
- `.gitlab-ci.yml` — GitLab CI deployment and test pipeline definition.
- `.golangci.yml` — Golangci-lint rules and linter settings.
- [QUALITY_GATES.md](../../QUALITY_GATES.md) — Pre-completion quality gates and verification runbook.

## Standard Workflow
1. **Understand Pipeline Stages (`.gitlab-ci.yml`)**:
   - Stages: `clear`, `deploy`.
   - Targets: Development SKI-MF, Development SKI-TL, Production SKI-MF.
2. **Local Pre-CI Verification**:
   Execute the local verification runbook:
   ```bash
   go fmt ./...
   go vet ./...
   go test ./...
   go build -o /dev/null .
   ```
3. **Review Static Linting Rules (`.golangci.yml`)**:
   - Enabled linters: `govet`, `errcheck`, `staticcheck`, `gocritic`, `gocyclo`, `lll` (max line 200).

## Hard Guardrails
- **NEVER** push commits that fail `go vet ./...` or `go test ./...`.
- **NEVER** expose SSH keys or GitLab CI tokens in logs or scripts.
- **DO NOT** make non-functional formatting changes across unrelated legacy files during pipeline fixes.
