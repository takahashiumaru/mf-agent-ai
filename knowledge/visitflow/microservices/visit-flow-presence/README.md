# Visit Flow - Presence & Attendance Microservice (`visit-flow-presence`)

> **AI agents:** Start with [AGENTS.md](AGENTS.md), then [.agent/INDEX.md](.agent/INDEX.md). Current source/runtime evidence and workspace database rules govern task decisions.


[![Go Version](https://img.shields.io/badge/Go-1.23-00ADD8?style=flat&logo=go)](https://golang.org)
[![Coverage](https://img.shields.io/badge/Coverage-97.8%25-brightgreen?style=flat&logo=go)](test/)
[![Gin Framework](https://img.shields.io/badge/Gin-v1.9.1-008ECF?style=flat&logo=go)](https://gin-gonic.com)
[![GORM](https://img.shields.io/badge/ORM-GORM%20v1.25.10-blue?style=flat)](https://gorm.io)
[![Database](https://img.shields.io/badge/Database-MySQL-4479A1?style=flat&logo=mysql)](https://www.mysql.com)
[![OpenTelemetry](https://img.shields.io/badge/Telemetry-OpenTelemetry-F5A800?style=flat&logo=opentelemetry)](https://opentelemetry.io)

Employee attendance and presence management microservice for **Visit Flow**, covering check-in/check-out workflows, office geofence radius validation, work schedule and shift management, leave quotas and request approvals, attendance corrections, and meeting presence records.

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

Evaluation of architecture, clean code, and production readiness for `visit-flow-presence`:

```
┌─────────────────────────┬─────────────────────────┬─────────────────────────┬─────────────────────────┐
│   OVERALL MATURITY      │   MATURE PILLARS (✅)   │   NEEDS ACTION (⚠️)     │   TEST SUITE COVERAGE   │
│       7.45 / 10         │        7 / 11           │        4 / 11           │         > 97%           │
│   Grade: B+ (Production)│     (63.6% Siap)        │     (Mutation in Read)  │   Geofence & DB Mock PASS│
└─────────────────────────┴─────────────────────────┴─────────────────────────┴─────────────────────────┘
```

### 🏆 Mature & Production-Ready Pillars (✅ Average 7.9 / 10)

| No | Maturity Pillar | Score | Visual Meter | Status | Highlights & Achievements |
|:---:|:---|:---:|:---|:---:|:---|
| **05** | **Testing** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Excellent. High coverage (>97%); comprehensive test suites verifying presence check-ins, geofence radius calculation, attendance corrections, and leave requests pass 100%. |
| **01** | **Clean Code** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Completed. Controllers & use cases are clean of debug logging; DTO structures mapped cleanly; geofence validation and haversine radius math isolated. |
| **02** | **Package Design** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Completed. Attendance corrections and leave management separated into cohesive, modular sub-services. |
| **03** | **SOLID / DIP** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Completed. All repositories and clients injected via interface constructors (`PresenceRepository`, `UserRepository`, `OfficeUserRepository`, `PondasiClient`). |
| **07** | **Observability** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Good. SigNoz OpenTelemetry distributed tracing (`goHelper.SignozSpan`) and structured logger active across presence and approval routes. |
| **10** | **CI / CD** | **8.0** / 10 | `████████░░` 80% | `✅ Completed` | Good. Automated `.gitlab-ci.yml` pipeline, automated test execution, and multi-stage Docker builds run reliably. |
| **06** | **Concurrency Safety** | **7.5** / 10 | `███████▌░░` 75% | `✅ Completed` | Good. `RunAsyncNotification` employs `context.WithTimeout(context.Background(), 15*time.Second)` safely preventing Gin context pool recycling. |

### ⚠️ Pillars Requiring Action / Tech Debt (⚠️ Average 6.6 / 10)

| No | Maturity Pillar | Score | Visual Meter | Status | Issues & Risk Analysis | Priority |
|:---:|:---|:---:|:---|:---:|:---|:---:|
| **08** | **Performance** | **6.5** / 10 | `██████▌░░░` 65% | `⚠️ Pending` | Read/Write splitting is active; however, `FindAll` still executes a mutating stored procedure (`CALL updateNameDeptEmpty()`) inside a read transaction. | `🚨 P0` |
| **04** | **Architecture** | **6.5** / 10 | `██████▌░░░` 65% | `⚠️ Pending` | Adopts conventional Layered Architecture; integrates external client (`internal/pondasi`); `*gin.Context` still leaks into business service signatures. | `⚡ P1` |
| **11** | **Production Reliability** | **6.5** / 10 | `██████▌░░░` 65% | `⚠️ Partial` | External HTTP calls (Pondasi client and Firebase notifications) lack circuit breaking and adaptive backoff retries. | `⚡ P1` |
| **09** | **Security** | **7.0** / 10 | `███████░░░` 70% | `⚠️ Pending` | GPS coordinates and anti-fake validations perform well; route-level role permission audits should be strictly enforced via middleware. | `📌 P2` |

### 🎯 Strategic Remediation Roadmap

```
[ P0 CRITICAL ] ──► Decouple Mutating Stored Procedure from Read Queries
                    ├─ Extract CALL updateNameDeptEmpty() out of FindAll read transactions
                    └─ Prevent write lock contention and replication lag on read replica handles

[ P1 HIGH ]     ──► External Client Circuit Breaking & Resilience
                    ├─ Wrap Pondasi client and Firebase calls with timeout thresholds and circuit breakers
                ──► Clean Architecture Signature Standardization
                    └─ Migrate (*gin.Context) parameters in use cases to standard (context.Context)

[ P2 MEDIUM ]   ──► Enforce Route Role & Permission Matrix
                    ├─ Enforce explicit role-based access authorization across all attendance endpoints
                    └─ Validate payload integrity for GPS mock detection
```

---

## 🏛 Architecture & Workflow

This service implements separation of concerns based on Clean Architecture principles:

```
[ Mobile / Web App ]
         │
         ▼
[ Gin HTTP Router ] (`route/`)
         │
         ▼
[ Auth & Context Middleware ] (`auth/`)
         │
         ▼
[ Controllers ] (`controller/`)       ──> Bind JSON/Multipart, Validate DTOs
         │
         ▼
[ Service Layer ] (`service/`)        ──> Geofence Validation, Business Invariants, Transactions
         │
         ▼
[ Repositories ] (`repository/`)      ──> GORM MySQL Queries (Read/Write Separation)
         │
         ▼
[ MySQL Database ]
```

---

## 🚀 Key Features

1. **Presensi & Validasi Geofence (*Check-in / Check-out*)**:
   - Real-time recording of clock-in and clock-out attendance events.
   - Validasi koordinat GPS (Latitude/Longitude) terhadap radius kantor yang ditugaskan (*geofencing*).
   - Penyimpanan foto bukti kehadiran (*selfie*) dan metadata perangkat.
   - Perhitungan otomatis keterlambatan (*late check-in*) dan jam kerja efektif.
2. **Master Kantor & Penugasan Karyawan**:
   - Master data kantor, alamat, koordinat peta, dan radius toleransi jarak (meter).
   - Pemetaan karyawan ke kantor utama atau penugasan kantor sementara (*multi-office assignment*).
3. **Jadwal Kerja & Shift (*Work Hours*)**:
   - Konfigurasi jam masuk, jam istirahat, dan jam pulang.
   - Fleksibilitas shift kerja dan penugasan jadwal kerja per karyawan (*work hour users*).
4. **Kalender Operasional & Hari Libur**:
   - Manajemen kalender hari libur nasional dan hari libur internal perusahaan.
5. **Manajemen Cuti & Saldo Kuota Cuti (*Leave & Quotas*)**:
   - Master kategori cuti (Cuti Tahunan, Cuti Sakit, Cuti Menikah, dsb.).
   - Annual leave quota balance tracking per period.
   - Leave application submission, medical/supporting certificate attachments, and approval workflows.
6. **Koreksi Absensi (*Attendance Corrections*)**:
   - Pengajuan revisi jam absensi oleh karyawan yang lupa absen atau kendala perangkat.
   - Direct supervisor verification and approval.
7. **Manajemen Rapat (*Meetings & Attendance*)**:
   - Penjadwalan rapat internal maupun eksternal.
   - Recording attendee attendance lists for meeting sessions.

---

## 📁 Directory Structure

```plaintext
visit-flow-presence/
├── app/                  # Router assembly, middleware setup, dan database bootstrap
├── auth/                 # Middleware JWT parser dan adapter autentikasi
├── configuration/        # Loader konfigurasi Viper (.env)
├── controller/           # Gin controllers (Presences, Leaves, Offices, Corrections, etc.)
├── exception/            # Centralized panic recovery and HTTP error mapping
├── helper/               # Geolocation distance helpers, transactions, FCM & email sender
├── model/
│   ├── domain/           # Entitas GORM domain & database persistence models
│   └── web/              # Request & Response DTOs
├── repository/           # GORM repository interfaces & implementations
├── route/                # Per-domain route registration & dependency injection
├── service/              # Presence business logic, validations, and transaction boundaries
├── test/                 # Test suites, mocks, and domain assertions
├── Dockerfile            # Containerization build file
├── docker-compose.yml    # Docker compose service definition
├── Makefile              # Build, test, lint, coverage scripts
└── main.go               # Application entrypoint
```

---

## 🔌 API Endpoints Catalog

The following is the complete catalog of REST API endpoints provided by this service:

### Attendance Corrections (`route/attendance_correction_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/attendance-corrections` | Get Attendance Corrections list (filter & pagination) |
| `GET` | `/attendance-corrections/:id` | Get Attendance Correction details by parameter |
| `POST` | `/attendance-corrections` | Create new Attendance Correction record |
| `PUT` | `/attendance-corrections/:id` | Update Attendance Correction record |
| `DELETE` | `/attendance-corrections/:id` | Delete Attendance Correction record |
| `PUT` | `/attendance-corrections/:id/approved-boss` | Direct superior approval for Attendance Correction request |
| `PUT` | `/attendance-corrections/:id/rejected-boss` | Penolakan pengajuan Attendance Corrections oleh atasan langsung |
| `PUT` | `/attendance-corrections/:id/approved-hrd` | Final HRD approval for Attendance Correction request |
| `PUT` | `/attendance-corrections/:id/rejected-hrd` | Penolakan pengajuan Attendance Corrections oleh HRD |

### Calendars & Holidays (`route/calendar_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/calendars/:id` | Delete Calendar & Holiday record |
| `GET` | `/calendars` | Get Calendars & Holidays list (filter & pagination) |
| `GET` | `/calendars/:id` | Get Calendar & Holiday details by parameter |
| `POST` | `/calendars/csv` | Import batch data melalui berkas CSV |
| `POST` | `/calendars/process-by-year` | Proses batch kalkulasi kalender / kuota per tahun |
| `POST` | `/calendars` | Create new Calendar & Holiday record |
| `PUT` | `/calendars/:id` | Update Calendar & Holiday record |

### Leave Categories (`route/leave_category_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/leave-categories/:id` | Delete Leave Category record |
| `GET` | `/leave-categories` | Get Leave Categories list (filter & pagination) |
| `GET` | `/leave-categories/:id` | Get Leave Category details by parameter |
| `POST` | `/leave-categories` | Create new Leave Category record |
| `PUT` | `/leave-categories/:id` | Update Leave Category record |

### Leave Periods (`route/leave_period_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/leave-period` | Get Leave Periods list (filter & pagination) |
| `GET` | `/leave-period/:id` | Get Leave Period details by parameter |
| `POST` | `/leave-period` | Create new Leave Period record |
| `PUT` | `/leave-period/:id` | Update Leave Period record |
| `DELETE` | `/leave-period/:id` | Delete Leave Period record |

### Leave Quota Categories (`route/leave_qouta_category_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/leave-qouta-categories/:id` | Delete Leave Quota Category record |
| `GET` | `/leave-qouta-categories` | Get Leave Quota Categories list (filter & pagination) |
| `GET` | `/leave-qouta-categories/:id` | Get Leave Quota Category details by parameter |
| `POST` | `/leave-qouta-categories` | Create new Leave Quota Category record |
| `PUT` | `/leave-qouta-categories/:id` | Update Leave Quota Category record |

### Leave Quotas & Balance (`route/leave_quota_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/leave-quotas` | Get Leave Quotas list (filter & pagination) |
| `GET` | `/leave-quotas/:id` | Get Leave Quota details by parameter |
| `POST` | `/leave-quotas` | Create new Leave Quota record |
| `POST` | `/leave-quotas/process/next-year` | Inisialisasi kuota cuti tahun berikutnya |
| `POST` | `/leave-quotas/process/quota` | Kalkulasi otomatis alokasi kuota cuti karyawan |
| `PUT` | `/leave-quotas/:id` | Update Leave Quota record |
| `PUT` | `/leave-quotas/non-active/:year` | Non-aktifkan alokasi kuota cuti pada tahun tertentu |
| `DELETE` | `/leave-quota/:id` | Delete Leave Quota record |

### Leaves & Approval Workflows (`route/leave_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/leaves/:id` | Delete Leave application record |
| `GET` | `/leaves` | Get Leave applications list (filter & pagination) |
| `GET` | `/leaves/:id` | Get Leave application details by parameter |
| `GET` | `/leaves/proof-photo/:file_name` | Mengambil / mengunduh file foto bukti Leaves & Approval Workflows |
| `GET` | `/leaves/validate-quota` | Validasi kecukupan sisa saldo kuota cuti |
| `POST` | `/leaves` | Create new Leave application |
| `PUT` | `/leaves/:id` | Update Leave application |
| `PUT` | `/leaves/:id/canceled` | Pembatalan pengajuan Leaves & Approval Workflows oleh pemohon |
| `PUT` | `/leaves/:id/approved/manager` | Direct manager approval for Leave application |
| `PUT` | `/leaves/:id/rejected/manager` | Penolakan pengajuan Leaves & Approval Workflows oleh atasan langsung |
| `PUT` | `/leaves/:id/approved/hrd` | Final HRD approval for Leave application |
| `PUT` | `/leaves/:id/rejected/hrd` | Penolakan pengajuan Leaves & Approval Workflows oleh HRD |
| `PUT` | `/leaves/:id/canceled/hrd` | Pembatalan pengajuan Leaves & Approval Workflows oleh HRD |
| `PUT` | `/leaves/:id/entry/security` | Security post check-in entry timestamp recording |
| `PUT` | `/leaves/:id/exit/security` | Security post departure exit timestamp recording |
| `GET` | `/report/leaves/totals` | Get aggregate total summary of Leaves & Approval Workflows |
| `GET` | `/report/leaves-details` | Get detailed report breakdown of Leaves & Approval Workflows |

### Presence Audit Logs (`route/log_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/visit-flow-presence-logs` | Get Presence Audit Logs list (filter & pagination) |

### Meeting Members Check-in/Check-out (`route/meeting_member_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `PUT` | `/meeting-members/:visitID/:structureID/check-in` | Update Meeting Member record |
| `PUT` | `/meeting-members/:visitID/:structureID/check-out` | Update Meeting Member record |

### Meetings (`route/meeting_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/meeting` | Create new Meeting record |

### Offices & Geofences (`route/office_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/offices/:office-id` | Delete Office & Geofence record |
| `GET` | `/offices` | Get Offices & Geofences list (filter & pagination) |
| `GET` | `/offices/:office-id` | Get Office & Geofence details by parameter |
| `POST` | `/offices` | Create new Office & Geofence record |
| `PUT` | `/offices/:office-id` | Update Office & Geofence record |

### Office Users Assignments (`route/office_user_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/offices/:office-id/users/:user-id` | Delete Office User Assignment record |
| `GET` | `/offices/:office-id/users` | Get Office User Assignment details by parameter |
| `POST` | `/offices/:office-id/users/:nip` | Create new Office User Assignment record |
| `POST` | `/office-users/upload-csv` | Import batch data melalui berkas CSV |
| `GET` | `/offices/users/:user-id/` | Get Office User Assignment details by parameter |
| `GET` | `/users/:user-id/offices` | Get Office User Assignment details by parameter |

### Presences & Attendance Reports (`route/presence_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/presences/monthly/:office-id/:period` | Get Presence details by parameter |
| `GET` | `/presences` | Get Presences list (filter & pagination) |
| `GET` | `/presences/:id` | Get Presence details by parameter |
| `GET` | `/presence/:date/user/:user-id/` | Get Presence details by parameter |
| `POST` | `/presences` | Create new Presence record |
| `GET` | `/report/presence/attendance-user` | Laporan rekap kehadiran pengguna |
| `GET` | `/report/total/presence/attendance-user` | Get aggregate total summary of User Attendance Presences |
| `GET` | `/report/presence/late-deductions-user` | Laporan kalkulasi denda keterlambatan user |
| `GET` | `/report/presence/attendance-user-deduction` | Laporan potongan absensi dan keterlambatan per user |
| `GET` | `/report/presence/late-user-deduction` | Get Presences list (filter & pagination) |

### Work Hours & Shifts (`route/work_hour_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/work-hours/:id` | Delete Work Hours & Shift record |
| `GET` | `/work-hours` | Get Work Hours & Shifts list (filter & pagination) |
| `GET` | `/work-hours/:id` | Get Work Hours & Shift details by parameter |
| `POST` | `/work-hours` | Create new Work Hours & Shift record |
| `PUT` | `/work-hours/:id` | Update Work Hours & Shift record |

### Work Hour Users Assignments (`route/work_hour_user_route.go`)

| Method | Endpoint | Description |
|---|---|---|
| `DELETE` | `/work-hour-users/:id` | Delete Work Hour User Assignment record |
| `GET` | `/work-hour-users` | Get Work Hour Users Assignments list (filter & pagination) |
| `GET` | `/work-hour-users/:id` | Get Work Hour User Assignment details by parameter |
| `POST` | `/work-hour-users` | Create new Work Hour User Assignment record |
| `POST` | `/work-hour-users/upload-csv` | Import batch data melalui berkas CSV |

---


## ⚙️ Environment Configuration (`.env`)

Buat atau sesuaikan file `configuration/.env`:

```env
# Application Port
PORT=8080

# MySQL Database Configuration
HOST_DB=127.0.0.1
PORT_DB=3306
USER_DB=root
PASSWORD_DB=secret_password
DATABASE_DB=visitflow_presence_db

# Security & JWT
ACCESS_SECRET=your_jwt_access_secret_key
REFRESH_SECRET=your_jwt_refresh_secret_key

# Observability
OTEL_EXPORTER_OTLP_ENDPOINT=localhost:4317
INSECURE_MODE=true

# Notification Integrations
FIREBASE_CREDENTIALS_FILE=helper/service-account.json
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=no-reply@example.com
SMTP_PASS=your_smtp_password
```

---

## 🛠 Getting Started (Local Development)

### Prerequisites
- **Go**: `1.23` atau lebih baru
- **MySQL**: `8.0` atau MariaDB setara

### Steps to Run
1. **Clone repository:**
   ```bash
   git clone https://gitlab.com/vneu/visit-flow-presence.git
   cd visit-flow-presence
   ```

2. **Download dependencies:**
   ```bash
   go mod download
   ```

3. **Konfigurasi environment:**
   ```bash
   cp configuration/.env.example configuration/.env
   ```

4. **Jalankan service:**
   ```bash
   make run
   # atau
   go run main.go
   ```

Service akan aktif di `http://localhost:8080`.

---

## 🧪 Testing & Quality Gates

The presence service is comprehensively verified covering Geofence radius algorithms (Haversine formula), leave quota calculations, exception recovery, and GORM transactions:

### Coverage Status

| Metric | Actual Value | CI Gate Threshold | Status |
|---|---|---|---|
| **Total Statement Coverage** | **97.8%** | `>= 70.0%` (Target: `>= 90.0%`) |  **PASSED** |

### Coverage Breakdown per Layer

| Layer / Package | Coverage | Description |
|---|---|---|
| `route/` | **100.0%** | Router endpoints & dependency injection |
| `model/domain/` | **100.0%** | Model database & entitas GORM domain |
| `configuration/` | **100.0%** | Loader konfigurasi Viper (.env) |
| `controller/` | **99.3%** | Gin controllers (Presences, Leaves, Offices, etc.) |
| `repository/` | **99.5%** | GORM queries, CRUD operations & DB resolver |
| `service/` | **98.3%** | Presence business logic & geofence validation |
| `exception/` | **92.7%** | Panic recovery & error mapper |
| `auth/` | **92.5%** | JWT verification & context claims parser |
| `helper/` | **89.2%** | Geolocation distance calculations & notification sender |

### Running Tests

```bash
# Run all unit tests
make test

# Run tests with coverage report
make cover

# Validate coverage threshold gate (>= 70%)
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
# Binary output saved to bin/visit-flow-presence
```

### Build Docker Image
```bash
docker build -t visit-flow-presence:latest .
```

### Deployment with Docker Compose
```bash
docker-compose up -d
```
The container runs with the name `visit-flow-presence`, connects to the `visitflow` Docker network, and mounts the storage volume `/home/DOCKER/VISIT-FLOW-PRESENCE/file:/app/file`.
