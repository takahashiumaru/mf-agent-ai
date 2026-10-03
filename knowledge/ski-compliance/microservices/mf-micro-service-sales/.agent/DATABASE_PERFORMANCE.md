# Database & Query Performance — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

Guidelines for optimizing MySQL query performance, indexing, and reducing database load.

---

## 1. Core Principles
1. **Think Before Querying**: Evaluate expected row count, filter selectivity, index coverage, and join complexity before adding any new query.
2. **Retrieve Only What Is Needed**: Avoid `SELECT *` on wide transactional tables when only an aggregate or small column subset is needed.

---

## 2. Index Awareness & Utilization
- **High-Volume Tables**:
  - `sales_ffs`: Filtered heavily by `period`, `outlet_id`, `product_id`, `marketing_structure_id`, `spv_code`, `asm_code`, `fsm_code`. Ensure queries match existing indexes defined in [model/domain/sales_ff.go](../model/domain/sales_ff.go).
  - `sales_distributors`: Indexed by composite primary keys (`period`, `outlet_id`, `product_id`, `distributor_id`, `invoice`, `invoice_date`, `batch`).
- **Composite Index Order**: Always place equality columns (`period = ?`) before range or sorting columns (`invoice_date >= ?`).
- **Sargability**: Avoid wrapping indexed columns in functions in WHERE clauses (e.g. avoid `WHERE YEAR(created_at) = 2026`, prefer `WHERE created_at >= '2026-01-01' AND created_at < '2027-01-01'`).

---

## 3. Query Checklist for New / Modified Code
Before committing any significant query:
- [ ] Is the `WHERE` clause selective and indexed?
- [ ] Are list queries bounded by `.Limit(...)`?
- [ ] Are BelongsTo relationships joined with `.Joins(...)` rather than separate queries?
- [ ] Are there any database calls occurring inside a `for` loop? (Eliminate all N+1 loops).
- [ ] Are remote HTTP API calls (e.g., ETL or Nocode) kept outside database transaction locks whenever possible?
