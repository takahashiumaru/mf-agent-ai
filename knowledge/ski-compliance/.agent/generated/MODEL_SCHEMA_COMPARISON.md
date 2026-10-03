# GORM model ↔ live database comparison

Repositories: `mf-micro-service-bank`, `mf-micro-service-customer`, `mf-micro-service-event`, `mf-micro-service-marketing-user`, `mf-micro-service-outlet-2`, `mf-micro-service-product`.

Live metadata observed: 2026-09-27 01:57:48.000000 UTC; MySQL 8.4.2; target schema `SKI_MF_PROD`. Database access was session read-only and retrieved metadata/DDL only; no row data or writes.

Domain structs parsed: 53. Tables matched by GORM conventional plural naming or explicit TableName: 44. Mapped models with declared columns absent in the live object: 0. Matched models with type/tag signals needing review: 0. Persistence candidates whose target is absent: 2.

## Method and limits

The six go.mod files use GORM v1.24.2–v1.25.2. Most matched models rely on GORM default plural table naming (no literal TableName method was found). `CustomerProfile` is explicitly mapped to the repository target `.Table("summary_customers")`. Other names are convention-based, not runtime-parsed. `gorm.Model` was expanded to id/created_at/updated_at/deleted_at; association fields were excluded from physical columns. Field names use Go-to-snake-case and explicit `column:` tags. Explicit `gorm:size` and `not null` tags are compared where available. A Go pointer alone is not treated as proof of nullable SQL.

“Model columns absent in DB” is a potential runtime mismatch only when the field is persisted by the relevant query. “DB columns absent in model” may be intentional legacy data, raw-query output, externally owned fields, or ignored columns. Check repository Select/Updates/Create and raw SQL before calling either defect. Projections under `model/domain` may not be table models.

## Definite source-column gaps and type/tag warnings

No direct-column gaps or type/tag warnings found in matched models.

## Models needing explicit mapping / query-level review

- `mf-micro-service-bank` `DiscountProposalTransferredType` → `discount_proposal_transferred_types`: table not found. Source: [mf-micro-service-bank/model/domain/discount_proposal_transferred_type.go](../../mf-micro-service-bank/model/domain/discount_proposal_transferred_type.go). Confirm query-level usage before treating it as a table mapping.
- `mf-micro-service-customer` `CustomerProfile` → `summary_customers`: table not found. Source: [mf-micro-service-customer/model/domain/customer_profile.go](../../mf-micro-service-customer/model/domain/customer_profile.go). Confirm query-level usage before treating it as a table mapping.
- `mf-micro-service-customer` `CustomerTerritoryProductOnFactur` → `projection`: projection: Projection over customer_territory_products + joined discount/product fields. Source: [mf-micro-service-customer/model/domain/customer_territory_product.go](../../mf-micro-service-customer/model/domain/customer_territory_product.go). Confirm query-level usage before treating it as a table mapping.
- `mf-micro-service-event` `ViewEventHeaderToClass` → `projection`: projection: Projection for live view view_event_header_to_classes. Source: [mf-micro-service-event/model/domain/event_header.go](../../mf-micro-service-event/model/domain/event_header.go). Confirm query-level usage before treating it as a table mapping.
- `mf-micro-service-marketing-user` `UserAccessCsv` → `projection`: projection: CSV file record. Source: [mf-micro-service-marketing-user/model/domain/menu_authentication.go](../../mf-micro-service-marketing-user/model/domain/menu_authentication.go). Confirm query-level usage before treating it as a table mapping.
- `mf-micro-service-outlet-2` `BridgingOutlet` → `projection`: projection: Projection over outlets + bridging_outlets aggregate. Source: [mf-micro-service-outlet-2/model/domain/outlet.go](../../mf-micro-service-outlet-2/model/domain/outlet.go). Confirm query-level usage before treating it as a table mapping.
- `mf-micro-service-outlet-2` `MappingCustomer` → `projection`: projection: Join projection from outlet/marketing/customer mappings. Source: [mf-micro-service-outlet-2/model/domain/outlet.go](../../mf-micro-service-outlet-2/model/domain/outlet.go). Confirm query-level usage before treating it as a table mapping.
- `mf-micro-service-outlet-2` `OutletShareName` → `projection`: projection: Projection over vw_migrasi_ski_outlet_shares. Source: [mf-micro-service-outlet-2/model/domain/outlet_share.go](../../mf-micro-service-outlet-2/model/domain/outlet_share.go). Confirm query-level usage before treating it as a table mapping.
- `mf-micro-service-product` `ProductProgramView` → `projection`: projection: Response projection; repository query reads product_programs. Source: [mf-micro-service-product/model/domain/product_program.go](../../mf-micro-service-product/model/domain/product_program.go). Confirm query-level usage before treating it as a table mapping.

## Full matched-model matrix

