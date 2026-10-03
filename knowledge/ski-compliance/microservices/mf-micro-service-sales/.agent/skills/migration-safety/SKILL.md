---
name: migration-safety
description: Use when managing schema changes, inspecting migration scripts, and ensuring safe database schema evolutions without AutoMigrate.
---

# Migration Safety Skill

## Guidelines
1. **Disable Runtime AutoMigrate**: Never run `AutoMigrate` inside application bootstrap code.
2. **Backward Compatibility**: When adding new columns, ensure they are nullable or have safe defaults so existing application instances do not fail.
3. **Synchronization Awareness**: Review whether table alterations impact MSSQL ETL sync mappings in `helper.EtlToMssql`.

See [.agent/DATABASE.md](../../DATABASE.md).
