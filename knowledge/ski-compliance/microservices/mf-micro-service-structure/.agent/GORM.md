# GORM Guide & Best Practices — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## GORM Initialization & Configuration

GORM is initialized in `app/database.go` with version `v1.25.2`:
```go
database, err := gorm.Open(mysql.Open(dsn), &gorm.Config{
    Logger: newLogger,
})
```

## Model Strategy & Association Tags

- **Primary & Foreign Keys**:
  ```go
  type MarketingStructure struct {
      ID                  string            `gorm:"size:20;primaryKey;not null;uniqueIndex:idx_marketing_structure"`
      Period              string            `gorm:"size:6;not null;primaryKey;uniqueIndex:idx_marketing_structure"`
      Code                string            `gorm:"size:20;not null;primaryKey"`
      MarketingPositionID string            `gorm:"size:30;uniqueIndex:idx_marketing_structure"`
      MarketingPosition   MarketingPosition `gorm:"references:id,period"`
      // ...
  }
  ```
- **Composite Primary Keys**: Many entities are partitioned by both `ID` / `Code` and `Period`. GORM queries must specify both keys when locating records.

## Query Construction & Filtering

- **Dynamic Filters (`helper.ApplyFilter`)**:
  - Filter maps parsed from query parameters (`field.eq`, `field.like`, `field.in`, `field.gt`, etc.) are passed to `helper.ApplyFilter(tx, filters)`.
  - Joins and preloads are chained explicitly:
  ```go
  tx = tx.
      Joins("CreatedBy").
      Joins("MarketingPosition").
      Preload("MarketingStructureBoss.User").
      Joins("Office").
      Joins("Division").
      Joins("UpdatedBy").
      Joins("User")
  ```

## Safe Update and Mutation Rules

1. **Avoid `Save` for Partial Updates**: `db.Save(&struct)` writes all fields including empty/zero values, potentially clearing unset columns.
2. **Zero-Value Updates**: When updating booleans (`IsClosedEditArea`, `IsClosedEditAll`, `IsDummy`, `IsBigCity`) or nullable pointers (`UserID`, `MarketingStructureBossID`), use `Select(...)` or `map[string]interface{}`:
   ```go
   db.Model(&marketingStructure).Select("IsClosedEditArea", "ClosedEditAreaByID").Updates(map[string]interface{}{
       "is_closed_edit_area":  true,
       "closed_edit_area_by_id": auth.UserID,
   })
   ```
3. **Transaction Propagation**:
   - Always operate on the transaction instance `tx *gorm.DB`.
   - Never call `service.DB.Create(...)` or `service.DB.Find(...)` inside a method where `tx` has been opened.

## GORM Anti-Patterns to Guard Against

- **N+1 Database Queries**: Avoid iterating over slices and executing `db.Find()` or `db.First()` inside loops. Prefer batch fetching with `Where("code IN ?", codes)` or using GORM `Preload`.
- **Unbounded Queries**: Large tables like `marketing_structures` must be constrained with `period` filters or pagination.
- **Raw SQL Injection Risk**: Never construct SQL with `fmt.Sprintf("WHERE code = '%s'", userInput)`. Always pass parameterized arguments: `Where("code = ?", userInput)`.
- **Ignoring RowsAffected**: On update/delete operations, check `tx.RowsAffected` when the business contract requires confirming the record existed.
