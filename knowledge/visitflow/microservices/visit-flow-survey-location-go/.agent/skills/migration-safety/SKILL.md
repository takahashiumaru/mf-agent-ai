---
name: migration-safety
description: Use when adding or altering columns, constraints, indexes, tables, data migrations, or any schema operation that may affect production deployments or large tables.
---

# Migration Safety

## Outcome

Design deployable schema evolution without assuming rollback is safe or that production can tolerate blocking DDL.

## Repository Boundary

Read `../../../AGENTS.md`, `../../DATABASE.md`, `../../CONSTRAINTS.md`, and apply `../database-schema/SKILL.md`. This repository has no established migration command or authoritative migration directory. Do not run `AutoMigrate`, create an ad hoc production process, or apply DDL without explicit ownership and environment confirmation.

## Safety Review

1. Identify old and new application versions that may share the schema.
2. Inspect table size, write traffic, existing data, replicas, and maintenance constraints.
3. Determine locking, index-build, duration, and disk implications.
4. Define `NULL`, default, and old-row behavior.
5. Separate large data backfills from schema DDL when that reduces risk.
6. Choose deploy order and a realistic recovery strategy.

## Preferred Sequence

When compatible with the change:

`expand -> deploy compatible application -> backfill/verify -> contract`

The exact sequence must reflect actual consumers and database capabilities; it is not permission to perform every phase in one release.

## Rules

- Prefer additive changes before destructive changes.
- Treat type changes, table/column renames, deletes, new `NOT NULL`, unique constraints, and foreign keys as high risk.
- Audit invalid/duplicate/null rows before adding constraints.
- For a new required column, plan how existing rows are populated and when application writes switch.
- Avoid huge row-by-row application migrations when safe SQL or bounded batch backfills are available.
- Make backfills resumable and observable where practical; bound batches and avoid long transactions.
- Coordinate online DDL options with the actual MySQL version and production operations owner.
- Do not promise rollback for destructive or lossy transforms. Prefer a forward fix when rollback would corrupt or discard data.
- Inspect every usage before rename or deletion, including GORM models, raw SQL, stored procedures, reports, DTOs, and external consumers.

## Index Changes

Apply `../mysql-performance/SKILL.md`. Confirm the index is not redundant, column order matches real queries, and the read benefit justifies build/write/storage cost. Plan large index builds as production operations, not merely code changes.

## Repository Examples

- DANGEROUS: enabling the currently unestablished `AutoMigrate` path as a production migration solution.
- MIGRATE-WHEN-TOUCHED: schema-dependent raw SQL and stored procedures in repository reporting paths require coordinated compatibility review.
- ACCEPTABLE: domain models provide evidence of expected columns, but they are not proof of the live production schema.

## Completion Gate

- Record rollout steps, compatibility window, validation query, expected duration, lock risk, monitoring, and abort criteria.
- State whether recovery is rollback, restore, or forward fix.
- List the human confirmations still needed: production schema owner, MySQL version, table size, traffic window, and deployment ordering.
