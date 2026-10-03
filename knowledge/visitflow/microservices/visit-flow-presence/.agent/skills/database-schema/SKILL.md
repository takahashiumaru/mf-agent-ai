---
name: database-schema
description: Use when changing MySQL tables, columns, types, primary keys, foreign keys, constraints, defaults, indexes, timestamps, or soft-delete fields.
---

# Database Schema

## Core Principle

Schema changes must preserve data integrity and match the deployed MySQL schema, application behavior, and API contract. GORM model tags are not a migration plan.

## Required Workflow

`UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW`

Inspect the GORM model, repositories, domain behavior, DTO mappings, tests, current indexes/constraints, and actual schema-management owner before proposing a change.

## Repository Reality

- `model/domain/` combines domain and GORM persistence models; schema-facing changes normally affect these structs directly.
- **PREFERRED evidence:** explicit table names, column tags, and composite indexes in `model/domain/presence.go`, `model/domain/leave.go`, and `model/domain/leave_quota.go`.
- **ACCEPTABLE evidence:** uniqueness constraints in office/work-hour assignment models and indexes in `model/domain/calendar.go` and meeting models.
- **LEGACY:** `app/database.go` contains an empty/commented `AutoMigrate` list. It is not an established production migration mechanism.
- **NOT CLEARLY ESTABLISHED:** migration files, migration command, deployed MySQL version, stored-procedure definitions, and the authoritative production schema.

## Design Review

- Verify primary/business key generation and every relationship used by GORM joins.
- Use `NOT NULL`, `UNIQUE`, foreign keys, and checks for critical invariants where compatible with the real schema and deployment process; do not rely on request validation alone.
- For a new column, define nullability, default behavior for old rows, Go zero/nil semantics, API exposure, and backfill needs.
- Preserve `created_at`, `updated_at`, `deleted_at`, and actor/audit fields according to the affected model.
- Determine whether delete means GORM soft delete, explicit `Unscoped` hard delete, or a business status transition; all patterns exist.

## Index Review

- Derive indexes from real predicates, joins, ordering, cardinality, and frequency.
- Check composite column order and redundant prefix indexes.
- Include write amplification, storage, and index-build cost; do not add one index per filter field.
- Validate named `FORCE INDEX` references against the deployed schema before changing their indexes.

## Cross-Layer Checklist

For every accepted schema change, inspect/update as applicable:

1. approved migration artifact in the real migration system;
2. `model/domain` struct and GORM tags;
3. repository predicates, selects, scans, and raw SQL;
4. request/response DTOs and mapping;
5. business validation and error mapping;
6. fixtures/mocks and repository/service/API tests;
7. rollback or forward-fix strategy.

Do not create or enable `AutoMigrate` to bypass the missing migration source of truth. Read `.agent/DATABASE.md` and use `migration-safety` for deployment planning.
