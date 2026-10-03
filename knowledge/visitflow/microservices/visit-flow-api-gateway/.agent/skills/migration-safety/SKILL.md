---
name: migration-safety
description: "Plan or review safe MySQL schema/data migrations, including columns, types, constraints, indexes, renames, deletes, backfills, and changes to large production tables."
---

# Migration Safety

Always use with `database-schema`; add `mysql-performance` for large tables or index changes.

Follow `UNDERSTAND -> INSPECT -> PLAN -> IMPLEMENT -> TEST -> REVIEW`.

## Repository Constraint

No migration system or schema source of truth exists in this repository. `AutoMigrate` is commented out. Before creating anything, locate the external migration owner/tool and follow its conventions. If it cannot be identified, stop and request direction rather than inventing a process.

## Required Analysis

Before a migration:

1. Trace every Go model, raw query, repository method, DTO, and downstream dependency using the object.
2. Confirm MySQL version and deployed schema/indexes.
3. Estimate table size, write traffic, lock/algorithm implications, duration, and index-build cost.
4. Determine whether old and new application versions will overlap.
5. Inspect current data for nulls, duplicates, invalid values, and backfill volume.
6. Define deployment order, validation, rollback or forward-fix strategy.

## Compatibility and Deploy Order

Prefer additive, backward-compatible sequences when practical:

`expand -> deploy compatible application -> backfill/validate -> switch reads/writes -> contract`

- Add nullable/new structures before requiring them.
- Support old and new representations during rolling deployment when necessary.
- Remove/rename only after all callers and data have moved.
- Do not combine a large schema change and large data rewrite blindly.

## NULL, Defaults, and Existing Rows

- Decide whether nil, zero, empty string, and missing have different meanings.
- Understand how MySQL fills old rows when adding a column.
- Avoid expensive table-wide defaults/backfills without checking engine/version behavior.
- Tighten to `NOT NULL` only after backfill and validation.
- Keep GORM update semantics aligned with the new null/default contract.

## Large Tables and Backfills

- Prefer online/in-place algorithms only after confirming MySQL support and operational limits.
- Separate schema change from large data backfill when it reduces risk.
- Batch backfills with checkpoints, bounded transactions, observability, and safe retries.
- Do not run row-by-row application migrations when set-based or bounded batch work is safer.
- Monitor lock waits, replication lag, DB load, and error rate.

## Index Changes

- Use real query patterns, selectivity, existing indexes, and `EXPLAIN` evidence.
- Avoid duplicate/redundant indexes.
- Account for build time, write amplification, disk, and replica impact.
- Never add an index solely because a column appears in `WHERE`.

## Destructive Changes

Column/table deletes, type narrowing, semantic changes, and renames are high risk. Inspect all repository and external consumers. Prefer staged replacement. Never promise rollback if data loss or irreversible conversion makes it false.

## Transaction and AutoMigrate Safety

- Do not assume MySQL DDL is fully transactional.
- Do not wrap large backfills in one long transaction.
- Do not use production `AutoMigrate` as a migration system.
- Correctness and recoverability outrank deployment speed.

## Validation Gate

- External migration owner/tool confirmed.
- Backward compatibility and mixed-version window reviewed.
- Existing data profiled.
- Table lock/build/backfill impact assessed.
- Application/model/query changes sequenced.
- Validation and observable success criteria defined.
- Honest rollback or forward-fix plan documented.

No preferred migration file can be cited because none exists locally. Read `../../DATABASE.md` and `../../WORKFLOWS.md` before schema work.
