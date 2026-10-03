---
name: migration-safety
description: Execute safe, zero-downtime database migrations and backfills. Use when applying DDL changes or large table migrations.
---

# Migration Safety Skill

## Purpose & Trigger
Enforce the expand-and-contract migration lifecycle, online DDL verification, and rollback planning.

## Workflow
1. **Understand**: Scope the schema migration and affected traffic volume.
2. **Inspect**: Check table lock behavior, index creation cost, and backwards compatibility with running application pods.
3. **Plan**: Structure changes into non-breaking steps: Expand -> Deploy Code -> Backfill Data -> Verify -> Contract.
4. **Implement**: Execute idempotent DDL migrations.
5. **Verify**: Test rolling upgrades and rollback procedures.

## Hard Rules
- Disable runtime AutoMigrate in production environments.
- Batch data backfills to avoid holding long table locks.
