# .agent/GORM.md — GORM Usage, Patterns & Anti-Patterns

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

## 1. GORM Initialization & Configuration

Database initialization is configured in `app/database.go`:
```go
func ConnectDatabase(user, host, password, port, db string) *gorm.DB {
    newLogger := logger.New(
        log.New(os.Stdout, "\r\n", log.LstdFlags),
        logger.Config{
            SlowThreshold: time.Second,
            LogLevel:      logger.Info,
            Colorful:      true,
        },
    )
    dsn := user + ":" + password + "@tcp(" + host + ":" + port + ")/" + db + "?parseTime=true"
    database, err := gorm.Open(mysql.Open(dsn), &gorm.Config{
        Logger: newLogger,
    })
    if err != nil {
        panic("failed to connect database")
    }
    return database
}
```

---

## 2. Model Struct Tags & Schema Mapping

- **Primary Keys**: `gorm:"primarykey"` or `gorm:"primaryKey"`
- **Column Sizing**: `gorm:"size:20"`, `gorm:"size:100"`, `gorm:"type:text"`
- **Default Values**: `gorm:"default:0"`, `gorm:"default:false"`
- **Compound Indexes**: `gorm:"index:idx_discount_proposal;uniqueIndex:idx_discount_proposal"`
- **Foreign Key Associations**:
  ```go
  City                           city.City                          `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
  MarketingStructure               structure.MarketingStructure       `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;references:code"`
  DiscountProposalEstimations   []DiscountProposalEstimation   `gorm:"foreignKey:DiscountProposalID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
  ```

---

## 3. Querying & Join Patterns

### Association Joins vs Manual SQL Joins
1. **GORM Association Joins**:
   Used for standard relations where GORM knows the foreign key:
   ```go
   tx := db.Model(&domain.DiscountProposal{}).
       Joins("CreatedBy").
       Joins("City").
       Joins("Distributor").
       Joins("MarketingStructure")
   ```
2. **Explicit SQL Joins**:
   Used for complex queries requiring custom conditions, aliasing, or soft-delete filtering:
   ```go
   tx := db.Model(&domain.DiscountProposal{}).
       Joins("JOIN discount_proposal_estimations ON discount_proposals.id = discount_proposal_estimations.discount_proposal_id AND discount_proposal_estimations.deleted_at IS NULL").
       Where("discount_proposals.deleted_at IS NULL")
   ```
3. **Dynamic Filtering with `helper.ApplyFilter`**:
   Repository search endpoints use `helper.ApplyFilter(tx, filters)` to parse query filters (e.g. `period.eq`, `status.in`, `type.like`).

---

## 4. Updates & The Zero-Value Caveat

### Critical GORM Rule
`db.Updates(&struct)` **ignores zero values** (`0`, `""`, `false`, `nil`). If a field needs to be set to `nil` or a zero value, you MUST use `Updates(map[string]interface{}{...})`.

### Verified Code Pattern (`repository/discount_proposal_repository_impl.go`)
```go
// Correct pattern for setting nullable fields to nil:
func (repository *DiscountProposalRepositoryImpl) UpdateOverBudgetNil(db *gorm.DB, discountProposal *domain.DiscountProposal, where *domain.DiscountProposal) *domain.DiscountProposal {
    tx := db.Model(&domain.DiscountProposal{}).Where(&domain.DiscountProposal{ID: where.ID})
    err := tx.Updates(map[string]interface{}{
        "discount_proposals.status_over_budget":            nil,
        "discount_proposals.marketing_structure_budget_id": discountProposal.MarketingStructureBudgetID,
        "updated_by_id":                                   discountProposal.UpdatedByID,
        "updated_at":                                      time.Now(),
    }).Error
    helper.PanicIfError(err)
    return discountProposal
}
```

---

## 5. Raw SQL & Complex Scans

For complex aggregations, reporting, or summary metrics, use `db.Raw(...)` or `db.Exec(...)` with explicit struct scanning:

```go
func (repository *DiscountProposalRepositoryImpl) FindSummaryQtyDldf(db *gorm.DB, period string) web.DiscountProposalDldfSummaryQtyResponses {
    summaryQty := web.DiscountProposalDldfSummaryQtyResponses{}
    err := db.Raw(`
        SELECT
            dp.type AS type,
            COUNT(DISTINCT dp.id) AS qty,
            SUM(dpf.total) AS total
        FROM
            discount_proposals dp
            JOIN discount_proposal_on_facturs dpf ON dp.id = dpf.discount_proposal_id
            AND dpf.deleted_at IS NULL
        WHERE
            dp.period = ?
            AND dp.type = 'DPF'
            AND dp.status = 'APPROVE'
            AND dp.deleted_at IS NULL
        GROUP BY
            dp.type
    `, period).Scan(&summaryQty).Error
    helper.PanicIfError(err)
    return summaryQty
}
```

---

## 6. Known Anti-Patterns to Avoid

| Anti-Pattern | Why It Is Dangerous | Correct Alternative |
| :--- | :--- | :--- |
| `db.Updates(&struct)` when resetting fields to `nil` | GORM ignores `nil` in struct updates; DB value remains unchanged. | Use `db.Updates(map[string]interface{}{"field": nil})`. |
| Assuming `*time.Time` soft deletes automatically filter | GORM only automatically filters `gorm.DeletedAt`. | Manually append `Where("deleted_at IS NULL")` for models with `*time.Time`. |
| Creating transactions inside Repositories | Prevents coordinating multi-repository transactions from the Service layer. | Manage transactions in `service/` using `tx := DB.Begin()` and pass `tx` to repositories. |
| Passing `service.DB` inside a transactional loop | Bypasses the active transaction, resulting in partial commits or deadlocks. | Pass `tx` consistently to all repository calls. |
| Calling `db.AutoMigrate()` at runtime | Can cause table locks and unexpected schema divergence in production. | Maintain schema through explicit SQL migration scripts. |
