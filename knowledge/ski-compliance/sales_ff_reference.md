# DOKUMENTASI LENGKAP SALES FIELD FORCE (`SalesFf`) — SKI COMPLIANCE

Layanan `mf-micro-service-sales` (`GO-MF-MICRO-SALES`) adalah modul inti pemrosesan transaksi penjualan dan performa tim lapangan (Field Force) di SKI Metiska Farma.

---

## 1. STRUKTUR TABEL `sales_ffs`

Tabel utama di MySQL: **`sales_ffs`**

| Kolom | Tipe Data | Keterangan & Aturan |
| :--- | :--- | :--- |
| `period` | `VARCHAR(6)` | **PRIMARY KEY**. Format `YYYYMM` (Contoh: `'202609'`). |
| `outlet_id` | `VARCHAR(20)` | **PRIMARY KEY**. ID Outlet master dari SKI. |
| `outlet_name` | `VARCHAR(500)` | Nama Outlet / RS / Apotek / Klinik. |
| `outlet_address` | `TEXT` | Alamat lengkap outlet. |
| `outlet_class` | `VARCHAR(20)` | Kelas / segmentasi outlet (A, B, C, dsb). |
| `outlet_type_id` | `INT UNSIGNED` | ID Tipe Outlet. |
| `outlet_type_name` | `VARCHAR(30)` | Nama Tipe Outlet (contoh: Apotek, Rumah Sakit). |
| `product_id` | `VARCHAR(20)` | **PRIMARY KEY**. ID Produk master SKI. |
| `product_name` | `VARCHAR(500)` | Nama Produk obat / farmasi. |
| `price` | `FLOAT(12,2)` | Harga satuan produk pada periode transaksi. |
| `qty` | `FLOAT(12,2)` | Kuantitas unit yang terjual (Gross). |
| `value_sales` | `FLOAT(12,2)` | Nilai Penjualan Gross ($Price \times Qty$). |
| `divisi_id` | `VARCHAR(30)` | ID Divisi Produk / Marketing. |
| `invoice` | `VARCHAR(100)` | **PRIMARY KEY**. Nomor Faktur / Invoice dari distributor. |
| `invoice_date` | `VARCHAR(300)` | Tanggal faktur penjualan. |
| `discount_on_distributor` | `FLOAT(12,2)` | Diskon on-invoice dari distributor (persentase/nominal). |
| `discount_on_principal` | `FLOAT(12,2)` | **PRIMARY KEY**. Diskon on-invoice dari principal. |
| `total_discount_on` | `FLOAT(12,2)` | Total diskon on-invoice ($\text{Distributor} + \text{Principal}$). |
| `discount_off_distributor`| `FLOAT(12,2)` | Diskon off-invoice dari distributor. |
| `qty_claim` | `FLOAT(12,2)` | Kuantitas klaim / retur / diskon ekstra. |
| `total_claim` | `FLOAT(12,2)` | Total nominal klaim. |
| `qty_final` | `FLOAT(12,2)` | Kuantitas final setelah dikurangi klaim ($Qty - QtyClaim$). |
| `value_sales_final` | `FLOAT(12,2)` | Nilai penjualan bersih setelah klaim ($ValueSales - TotalClaim$). |
| `distributor_id` | `VARCHAR(100)` | Kode distributor sumber data. |
| `branch_distributor_id` | `VARCHAR(20)` | Kode cabang distributor. |
| `branch_distributor_name` | `VARCHAR(100)`| Nama cabang distributor. |
| `marketing_structure_id` | `VARCHAR(30)` | **PRIMARY KEY**. Kode struktur organisasi marketing. |
| `dl_df_id` | `VARCHAR(20)` | ID Detail Line / Detail Form. |
| `transaction_type` | `VARCHAR(100)` | Jenis transaksi (Penjualan, Retur, Koreksi). |
| `batch` | `VARCHAR(100)` | Nomor Batch produksi. |
| `expired_date` | `DATETIME` | Tanggal kadaluarsa produk. |
| `flag_nr` | `VARCHAR(1)` | Flag Non-Regular / Regular. |
| `closed` | `TINYINT(1)` | Status closing periode transaksi (`1` = closed, `0` = open). |
| `year` | `VARCHAR(4)` | Tahun transaksi (`'2026'`). |
| `month` | `VARCHAR(2)` | Bulan transaksi (`'09'`). |
| `mr_name` | `VARCHAR(100)` | Nama Medical Representative (MR) yang bertanggung jawab. |
| `spv_code` | `VARCHAR(30)` | Kode SPV (Supervisor). |
| `spv_name` | `VARCHAR(100)` | Nama SPV. |
| `asm_code` | `VARCHAR(30)` | Kode Area Sales Manager (ASM). |
| `asm_name` | `VARCHAR(100)` | Nama ASM. |
| `fsm_code` | `VARCHAR(30)` | Kode Field Sales Manager (FSM). |
| `fsm_name` | `VARCHAR(100)` | Nama FSM. |
| `updated_data` | `DATETIME` | Timestamp terakhir data diperbarui. |

