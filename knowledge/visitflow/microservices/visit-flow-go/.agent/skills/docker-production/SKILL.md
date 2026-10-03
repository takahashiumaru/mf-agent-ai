---
name: docker-production
description: Use when changing the Dockerfile, Docker Compose, container build context, runtime image, container deployment configuration, health checks, or container secrets.
---

# Docker Production

## Outcome

Produce a reproducible, minimal, non-secret-bearing image that can start, stop, and report health safely.

## Required Inspection

Read `../../../AGENTS.md`, `../../../Dockerfile`, `../../../.dockerignore`, `../../../docker-compose.yml`, `../../../deploy.sh`, `../../../go.mod`, runtime file/template usage, and `../../../.gitlab-ci.yml`. Apply `../backend-security/SKILL.md` for credentials and `../ci-quality-gate/SKILL.md` for pipeline changes.

## Build and Runtime

- Prefer a multi-stage build: pinned compatible Go builder, minimal runtime stage, only the binary and required runtime assets.
- In the repository-root Docker build context, use Dockerfile sources such as `COPY go.mod go.sum ./` and download modules before copying source when that improves cache reuse.
- Do not run formatters as mutating build steps; CI should fail on drift.
- Build an appropriate production binary. A `-race` binary is for executed race testing/diagnostics, not a substitute for tests or the default optimized runtime.
- Run as a non-root user when compatible with required files and ports.
- Preserve required `file/` and `html_template/` assets only after inspecting runtime usage.

## Secrets and Build Context

- Never bake database credentials, API tokens, private keys, JWT secrets, `.env`, service-account files, or Git credentials into image layers.
- `../../../.gitignore` does not control Docker context; verify `../../../.dockerignore` explicitly.
- Avoid secret-bearing build args and Git global configuration that persist in layers. Use the platform's secret mechanism where available.
- Do not print CI/deployment tokens.

## Runtime Safety

- Preserve signal handling and implement graceful shutdown when the application owns long-lived connections.
- Review HTTP read/write/idle/header timeouts.
- Add health/readiness behavior only when semantics and deployment consumers are defined.
- Consider read-only filesystem, dropped capabilities, resource limits, and writable paths according to the actual platform.
- Pin critical bases/dependencies enough for reproducibility; do not change base families without compatibility testing.

## Current Repository Risks

- DANGEROUS: current single-stage `../../../Dockerfile` retains compiler, source, build credentials, and root runtime.
- DANGEROUS: `COPY . .` plus the current `../../../.dockerignore` can include `../../../configuration/.env` and `../../../helper/service-account.json`.
- DANGEROUS: CI/deploy scripts expose tokens and place environment files into the build context.
- MIGRATE-WHEN-TOUCHED: no graceful shutdown, server timeouts, or container health check are established.

## Verification

- Build the image; inspect stages, effective user, copied files, entrypoint, and expected runtime assets.
- Scan image/history/context for secret filenames and values without printing secrets.
- Smoke-test start, health, signal shutdown, and required templates/files.
- Report platform assumptions that require human confirmation.
