---
name: database-schema
description: Review or change persistence models, tables, columns, keys, indexes, types, or constraints. Use whenever schema alignment is in scope.
---

# Database Schema

Use this skill when its trigger above matches the task. Start with the relevant repository guidance at `../../DATABASE.md` and `.agent/INDEX.md`.

## Workflow

1. UNDERSTAND the data contract and affected readers/writers.
2. INSPECT the authoritative schema source, GORM tags, indexes, and migration/deploy process.
3. PLAN backward-compatible changes and data/rollback needs.
4. IMPLEMENT model and migration changes only within the authorized scope.
5. TEST old/new application compatibility and representative data.
6. REVIEW deploy order, query plans, and rollback/forward-fix path.

## Hard rules

Schema source of truth is not established in this repository context. STOP before generating or executing DDL until the owner/process is confirmed. Check nullability, defaults, existing rows, keys, soft delete, and API serialization. A model tag alone does not prove deployed schema.

## Verification and stop conditions

- Use fresh output from relevant tests, builds, static checks, query plans, or security-negative tests; do not claim checks passed when they were not run.
- Preserve current API, authorization, data-integrity, and side-effect contracts unless a behavior change is explicitly requested.
- Stop and ask for the missing owner/input when target schema, production access, migration policy, or required behavior is unclear. Continue independent read-only analysis.
- Keep changes scoped; inspect `git status` and review the diff before reporting completion.
