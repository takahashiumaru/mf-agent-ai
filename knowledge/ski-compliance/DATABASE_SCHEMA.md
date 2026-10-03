# SKI_MF_PROD schema guide

## Source and boundaries

Live metadata was observed on **2026-09-27 01:57:48 UTC**, MySQL **8.4.2**, with session `transaction_read_only=1`. The account saw 183 base tables, 78 views, 4,354 columns across both, 131 routines, and zero triggers. These counts reflect metadata visibility; account grants were not audited.

[DATABASE_SCHEMA_CATALOG.md](DATABASE_SCHEMA_CATALOG.md) contains every captured object, column, index, FK column mapping, and routine name/type. [database_schema.sql](database_schema.sql) contains base-table SHOW CREATE output with auto-increment counters removed. It is a structure reference and must not be executed as a migration. The JSON source is `.agent/generated/database_snapshot.json`.

The original `SKI_MF_PROD.sql` is preserved. It contains 185 base table definitions and 78 final view sections, dated 2026-09-23. Legacy-only table names are `MFDB_M_CallMarketing`, `MFDB_M_CallMarketing_Actual`, `MFDB_M_CallMarketing_Target`; live-only base table name is `Book1`. These differences do not establish intent or a migration history. Metadata capture spans multiple sessions, so concurrent DDL cannot be ruled out.

## Verified examples that prevent wrong SQL

| Object | Observed columns/types | Query implication |
|---|---|---|
| `customers` | `id` varchar(20), `status` varchar(25), `deleted_at` datetime(3) | No `company_id`; establish status meaning from code, not a guessed ACTIVE value. |
| `outlets` | `id` varchar(20), `is_active` tinyint(1), `deleted_at` datetime(3) | Active and undeleted are different predicates; no blanket tenant column. |
| `accounts` | `id` bigint unsigned, `is_active` tinyint(1), `deleted_at` datetime(3) | Join with actual FK/key types; avoid unnecessary account details in output. |
| `event_classes` | `period_start`, `period_end` varchar(8) | Do not compare as YYYYMM without checking code semantics. |
| `customer_territory_outlets` | `period` varchar(6), `customer_id`, `outlet_id`, `deleted_at` | Mapping can be period-dependent and multiply rows in joins. |
| `marketing_structures` | `period` varchar(6), `user_id`, `deleted_at` | Historical structure membership needs the intended period. |
| `product_programs` | `id` varchar(8), `deleted_at` | Program-level rows differ from product/discount-level rows. |
| `sales_ffs` | `period` varchar(6), `outlet_id`, `product_id`, `qty` float(12,2), `year`, `month` | No `deleted_at` or `company_id`; quantity is not automatically money. Confirm grain before totals. |
| `status_closings` | `period` varchar(8), `deleted_at` | Closing semantics and period format require the owning service. |

## Current model alignment

For the six-repository model audit, see [MODEL_SCHEMA_COMPARISON.md](.agent/generated/MODEL_SCHEMA_COMPARISON.md). That report compares mapped GORM domain fields with this live snapshot, flags absent target objects, primary-key/tag/type differences and columns not represented in models. It distinguishes persistence structs from query/CSV projections.

## Relationship and grain discipline

Use catalog FK mappings and DDL keys to identify declared relationships. Application joins may add relationships not enforced by FKs. An FK alone does not establish a business reporting grain, ownership rule, or active-record policy. For composite keys, preserve all columns and their order. Check uniqueness on both sides before summing joined facts.

Views may aggregate or filter data; their bodies were not exported in this refresh, so do not claim view semantics from names. Routine metadata is navigation only; do not execute routines during read-only analysis. Numeric column types, nullability, defaults, and index definitions are structural evidence, not a substitute for business definitions.

## Freshness and use

For actual numbers use [data retrieval guidance](.agent/DATA_ACCESS.md), then [answer with data first](.agent/DATA_ANSWERS.md). For a schema discrepancy, refresh metadata and review the relevant model/query. Never silently rename or add fields to make a template fit.
