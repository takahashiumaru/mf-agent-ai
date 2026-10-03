---
name: migration-safety
description: Use when adding or changing migrations, columns, types, constraints, indexes, tables, large-table operations, or data backfills.
---

# Migration Safety

## Core Principle

Treat schema rollout as a compatibility and data-integrity operation, not merely a DDL edit. Correctness and deployability outrank convenience.

## Required Workflow

`UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW`

Identify the authoritative migration system and deployment order before creating an artifact. If ownership remains unknown, stop short of claiming the migration is deployable.

## Repository Reality

- **NOT CLEARLY ESTABLISHED:** no SQL/Go migration directory, migration tool, or migration command is present.
- **LEGACY — DO NOT COPY:** `app/database.go` invokes `AutoMigrate` with an empty/commented model list. Do not populate it as an ad hoc production migration.
- **HIGH RISK:** repositories call stored procedures and named indexes whose definitions are outside this repository.
- No repository-local preferred migration file exists. The preferred action is to confirm the external schema owner and follow its real convention.

## Safety Review

### Compatibility

- Determine whether old and new application versions overlap during deploy.
- Prefer an additive expand phase before code relies on a new column/index; contract only after old code and data dependencies are gone.
- Preserve reads/writes from both versions during the overlap window.

### Existing Data

- For each new column, decide nullability, default behavior, old-row values, backfill strategy, and GORM/API nil semantics.
- Separate large data backfills from schema DDL when that reduces locks, transaction size, or deployment risk.
- Batch backfills and make restart/idempotency behavior explicit.

### Large Tables and Locks

- Establish approximate table size, write traffic, MySQL version, online-DDL capability, lock behavior, index-build duration, disk headroom, and replication impact.
- Do not run row-by-row application migrations when set-based or controlled batches are safer.
- Do not add a large-table constraint before invalid existing data is identified and handled.

### Destructive Changes

- Renames, drops, type narrowing, and irreversible transforms are high risk. Inspect every code, query, report, stored procedure, and external consumer reference.
- Do not promise rollback when it would lose data. Define a forward-fix or restore strategy instead.

## Index Changes

- Use actual query patterns and plans; check duplicate/composite indexes and write cost.
- Do not make application correctness depend on an index being present before its deployment succeeds.
- Validate any `FORCE INDEX` names used by repositories.

## Required Deliverable

Document the deploy sequence, compatibility window, data/backfill plan, expected locking, validation queries, rollback/forward-fix plan, and human owner. Never invent a migration command for this repository. Unknown migration ownership is a blocker: ask the maintainer/deployment owner before creating or validating a deployable artifact.

Read `.agent/DATABASE.md`; also use `database-schema` and `mysql-performance` for schema/index changes.
