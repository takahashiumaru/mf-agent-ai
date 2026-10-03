---
name: docker-production
description: Review or change Docker image build and container runtime behavior. Use for Dockerfile, image, entrypoint, or deployment-container changes.
---

# Docker Production

Use this skill when its trigger above matches the task. Start with the relevant repository guidance at `../../WORKFLOWS.md` and `.agent/INDEX.md`.

## Workflow

1. UNDERSTAND runtime contract, port, signals, health, and target architecture.
2. INSPECT `Dockerfile`, `.dockerignore`, compose, CI build, and required certificates/timezone/files.
3. PLAN image/runtime changes compatible with current deployment.
4. IMPLEMENT minimal container changes; preserve secret injection outside image layers.
5. TEST build, startup, signal shutdown, and non-root/file access where supported.
6. REVIEW image contents, tags, health behavior, and CI parity.

## Hard rules

Do not assume production runtime or orchestrator from Docker files alone. Never bake credentials into image or logs. Preserve Go build tags/architecture, CA certificates, timezone and required filesystem permissions. Health checks and non-root execution require compatibility review.

## Verification and stop conditions

- Use fresh output from relevant tests, builds, static checks, query plans, or security-negative tests; do not claim checks passed when they were not run.
- Preserve current API, authorization, data-integrity, and side-effect contracts unless a behavior change is explicitly requested.
- Stop and ask for the missing owner/input when target schema, production access, migration policy, or required behavior is unclear. Continue independent read-only analysis.
- Keep changes scoped; inspect `git status` and review the diff before reporting completion.
