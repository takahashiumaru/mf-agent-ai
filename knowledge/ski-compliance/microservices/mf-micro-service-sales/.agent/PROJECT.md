# Project Overview — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## 1. Project Purpose
`mf-micro-service-sales` is a core backend microservice within the SKI compliance & enterprise ecosystem (VNEU). It processes and maintains all sales-related data, including Field Force sales (`SalesFf`), distributor sales transactions (`SalesDistributor`), distributor warehouse stock (`StockDistributor`), marketing targets, bridging data between distributors and internal master entities, distributor extra discounts, and historical sales auditing.

## 2. Main Responsibilities
- **Sales Data Aggregation & Ingestion**: Ingesting and calculating sales transaction records from distributors and field force personnel.
- **Master Data Bridging**: Mapping distributor-specific outlet and product identifiers to internal standardized master records ([model/domain/bridging_outlet.go](../model/domain/bridging_outlet.go), [model/domain/bridging_product.go](../model/domain/bridging_product.go)).
- **Sales vs Target Tracking**: Tracking actual sales against sales targets per marketing structure, ASM, SPV, and sector.
- **Distributor Extra Discount & Claims**: Managing approval workflows, percentages, and claim statuses for distributor extra discounts.
- **Period Closing & Lock Management**: Ensuring closed financial/sales periods are locked against modification via integration with the Nocode status closing service.
- **Data Synchronization (ETL)**: Propagating CRUD changes in MySQL to an enterprise Microsoft SQL Server database using synchronous or asynchronous HTTP ETL endpoints.
- **Asynchronous Task Dispatching**: Queuing background batch tasks (e.g. Sales FF and Principal processing) to Redis.

## 3. Main Business Modules
The codebase is structured into cohesive business domains across `controller/`, `service/`, `repository/`, and `model/`:
1. **Bridging Outlet & Product**:
   - Files: `bridging_outlet_*`, `bridging_product_*`
   - Purpose: Maps external distributor codes (`OutletDistributorID`, `BranchDistributorID`) to internal master `OutletID` and `ProductID`.
2. **Sales Field Force (Sales FF)**:
   - Files: `sales_ff_*`
   - Purpose: Detailed sales reporting by field representatives (MR, SPV, ASM, FSM), sector breakdowns, and target comparisons.
3. **Sales Distributor**:
   - Files: `sales_distributor_*`
   - Purpose: Distributor invoice level sales records, discounts (on/off distributor and principal), and price calculations.
4. **Stock Distributor**:
   - Files: `stock_distributor_*`
   - Purpose: Tracks beginning stock, incoming stock, sales out, ending stock, and warehouse movements at distributor branches.
5. **Sales Principal & Sales Share**:
   - Files: `sales_principal_*`, `sales_share_*`
   - Purpose: Principal-level sales allocations and share percentage distributions.
6. **Target Marketing**:
   - Files: `target_marketing_*`
   - Purpose: Marketing sales target definitions per marketing structure and time period.
7. **Distributor Extra Discount & Claim**:
   - Files: `distributor_extra_discount_*`, `distributor_extra_discount_claim_*`
   - Purpose: Discount percentage agreements, credit note / claim submissions, and validations.
8. **Work Calendar & Warehouse Process**:
   - Files: `work_calendar_*`, `sales_out_*`, `sales_out_wh_*`
   - Purpose: Working days tracking per month and warehouse sales processing.
9. **Job Redis Queue**:
   - Files: `job_redis_*`
   - Purpose: Dispatches scheduled jobs for sales calculation to Redis workers.

## 4. External Systems & Dependencies
- **Primary Database**: MySQL 8.x (accessed via GORM v2 and `gorm.io/driver/mysql`).
- **ETL Synchronization Service (MSSQL Sync)**:
  - Configuration: `SYNC_URL` in [configuration/.env](../configuration/.env)
  - Endpoints: `${SYNC_URL}/sync-ski` and `${SYNC_URL}/find-data`
  - Implementation: [helper/etl_to_mssql.go](../helper/etl_to_mssql.go)
- **Nocode / Status Closing Platform**:
  - Configuration: `NOCODE_URL`
  - Used for checking whether a table/period is closed: `${NOCODE_URL}/status_closings` in [helper/validate_closing.go](../helper/validate_closing.go).
- **Redis Queue System**:
  - Dispatches tasks via `gitlab.com/vneu/go-helper/helper.SendRedisJobRequest` in [helper/create_redis.go](../helper/create_redis.go).
- **OpenTelemetry Collector**:
  - Configuration: `OTEL_EXPORTER_OTLP_ENDPOINT` (gRPC collector for distributed tracing).
- **Shared Microservice Domain Libraries**:
  - `gitlab.com/VNEU/mf-micro-service-distributor`
  - `gitlab.com/VNEU/mf-micro-service-marketing-user`
  - `gitlab.com/VNEU/mf-micro-service-outlet-2`
  - `gitlab.com/VNEU/mf-micro-service-product`
  - `gitlab.com/VNEU/mf-micro-service-structure`
  - `gitlab.com/VNEU/mf-micro-service-discount-proposal`

## 5. Application Entrypoint & Startup
- **Entrypoint**: [main.go](../main.go)
- **Bootstrap Sequence**:
  1. Loads configuration with `c.LoadConfig()`.
  2. Connects to MySQL with `app.ConnectDatabase(...)` using GORM.
  3. Instantiates `validator.New()` and registers custom validators via `helper.RegisterValidation(validate)`.
  4. Configures OpenTelemetry tracer and initializes Gin routes via `app.NewRouter(db, validate)`.
  5. Starts `http.Server` listening on configured `PORT`.

## 6. Configuration Management
- Configuration is declared in [configuration/configuration.go](../configuration/configuration.go) and loaded using **Viper** from `./configuration/.env`.
- Required environment variables:
  - `ACCESS_SECRET`, `REFRESH_SECRET`: JWT signing keys.
  - `PORT`: HTTP port for Gin server (e.g. `8080`).
  - `PORT_DB`, `HOST_DB`, `PASSWORD_DB`, `USER_DB`, `DATABASE_DB`: MySQL connection parameters.
  - `SYNC_URL`: MSSQL ETL service base URL.
  - `NOCODE_URL`: Nocode platform base URL for status closing checks.
  - `API_HOST`: Base host of the microservice.
  - `OTEL_EXPORTER_OTLP_ENDPOINT`: OpenTelemetry collector host:port.
  - `INSECURE_MODE`: Whether OTLP uses insecure gRPC connection.
