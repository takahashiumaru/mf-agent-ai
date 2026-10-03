---
name: gorm-quality
description: Safely review or change GORM models, queries, mutations, associations, and transactions. Use whenever persistence behavior or SQL changes.
---

# Gorm Quality

Use this skill when its trigger above matches the task. Start with the relevant repository guidance at `../../GORM_BEST_PRACTICES.md` and `.agent/INDEX.md`.

## Workflow

1. UNDERSTAND rows, filters, ordering, side effects, and API expectations.
2. INSPECT model tags, repository callers, transaction owner, resolver handles, and tests.
3. PLAN predicate, writable fields, association strategy, and failure behavior.
4. IMPLEMENT using the existing transaction handle and bounded conditions.
5. TEST zero values, not-found, affected rows, rollback, and delete semantics.
6. REVIEW generated/query behavior and result equivalence.

## Hard rules

Check every GORM finisher error. `Updates(struct)` skips zero values by default; use explicit allowed fields when zero values must persist. Avoid `Save` for partial updates. Treat `Unscoped` as potentially physical deletion. Do not fall back from a transaction to the base DB. Parameterize values and allowlist dynamic identifiers.

## Verification and stop conditions

- Use fresh output from relevant tests, builds, static checks, query plans, or security-negative tests; do not claim checks passed when they were not run.
- Preserve current API, authorization, data-integrity, and side-effect contracts unless a behavior change is explicitly requested.
- Stop and ask for the missing owner/input when target schema, production access, migration policy, or required behavior is unclear. Continue independent read-only analysis.
- Keep changes scoped; inspect `git status` and review the diff before reporting completion.
