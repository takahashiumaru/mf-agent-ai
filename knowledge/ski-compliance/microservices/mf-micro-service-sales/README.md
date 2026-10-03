# MF Micro Service — Sales (`GO-MF-MICRO-SALES`)

[![Go Version](https://img.shields.io/badge/Go-1.23-00ADD8?style=flat&logo=go)](https://golang.org/)
[![Coverage](https://img.shields.io/badge/Coverage-94.7%25-brightgreen?style=flat&logo=go)](test/)
[![Web Framework](https://img.shields.io/badge/Framework-Gin%20v1.9.1-008ECF?style=flat&logo=gin)](https://gin-gonic.com/)
[![ORM](https://img.shields.io/badge/ORM-GORM%20v1.25.2-00758F?style=flat)](https://gorm.io/)
[![Database](https://img.shields.io/badge/Database-MySQL%208.x-4479A1?style=flat&logo=mysql)](https://www.mysql.com/)
[![Observability](https://img.shields.io/badge/Tracing-OpenTelemetry%20OTLP-F5A800?style=flat&logo=opentelemetry)](https://opentelemetry.io/)
[![Coverage Gate](https://img.shields.io/badge/Coverage%20Gate-%E2%89%A5%2070%25-brightgreen?style=flat)](Makefile)

A high-performance Go backend microservice responsible for the sales domain in the **SKI (Sales & Marketing Enterprise System)**. It processes transaction records, calculates distributor/field force sales, manages stock movements, tracks marketing targets, reconciles distributor extra discounts & claims, bridges master data, and synchronizes data with external enterprise systems (MSSQL ETL & Redis Job Queues).

---

## 📑 Table of Contents
1. [Key Features & Business Domains](#-key-features--business-domains)
2. [Technology Stack](#-technology-stack)
3. [Architecture & Project Layout](#-architecture--project-layout)
4. [API Endpoints Reference](#-api-endpoints-reference)
5. [Environment Configuration](#-environment-configuration)
6. [Getting Started & Local Setup](#-getting-started--local-setup)
7. [Testing & Quality Gates](#-testing--quality-gates)
8. [Docker & CI/CD Deployment](#-docker--cicd-deployment)
9. [AI Agent Guidelines & Repository Standards](#-ai-agent-guidelines--repository-standards)

---

## 🚀 Key Features & Business Domains

- **🏢 Sales Field Force (`SalesFf`)**:
  - Detailed sales calculation and reporting by field representatives (MR, SPV, ASM, FSM).
  - Multi-level sector breakdowns, sales-vs-target comparisons, and sales net achievements.
  - Automated report generation and email dispatch for OTX and Morses ASM sales.
  - Period closing management integrated with Nocode closing checks.

- **🚚 Sales Distributor (`SalesDistributor`)**:
  - Ingestion and parsing of distributor invoice-level transaction data.
  - Calculation of on/off distributor and principal discounts.
  - Integration with PDU endpoints for automated sales processing.

- **📦 Stock Distributor (`StockDistributor`)**:
  - Distributor warehouse stock movement tracking (beginning stock, incoming stock, sales out, ending stock).
  - Automated evaluation reports and stock-vs-product reconciliation email dispatch.

- **🔗 Master Data Bridging (`BridgingOutlet`, `BridgingProduct`)**:
  - Maps external distributor-specific outlet and product identifiers to internal standardized master records.
  - Manages bridging status, verification workflows, and audit history.

- **🎯 Target Marketing (`TargetMarketing`)**:
  - Sets and evaluates monthly sales targets per marketing structure, ASM, SPV, and product.
  - Bulk CSV target upload and automated warehouse target calculation synchronization.

- **🏷️ Distributor Extra Discount & Claims (`DistributorExtraDiscount`)**:
  - Distributor extra discount percentage agreements and validation workflows.
  - Credit note and claim submissions (`DistributorExtraDiscountClaim`) with audit trail logging.

- **🤝 Sales Principal & Sales Share (`SalesPrincipal`, `SalesShare`)**:
  - Principal-level sales allocations and share percentage distributions across marketing structures.
  - Unregistered territory outlet detection and reconciliation.

- **🔄 External Integrations & Worker Dispatch**:
  - **MSSQL ETL Sync**: Propagates data mutations to Microsoft SQL Server via HTTP ETL endpoints (`/sync-ski`, `/find-data`).
  - **Nocode Period Locking**: Validates financial/sales period closing status via `/status_closings`.
  - **Redis Queue System**: Queues heavy background batch jobs (Sales FF & Sales Principal calculations) to Redis workers.
  - **OpenTelemetry Tracing**: Distributed tracing with OTLP gRPC collector.

---

## 🛠 Technology Stack

| Component | Technology | Version | Details |
| :--- | :--- | :--- | :--- |
| **Language** | Go | `1.23` | Statically typed, compiled language |
| **Web Framework** | Gin | `v1.9.1` | High-performance HTTP web framework |
| **ORM** | GORM | `v1.25.2` | Object-Relational Mapping for Go |
| **Database Driver** | MySQL Driver | `v1.5.1` | MySQL driver for GORM (`parseTime=true`) |
| **GORM Hints** | GORM Hints | `v1.1.2` | SQL index and optimizer hints |
| **Validation** | Go Playground Validator | `v10.14.1` | Struct & field validation with custom tags |
| **Configuration** | Viper | `v1.16.0` | Environment config loader from `.env` |
| **Auth** | JWT (dgrijalva) | `v3.2.0` | Token verification & custom user claims |
| **Observability** | OpenTelemetry OTLP | `v1.18.0` / `otelgin v0.44.0` | Distributed gRPC tracing |
| **Testing** | Standard `testing`, Testify, SQLMock | `v1.8.4` / `v1.5.2` | Unit tests & SQL mock assertions |
| **Containerization** | Docker & Docker Compose | `Compose 3.9` | Containerized deployment |

---

## 🏗 Architecture & Project Layout

The service follows a clean layered architecture with strict separation of concerns and panic-recover error orchestration.

```
HTTP Request
     │
     ▼
Router (`app/router.go` + `route/*.go`)
     │  (Middleware: otelgin, ErrorHandler, auth.Auth)
     ▼
Controller (`controller/*_controller_impl.go`)
     │  (Parses query params / JSON body into DTOs, validates input)
     ▼
Service (`service/*_service_impl.go`)
     │  (Owns DB transactions: Begin/CommitOrRollback, business logic)
     ▼
Repository (`repository/*_repository_impl.go`)
     │  (Executes GORM queries, logs history, triggers ETL callbacks)
     ▼
Database (MySQL) & External Systems (Audit History, MSSQL ETL, Redis Queue)
```

### Directory Map

```text
.
├── .agent/              # AI Agent engineering knowledge base and 13 skills
├── app/                 # Database connection & OpenTelemetry router bootstrap
├── auth/                # JWT authentication middleware and claims parser
├── configuration/       # Viper environment configuration loader
├── controller/          # HTTP controllers handling REST requests/responses
├── exception/           # Central panic recovery handler & custom error types
├── helper/              # Dynamic query filters, history logger, ETL & Redis helpers
├── model/
│   ├── domain/          # GORM domain models with database schema tags
│   └── web/             # Request & Response DTOs and WebResponse envelope
├── repository/          # GORM persistence layer and query builders
├── route/               # Gin route definitions per domain module (62 endpoints)
├── scripts/             # Automation scripts (dynamic coverage updater)
├── test/                # Consolidated unit test suite (App, Auth, Service, Repo, etc.)
├── Dockerfile           # Multi-stage production container build
├── Makefile             # Development, testing, coverage, and lint commands
└── main.go              # Application entrypoint
```

---

## 📡 API Endpoints Reference

All secured endpoints require a valid Bearer JWT Token in the `Authorization` header (`Authorization: Bearer <token>`). The service exposes **62 API endpoints** organized into the following business domains:

### 1. Master Data Bridging (10 Endpoints)
| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/bridgings/outlets` | Yes | List bridging outlets with query filters (`distributor_id.eq`, `outlet_id.eq`, `outlet_distributor_id.eq`) & pagination |
| `GET` | `/bridgings/outlets/:id` | Yes | Get bridging outlet mapping by ID |
| `POST` | `/bridgings/outlets` | Yes | Create new bridging outlet mapping |
| `PUT` | `/bridgings/outlets/:id` | Yes | Update bridging outlet status (`status` field) |
| `DELETE` | `/bridgings/outlets/:id` | Yes | Soft-delete bridging outlet mapping |
| `GET` | `/bridgings/products` | Yes | List bridging products with query filters (`distributor_id.eq`, `product_id.eq`, `product_distributor_id.eq`) |
| `GET` | `/bridgings/products/:id` | Yes | Get bridging product mapping by ID |
| `POST` | `/bridgings/products` | Yes | Create new bridging product mapping |
| `PUT` | `/bridgings/products/:id` | Yes | Update bridging product status (`status` field) |
| `DELETE` | `/bridgings/products/:id` | Yes | Soft-delete bridging product mapping |

### 2. Sales Field Force (`SalesFf`) (17 Endpoints)
| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/sales-ffs` | Yes | List field force sales records with query filters & pagination |
| `GET` | `/sales-ffs/by/product` | No | List aggregated sales FF grouped by product |
| `GET` | `/sales-ffs/by-structure/:periodStart/:periodEnd/:periodStructure` | Yes | Get sales FF aggregated by marketing structure hierarchy |
| `GET` | `/sales-ffs/report` | Yes | Retrieve sales FF formatted report view |
| `GET` | `/sales-ffs/outlet-non-bridging/by-structure` | Yes | List non-bridging outlets grouped by marketing structure |
| `GET` | `/sales-ffs/:period/outlet-non-bridging` | Yes | List non-bridging outlets for a specific period |
| `POST` | `/sales-ffs/:period/:distributorID` | No | Trigger synchronous Sales FF calculation process for distributor & period |
| `POST` | `/sales-ffs/process-warehouse/outlet-non-bridding/:periodStart/:periodEnd` | No | Process non-bridging outlets to warehouse staging for period range |
| `PUT` | `/sales-ffs/closed/:period` | Yes | Lock or unlock Sales FF period status (validates Nocode closing status) |
| `POST` | `/sales-ffs/otx/by-email` | No | Generate OTX sales report and dispatch via email |
| `POST` | `/sales-ffs/sales-morses/by-email-asm` | No | Generate Morses ASM sales report and dispatch email to ASMs |
| `GET` | `/sales-ffs/sales-vs-target/:period` | Yes | Compare actual Sales FF vs marketing target for period |
| `GET` | `/sales-ffs/sales-vs-cn/:period` | Yes | Compare actual Sales FF vs credit notes (CN) for period |
| `GET` | `/sales-ffs/summary-by-period/:periodStart/:periodEnd` | Yes | Get summary of sales and targets for a period range |
| `GET` | `/sales-ffs/sales-net-by-u` | Yes | Get net sales breakdown by user hierarchy |
| `GET` | `/sales-ffs/sales-by-achievement` | Yes | Get sales performance and achievement breakdown |
| `GET` | `/sales-ffs/sales-by-sector` | Yes | Get sales breakdown by sector and target achievement |

### 3. Sales Distributor & Stock Distributor (8 Endpoints)
| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/sales-distributors` | Yes | List distributor sales invoices with query filters & pagination |
| `GET` | `/sales-distributors/sales-ffs` | Yes | Monitor and track sales across distributors |
| `GET` | `/report-sales/by/level` | Yes | Generate sales report grouped by organizational level |
| `GET` | `/report-sales/no-claim` | Yes | Retrieve distributor sales records without claims |
| `POST` | `/import-sales-distributors/process/:period/:distributorID` | No | Ingest, import, and process PDU distributor sales data |
| `GET` | `/stock-distributors` | Yes | List distributor warehouse stock movements (beginning, in, sales out, ending) |
| `POST` | `/stock-distributors/evaluation/by-email` | No | Trigger distributor stock evaluation email report |
| `POST` | `/stock-distributors/vs-stock-product/by-email` | No | Trigger stock vs product reconciliation email report |

### 4. Sales Principal & Sales Share (8 Endpoints)
| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/sales-principals` | Yes | List sales principal transaction records with query filters |
| `GET` | `/sales-principals/:header/distributors` | Yes | Retrieve outlets or products by distributor header ID |
| `GET` | `/sales-principals/unregistered-territory-outlets/:period` | Yes | Detect and list unregistered territory outlets for period |
| `POST` | `/sales-principals/:period/:distributorID` | No | Process sales principal transaction calculations |
| `PUT` | `/sales-principals/closed/:period` | Yes | Lock or unlock Sales Principal period status |
| `GET` | `/sales-shares` | Yes | List sales share percentage distributions |
| `POST` | `/sales-shares` | Yes | Create new sales share allocation mapping |
| `DELETE` | `/sales-shares/:period/:outletHeaderID/:outletSubID/:productID/:dldfID/:marketingStructureID/:invoice/:batch` | Yes | Delete specific sales share mapping entry by composite key |

### 5. Target Marketing (6 Endpoints)
| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/target-marketings` | Yes | List marketing sales target records with query filters |
| `GET` | `/target-marketings/headers` | Yes | Get target marketing header summary records |
| `GET` | `/target-marketings/details` | Yes | Get detailed target marketing breakdown records |
| `POST` | `/target-marketings/:period` | Yes | Upload CSV target marketing data for a period |
| `PUT` | `/target-marketings` | Yes | Update marketing target entries |
| `DELETE` | `/target-marketings/:period/:codeMr/:productID` | Yes | Delete marketing target entry by period, MR code, and product ID |

### 6. Distributor Extra Discount & Claims (6 Endpoints)
| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/distributor-extra-discounts` | Yes | List distributor extra discount agreements |
| `POST` | `/distributor-extra-discounts/process/:period` | No | Process distributor extra discount calculations for period |
| `GET` | `/distributor-extra-discount-claims` | Yes | List extra discount claim submissions with filters |
| `POST` | `/distributor-extra-discount-claims` | Yes | Submit new extra discount claim record |
| `PUT` | `/distributor-extra-discount-claims/:id` | Yes | Update extra discount claim status or details by ID |
| `DELETE` | `/distributor-extra-discount-claims/:id` | Yes | Delete extra discount claim submission by ID |

### 7. Work Calendar, Sales Out & Background Redis Jobs (7 Endpoints)
| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/work-calendars` | Yes | List work calendar operational days per period |
| `PUT` | `/work-calendars` | Yes | Update work calendar configurations |
| `DELETE` | `/work-calendars/:period` | Yes | Delete work calendar configuration for period |
| `GET` | `/sales-out/:period/:code/:type/:groupby` | No | Retrieve calculated sales out summary by code and group |
| `POST` | `/warehouse/sales-out/process` | No | Process sales out calculations into warehouse staging table |
| `POST` | `/job-redis/sales-principals/:period` | No | Dispatch asynchronous Sales Principal batch calculation to Redis queue |
| `POST` | `/job-redis/sales-ffs/:period` | No | Dispatch asynchronous Sales FF batch calculation to Redis queue |

---

## ⚙️ Environment Configuration

Configuration is loaded using **Viper** from `./configuration/.env`. Example variables:

```ini
# Server Port
PORT=8080

# Database Configuration (MySQL 8.x)
HOST_DB=127.0.0.1
PORT_DB=3306
USER_DB=root
PASSWORD_DB=secret
DATABASE_DB=ski_sales_db

# JWT Authentication Secrets
ACCESS_SECRET=your_jwt_access_secret_key
REFRESH_SECRET=your_jwt_refresh_secret_key

# External Microservice Integrations
SYNC_URL=https://sync-ski.internal.domain
NOCODE_URL=https://nocode-platform.internal.domain
API_HOST=http://127.0.0.1:8080
API_KEY=your_api_key_here

# Observability (OpenTelemetry OTLP Tracer)
OTEL_EXPORTER_OTLP_ENDPOINT=localhost:4317
INSECURE_MODE=true
```

| Variable | Description |
| :--- | :--- |
| `PORT` | HTTP port for the Gin web server (e.g. `8080`) |
| `HOST_DB`, `PORT_DB` | Hostname and port of the MySQL database |
| `USER_DB`, `PASSWORD_DB` | Database credentials |
| `DATABASE_DB` | MySQL database name |
| `ACCESS_SECRET`, `REFRESH_SECRET` | JWT HMAC secret keys for token validation |
| `SYNC_URL` | Base URL of the MSSQL ETL synchronization service |
| `NOCODE_URL` | Base URL of the Nocode closing platform |
| `API_HOST` | Self-referential API host for internal webhooks/email attachments |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | OpenTelemetry gRPC collector endpoint |
| `INSECURE_MODE` | Set `true` to disable TLS for OpenTelemetry gRPC collector |

---

## 💻 Getting Started & Local Setup

### Prerequisites
- **Go**: `1.23` or higher
- **MySQL**: `8.0` or higher
- **Git**: Installed and configured for GitLab private repositories (`gitlab.com/VNEU/*`)

### 1. Clone & Configure Git Access
```bash
git clone https://gitlab.com/VNEU/mf-micro-service-sales.git
cd mf-micro-service-sales

# Configure private module access if necessary
git config --global url."https://${ACCESS_TOKEN}@gitlab.com".insteadOf "https://gitlab.com"
export GOPRIVATE="gitlab.com/VNEU/*"
```

### 2. Prepare Environment File
```bash
cp configuration/.env.example configuration/.env
# Edit configuration/.env with your local MySQL credentials
```

### 3. Install Dependencies & Run
```bash
go mod download
make run
```
The server will start listening at `http://localhost:8080`.

### 4. Makefile Commands

| Command | Action |
| :--- | :--- |
| `make run` | Run server locally (`go run main.go`) |
| `make test` | Run all unit tests (`go test ./...`) |
| `make cov` | Run tests, generate `coverage.out`, and update README coverage dynamically |
| `make update-cov` | Alias for `make cov` to sync test coverage with README |
| `make check-cov` | Enforce **>= 70%** statement coverage quality gate & sync README |
| `make fmt` | Format all Go source files (`go fmt ./...`) |
| `make lint` | Run `golangci-lint` |
| `make critic` | Run `gocritic check ./...` |
| `make check-all` | Run staticcheck, gocritic, and coverage verification |
| `make tidy` | Run `go mod tidy` and `go mod verify` |

---

## 🧪 Testing & Quality Gates

The test suite is organized inside `test/` using `go-sqlmock` and `testify`, ensuring complete isolation from production databases:

```bash
# Run unit tests with race detection
go test -race ./...

# Run statement coverage gate (requires >= 70% statement coverage) & update README dynamically
make check-cov

# Run full quality gate (lint + static check + test coverage)
make check-all
```

### 📊 Code Coverage & Quality Metrics

| Metric | Threshold / Target | Current Live Value | Status |
| :--- | :---: | :---: | :---: |
| **Statement Coverage** | `>= 70.0%` | **94.7%** | `PASSED` |
| **Test Suite Isolation** | 100% Mock / In-Memory | Fully Isolated | `PASSED` |
| **Race Detector** | `-race` enabled | 0 Race Conditions | `PASSED` |
| **Static Analysis** | `staticcheck` + `gocritic` | 0 Issues | `PASSED` |

---

## 🚢 Docker & CI/CD Deployment

### Production Docker Build
The service utilizes a multi-stage Docker build:

```bash
docker build \
  -t mf-micro-service-sales:latest \
  --build-arg ACCESS_TOKEN="your_gitlab_token" \
  --build-arg CI_SERVER_HOST="gitlab.com" \
  .
```

### GitLab CI/CD Pipeline
Pipelines are automatically triggered based on Git tags:
- **Development / Staging**: Tags matching `v*.*.*-m*` or `v*.*.*-rc*` (executes test quality gates and deploys to Dev).
- **Production**: Tags matching `v*.*.*-release*` (executes test quality gates and deploys to Production servers).

---

## 🤖 AI Agent Guidelines & Repository Standards

This codebase includes structured AI coding agent documentation and skills located in `.agent/`:

- **Operational Rules**: Read [AGENTS.md](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/AGENTS.md) and [.agent/INDEX.md](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/.agent/INDEX.md).
- **Architecture & Domain Rules**: Review [.agent/ARCHITECTURE.md](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/.agent/ARCHITECTURE.md) and [.agent/DOMAIN.md](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/.agent/DOMAIN.md).
- **Critical Invariants**:
  1. **Panic-Based Error Flow**: Handlers and services throw known errors caught by `app.ErrorHandler()`.
  2. **Transaction Ownership**: Transactions are created in the Service layer (`tx := service.DB.Begin()`, `defer helper.CommitOrRollback(tx)`).
  3. **No Runtime AutoMigrate**: Database schema changes must be applied via SQL migration scripts, never via runtime `AutoMigrate`.
  4. **Mandatory Changelog Entry**: Every AI Agent modifying this repository **MUST** record its commit message and summary under `## Commit History` in [.agent/CHANGELOG.md](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/.agent/CHANGELOG.md) using the format `## YYYY-MM-DD — `commit message`` before committing or pushing.