| Repo | Model | Live table | Name basis | Missing columns | Extra DB columns | Type/tag warning |
|---|---|---|---|---|---|---|
| mf-micro-service-bank | Account | accounts | inferred | — | — | 0 |
| mf-micro-service-bank | Bank | banks | inferred | — | — | 0 |
| mf-micro-service-bank | BankBranch | bank_branches | inferred | — | — | 0 |
| mf-micro-service-bank | BankTransferFee | bank_transfer_fees | inferred | — | — | 0 |
| mf-micro-service-bank | History | histories | inferred | — | — | 0 |
| mf-micro-service-customer | Customer | customers | inferred | — | — | 0 |
| mf-micro-service-customer | CustomerGroupSpecialist | customer_group_specialists | inferred | — | — | 0 |
| mf-micro-service-customer | CustomerInactiveStatus | customer_inactive_statuses | inferred | — | — | 0 |
| mf-micro-service-customer | CustomerPosition | customer_positions | inferred | — | — | 0 |
| mf-micro-service-customer | CustomerSpecialist | customer_specialists | inferred | — | — | 0 |
| mf-micro-service-customer | CustomerTerritoryOutlet | customer_territory_outlets | inferred | — | — | 0 |
| mf-micro-service-customer | CustomerTerritoryProduct | customer_territory_products | inferred | — | — | 0 |
| mf-micro-service-customer | History | histories | inferred | — | — | 0 |
| mf-micro-service-event | EventClass | event_classes | inferred | — | — | 0 |
| mf-micro-service-event | EventDetail | event_details | inferred | — | — | 0 |
| mf-micro-service-event | EventHeader | event_headers | inferred | — | — | 0 |
| mf-micro-service-event | EventOrganizer | event_organizers | inferred | — | — | 0 |
| mf-micro-service-event | EventSpecialist | event_specialists | inferred | — | — | 0 |
| mf-micro-service-event | History | histories | inferred | — | — | 0 |
| mf-micro-service-marketing-user | Division | divisions | inferred | — | — | 0 |
| mf-micro-service-marketing-user | GroupAuthentication | group_authentications | inferred | — | — | 0 |
| mf-micro-service-marketing-user | GroupMenuAuthentication | group_menu_authentications | inferred | — | — | 0 |
| mf-micro-service-marketing-user | History | histories | inferred | — | — | 0 |
| mf-micro-service-marketing-user | MenuAuthentication | menu_authentications | inferred | — | — | 0 |
| mf-micro-service-marketing-user | MenuSidebar | menu_sidebars | inferred | — | — | 0 |
| mf-micro-service-marketing-user | Session | sessions | inferred | — | — | 0 |
| mf-micro-service-marketing-user | User | users | inferred | — | — | 0 |
| mf-micro-service-outlet-2 | History | histories | inferred | — | — | 0 |
| mf-micro-service-outlet-2 | Outlet | outlets | inferred | — | — | 0 |
| mf-micro-service-outlet-2 | OutletGroup | outlet_groups | inferred | — | — | 0 |
| mf-micro-service-outlet-2 | OutletGroupMapping | outlet_group_mappings | inferred | — | — | 0 |
| mf-micro-service-outlet-2 | OutletShare | outlet_shares | inferred | — | — | 0 |
| mf-micro-service-outlet-2 | OutletType | outlet_types | inferred | — | — | 0 |
| mf-micro-service-product | History | histories | inferred | — | — | 0 |
| mf-micro-service-product | Principal | principals | inferred | — | — | 0 |
| mf-micro-service-product | Product | products | inferred | — | — | 0 |
| mf-micro-service-product | ProductCategory | product_categories | inferred | — | — | 0 |
| mf-micro-service-product | ProductMaxDiscount | product_max_discounts | inferred | — | — | 0 |
| mf-micro-service-product | ProductPacking | product_packings | inferred | — | — | 0 |
| mf-micro-service-product | ProductPicture | product_pictures | inferred | — | — | 0 |
| mf-micro-service-product | ProductPrice | product_prices | inferred | — | — | 0 |
| mf-micro-service-product | ProductProgram | product_programs | inferred | — | — | 0 |
| mf-micro-service-product | ProductType | product_types | inferred | — | — | 0 |
| mf-micro-service-product | ProductUnit | product_units | inferred | — | — | 0 |

## Important source-to-schema findings

- `mf-micro-service-bank` `DiscountProposalTransferredType` is passed to `db.Model(...)`; its GORM-convention table `discount_proposal_transferred_types` is absent from the captured schema. The local repository has Create/Find/Update/Delete flows for this model. Verify the runtime DSN/schema or missing-object deployment before concluding whether those flows currently fail.
- `mf-micro-service-customer` `CustomerProfile` repository explicitly targets `summary_customers` for writes; that table is absent from the captured schema. This is a direct repository target/schema discrepancy; Create, Update and Delete use `.Table("summary_customers")`. Those methods require the object on their configured connection.
- Additional customer/product/product-price columns are mapped as read-only fields excluded from migration and JSON; existing API writes remain unchanged.
- Local model corrections align primary-key tags, event fee precision, account verifier signedness, product program ID lengths, history lengths and outlet nullability with the captured schema. See MODEL_SCHEMA_FIXES.md for verification and unresolved targets.

## Recommended checks before changing a model

1. Trace every flagged model through Create/Save/Updates/Select and raw SQL; a response-only field does not need a DB column.
2. Check associations and FK column type pairs separately. Same column name does not prove matching signedness or referenced key.
3. Review duplicate embedding/shadowing of `gorm.Model` fields in source; GORM schema precedence depends on field definitions and version.
4. Validate all write/query paths in a non-production isolated environment before changing a type, constraint or migration. No schema change is proposed or executed in this analysis.
