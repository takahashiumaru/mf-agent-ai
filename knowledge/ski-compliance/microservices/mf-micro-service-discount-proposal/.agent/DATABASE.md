# .agent/DATABASE.md — MySQL Schema, Models & Data Persistence

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

## 1. Database Engine & Connection Strategy

- **Engine**: MySQL 5.7 / 8.0
- **Driver**: `gorm.io/driver/mysql` v1.5.1 with underlying `github.com/go-sql-driver/mysql` v1.7.1
- **Connection Initialization**: Located in `app/database.go`
- **DSN Format**:
  ```text
  user:password@tcp(host:port)/db?parseTime=true
  ```
- **Logger Configuration**: GORM logger set to `logger.Info` with `SlowThreshold = 1 * time.Second`.

---

## 2. Schema Management & Migration Policy

- **Source of Truth**: The running MySQL database schema.
- **AutoMigrate Status**: **Disabled/Commented Out** in `app/database.go`.
- **Migration Scripts**:
  - `app/database/before_auto_migrate.sql`
  - `app/database/after_auto_migrate.sql`
- **Constraint Policy**:
  - GORM `Migrator().CreateConstraint` calls are commented out at startup to prevent DDL lock contention and unexpected schema mutation.
  - Foreign key constraints are defined in MySQL with `ON UPDATE CASCADE ON DELETE SET NULL`.

---

## 3. Key Tables & Primary Key Schemes

### 1. `discount_proposals` (`model/domain/discount_proposal.go`)
- **Primary Key**: `ID` (`string`, `size:20`)
- **Composite Model Keys / Indexes**:
  - `ID` (`primarykey`)
  - `DivisionID` (`primaryKey;size:30;index:idx_discount_proposal`)
  - `MarketingStructureID` (`primaryKey;size:20;index:idx_discount_proposal`)
- **Compound Index `idx_discount_proposal`**:
  - `(deleted_at, division_id, marketing_structure_id, city_id, discount_proposal_category_detail_id, period, period_start, period_end, status, type)`
- **Key Columns**:
  - `period` (`size:6`), `period_start` (`size:8`), `period_end` (`size:8`)
  - `amount_actual` (`*float64`), `amount_estimation` (`*float64`), `amount_tax` (`float64`)
  - `status` (`size:20`), `type` (`size:4`)
  - `distributor_id` (`*string`), `city_id` (`string`), `event_header_id` (`*string`)
  - `amortization` (`*bool`), `status_over_budget` (`string`)

### 2. `credit_notes` (`model/domain/credit_note.go`)
- **Composite Primary Key / Unique Index `idx_cqrs_credit_notes`**:
  - `DiscountProposalID` (`size:20`)
  - `OutletID` (`size:20`)
  - `CustomerID` (`size:20`)
  - `ProductID` (`size:20`)
  - `MarketingStructureID` (`size:200`)
  - `Period` (`size:6`)
  - `InvoiceNo` (`size:50`)
  - `InvoiceDate` (`size:10`)
- **Key Columns**:
  - `qty` (`float64`), `percent_on` (`*float64`), `percent_off` (`*float64`), `value` (`float64`)
  - `is_closed` (`*bool`), `quantity_type` (`string`), `amortization` (`*bool`)

### 3. `customer_balances` (`model/domain/customer_balance.go`)
- **Composite Primary Key**:
  - `CustomerID` (`string`, `primarykey`)
  - `Period` (`string`, `size:6`, `primarykey`)
- **Key Columns**:
  - `balance_begin` (`*float64`), `balance_end_total` (`*float64`), `balance_amor_end_total` (`*float64`)
  - `ski_amount_post`, `ski_amount_pre`, `ski_amount_amor`
  - `cn_amount_post`, `cn_amount_pre`, `cn_amount_amor`
  - `return_amount`, `return_amount_confirm`
  - `is_closed` (`*bool`), `closed_time` (`*time.Time`)

### 4. Supporting Entity Tables
- `discount_proposal_estimations`: Product-level forecast and percentage breakdown.
- `discount_proposal_recipients`: Beneficiary and bank details.
- `discount_proposal_payments`: Payment realization tracking.
- `discount_proposal_confirmations` & `discount_proposal_confirmation_statuses`: Workflow confirmation data.
- `discount_proposal_returns`: Returned proposal adjustments.
- `discount_proposal_on_facturs`: On-invoice line items.
- `histories`: Audit log trail (`table_id`, `table_name`, `data`, `type`, `created_by_id`, `created_at`).

---

## 4. Audit Fields & Soft Delete Conventions

### Standard Audit Columns
Every persistent domain model includes:
```go
CreatedAt   time.Time
UpdatedAt   time.Time
CreatedByID uint
UpdatedByID uint
DeletedByID *uint
```

### Soft Delete Nuance
There are two different soft-delete patterns in the domain models:
1. **`gorm.DeletedAt`**:
   - Used in `DiscountProposal` (`DeletedAt gorm.DeletedAt gorm:"index;uniqueIndex:idx_discount_proposal"`), `CqrsDiscountProposalTransferred`.
   - GORM automatically appends `WHERE deleted_at IS NULL` to standard queries.
2. **`*time.Time`**:
   - Used in `CreditNote`, `CustomerBalance`, `CreditNoteDetail`, `CqrsCreditNote`.
   - GORM does **NOT** automatically filter `*time.Time` fields. Queries and joins must explicitly include `Where("deleted_at IS NULL")`.

---

## 5. Audit Logging (`histories` Table)

Audit records are captured via `helper.CreateHistory(db, model, action, userId)` in `helper/history.go`:
The actual model is [model/domain/history.go](../model/domain/history.go). It embeds `gorm.Model`, uses `TableID size:50`, `Data size:8000`, `Type size:10`, and includes the CreatedBy association. See [EVIDENCE.md](EVIDENCE.md) for the dated physical schema comparison.
