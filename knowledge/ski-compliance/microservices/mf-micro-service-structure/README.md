# MF Micro Service — Marketing Structure

[![Go Version](https://img.shields.io/badge/Go-1.23-00ADD8?style=flat&logo=go)](https://golang.org/)
[![Gin Framework](https://img.shields.io/badge/Gin-v1.9.1-008ECF?style=flat&logo=gin)](https://gin-gonic.com/)
[![GORM](https://img.shields.io/badge/ORM-GORM%20v1.25.2-blue?style=flat)](https://gorm.io/)
[![MySQL](https://img.shields.io/badge/Database-MySQL%205.7%2F8.0-4479A1?style=flat&logo=mysql)](https://www.mysql.com/)
[![OpenTelemetry](https://img.shields.io/badge/Telemetry-OTel%20Tracing-F5A800?style=flat&logo=opentelemetry)](https://opentelemetry.io/)
[![Coverage](https://img.shields.io/badge/Coverage-97.6%25-brightgreen?style=flat&logo=go)](Makefile)

`mf-micro-service-structure` adalah backend microservice berbasis Go yang bertanggung jawab mengelola struktur organisasi pemasaran (*marketing structures*), tingkatan posisi/hierarki (*Level 1–6*), penugasan kantor (*office*), wilayah teritori outlet (*Territory Outlet*) dan pelanggan (*Territory Customer*), relasi hierarki atasan-bawahan, sinkronisasi warehouse struktur (ETL), serta operasi penutupan berbasis periode (*period closing / lock period*) dalam ekosistem **VNEU / SKI Compliance**.

---

## 📑 Daftar Isi

- [Arsitektur & Tech Stack](#-arsitektur--tech-stack)
- [Struktur Direktori](#-struktur-direktori)
- [Fitur Utama & Domain](#-fitur-utama--domain)
- [Prasyarat Sistem](#-prasyarat-sistem)
- [Instalasi & Menjalankan Lokal](#-instalasi--menjalankan-lokal)
- [Konfigurasi Environment (`.env`)](#-konfigurasi-environment-env)
- [Katalog Endpoint API](#-katalog-endpoint-api)
- [Pengujian & Test Coverage](#-pengujian--test-coverage)
- [Quality Gates & Makefile Commands](#-quality-gates--makefile-commands)
- [Docker & Deployment](#-docker--deployment)
- [Aturan & Konvensi Arsitektur](#-aturan--konvensi-arsitektur)

---

## 🛠 Arsitektur & Tech Stack

| Komponen | Teknologi / Library | Keterangan |
| :--- | :--- | :--- |
| **Bahasa Pemrograman** | Go `1.23` | Backend runtime & concurrency |
| **HTTP Web Framework** | Gin Web Framework `v1.9.1` | REST API routing, context handling & middleware |
| **Database & ORM** | MySQL 5.7+ / 8.0 & GORM `v1.25.2` | Object Relational Mapping & dynamic querying |
| **Konfigurasi** | Viper `v1.16.0` | Environment parser via `./configuration/.env` |
| **Validasi Request** | Go Playground Validator `v10.14.1` | DTO validation & custom domain rules |
| **Autentikasi** | JWT (`github.com/dgrijalva/jwt-go`) | Bearer token claim & AccessDetails validation |
| **Observabilitas** | OpenTelemetry (`otel`, `otelgin` `v0.44.0`) | Distributed tracing via OTLP gRPC collector |
| **Testing & Mocking** | `testing`, Testify `v1.8.4`, SQLMock `v1.5.0` | Unit & integration tests dengan coverage $\ge 90\%$ |

### Alur Request Lifecycle

```text
HTTP Request 
   │
   ▼
otelgin (OTel Tracing Middleware)
   │
   ▼
ErrorHandler (Global Panic Recovery & HTTP Status Mapping)
   │
   ▼
Auth Middleware (JWT Token Verification & Access Control)
   │
   ▼
Controller (Binding DTO, Unmarshaling & JSON Response Formatting)
   │
   ▼
Service (Transaction Boundary: tx.Begin -> defer CommitOrRollback)
   │
   ▼
Repository (GORM ORM Queries, Mutations & History Audit)
   │
   ▼
MySQL Database
```

---

## 📂 Struktur Direktori

```text
mf-micro-service-structure/
├── app/                  # Inisialisasi DB connection, OTel tracer, & router registry
├── auth/                 # Middleware autentikasi JWT & token parsing
├── configuration/        # Viper config loader & struct konfigurasi (.env)
├── controller/           # HTTP handlers & controller layer
├── exception/            # Panic-recovery error handler & mapping HTTP response
├── helper/               # Helper fungsi: query filter, ETL, custom validation, tx helpers
├── model/
│   ├── domain/           # GORM persistence structs, views, & entity database
│   └── web/              # Request / Response DTOs & response envelopes
├── repository/           # Repository interfaces & implementasi GORM queries
├── route/                # Definisi route groups Gin
├── scripts/              # Automation scripts (e.g. check-coverage.sh)
├── service/              # Business logic & boundaries transaksi database
├── test/                 # Test suites (unit test, mock test, helper & repository test)
├── .agent/               # Knowledge base, architectural guides & AGENTS operations
├── Dockerfile            # Multi-stage production container build
├── docker-compose.yml    # Docker compose service definition
├── Makefile              # Quality gate automation & dev commands
└── main.go               # Entry point aplikasi
```

---

## 🚀 Fitur Utama & Domain

1. **Marketing Structure Management**:
   - Pengelolaan struktur marketing per periode (`YYYYMM`).
   - Hierarki multi-tingkat: Level 1 (MR/Sales Rep) hingga Level 6 (Direksi/Pimpinan).
   - Relasi atasan (*boss*) dan bawahan (*subordinates*).
   - Dukungan tanggal bergabung (*join date*), duplikasi struktur, dan penggabungan (*merge structure*).
2. **Period Locking & Closing**:
   - `ClosedEditArea`: Mengunci perubahan area teritori pada periode tertentu.
   - `ClosedEditAll`: Menutup dan mengunci seluruh modifikasi data struktur pada periode tertentu.
3. **Marketing Positions**:
   - Master data posisi dan jabatan marketing yang terikat pada periode kerja.
4. **Territory Mapping**:
   - **Marketing Structure Area**: Pemetaan marketing structure ke kota/kabupaten (*City / District*).
   - **Territory Outlet**: Pemetaan marketing structure ke outlet/pelanggan institusi.
   - **Territory Customer**: Pemetaan marketing structure ke customer/dokter/spesialis.
5. **Office Management**:
   - Pengelolaan kantor cabang dan kantor operasional.
6. **Warehouse & Flat Structure ETL**:
   - Ekstraksi dan pemrosesan data struktur menjadi format tabel flat *all-levels* untuk keperluan analytics, reporting, dan warehouse compliance (`structure_wh_process`).
7. **Audit Trail & Soft Deletes**:
   - Setiap mutasi (Create, Update, Delete) dicatat ke dalam tabel riwayat audit (`history`) dengan menyertakan `user_id` dan timestamp.

---

## 💻 Prasyarat Sistem

- **Go**: Version `1.23` atau lebih tinggi
- **MySQL**: Version `5.7` atau `8.0`
- **Make**: Untuk eksekusi command automation
- **GitLab Access Token**: Diperlukan untuk mendownload private modules `gitlab.com/VNEU/*`

---

## 🔧 Instalasi & Menjalankan Lokal

### 1. Clone Repository

```bash
git clone https://gitlab.com/VNEU/mf-micro-service-structure.git
cd mf-micro-service-structure
```

### 2. Konfigurasi Private Modules Go

Pastikan Go dapat mengunduh dependensi privat dari GitLab:

```bash
git config --global url."https://<ACCESS_TOKEN>@gitlab.com".insteadOf "https://gitlab.com"
export GOPRIVATE="gitlab.com/VNEU/*"
```

### 3. Setup Konfigurasi Environment

Salin atau buat file konfigurasi di `./configuration/.env`:

```bash
cp configuration/.env.example configuration/.env # Jika tersedia, atau buat konfigurasi baru
```

Isi variabel environment sesuai database dan kebutuhan lokal Anda (lihat tabel di bawah).

### 4. Unduh Dependensi & Jalankan Service

```bash
# Download dependencies
go mod tidy

# Jalankan service secara lokal
make run
# atau
go run main.go
```

Service akan aktif dan mendengarkan pada port yang ditentukan (default: `8080`).

---

## ⚙️ Konfigurasi Environment (`.env`)

File konfigurasi dibaca dari `./configuration/.env`:

| Variabel | Tipe | Contoh Nilai | Deskripsi |
| :--- | :--- | :--- | :--- |
| `PORT` | `string` | `8080` | Port listening server HTTP |
| `HOST_DB` | `string` | `127.0.0.1` | Host database MySQL |
| `PORT_DB` | `string` | `3306` | Port database MySQL |
| `USER_DB` | `string` | `root` | Username database MySQL |
| `PASSWORD_DB` | `string` | `password` | Password database MySQL |
| `DATABASE_DB` | `string` | `db_marketing_structure` | Nama database |
| `ACCESS_SECRET` | `string` | `your-jwt-access-secret` | Secret key untuk verifikasi JWT Access Token |
| `REFRESH_SECRET` | `string` | `your-jwt-refresh-secret` | Secret key untuk JWT Refresh Token |
| `SYNC_URL` | `string` | `http://localhost:8081` | URL service sinkronisasi |
| `VISIT_URL` | `string` | `http://localhost:8082` | URL service kunjungan / visit flow |
| `NOCODE_URL` | `string` | `http://localhost:8083` | URL integrasi no-code API config |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | `string` | `localhost:4317` | Alamat endpoint OTel Collector (gRPC) |
| `INSECURE_MODE` | `string` | `true` | Mode koneksi insecure OTel (`true`/`false`) |

---

## 📡 API Endpoint Catalog

All registered HTTP endpoints across the 8 service modules are listed below:

### 1. Marketing Structures (`/marketings/structures`)

| HTTP Method | Path | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/marketings/structures` | Bearer JWT | Retrieve all marketing structures with dynamic query filtering and hierarchy scope evaluation |
| `GET` | `/marketings/structures-no-auth` | None | Retrieve marketing structures without authentication |
| `GET` | `/marketings/structures/:id` | Bearer JWT | Retrieve marketing structure details by structure ID / code and period |
| `GET` | `/marketings/structures/:id/user` | None | Retrieve marketing structure details assigned to a specific user ID |
| `GET` | `/marketings/structures-get-boss/:id` | Bearer JWT | Retrieve supervisor / boss hierarchy details for a given structure ID |
| `GET` | `/marketings/structures-find/:period/:city/:level/:division` | Bearer JWT | Find specific marketing structures matching period, city, level, and division path parameters |
| `GET` | `/marketings/structures-all-levels` | None | Query complete multi-tier marketing structure hierarchy across all levels (Level 1 to Level 6) |
| `GET` | `/marketings/structures-subordinates-no-auth` | None | Retrieve subordinate marketing structures for all hierarchy levels without authentication |
| `GET` | `/marketings/structures/with-join-date` | Bearer JWT | Retrieve marketing structures along with employee join date details |
| `GET` | `/marketings/structures-duplicate` | None | Duplicate marketing structure hierarchy into the subsequent period |
| `GET` | `/marketings/structures-filter/:period/:level/:code` | Bearer JWT | Filter marketing structure hierarchy by period, position level, and structure code |
| `POST` | `/marketings/structures` | Bearer JWT | Create a new marketing structure node |
| `POST` | `/marketings/structures/process-data/:period` | None | Batch process and migrate marketing structure data into the specified target period |
| `PUT` | `/marketings/structures/:id` | Bearer JWT | Update existing marketing structure node information |
| `PUT` | `/marketings/structures/closed_edit_area/:period` | Bearer JWT | Lock and close territory area modifications for the specified period |
| `PUT` | `/marketings/structures/closed_edit_all/:period` | None | Lock and close all structure mutations for the specified period |
| `PUT` | `/marketings/structures/:id/merge/:marketingStructureID/:isAll` | Bearer JWT | Merge or split marketing structure assignments between two nodes |
| `DELETE` | `/marketings/structures/:id/:period` | Bearer JWT | Soft-delete marketing structure node by code and period |

### 2. Marketing Positions (`/marketings/positions`)

| HTTP Method | Path | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/marketings/positions` | Bearer JWT | Retrieve list of marketing positions (Level 1 to Level 6) |
| `GET` | `/marketings/positions/:id` | Bearer JWT | Retrieve marketing position details by position ID |
| `POST` | `/marketings/positions` | Bearer JWT | Create a new marketing position level |
| `PUT` | `/marketings/positions/:id/:period` | Bearer JWT | Update marketing position details for a specific period |
| `DELETE` | `/marketings/positions/:id/:period` | Bearer JWT | Soft-delete marketing position by position ID and period |

### 3. Hierarchies (`/hierarchies`)

| HTTP Method | Path | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/hierarchies` | Bearer JWT | Retrieve list of user hierarchy relationships |
| `GET` | `/hierarchies/all` | Bearer JWT | Retrieve all marketing hierarchy relationships |
| `GET` | `/hierarchies-csv` | Bearer JWT | Export hierarchy relationship data in CSV format |
| `GET` | `/hierarchies/:id` | Bearer JWT | Retrieve hierarchy relationship details by ID |
| `POST` | `/hierarchies` | Bearer JWT | Create a new user hierarchy relationship |
| `PUT` | `/hierarchies/:id` | Bearer JWT | Update an existing hierarchy relationship |
| `DELETE` | `/hierarchies/:id` | Bearer JWT | Delete a hierarchy relationship |

### 4. Territory Areas & Coverage (`/marketings/structures/areas`)

| HTTP Method | Path | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/marketings/structures/areas` | Bearer JWT | Retrieve marketing structure to city area mappings |
| `GET` | `/marketings/structures/areas/:id` | Bearer JWT | Retrieve structure city area mapping details by ID |
| `POST` | `/marketings/structures/areas` | Bearer JWT | Assign a new city area to a marketing structure |
| `PUT` | `/marketings/structures/areas/:id` | Bearer JWT | Update structure city area mapping |
| `DELETE` | `/marketings/structures/areas/:id` | Bearer JWT | Delete structure city area mapping |

### 5. Territory Outlets (`/marketings/structures/territories/outlets`)

| HTTP Method | Path | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/marketings/structures/territories/outlets` | Bearer JWT | Retrieve paginated list of outlet territory assignments |
| `GET` | `/marketings/structures/territories/outlets-no-auth` | None | Retrieve outlet territory assignments without authentication |
| `GET` | `/marketings/structures/territories/outlets/by-structure-no-auth` | None | Retrieve distinct outlet territory assignments grouped by structure |
| `GET` | `/marketings/structures/territories/outlets/:id` | Bearer JWT | Retrieve outlet territory assignment details by ID |
| `POST` | `/marketings/structures/territories/outlets` | Bearer JWT | Assign an outlet to a marketing structure territory |
| `PUT` | `/marketings/structures/territories/outlets/:id` | Bearer JWT | Update outlet territory assignment details |
| `DELETE` | `/marketings/structures/territories/outlets/:id` | Bearer JWT | Remove an outlet territory assignment |

### 6. Territory Customers (`/marketings/structures/territories/customers`)

| HTTP Method | Path | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/marketings/structures/territories/customers` | Bearer JWT | Retrieve paginated list of customer territory assignments |
| `GET` | `/marketings/structures/territories/customers-no-auth` | None | Retrieve customer territory assignments without authentication |
| `GET` | `/marketings/structures/territories/customers/by-structure-no-auth` | None | Retrieve distinct customer territory assignments grouped by structure |
| `GET` | `/marketings/structures/territories/customers/events` | Bearer JWT | Retrieve customer territory assignments associated with promotional events |
| `GET` | `/marketings/structures/territories/customers/:id` | Bearer JWT | Retrieve customer territory assignment details by ID |
| `POST` | `/marketings/structures/territories/customers` | Bearer JWT | Assign a customer to a marketing structure territory |
| `DELETE` | `/marketings/structures/territories/customers/:id` | Bearer JWT | Remove a customer territory assignment |

### 7. Offices (`/offices`)

| HTTP Method | Path | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/offices` | Bearer JWT | Retrieve list of branch offices |
| `GET` | `/offices/:id` | Bearer JWT | Retrieve branch office details by office ID |
| `POST` | `/offices` | Bearer JWT | Register a new branch office |
| `PUT` | `/offices/:id` | Bearer JWT | Update branch office details |
| `DELETE` | `/offices/:id` | Bearer JWT | Soft-delete a branch office by ID |

### 8. Structure Warehouse & ETL Processes

| HTTP Method | Path | Auth | Description |
| :--- | :--- | :---: | :--- |
| `POST` | `/warehouse/structure-ethical/process/:period` | None | ETL process and sync ethical structure data into the warehouse database |
| `POST` | `/ski/marketing-structure-all-levels/process/:period` | None | Process and flatten all-level marketing structure table for SKI analytics |
| `GET` | `/marketing-structure-all-levels/subordinates` | None | Retrieve list of subordinates across all structure levels |

---

## 🧪 Pengujian & Test Coverage

Seluruh pengujian unit dan integrasi dikelola secara terisolasi pada direktori `./test` menggunakan kombinasi `testing`, `testify` (`assert`, `mock`), dan `go-sqlmock`. Statement coverage divalidasi dan dihitung secara live (tidak di-hardcode) melalui script sinkronisasi `scripts/update_coverage.py` dan quality gate `scripts/check-coverage.sh`.

### Live Statement Coverage Breakdown

<!-- LIVE_COVERAGE_START -->
| Package / Layer | Covered Statements | Total Statements | Statement Coverage | Quality Gate Status |
| :--- | :---: | :---: | :---: | :---: |
| `controller` | 920 | 925 | **99.5%** | ✅ Passed |
| `service` | 3,478 | 3,543 | **98.2%** | ✅ Passed |
| `repository` | 2,416 | 2,460 | **98.2%** | ✅ Passed |
| `route` | 193 | 193 | **100.0%** | ✅ Passed |
| `exception` | 85 | 85 | **100.0%** | ✅ Passed |
| `model` | 105 | 105 | **100.0%** | ✅ Passed |
| `helper` | 605 | 668 | **90.6%** | ✅ Passed |
| `app` | 78 | 89 | **87.6%** | ✅ Passed |
| `auth` | 23 | 28 | **82.1%** | ✅ Passed |
| `configuration` | 13 | 15 | **86.7%** | ✅ Passed |
| **Total (Overall)** | **7,916** | **8,111** | **97.6%** | **✅ Quality Gate Satisfied (≥ 90.0%)** |
<!-- LIVE_COVERAGE_END -->

Untuk memperbarui angka coverage secara otomatis pada README:
```bash
# Menjalankan test coverage dan auto-sync README
make update-cov
# atau
make check-cov
```

---

## 🛡 Quality Gates & Makefile Commands

Proyek ini dilengkapi dengan target `Makefile` terstandarisasi untuk menjamin kualitas kode:

```bash
# Menampilkan seluruh opsi perintah Make
make help
```

| Perintah | Deskripsi |
| :--- | :--- |
| `make run` | Menjalankan aplikasi secara lokal |
| `make build` | Membangun biner statis (`CGO_ENABLED=0`) ke dalam folder `bin/` |
| `make test` / `make t` | Menjalankan unit & integration test pada paket `./test/...` |
| `make cov` / `make cover` | Menjalankan test coverage dan menampilkan ringkasan per fungsi |
| `make check-cov` | Memvalidasi bahwa statement coverage memenuhi threshold $(\ge 90.0\%)$ |
| `make race` | Menjalankan test suite dengan Go race detector (`-race`) |
| `make fmt` | Memformat kode Go dengan `go fmt ./...` |
| `make fmt-check` | Memeriksa format file tanpa mengubah isi file |
| `make vet` | Menjalankan analisis statis dengan `go vet ./...` |
| `make lint` | Menjalankan `golangci-lint` jika terpasang |
| `make critic` / `make cr` | Menjalankan pemeriksaan style & bug pattern dengan `gocritic` |
| `make cspell` | Memeriksa ejaan pada file `.go` menggunakan CSpell |
| `make tidy` | Merapikan dan memverifikasi `go.mod` dan `go.sum` |
| `make check-all` / `make check` | Menjalankan seluruh pipeline quality gates sebelum commit/push |
| `make clean` / `make cl` | Menghapus binary build dan artifact coverage |

---

## 🐳 Docker & Deployment

### Build & Run via Docker

```bash
# Build Docker Image
docker build \
  --build-arg ACCESS_TOKEN="<YOUR_GITLAB_ACCESS_TOKEN>" \
  -t mf-micro-service-structure:latest .

# Run Container
docker run -d \
  -p 8080:8080 \
  --name mf-micro-service-structure \
  mf-micro-service-structure:latest
```

### Docker Compose

Gunakan file `docker-compose.yml` untuk deployment di server:

```bash
docker compose up -d
```

---

## 📐 Aturan & Konvensi Arsitektur

Saat mengembangkan kode pada repositori ini, patuhi aturan berikut:

1. **Panic-Recover Error Propagation**:
   - Jangan menelan error (*swallow errors*) atau mengembalikan `nil` diam-diam saat terjadi failure pada layer service/repository.
   - Gunakan `helper.PanicIfError(err)` untuk mentrigger rollback otomatis pada `helper.CommitOrRollback(tx)` dan mapping error code di `exception.ErrorHandler`.
2. **Transaction Scope**:
   - Service bertanggung jawab membuka transaksi (`tx := service.DB.Begin()`) dan memastikan `defer helper.CommitOrRollback(tx)`.
   - Wajib meneruskan pointer `tx *gorm.DB` ke seluruh fungsi repository dalam satu siklus mutasi.
3. **Integritas Periode & Hierarki**:
   - Data terpartisi oleh `period` (`YYYYMM`, 6 digit numerik). Mutasi harus selalu mengecek status closing via `helper.ValidateClosing`, `IsClosedEditArea`, atau `IsClosedEditAll`.
4. **Audit History & Soft Deletes**:
   - Setiap mutasi wajib mencatat rekam jejak menggunakan `helper.CreateHistory(db, model, action, userID)`.
   - Gunakan soft-delete (`deleted_at`, `deleted_by_id`) untuk menjaga integritas data historis.

---

## 👥 Authors & Maintainers

- **VNEU Engineering Team** — Marketing Structure Service Maintainers
- Hak Cipta © 2026 VNEU / SKI Compliance. Seluruh hak cipta dilindungi undang-undang.
