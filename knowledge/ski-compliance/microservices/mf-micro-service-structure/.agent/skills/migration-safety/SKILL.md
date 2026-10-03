---
name: migration-safety
description: Plan, execute, and verify database schema migrations and SQL DDL scripts safely. Use whenever creating or altering database schema, tables, views, or indexes.
---

# Migration Safety Skill

## Purpose
Ensure zero-downtime, safe schema migrations and DDL scripts without breaking existing application behavior.

## When to Use
Use when applying DDL changes, creating or altering views (e.g. `after_auto_migrate.sql`), or introducing new database indexes.

## Workflow
1. **Understand**: Check target database version (MySQL 5.7 / 8.0) and table size.
2. **Inspect**: Check locking implications of DDL statements.
3. **Plan**: Write backward-compatible, versioned SQL migration scripts.
4. **Implement**:
   - For view updates, test script in `app/database/after_auto_migrate.sql`.
   - For column additions, ensure defaults or nullability allow existing code to operate without failure.
5. **Verify**:
   - Validate DDL on a local/staging instance before requesting production execution.

## Hard Rules
- Never execute destructive DDL (`DROP TABLE`, `DROP COLUMN`) without explicit authorization and a verified rollback plan.

## References
- [.agent/DATABASE.md](../../DATABASE.md)
- [.agent/CONSTRAINTS.md](../../CONSTRAINTS.md)
