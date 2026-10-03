---
name: gorm-quality
description: Review and modify GORM queries, updates, associations, transactions, and audit logging safely. Use whenever modifying GORM models, repository methods, or transaction boundaries.
---

# GORM Quality Skill

## Purpose
Ensure safe, transactional, and injection-free GORM database operations in `mf-micro-service-structure`.

## When to Use
Use whenever modifying repositories, domain models, GORM queries, transactions, or update logic.

## Workflow
1. **Understand**: Check affected entities, composite keys (`ID`, `Period`), and associations.
2. **Inspect**: Trace callers in the service layer to ensure transaction propagation (`tx *gorm.DB`).
3. **Plan**: Design queries with explicit joins/preloads and parameterized filters.
4. **Implement**:
   - For writes, operate exclusively on the transaction `tx`.
   - For zero-value updates, use explicit `.Select(...)` or `map[string]interface{}`.
   - For deletes, maintain soft delete and call `helper.CreateHistory(...)`.
5. **Verify**:
   - Test queries with bound parameters.
   - Run `go test ./...` and `go vet ./...`.

## Hard Rules
- Never use `db.Save()` on partial structs.
- Never use base `service.DB` inside an active transaction.
- Never concatenate raw strings into SQL queries.

## References
- [.agent/GORM_BEST_PRACTICES.md](../../GORM_BEST_PRACTICES.md)
- [.agent/GORM.md](../../GORM.md)
- [.agent/DATABASE.md](../../DATABASE.md)
