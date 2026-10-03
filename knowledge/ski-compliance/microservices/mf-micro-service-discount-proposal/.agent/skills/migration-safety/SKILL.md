---
name: migration-safety
description: Plan, draft, review, and execute safe MySQL schema migrations and data backfills without runtime table locks or service interruptions. Use whenever altering database schema or running SQL migration scripts.
---

# migration-safety

Guides safe MySQL DDL execution and data migration in `mf-micro-service-discount-proposal`.

## Core References
- [DATABASE.md](../../DATABASE.md) — Schema source of truth, migration policy.
- [CONSTRAINTS.md](../../CONSTRAINTS.md) — Non-negotiable database constraints.
- [WORKFLOWS.md](../../WORKFLOWS.md) — Workflow 5: Changing database schema.

## Standard Workflow
1. **Understand Change**: Determine whether adding columns, adding indexes, or altering existing structures.
2. **Review AutoMigrate Policy**:
   - Runtime `AutoMigrate` is intentionally disabled in `app/database.go`.
   - All DDL changes MUST be authored as standalone, idempotent SQL scripts.
3. **Draft SQL Migration Script**:
   - Use `app/database/before_auto_migrate.sql` or create dedicated timestamped SQL scripts.
   - For new columns, provide safe defaults and allow `NULL` during rollout.
   - For indexes, use `CREATE INDEX ...` and test execution on staging first.
4. **Plan Expand-and-Contract Sequencing**:
   - Step 1: Expand database schema (add new column).
   - Step 2: Deploy Go code reading/writing new column.
   - Step 3: Backfill historical data in bounded batches.
   - Step 4: Contract (drop unused legacy columns after full verification).
5. **Verify**:
   - Ensure DDL script executes without errors against target MySQL version.
   - Verify `go build -o /dev/null .` compiles with updated Go domain models.

## Hard Guardrails
- **NEVER** uncomment `database.AutoMigrate(...)` in `app/database.go` for runtime execution.
- **NEVER** drop or rename production columns in a single deployment step.
- **ALWAYS** test DDL migration scripts on a copy of the database before production rollout.
