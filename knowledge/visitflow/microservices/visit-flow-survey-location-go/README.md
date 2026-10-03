# Visit Flow - Survey Location Microservice (`visit-flow-survey-location-go`)

> **AI agents:** Start with [AGENTS.md](AGENTS.md), then [.agent/INDEX.md](.agent/INDEX.md). Current source/runtime evidence and workspace database rules govern task decisions.


[![Go Version](https://img.shields.io/badge/Go-1.23-00ADD8?style=flat&logo=go)](https://golang.org)
[![Coverage](https://img.shields.io/badge/Coverage-95.4%25-brightgreen?style=flat&logo=go)](test/)
[![Gin Framework](https://img.shields.io/badge/Gin-v1.9.1-008ECF?style=flat&logo=go)](https://gin-gonic.com)
[![GORM](https://img.shields.io/badge/ORM-GORM%20v1.25.4-blue?style=flat)](https://gorm.io)
[![Database](https://img.shields.io/badge/Database-MySQL-4479A1?style=flat&logo=mysql)](https://www.mysql.com)
[![OpenTelemetry](https://img.shields.io/badge/Telemetry-OpenTelemetry-F5A800?style=flat&logo=opentelemetry)](https://opentelemetry.io)

Microservice for outlet survey and audit management within the **Visit Flow** ecosystem. This service manages field survey evaluation questionnaires, surveyed outlet data, product availability and Point-of-Sale Materials (POSM) display audits, as well as distributor master data and material catalogs.

---

## 📑 Table of Contents

- [Architecture & Engineering Maturity Audit](#-architecture--engineering-maturity-audit)
- [Architecture & Workflow](#-architecture--workflow)
- [Key Features](#-key-features)
- [Directory Structure](#-directory-structure)
- [API Endpoints Catalog](#-api-endpoints-catalog)
- [Environment Configuration (`.env`)](#-environment-configuration-env)
- [Getting Started (Local Development)](#-getting-started-local-development)
- [Testing & Quality Gates](#-testing--quality-gates)
- [Docker & Deployment](#-docker--deployment)

---

## 📊 Architecture & Engineering Maturity Audit

Evaluation of architecture, clean code, and production readiness for `visit-flow-survey-location-go`:

```
┌─────────────────────────┬─────────────────────────┬─────────────────────────┬─────────────────────────┐
│   OVERALL MATURITY      │   MATURE PILLARS (✅)   │   NEEDS ACTION (⚠️)     │   TEST SUITE COVERAGE   │
│       7.64 / 10         │        7 / 11           │        4 / 11           │         95.4%           │
│   Grade: B+ (Production)│     (63.6% Siap)        │     (Upload & Memory)   │   Full Suite PASS 100%  │
└─────────────────────────┴─────────────────────────┴─────────────────────────┴─────────────────────────┘
```

### 🏆 Mature & Production-Ready Pillars (✅ Average 8.0 / 10)

| No | Maturity Pillar | Score | Visual Meter | Status | Highlights & Achievements |
|:---:|:---|:---:|:---|:---:|:---|
| **05** | **Testing** | **8.5** / 10 | `█████████░` 85% | `✅ Completed` | Excellent. Statement coverage reaches 95.4% (`./...`); comprehensive test suites (auth, controller, service, repository, rollback contract, characterization) pass 100%. |
| **01** | **Clean Code** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Completed. Debug logs (`fmt.Println`) eliminated; `DistributorService.FindAll` queries rerouted to `tx.Read` preventing lock contention; unused imports removed. |
| **02** | **Package Design** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Completed. Modular structure focused on the bounded context of location surveys, questionnaire audits, and distributor master data without circular cross-service dependencies. |
| **03** | **SOLID / DIP** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Completed. All services implement interface-based repository dependencies via constructor injection (DIP & ISP satisfied); no hidden concrete instantiations. |
| **06** | **Concurrency Safety** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Safe. Survey submissions and POSM audit workflows execute synchronously and deterministically; no unmanaged fire-and-forget goroutines risking data races. |
| **10** | **CI / CD** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Good. Automated `.gitlab-ci.yml` pipeline, multi-stage Docker builds, and automated quality test suites execute reliably. |
| **07** | **Observability** | **7.5** / 10 | `███████▌░░` 75% | `✅ Completed` | Good. SigNoz OpenTelemetry distributed tracing (`goHelper.SignozSpan`) active across controllers and main use cases. |

### ⚠️ Pillars Requiring Action / Tech Debt (⚠️ Average 7.0 / 10)

| No | Maturity Pillar | Score | Visual Meter | Status | Issues & Risk Analysis | Priority |
|:---:|:---|:---:|:---|:---:|:---|:---:|
| **08** | **Performance** | **7.0** / 10 | `███████░░░` 70% | `⚠️ Moderate` | Read/Write splitting active; Excel/CSV distributor bulk import parsing needs memory streaming (potential OOM spikes during large file imports). | `⚡ P1` |
| **09** | **Security** | **7.0** / 10 | `███████░░░` 70% | `⚠️ Pending` | Multi-tenant `company_id` scoping is consistent; file upload validation for survey photo evidence requires strict binary magic-byte and payload size auditing. | `⚡ P1` |
| **04** | **Architecture** | **7.0** / 10 | `███████░░░` 70% | `⚠️ Moderate` | Most isolated service in the ecosystem (no direct cross-repo Go imports); however, `*gin.Context` still permeates business service signatures. | `📌 P2` |
| **11** | **Production Reliability** | **7.0** / 10 | `███████░░░` 70% | `⚠️ Moderate` | Service is stable in production via stateless CRUD; however, lacks rate limiting for concurrent survey photo uploads per surveyor. | `📌 P2` |

### 🎯 Strategic Remediation Roadmap

```
[ P1 HIGH ]     ──► Optimize Distributor Excel/CSV File Imports
                    ├─ Use streaming readers (excelize stream) instead of buffering entire sheets into memory
                    └─ Prevent container memory spikes and Out-Of-Memory (OOM) kills

[ P1 HIGH ]     ──► File Upload Security & Magic Byte Validation
                    ├─ Validate binary signatures for survey photo evidence (JPEG/PNG/WebP)
                    └─ Enforce strict upload size limits per photo and request payload

[ P2 MEDIUM ]   ──► Rate Limiting for Survey Photo Uploads
                    ├─ Prevent bandwidth and storage I/O saturation during mass surveyor sync
                ──► Clean Architecture Signature Standardization
                    └─ Gradually migrate (*gin.Context) parameters in service methods to (context.Context)
```

---

## 🏛 Architecture & Workflow

This service is built using a modular Clean Layered Architecture:

```
[ Mobile / Field Surveyor App ]
               │
               ▼
      [ Gin HTTP Router ] (`route/`)
               │
               ▼
  [ JWT Auth & Context Layer ] (`auth/`)
               │
               ▼
        [ Controllers ] (`controller/`)  ──> Request Binding & Response DTO Mapping
               │
               ▼
         [ Services ] (`service/`)       ──> Business Rules, Validations, Transaction Boundaries
               │
               ▼
       [ Repositories ] (`repository/`)  ──> GORM SQL Queries with Read/Write Resolver
               │
               ▼
      [ MySQL Database ]
```

### Design Characteristics
- **Isolasi Multi-Tenant**: Semua query dibatasi secara ketat menggunakan filter `company_id`.
- **Read/Write DB Resolver**: Mengoptimalkan performa kueri menggunakan koneksi terpisah antara replika pembacaan (`db.Read`) dan mutasi transaksi (`db.Write`).
- **Data Integrity**: Menjamin konsistensi data transaksi kuesioner dan audit produk dengan `helper.CommitOrRollback`.

---

## 🚀 Key Features

1. **Manajemen Sesi Survei Outlet (*Outlet Surveys*)**:
   - Creation and tracking of field outlet survey sessions.
   - Recording surveyor identity, survey timestamp, completion status, and coordinate geotagging.
2. **Kuesioner Dinamis (*Outlet Survey Questions*)**:
   - Pembuatan pertanyaan survei fleksibel (pilihan ganda, teks, skala nilai/skor).
   - Penentuan bobot dan kategori pertanyaan kuesioner.
3. **Data Outlet yang Disurvei (*Surveyed Customers*)**:
   - Direct field observation recordings for outlet/customer premises.
   - Evaluation of store profile, physical condition, and surveyor questionnaire responses.
4. **Audit Produk & Materi Promosi (*Customer Products & POSM Evaluation*)**:
   - Audit ketersediaan stok produk dan harga jual di tingkat outlet.
   - Pengecekan display produk kompetitor vs produk prinsipal.
   - Tracking Point of Sale Materials (POSM) installed across outlets.
5. **Master Data Distributor & Material**:
   - Master data distributor rekanan logistik/distribusi.
   - Katalog master materi promosi dan merchandise (*materials*).

---

## 📁 Directory Structure

```plaintext
visit-flow-survey-location-go/
├── app/                  # Inisialisasi koneksi database dan router Gin
├── auth/                 # Middleware verifikasi JWT claims & context builder
├── configuration/        # Loader konfigurasi Viper (.env)
├── controller/           # Controller handlers (Surveys, Questions, Products, etc.)
├── helper/               # SQL filter builders, transaction wrappers, error mappers
├── model/
│   ├── domain/           # Entitas domain model GORM & schema database
│   └── web/              # DTOs Request dan Response
├── repository/           # Repository interface & implementasi GORM MySQL
├── route/                # Definisi route API dan wiring dependency injection
├── service/              # Logic bisnis survei, validasi, dan transaksi
├── test/                 # Test suites, mock repositories, dan sqlmock tests
├── visit-app-diagram/    # Mermaid ERD & arsitektur sistem
├── Dockerfile            # Container build multi-stage
├── docker-compose.yml    # Service compose definition
├── Makefile              # Automation script untuk build, test, lint, coverage
└── main.go               # Application entrypoint
```

---

## 🔌 API Endpoints Catalog

The following is the complete catalog of REST API endpoints provided by this service:

### Distributors (`route/distributor_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/distributors/:id` | Delete Distributor record |
| `GET` | `/distributors` | Get Distributors list (filter & pagination) |
| `GET` | `/distributors/:id` | Get Distributor details by parameter |
| `POST` | `/distributors` | Create new Distributor record |
| `PUT` | `/distributors/:id` | Update Distributor record |

### Materials & POSM (`route/material_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/materials/:id` | Delete Material/POSM record |
| `GET` | `/materials` | Get Materials/POSM list (filter & pagination) |
| `GET` | `/materials/:id` | Get Material/POSM details by parameter |
| `POST` | `/materials` | Create new Material/POSM record |
| `PUT` | `/materials/:id` | Update Material/POSM record |

### Outlet Survey Customer Products & Audits (`route/outlet_survey_customer_product_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/outlet-survey-customer-products/:id` | Delete Outlet Survey Customer Product record |
| `GET` | `/outlet-survey-customer-products` | Get Outlet Survey Customer Products list (filter & pagination) |
| `GET` | `/outlet-survey-customer-products/:id` | Get Outlet Survey Customer Product details by parameter |
| `POST` | `/outlet-survey-customer-products` | Create new Outlet Survey Customer Product record |
| `PUT` | `/outlet-survey-customer-products/:id` | Update Outlet Survey Customer Product record |
| `GET` | `/outlet_surveys/:outlet-survey-id/customers/:customer-id/products` | Get Outlet Survey Customer Product details by parameter |
| `POST` | `/outlet_surveys/:outlet-survey-id/customers/:customer-id/products/:product-id` | Create new Outlet Survey Customer Product record |

### Outlet Survey Customers (`route/outlet_survey_customer_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/outlet-survey-customers/:id` | Delete Outlet Survey Customer record |
| `GET` | `/outlet-survey-customers` | Get Outlet Survey Customers list (filter & pagination) |
| `GET` | `/outlet-survey-customers/:id` | Get Outlet Survey Customer details by parameter |
| `POST` | `/outlet-survey-customers` | Create new Outlet Survey Customer record |
| `PUT` | `/outlet-survey-customers/:id` | Update Outlet Survey Customer record |
| `GET` | `/outlet_surveys/:outlet-survey-id/customers` | Get Outlet Survey Customer details by parameter |
| `POST` | `/outlet_surveys/:outlet-survey-id` | Create new Outlet Survey Customer record |
| `GET` | `/outlet-survey/customers` | Get Outlet Survey Customers list (filter & pagination) |

### Outlet Survey Questions & Questionnaires (`route/outlet_survey_question_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/outlet-survey-questions/:id` | Delete Survey Question record |
| `GET` | `/outlet-survey-questions` | Get Survey Questions list (filter & pagination) |
| `GET` | `/outlet-survey-questions/:id` | Get Survey Question details by parameter |
| `POST` | `/outlet-survey-questions` | Create new Survey Question record |
| `PUT` | `/outlet-survey-questions/:id` | Update Survey Question record |
| `POST` | `/outlet_surveys/:outlet-survey-id/questions` | Create new Survey Question record |

### Outlet Surveys Sesi (`route/outlet_survey_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/outlet-surveys/:id` | Delete Outlet Survey Session record |
| `GET` | `/outlet-surveys` | Get Outlet Survey Sessions list (filter & pagination) |
| `GET` | `/outlet-surveys/:id` | Get Outlet Survey Session details by parameter |
| `POST` | `/outlet-surveys` | Create new Outlet Survey Session record |
| `PUT` | `/outlet-surveys/:id` | Update Outlet Survey Session record |
| `POST` | `/outlet-surveys/:outlet-survey-id` | Create new Outlet Survey Session record |
| `GET` | `/outlet_surveys/all` | Get Outlet Survey Sessions list (filter & pagination) |

---


## ⚙️ Environment Configuration (`.env`)

Buat atau sesuaikan file konfigurasi pada `configuration/.env`:

```env
# Server Port
PORT=8080

# Database MySQL Connection
HOST_DB=127.0.0.1
PORT_DB=3306
USER_DB=root
PASSWORD_DB=secret_password
DATABASE_DB=visitflow_survey_db

# Security & JWT Authentication
ACCESS_SECRET=your_jwt_access_secret_key
REFRESH_SECRET=your_jwt_refresh_secret_key

# OpenTelemetry Tracing
OTEL_EXPORTER_OTLP_ENDPOINT=localhost:4317
INSECURE_MODE=true
```

---

## 🛠 Getting Started (Local Development)

### Prerequisites
- **Go**: `1.23` atau lebih baru
- **MySQL**: `8.0` atau MariaDB setara

### Steps to Run
1. **Clone repository:**
   ```bash
   git clone https://gitlab.com/VNEU/visit-flow-survey-location-go.git
   cd visit-flow-survey-location-go
   ```

2. **Download dependencies:**
   ```bash
   go mod download
   ```

3. **Siapkan konfigurasi:**
   ```bash
   cp configuration/.env.example configuration/.env
   ```

4. **Run the application:**
   ```bash
   make run
   # atau
   go run main.go
   ```

The service runs on `http://localhost:8080`.

---

## 🧪 Testing & Quality Gates

This service is rigorously verified with unit tests, sqlmock repository suites, and coverage gate thresholds:

### Coverage Status

| Metric | Actual Value | CI Gate Threshold | Status |
|---|---|---|---|
| **Total Statement Coverage** | **95.4%** | `>= 70.0%` (Target: `>= 90.0%`) |  **PASSED** |

### Coverage Breakdown per Layer

| Layer / Package | Coverage | Description |
|---|---|---|
| `route/` | **100.0%** | Routing endpoints & dependency injection |
| `model/domain/` | **100.0%** | Entitas database & domain models |
| `repository/` | **98.5%** | GORM queries, CRUD operations & DB resolver |
| `controller/` | **97.7%** | HTTP request binding, status codes & JSON DTOs |
| `service/` | **97.7%** | Business rules, validasi kuesioner & audit |
| `auth/` | **87.3%** | JWT verification & context claims |
| `helper/` | **80.5%** | SQL filter builders & helper utilities |

### Running Tests

```bash
# Run all unit tests
make test

# Run tests with coverage report
make cov

# Validate coverage quality gate (Minimum 70% threshold)
make check-cov

# Format source code
make fmt

# Static analysis & linting
make lint       # Memerlukan golangci-lint
make critic     # Memerlukan gocritic

# Run all quality checks
make check-all

# Render Mermaid diagrams to PNG & SVG
make img
```

---

## 🐳 Docker & Deployment

### Build Binary
```bash
make build
# Binary saved to bin/visit-flow-survey-location-go
```

### Build Docker Image
```bash
docker build -t visit-flow-survey-location-go:latest .
```

### Deployment with Docker Compose
```bash
docker-compose up -d
```
The `VISIT-FLOW-SURVEY-LOCATION` container runs with `Asia/Jakarta` timezone, mounts `/home/DOCKER/VISIT-FLOW-SURVEY-LOCATION/file:/app/file`, and joins the `visitflow` network.
