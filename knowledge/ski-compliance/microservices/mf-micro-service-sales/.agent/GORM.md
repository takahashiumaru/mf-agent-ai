# GORM Patterns & Best Practices — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document details GORM usage, model mapping, queries, transactions, association handling, and repository-specific practices.

---

## 1. GORM Version & Setup
- **GORM Version**: `gorm.io/gorm v1.25.2` with `gorm.io/hints v1.1.2`.
- **Initialization**: [app/database.go](../app/database.go).
- **Logger**: Uses `logger.New` configured with `SlowThreshold: 1 * time.Second` and `LogLevel: logger.Info`.

---

## 2. Model Mapping Strategy: Strategy A (Direct Domain Model)

This repository uses **Strategy A**:
- Structs located in `model/domain/*.go` serve as both Domain models and GORM persistence models.
- Structs contain `gorm:"..."` tags, association fields, and embedded `gorm.Model`.
- Response transformation is achieved via receiver methods: `To<Entity>Response() web.<Entity>Response`.

**Example from [model/domain/bridging_outlet.go](../model/domain/bridging_outlet.go):**
```go
type BridgingOutlet struct {
    gorm.Model
    CreatedByID uint
    UpdatedByID uint
    DeletedByID *uint

    Outlet                outlet.Outlet           `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
    Distributor           distributor.Distributor `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
    DistributorID         string                  `gorm:"size:10;uniqueIndex:idx_bridging_outlet"`
    OutletID              string                  `gorm:"size:20;uniqueIndex:idx_bridging_outlet"`
    OutletDistributorID   string                  `gorm:"size:50;uniqueIndex:idx_bridging_outlet"`
    BranchDistributorID   string                  `gorm:"size:20"`
    BranchDistributorName string                  `gorm:"size:100"`
    OutletUpdated         *bool
}
```

---

## 3. Query Patterns

### A. Dynamic Filtering via `helper.ApplyFilter`
Used across all `FindAll` methods in repository implementations:
```go
func (repository *BridgingOutletRepositoryImpl) FindAll(db *gorm.DB, filters *map[string]string) domain.BridgingOutlets {
    bridgingOutlets := domain.BridgingOutlets{}
    tx := db.Model(&domain.BridgingOutlet{}).Limit(500)

    err := helper.ApplyFilter(tx, filters)
    helper.PanicIfError(err)

    err = tx.Joins("Outlet").Joins("Distributor").Find(&bridgingOutlets).Error
    helper.PanicIfError(err)

    return bridgingOutlets
}
```

### B. Joins vs Preload
- For `BelongsTo` relationships (e.g. `Outlet`, `Distributor`), **`tx.Joins("Outlet").Joins("Distributor")`** is the standard approach to prevent N+1 query loops.
- `Preload` is used selectively when querying one-to-many child collections.

### C. Find by Primary Key
```go
var bridgingOutlet domain.BridgingOutlet
err := db.Joins("Outlet").Joins("Distributor").First(&bridgingOutlet, id).Error
helper.PanicIfError(err)
return bridgingOutlet
```

---

## 4. Mutation Patterns (Create, Update, Delete)

### A. Create
```go
err := db.Create(&bridgingOutlet).Joins("Outlet").Joins("Distributor").First(&bridgingOutlet).Error
helper.PanicIfError(err)
```

### B. Update
```go
err := db.Updates(&bridgingOutlet).Error
helper.PanicIfError(err)

err = db.First(&bridgingOutlet, bridgingOutlet.ID).Error
helper.PanicIfError(err)

err = helper.CreateHistory(db, bridgingOutlet, helper.HistoryUpdate, bridgingOutlet.UpdatedByID)
helper.PanicIfError(err)
```
> [!WARNING]
> **Zero-Value Updates**: GORM's `Updates(struct)` skips Go zero values (`0`, `""`, `false`). When a zero value must be persisted (such as setting a boolean flag to `false`), use `*bool` pointer fields in domain structs or pass `map[string]interface{}` / `.Select("field")`.

### C. Delete & Soft-Delete with History
```go
bridgingOutlet := &domain.BridgingOutlet{}
tx := db.First(bridgingOutlet, id).Updates(&domain.BridgingOutlet{
    Model:       gorm.Model{ID: uint(*id)},
    DeletedByID: deletedByID,
})

// Create history snapshot
err := helper.CreateHistory(db, bridgingOutlet, helper.HistoryDelete, *deletedByID)
helper.PanicIfError(err)

// Execute delete
err = tx.Unscoped().Delete(bridgingOutlet, id).Error
helper.PanicIfError(err)
```

---

## 5. Transactions

Transactions follow a strict standard:
1. **Service Layer initiates transaction**:
   ```go
   tx := service.DB.Begin()
   err := tx.Error
   helper.PanicIfError(err)
   defer helper.CommitOrRollback(tx)
   ```
2. **Transaction DB pointer is passed**: Repositories accept `db *gorm.DB` which is the active transaction.
3. **Commit or Rollback via Panic Interception**:
   [helper/tx.go](../helper/tx.go):
   ```go
   func CommitOrRollback(tx *gorm.DB) {
       err := recover()
       if err != nil {
           errorRollback := tx.Rollback().Error
           PanicIfError(errorRollback)
           panic(err)
       } else {
           errorCommit := tx.Commit().Error
           PanicIfError(errorCommit)
       }
   }
   ```

---

## 6. GORM Anti-Patterns in this Repository

- **DO NOT** use `db.AutoMigrate()` in application startup code.
- **DO NOT** use `db.Save()` for partial updates.
- **DO NOT** open nested transactions by calling `db.Begin()` inside repositories.
- **DO NOT** construct raw SQL queries by concatenating unsanitized strings.
