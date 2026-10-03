# Preferred Engineering Patterns — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document defines the canonical implementation patterns for new code and touched legacy components.

---

## 1. Service Layer Transaction Handling

### Preferred Pattern
For write operations (Create, Update, Delete):
```go
func (service *OfficeServiceImpl) Create(auth *auth.AccessDetails, request *web.OfficeCreateRequest) web.OfficeResponse {
    err := service.Validate.Struct(request)
    helper.PanicIfError(err)

    tx := service.DB.Begin()
    helper.PanicIfError(tx.Error)
    defer helper.CommitOrRollback(tx)

    office := &domain.Office{
        ID:          request.ID,
        Name:        request.Name,
        CreatedAt:   time.Now(),
        CreatedByID: auth.UserID,
    }
    createdOffice := service.OfficeRepository.Create(tx, office)
    return createdOffice.ToOfficeResponse()
}
```

### Legacy Alternative to Avoid
- Opening transactions for purely read-only queries when touching existing code.
- Invoking `service.DB` inside a helper or repository rather than passing the transaction `tx *gorm.DB`.

---

## 2. GORM Updates and Zero-Value Handling

### Preferred Pattern
Use explicit `Select(...)` or `map[string]interface{}` updates when zero values (e.g. `false`, `0`, `""`, `nil`) must be updated:
```go
// Preferred: Explicit selection of boolean / pointer fields
tx.Model(&domain.MarketingStructure{}).
    Where("id = ? AND period = ?", id, period).
    Select("IsClosedEditArea", "ClosedEditAreaByID", "UpdatedByID", "UpdatedAt").
    Updates(domain.MarketingStructure{
        IsClosedEditArea:    true,
        ClosedEditAreaByID:  &auth.UserID,
        UpdatedByID:         auth.UserID,
        UpdatedAt:           time.Now(),
    })
```

### Legacy Alternative to Avoid
- `db.Save(&model)` on partial structs (risks overwriting unpopulated fields with defaults).
- Unscoped hard deletes (`db.Unscoped().Delete(...)`) unless explicitly mandated by business requirement.

---

## 3. Dynamic Filtering and Query Bounds

### Preferred Pattern
Use `helper.ApplyFilter` with bound parameterization and always include period constraints for multi-tenant / monthly tables:
```go
func (repository *MarketingStructureRepositoryImpl) FindAll(db *gorm.DB, filters *map[string]string, hierarchy []string) domain.MarketingStructures {
    var marketingStructures domain.MarketingStructures
    tx := db.Model(&domain.MarketingStructure{})

    err := helper.ApplyFilter(tx, filters)
    helper.PanicIfError(err)

    tx = tx.Joins("CreatedBy").
        Joins("MarketingPosition").
        Joins("Office").
        Joins("Division").
        Joins("User")

    err = tx.Order("MarketingPosition.level asc").Find(&marketingStructures).Error
    helper.PanicIfError(err)

    return marketingStructures
}
```

### Legacy Alternative to Avoid
- String concatenation into SQL queries (`fmt.Sprintf("WHERE code = '%s'", val)`).
- Querying entire tables without pagination or period filters.

---

## 4. Audit History Capture

### Preferred Pattern
Always capture change history after successful database mutations:
```go
err = helper.CreateHistory(db, updatedOffice, helper.HistoryUpdate, office.UpdatedByID)
helper.PanicIfError(err)
```

---

## 5. External HTTP Calls

### Preferred Pattern
Configure explicit timeouts and context propagation for all external HTTP requests:
```go
client := &http.Client{
    Timeout: 10 * time.Second,
}
resp, err := client.Do(req)
```

### Legacy Alternative to Avoid
- `client := &http.Client{}` with zero timeout (can hang worker goroutines indefinitely).
