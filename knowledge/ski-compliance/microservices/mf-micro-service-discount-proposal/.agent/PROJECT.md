# .agent/PROJECT.md — Project & Service Overview

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

## 1. System Overview & Purpose

`mf-micro-service-discount-proposal` is a core Golang microservice responsible for managing the **Discount Proposal (Usulan Diskon)** and **Credit Note (CN)** workflows within the SKI Compliance (Metiska Farma) pharmaceutical distribution and sales management ecosystem.

The microservice handles:
1. **Discount Proposals**: Creation, budget calculation, multi-level hierarchy approval, and tracking of promotional discount schemes (`SKI1`, `SKI2`, `DPL`, `DPF`, `DPL2`).
2. **Estimation & Products**: Tracking product allocations, discount percentages (Principal vs Distributor, On-Invoice vs Off-Invoice), and outlet bindings (`discount_proposal_estimations`, `discount_proposal_limit_details`).
3. **Disbursement & Recipients**: Managing payout recipients, bank account routing, NPWP tax deductions, and payment execution (`discount_proposal_recipients`, `discount_proposal_payments`).
4. **Credit Notes**: Recording invoice deductions and promotional adjustments per customer, outlet, product, and period (`credit_notes`, `cqrs_credit_notes`).
5. **Customer Balances**: Tracking period opening balances, cumulative discount adjustments, returns, and closing balances (`customer_balances`).
6. **Amortization**: Tracking multi-month promotional amortizations across accounting periods (`credit_note_amortizations`).
7. **Legacy ETL & Data Sync**: Asynchronous synchronization of transactional records to external legacy MSSQL/FoxPro systems.

---

## 2. Directory Layout & Module Responsibilities

| Directory | Layer / Purpose | Key Responsibilities |
| :--- | :--- | :--- |
| `main.go` | Application Entrypoint | Initializes configuration, connects to MySQL, registers custom validators, creates HTTP server on configured port. |
| `app/` | Core Bootstrap | `database.go`: Initializes GORM connection and logger.<br>`router.go`: Sets up Gin engine, tracing middleware, error handler, and routes. |
| `auth/` | Authentication | Extracts Bearer JWT tokens, validates secret HMAC signatures, and populates `AccessDetails`. |
| `configuration/` | Config Management | Uses Viper to parse `./configuration/.env` into the `Configuration` struct. |
| `controller/` | HTTP Presentation | Implements Gin controller handlers, parses query/body parameters, and returns `web.WebResponse`. |
| `exception/` | Error Management | Defines sentinel errors, `ErrorSendToResponse`, and central `ErrorHandler` responding with formatted JSON. |
| `helper/` | Utilities | Houses custom validators, transaction helper (`CommitOrRollback`), audit history generator, filter builder, date math, and ETL runners. |
| `model/domain/` | Domain & Entities | GORM structs mapping to MySQL tables, along with response mapper methods (`To*Response`). |
| `model/web/` | DTOs & Contracts | Request/response structs and the standard `WebResponse` API envelope. |
| `repository/` | Persistence Layer | Direct GORM and raw SQL database queries, audit history creation, and ETL dispatching. |
| `route/` | Routing & DI | Registers HTTP routes on `*gin.Engine` and manually wires repository, service, and controller dependencies. |
| `service/` | Business Logic | Business validations, period closing checks, transaction lifecycle management (`tx.Begin`/`CommitOrRollback`), and domain operations. |

---

## 3. Entrypoint & Application Bootstrap Flow

The bootstrap sequence in `main.go` proceeds as follows:

```go
// 1. Load configuration from ./configuration/.env
configuration, err := c.LoadConfig()

// 2. Open GORM database connection with configured logger
db := app.ConnectDatabase(configuration.User, configuration.Host, configuration.Password, configuration.PortDB, configuration.Db)

// 3. Initialize Validator and register custom domain validations
validate := validator.New()
helper.RegisterValidation(validate)

// 4. Initialize Gin router, OpenTelemetry tracer, middleware, and route mappings
router := app.NewRouter(db, validate)

// 5. Start HTTP server
server := http.Server{
    Addr:    ":" + port,
    Handler: router,
}
server.ListenAndServe()
```

---

## 4. Configuration Schema

Configuration is managed via Viper in `configuration/configuration.go` reading `./configuration/.env`:

| Key / Environment Variable | Type | Description |
| :--- | :--- | :--- |
| `PORT` | `string` | HTTP listening port (e.g. `8089`) |
| `HOST_DB` | `string` | MySQL host address |
| `PORT_DB` | `string` | MySQL port (e.g. `3306`) |
| `USER_DB` | `string` | Database username |
| `PASSWORD_DB` | `string` | Database password |
| `DATABASE_DB` | `string` | Database name |
| `ACCESS_SECRET` | `string` | JWT access token secret key |
| `REFRESH_SECRET` | `string` | JWT refresh token secret key |
| `SYNC_URL` | `string` | External sync API base URL |
| `NOCODE_URL` | `string` | Nocode / Status Closing API URL |
| `API_HOST` | `string` | External API host URL |
| `OTEL_EXPORTER_OTLP_ENDPOINT`| `string` | OpenTelemetry collector gRPC endpoint |
| `INSECURE_MODE` | `string` | OTel transport security toggle |

---

## 5. External Systems & Upstream Services

The service interacts with several external services and internal packages:

1. **MySQL Database**: Primary relational data store for discount proposals, estimations, credit notes, and balances.
2. **Legacy MSSQL / FoxPro**: Asynchronous ETL sync executed via `go helper.EtlToMssql(...)` for legacy system backwards compatibility.
3. **Nocode / Status Closings Service (`NOCODE_URL`)**: Queried via HTTP in `helper.ValidateClosing(...)` to check whether a transaction period is closed.
4. **Internal GitLab Microservice Modules**:
   - `gitlab.com/VNEU/go-helper`: Shared utilities
   - `gitlab.com/VNEU/mf-micro-service-structure`: Marketing hierarchy, territory, and organizational structure
   - `gitlab.com/VNEU/mf-micro-service-counter`: ID generator and sequence counter service
   - `gitlab.com/VNEU/mf-micro-service-customer`: Customer and customer territory management
   - `gitlab.com/VNEU/mf-micro-service-distributor`: Distributor master data
   - `gitlab.com/VNEU/mf-micro-service-product`: Product catalogue and master data
   - `gitlab.com/VNEU/mf-micro-service-city`: City and regional reference data
   - `gitlab.com/VNEU/mf-micro-service-master-document-proposal`: Document categories and metadata
   - `gitlab.com/VNEU/mf-micro-service-marketing-user`: User authentication and authorization models
5. **OpenTelemetry Collector**: Receives distributed trace spans over gRPC.
