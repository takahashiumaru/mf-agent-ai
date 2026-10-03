---
name: ci-quality-gate
description: Change CI pipelines, build/test commands, caching, or release quality gates. Use for `.gitlab-ci.yml` or CI workflow changes.
---

# Ci Quality Gate

Use this skill when its trigger above matches the task. Start with the relevant repository guidance at `../../QUALITY_GATES.md` and `.agent/INDEX.md`.

## Workflow

1. UNDERSTAND existing stages, runner environment, branch/tag rules, and release contract.
2. INSPECT `.gitlab-ci.yml`, Docker build, module layout, and existing commands.
3. PLAN mandatory versus conditional gates and rollout impact.
4. IMPLEMENT a focused pipeline change with useful failure output.
5. TEST syntax and commands in a compatible local/CI environment.
6. REVIEW cache keys, secret handling, architecture, and failure behavior.

## Hard rules

Derive commands from the repo CI. Do not add unavailable/flaky tools as unconditional blockers without a rollout plan. Preserve useful diagnostics and do not weaken a failing gate to finish. Never print masked variables or expose credentials.

## Verification and stop conditions

- Use fresh output from relevant tests, builds, static checks, query plans, or security-negative tests; do not claim checks passed when they were not run.
- Preserve current API, authorization, data-integrity, and side-effect contracts unless a behavior change is explicitly requested.
- Stop and ask for the missing owner/input when target schema, production access, migration policy, or required behavior is unclear. Continue independent read-only analysis.
- Keep changes scoped; inspect `git status` and review the diff before reporting completion.
