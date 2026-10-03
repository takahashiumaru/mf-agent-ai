# .agent/GORM_BEST_PRACTICES.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## GORM Best Practices for Integrated Microservices

Guidelines for GORM data access layers across services interacting with `ski-api-gateway`.

---

## 1. Context & Query Discipline

- **Context Binding**: Always bind the HTTP request context: `db.WithContext(ctx)`.
- **Select Projection**: Explicitly list columns for large models: `.Select("id", "status", "created_at")`.
- **Result Bounds**: Bound every list query with `.Limit()` and `.Offset()` to prevent unbounded memory allocation and table full-scans.

---

## 2. Updates & Zero Values

- **Zero Values**: `db.Updates(struct)` ignores Go zero values (`0`, `false`, `""`). Use `.Select("IsActive", "Amount").Updates(...)` or `map[string]any` when writing zero values.
- **Avoid Save for Partial Updates**: Do not call `db.Save()` on partially populated structs.

---

## 3. Transactions

- Ensure all repository calls inside a transaction reuse the transaction handle (`tx *gorm.DB`), not the root database handle.
- Defer rollback safety in transaction helpers:
  ```go
  tx := db.Begin()
  defer func() {
      if r := recover(); r != nil {
          tx.Rollback()
          panic(r)
      }
  }()
  ```
