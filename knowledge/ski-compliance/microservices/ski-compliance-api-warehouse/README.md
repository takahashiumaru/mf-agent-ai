# ski-compliance-api-warehouse

Warehouse processing and reporting for sales, discounts, credit notes, stock, marketing targets, customer activity and general-trade summaries.

## Table of Contents

- [Overview and architecture](#overview-and-architecture)
- [Technology stack](#technology-stack)
- [Directory structure](#directory-structure)
- [Getting started](#getting-started)
- [Complete API endpoint reference](#complete-api-endpoint-reference)
- [Database and integration notes](#database-and-integration-notes)
- [Quality and deployment](#quality-and-deployment)

## Overview and architecture

`main.go` wires database handles and validation, then `app/router.go` registers functions in `route/`. Requests pass through the registered middleware and controllers to services, repositories and model/response mapping. Transaction and synchronization behavior must be read in the owning service and repository.

## Technology stack

- Module: `gitlab.com/VNEU/ski-compliance-api-warehouse`.
- Go language version declared by [go.mod](go.mod): **1.23**.
- Gin: `v1.9.1`.
- GORM: `v1.25.8`.
- GORM MySQL driver: `v1.5.1`.
- Validator: `v10.14.1`.
- Viper: `v1.16.0`.

Internal/private modules are pinned in `go.mod`; access to those module versions is required. A sibling checkout does not automatically replace a pinned dependency.

## Directory structure

| Path | Purpose |
| --- | --- |
| [app/](app/) | Database bootstrap and router composition |
| [route/](route/) | HTTP route registration and dependency wiring |
| [controller/](controller/) | HTTP binding and response handling |
| [service/](service/) | Business rules and orchestration |
| [repository/](repository/) | Database queries and persistence |
| [model/](model/) | Persistence models and API DTOs |
| [configuration/](configuration/) | Local configuration loader/files |
| [auth/](auth/) | Local authentication helpers; routes may import another module instead |
| [helper/](helper/) | Shared utilities and integrations |
| [exception/](exception/) | Error definitions and response handling |
| [Auth/](Auth/) | Custom mux and authentication |

## Getting started

1. Install the Go version required by `go.mod` and configure access to private module dependencies.
2. Prepare local configuration from the loader below. Obtain secrets through the approved secret-management process; do not copy production credentials into README examples.
3. Use an isolated development database and review bootstrap/integration side effects before starting the application.
4. Run from the repository root:

```sh
go mod download
go run .
```

These are documented commands, not commands executed during this README refresh.

### Configuration

Loader: [configuration/configuration.go](configuration/configuration.go).
The loader reads `configuration/.env`. `main.go` uses `":" + PORT` for its HTTP address.

Declared configuration keys (names only):

| Key |
| --- |
| `ACCESS_SECRET` |
| `REFRESH_SECRET` |
| `PORT` |
| `PORT_DB` |
| `HOST_DB` |
| `PASSWORD_DB` |
| `USER_DB` |
| `DATABASE_DB` |
| `SYNC_URL` |
| `OTEL_EXPORTER_OTLP_ENDPOINT` |
| `INSECURE_MODE` |


## Complete API endpoint reference

**73 source declarations** are listed below, including declarations not called by the current router. Paths preserve the source spelling and parameters. This inventory describes the local checkout, not a verified deployed API.

“Registered” means the route function has a call in `app/router.go`. “Declaration only” means no such call was found there. Auth names show the exact route wrapper, not a claim that the endpoint is public when no wrapper appears. Global middleware and gateway policy can still apply. Handler names link behavior to its implementation without inventing business rules.

### Call Pareto Route

Source: [route/call_pareto_route.go](route/call_pareto_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/warehouse/call-pareto/process/meta_base/:period` | No route-level Auth wrapper | Registered | `(callParetoController.ProcessCallPareto)` | [L22](route/call_pareto_route.go#L22) |


### Credit Note Gt Customer Route

Source: [route/credit_note_gt_customer_route.go](route/credit_note_gt_customer_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/credit-note/warehouse/gt/customers/headers` | auth.Auth | Declaration only | `auth.Auth(creditNoteGtCustomerController.FindAllHeader, []string{})` | [L23](route/credit_note_gt_customer_route.go#L23) |
| `GET` | `/credit-note/warehouse/gt/customers/details` | auth.Auth | Declaration only | `auth.Auth(creditNoteGtCustomerController.FindAllDetail, []string{})` | [L24](route/credit_note_gt_customer_route.go#L24) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Credit Note Gt Outlet Route

Source: [route/credit_note_gt_outlet_route.go](route/credit_note_gt_outlet_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/credit-note/warehouse/gt/outlets/headers` | auth.Auth | Declaration only | `auth.Auth(creditNoteGtOutletController.FindAllHeader, []string{})` | [L23](route/credit_note_gt_outlet_route.go#L23) |
| `GET` | `/credit-note/warehouse/gt/outlets/details` | auth.Auth | Declaration only | `auth.Auth(creditNoteGtOutletController.FindAllDetail, []string{})` | [L24](route/credit_note_gt_outlet_route.go#L24) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Credit Note Gt Product Route

Source: [route/credit_note_gt_product_route.go](route/credit_note_gt_product_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/credit-note/warehouse/gt/products/headers` | auth.Auth | Declaration only | `auth.Auth(creditNoteGtProductController.FindAllHeader, []string{})` | [L23](route/credit_note_gt_product_route.go#L23) |
| `GET` | `/credit-note/warehouse/gt/products/details` | auth.Auth | Declaration only | `auth.Auth(creditNoteGtProductController.FindAllDetail, []string{})` | [L24](route/credit_note_gt_product_route.go#L24) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Credit Note Gt Route

Source: [route/credit_note_gt_route.go](route/credit_note_gt_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/credit-note/warehouse/gt/headers` | auth.Auth | Declaration only | `auth.Auth(creditNoteGtController.FindAllHeader, []string{})` | [L23](route/credit_note_gt_route.go#L23) |
| `GET` | `/credit-note/warehouse/gt/details` | auth.Auth | Declaration only | `auth.Auth(creditNoteGtController.FindAllDetail, []string{})` | [L24](route/credit_note_gt_route.go#L24) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Credit Note Route

Source: [route/credit_note_route.go](route/credit_note_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/credit-note/warehouse` | auth.Auth | Registered | `auth.Auth(creditNoteController.FindAll, []string{})` | [L30](route/credit_note_route.go#L30) |
| `POST` | `/credit-note/warehouse/process/:period` | No route-level Auth wrapper | Registered | `creditNoteController.ProcessCreditNote` | [L31](route/credit_note_route.go#L31) |
| `POST` | `/credit-note/warehouse/ski-header/process/:no-ski` | No route-level Auth wrapper | Registered | `creditNoteController.ProcessSkiHeader` | [L32](route/credit_note_route.go#L32) |
| `POST` | `/credit-note/warehouse/ski-payment/process/:no-ski` | No route-level Auth wrapper | Registered | `creditNoteController.ProcessSkiPayment` | [L33](route/credit_note_route.go#L33) |
| `POST` | `/credit-note/warehouse/ski-credit-note-process/:no-ski` | No route-level Auth wrapper | Registered | `creditNoteController.ProcessSkiCreditNote` | [L34](route/credit_note_route.go#L34) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Customer Estimasi Vs Cn

Source: [route/customer_estimasi_vs_cn.go](route/customer_estimasi_vs_cn.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/warehouse/customer-estimation-vs-cn` | No route-level Auth wrapper | Registered | `(customerEstimationVsCnController.FindAll)` | [L20](route/customer_estimasi_vs_cn.go#L20) |
| `POST` | `/warehouse/customer-estimation-vs-cn/process/:period` | No route-level Auth wrapper | Registered | `(customerEstimationVsCnController.CustomerEstimationVsCnProcess)` | [L21](route/customer_estimasi_vs_cn.go#L21) |


### Customer Family Route

Source: [route/customer_family_route.go](route/customer_family_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/customer-families` | auth.Auth | Registered | `auth.Auth(customerFamilyController.FindAll, []string{})` | [L23](route/customer_family_route.go#L23) |
| `POST` | `/customer-families` | auth.Auth | Registered | `auth.Auth(customerFamilyController.Create, []string{})` | [L24](route/customer_family_route.go#L24) |
| `PUT` | `/customer-families/:customer-id/:flags/:names` | auth.Auth | Registered | `auth.Auth(customerFamilyController.Update, []string{})` | [L25](route/customer_family_route.go#L25) |
| `DELETE` | `/customer-families/:customer-id/:flags/:names` | auth.Auth | Registered | `auth.Auth(customerFamilyController.Delete, []string{})` | [L26](route/customer_family_route.go#L26) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Customer Hobby Route

Source: [route/customer_hobby_route.go](route/customer_hobby_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/customer-hobbies` | auth.Auth | Registered | `auth.Auth(customerHobbyController.FindAll, []string{})` | [L23](route/customer_hobby_route.go#L23) |
| `POST` | `/customer-hobbies` | auth.Auth | Registered | `auth.Auth(customerHobbyController.Create, []string{})` | [L24](route/customer_hobby_route.go#L24) |
| `PUT` | `/customer-hobbies/:customer-id/:hobbies` | auth.Auth | Registered | `auth.Auth(customerHobbyController.Update, []string{})` | [L25](route/customer_hobby_route.go#L25) |
| `DELETE` | `/customer-hobbies/:customer-id/:hobbies` | auth.Auth | Registered | `auth.Auth(customerHobbyController.Delete, []string{})` | [L26](route/customer_hobby_route.go#L26) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Customer Media Social Route

Source: [route/customer_media_social_route.go](route/customer_media_social_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/customer-media-socials` | auth.Auth | Registered | `auth.Auth(customerMediaSocialController.FindAll, []string{})` | [L23](route/customer_media_social_route.go#L23) |
| `POST` | `/customer-media-socials` | auth.Auth | Registered | `auth.Auth(customerMediaSocialController.Create, []string{})` | [L24](route/customer_media_social_route.go#L24) |
| `PUT` | `/customer-media-socials/:customer-id/:flags` | auth.Auth | Registered | `auth.Auth(customerMediaSocialController.Update, []string{})` | [L25](route/customer_media_social_route.go#L25) |
| `DELETE` | `/customer-media-socials/:customer-id/:flags` | auth.Auth | Registered | `auth.Auth(customerMediaSocialController.Delete, []string{})` | [L26](route/customer_media_social_route.go#L26) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Customer Note Route

Source: [route/customer_note_route.go](route/customer_note_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/customer-notes` | auth.Auth | Registered | `auth.Auth(customerNoteController.FindAll, []string{})` | [L24](route/customer_note_route.go#L24) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Customer Task Route

Source: [route/customer_task_route.go](route/customer_task_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/customer-tasks` | auth.Auth | Registered | `auth.Auth(customerTaskController.FindAll, []string{})` | [L23](route/customer_task_route.go#L23) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Customer Timeline Route

Source: [route/customer_timeline_route.go](route/customer_timeline_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/customer-timelines` | auth.Auth | Registered | `auth.Auth(customerTaskController.FindAll, []string{})` | [L24](route/customer_timeline_route.go#L24) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Customer Work Practice Route

Source: [route/customer_work_practice_route.go](route/customer_work_practice_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/customer-work-practices` | auth.Auth | Registered | `auth.Auth(customerWorkPracticeController.FindAll, []string{})` | [L23](route/customer_work_practice_route.go#L23) |
| `POST` | `/customer-work-practices` | auth.Auth | Registered | `auth.Auth(customerWorkPracticeController.Create, []string{})` | [L24](route/customer_work_practice_route.go#L24) |
| `PUT` | `/customer-work-practices/:customer-id/:outlet-id/:start` | auth.Auth | Registered | `auth.Auth(customerWorkPracticeController.Update, []string{})` | [L25](route/customer_work_practice_route.go#L25) |
| `DELETE` | `/customer-work-practices/:customer-id/:outlet-id/:start` | auth.Auth | Registered | `auth.Auth(customerWorkPracticeController.Delete, []string{})` | [L26](route/customer_work_practice_route.go#L26) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Data Bp Teguh Process Route

Source: [route/data_bp_teguh_process_route.go](route/data_bp_teguh_process_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/warehouse/data-bp-teguh-process/:period` | No route-level Auth wrapper | Registered | `(summaryFfController.ProcessToDataBpTeguhWh)` | [L20](route/data_bp_teguh_process_route.go#L20) |


### Discount Gt Customer Route

Source: [route/discount_gt_customer_route.go](route/discount_gt_customer_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/discount/warehouse/gt/customers/headers` | auth.Auth | Registered | `auth.Auth(discountGtCustomerController.FindAllHeader, []string{})` | [L23](route/discount_gt_customer_route.go#L23) |
| `GET` | `/discount/warehouse/gt/customers/details` | auth.Auth | Registered | `auth.Auth(discountGtCustomerController.FindAllDetail, []string{})` | [L24](route/discount_gt_customer_route.go#L24) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Discount Gt Outlet Route

Source: [route/discount_gt_outlet_route.go](route/discount_gt_outlet_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/discount/warehouse/gt/outlets/headers` | auth.Auth | Registered | `auth.Auth(discountGtOutletController.FindAllHeader, []string{})` | [L23](route/discount_gt_outlet_route.go#L23) |
| `GET` | `/discount/warehouse/gt/outlets/details` | auth.Auth | Registered | `auth.Auth(discountGtOutletController.FindAllDetail, []string{})` | [L24](route/discount_gt_outlet_route.go#L24) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Discount Gt Product Route

Source: [route/discount_gt_product_route.go](route/discount_gt_product_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/discount/warehouse/gt/products/headers` | auth.Auth | Registered | `auth.Auth(discountGtProductController.FindAllHeader, []string{})` | [L23](route/discount_gt_product_route.go#L23) |
| `GET` | `/discount/warehouse/gt/products/details` | auth.Auth | Registered | `auth.Auth(discountGtProductController.FindAllDetail, []string{})` | [L24](route/discount_gt_product_route.go#L24) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Discount Gt Route

Source: [route/discount_gt_route.go](route/discount_gt_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/discount/warehouse/gt/headers` | auth.Auth | Registered | `auth.Auth(discountGtController.FindAllHeader, []string{})` | [L23](route/discount_gt_route.go#L23) |
| `GET` | `/discount/warehouse/gt/details` | auth.Auth | Registered | `auth.Auth(discountGtController.FindAllDetail, []string{})` | [L24](route/discount_gt_route.go#L24) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Discount Route

Source: [route/discount_route.go](route/discount_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/discount/warehouse` | auth.Auth | Registered | `auth.Auth(discountController.FindAll, []string{})` | [L29](route/discount_route.go#L29) |
| `POST` | `/discount/warehouse/process/:period` | No route-level Auth wrapper | Registered | `discountController.ProcessDiscount` | [L30](route/discount_route.go#L30) |

Auth imports: `auth` → `gitlab.com/VNEU/ski-compliance-api-warehouse/auth`.

### Distributor Product

Source: [route/distributor_product.go](route/distributor_product.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/warehouse/distributor-product/process/:period` | No route-level Auth wrapper | Registered | `(summaryFfController.ProcessToTargetMarketingWh)` | [L20](route/distributor_product.go#L20) |


### Gt Customer Header Route

Source: [route/gt_customer_header_route.go](route/gt_customer_header_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/warehouse/gt-customer-headers` | No route-level Auth wrapper | Registered | `(gtCustomerHeaderController.FindAll)` | [L20](route/gt_customer_header_route.go#L20) |
| `POST` | `/warehouse/gt-customer-headers/process/:period` | No route-level Auth wrapper | Registered | `(gtCustomerHeaderController.GtCustomerHeaderProcess)` | [L21](route/gt_customer_header_route.go#L21) |


### Gt Outlet Header Route

Source: [route/gt_outlet_header_route.go](route/gt_outlet_header_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/warehouse/gt-outlet-headers` | No route-level Auth wrapper | Registered | `(gtOutletHeaderController.FindAll)` | [L20](route/gt_outlet_header_route.go#L20) |
| `POST` | `/warehouse/gt-outlet-headers/process/:period` | No route-level Auth wrapper | Registered | `(gtOutletHeaderController.GtOutletHeaderProcess)` | [L21](route/gt_outlet_header_route.go#L21) |


### Gt Product Header Route

Source: [route/gt_product_header_route.go](route/gt_product_header_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/warehouse/gt-product-headers/by-product` | No route-level Auth wrapper | Registered | `(gtOutletHeaderController.FindByProduct)` | [L20](route/gt_product_header_route.go#L20) |
| `POST` | `/warehouse/gt-product-headers/process/:period` | No route-level Auth wrapper | Registered | `(gtOutletHeaderController.GtProductHeaderProcess)` | [L21](route/gt_product_header_route.go#L21) |


### K4 Wh Route

Source: [route/k4_wh_route.go](route/k4_wh_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/warehouse/k4/process/:period` | No route-level Auth wrapper | Registered | `(summaryFfController.K4WhProcess)` | [L20](route/k4_wh_route.go#L20) |


### Marketing Absent Route

Source: [route/marketing_absent_route.go](route/marketing_absent_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/warehouse/marketing-absent/process/:period` | No route-level Auth wrapper | Registered | `(marketingAbsentController.ProcessMarketingAbsentWh)` | [L20](route/marketing_absent_route.go#L20) |


### Sales Gt Outlet Wh Route

Source: [route/sales_gt_outlet_wh_route.go](route/sales_gt_outlet_wh_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/sales/gt/outlet` | No route-level Auth wrapper | Registered | `salesGtOutletController.FindSalesGtOutletWh` | [L22](route/sales_gt_outlet_wh_route.go#L22) |


### Sales Gt Product Wh Route

Source: [route/sales_gt_product_wh_route.go](route/sales_gt_product_wh_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/sales/gt/product` | No route-level Auth wrapper | Registered | `salesGtProductController.FindSalesGtProductWh` | [L22](route/sales_gt_product_wh_route.go#L22) |


### Sales Gt Wh Route

Source: [route/sales_gt_wh_route.go](route/sales_gt_wh_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/sales/gt` | No route-level Auth wrapper | Registered | `salesGtController.FindSalesGtWh` | [L22](route/sales_gt_wh_route.go#L22) |


### Sales Out Wh Process Route

Source: [route/sales_out_wh_process_route.go](route/sales_out_wh_process_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/sales-target/achievement/:period/by/:code` | No route-level Auth wrapper | Registered | `(summaryFfController.FindByPeriodAreaCode)` | [L23](route/sales_out_wh_process_route.go#L23) |
| `POST` | `/warehouse/sales-out/process/:period/:distributorId` | No route-level Auth wrapper | Registered | `(summaryFfController.ProcessToSalesOutWh)` | [L24](route/sales_out_wh_process_route.go#L24) |


### Sales Stock Distributor Route

Source: [route/sales_stock_distributor_route.go](route/sales_stock_distributor_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/report/product-stock/ed` | No route-level Auth wrapper | Registered | `(summaryFfController.FindReportProductStockEd)` | [L21](route/sales_stock_distributor_route.go#L21) |
| `POST` | `/warehouse/sales-stock-distributor/process/meta_base/:period` | No route-level Auth wrapper | Registered | `(summaryFfController.ProcessToSalesStockDistributorWh)` | [L22](route/sales_stock_distributor_route.go#L22) |


### Sales Stock Principal Route

Source: [route/sales_stock_principal_route.go](route/sales_stock_principal_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/warehouse/sales-stock-principal/process/meta_base/:period` | No route-level Auth wrapper | Registered | `(salesStockPrincipal.ProcessToSalesStockPrincipalWh)` | [L21](route/sales_stock_principal_route.go#L21) |


### Ski Route

Source: [route/ski_route.go](route/ski_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/ski/warehouse/process/:period/:no-ski` | No route-level Auth wrapper | Registered | `creditNoteController.ProcessSki` | [L24](route/ski_route.go#L24) |
| `POST` | `/ski/warehouse/ski-header/:no-ski` | No route-level Auth wrapper | Registered | `creditNoteController.ProcessSkiHeader` | [L25](route/ski_route.go#L25) |
| `POST` | `/ski/warehouse/ski-payment/:no-ski` | No route-level Auth wrapper | Registered | `creditNoteController.ProcessSkiPayment` | [L26](route/ski_route.go#L26) |
| `POST` | `/ski/warehouse/ski-credit-note/:no-ski` | No route-level Auth wrapper | Registered | `creditNoteController.ProcessSkiCreditNote` | [L27](route/ski_route.go#L27) |


### Sp Warehouse Route

Source: [route/sp_warehouse_route.go](route/sp_warehouse_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/warehouse/report-bp-teguh/process/:period` | No route-level Auth wrapper | Registered | `(spWarehouseController.ProcessSpReportBpTeguhProcess)` | [L20](route/sp_warehouse_route.go#L20) |


### Stock Distributor Route

Source: [route/stock_distributor_route.go](route/stock_distributor_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/warehouse/stock-distributor/process/:period` | No route-level Auth wrapper | Registered | `(summaryFfController.ProcessToStockDistributorWh)` | [L20](route/stock_distributor_route.go#L20) |
| `GET` | `/stock-distributor/:period/:productID/:distributorID` | No route-level Auth wrapper | Registered | `(summaryFfController.FindByPeriodProduct)` | [L21](route/stock_distributor_route.go#L21) |


### Stock Header Route

Source: [route/stock_header_route.go](route/stock_header_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/warehouse/stock/process/:period` | No route-level Auth wrapper | Registered | `(stockHeaderController.ProcessToStockWh)` | [L20](route/stock_header_route.go#L20) |


### Target Marketing Route

Source: [route/target_marketing_route.go](route/target_marketing_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/warehouse/target-marketing/process/:period` | No route-level Auth wrapper | Registered | `(targetMarketingController.ProcessToTargetMarketingWh)` | [L22](route/target_marketing_route.go#L22) |


### Update Structure New Route

Source: [route/update_structure_new_route.go](route/update_structure_new_route.go).

| Method | Path | Route auth | Registration | Handler expression | Source |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/warehouse/structure-new/process/:period` | No route-level Auth wrapper | Registered | `(summaryFfController.ProcessStructureNowWh)` | [L20](route/update_structure_new_route.go#L20) |


## Database and integration notes

Persistence/bootstrap source: [app/database.go](app/database.go). No active AutoMigrate/RunSQLFromFile call was found in the inspected app source; commented migration snippets do not execute.

## Quality and deployment

Useful checks, to run in an appropriate development environment:

```sh
go build ./...
go test ./...
go vet ./...
```

No application tests, service startup, deployment or database mutations were performed for this README update. Existing coverage files or badges are not a fresh coverage measurement.

Container definition: [Dockerfile](Dockerfile). Base stages: `golang:1.23`.

```sh
docker build -t ski-compliance-api-warehouse:local .
```

Review [docker-compose.yml](docker-compose.yml) for environment files, mounts, networks and host port mapping before running Compose.

## Documentation provenance

Updated on 2026-09-27 from the current local source/configuration. The discount-proposal README supplied the section structure; endpoint, version and configuration facts were extracted from this repository. Source declarations and local changes are not deployment verification.

Additional investigation guidance: [AGENTS.md](AGENTS.md).
