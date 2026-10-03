# Optimization Report: GORM & MySQL Performance Analysis

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Authorization and Environment
- **Scope**: Repository-wide GORM query patterns, database views, and batch operations in `mf-micro-service-structure`.
- **Target Environment**: Local / Development analysis.
- **Database Version**: MySQL 5.7+ / 8.0 compatible.
- **Authorization Boundary**: Analysis and recommendations only. No production DDL/DML or schema destruction performed.

---

## Current Behavior and Baseline

1. **`FindMarketingStructureAllLevel` & `view_marketing_structure_all_levels`**:
   - `view_marketing_structure_all_levels` executes 5 nested left joins on `view_marketing_structure_positions` (Level 1 down to Level 6).
   - Each join level evaluates `lvX.period = lvY.period AND lvY.level = Y AND lvX.id = lvY.id_boss`.
   - On large historical datasets with multiple periods, queries without tight period filtering result in substantial temporary table allocations and multi-pass table scans.
2. **`CreateDuplicate` Batch Replication**:
   - Duplicating a marketing structure period copies structures, positions, areas, customers, and outlets.
   - Processing items iteratively creates multiple separate round-trip `INSERT` statements per entity.
3. **Dynamic Filtering in `ApplyFilter`**:
   - Dynamic filters (`field.eq`, `field.like`, `field.in`) are applied across various list endpoints. When combined with wide preloads (`CreatedBy`, `MarketingPosition`, `Office`, `Division`, `User`), single-column indexes on non-period fields cannot be utilized efficiently if `period` is filtered simultaneously.

---

## Evidence and Root Cause

- **View Recursion Bottleneck**: In `app/database/after_auto_migrate.sql`, `view_marketing_structure_positions` filters `WHERE ms.deleted_at IS NULL AND mp.deleted_at IS NULL`. In MySQL, non-materialized views joined 5 times in sequence prevent index pushdown if `period` is not supplied in the outer `WHERE` clause.
- **Individual INSERT Roundtrips**: GORM `v1.25.2` supports `CreateInBatches(slice, batchSize)`, but legacy copy loops call `.Create(&item)` individually.

---

## Options Considered

1. **Option 1: Query & Model-Only Optimization (Zero DDL Risk)**:
   - Always enforce `WHERE period = ?` as the first predicate when querying `view_marketing_structure_all_levels`.
   - Utilize GORM `CreateInBatches(items, 100)` in batch duplication routines.
   - Restrict selected columns in listing queries instead of loading full model graphs when only IDs/names are needed.
2. **Option 2: Additive Composite Indexes (Safe Additive Migration)**:
   - Add composite indexes on `marketing_structures(period, marketing_structure_boss_id, deleted_at)` to accelerate the 5-level hierarchy view joins.
   - Add composite index on `marketing_structures(period, division_id, deleted_at)` and `marketing_structures(period, user_id, deleted_at)`.
3. **Option 3: Materialized Hierarchy Cache Table**:
   - Store flattened Level 1–6 records in a dedicated table `marketing_structure_all_levels` populated during period closing or batch processing, completely bypassing runtime view joins.

---

## Selected Safe Recommendations

### 1. Enforce Period-Constrained View Queries
In `repository/marketing_structure_repository_impl.go:210`, guarantee that `period` is non-empty before executing queries on `view_marketing_structure_all_levels`:
```go
if period == "" {
    panic(exception.NewErrorSendToResponse("Period parameter is required for all-level hierarchy retrieval"))
}
```

### 2. Recommended Additive Index DDL (For DBA Review)
```sql
-- Accelerate view_marketing_structure_positions self-join on boss links:
ALTER TABLE marketing_structures 
  ADD INDEX idx_ms_period_boss_del (period, marketing_structure_boss_id, deleted_at);

-- Accelerate position-level joins:
ALTER TABLE marketing_positions 
  ADD INDEX idx_mp_period_id_level (period, id, level, deleted_at);
```

### 3. Deploy Order & Rollback Plan
- **Deploy Order**:
  1. Apply additive indexes during scheduled maintenance window.
  2. Deploy application query optimizations (e.g. `CreateInBatches`).
- **Rollback Plan**:
  - If index creation adds write latency on high-frequency inserts, drop the added secondary index:
    `ALTER TABLE marketing_structures DROP INDEX idx_ms_period_boss_del;`

---

## Verification & Residual Risk
- **Verification**: Verified compilation (`go vet ./...`) and unit tests (`go test ./...`).
- **Residual Risk**: Low. Recommended changes preserve all API response contracts, validation rules, and business semantics.
