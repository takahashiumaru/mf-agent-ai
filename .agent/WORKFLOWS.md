# Workflow & Diagram VisitFlow

Dokumentasi alur proses bisnis utama sistem VisitFlow.

---

## 1. Alur Siklus Hidup Kunjungan (Visit Lifecycle)

```mermaid
stateDiagram-v2
    [*] --> Draft : Buat Rencana Kunjungan
    Draft --> PlanApproved : Disetujui Atasan (Plan Approval)
    Draft --> PlanRejected : Ditolak Atasan
    
    PlanApproved --> CheckIn : MR Check-In di Lokasi (GPS & Foto)
    note right of PlanApproved: Plan Approved BUKAN Kunjungan!\nBaru rencana jadwal kerja.
    
    CheckIn --> CheckOut : MR Selesai & Input Bukti/Produk
    note right of CheckIn: In-Progress di Lapangan
    
    CheckOut --> RealizationApproved : Disetujui Atasan (Realization Approval)
    CheckOut --> RealizationRejected : Ditolak Atasan
    
    RealizationApproved --> Closed : Kunjungan Selesai & Ditutup
    note right of CheckOut: MINIMAL CHECK-OUT\nSudah Sah Dihitung Kunjungan (Call)
```

---

## 2. Alur Master Customer List (MCL)

```mermaid
flowchart TD
    A["Master Dokter (master_customers)"] --> B["Pengajuan Alokasi Bulanan (visit_customers)"]
    B --> C{"Persetujuan Atasan (MCL Approval)"}
    C -->|Approved| D["Target Resmi Periode YYYYMM"]
    C -->|Rejected| E["Target Ditolak"]
    D --> F["Jadwal Kunjungan (visits draft/plan-approved)"]
    F --> G["Kunjungan Lapangan (visits checkin/checkout)"]
```

---

## 3. Alur Presensi & Cuti (Presence & Leave)

- **Presensi Harian**: Check-in (wajah + GPS kantor) $\rightarrow$ Aktivitas kerja $\rightarrow$ Check-out (wajah + GPS).
- **Cuti**: Pengajuan (`input`) $\rightarrow$ Validasi kuota cuti tahun lalu & tahun ini $\rightarrow$ Approval Boss $\rightarrow$ Approval HRD (`approved hrd`).
- **Koreksi Absensi**: Pengajuan (`input`) $\rightarrow$ Approval Boss $\rightarrow$ Approval HRD $\rightarrow$ Mutasi ke tabel presensi.
