# GORM Best Practices — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document defines standard practices and safety rules when using GORM `v1.25.2` in `mf-micro-service-structure`.

---

## 1. Transaction Safety

### Rule: Single Transaction Instance Propagation
- **Classification**: PREFERRED
- **Rule**: All mutations in a business operation must operate on the same transaction instance `tx *gorm.DB`.
- **Why**: Operating on `service.DB` inside an active transaction breaks atomicity and bypasses rollback if an error occurs.
- **Evidence**: `service/marketing_structure_service_impl.go`, `service/office_service_impl.go`

---

## 2. Updates & Zero Values

### Rule: Explicit Selection or Map Updates for Zero Values
- **Classification**: PREFERRED
- **Rule**: Never use `db.Save()` on partial structs. When persisting `false`, `0`, `""`, or `nil` values, use `.Select(...)` or `map[string]interface{}`:
  ```go
  tx.Model(&domain.MarketingStructure{}).
      Where("id = ? AND period = ?", id, period).
      Select("IsClosedEditArea", "ClosedEditAreaByID").
      Updates(map[string]interface{}{
          "is_closed_edit_area":    true,
          "closed_edit_area_by_id": auth.UserID,
      })
  ```
- **Why**: GORM `Updates(struct)` silently ignores zero-valued struct fields by default, while `Save()` overwrites all uninitialized fields with zero values.

---

## 3. Query Bounds & Association Loading

### Rule: Explicit Joins and Preload for Associations
- **Classification**: PREFERRED
- **Rule**: Always preload or join required child associations explicitly; avoid querying related records inside loops.
- **Why**: Prevents N+1 database roundtrips.
- **Evidence**: `repository/marketing_structure_repository_impl.go:38-46`

---

## 4. Parameterized Dynamic SQL

### Rule: Bind Dynamic Query Values with Placeholders
- **Classification**: PREFERRED
- **Rule**: Use `tx.Where("column = ?", value)` or `helper.ApplyFilter(tx, filters)`. Never interpolate untrusted user strings directly into SQL strings.
- **Why**: Prevents SQL injection vulnerabilities.

---

## 5. Soft Delete and Audit Invariants

### Rule: Preserve Soft Deletes and Audit Logging
- **Classification**: PREFERRED
- **Rule**: Deletions must set `deleted_at` and `deleted_by_id` and call `helper.CreateHistory(tx, model, helper.HistoryDelete, userID)`. Hard deletes (`.Unscoped().Delete(...)`) require explicit design justification.
- **Evidence**: `repository/office_repository_impl.go:44-49`
