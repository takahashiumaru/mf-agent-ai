# Flexurio No-code API Configuration — MF Marketing

Configuration package for the Flexurio no-code API runtime: marketing entities, incentive calculations, budgets, projects and summary/reporting resources.

## Table of Contents

- [Architecture and repository layout](#architecture-and-repository-layout)
- [Getting started and deployment](#getting-started-and-deployment)
- [Complete configured endpoint reference](#complete-configured-endpoint-reference)
- [Database and operational notes](#database-and-operational-notes)

## Architecture and repository layout

The application implementation is supplied by the Flexurio runtime image/binaries. This repository configures its resources; it does not contain that runtime source. HTTP verb/path expansion, built-in authentication endpoints and generated routes must be confirmed against the deployed runtime version.

| Path | Purpose |
| --- | --- |
| [config/routes.json](config/routes.json) | Resource registration, public-resource configuration and token conversion |
| [config/entity/](config/entity/) | Table mappings, column definitions and per-method behavior |
| [db/](db/) | Database assets |
| [seed/](seed/) | Seed assets; inspect before execution |
| [static/](static/) | Static application assets |
| [Dockerfile](Dockerfile) | Runtime image and copied configuration |

## Getting started and deployment

The Dockerfile uses `jayuda/flx_nocode_api:latest`, copies `config/`, `db/` and a local `.env`, exposes port `8080`, and starts `./target/release/flx-nocode-api`. The checked-in macOS binary names include `v0.4.8-release`; this does not pin the Docker `latest` image.

1. Obtain a compatible runtime and approved development configuration.
2. Review table mappings: some entities explicitly qualify `SKI_MF_PROD`, so changing only the connection default is insufficient to redirect them to DEV.
3. Review the `.env` copying behavior in Dockerfile and keep credentials out of committed files or shared images.
4. Build only after preparing the intended environment:

```sh
docker build -t flexurio-marketing-api:local .
```

See [docker-compose.yml](docker-compose.yml) for mounts, network and port mappings. No runtime, seed, migration, deployment or application tests were executed for this documentation.

## Complete configured endpoint reference

`routes` contains 48 entries (48 unique resource names); `route_publics` contains 49 entries (48 unique names). Every registration and entity definition is represented below. The method table preserves explicit endpoint overrides and enabled flags. **An unset override means runtime-derived, not a verified path.** No conventional CRUD suffix is invented.

| Resource | Registered | Listed in route_publics | Entity source |
| --- | --- | --- | --- |
| `attendance_deductions` | Yes | Yes | [config/entity/attendance_deductions.json](config/entity/attendance_deductions.json) |
| `discount_proposal_budget_process` | Yes | Yes | [config/entity/discount_proposal_budget_process.json](config/entity/discount_proposal_budget_process.json) |
| `discount_proposal_budgets` | Yes | Yes | [config/entity/discount_proposal_budgets.json](config/entity/discount_proposal_budgets.json) |
| `discount_proposal_configs` | Yes | Yes | [config/entity/discount_proposal_configs.json](config/entity/discount_proposal_configs.json) |
| `division_products` | Yes | Yes | [config/entity/division_products.json](config/entity/division_products.json) |
| `estimation_sales_per_product` | Yes | Yes | [config/entity/estimation_sales_per_product.json](config/entity/estimation_sales_per_product.json) |
| `flx_roles` | Yes | Yes | [config/entity/flx_roles.json](config/entity/flx_roles.json) |
| `flx_users` | Yes | Yes | [config/entity/flx_users.json](config/entity/flx_users.json) |
| `incentive_base_cn_customer_outlet_product_types` | Yes | Yes | [config/entity/incentive_base_cn_customer_outlet_product_types.json](config/entity/incentive_base_cn_customer_outlet_product_types.json) |
| `incentive_base_cn_customers` | Yes | Yes | [config/entity/incentive_base_cn_customers.json](config/entity/incentive_base_cn_customers.json) |
| `incentive_base_cn_discount_products` | Yes | Yes | [config/entity/incentive_base_cn_discount_products.json](config/entity/incentive_base_cn_discount_products.json) |
| `incentive_base_sales_category_products` | Yes | Yes | [config/entity/incentive_base_sales_category_products.json](config/entity/incentive_base_sales_category_products.json) |
| `incentive_base_sales_products` | Yes | Yes | [config/entity/incentive_base_sales_products.json](config/entity/incentive_base_sales_products.json) |
| `incentive_base_sales_structures` | Yes | Yes | [config/entity/incentive_base_sales_structures.json](config/entity/incentive_base_sales_structures.json) |
| `incentive_base_subordinate_structures` | Yes | Yes | [config/entity/incentive_base_subordinate_structures.json](config/entity/incentive_base_subordinate_structures.json) |
| `incentive_base_target_category_products` | Yes | Yes | [config/entity/incentive_base_target_category_products.json](config/entity/incentive_base_target_category_products.json) |
| `incentive_base_target_products` | Yes | Yes | [config/entity/incentive_base_target_products.json](config/entity/incentive_base_target_products.json) |
| `incentive_details` | Yes | Yes | [config/entity/incentive_details.json](config/entity/incentive_details.json) |
| `incentive_headers` | Yes | Yes | [config/entity/incentive_headers.json](config/entity/incentive_headers.json) |
| `incentive_logs` | Yes | Yes | [config/entity/incentive_logs.json](config/entity/incentive_logs.json) |
| `incentive_recapitulasi` | Yes | Yes | [config/entity/incentive_recapitulasi.json](config/entity/incentive_recapitulasi.json) |
| `incentive_schema_details` | Yes | Yes | [config/entity/incentive_schema_details.json](config/entity/incentive_schema_details.json) |
| `incentive_schemas` | Yes | Yes | [config/entity/incentive_schemas.json](config/entity/incentive_schemas.json) |
| `manual_process_endpoints` | Yes | Yes | [config/entity/manual_process_endpoints.json](config/entity/manual_process_endpoints.json) |
| `menu_users` | Yes | Yes | [config/entity/menu_users.json](config/entity/menu_users.json) |
| `menus` | Yes | Yes | [config/entity/menus.json](config/entity/menus.json) |
| `outlet_summary_cross_sellings` | Yes | Yes | [config/entity/outlet_summary_cross_sellings.json](config/entity/outlet_summary_cross_sellings.json) |
| `outlet_summary_up_sellings` | Yes | Yes | [config/entity/outlet_summary_up_sellings.json](config/entity/outlet_summary_up_sellings.json) |
| `outlet_summarys` | Yes | Yes | [config/entity/outlet_summarys.json](config/entity/outlet_summarys.json) |
| `potential_customer_products` | Yes | Yes | [config/entity/potential_customer_products.json](config/entity/potential_customer_products.json) |
| `project_poa` | Yes | Yes | [config/entity/project_poa.json](config/entity/project_poa.json) |
| `project_poa_products` | Yes | Yes | [config/entity/project_poa_products.json](config/entity/project_poa_products.json) |
| `project_poa_ski` | Yes | Yes | [config/entity/project_poa_ski.json](config/entity/project_poa_ski.json) |
| `project_users` | Yes | Yes | [config/entity/project_users.json](config/entity/project_users.json) |
| `projects` | Yes | Yes | [config/entity/projects.json](config/entity/projects.json) |
| `public_holidays` | Yes | Yes | [config/entity/public_holidays.json](config/entity/public_holidays.json) |
| `recap_outlet_product_calls` | Yes | Yes | [config/entity/recap_outlet_product_calls.json](config/entity/recap_outlet_product_calls.json) |
| `recap_outlet_product_customer_cross_sells` | Yes | Yes | [config/entity/recap_outlet_product_customer_cross_sells.json](config/entity/recap_outlet_product_customer_cross_sells.json) |
| `recap_outlet_product_customer_up_sells` | Yes | Yes | [config/entity/recap_outlet_product_customer_up_sells.json](config/entity/recap_outlet_product_customer_up_sells.json) |
| `recap_outlet_product_customers` | Yes | Yes | [config/entity/recap_outlet_product_customers.json](config/entity/recap_outlet_product_customers.json) |
| `recap_outlet_product_maxs` | Yes | Yes | [config/entity/recap_outlet_product_maxs.json](config/entity/recap_outlet_product_maxs.json) |
| `recap_outlets` | Yes | Yes | [config/entity/recap_outlets.json](config/entity/recap_outlets.json) |
| `sales_trend` | Yes | Yes | [config/entity/sales_trend.json](config/entity/sales_trend.json) |
| `sales_trend_total` | Yes | Yes | [config/entity/sales_trend_total.json](config/entity/sales_trend_total.json) |
| `status_closings` | Yes | Yes | [config/entity/status_closings.json](config/entity/status_closings.json) |
| `target_sector_structures` | Yes | Yes | [config/entity/target_sector_structures.json](config/entity/target_sector_structures.json) |
| `visit_flow_discount_proposal_estimations` | Yes | Yes | [config/entity/visit_flow_discount_proposal_estimations.json](config/entity/visit_flow_discount_proposal_estimations.json) |
| `visit_flow_discount_proposals` | Yes | Yes | [config/entity/visit_flow_discount_proposals.json](config/entity/visit_flow_discount_proposals.json) |


### attendance_deductions

Source: [config/entity/attendance_deductions.json](config/entity/attendance_deductions.json). Table mapping: `VISITFLOW_MF_PROD.attendance_deductions`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | Runtime-derived; no explicit override | `search, page, sort, ascending, limit, redis, id.eq, period.eq, company_id.eq, late_start.gte, late_end.lte, penalty_amount.eq, created_at.eq, updated_at.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### discount_proposal_budget_process

Source: [config/entity/discount_proposal_budget_process.json](config/entity/discount_proposal_budget_process.json). Table mapping: `discount_proposal_budgets`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `menus` | `search, page, sort, ascending, limit, redis, id.eq, period.eq, marketing_structure_id.eq, marketing_structure_id.in, marketing_position_id.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### discount_proposal_budgets

Source: [config/entity/discount_proposal_budgets.json](config/entity/discount_proposal_budgets.json). Table mapping: `SKI_MF_PROD.discount_proposal_budgets`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `menus` | `search, page, sort, ascending, limit, redis, id.eq, period.eq, marketing_structure_id.eq, marketing_structure_id.in, marketing_position_id.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### discount_proposal_configs

Source: [config/entity/discount_proposal_configs.json](config/entity/discount_proposal_configs.json). Table mapping: `SKI_MF_PROD.discount_proposal_configs`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `discount_proposal_configs` | `search, page, sort, ascending, limit, redis, id.eq, name.eq, period.eq, period_start.gte, period_end.lte, level.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### division_products

Source: [config/entity/division_products.json](config/entity/division_products.json). Table mapping: `SKI_MF_PROD.division_products`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `division_products` | `search, page, sort, ascending, limit, id.eq, division_id.eq, customer_id.eq, product_id.eq, outlet_type_id.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### estimation_sales_per_product

Source: [config/entity/estimation_sales_per_product.json](config/entity/estimation_sales_per_product.json). Table mapping: `estimation_sales_per_product`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `estimation_sales_per_product` | `search, page, sort, ascending, limit, period.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### flx_roles

Source: [config/entity/flx_roles.json](config/entity/flx_roles.json). Table mapping: `flx_roles`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | Runtime-derived; no explicit override | `id_users.eq, role.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | False | Runtime-derived; no explicit override | `` |
| `TRACE` | False | Runtime-derived; no explicit override | `` |


### flx_users

Source: [config/entity/flx_users.json](config/entity/flx_users.json). Table mapping: `flx_users`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | Runtime-derived; no explicit override | `email.eq, phone.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | False | Runtime-derived; no explicit override | `` |
| `TRACE` | False | Runtime-derived; no explicit override | `` |


### incentive_base_cn_customer_outlet_product_types

Source: [config/entity/incentive_base_cn_customer_outlet_product_types.json](config/entity/incentive_base_cn_customer_outlet_product_types.json). Table mapping: `incentive_base_cn_customer_outlet_product_types`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | Not declared | `incentive_base_cn_customer_outlet_product_types` | `search, page, sort, ascending, limit, id.eq, period.eq, customer_id.eq, customer_name.eq, customer_name.like, product_id.eq, product_name.eq, product_name.like, product_program_id.eq, outlet_id.eq, outlet_name.eq, outlet_name.like, mr_code.eq, mr_code.like&#124;spv_code.like&#124;asm_code.like&#124;fsm_code.like&#124;gm_code.like, mr_nip.eq, mr_name.eq, spv_code.eq, spv_nip.eq, spv_name.eq, asm_code.eq, asm_nip.eq, asm_name.eq, fsm_code.eq, fsm_nip.eq, fsm_name.eq, gm_code.eq, gm_nip.eq, gm_name.eq, co1.eq, co2.eq, co1_date.eq, created_at.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | Not declared | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_base_cn_customers

Source: [config/entity/incentive_base_cn_customers.json](config/entity/incentive_base_cn_customers.json). Table mapping: `incentive_base_cn_customers`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_base_cn_customers` | `search, page, sort, ascending, limit, id.eq, period.eq, customer_id.eq, customer_name.eq, customer_name.like, mr_code.eq, mr_code.like&#124;spv_code.like&#124;asm_code.like&#124;fsm_code.like&#124;gm_code.like, mr_nip.eq, mr_name.eq, spv_code.eq, spv_nip.eq, spv_name.eq, asm_code.eq, asm_nip.eq, asm_name.eq, fsm_code.eq, fsm_nip.eq, fsm_name.eq, gm_code.eq, gm_nip.eq, gm_name.eq, co1.eq, co2.eq, co1_date.eq, created_at.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_base_cn_discount_products

Source: [config/entity/incentive_base_cn_discount_products.json](config/entity/incentive_base_cn_discount_products.json). Table mapping: `incentive_base_cn_discount_products`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_base_cn_discount_products` | `search, page, sort, ascending, limit, id.eq, period.eq, product_id.eq, product_name.eq, mr_code.eq, mr_code.like&#124;spv_code.like&#124;asm_code.like&#124;fsm_code.like&#124;gm_code.like, mr_nip.eq, mr_name.eq, spv_code.eq, spv_nip.eq, spv_name.eq, asm_code.eq, asm_nip.eq, asm_name.eq, fsm_code.eq, fsm_nip.eq, fsm_name.eq, gm_code.eq, gm_nip.eq, gm_name.eq, percent_off.eq, value_sales_final.eq, created_at.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_base_sales_category_products

Source: [config/entity/incentive_base_sales_category_products.json](config/entity/incentive_base_sales_category_products.json). Table mapping: `incentive_base_sales_category_products`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_base_sales_category_products` | `search, page, sort, ascending, limit, id.eq, period.eq, mr_code.eq, mr_nip.eq, mr_name.eq, spv_code.eq, spv_nip.eq, spv_name.eq, asm_code.eq, asm_nip.eq, asm_name.eq, fsm_code.eq, fsm_nip.eq, fsm_name.eq, gm_code.eq, gm_nip.eq, gm_name.eq, product_category.eq, co1_qty_product_rutin.eq, co1_qty_product_non_rutin.eq, co1_qty_product_total.eq, co2_qty_product_rutin.eq, co2_qty_product_non_rutin.eq, co2_qty_product_total.eq, co1_rutin.eq, co1_non_rutin.eq, co1_total.eq, co2_rutin.eq, co2_non_rutin.eq, co2_total.eq, co1_date.eq, created_at.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_base_sales_products

Source: [config/entity/incentive_base_sales_products.json](config/entity/incentive_base_sales_products.json). Table mapping: `incentive_base_sales_products`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_base_sales_products` | `search, page, sort, ascending, limit, id.eq, period.eq, mr_code.eq, mr_code.like&#124;spv_code.like&#124;asm_code.like&#124;fsm_code.like&#124;gm_code.like, mr_nip.eq, mr_name.eq, spv_code.eq, spv_nip.eq, spv_name.eq, asm_code.eq, asm_nip.eq, asm_name.eq, fsm_code.eq, fsm_nip.eq, fsm_name.eq, gm_code.eq, gm_nip.eq, gm_name.eq, product_code.eq, product_name.eq, product_category.eq, co1_qty_rutin.eq, co1_qty_non_rutin.eq, co1_qty_total.eq, co2_qty_rutin.eq, co2_qty_non_rutin.eq, co2_qty_total.eq, co1_rutin.eq, co1_non_rutin.eq, co1_total.eq, co2_rutin.eq, co2_non_rutin.eq, co2_total.eq, co1_date.eq, created_at.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_base_sales_structures

Source: [config/entity/incentive_base_sales_structures.json](config/entity/incentive_base_sales_structures.json). Table mapping: `incentive_base_sales_structures`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_base_sales_structures` | `search, page, sort, ascending, limit, id.eq, period.eq, mr_code.eq, mr_code.like&#124;spv_code.like&#124;asm_code.like&#124;fsm_code.like&#124;gm_code.like, mr_nip.eq, mr_name.eq, spv_code.eq, spv_nip.eq, spv_name.eq, asm_code.eq, asm_nip.eq, asm_name.eq, fsm_code.eq, fsm_nip.eq, fsm_name.eq, gm_code.eq, gm_nip.eq, gm_name.eq, co1_rutin.eq, co1_non_rutin.eq, co1_total.eq, co2_rutin.eq, co2_non_rutin.eq, co2_total.eq, co1_date.eq, created_at.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_base_subordinate_structures

Source: [config/entity/incentive_base_subordinate_structures.json](config/entity/incentive_base_subordinate_structures.json). Table mapping: `incentive_base_subordinate_structures`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_base_subordinate_structures` | `search, page, sort, ascending, limit, id.eq, period.eq, code.eq, nip.eq, name.eq, position.eq, subordinate_filled.eq, subordinate_vacant.eq, subordinate_vacant_freeze.eq, subordinate_vacant_total.eq, subordinate_total.eq, created_at.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_base_target_category_products

Source: [config/entity/incentive_base_target_category_products.json](config/entity/incentive_base_target_category_products.json). Table mapping: `incentive_base_target_category_products`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_base_target_category_products` | `search, page, sort, ascending, limit, id.eq, period.eq, code.eq, position.eq, product_category.eq, qty_rutin.eq, qty_non_rutin.eq, qty_total.eq, value_rutin.eq, value_non_rutin.eq, value_total.eq, created_at.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_base_target_products

Source: [config/entity/incentive_base_target_products.json](config/entity/incentive_base_target_products.json). Table mapping: `incentive_base_target_products`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_base_target_products` | `search, page, sort, ascending, limit, id.eq, period.eq, code.eq, position.eq, product_category.eq, product_code.eq, qty_rutin.eq, qty_non_rutin.eq, qty_total.eq, value_rutin.eq, value_non_rutin.eq, value_total.eq, created_at` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_details

Source: [config/entity/incentive_details.json](config/entity/incentive_details.json). Table mapping: `SKI_MF_PROD.incentive_details`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_details` | `search, page, sort, ascending, limit, id.eq, period.eq, structure_id.eq, nip.eq, name.eq, job_title.eq, schema_header.eq, schema_detail.eq, schema_detail_sub.eq, indicator.eq, data.eq, isok.eq, min.eq, note.eq, company.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_headers

Source: [config/entity/incentive_headers.json](config/entity/incentive_headers.json). Table mapping: `SKI_MF_PROD.incentive_headers`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_headers` | `search, page, sort, ascending, limit, id.eq, period.eq, structure_id.eq, nip.eq, name.eq, job_title.eq, schema_header.eq, schema_detail.eq, schema_detail_sub.eq, min_score.eq, score.eq, incentive_calculation.eq, incentive_to_pay.eq, join_date.eq, resign_date.eq, is_inactive.eq, note.eq, status.eq, company.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_logs

Source: [config/entity/incentive_logs.json](config/entity/incentive_logs.json). Table mapping: `SKI_MF_PROD.incentive_logs`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_logs` | `search, page, sort, ascending, limit, id.eq, period.eq, incentive_header.eq, incentive_detail.eq, sp.eq, process_date.eq, status.eq, company.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_recapitulasi

Source: [config/entity/incentive_recapitulasi.json](config/entity/incentive_recapitulasi.json). Table mapping: `SKI_MF_PROD.incentive_recapitulasi`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_recapitulasi` | `search, page, sort, ascending, limit, id.eq, company.eq, period.eq, nip.eq, name.eq, schema_header.eq, status.eq, value.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_schema_details

Source: [config/entity/incentive_schema_details.json](config/entity/incentive_schema_details.json). Table mapping: `SKI_MF_PROD.incentive_schema_details`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_schema_details` | `search, page, sort, ascending, limit, id.eq, company.eq, incentive_schema_id.eq, incentive_name.like` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### incentive_schemas

Source: [config/entity/incentive_schemas.json](config/entity/incentive_schemas.json). Table mapping: `SKI_MF_PROD.incentive_schemas`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `incentive_schemas` | `search, page, sort, ascending, limit, id.eq, company.eq, incentive_name.eq, incentive_name.like` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### manual_process_endpoints

Source: [config/entity/manual_process_endpoints.json](config/entity/manual_process_endpoints.json). Table mapping: `VISITFLOW_MF_PROD.manual_process_endpoints`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `manual_process_endpoints` | `search, page, sort, ascending, limit, id.eq, name.like` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### menu_users

Source: [config/entity/menu_users.json](config/entity/menu_users.json). Table mapping: `VISITFLOW_MF_PROD.menu_users`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `menu_users` | `search, page, sort, ascending, limit, redis, id.eq, menu_id.eq, user_id.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### menus

Source: [config/entity/menus.json](config/entity/menus.json). Table mapping: `VISITFLOW_MF_PROD.menus`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `menus` | `search, page, sort, ascending, limit, redis, id.eq, name.eq, name.like` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### outlet_summary_cross_sellings

Source: [config/entity/outlet_summary_cross_sellings.json](config/entity/outlet_summary_cross_sellings.json). Table mapping: `SKI_MF_PROD.outlet_summary_cross_sellings`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `outlet_summary_cross_sellings` | `search, page, sort, ascending, limit, period.eq, outlet_id.eq, product_id.eq, customer_id.eq, outlet_name.like, product_name.like, customer_name.like` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### outlet_summary_up_sellings

Source: [config/entity/outlet_summary_up_sellings.json](config/entity/outlet_summary_up_sellings.json). Table mapping: `SKI_MF_PROD.outlet_summary_up_sellings`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `outlet_summary_up_sellings` | `search, page, sort, ascending, limit, period.eq, outlet_id.eq, product_id.eq, outlet_name.like, product_name.like` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### outlet_summarys

Source: [config/entity/outlet_summarys.json](config/entity/outlet_summarys.json). Table mapping: `SKI_MF_PROD.outlet_summarys`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `outlet_summarys` | `search, page, sort, ascending, limit, period.eq, outlet_id.eq, flag.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### potential_customer_products

Source: [config/entity/potential_customer_products.json](config/entity/potential_customer_products.json). Table mapping: `VISITFLOW_MF_PROD.potential_customer_products`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | Runtime-derived; no explicit override | `search, page, sort, ascending, limit, id.eq, period.eq, structure_id.eq, customer_id.eq, product_id.eq, qty.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### project_poa

Source: [config/entity/project_poa.json](config/entity/project_poa.json). Table mapping: `SKI_MF_PROD.project_poa`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `project_poa` | `search, page, sort, ascending, limit, redis, id.eq, project_id.eq, project_name.eq, customer_id.eq, customer_name.eq, struktur_id.eq, est.eq, sales.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### project_poa_products

Source: [config/entity/project_poa_products.json](config/entity/project_poa_products.json). Table mapping: `SKI_MF_PROD.project_poa_products`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | Runtime-derived; no explicit override | `search, page, sort, ascending, limit, redis, id.eq, project_id.eq, project_name.eq, customer_id.eq, customer_name.eq, struktur_id.eq, product_id.eq, product_name.eq, no_promotion.eq, est.eq, sales.eq, CN.eq, project_poa_id.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### project_poa_ski

Source: [config/entity/project_poa_ski.json](config/entity/project_poa_ski.json). Table mapping: `SKI_MF_PROD.project_poa_ski`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `project_poa_ski` | `search, page, sort, ascending, limit, redis, id.eq, project_poa_id.eq, customer_id.eq, customer_name.eq, struktur_id.eq, no_promotion.eq, est.eq, sales.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### project_users

Source: [config/entity/project_users.json](config/entity/project_users.json). Table mapping: `SKI_MF_PROD.project_users`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `project_users` | `search, page, sort, ascending, limit, redis, id.eq, project_id.eq, project_name.eq, customer_id.eq, customer_name.eq, user_active.eq, specialis.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### projects

Source: [config/entity/projects.json](config/entity/projects.json). Table mapping: `SKI_MF_PROD.projects`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | Runtime-derived; no explicit override | `search, page, sort, ascending, limit, redis, id.eq, name_project.eq, total_budget.eq, total_participants.eq, user_active.eq, pdds.eq, user_non_active.eq, period_start.eq, period_start.gte, period_start.lte, period_end.eq, period_end.gte, period_end.lte, est.eq, CN.eq, percentage_budget.eq, CN_new_non_active.eq, ratio_budget_CN.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### public_holidays

Source: [config/entity/public_holidays.json](config/entity/public_holidays.json). Table mapping: `VISITFLOW_MF_PROD.public_holidays`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `public_holidays` | `search, page, sort, ascending, limit, id.eq, name.eq, period.eq, date.eq, is_yearly.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### recap_outlet_product_calls

Source: [config/entity/recap_outlet_product_calls.json](config/entity/recap_outlet_product_calls.json). Table mapping: `SKI_MF_PROD.recap_outlet_product_calls`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `recap_outlet_product_calls` | `search, page, sort, ascending, limit, id.eq, period.eq, period.like, mr_code.eq, spv_code.eq, asm_code.eq, outlet_id.eq, sector.eq, outlet_id.like, outlet_name.like, product_id.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### recap_outlet_product_customer_cross_sells

Source: [config/entity/recap_outlet_product_customer_cross_sells.json](config/entity/recap_outlet_product_customer_cross_sells.json). Table mapping: `SKI_MF_PROD.recap_outlet_product_customer_cross_sells`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `recap_outlet_product_customer_cross_sells` | `search, page, sort, ascending, limit, id.eq, period.eq, mr_code.eq, spv_code.eq, asm_code.eq, outlet_id.eq, product_id.eq, customer_id.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### recap_outlet_product_customer_up_sells

Source: [config/entity/recap_outlet_product_customer_up_sells.json](config/entity/recap_outlet_product_customer_up_sells.json). Table mapping: `SKI_MF_PROD.recap_outlet_product_customer_up_sells`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `recap_outlet_product_customer_up_sells` | `search, page, sort, ascending, limit, id.eq, period.eq, mr_code.eq, spv_code.eq, asm_code.eq, outlet_id.eq, product_id.eq, customer_id.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### recap_outlet_product_customers

Source: [config/entity/recap_outlet_product_customers.json](config/entity/recap_outlet_product_customers.json). Table mapping: `SKI_MF_PROD.recap_outlet_product_customers`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `recap_outlet_product_customers` | `search, page, sort, ascending, limit, id.eq, period.eq, period.like, mr_code.eq, spv_code.eq, asm_code.eq, outlet_id.eq, sector.eq, outlet_id.like, outlet_name.like, product_id.eq, product_name.eq, customer_id.eq, estimation.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### recap_outlet_product_maxs

Source: [config/entity/recap_outlet_product_maxs.json](config/entity/recap_outlet_product_maxs.json). Table mapping: `SKI_MF_PROD.recap_outlet_product_maxs`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `recap_outlet_product_maxs` | `search, page, sort, ascending, limit, id.eq, period.eq, period.like, mr_code.eq, spv_code.eq, asm_code.eq, outlet_id.eq, sector.eq, outlet_id.like, outlet_name.like, product_id.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### recap_outlets

Source: [config/entity/recap_outlets.json](config/entity/recap_outlets.json). Table mapping: `SKI_MF_PROD.recap_outlets`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | Runtime-derived; no explicit override | `search, page, sort, ascending, limit, redis, id.eq, period.eq, structure_id.eq, outlet_id.eq, outlet_name.eq, sector.eq, target.eq, sales_max.eq, estimation.eq, realization.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### sales_trend

Source: [config/entity/sales_trend.json](config/entity/sales_trend.json). Table mapping: `SKI_MF_PROD.sales_trend`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | Runtime-derived; no explicit override | `search, page, sort, ascending, limit, redis, id.eq, project_id.eq, project_name.eq, customer_id.eq, customer_name.eq, period.eq, sales.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### sales_trend_total

Source: [config/entity/sales_trend_total.json](config/entity/sales_trend_total.json). Table mapping: `SKI_MF_PROD.sales_trend_total`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | Runtime-derived; no explicit override | `search, page, sort, ascending, limit, redis, id.eq, project_id.eq, project_name.eq, period.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### status_closings

Source: [config/entity/status_closings.json](config/entity/status_closings.json). Table mapping: `SKI_MF_PROD.status_closings`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | Runtime-derived; no explicit override | `search, page, sort, ascending, limit, redis, id.eq, period.eq, name.eq, closed.eq, created_at.eq, updated_at.eq, created_by_id.eq, updated_by_id.eq, deleted_by_id.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### target_sector_structures

Source: [config/entity/target_sector_structures.json](config/entity/target_sector_structures.json). Table mapping: `SKI_MF_PROD.target_sector_structures`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `target_sector_structures` | `search, page, sort, ascending, limit, id.eq, period.eq, period.like, structure_id.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `period.eq` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### visit_flow_discount_proposal_estimations

Source: [config/entity/visit_flow_discount_proposal_estimations.json](config/entity/visit_flow_discount_proposal_estimations.json). Table mapping: `SKI_MF_PROD.visit_flow_discount_proposal_estimations`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `visit_flow_discount_proposal_estimations` | `search, page, sort, ascending, limit, id.eq, visit_flow_discount_proposal_id.eq, customer_id.eq, product_id.eq, outlet_id.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


### visit_flow_discount_proposals

Source: [config/entity/visit_flow_discount_proposals.json](config/entity/visit_flow_discount_proposals.json). Table mapping: `SKI_MF_PROD.visit_flow_discount_proposals`.

| Method | enable_method | Explicit endpoint override | Declared parameters |
| --- | --- | --- | --- |
| `GET` | True | `visit_flow_discount_proposals` | `search, page, sort, ascending, limit, id.eq, period.eq, marketing_structure_id.eq` |
| `POST` | True | Runtime-derived; no explicit override | See entity configuration |
| `PUT` | True | Runtime-derived; no explicit override | See entity configuration |
| `DELETE` | True | Runtime-derived; no explicit override | See entity configuration |
| `PATCH` | True | Runtime-derived; no explicit override | `` |
| `TRACE` | True | Runtime-derived; no explicit override | `` |


## Database and operational notes

Entity configuration is an input to the runtime, not proof that every mapped table/column exists in the connected schema. Compare table definitions and method-specific SQL against the actual database before changing behavior. Public-resource flags describe configuration only; gateway and runtime authentication remain separate.

For investigation, SELECT/plain EXPLAIN SELECT use the authorized production read-only path. Proposed mutations default to DEV and require the exact query, impact and explicit user confirmation before execution; production mutations default to an unexecuted proposal. No database credentials are documented here.

## Documentation provenance

Updated on 2026-09-27 from all local entity files and route registrations. The runtime implementation is unavailable in this checkout, so a complete runtime-generated route list cannot be established from these files alone.
