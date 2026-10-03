# Arsitektur Sistem VisitFlow

Dokumentasi arsitektur sistem backend microservice VisitFlow (Core Visit, Presence, Survey, Gateway, Payroll).

---

## 1. Peta Layanan (Service Ecosystem)

| Service | Direktori | Port Default | Tanggung Jawab Utama | Database / Entitas |
| :--- | :--- | :--- | :--- | :--- |
| **VisitFlow Core (`visit-flow-go`)** | `visit-flow-go/` | `8080` | Manajemen Kunjungan (Visits), MCL (`visit_customers`), Organisasi (`structures`, `companies`, `areas`), Customer, Produk, Approval. | MySQL (`visits`, `visit_customers`, `structures`, `customers`, dll) |
| **Presence (`visit-flow-presence`)** | `visit-flow-presence/` | `8081` | Presensi harian karyawan, Jadwal kerja, Kantor, Cuti (`leaves`), Koreksi presensi, Meeting. | MySQL (`presences`, `offices`, `leaves`, `work_hours`) |
| **Survey (`visit-flow-survey-location-go`)** | `visit-flow-survey-location-go/` | `8082` | Survei outlet/lokasi, Kuisioner, Distributor, Material promosi. | MySQL (`outlet_surveys`, `outlet_survey_questions`) |
| **API Gateway (`visit-flow-api-gateway`)** | `visit-flow-api-gateway/` | `8000` | Proxy KrakenD, Autentikasi Gin lokal, Manajemen User, Role, Permission, Sesi login. | MySQL (`users`, `roles`, `sessions`) |
| **Payroll (`visit-flow-payroll`)** | `visit-flow-payroll/` | `8083` | Ingest PDF slip gaji, IMAP parser, Endpoint OTP payroll. | MySQL / File Storage |
| **Agent AI (`visitflow-agent-ai`)** | `visitflow-agent-ai/` | `5173` | AI Assistant SvelteKit + AGY CLI untuk konsultasi data, kueri database, & investigasi domain. | SQLite (chat memory) + MySQL Prod Readonly |

---

## 2. Arsitektur Layering Go Service (`visit-flow-go`)

```text
HTTP Request
  -> Gin Engine & Global Middleware (router)
  -> Auth Middleware (JWT parser & AccessDetails)
  -> Controller Interface & Implementation (controller/)
  -> Service Interface & Implementation (service/ - validasi & transaksi)
  -> Repository Interface & Implementation (repository/ - GORM & raw queries)
  -> MySQL Database
```

---

## 3. Alur Autentikasi & Multi-Tenancy

- **JWT Authentication**: Divalidasi oleh Gateway dan middleware `auth/auth.go`. Menghasilkan `AccessDetails` yang berisi `UserID`, `CompanyID`, `StructureID`, dan role flags (`IsMkt`).
- **Data Scoping**: Hampir semua kueri transaksi mewajibkan filter `company_id` (contoh: `company_id = 1` untuk PT. Metiska Farma) dan `period` (format `YYYYMM`).
- **Soft Deletion**: Menggunakan field `deleted_at`. Seluruh kueri wajib menyertakan filter `deleted_at IS NULL`.
