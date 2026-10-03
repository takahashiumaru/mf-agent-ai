# Visit Flow - API Gateway & Identity Service (`visit-flow-api-gateway`)

> **AI agents:** Start with [AGENTS.md](AGENTS.md), then [.agent/INDEX.md](.agent/INDEX.md). Current source/runtime evidence and workspace database rules govern task decisions.


[![Go Version](https://img.shields.io/badge/Go-1.23-00ADD8?style=flat&logo=go)](https://golang.org)
[![Coverage](https://img.shields.io/badge/Coverage-95.3%25-brightgreen?style=flat&logo=go)](test/)
[![KrakenD](https://img.shields.io/badge/Gateway-KrakenD%20v1.2.0-188838?style=flat)](https://www.krakend.io)
[![Gin Framework](https://img.shields.io/badge/Gin-v1.9.1-008ECF?style=flat&logo=go)](https://gin-gonic.com)
[![GORM](https://img.shields.io/badge/ORM-GORM%20v1.25.2-blue?style=flat)](https://gorm.io)
[![Database](https://img.shields.io/badge/Database-MySQL-4479A1?style=flat&logo=mysql)](https://www.mysql.com)
[![JWT](https://img.shields.io/badge/Auth-JWT%20HMAC-black?style=flat&logo=jsonwebtokens)](https://jwt.io)

Primary Unified API Gateway and Identity & Access Management (IAM) service for the entire **Visit Flow** microservice ecosystem. This service combines the high-performance **KrakenD** reverse-proxy engine with a **Gin/GORM** identity and authentication backend.

---

## 📑 Table of Contents

- [Architecture & Engineering Maturity Audit](#-architecture--engineering-maturity-audit)
- [Dual Runtime Roles](#-dual-runtime-roles)
- [System Architecture](#-system-architecture)
- [Key Features](#-key-features)
- [Directory Structure](#-directory-structure)
- [API Endpoints Catalog](#-api-endpoints-catalog)
- [Environment Configuration (`.env`) & KrakenD](#-environment-configuration-env--krakend)
- [Getting Started (Local Development)](#-getting-started-local-development)
- [Testing & Quality Gates](#-testing--quality-gates)
- [Docker & Deployment](#-docker--deployment)

---

## 📊 Architecture & Engineering Maturity Audit

Evaluation of architecture, clean code, and production readiness for `visit-flow-api-gateway`:

```
┌─────────────────────────┬─────────────────────────┬─────────────────────────┬─────────────────────────┐
│   OVERALL MATURITY      │   MATURE PILLARS (✅)   │   NEEDS ACTION (⚠️)     │   TEST SUITE COVERAGE   │
│       7.32 / 10         │        6 / 11           │        5 / 11           │         > 95%           │
│   Grade: B+ (Production)│     (54.5% Siap)        │     (Gateway SPOF Risk) │   Auth & Token Test PASS│
└─────────────────────────┴─────────────────────────┴─────────────────────────┴─────────────────────────┘
```

### 🏆 Mature & Production-Ready Pillars (✅ Average 8.0 / 10)

| No | Maturity Pillar | Score | Visual Meter | Status | Highlights & Achievements |
|:---:|:---|:---:|:---|:---:|:---|
| **01** | **Clean Code** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Completed. Remaining debug logs (`fmt.Println`) cleaned; controller and service code sanitized; unused imports removed. |
| **02** | **Package Design** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Completed. Separation of concerns between dual runtime roles (KrakenD proxy on port `9000` and Gin IAM on port `8090`) is cleanly isolated. |
| **03** | **SOLID / DIP** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Completed. All IAM services (Auth, User, Role, UserRole) implement interface-based repository dependencies via constructor injection (DIP & ISP satisfied). |
| **05** | **Testing** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Excellent. High coverage (>95%); test suites for token refresh, user auth, and role management run isolated and pass 100%. |
| **07** | **Observability** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Good. SigNoz OpenTelemetry distributed tracing integrated across route and identity service layers. |
| **10** | **CI / CD** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Good. Automated `.gitlab-ci.yml` pipeline, automated test execution, and multi-stage Docker builds run reliably. |

### ⚠️ Pillars Requiring Action / Tech Debt (⚠️ Average 6.5 / 10)

| No | Maturity Pillar | Score | Visual Meter | Status | Issues & Risk Analysis | Priority |
|:---:|:---|:---:|:---|:---:|:---|:---:|
| **06** | **Concurrency Safety** | **5.5** / 10 | `█████░░░░░` 55% | `⚠️ Pending` | Potential data race in `helper/block_acces.go` where `blockList` map is accessed without mutex synchronization under concurrent requests. | `🚨 P0` |
| **04** | **Architecture** | **6.5** / 10 | `██████▌░░░` 65% | `⚠️ Pending` | Acts as API Gateway & IAM; however, the gateway's `repository` package is directly imported by `visit-flow-go` instead of communicating over HTTP/gRPC. | `⚡ P1` |
| **08** | **Performance** | **7.0** / 10 | `███████░░░` 70% | `⚠️ Moderate` | KrakenD engine is ultra-fast; bottleneck lies in Gin MySQL authentication during high-volume login spikes (no Redis token caching yet). | `⚡ P1` |
| **09** | **Security** | **7.0** / 10 | `███████░░░` 70% | `⚠️ Pending` | Bcrypt hashing and JWT tokens installed; however, brute-force IP blocking is local in-memory (not synchronized across pods). | `⚡ P1` |
| **11** | **Production Reliability** | **6.5** / 10 | `██████▌░░░` 65% | `⚠️ Partial` | Acts as Single Point of Failure (SPOF) for ingress traffic; gateway resilience lacks automated failover or distributed rate limiting. | `📌 P2` |

### 🎯 Strategic Remediation Roadmap

```
[ P0 CRITICAL ] ──► Fix Concurrency Data Race in blockList
                    ├─ Add sync.RWMutex protection to helper/block_acces.go
                    └─ Prevent fatal concurrent map read/write runtime panics

[ P1 HIGH ]     ──► Provide Internal REST/gRPC IAM Endpoints
                    ├─ Eliminate direct cross-repo Go import from visit-flow-go
                ──► Distributed Brute-Force & Rate Limiting (Redis)
                    ├─ Synchronize IP blacklists across multi-pod replicas
                ──► Redis Token & Session Caching
                    └─ Reduce MySQL query contention during peak login surges

[ P2 MEDIUM ]   ──► High Availability & Failover Resilience
                    ├─ Implement upstream circuit breaking and failover policies
                    └─ Validate multi-replica gateway load balancing
```

---

## 🎭 Dual Runtime Roles

This service runs **two server listeners** within a single application process:

1. **KrakenD API Gateway (Port `9000`)**:
   - Serves as the Single Entry Point for Web & Mobile applications.
   - Routes client requests to corresponding upstream microservices configured in `configuration.json`.
   - Manages authorization token forwarding (`Authorization` Bearer header), CORS headers, and query string manipulation.
2. **Gin Identity & IAM Service (Port `8090`)**:
   - Menyediakan API manajemen pengguna (*users*), role, hak akses (*permissions*), dan struktur hierarki.
   - Menangani login, registrasi sesi, penerbitan *Access Token* & *Refresh Token*, dan pencabutan sesi (*session revocation*).
   - Mengelola upload dan penyajian file statis lokal (avatar, berkas bukti, dokumen).

---

## 🏛 System Architecture

```
                                  [ Web App / Mobile Client ]
                                               │
                       ┌───────────────────────┴───────────────────────┐
                       │                                               │
                Port 9000 (KrakenD)                             Port 8090 (Gin IAM)
                       │                                               │
       ┌───────────────┼───────────────┐                  [ Auth / Identity Controller ]
       │               │               │                               │
       ▼               ▼               ▼                               ▼
[ VISIT-FLOW ]  [ PRESENCE ]    [ PAYROLL ]                  [ User / Role Service ]
 (Port 8080)     (Port 8080)     (Port 8080)                           │
                                                                       ▼
                                                             [ GORM / MySQL Database ]
```

---

## 🚀 Key Features

1. **API Gateway & Routing (KrakenD)**:
   - Intelligent reverse proxy to all downstream microservices:
     - `VISIT-FLOW`: Modul kunjungan, outlet, produk, approval, rekomendasi.
     - `VISIT-FLOW-PRESENCE`: Absensi, kantor, jadwal kerja, kuota cuti, koreksi.
     - `VISIT-FLOW-PAYROLL`: Arsip slip gaji, validasi OTP Telegram, integrasi email.
     - `VISIT-FLOW-SURVEY-LOCATION`: Outlet surveys, evaluation questions, distributors.
2. **Authentication & Token Lifecycle**:
   - Login dengan proteksi hash password `bcrypt`.
   - JWT issuance (short-lived Access Tokens and registered Refresh Tokens).
   - Refresh token otomatis dengan validasi sesi database.
   - Single sign-on and active session tracking (Device Info, IP, User-Agent).
3. **Role-Based Access Control (RBAC)**:
   - Manajemen roles dan granular permissions.
   - Penugasan user ke multiple roles dan unit struktur organisasi.
4. **File Storage & Media Delivery**:
   - Upload dokumen, foto profil (avatar), foto bukti kunjungan, dan tanda tangan.
   - Endpoint streaming download file terproteksi.

---

## 📁 Directory Structure

```plaintext
visit-flow-api-gateway/
├── auth/                 # JWT helper, claims parser, dan wrapper autentikasi
├── config/               # Inisialisasi koneksi database GORM MySQL
├── configuration/        # Loader konfigurasi .env Viper
├── configuration.json    # Sumber konfigurasi routing KrakenD Gateway
├── controller/           # Handler HTTP Gin (Users, Roles, Permissions, Files, Auth)
├── exception/            # Panic-to-JSON error handling middleware
├── helper/               # Helper utilities, transactions, FCM & mail notification
├── model/
│   ├── domain/           # Entitas GORM domain & database models
│   └── web/              # Request & Response DTOs
├── repository/           # GORM repository interfaces & implementations
├── route/                # Definisi route Gin & dependency wiring
├── service/              # Business logic autentikasi, transaksi, dan validasi
├── test/                 # Suite unit test & mock coverage
├── Dockerfile            # Container build recipe
├── docker-compose.yml    # Konfigurasi container service
├── Makefile              # Command build, test, lint, dan coverage
└── main.go               # Entrypoint (KrakenD + Gin Server)
```

---

## 🔌 API Endpoints Catalog

The following is the complete catalog of REST API endpoints provided by this service:

### File Delivery & Slow Endpoints (`route/file.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/file/user/:file` | Get File Delivery & Slow Endpoints details by parameter |
| `GET` | `/file/slow-endpoints` | Get File Delivery & Slow Endpoints list (filter & pagination) |

### Role Permissions (`route/role_menu_permission_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/roles/:role-id/permissions/:permission-id` | Delete Role Permissions record |
| `POST` | `/roles/:role-id/permissions/:permission-id` | Create new Role Permissions record |
| `GET` | `/roles/:role-id/permissions` | Get Role Permissions details by parameter |
| `GET` | `/roles/:role-id/permissions/:permission-id` | Get Role Permissions details by parameter |

### Roles Master (`route/role_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/roles/:role-id` | Delete Roles Master record |
| `GET` | `/roles` | Get Roles Master list (filter & pagination) |
| `GET` | `/roles/:role-id` | Get Roles Master details by parameter |
| `POST` | `/roles` | Create new Roles Master record |
| `PUT` | `/roles/:role-id` | Update Roles Master record |

### User Roles & Access Reports (`route/user_role_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/user-roles/:user-id/:role-id` | Delete User Roles & Access Reports record |
| `GET` | `/roles/:role-id/users` | Get User Roles & Access Reports details by parameter |
| `POST` | `/user-roles/:user-id/:role-id` | Create new User Roles & Access Reports record |
| `GET` | `/user-roles/:user-id` | Get User Roles & Access Reports details by parameter |
| `GET` | `/report-list-user-access` | Get User Roles & Access Reports list (filter & pagination) |

### Users, Authentication & Token Management (`route/users_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/users/:id` | Delete User record |
| `GET` | `/users` | Get Users list (filter & pagination) |
| `GET` | `/users/department` | Get Users list (filter & pagination) |
| `GET` | `/users/:id` | Get User details by parameter |
| `POST` | `/users` | Create new User record |
| `PUT` | `/users/:id` | Update User record |
| `GET` | `/users/no-auth/:id` | Get User details by parameter |
| `PUT` | `/users/no-auth/:id` | Update User record |
| `POST` | `/users/verify-password` | Verify user password |
| `POST` | `/verify-password` | Verify user password |
| `POST` | `/login` | User login authentication & JWT token issuance |
| `PUT` | `/users/change-password` | Change self-account user password |
| `PUT` | `/users/reset-password/:id` | Reset user password by administrator |
| `GET` | `/user/:device-id/check-token` | Validate token active status per device ID |
| `PUT` | `/users/update-access-token` | Update active session access token |
| `POST` | `/users/refresh-token` | Refresh JWT access token using refresh token |

---


## ⚙️ Environment Configuration (`.env`) & KrakenD

Configuration is loaded from `configuration/.env`:

```env
# Gin IAM Server Port
PORT=8090

# Database Connection (MySQL)
HOST_DB=127.0.0.1
PORT_DB=3306
USER_DB=root
PASSWORD_DB=secret_password
DATABASE_DB=visitflow_iam_db

# Security & JWT Secrets
ACCESS_SECRET=your_super_secret_access_key
REFRESH_SECRET=your_super_secret_refresh_key

# External Notifications (Firebase / SMTP)
FIREBASE_CREDENTIALS_FILE=helper/service-account.json
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=no-reply@example.com
SMTP_PASS=secret_smtp_password
```

KrakenD routing is configured via `configuration.json`, which defines the gateway port (`9000`) and the proxy endpoint catalog to upstream microservices.

---

## 🛠 Getting Started (Local Development)

### Prerequisites
- **Go**: `1.23` or newer
- **MySQL**: `8.0` or compatible MariaDB

### Steps to Run
1. **Clone repository:**
   ```bash
   git clone https://gitlab.com/VNEU/visit-flow-api-gateway.git
   cd visit-flow-api-gateway
   ```

2. **Download dependencies:**
   ```bash
   go mod download
   ```

3. **Set up configuration file:**
   ```bash
   cp configuration/.env.example configuration/.env
   ```

4. **Run the application:**
   ```bash
   make run
   # or
   go run main.go
   ```

The service will launch:
- **KrakenD Gateway** on `http://localhost:9000`
- **Gin IAM Service** on `http://localhost:8090`

---

## 🧪 Testing & Quality Gates

This service is comprehensively verified with test suites covering KrakenD integration, JWT middleware, exception handling, and GORM repositories/services:

### Coverage Status

| Metric | Actual Value | CI Gate Threshold | Status |
|---|---|---|---|
| **Total Statement Coverage** | **95.3%** | `>= 70.0%` (Target: `>= 90.0%`) |  **PASSED** |

### Coverage Breakdown per Layer

| Layer / Package | Coverage | Description |
|---|---|---|
| `route/` | **100.0%** | Gin router configuration & dependency mapping |
| `controller/` | **100.0%** | HTTP handlers (Auth, User, Role, Permission, File) |
| `exception/` | **100.0%** | Panic recovery & central error mapping |
| `model/domain/` | **100.0%** | GORM domain persistence entities |
| `repository/` | **99.8%** | Data access layer, user & role queries |
| `service/` | **99.2%** | Business rules, authentication logic & RBAC |
| `auth/` | **97.4%** | JWT claims validator & token generation |
| `configuration/` | **97.4%** | Viper environment configuration loader |
| `helper/` | **92.1%** | Notification utilities, mailer & transactions |
| `config/` | **85.3%** | MySQL database connection bootstrap |

### Running Tests

```bash
# Run all unit tests
make test

# Run tests with coverage
make cover

# Validate coverage quality gate (Minimum 70%)
make check-cov

# Format source code
make fmt

# Linter & static analysis
make lint
make static
make critic

# Run all quality checks
make check-all
```

---

## 🐳 Docker & Deployment

### Build Binary
```bash
make build
# Binary output saved to bin/visit-flow-api-gateway
```

### Build Docker Image
```bash
docker build -t visit-flow-gateway:latest .
```

### Deployment with Docker Compose
```bash
docker-compose up -d
```
The `VISIT-FLOW-GATEWAY` container exposes:
- Port `33055` -> Port `8090` (Gin IAM)
- Port `33555` -> Port `9000` (KrakenD Gateway)
- Volume `/home/DOCKER/VISIT-FLOW/file` -> `/app/file`
- Network: `visitflow`
