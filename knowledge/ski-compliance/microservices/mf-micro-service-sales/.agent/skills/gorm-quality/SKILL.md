---
name: gorm-quality
description: Use when writing GORM queries, configuring associations, managing transactions, handling zero-value updates, and preventing N+1 queries.
---

# GORM Quality Skill

## Guidelines
1. **Transactions**: Start transactions exclusively in the Service layer (`tx := service.DB.Begin()`, `defer helper.CommitOrRollback(tx)`). Pass `tx` to repositories.
2. **Partial Updates**: Do NOT use `Save()` for partial updates. Use `.Updates(&model)` with pointers or explicit map updates to preserve zero values.
3. **Joins vs Preload**: Use `.Joins("Relation")` for BelongsTo relationships to execute single SQL JOIN queries.
4. **No AutoMigrate**: Do not run `db.AutoMigrate()` during application bootstrap.
5. **Audit Logging**: Always call `helper.CreateHistory(...)` inside mutation methods.

See [.agent/GORM_BEST_PRACTICES.md](../../GORM_BEST_PRACTICES.md) and [.agent/GORM.md](../../GORM.md).