---

## 2. TERMINOLOGI KHUSUS & REKONSILIASI
- **\`SPC\` = Credit Notes**:
  - Di seluruh laporan Sales FF, ekspor Excel, dan analisis performa SKI Compliance, istilah/kolom **\`SPC\` merujuk pada Credit Notes** (Nota Kredit).
  - Kolom seperti `spc_n` (Credit Note bulan berjalan), `spc_nmin1` s/d `spc_nmin6` (Credit Note 1 s/d 6 bulan sebelumnya), `spc_y` (Credit Note YTD tahun berjalan), dan `spc_ymin1` (Credit Note tahun sebelumnya) digunakan untuk merekonsiliasi potongan dan klaim diskon ekstra dari distributor.

---

## 3. DAFTAR ENDPOINT REST API `SalesFf`

Base path di microservice sales: `/api/v1/sales-ff`

| Method | Endpoint | Fungsi & Deskripsi |
| :--- | :--- | :--- |
| `GET` | `/api/v1/sales-ff` | Menampilkan daftar transaksi Sales FF dengan filter dinamis (`period`, `outlet_id`, `product_id`, `spv_code`, `asm_code`, `page`, `limit`). |
| `GET` | `/api/v1/sales-ff/view` | Mengambil data `SalesFfView` yang sudah dioptimasi untuk render tabel cepat. |
| `GET` | `/api/v1/sales-ff/report` | Laporan agregasi penjualan per struktur, ASM, SPV, dan produk. |
| `GET` | `/api/v1/sales-ff/report-by-structure` | Laporan breakdown hierarki pohon struktur marketing. |
| `GET` | `/api/v1/sales-ff/summary-by-period` | Ringkasan perbandingan sales antar periode (Month-over-Month / Year-over-Year). |
| `GET` | `/api/v1/sales-ff/target-by-asm` | Evaluasi pencapaian target penjualan vs aktual per ASM. |
| `GET` | `/api/v1/sales-ff/top-50-sectors` | Ranking 50 sektor penjualan teratas berdasarkan value sales. |
| `GET` | `/api/v1/sales-ff/otx` | Laporan penjualan produk OTX (Over-the-Counter). |
| `GET` | `/api/v1/sales-ff/morses-stock` | Laporan monitoring pergerakan stok Morses di distributor. |
| `GET` | `/api/v1/sales-ff/morses-stock-ed-1y` | Laporan stok Morses yang mendekati masa expired (< 1 tahun). |
| `POST`| `/api/v1/sales-ff/calculate` | Memicu proses kalkulasi ulang Sales FF dari data distributor via Redis Worker. |
| `POST`| `/api/v1/sales-ff/close-period` | Mengunci periode penjualan agar tidak dapat diubah kembali. |
| `POST`| `/api/v1/sales-ff/send-mail-otx` | Mengirimkan laporan penjualan OTX via email otomatis ke manajemen. |
| `POST`| `/api/v1/sales-ff/send-mail-morses`| Mengirimkan laporan evaluasi stok Morses via email ke seluruh ASM. |

---

## 3. RELASI & ALUR KERJA DARI DISTRIBUTOR KE SALES FF

```
1. Ingest Data Distributor
   [File CSV/Excel/API Distributor] ──► Tabel `sales_distributors` & `stock_distributors`
                                              │
2. Master Bridging Check                      ▼
   Verifikasi Outlet:  `bridging_outlets`   (Distributor Outlet Code ──► SKI Outlet ID)
   Verifikasi Produk:  `bridging_products`  (Distributor Product Code ──► SKI Product ID)
                                              │
3. Territory & Structure Mapping             ▼
   Mapping Teritori Outlet: `customer_territory_outlets`
   Mapping Struktur Tim:    `marketing_structures` (MR ──► SPV ──► ASM ──► FSM)
                                              │
4. Extra Discount & Target Evaluation        ▼
   Diskon Ekstra: `distributor_extra_discounts` & `distributor_extra_discount_claims`
   Target Bulanan: `target_marketings`
                                              │
5. Final Calculation Engine (Redis Queue)     ▼
   Eksekusi Kalkulasi Bersih ────────► Tabel Final: `sales_ffs`
```
