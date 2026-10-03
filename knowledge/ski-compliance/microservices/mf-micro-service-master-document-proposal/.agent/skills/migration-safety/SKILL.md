---
name: migration-safety
description: Plan and review schema/data migrations and rollout safety. Use for every migration or DDL/data transformation task.
---

# Migration Safety

Use this skill when its trigger above matches the task. Start with the relevant repository guidance at `../../DATABASE.md` and `.agent/INDEX.md`.

## Workflow

1. UNDERSTAND schema ownership, live engine/version, table size, and consumers.
2. INSPECT migration mechanism and deployment order.
3. PLAN expand/migrate/contract, backfill batches, locks, verification, and forward-fix.
4. IMPLEMENT only authorized local migration artifacts.
5. TEST against isolated representative data and old/new application versions.
6. REVIEW operational timing, progress, rollback limits, and recovery owner.

## Hard rules

Migration ownership requires confirmation; the workspace schema snapshot records the observed authorized server version, not every deployment. STOP if the target/schema source is ambiguous. Do not run production DDL/DML, assume `AutoMigrate` is the release path, or promise rollback for irreversible changes. Prefer bounded idempotent backfills and explicit verification queries.

## Verification and stop conditions

- Use fresh output from relevant tests, builds, static checks, query plans, or security-negative tests; do not claim checks passed when they were not run.
- Preserve current API, authorization, data-integrity, and side-effect contracts unless a behavior change is explicitly requested.
- Stop and ask for the missing owner/input when target schema, production access, migration policy, or required behavior is unclear. Continue independent read-only analysis.
- Keep changes scoped; inspect `git status` and review the diff before reporting completion.
