# Visit Flow - Payroll Microservice (`visit-flow-payroll`)

> **AI agents:** Start with [AGENTS.md](AGENTS.md), then [.agent/INDEX.md](.agent/INDEX.md). Current source/runtime evidence and workspace database rules govern task decisions.


[![Go Version](https://img.shields.io/badge/Go-1.23-00ADD8?style=flat&logo=go)](https://golang.org)
[![Coverage](https://img.shields.io/badge/Coverage-2.4%25-red?style=flat&logo=go)](helper/)
[![Gin Framework](https://img.shields.io/badge/Gin-v1.9.1-008ECF?style=flat&logo=go)](https://gin-gonic.com)
[![IMAP Protocol](https://img.shields.io/badge/Protocol-IMAP%20TLS-green?style=flat)](https://github.com/emersion/go-imap)
[![Telegram Bot](https://img.shields.io/badge/Integration-Telegram%20Bot%20API-0088cc?style=flat&logo=telegram)](https://core.telegram.org/bots/api)

Microservice untuk mengelola arsip slip gaji (*payroll payslips*), integrasi pengunduhan lampiran email otomatis melalui IMAP TLS, pencarian berkas slip gaji per NIP & periode, serta pengamanan akses berkas melalui autentikasi Two-Factor / One-Time Password (OTP) via Telegram Bot dan Email.

---

## 📑 Daftar Isi

- [Arsitektur & Alur Kerja](#arsitektur--alur-kerja)
- [Fitur Utama](#fitur-utama)
- [Struktur Direktori](#struktur-direktori)
- [Daftar Endpoint API](#daftar-endpoint-api)
- [Konfigurasi Environment (`.env`)](#konfigurasi-environment-env)
- [Panduan Memulai (Local Development)](#panduan-memulai-local-development)
- [Pengujian & Quality Gates](#pengujian--quality-gates)
- [Docker & Deployment](#docker--deployment)

---

## 🏛 Arsitektur & Alur Kerja

Layanan ini dirancang khusus untuk memproses dan mendistribusikan berkas PDF slip gaji secara aman:

```
                  ┌───────────────────────────────┐
                  │      IMAP Mail Server         │
                  │   (Slip Gaji Email Ingestion) │
                  └──────────────┬────────────────┘
                                 │
                                 ▼ (ProcessByEmail)
┌────────────────┐     ┌──────────────────┐     ┌────────────────────────┐
│ Client / Web   │ ──> │   Gin Router     │ ──> │   Payroll Service      │
│ Mobile App     │     │   & Auth Layer   │     │ (Search, Fetch, OTP)   │
└────────────────┘     └──────────────────┘     └───────────┬────────────┘
         ▲                                                  │
         │ (OTP Token)               ┌──────────────────────┴─────────────────────┐
         └───────────────────────────┤                                            ▼
                    ┌────────────────┴───────────────┐                 ┌──────────────────────┐
                    │ Telegram Bot API / SMTP Mailer │                 │ Local File Storage   │
                    │      (OTP Verification)        │                 │ (`/app/file/gaji/`)  │
                    └────────────────────────────────┘                 └──────────────────────┘
```

---

## 🚀 Fitur Utama

1. **Pencarian & Pengambilan Berkas Slip Gaji**:
   - Pencarian riwayat slip gaji berdasarkan Nomor Induk Pegawai (`NIP`).
   - Format penamaan periode fleksibel (`YYYYMM` atau `YYYY_Bulan`).
   - Pengunduhan berkas PDF slip gaji dengan header konten streaming yang aman.
2. **Otomatisasi Penarikan Slip Gaji dari Email (IMAP Ingestion)**:
   - Menghubungi mail server melalui protokol IMAP TLS.
   - Menginspeksi subject email (contoh: `SLIP GAJI NOVEMBER 2025`).
   - Melakukan batch processing dan ekstraksi lampiran PDF ke direktori penyimpanan lokal secara otomatis.
3. **Verifikasi Keamanan OTP (Telegram & Email)**:
   - Pembuatan token OTP 6-digit acak dengan batas masa berlaku (*time-to-live* 5 menit).
   - Pengiriman notifikasi OTP ke akun Telegram user via Telegram Bot API.
   - Pengiriman kode cadangan melalui Email.
   - Validasi OTP sebelum user diperbolehkan membuka atau mengunduh slip gaji.
4. **Agregasi & Statistik Berkas**:
   - Menghitung total berkas slip gaji yang telah terindeks pada periode berjalan.

---

## 📁 Struktur Direktori

```plaintext
visit-flow-payroll/
├── app/                  # Gin router initialization & middleware setup
├── auth/                 # JWT authentication & authorization wrapper
├── configuration/        # Environment config loader (.env)
├── controller/           # HTTP handlers & response formatters
├── email_template/       # Template email notifikasi OTP / slip gaji
├── helper/               # File path resolvers, string formatting, OTP helper
├── model/
│   └── web/              # Request and response DTOs
├── route/                # Route definitions & dependency injection
├── service/              # Payroll logic, IMAP processing, OTP token store
├── Dockerfile            # Container build recipe
├── docker-compose.yml    # Service composition definition
├── Makefile              # Deployment shortcuts
└── main.go               # Server entrypoint
```

---

## 🔌 Daftar Endpoint API

Berikut adalah seluruh endpoint REST API yang tersedia secara lengkap pada layanan ini:

### Payroll & Slip Gaji Services (`route/payroll_route.go`)

| Method | Endpoint | Deskripsi |
|---|---|---|
| `GET` | `/payrolls` | Mengunduh file PDF slip gaji sesuai user / NIP |
| `GET` | `/payrolls-by-nip/:nip` | Mendapatkan daftar periode slip gaji yang tersedia untuk NIP |
| `GET` | `/payroll-count-file` | Menghitung total berkas slip gaji pada direktori periode |
| `POST` | `/payroll-by-emails` | Memicu sinkronisasi penarikan slip gaji dari email IMAP TLS |
| `GET` | `/payroll-token` | Generate dan kirim kode OTP ke Telegram / Email |
| `POST` | `/payroll-token-validate` | Validasi kode OTP yang dimasukkan pengguna |

---


## ⚙️ Konfigurasi Environment (`.env`)

Buat file `.env` di root direktori service:

```env
# Application Port
PORT=8080

# Security & JWT
ACCESS_SECRET=your_jwt_access_secret_key
REFRESH_SECRET=your_jwt_refresh_secret_key

# IMAP Configuration (Untuk sinkronisasi slip gaji dari email)
HOST=imap.example.com:993
EMAIL=hr-payroll@example.com
PASSWORD=your_email_password

# Telegram Bot API (Untuk pengiriman kode OTP)
TELEGRAM_BOT_TOKEN=5557215067:AAH2AcRqcrkgd8ET-I2xQRtzMGyzkJKfLg0

# SMTP / Email Configuration (Notifikasi OTP Cadangan)
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=no-reply@example.com
SMTP_PASS=your_smtp_password
```

---

## 🛠 Panduan Memulai (Local Development)

### Prasyarat
- **Go**: `1.23` atau lebih baru
- Akses ke direktori penyimpanan berkas PDF (`file/gaji/`)

### Langkah Menjalankan
1. **Clone repository:**
   ```bash
   git clone https://gitlab.com/VNEU/visit-flow-payroll.git
   cd visit-flow-payroll
   ```

2. **Download dependencies:**
   ```bash
   go mod download
   ```

3. **Buat direktori penyimpanan berkas lokal:**
   ```bash
   mkdir -p file/gaji
   ```

4. **Jalankan aplikasi:**
   ```bash
   go run main.go
   ```

Server akan aktif dan melayani request pada port yang ditentukan (default: `8080`).

---

## 🧪 Pengujian & Quality Gates

Layanan ini memiliki pengujian unit pada fungsi pembantu (*helper utilities*, resolusi berkas, operasi string, dan token OTP):

### Status Coverage

| Metrik | Nilai Aktual | Target Gate | Keterangan |
|---|---|---|---|
| **Statement Coverage** | **2.4%** | Baseline | Pengujian terfokus pada modul `helper/` |

### Breakdown Coverage per Paket

| Paket | Coverage | Cakupan Pengujian |
|---|---|---|
| `helper/` | **7.8%** | Validasi model, operator format file, dan parsing helper |
| `service/` | `0.0%` | *(Rencana ekspansi unit test IMAP ingestion & OTP)* |
| `controller/` | `0.0%` | *(Rencana ekspansi unit test HTTP handler)* |

### Menjalankan Pengujian

```bash
# Menjalankan unit test
make test
# atau
go test ./...

# Menjalankan test dengan report coverage
make cover
# atau
go test ./... -coverpkg=./... -coverprofile=coverage.out
go tool cover -func=coverage.out | grep total:

# Validasi quality gate coverage
make check-cov
```

---

## 🐳 Docker & Deployment

### Build Docker Image
```bash
docker build -t visit-flow-payroll:latest .
```

### Deployment dengan Docker Compose
```bash
docker-compose up -d
```

Service akan menjalankan kontainer bernama `VISIT-FLOW-PAYROLL`, melakukan *volume mount* direktori slip gaji dari host (`/home/SDB/ftp/hr/salary` ke `/app/file/gaji/`), dan memetakan port host `21033` ke port internal kontainer `8080`.
