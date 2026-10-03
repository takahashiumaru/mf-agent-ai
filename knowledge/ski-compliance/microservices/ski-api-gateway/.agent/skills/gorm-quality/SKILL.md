---
name: gorm-quality
description: Ensure safe GORM queries, updates, associations, and transaction management in services integrated with ski-api-gateway. Use when inspecting or modifying GORM database logic.
---

# GORM Quality Skill

## Purpose & Trigger
Guide safe and correct usage of GORM across services interacting with `ski-api-gateway`.

## Workflow
1. **Understand**: Identify affected model, query, or transaction.
2. **Inspect**: Check context attachment (`db.WithContext(ctx)`), zero-value handling in updates, and association loading.
3. **Plan**: Formulate explicit field projections (`.Select()`) and safe transaction boundaries.
4. **Implement**: Use map/Select updates for zero values; avoid unconstrained `Save()`.
5. **Verify**: Test query execution, error returns, and transaction rollback paths.

## Hard Rules
- Always check `result.Error`.
- Never use `Save()` for partial updates.
- Pass transaction instances (`tx *gorm.DB`) to all repository methods inside transactions.
