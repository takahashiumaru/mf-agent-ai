---
name: database-schema
description: Use when analyzing table schemas, composite primary keys, foreign key constraints, or adding columns to domain models.
---

# Database Schema Skill

## Guidelines
1. **Domain Struct as GORM Model**: Add fields with proper `gorm:"..."` tags in `model/domain/<entity>.go`.
2. **Audit Fields**: Ensure tables have `CreatedByID`, `UpdatedByID`, and nullable `DeletedByID *uint`.
3. **Composite Keys**: For transaction tables (`sales_ffs`, `sales_distributors`, `stock_distributors`), maintain the exact composite primary key definition.
4. **No Destructive Changes**: Do not remove or alter existing database columns without backward-compatibility analysis.

See [.agent/DATABASE.md](../../DATABASE.md).
