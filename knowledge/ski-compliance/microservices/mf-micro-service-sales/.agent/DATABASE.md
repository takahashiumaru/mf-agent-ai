# Database & Persistence Guidelines — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document describes the database engine, schema design principles, key tables, indexing strategies, and migration conventions.

---

## 1. Database Engine
- **Engine**: MySQL 8.x
- **Driver**: `gorm.io/driver/mysql v1.5.1` (underlying driver `github.com/go-sql-driver/mysql v1.7.1`).
- **Connection DSN**: `<user>:<password>@tcp(<host>:<port>)/<db>?parseTime=true`
- **Connection Configuration**: Configured in [app/database.go](../app/database.go).

---

## 2. Schema Strategy & Migration
- **Schema Control**: The database schema is pre-provisioned and managed externally.
- **Runtime AutoMigrate**: `database.AutoMigrate(...)` in [app/database.go](../app/database.go) is **disabled** and commented out.
- **SQL Scripts**: [app/database/before_auto_migrate.sql](../app/database/before_auto_migrate.sql) and [app/database/after_auto_migrate.sql](../app/database/after_auto_migrate.sql) are placeholders and not automatically executed.
- **Rule for Agents**: Do not invoke `db.AutoMigrate()` in production code. Any schema updates must align with existing table conventions.

---

## 3. Important Tables & Structures

| Table Name | Primary Key / Composite Key | Domain Struct | Description |
| :--- | :--- | :--- | :--- |
| `bridging_outlets` | `id` (Auto Increment `gorm.Model`) | [BridgingOutlet](../model/domain/bridging_outlet.go) | Bridging between distributor outlet IDs and internal outlets |
| `bridging_products` | `id` (Auto Increment `gorm.Model`) | [BridgingProduct](../model/domain/bridging_product.go) | Bridging between distributor product IDs and internal products |
| `sales_ffs` | `(period, outlet_id, product_id, invoice, discount_on_principal, marketing_structure_id)` | [SalesFf](../model/domain/sales_ff.go) | Sales Field Force transaction records |
| `sales_distributors`| `(period, outlet_id, product_id, distributor_id, invoice, invoice_date, batch)` | [SalesDistributor](../model/domain/sales_distributor.go) | Distributor sales invoices and line items |
| `stock_distributors`| `(period, distributor_id, product_id, branch_distributor_id)` | [StockDistributor](../model/domain/stock_distributor.go) | Beginning, incoming, sales out, and ending stock |
| `target_marketings` | `id` (Auto Increment `gorm.Model`) | [TargetMarketing](../model/domain/target_marketing.go) | Sales targets by marketing structure & period |
| `distributor_extra_discounts` | `id` (Auto Increment `gorm.Model`) | [DistributorExtraDiscount](../model/domain/distributor_extra_discount.go) | Extra discount master settings |
| `distributor_extra_discount_claims` | `id` (Auto Increment `gorm.Model`) | [DistributorExtraDiscountClaim](../model/domain/distributor_extra_discount_claim.go) | Extra discount claim submissions |
| `histories` | `id` (Auto Increment `gorm.Model`) | [History](../model/domain/history.go) | Audit log of deleted/updated records in JSON |
| `work_calendars` | `id` (Auto Increment `gorm.Model`) | [WorkCalendar](../model/domain/work_calendar.go) | Working days configuration per month |

---

## 4. Key Patterns & Conventions

### A. Primary Key Strategies
Two strategies coexist depending on the table:
1. **Surrogate Auto-Increment ID**: Uses embedded `gorm.Model` (`ID uint`, `CreatedAt`, `UpdatedAt`, `DeletedAt`). Example: `bridging_outlets`, `target_marketings`.
2. **Natural Composite Keys**: Transaction-heavy tables (e.g. `sales_ffs`, `sales_distributors`, `stock_distributors`) use multi-column primary keys representing business uniqueness without surrogate IDs.

### B. Standard Audit Columns
For surrogate ID tables:
- `CreatedByID uint`
- `UpdatedByID uint`
- `DeletedByID *uint` (nullable)
- Embedded `gorm.Model` provides `CreatedAt`, `UpdatedAt`, `DeletedAt`.

### C. Indexes
- **Unique Indexes**:
  - `idx_bridging_outlet`: Unique on `(distributor_id, outlet_id, outlet_distributor_id)`.
  - `idx_bridging_product`: Unique on `(distributor_id, product_id, product_distributor_id)`.
- **Query Performance Indexes**:
  - `sales_ffs` indexes: `idx_period`, `idx_outlet_id`, `idx_product_id`, `idx_invoice`, `idx_spv_code`, `idx_asm_code`, `idx_fsm_code`, `idx_marketing_structure_id`.

### D. Audit Logging via `histories` Table
When deleting or updating records, the repository invokes [helper/history.go](../helper/history.go):
```go
helper.CreateHistory(db, model, helper.HistoryUpdate, userId)
helper.CreateHistory(db, model, helper.HistoryDelete, userId)
```
The helper serializes non-foreign-key struct fields into JSON and inserts a row into `histories` capturing `(table_name, table_id, data, type, created_by_id)`.
