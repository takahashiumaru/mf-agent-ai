---
name: ci-quality-gate
description: Enforce CI/CD pipeline quality gates, testing, linting, and build verification. Use when modifying .gitlab-ci.yml or CI pipeline scripts.
---

# CI Quality Gate Skill

## Purpose & Trigger
Maintain robust automated validation in GitLab CI pipelines for `ski-api-gateway`.

## Workflow
1. **Understand**: Identify pipeline stages (lint, test, build, deploy).
2. **Inspect**: Review `.gitlab-ci.yml` jobs and runner configurations.
3. **Plan**: Add automated test execution with coverage checks and static analysis.
4. **Implement**: Configure jobs for `go test ./...`, `go vet ./...`, and Docker artifact builds.
5. **Verify**: Ensure pipeline passes reliably without flaky job failures.

## Hard Rules
- CI must fail if unit tests fail or code cannot compile.
