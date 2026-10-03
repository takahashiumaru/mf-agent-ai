---
name: ci-quality-gate
description: Maintain and audit GitLab CI/CD pipelines, static analysis, and automated release gates. Use whenever modifying .gitlab-ci.yml or .golangci.yml.
---

# CI Quality Gate Skill

## Purpose
Ensure pipeline stability, automated linting, test execution, and deployment safety across development and production targets.

## When to Use
Use when modifying GitLab CI stages, tags, linters in `.golangci.yml`, or deployment scripts (`deploy.sh`).

## Workflow
1. **Understand**: Review stages in `.gitlab-ci.yml` (`clear`, `test`, `deploy`).
2. **Inspect**: Check deploy conditions based on git tag formats (`v*.*.*-(m|rc)` for dev, `v*.*.*-release` for prod).
3. **Plan**: Ensure all linting and test checks execute cleanly before deploy steps.
4. **Implement**:
   - Maintain consistency between local `golangci-lint` settings and CI environment.
5. **Verify**:
   - Test linting locally: `golangci-lint run`.

## Hard Rules
- Never bypass test/vet gates on release tags.

## References
- `.gitlab-ci.yml`
- `.golangci.yml`
- [.agent/QUALITY_GATES.md](../../QUALITY_GATES.md)
