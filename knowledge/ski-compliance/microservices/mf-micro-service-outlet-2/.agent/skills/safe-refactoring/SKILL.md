---
name: safe-refactoring
description: Refactor code while preserving externally observable behavior. Use when cleanup, extraction, or structural change is requested without intended behavior changes.
---

# Safe Refactoring

Use this skill when its trigger above matches the task. Start with the relevant repository guidance at `../../REFACTORING.md` and `.agent/INDEX.md`.

## Workflow

1. UNDERSTAND current behavior and the no-change contract.
2. INSPECT callers, route/middleware, tests, DB effects, transactions, and ETL/audit.
3. PLAN characterization tests and one focused edit.
4. IMPLEMENT incrementally without bundling policy changes.
5. TEST behavior, errors, data effects, and compatibility.
6. REVIEW the final diff and state any unverified equivalence.

## Hard rules

Do not combine schema, API, auth, dependency, or cross-database redesign with routine cleanup. Preserve transaction handles and resolver direction. Security fixes require explicit scope even when a defect is found. Stop if behavior cannot be characterized safely.

## Verification and stop conditions

- Use fresh output from relevant tests, builds, static checks, query plans, or security-negative tests; do not claim checks passed when they were not run.
- Preserve current API, authorization, data-integrity, and side-effect contracts unless a behavior change is explicitly requested.
- Stop and ask for the missing owner/input when target schema, production access, migration policy, or required behavior is unclear. Continue independent read-only analysis.
- Keep changes scoped; inspect `git status` and review the diff before reporting completion.
