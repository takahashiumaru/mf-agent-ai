# GORM Best Practices — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

Practical guidelines for writing safe, performant, and correct GORM code in this repository.

---

## 1. Transaction Safety
1. **Service Layer Initiates**: Always begin transactions in the service layer:
   ```go
   tx := service.DB.Begin()
   err := tx.Error
   helper.PanicIfError(err)
   defer helper.CommitOrRollback(tx)
   ```
2. **Pass Active `tx`**: Pass `tx` into every repository method. Repositories must NEVER call `db.Begin()` themselves.
3. **No Mixed Connections**: Ensure all mutations inside a business flow operate on the passed `tx` rather than `service.DB` or global instances.

---

## 2. Safe Update Strategies & Zero Values
- **The Zero-Value Problem**: Calling `db.Updates(&struct)` ignores Go zero values (`false`, `0`, `""`).
- **Safe Alternatives**:
  - **Pointer Fields**: Declare boolean or numeric fields as pointers in domain structs (e.g. `OutletUpdated *bool`).
  - **Explicit Map Updates**: Use `db.Model(&model).Updates(map[string]interface{}{"is_active": false})`.
  - **Select Columns**: Use `db.Model(&model).Select("OutletUpdated").Updates(&model)`.
- **Never Use `db.Save()` for Partial Updates**: `Save()` updates all fields in the database table and will inadvertently overwrite unchanged columns with struct defaults.

---

## 3. Query Optimization & Preventing N+1
- **Prefer `Joins` for BelongsTo Relationships**:
  ```go
  // Preferred: Executes a single SQL JOIN query
  tx.Joins("Outlet").Joins("Distributor").Find(&bridgingOutlets)
  ```
- **Avoid Queries in Loops**:
  - ❌ **ANTI-PATTERN**:
    ```go
    for _, item := range items {
        db.Where("outlet_id = ?", item.OutletID).Find(&outlets)
    }
    ```
  - ✅ **PREFERRED**: Fetch related items in batches using `IN (...)` or use `Joins` / `Preload`.

---

## 4. Query Limits & Pagination
- High-volume tables (`sales_ffs`, `sales_distributors`, `stock_distributors`) must not be queried without bounds.
- Apply `.Limit(500)` or pagination limits on all list endpoints.

---

## 5. Audit Logging with History
- Every data mutation in repositories must invoke change logging:
  ```go
  err := helper.CreateHistory(db, model, helper.HistoryUpdate, userId)
  helper.PanicIfError(err)
  ```
- History logging must execute inside the active transaction `db` to ensure audit integrity.
