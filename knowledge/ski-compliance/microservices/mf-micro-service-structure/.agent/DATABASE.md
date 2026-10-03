# Database Schema & Persistence Guide — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Database Engine & Connection

- **Engine**: MySQL 5.7+ / 8.0
- **Driver**: `gorm.io/driver/mysql` wrapping `github.com/go-sql-driver/mysql` (`v1.7.1`)
- **DSN Format**:
  ```text
  <user>:<password>@tcp(<host>:<port>)/<database>?parseTime=true
  ```
- **Logger**: GORM custom logger outputting to stdout with 1-second slow-query threshold (`app/database.go`).

## Key Tables

| Table Name | Primary Key | Key Columns & Indexes | Description |
|---|---|---|---|
| `marketing_structures` | `(id, period, code)` | `idx_ms_period_user(period, user_id, deleted_at)`, `idx_ms_period_division(period, division_id, deleted_at)`, `idx_ms_period_position(period, marketing_position_id, deleted_at)`, `idx_ms_period_boss(period, marketing_structure_boss_id, deleted_at)` | Core marketing tree nodes and employee assignments |
| `marketing_positions` | `(id, period)` | `idx_mp_period_level(period, level, deleted_at)` | Position levels (Lv1 to Lv6) |
| `marketing_structure_areas` | `id` | `idx_msa_structure_city(marketing_structure_id, city_id, deleted_at)`, `idx_msa_city_structure(city_id, marketing_structure_id, deleted_at)` | Structure to city area mappings |
| `marketing_structure_territory_customers` | `id` | `idx_mstc_period_customer(period, customer_id, deleted_at)`, `idx_mstc_period_structure(period, marketing_structure_id, customer_id, deleted_at)` | Structure to customer mappings |
| `marketing_structure_territory_outlets` | `id` | `idx_msto_period_outlet(period, outlet_id, is_default, deleted_at)`, `idx_msto_period_structure(period, marketing_structure_id, outlet_id, deleted_at)`, `idx_msto_period_division(period, division_id, deleted_at)` | Structure to outlet mappings |
| `offices` | `id` | `id` (size 30), `name` | Physical branch office registry |
| `hierarchies` | `id` | `idx_hierarchies_lookup(user_id, marketing_structure_id, deleted_at)` | Hierarchical groupings |
| `histories` | `id` (auto-increment uint) | `idx_histories_table_lookup(table_name, table_id)`, `idx_histories_created_at(created_at)` | Audit trail of all master data changes |
| `structure_wh_processes` | `id` | `period`, `status`, timestamps | Warehouse sync tracking |

## MySQL Database Views (`app/database/after_auto_migrate.sql`)

1. **`view_marketing_structure_positions`**:
   - Joins `marketing_structures` with `marketing_positions` and self-joins `marketing_structures` (as `ms2`) to resolve reporting supervisor codes (`code_boss`, `id_boss`, `user_id_boss`).
   - Filters `deleted_at is null`.
2. **`view_marketing_structure_all_levels`**:
   - Multi-tier left self-joins across `view_marketing_structure_positions` starting from Level 1 (`Where lv1.level = 1`) down to Level 6:
   ```sql
   Left Join view_marketing_structure_positions lv2 on lv1.period = lv2.period and lv2.level = 2 and lv1.id = lv2.id_boss
   Left Join view_marketing_structure_positions lv3 on lv1.period = lv3.period and lv3.level = 3 and lv2.id = lv3.id_boss
   ...
   Left Join view_marketing_structure_positions lv6 on lv1.period = lv6.period and lv6.level = 6 and lv5.id = lv6.id_boss
   ```

## Soft Delete & Audit Columns

- **Soft Delete**: Tables use standard `DeletedAt` (`*time.Time` or `gorm.DeletedAt`) plus `DeletedByID` (`*uint`).
- **Audit Columns**: `CreatedAt`, `CreatedByID`, `UpdatedAt`, `UpdatedByID`.
- **History Table (`histories`)**:
  - Automatically populated on create, update, or delete via `helper.CreateHistory(db, model, action, userId)`.
  - Serializes full entity state into JSON data payloads for auditing.
