---
name: go-quality
description: Review or change Go code using the repository structure, conventions, and verification commands. Use for every Go implementation or review task.
---

# Go Quality

Use this skill when its trigger above matches the task. Start with the relevant repository guidance at `../../GO_BEST_PRACTICES.md` and `.agent/INDEX.md`.

## Workflow

1. UNDERSTAND current and intended behavior.
2. INSPECT callers, adjacent examples, errors, context, and side effects.
3. PLAN the smallest compatible change.
4. IMPLEMENT with explicit flow and existing package ownership.
5. TEST targeted behavior; check race-sensitive code when relevant.
6. REVIEW formatting, diff scope, logs, and API/data compatibility.

## Hard rules

Follow `CODE_STYLE.md`, `ARCHITECTURE.md`, and `TECH_DEBT.md`. Preserve public identifiers and error/response contracts. Propagate context only where supported; wider propagation is a migration. Do not ignore meaningful errors, add generic abstractions without a seam, or refactor unrelated code.

## Verification and stop conditions

- Use fresh output from relevant tests, builds, static checks, query plans, or security-negative tests; do not claim checks passed when they were not run.
- Preserve current API, authorization, data-integrity, and side-effect contracts unless a behavior change is explicitly requested.
- Stop and ask for the missing owner/input when target schema, production access, migration policy, or required behavior is unclear. Continue independent read-only analysis.
- Keep changes scoped; inspect `git status` and review the diff before reporting completion.
