---
name: database-schema
description: Use when designing or changing MySQL tables, columns, keys, indexes, constraints, defaults, data types, soft deletes, or audit fields.
---

# Database Schema

## Outcome

Keep schema changes consistent with domain rules, GORM mappings, API contracts, existing data, and deployment reality.

## Required Reading

Read `../../../AGENTS.md`, `../../DATABASE.md`, `../../DOMAIN.md`, and affected models/repositories/DTOs. Apply `../migration-safety/SKILL.md` for any applied schema change and `../mysql-performance/SKILL.md` for indexes.

## Inspection Checklist

Before proposing or changing schema, inspect:

- primary keys and identity strategy;
- foreign keys and delete/update behavior;
- `UNIQUE`, `NOT NULL`, checks, and other integrity constraints;
- defaults and the difference between absent, zero, empty, and `NULL`;
- data types, precision, length, collation, and time representation;
- existing single and composite indexes;
- `deleted_at`, timestamps, creator/updater/deleter audit fields;
- GORM model tags, associations, response mappings, repositories, API request/response DTOs;
- established migration ownership and production deployment process.

Prefer database constraints for critical invariants when compatible with current data and application behavior. Application validation alone is not a durable integrity boundary.

## Repository Constraints

- Models in `../../../model/domain/` are both GORM persistence/domain structs and often own `To...Response` mappings; do not invent a parallel persistence layer for a focused task.
- Survey models use explicit fields and composite keys. Verify deletion behavior and index implications from the affected model, SQL and schema.
- No established migration directory or production migration command was found. Do not enable `AutoMigrate` or invent a migration framework without human confirmation.
- Preserve `company_id`, `structure_id`, subordinate, location, and period ownership constraints.

## Decision Rules

- Additive schema changes are preferred before destructive ones when old and new application versions may overlap.
- A new index needs evidence from real predicates, joins, ordering, cardinality, and existing index definitions.
- A foreign key or unique constraint requires an existing-data audit before enforcement.
- A default is business behavior: verify how old rows and omitted request fields should behave.
- A rename/delete is a compatibility change across SQL, models, DTOs, reports, stored procedures, and deployments.

## Repository Examples

- LEGACY — DO NOT COPY FOR NEW CODE: relying only on application checks for critical uniqueness or ownership where the database can safely enforce the invariant.

## Completion Gate

- Document compatibility, existing-data handling, application rollout order, locking risk, and rollback/forward-fix strategy.
- Verify every referenced column/table/index against the authoritative schema source or environment available for the task.
- If the authoritative production schema is unavailable, identify that gap and stop short of claiming the migration is production-safe.

## Local navigation and limits

Use `../../PREFERRED_PATTERNS.md` for scoped examples and `../../TESTING.md` for facilities. Survey route/service/repository anchors are outlet_survey or distributor; product repositories use customer_material filenames. Repositories take `*gorm.DB`; services select the read/write handle. SQL mocks check generated statements and calls, not live isolation or replication.
