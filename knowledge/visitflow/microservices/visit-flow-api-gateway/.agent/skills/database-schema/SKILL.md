---
name: database-schema
description: "Design or review MySQL tables, columns, types, primary/foreign keys, constraints, indexes, timestamps, audit fields, or GORM schema mappings."
---

# Database Schema

Use with `migration-safety` for any deployed schema change and `mysql-performance` for index design.

Follow `UNDERSTAND -> INSPECT -> PLAN -> IMPLEMENT -> TEST -> REVIEW`.

## Establish the Source of Truth

This repository has no migration directory/tool, and startup `AutoMigrate` is commented out. The deployed schema is managed elsewhere or by an undocumented process.

Before proposing a schema change:

1. Identify the external schema/migration owner.
2. Inspect the deployed definition and current indexes.
3. Inspect corresponding `model/domain` structs, repositories/raw SQL, web DTOs, mappings, and tests.
4. Trace all reads/writes and compatibility requirements.
5. Plan the schema and application rollout together.

Never invent a repository migration convention or enable startup `AutoMigrate`.

## Integrity Review

For each field/table review:

- primary and business keys;
- foreign keys and update/delete actions;
- `UNIQUE`, `NOT NULL`, checks where supported/appropriate, and defaults;
- data type, length, collation, timezone/date representation, and signedness;
- single/composite indexes and column order;
- soft deletion, timestamps, and created/updated/deleted-by audit fields;
- existing invalid/duplicate/null data before tightening constraints.

Use database constraints for critical invariants when they match deployment and compatibility needs; application validation alone is not enough for concurrent writers.

## Repository-Specific Risks

- `domain.User` embeds `gorm.Model` while also marking `CompanyID` as a primary key and sharing named unique index `idx_users` across username/email/company. Confirm actual MySQL keys before changing it.
- `RoleMenuPermission.RoleID` is a string, while controller/service inputs begin as integers.
- `UserRole` and `RoleMenuPermission` are hard-deleted despite deleted/audit concepts elsewhere.
- Employment dates are stored as strings and queried with MySQL functions, affecting validation and index use.
- Raw queries depend on external tables: `companies`, `structures`, `structure_positions`, `departments`, and `user_departments`.
- Login SQL assumes `companies_id_index` exists.

These are evidence-backed investigation points, not permission for a redesign.

PREFERRED model example — `model/domain/session.go` declares a unique non-null refresh UUID and an indexed non-null user ID. Treat tags as mapping evidence only; verify the deployed schema.

## Index Design

- Derive indexes from real equality/range/join/order patterns and workload.
- Respect composite leftmost-prefix behavior.
- Avoid redundant indexes already covered by a composite index.
- Balance read improvement against storage and write amplification.
- Validate important designs with generated SQL and execution plans.

## GORM Mapping

- Current domain structs are persistence models; keep tags synchronized with the external schema.
- Confirm null representation (`*T`, `gorm.DeletedAt`) and zero/default semantics.
- Do not assume tags changed in Go update production schema.
- Search raw SQL and explicit column strings before renaming anything.

## Output of Schema Work

Document:

- exact invariant and compatibility goal;
- current and proposed schema;
- affected queries/models/APIs;
- index/constraint rationale;
- rollout and validation plan;
- migration owner and rollback/forward-fix limits.

Read `../../DATABASE.md`, `../../GORM.md`, and `../../DOMAIN.md` for repository details.
