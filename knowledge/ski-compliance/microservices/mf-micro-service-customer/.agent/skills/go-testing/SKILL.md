---
name: go-testing
description: Add or update meaningful Go tests for behavior and regressions. Use when changing behavior or tests.
---

# Go Testing

Use this skill when its trigger above matches the task. Start with the relevant repository guidance at `../../TESTING.md` and `.agent/INDEX.md`.

## Workflow

1. UNDERSTAND the contract and failure cases.
2. INSPECT existing tests, package seams, fixtures, and external dependencies.
3. PLAN unit/integration scope and deterministic fixtures.
4. IMPLEMENT the smallest regression test before or with the behavior change.
5. TEST focused packages, then broader module checks when feasible.
6. REVIEW isolation, cleanup, race risk, and assertion quality.

## Hard rules

Use synthetic fixtures and isolated databases only. Cover valid, invalid, denied, zero-value, not-found, and side-effect paths as relevant. Do not weaken assertions/gates to get a pass. Confirm exact CI commands in `.gitlab-ci.yml`; report unavailable DB or race prerequisites.

## Verification and stop conditions

- Use fresh output from relevant tests, builds, static checks, query plans, or security-negative tests; do not claim checks passed when they were not run.
- Preserve current API, authorization, data-integrity, and side-effect contracts unless a behavior change is explicitly requested.
- Stop and ask for the missing owner/input when target schema, production access, migration policy, or required behavior is unclear. Continue independent read-only analysis.
- Keep changes scoped; inspect `git status` and review the diff before reporting completion.
