# Visit Flow - Core Backend Service (`visit-flow-go`)

> **AI agents:** Start with [AGENTS.md](AGENTS.md), then use [.agent/INDEX.md](.agent/INDEX.md) to select task guidance. Runtime/code evidence and the workspace database rules take precedence over descriptive examples here.


[![Go Version](https://img.shields.io/badge/Go-1.23-00ADD8?style=flat&logo=go)](https://golang.org)
[![Coverage](https://img.shields.io/badge/Coverage-94.7%25-brightgreen?style=flat&logo=go)](test/)
[![Gin Framework](https://img.shields.io/badge/Gin-v1.9.1-008ECF?style=flat&logo=go)](https://gin-gonic.com)
[![GORM](https://img.shields.io/badge/ORM-GORM%20v1.25.4-blue?style=flat)](https://gorm.io)
[![Database](https://img.shields.io/badge/Database-MySQL-4479A1?style=flat&logo=mysql)](https://www.mysql.com)
[![OpenTelemetry](https://img.shields.io/badge/Telemetry-OpenTelemetry-F5A800?style=flat&logo=opentelemetry)](https://opentelemetry.io)

Core backend microservice for **Visit Flow**, managing field-visit planning and realization, customer/outlet profiling, multi-tiered organizational structures, approval workflows, product recommendations, and comprehensive visit analytics reporting.

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

Evaluation of architecture, clean code, and production readiness for `visit-flow-go`:

```
┌─────────────────────────┬─────────────────────────┬─────────────────────────┬─────────────────────────┐
│   OVERALL MATURITY      │   MATURE PILLARS (✅)   │   NEEDS ACTION (⚠️)     │   TEST SUITE COVERAGE   │
│       7.23 / 10         │        6 / 11           │        5 / 11           │         > 94%           │
│   Grade: B+ (Production)│     (54.5% Siap)        │     (Tech Debt Risk)    │   Characterization PASS │
└─────────────────────────┴─────────────────────────┴─────────────────────────┴─────────────────────────┘
```

### 🏆 Mature & Production-Ready Pillars (✅ Average 8.1 / 10)

| No | Maturity Pillar | Score | Visual Meter | Status | Highlights & Achievements |
|:---:|:---|:---:|:---|:---:|:---|
| **05** | **Testing** | **8.5** / 10 | `█████████░` 85% | `✅ Completed` | **Sangat Baik**. Coverage >94%, mock `sqlmock` mendalam pada `test/`, characterization test lolos 100%. *(Pending: live DB testcontainers di CI).* |
| **01** | **Clean Code** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Debug logs (`fmt.Println`) sanitized, read queries rerouted to `tx.Read`, dead code and unused imports removed. *(Residue: `helper.PanicIfError` on internal boundaries).* |
| **02** | **Package Design** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Giant use-case files (>1,000 lines) decomposed into cohesive sub-files (`visit_checkin.go`, `visit_plan.go`, `structure_rollover.go`). *(Pending: `*gin.Context` still in service signatures).* |
| **03** | **SOLID / DIP** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | All inline repository dependencies decoupled via *consumer-owned interfaces* & fallback getters (100% backward compatible, DIP & ISP satisfied). |
| **07** | **Observability** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | OpenTelemetry distributed tracing integrated with SigNoz (`goHelper.SignozSpan`); request spans and DB metrics tracked across primary workflows. |
| **10** | **CI / CD** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Automated `.gitlab-ci.yml` pipeline, multi-stage Docker builds, and automated test pipelines execute reliably. |

### ⚠️ Pillars Requiring Action / Tech Debt (⚠️ Average 6.2 / 10)

| No | Maturity Pillar | Score | Visual Meter | Status | Issues & Risk Analysis | Priority |
|:---:|:---|:---:|:---|:---:|:---|:---:|
| **06** | **Concurrency Safety** | **5.5** / 10 | `█████░░░░░` 55% | `⚠️ Pending` | Background goroutine (`go func()`) for FCM notifications carries active `*gin.Context` pointers (risking race condition / Gin context recycling). Bounded worker pool missing. | `🚨 P0` |
| **04** | **Architecture** | **6.0** / 10 | `██████░░░░` 60% | `⚠️ Pending` | Distributed Monolith structure; contains direct cross-repo Go import (`gitlab.com/VNEU/visit-flow-api-gateway/repository`) and transport `*gin.Context` leaking into business layers. | `⚡ P1` |
| **09** | **Security** | **6.5** / 10 | `██████▌░░░` 65% | `⚠️ Pending` | Multi-tenant scoping for `company_id` & `structure_id` is strict; legacy search query helpers still contain unparameterized raw SQL string concatenations. | `⚡ P1` |
| **08** | **Performance** | **6.5** / 10 | `██████▌░░░` 65% | `⚠️ Pending` | Read/Write splitting (`DatabaseResolver`) and rollover batching perform well; however, aggregate reporting joins remain heavy without Redis caching for master data. | `⚡ P1` |
| **11** | **Production Reliability** | **6.5** / 10 | `██████▌░░░` 65% | `⚠️ Partial` | System is stable in production; however, external HTTP calls (FCM) lack Circuit Breaker protection and rely on framework panic recovery. | `📌 P2` |

### 🎯 Strategic Remediation Roadmap

```
[ P0 CRITICAL ] ──► Secure FCM Background Goroutines
                    ├─ Detach *gin.Context pointer from go func()
                    └─ Use context.WithoutCancel() or a bounded worker pool

[ P1 HIGH ]     ──► Decouple Cross-Repo API Gateway Import
                    ├─ Define local contract interfaces in visit-flow-go
                ──► Parameterize Legacy SQL Queries
                    ├─ Replace SQL string concatenation with dynamic parameter binding
                ──► Redis Master Data Caching
                    └─ Cache master customer & location data to reduce DB join pressure

[ P2 MEDIUM ]   ──► Add Circuit Breakers
                    ├─ Protect external FCM HTTP calls with circuit breaker (sony/gobreaker)
                ──► Clean Architecture Signature Modernization
                    └─ Incrementally migrate (*gin.Context) in service layers to (context.Context)
```


---

## 🏛 Architecture & Workflow

This service adopts **Clean / Layered Architecture** with strict separation of concerns:

```
[ HTTP Client / API Gateway ]
              │
              ▼
    [ Gin Router & Routes ] (`route/`)
              │
              ▼
   [ Authentication Middleware ] (`auth/`)
              │
              ▼
       [ Controllers ] (`controller/`)  ──> Request Decoding & Response DTO Mapping
              │
              ▼
        [ Services ] (`service/`)        ──> Business Rules, Transactions, Validations
              │
              ▼
      [ Repositories ] (`repository/`)   ──> GORM SQL Queries & DB Transactions
              │
              ▼
     [ MySQL Database ]                  ──> Read/Write Database Resolver
```

### Design Principles
- **Dependency Injection**: Route bertindak sebagai *composition root* yang menginisialisasi repository, service, dan controller.
- **Transaction Boundary**: The service layer manages the transaction lifecycle using `goHelper.CreateTransaction` with separate Read and Write replica handles (`dbresolver`).
- **Data Transfer Objects**: API request and response DTOs are explicitly defined in `model/web/`, while database persistence entities reside in `model/domain/`.
- **Tenant Isolation**: Every critical query is strictly scoped by `company_id` and organizational `structure_id` hierarchy.

---

## 🚀 Key Features

1. **Visit Management**:
   - Perencanaan kunjungan (*visit planning*), penjadwalan tanggal, dan penugasan tim.
   - Realisasi kunjungan (*check-in/check-out*, validasi koordinat GPS/geotagging, durasi kunjungan).
   - Bukti foto (*proof photo*) dan tanda tangan digital (*proof signature*).
2. **Customer & Location Management**:
   - Master data customer, draft customer, kategori pelanggan, dan data hobi.
   - Lokasi customer, sub-lokasi, dan integrasi Google Maps Geocoding / Places.
3. **Product & Recommendation Engine**:
   - Master katalog produk dan bridging product specialist.
   - Estimasi rekomendasi produk per area dan kalkulasi potensi penjualan.
4. **Organizational Hierarchy & Structure**:
   - Manajemen struktur perusahaan bertingkat (*structure*, *structure boss*, *positions*, *cities*, *locations*).
   - Penugasan atasan-bawahan (*superior-subordinate relations*) untuk kontrol visibilitas data.
5. **Approval Workflow**:
   - Multi-tier approval untuk rencana kunjungan dan penyesuaian data.
6. **Reporting & Logging**:
   - Rekapitulasi laporan realisasi kunjungan (*visit flow report*).
   - Audit trail integrasi API dan logging performa request.

---

## 📁 Directory Structure

```plaintext
visit-flow-go/
├── app/                  # Inisialisasi database dan router Gin terpusat
├── auth/                 # Middleware JWT parser dan wrapper autentikasi
├── configuration/        # Loader konfigurasi Viper (.env)
├── controller/           # Gin HTTP handler (parsing request & response formatting)
├── helper/               # Helper utilities, query filter builder, upload file, FCM
├── html_template/        # Template HTML untuk rendering dokumen / export
├── model/
│   ├── domain/           # GORM domain models & entitas database
│   └── web/              # Request & Response DTOs
├── repository/           # Repository interface dan implementasi GORM MySQL
├── route/                # Definisi route per domain dan dependency wiring
├── service/              # Business logic, validasi, dan transaksi
├── test/                 # Unit tests & repository mocks
├── visit-app-diagram/    # Mermaid ERD & arsitektur sistem
├── Dockerfile            # Multi-stage production build
├── docker-compose.yml    # Docker compose untuk deployment kontainer
├── Makefile              # Shortcut build, test, lint, dan coverage
└── main.go               # Application entrypoint
```

---

## 🔌 API Endpoints Catalog

The following is the complete catalog of REST API endpoints provided by this service:

### Approvals (`route/approval_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/approvals` | Get list of Approvals (filter & pagination) |

### Area Recommendation Estimations (`route/area_recomendation_estimation_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/area-recomendation-estimations` | Get list of Area Recommendation Estimations (filter & pagination) |
| `GET` | `/area-recomendation-estimations/:id` | Get details of Area Recommendation Estimations by parameter |
| `POST` | `/area-recomendation-estimations` | Create new Area Recommendation Estimations |
| `PUT` | `/area-recomendation-estimations/:id` | Update Area Recommendation Estimations |
| `GET` | `/area-recomendation-estimations/subordinates` | Get list of Area Recommendation Estimations (filter & pagination) |
| `POST` | `/area-recomendation-estimations/process/:period` | Proses kalkulasi / background processing data Area Recommendation Estimations |

### Areas (`route/areas_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/areas/:id` | Delete Areas |
| `GET` | `/areas` | Get list of Areas (filter & pagination) |
| `GET` | `/areas/:id` | Get details of Areas by parameter |
| `POST` | `/areas` | Create new Areas |
| `PUT` | `/areas/:id` | Update Areas |

### Bridging Product Specialists (`route/bridging_product_specialist_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/bridging-product-specialists` | Get list of Bridging Product Specialists (filter & pagination) |
| `GET` | `/bridging-product-specialists/:id` | Get details of Bridging Product Specialists by parameter |

### Call Targets (`route/call_target_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/call-target/process/:period` | Proses kalkulasi / background processing data Call Targets |

### Companies (`route/company_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/companies/:id` | Delete Companies |
| `GET` | `/companies` | Get list of Companies (filter & pagination) |
| `GET` | `/companies/:id` | Get details of Companies by parameter |
| `POST` | `/companies` | Create new Companies |
| `PUT` | `/companies/:id` | Update Companies |

### Configurations & Target Rules (`route/config_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/configs/:id` | Delete Configurations & Target Rules |
| `GET` | `/configs` | Get list of Configurations & Target Rules (filter & pagination) |
| `GET` | `/configs/no-auth` | Get list of Configurations & Target Rules (filter & pagination) |
| `GET` | `/configs/:id` | Get details of Configurations & Target Rules by parameter |
| `POST` | `/configs` | Create new Configurations & Target Rules |
| `PUT` | `/configs/:id` | Update Configurations & Target Rules |

### Customer Categories (`route/customer_category_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/customer-categories/:id` | Delete Customer Categories |
| `GET` | `/customer-categories` | Get list of Customer Categories (filter & pagination) |
| `GET` | `/customer-categories/:id` | Get details of Customer Categories by parameter |
| `POST` | `/customer-categories` | Create new Customer Categories |
| `PUT` | `/customer-categories/:id` | Update Customer Categories |

### Customer Category Mappings (`route/customer_customer_category_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/customer-customer-categories/:id` | Delete Customer Category Mappings |
| `GET` | `/customer-customer-categories` | Get list of Customer Category Mappings (filter & pagination) |
| `GET` | `/customer-customer-categories/:id` | Get details of Customer Category Mappings by parameter |
| `POST` | `/customer-customer-categories` | Create new Customer Category Mappings |
| `PUT` | `/customer-customer-categories/:id` | Update Customer Category Mappings |

### Customer Drafts (`route/customer_draft_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/customers-draft` | Get list of Customer Drafts (filter & pagination) |
| `POST` | `/customers-draft` | Create new Customer Drafts |
| `PUT` | `/customers-draft/approve/:id/:updatedById` | Approve Customer Draft record |
| `PUT` | `/customers-draft/reject/:id/:updatedById` | Penolakan (rejection) Customer Drafts |

### Customer Hobbies (`route/customer_hobby_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/customer-hobbys/:id` | Delete Customer Hobbies |
| `GET` | `/customer-hobbys` | Get list of Customer Hobbies (filter & pagination) |
| `POST` | `/customer-hobbys` | Create new Customer Hobbies |

### Customer Locations & Geotagging (`route/customer_location_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/customer-locations/:id` | Delete Customer Locations & Geotagging |
| `GET` | `/customer-locations` | Get list of Customer Locations & Geotagging (filter & pagination) |
| `GET` | `/customer-locations/:id` | Get details of Customer Locations & Geotagging by parameter |
| `GET` | `/customer-locations-filter-visit/:customerID-locationID` | Get details of Customer Locations & Geotagging by parameter |
| `POST` | `/customer-locations` | Create new Customer Locations & Geotagging |
| `PUT` | `/customer-locations/:id` | Update Customer Locations & Geotagging |
| `GET` | `/customer-location-joins/:customer-id` | Get details of Customer Locations & Geotagging by parameter |
| `GET` | `/location-joins/:location-id` | Get details of Customer Locations & Geotagging by parameter |
| `GET` | `/customer-location-join-calls/:name` | Get details of Customer Locations & Geotagging by parameter |
| `PUT` | `/customer-update-status-approves/:customer-id/:location-id` | Approve Customer Location & Geotagging status |
| `PUT` | `/customer-update-status-rejects/:customer-id/:location-id` | Penolakan (rejection) Customer Locations & Geotagging |
| `PUT` | `/customer-update-status-non-actives/:customer-id/:location-id` | Non-aktifkan alokasi kuota cuti pada tahun tertentu |
| `GET` | `/customer-locations-join-customer-and-location` | Get list of Customer Locations & Geotagging (filter & pagination) |
| `GET` | `/customer-locations-filter-status/:status` | Get details of Customer Locations & Geotagging by parameter |
| `GET` | `/customer-locations-join-all` | Get list of Customer Locations & Geotagging (filter & pagination) |

### Customers Master & Profiling (`route/customer_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/customers/:id` | Delete Customers Master & Profiling |
| `GET` | `/customers` | Get list of Customers Master & Profiling (filter & pagination) |
| `GET` | `/customers/:id` | Get details of Customers Master & Profiling by parameter |
| `POST` | `/customers` | Create new Customers Master & Profiling |
| `PUT` | `/customers/:id` | Update Customers Master & Profiling |
| `POST` | `/customers/:category-id/customer-process` | Proses kalkulasi / background processing data Customers Master & Profiling |
| `PUT` | `/customers/:id/:customer-category-id/edit-profile-customers` | Update Customers Master & Profiling |
| `GET` | `/customer/join-city-data` | Get list of Customers Master & Profiling (filter & pagination) |
| `PUT` | `/customers/:id/approve` | Approve Customer Master & Profiling |
| `PUT` | `/customers/:id/reset-city` | Update Customers Master & Profiling |
| `PUT` | `/customers/dynamic-update/:id` | Update Customers Master & Profiling |
| `POST` | `/customers/cluster/process/:period` | Proses kalkulasi / background processing data Customers Master & Profiling |
| `GET` | `/customers/cluster/history` | Get list of Customers Master & Profiling (filter & pagination) |

### Dashboard Promotions (`route/dashboard_promotion_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/dashboard-promotions/table` | Get list of Dashboard Promotions (filter & pagination) |
| `POST` | `/dashboard-promotions/process/:period` | Proses kalkulasi / background processing data Dashboard Promotions |

### File Management & Storage (`route/file_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/file/location/:file` | Get details of File Management & Storage by parameter |
| `GET` | `/file/customer/:file` | Get details of File Management & Storage by parameter |
| `GET` | `/file/ktp/:file` | Get details of File Management & Storage by parameter |
| `GET` | `/file/name_card/:file` | Get details of File Management & Storage by parameter |
| `GET` | `file/location_group/:file` | Get details of File Management & Storage by parameter |
| `GET` | `file/product/:file` | Get details of File Management & Storage by parameter |
| `DELETE` | `file/older-than-6-months` | Delete File Management & Storage |

### Google Maps & Places Geocoding (`route/google_maps_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/google-maps/places/autocomplete` | Pencarian autocomplete tempat / alamat via Google Places API |
| `GET` | `/google-maps/places/details` | Get place details and coordinates from Google Places API |
| `GET` | `/google-maps/geocode/reverse` | Reverse geocoding (koordinat lat/long ke alamat lengkap) |
| `GET` | `/google-maps/geocode` | Geocoding (nama alamat / gedung ke koordinat lat/long) |

### HTML Document Export Services (`route/html_service_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/html-services` | Get list of HTML Document Export Services (filter & pagination) |
| `POST` | `/html-services/incentive/:period` | Create new HTML Document Export Services |
| `POST` | `/html-services/customer/:period` | Create new HTML Document Export Services |
| `POST` | `/html-services/customer-location/:period` | Create new HTML Document Export Services |
| `POST` | `/html-services/customer-family/:period` | Create new HTML Document Export Services |
| `POST` | `/incentive-recommendation/process/:period` | Proses kalkulasi / background processing data HTML Document Export Services |

### Location Categories (`route/location_categories_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/location-categories/:id` | Delete Location Categories |
| `GET` | `/location-categories` | Get list of Location Categories (filter & pagination) |
| `GET` | `/location-categories/:id` | Get details of Location Categories by parameter |
| `POST` | `/location-categories` | Create new Location Categories |
| `PUT` | `/location-categories/:id` | Update Location Categories |

### Location Groups (`route/location_group_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/location-groups/:id` | Delete Location Groups |
| `GET` | `/location-groups` | Get list of Location Groups (filter & pagination) |
| `GET` | `/location-groups/:id` | Get details of Location Groups by parameter |
| `POST` | `/location-groups` | Create new Location Groups |
| `PUT` | `/location-groups/:id` | Update Location Groups |

### Location Category Mappings (`route/location_location_categories_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/location-location-categories/:id` | Delete Location Category Mappings |
| `GET` | `/location-location-categories` | Get list of Location Category Mappings (filter & pagination) |
| `GET` | `/location-location-categories/:id` | Get details of Location Category Mappings by parameter |
| `POST` | `/location-location-categories` | Create new Location Category Mappings |
| `PUT` | `/location-location-categories/:id` | Update Location Category Mappings |
| `GET` | `/location-location-categories-joins/:location-id` | Get details of Location Category Mappings by parameter |

### Locations Master (`route/location_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/locations/:id` | Delete Locations Master |
| `GET` | `/locations` | Get list of Locations Master (filter & pagination) |
| `GET` | `/locations/:id` | Get details of Locations Master by parameter |
| `POST` | `/locations` | Create new Locations Master |
| `PUT` | `/locations/:id` | Update Locations Master |
| `POST` | `/locations/:l-category-id/location-process` | Proses kalkulasi / background processing data Locations Master |
| `PUT` | `/locations/:id/:location-category-id/edit-locations` | Update Locations Master |
| `GET` | `/locations/join-city-data` | Get list of Locations Master (filter & pagination) |
| `PUT` | `/locations/:id/update-no-location-by-company` | Update Locations Master |
| `PUT` | `/locations/:id/approve` | Approve Location Master record |
| `PUT` | `/locations/:id/reset-city` | Update Locations Master |

### Location Sub-units (`route/location_subs_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/location-subs/:id` | Delete Location Sub-units |
| `GET` | `/location-subs` | Get list of Location Sub-units (filter & pagination) |
| `GET` | `/location-subs/:id` | Get details of Location Sub-units by parameter |
| `POST` | `/location-subs` | Create new Location Sub-units |
| `PUT` | `/location-subs/:id` | Update Location Sub-units |

### Visit Background Data Processing (`route/process_data_visit.go`)

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/visit/process` | Proses background kalkulasi dan sinkronisasi kunjungan |

### Product Recommendation Estimations (`route/product_recommendation_estimation_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/product-recommendation-estimations` | Get list of Product Recommendation Estimations (filter & pagination) |
| `GET` | `/product-recommendation-estimations/:id` | Get details of Product Recommendation Estimations by parameter |
| `PUT` | `/product-recommendation-estimations/:id` | Update Product Recommendation Estimations |

### Products Catalog (`route/product_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/products/:id` | Delete Products Catalog |
| `GET` | `/products` | Get list of Products Catalog (filter & pagination) |
| `GET` | `/products/survey` | Get list of Products Catalog (filter & pagination) |
| `GET` | `/products/recommendation-estimations` | Get list of Products Catalog (filter & pagination) |
| `GET` | `/products/:id` | Get details of Products Catalog by parameter |
| `POST` | `/products` | Create new Products Catalog |
| `PUT` | `/products/:id` | Update Products Catalog |
| `GET` | `/products/photo/:file_name` | Mengambil / mengunduh file foto bukti Products Catalog |

### Social Media Verification (`route/social_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/check-social-media` | Get list of Social Media Verification (filter & pagination) |

### Structure Boss & Superior Hierarchy (`route/structure_boss_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/structure-boss/:id` | Delete Structure Boss & Superior Hierarchy |
| `GET` | `/structure-boss` | Get list of Structure Boss & Superior Hierarchy (filter & pagination) |
| `GET` | `/structure-boss/:id` | Get details of Structure Boss & Superior Hierarchy by parameter |
| `POST` | `/structure-boss` | Create new Structure Boss & Superior Hierarchy |
| `PUT` | `/structure-boss/:id` | Update Structure Boss & Superior Hierarchy |

### Structure City Assignments (`route/structure_cities.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/structure-cities/:id` | Delete Structure City Assignments |
| `GET` | `/structure-cities` | Get list of Structure City Assignments (filter & pagination) |
| `GET` | `/structure-cities/:id` | Get details of Structure City Assignments by parameter |
| `POST` | `/structure-cities` | Create new Structure City Assignments |
| `PUT` | `/structure-cities/:id` | Update Structure City Assignments |
| `PUT` | `/structure-cities/:id/approved` | Approve Structure City Assignment |
| `PUT` | `/structure-cities/:id/rejected` | Penolakan (rejection) Structure City Assignments |

### Structure Location Mappings (`route/structure_location_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/structure-locations/:location_id` | Delete Structure Location Mappings |
| `GET` | `/structure-locations` | Get list of Structure Location Mappings (filter & pagination) |
| `GET` | `/structure-locations/:id` | Get details of Structure Location Mappings by parameter |
| `POST` | `/structure-locations` | Create new Structure Location Mappings |
| `PUT` | `/structure-locations/:id` | Update Structure Location Mappings |

### Structure Positions & Levels (`route/structure_position_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/structure-positions/:id` | Delete Structure Positions & Levels |
| `GET` | `/structure-positions` | Get list of Structure Positions & Levels (filter & pagination) |
| `GET` | `/structure-positions/:id` | Get details of Structure Positions & Levels by parameter |
| `POST` | `/structure-positions` | Create new Structure Positions & Levels |
| `PUT` | `/structure-positions/:id` | Update Structure Positions & Levels |

### Organizational Structures (`route/structure_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/structures/:id` | Delete Organizational Structures |
| `GET` | `/structures` | Get list of Organizational Structures (filter & pagination) |
| `GET` | `/structures/:id` | Get details of Organizational Structures by parameter |
| `POST` | `/structures` | Create new Organizational Structures |
| `PUT` | `/structures/:id` | Update Organizational Structures |
| `GET` | `/structures/join-visit` | Get list of Organizational Structures (filter & pagination) |
| `PUT` | `/structures/duplicate-current-period` | Update Organizational Structures |
| `POST` | `/structures/boss/process/:period` | Proses kalkulasi / background processing data Organizational Structures |

### Visit API Logs (`route/visit_api_log_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/visit-api-logs/:id` | Delete Visit API Logs |
| `GET` | `/visit-api-logs` | Get list of Visit API Logs (filter & pagination) |
| `GET` | `/visit-api-logs/:id` | Get details of Visit API Logs by parameter |
| `POST` | `/visit-api-logs` | Create new Visit API Logs |
| `PUT` | `/visit-api-logs/:id` | Update Visit API Logs |

### Visit APIs Integration (`route/visit_api_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/visit-apis/:id` | Delete Visit APIs Integration |
| `GET` | `/visit-apis` | Get list of Visit APIs Integration (filter & pagination) |
| `GET` | `/visit-apis/:id` | Get details of Visit APIs Integration by parameter |
| `POST` | `/visit-apis` | Create new Visit APIs Integration |
| `PUT` | `/visit-apis/:id` | Update Visit APIs Integration |

### Visit Customers & Target Planning (`route/visit_customer_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/visit-customers/:id` | Delete Visit Customers & Target Planning |
| `GET` | `/visit-customers` | Get list of Visit Customers & Target Planning (filter & pagination) |
| `GET` | `/visit-customers/reports/coverage` | Get list of Visit Customers & Target Planning (filter & pagination) |
| `POST` | `/visit-customers/notifications/self` | Create new Visit Customers & Target Planning |
| `POST` | `/visit-customers/notifications/boss` | Create new Visit Customers & Target Planning |
| `GET` | `/visit-customers/:id` | Get details of Visit Customers & Target Planning by parameter |
| `POST` | `/visit-customers` | Create new Visit Customers & Target Planning |
| `PUT` | `/visit-customers/:id/approved` | Approve Visit Customer & Target Plan |
| `PUT` | `/visit-customers/:id/delete-approved` | Approve Visit Customer & Target Plan |
| `PUT` | `/visit-customers/:id/rejected` | Penolakan (rejection) Visit Customers & Target Planning |
| `PUT` | `/visit-customers/:id` | Update Visit Customers & Target Planning |

### Visit Flow Reports & Daily Calls (`route/visit_flow_report_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/visits/daily-calls` | Get list of Visit Flow Reports & Daily Calls (filter & pagination) |
| `GET` | `/visits/daily-call/totals` | Get aggregate total summary of Visit Flow Reports & Daily Calls |
| `GET` | `/visits/call-details` | Get detailed breakdown of Visit Flow Reports & Daily Calls |
| `GET` | `/visits/customer-lists` | Get list of Visit Flow Reports & Daily Calls (filter & pagination) |
| `POST` | `/process/visits/daily-calls/:period` | Proses kalkulasi / background processing data Visit Flow Reports & Daily Calls |
| `POST` | `/process/visits/call-details/:period` | Process and retrieve detailed Visit Flow Reports & Daily Calls for period |
| `POST` | `/process/visits/customer-lists/:period` | Proses kalkulasi / background processing data Visit Flow Reports & Daily Calls |

### Visit Joint Members (`route/visit_member_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/visit-members/:id` | Delete Visit Joint Members |
| `GET` | `/visit-members` | Get list of Visit Joint Members (filter & pagination) |
| `GET` | `/visit-member/:id` | Get details of Visit Joint Members by parameter |
| `GET` | `/visit-members/:visit_id` | Get details of Visit Joint Members by parameter |
| `POST` | `/visit-members` | Create new Visit Joint Members |
| `PUT` | `/visit-members/:id` | Update Visit Joint Members |

### Visit Detailing Products (`route/visit_product_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/visit-products/:id` | Delete Visit Detailing Products |
| `GET` | `/visit-products` | Get list of Visit Detailing Products (filter & pagination) |
| `GET` | `/visit-products/by-estimation` | Get list of Visit Detailing Products (filter & pagination) |
| `GET` | `/visit-products/:id` | Get details of Visit Detailing Products by parameter |
| `GET` | `/visit-products-visit` | Get list of Visit Detailing Products (filter & pagination) |
| `POST` | `/visit-products` | Create new Visit Detailing Products |
| `PUT` | `/visit-products/:id` | Update Visit Detailing Products |

### Visits Execution & Realization (`route/visit_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/visits/:id` | Delete (soft delete) visit record |
| `GET` | `/visits` | Get visit records list (filter, pagination, sorting) |
| `GET` | `/visit-histories` | Get list of Visits Execution & Realization (filter & pagination) |
| `GET` | `/visits/:id` | Detail informasi data kunjungan |
| `GET` | `/visits/last-checkout/by-customer/:customerID` | Get latest checkout record for specified customer |
| `POST` | `/visits` | Create new scheduled visit plan |
| `PUT` | `/visits/:id` | Update visit schedule / planned visit details |
| `PUT` | `/visits/:id/approved` | Approve scheduled visit plan |
| `PUT` | `/visits/:id/check-in` | Check-in kunjungan lapangan dengan koordinat GPS & validasi radius |
| `PUT` | `/visits/:id/check-out` | Check-out kunjungan lapangan dengan bukti foto & tanda tangan |
| `PUT` | `/visits/:id/closed` | Verifikasi & penutupan (closing) kunjungan oleh atasan |
| `PUT` | `/visits/:id/plan-rejected` | Penolakan rencana kunjungan |
| `PUT` | `/visits/:id/realization-rejected` | Penolakan realisasi kunjungan |
| `GET` | `/visits/join-data` | Get comprehensive relational data for visit, customer, and products |
| `GET` | `/visit-periods/:period/filter` | Get details of Visits Execution & Realization by parameter |
| `PUT` | `/visits/:id/schedule-datetime` | Update Visits Execution & Realization |
| `GET` | `/visits/proof-photo/:file_name` | Mengambil / mengunduh file foto bukti Visits Execution & Realization |
| `GET` | `/visits/proof-photo-base64/:file_name` | Mengambil / mengunduh file foto bukti Visits Execution & Realization |
| `GET` | `/visit/:id/proof-signature` | Mengambil / mengunduh file tanda tangan Visits Execution & Realization |
| `GET` | `/policies` | Get list of Visits Execution & Realization (filter & pagination) |
| `GET` | `/visits/subordinates` | Get subordinate team members' visit records |
| `GET` | `/visits-achievement` | Get visit target achievement summary recap |
| `GET` | `/visit-outlet-photo/:location_id/:customer_id/proof-photo` | Mengambil / mengunduh file foto bukti Visits Execution & Realization |
| `GET` | `/visits/completeness-reports` | Laporan kelengkapan data kunjungan |
| `POST` | `/process/visits/completeness-reports/:period` | Proses agregasi batch kelengkapan data kunjungan per periode |

### Product Survey Views (`route/vw_product_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/survey/product/filter` | Get list of Product Survey Views (filter & pagination) |

---


## ⚙️ Environment Configuration (`.env`)

Konfigurasi dimuat dari file `configuration/.env`. Buat atau sesuaikan file tersebut:

```env
# Application
PORT=8080
API_HOST=http://localhost:8080

# Database Connection (MySQL)
HOST_DB=127.0.0.1
PORT_DB=3306
USER_DB=root
PASSWORD_DB=secret_password
DATABASE_DB=visitflow_db

# Security & JWT
ACCESS_SECRET=your_jwt_access_secret_key
REFRESH_SECRET=your_jwt_refresh_secret_key

# Observability (OpenTelemetry)
OTEL_EXPORTER_OTLP_ENDPOINT=localhost:4317
INSECURE_MODE=true
```

---

## 🛠 Getting Started (Local Development)

### Prerequisites
- **Go**: `1.23` atau lebih baru
- **MySQL**: `8.0` atau MariaDB setara
- **Make**: (opsional, untuk menjalankan Makefile targets)

### Steps to Run
1. **Clone repository dan masuk ke direktori:**
   ```bash
   git clone https://gitlab.com/VNEU/visit-flow-go.git
   cd visit-flow-go
   ```

2. **Unduh dependencies:**
   ```bash
   go mod download
   ```

3. **Siapkan konfigurasi environment:**
   ```bash
   cp configuration/.env.example configuration/.env # atau sesuaikan configuration/.env
   ```

4. **Run the application:**
   ```bash
   make run
   # atau
   go run main.go
   ```

The application will run on `http://localhost:8080`.

---

## 🧪 Testing & Quality Gates

Proyek ini dilengkapi dengan unit test menyeluruh, repository mock suites, dan validasi automated coverage gate:

### Coverage Status

| Metric | Actual Value | CI Gate Threshold | Status |
|---|---|---|---|
| **Total Statement Coverage** | **94.7%** | `>= 70.0%` (Target: `>= 90.0%`) |  **PASSED** |

### Coverage Breakdown per Layer

| Layer / Package | Coverage | Description |
|---|---|---|
| `route/` | **100.0%** | Dependency injection wiring & endpoint routing |
| `model/domain/` | **99.6%** | GORM entity hooks, custom types, dan domain models |
| `controller/` | **99.2%** | HTTP request binding, status codes, dan response DTOs |
| `repository/` | **97.8%** | GORM CRUD operations, transactional boundary & DB queries |
| `service/` | **95.8%** | Business rules, hierarchy filtering, dan logic validation |
| `helper/` | **92.9%** | Utilities, query filter builder, upload handler |
| `auth/` | **91.0%** | JWT verification, token parser, middleware context |

### Running Tests

```bash
# Run all unit tests
make test

# Run tests with coverage report
make cover

# Validate coverage quality gate (Minimum 70% statement coverage)
make check-cov

# Format source code
make fmt

# Static analysis & linting
make lint       # Memerlukan golangci-lint
make static     # Memerlukan staticcheck
make critic     # Memerlukan gocritic

# Run all quality gates (Static Analysis, Gocritic & Coverage Check)
make check-all
```

---

## 🐳 Docker & Deployment

### Build Binary
```bash
make build
# Binary output saved to bin/visit-flow-go
```

### Build Docker Image
```bash
docker build -t visit-flow-go:latest .
```

### Deployment with Docker Compose
```bash
docker-compose up -d
```
Service akan terhubung ke Docker network eksternal `visitflow` dan port kontainer di-map ke `0.0.0.0:33033:8080`.
