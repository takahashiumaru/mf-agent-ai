---
name: ci-quality-gate
description: Use when verifying GitLab CI/CD stages, static analysis linters, test coverage, and automated deployment pipelines.
---

# CI Quality Gate Skill

## Guidelines
1. **Pipeline Stages**: `clear`, `test`, `deploy` configured in [.gitlab-ci.yml](../../../.gitlab-ci.yml).
2. **Linter Gate**: Enforces `.golangci.yml` linting checks (`govet`, `gocritic`, `gocyclo`, `lll`).
3. **Local Pre-Commit Verification**: Run `go fmt ./...`, `go vet ./...`, `golangci-lint run`, and `go test ./...`.

See [.gitlab-ci.yml](../../../.gitlab-ci.yml) and [.golangci.yml](../../../.golangci.yml).
