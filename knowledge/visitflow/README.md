# Visit Flow Microservices Platform

[![Go Version](https://img.shields.io/badge/Go-1.23-00ADD8?style=flat&logo=go)](https://golang.org)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Microservices-blue?style=flat)]()
[![Overall Test Gates](https://img.shields.io/badge/Quality%20Gate-PASSED-brightgreen?style=flat)]()

**Visit Flow** adalah platform ekosistem microservices terdistribusi untuk manajemen perencanaan dan realisasi kunjungan lapangan (*field-visit management*), pelacakan presensi berbasis geofence GPS, audit survei outlet, distribusi berkas slip gaji terproteksi OTP, serta identitas dan gateway akses terpadu.

## Panduan jawaban berbasis bukti

Ikuti [AGENTS.md](AGENTS.md) untuk Codex, Claude Code, dan Antigravity. Pertanyaan data dijawab dengan hasil query pada target read-only yang sudah dipilih, beserta scope, tanggal/zona waktu, dan waktu pengambilan. SQL validasi disertakan saat diminta; permintaan SQL saja tidak dieksekusi. Jika akses belum ada, agent menjelaskan hambatan spesifik tanpa mengarang angka.

Pertanyaan fitur wajib diverifikasi dari implementasi dan struktur database terkait. Usulan fitur mencakup kelayakan, perubahan kode/schema, risiko integritas/kompatibilitas/performa, dan rekomendasi yang dapat diuji. Pernyataan performa tanpa pengukuran harus diberi batas kepastian.

- [Katalog schema](DATABASE_SCHEMA_CATALOG.md) dan [kamus schema](DATABASE_SCHEMA.md): referensi struktur bertanggal; cocokkan dengan model/query dan target database.
- `database_schema.sql`: dump sensitif berisi DDL **dan INSERT**; baca hanya definisi yang diperlukan, jangan menjalankan/import dump untuk Q&A.
- `VisitFlow_API_Testing.postman_collection.json`: referensi request; periksa metadata terpilih dengan nilai sensitif disamarkan. Entri koleksi bukan bukti implementasi/deployment dan koleksi tidak dijalankan otomatis.
- `.claude/skills/` menautkan skill bersama `.agents/skills/`; `.agents/rules/visitflow.md` memuat panduan workspace. Dokumen `.agent/` berada di repository anak.

Angka endpoint, coverage, dan status quality gate di bawah adalah catatan dokumentasi yang perlu diverifikasi ulang sebelum disebut sebagai hasil terkini; bukan hasil pemeriksaan pada sesi ini.

---

## 📑 Daftar Microservices & Status Quality Gates

Berikut adalah ikhtisar seluruh microservice, port listener, jumlah endpoint, dan **catatan statement test coverage** dari dokumentasi sebelumnya:

| Microservice | Direktori | Port (Internal / Host) | Total Endpoints | Statement Coverage | Status Quality Gate |
|---|---|---|---|---|---|
| **Core Visit Flow** | [`visit-flow-go`](visit-flow-go/) | `8080` / `33033` | **232 Endpoints** | [![Coverage](https://img.shields.io/badge/Coverage-94.7%25-brightgreen?style=flat&logo=go)](visit-flow-go/test/) | **PASSED** (>= 70%) |
| **Presence & Attendance** | [`visit-flow-presence`](visit-flow-presence/) | `8080` / `33044` | **91 Endpoints** | [![Coverage](https://img.shields.io/badge/Coverage-96.0%25-brightgreen?style=flat&logo=go)](visit-flow-presence/test/) | **PASSED** (>= 70%) |
| **Survey & Location** | [`visit-flow-survey-location-go`](visit-flow-survey-location-go/) | `8080` / `33066` | **38 Endpoints** | [![Coverage](https://img.shields.io/badge/Coverage-95.4%25-brightgreen?style=flat&logo=go)](visit-flow-survey-location-go/test/) | **PASSED** (>= 70%) |
| **API Gateway & IAM** | [`visit-flow-api-gateway`](visit-flow-api-gateway/) | `9000` (Gateway) / `8090` (IAM) | **32 Endpoints** | [![Coverage](https://img.shields.io/badge/Coverage-95.2%25-brightgreen?style=flat&logo=go)](visit-flow-api-gateway/test/) | **PASSED** (>= 70%) |
| **Payroll & Payslip** | [`visit-flow-payroll`](visit-flow-payroll/) | `8080` / `21033` | **6 Endpoints** | [![Coverage](https://img.shields.io/badge/Coverage-2.4%25-yellow?style=flat&logo=go)](visit-flow-payroll/helper/) | **PASSED** (Baseline) |
| **Agent AI & Prompts** | [`visitflow-agent-ai`](visitflow-agent-ai/) | Custom AI Binary / Prompts | - | - | Engine Template |

> **Total Keseluruhan Endpoint REST API**: **399 Endpoints** di seluruh ekosistem backend.

---

## 🏛 Arsitektur & Topologi Sistem

```
                              [ Web Apps & Mobile Clients ]
                                             │
                                             ▼
                       [ Visit Flow API Gateway / KrakenD ] (Port 9000)
                                             │
      ┌──────────────────────┬───────────────┴───────────────┬──────────────────────┐
      │                      │                               │                      │
      ▼                      ▼                               ▼                      ▼
[ visit-flow-go ]   [ visit-flow-presence ]     [ visit-flow-survey-location ]  [ visit-flow-payroll ]
  (Core Visits,       (GPS Presences, Shifts,       (Outlet Surveys, Audits,      (IMAP Ingestion,
   Customers, DB)       Leaves, Corrections)           POSM, Questionnaires)        Telegram OTP)
  Port 8080             Port 8080                     Port 8080                     Port 8080
      │                      │                               │                      │
      └──────────────────────┴───────────────┬───────────────┴──────────────────────┘
                                             ▼
                              [ MySQL Read/Write Database ]
```

---

## 📁 Struktur Direktori Repositori

```plaintext
visitflow/
├── visit-flow-go/                   # Microservice inti kunjungan lapangan, customer, produk & laporan
│   └── visit-app-diagram/           # Mermaid ERD & visual workflow diagrams
├── visit-flow-presence/             # Microservice presensi, GPS geofencing, cuti & koreksi absensi
├── visit-flow-survey-location-go/   # Microservice audit survei outlet & materi promosi
├── visit-flow-api-gateway/          # Unified reverse proxy (KrakenD) & Identity Management (Gin)
├── visit-flow-payroll/              # Microservice arsip slip gaji, penarikan IMAP & 2FA Telegram OTP
├── visitflow-agent-ai/              # Template prompt & modul asisten cerdas AI
├── docs/                            # Dokumentasi arsitektur, flow & spesifikasi teknis
└── database_schema.sql              # Dump historis MySQL (DDL dan data sensitif)
```

---

## 🧪 Validasi Pengujian & Quality Gates

Setiap layanan backend Go memiliki target Makefile standar untuk pengujian, validasi linter, dan pengecekan threshold coverage:

```bash
# Contoh eksekusi pengujian di salah satu microservice:
cd visit-flow-go

# Menjalankan seluruh unit test suite
make test

# Menghasilkan kalkulasi statement coverage
make cover

# Validasi quality gate (gagal otomatis jika coverage di bawah threshold)
make check-cov

# Menjalankan linting dan static analysis
make check-all
```

---

## 🔗 Dokumentasi Terkait

- [Panduan Q&A kode, endpoint, dan database untuk agent](AGENTS.md)
- Codex, Claude Code, dan Antigravity memakai panduan bersama tersebut melalui `AGENTS.md`, `CLAUDE.md`, dan `.agents/rules/visitflow.md`. Skill utama disimpan sekali di `.agents/skills/`.
- [Dokumentasi Lengkap Mermaid ERD & Business Workflow](visit-flow-go/visit-app-diagram/README.md)
- [README visit-flow-go](visit-flow-go/README.md)
- [README visit-flow-presence](visit-flow-presence/README.md)
- [README visit-flow-survey-location-go](visit-flow-survey-location-go/README.md)
- [README visit-flow-api-gateway](visit-flow-api-gateway/README.md)
- [README visit-flow-payroll](visit-flow-payroll/README.md)
- [README visitflow-agent-ai](visitflow-agent-ai/README.md)
- [Audit, migrasi, dan benchmark historis](../visitflow-backups/historical-artifacts-2026-09-23/README.md) — disimpan di luar workspace.
