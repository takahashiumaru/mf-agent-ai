# Domain Lengkap VisitFlow

Dokumen ini adalah referensi kanonikal domain bisnis dan operasional seluruh sistem **VisitFlow** (Core Visit, Presence, Survey, Gateway, Payroll).

---

## 1. Domain Kunjungan (Visits) vs MCL (Visit Customers) vs Master Customer

| Konsep Lapangan | Tabel Utama | Definisi & Sifat Data | Syarat Sah Disebut Kunjungan (Call) |
| :--- | :--- | :--- | :--- |
| **Kunjungan Aktual Lapangan** | **`visits`** | Data eksekusi nyata kunjungan di lapangan oleh Medical Representative (MR) / Sales. Mencatat koordinat GPS (`checkin_latitude`, `checkin_longitude`), radius, foto bukti (`proof_photo`), tanda tangan (`proof_signature`), produk yang dipromosikan (`visit_products`), dan waktu aktual (`checkin_time`, `checkout_time`). | **MINIMAL SUDAH CHECK-OUT** (`checkout_time IS NOT NULL` atau status `check-out`, `closed`, `realization-approved` / `approved`). |
| **MCL (Master Customer List)** | **`visit_customers`** | Data **rencana dan alokasi target bulanan** per perwakilan/struktur (`structure_id`) untuk suatu periode (`period` format `YYYYMM`, misal `202609`). Berisi status approval target (`draft`, `submitted`, `approved`, `rejected`), prioritas dokter, cluster, level. | **BUKAN KUNJUNGAN**. Ini adalah daftar target perencanaan, bukan realisasi. |
| **Master Dokter / Customer** | **`master_customers`** / `/customers/no-auth` | Data induk identitas profil dokter/pelanggan secara global (nama, NIK/KTP, NPWP, spesialisasi melalui `customer_specialist`, posisi melalui `customer_position`, alamat, status aktif/nonaktif). | Master entitas profil. |
| **Master Lokasi / Outlet** | **`locations`** / **`customer_locations`** | Data fisik rumah sakit, klinik, atau apotek tempat dokter berpraktek yang menjadi titik GPS kunjungan. | Master tempat praktek/tujuan. |

---

## 2. Aturan Bisnis & Status Kunjungan (Visits Lifecycle)

### Alur Status Kunjungan
```text
draft -> plan-approved -> check-in -> check-out -> realization-approved
          \-> plan-rejected             \-> realization-rejected
```

### Rincian Status:
1. **`plan-approved`**:
   - **ARTI**: Rencana jadwal kunjungan yang telah disetujui atasan.
   - **ATURAN MUTLAK**: **BUKAN KUNJUNGAN**. Tim belum berada di lokasi dan belum ada tindakan fisik di lapangan. Dilarang keras menjumlahkan *Plan Approved* ke dalam angka "Total Kunjungan" / Realisasi Call!
2. **`check-in`**:
   - **ARTI**: Tim MR sudah berada di lokasi dan melakukan check-in GPS.
   - **STATUS**: Masih berlangsung (*In-Progress*), belum selesai.
3. **`check-out`**:
   - **ARTI**: Tim MR telah menyelesaikan interaksi, mengisi catatan/produk/bukti, dan mencatat waktu check-out.
   - **STATUS**: **SUDAH SAH DIHITUNG KUNJUNGAN (CALL)**.
4. **`realization-approved` / `approved` / `closed`**:
   - **ARTI**: Kunjungan selesai (sudah check-out) dan telah disetujui/ditutup oleh atasan/sistem.
   - **STATUS**: **KUNJUNGAN SAH LENGKAP**.

---

## 3. Joint Visit & Anggota Kunjungan (`visit_members`)

- **Definisi Joint Visit**: Kunjungan bersama yang dilakukan oleh lebih dari satu orang perwakilan/atasan (misal MR bersama Supervisor/Manager).
- **Tabel `visit_members`**: Menyimpan data anggota (`structure_id`, `user_id`) yang ikut serta mendampingi pada suatu transaksi kunjungan (`visit_id`).
- **ATURAN PERHITUNGAN KUNJUNGAN JOINT VISIT**:
  - Jika seorang karyawan terdaftar sebagai anggota di tabel **`visit_members`** pada suatu kunjungan yang telah dieksekusi (minimal sudah check-out), kunjungan tersebut **JUGA DIHITUNG SEBAGAI KUNJUNGAN SAH BAGI ANGGOTA TERSEBUT**.
  - Total kunjungan seorang karyawan = **Kunjungan sebagai PIC/Lead Utama (`visits.structure_id`)** + **Kunjungan sebagai Member Joint Visit (`visit_members.structure_id`)**.

1. **Struktur (`structures`)**:
   - Mewakili posisi penempatan karyawan dalam wilayah dan hierarki organisasi untuk periode tertentu (`period` YYYYMM, misal `202609`).
   - Setiap struktur memiliki `id` (misal: `BDGA1`, `SMDA1S101`), `name`, `level` (Level 1: MR/Sales lapangan, Level 2: District/Area Supervisor, Level 3: Area Manager / Header).
2. **Relasi Atasan-Bawahan (`structure_bos`)**:
   - Menghubungkan struktur karyawan (`structure_id`) dengan struktur atasannya (`boss_structure_id`).
   - Untuk mencari **seluruh bawahan** dari seorang manajer/header (misal `BDGA1`):
     - Struktur bawahan langsung: `boss_structure_id = 'BDGA1'`
     - Struktur bawahan tidak langsung (bawahan dari bawahan): Menggunakan recursive lookup atau join berlapis pada `structure_bos`.

---

## 4. Domain Lainnya

- **Presensi / Kehadiran (`presences`)**: Data absensi harian karyawan (check-in, check-out kantor/lokasi, pengenalan wajah, koordinat).
- **Cuti (`leaves`)**: Pengajuan dan persetujuan cuti per periode/kuota.
- **Koreksi Absensi (`attendance_corrections`)**: Pengajuan perbaikan jam absensi yang memerlukan persetujuan atasan dan HRD.
- **Survei Lokasi (`outlet_surveys`)**: Pengisian kuisioner dan audit outlet/distributor di lapangan.
- **Payroll**: Slip gaji pegawai berbasis NIP.
