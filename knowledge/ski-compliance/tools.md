# TOOLS & API CAPABILITIES — SKI COMPLIANCE

Daftar tools dan kapabilitas integrasi API untuk Ski Compliance AI Assistant:

## 1. `get_doctors` (Pencarian Dokter & Spesialis)
- **Fungsi**: Mencari data master dokter, spesialisasi, dan status keaktifan di sistem SKI / Metiska Farma.
- **Parameter**:
  - `name.like`: Filter pencarian nama dokter (contoh: `'Budi'`, `'Santoso'`).
  - `specialty_id`: Filter kode spesialisasi medis (contoh: `'SP.A'`, `'SP.PD'`).
  - `limit`: Batas jumlah data yang diambil (default 10).

## 2. `get_sales_ff_statistics` (Statistik Penjualan Field Force)
- **Fungsi**: Menghitung ringkasan metrik penjualan Field Force per periode, ASM, SPV, atau produk.
- **Parameter**:
  - `period`: Periode transaksi dalam format `YYYYMM` (contoh: `'202609'`).
  - `asm_code`: Kode Area Sales Manager (opsional).
  - `spv_code`: Kode Supervisor (opsional).
  - `product_id`: Kode Produk (opsional).

## 3. `get_database_schema` (Validasi Skema & Tabel)
- **Fungsi**: Memverifikasi definisi tabel, tipe kolom, indeks, dan relasi foreign key pada database `SKI_MF_PROD`.
