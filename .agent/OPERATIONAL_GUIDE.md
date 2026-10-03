# Panduan Operasional & Kueri Database VisitFlow

Panduan ini digunakan oleh AI Assistant untuk mengeksekusi kueri MySQL dan menjawab pertanyaan data riil, operasional, total kunjungan (call), hierarki bawahan, dan presensi.

---

## 1. Koneksi Database Production (Read-Only)

Eksekusi kueri read-only langsung menggunakan login-path MySQL lokal yang sudah terkonfigurasi:

```bash
mysql --login-path=visitflow-production-readonly --database=VISITFLOW_MF_PROD -e "START TRANSACTION READ ONLY; SELECT ...; COMMIT;"
```

> **Catatan Keamanan**:  
> - Profile ini dapat memiliki hak tulis. Bungkus setiap batch SELECT yang sudah diperiksa dalam `START TRANSACTION READ ONLY` dan akhiri dengan `COMMIT`.  
> - Selalu batasi kueri dengan waktu, perusahaan/tenant, dan scope bisnis yang relevan. Jika scope yang mengubah hasil tidak tersedia, tanyakan dulu.  
> - Jangan gunakan kredensial aplikasi dari `.env`; jangan jalankan prosedur, mutasi, atau DDL di production.

---

## 2. Resep Kueri Kunjungan (Visits / Call)

### A. Aturan Perhitungan Kunjungan Riil
1. **Total Kunjungan Sah (Call)**: **Hanya menghitung data yang MINIMAL SUDAH CHECK-OUT** (`checkout_time IS NOT NULL` / status `check-out`, `closed`, `approved`, `realization-approved`).
2. **Plan-Approved**: **TIDAK BOLEH** dihitung sebagai kunjungan/call riil karena baru berupa rencana jadwal.
3. **Check-in**: Status *in-progress* (sedang berlangsung).
4. **Joint Visit (`visit_members`)**: Jika karyawan terdaftar sebagai member di tabel `visit_members` pada kunjungan yang sudah dieksekusi (minimal check-out), kunjungan tersebut **JUGA DIHITUNG SEBAGAI KUNJUNGAN SAH BAGI KARYAWAN TERSEBUT**.

---

### B. Kueri Total Kunjungan Per Anggota Tim / Struktur (Termasuk Joint Visit `visit_members`)

Contoh kueri komprehensif untuk Area Manager / Header **`BDGA1`** beserta seluruh bawahannya pada periode aktif (misal September 2026 / `202609`), mencakup kunjungan mandiri (PIC) dan kunjungan bersama (Joint Visit):

```sql
SELECT 
    s.id AS kode_struktur,
    s.level,
    s.name AS nama_karyawan,
    -- Total Kunjungan Sah = Minimal sudah check-out (sebagai PIC langsung ATAU member joint visit)
    COUNT(DISTINCT CASE WHEN (v.checkout_time IS NOT NULL OR vm.checkout_time IS NOT NULL) THEN v.id END) AS total_kunjungan_sah,
    -- Rincian peran
    COUNT(DISTINCT CASE WHEN v.structure_id = s.id AND v.checkout_time IS NOT NULL THEN v.id END) AS kunjungan_mandiri_pic,
    COUNT(DISTINCT CASE WHEN vm.structure_id = s.id AND v.structure_id != s.id AND (v.checkout_time IS NOT NULL OR vm.checkout_time IS NOT NULL) THEN v.id END) AS joint_visit_member,
    -- Rincian status kunjungan
    COUNT(DISTINCT CASE WHEN v.status IN ('realization-approved', 'approved') THEN v.id END) AS realization_approved,
    COUNT(DISTINCT CASE WHEN v.status = 'check-out' THEN v.id END) AS check_out,
    COUNT(DISTINCT CASE WHEN v.status = 'check-in' THEN v.id END) AS check_in_ongoing,
    COUNT(DISTINCT CASE WHEN v.status = 'plan-approved' THEN v.id END) AS plan_approved
FROM structures s
LEFT JOIN (
    visits v
    LEFT JOIN visit_members vm ON vm.visit_id = v.id AND vm.deleted_at IS NULL
) ON (
    (v.structure_id = s.id OR vm.structure_id = s.id)
    AND v.deleted_at IS NULL
    AND v.period = '202609'
    AND v.type IN ('call', 'call outlet', 'joint')
)
WHERE s.company_id = 1
  AND (
      s.id = 'BDGA1'
      OR s.id IN (
          SELECT structure_id FROM structure_bos WHERE boss_structure_id = 'BDGA1'
          UNION
          SELECT structure_id FROM structure_bos WHERE boss_structure_id IN (
              SELECT structure_id FROM structure_bos WHERE boss_structure_id = 'BDGA1'
          )
      )
  )
GROUP BY s.id, s.level, s.name
ORDER BY s.level ASC, total_kunjungan_sah DESC;
```

---

### C. Kueri Kunjungan Berdasarkan Tanggal (Hari Ini / Kemarin)

Untuk memeriksa kunjungan pada tanggal tertentu (misal kemarin atau hari ini di timezone Asia/Jakarta / UTC+7):

```sql
SELECT 
    DATE(v.checkin_time) AS tanggal,
    v.structure_id AS kode_struktur,
    COALESCE(s.name, v.user_name) AS nama_karyawan,
    COUNT(CASE WHEN v.checkout_time IS NOT NULL THEN 1 END) AS total_kunjungan_sah,
    COUNT(CASE WHEN v.status IN ('realization-approved', 'approved') THEN 1 END) AS realization_approved,
    COUNT(CASE WHEN v.status = 'check-out' THEN 1 END) AS check_out,
    COUNT(CASE WHEN v.status = 'check-in' THEN 1 END) AS check_in_ongoing,
    COUNT(CASE WHEN v.status = 'plan-approved' THEN 1 END) AS plan_approved
FROM visits v
LEFT JOIN structures s ON v.structure_id = s.id AND v.company_id = s.company_id
WHERE v.deleted_at IS NULL
  AND v.checkin_time >= '2026-09-28 00:00:00' 
  AND v.checkin_time < '2026-09-29 00:00:00'
  AND v.type IN ('call', 'call outlet')
  AND (
      v.structure_id = 'BDGA1'
      OR v.structure_id IN (
          SELECT structure_id FROM structure_bos WHERE boss_structure_id = 'BDGA1'
          UNION
          SELECT structure_id FROM structure_bos WHERE boss_structure_id IN (
              SELECT structure_id FROM structure_bos WHERE boss_structure_id = 'BDGA1'
          )
      )
  )
GROUP BY DATE(v.checkin_time), v.structure_id, s.name, v.user_name
ORDER BY total_kunjungan_sah DESC;
```

---

## 3. Resep Kueri Master Customer List (MCL / `visit_customers`)

Untuk memeriksa target alokasi bulanan per dokter yang direncanakan untuk dikunjungi:

```sql
SELECT 
    vc.period,
    vc.structure_id,
    vc.customer_name,
    vc.priority,
    vc.cluster,
    vc.status AS status_approval_target
FROM visit_customers vc
WHERE vc.deleted_at IS NULL
  AND vc.period = '202609'
  AND vc.structure_id = 'BDGA1S201'
ORDER BY vc.priority ASC;
```
