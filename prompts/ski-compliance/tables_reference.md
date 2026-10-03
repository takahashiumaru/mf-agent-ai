# REFERENSI TABEL & SKEMA DATABASE LENGKAP — SKI COMPLIANCE (`SKI_MF_PROD`)

Katalog skema dan referensi relasi tabel terverifikasi di database MySQL **`SKI_MF_PROD`** (183 tabel base, 78 views, 131 stored routines).

---

## 1. DOMAIN SALES, LAPORAN & TRANSAKSI

### A. `sales_ffs` (Sales Field Force)
- **Tujuan**: Menyimpan data detail transaksi penjualan tim Field Force per faktur, outlet, produk, dan hierarki sales.
- **Primary Key**: `(period, outlet_id, product_id, invoice, marketing_structure_id, discount_on_principal, qty, dl_df_id)`
- **Indeks Utama**: `idx_period`, `idx_outlet_id`, `idx_product_id`, `idx_invoice`, `idx_marketing_structure_id`, `idx_spv_code`, `idx_asm_code`, `idx_fsm_code`, `idx_closed`.
- **Kolom Kunci & Nama Resmi**:
  - `period` (`VARCHAR(6)`, format `YYYYMM`)
  - `invoice` (`VARCHAR(100)`) $\rightarrow$ **Nomor Faktur / Invoice (BUKAN `invoice_no`)**
  - `invoice_date` (`VARCHAR(300)`) $\rightarrow$ **Tanggal Faktur (BUKAN `transaction_date`)**
  - `outlet_id` (`VARCHAR(20)`), `outlet_name` (`VARCHAR(500)`), `outlet_class`, `outlet_type_name`
  - `product_id` (`VARCHAR(20)`), `product_name` (`VARCHAR(500)`), `divisi_id`
  - `price` (`FLOAT`), `qty` (`FLOAT(12,2)`), `value_sales` (`DECIMAL(18,0)`) $\rightarrow$ Nilai Kotor ($Price \times Qty$)
  - `discount_on_distributor`, `discount_on_principal`, `total_discount_on`, `discount_off_distributor`
  - `qty_claim`, `total_claim` (`FLOAT(12,2)`) $\rightarrow$ **Nominal Klaim (BUKAN `claim_amount`)**
  - `qty_final`, `value_sales_final` (`DECIMAL(18,0)`) $\rightarrow$ Nilai Bersih Final
  - `distributor_id`, `branch_distributor_id`, `branch_distributor_name`
  - `marketing_structure_id`, `mr_name`, `spv_code`, `spv_name`, `asm_code`, `asm_name`, `fsm_code`, `fsm_name`
  - `closed` (`TINYINT`), `year` (`VARCHAR(4)`), `month` (`VARCHAR(2)`), `updated_data`
  - **PENTING**: TIDAK MEMILIKI `deleted_at`, `company_id`, `transaction_date`, atau `claim_amount`!

### B. `credit_notes` (Credit Notes / Nota Kredit / SPC)
- **Tujuan**: Tabel transaksi resmi Credit Notes (CN) / SPC untuk klaim retur, diskon ekstra, dan penyesuaian komersial kesepakatan dokter.
- **Primary Key**: `(discount_proposal_id, outlet_id, customer_id, product_id, marketing_structure_id, period, invoice_no, invoice_date)`
- **Kolom Kunci & Nama Resmi**:
  - `period` (`VARCHAR(6)`, format `YYYYMM`)
  - `invoice_no` (`VARCHAR(50)`) $\rightarrow$ Nomor Invoice
  - `invoice_date` (`VARCHAR(10)`) $\rightarrow$ Tanggal Faktur (format `YYYY-MM-DD`)
  - `discount_proposal_id` (`VARCHAR(20)`) $\rightarrow$ ID Pengajuan Diskon / Kesepakatan
  - `customer_id` (`VARCHAR(20)`) $\rightarrow$ ID Dokter
  - `outlet_id` (`VARCHAR(20)`) $\rightarrow$ ID Faskes / Outlet
  - `product_id` (`VARCHAR(20)`) $\rightarrow$ ID Produk
  - `marketing_structure_id` (`VARCHAR(200)`), `distributor_id` (`VARCHAR(10)`)
  - `qty` (`FLOAT(12,2)`), `percent_on` (`FLOAT(12,2)`), `percent_off` (`FLOAT(12,2)`)
  - `value` (`DOUBLE`) $\rightarrow$ **Nilai Nominal Rupiah Credit Note (CN / SPC)**
  - `is_closed` (`TINYINT(1)`), `closed_time` (`DATETIME(3)`)
  - `deleted_at` (`DATETIME(3)`) $\rightarrow$ **WAJIB menggunakan filter `deleted_at IS NULL`**

### C. `sales_distributors` (Sales Ingest Distributor)
- **Tujuan**: Data transaksi mentah dari distributor sebelum masuk ke kalkulasi Field Force.
- **Kolom Kunci**: `invoice`, `invoice_date`, `distributor_id`, `branch_distributor_id`, `outlet_id`, `outlet_name`, `product_id`, `product_name`, `price`, `qty`, `value_sales`, `is_bridging`, `period` (`VARCHAR(6)`).

### D. `stock_distributors` (Stok Distributor)
- **Tujuan**: Pelacakan pergerakan stok produk di gudang distributor per periode `YYYYMM`.
- **Kolom Kunci**: `period` (`YYYYMM`), `distributor_id`, `branch_distributor_id`, `product_id`, `beginning_stock`, `incoming_stock`, `sales_out`, `ending_stock`, `adj_stock`.

### E. `target_marketing` (Target Penjualan Marketing)
- **Tujuan**: Penetapan target kuantitas dan nominal penjualan per struktur/MR dan produk.
- **Kolom Kunci**: `period` (`VARCHAR(8)`, `YYYYMMDD` / `YYYYMM`), `code_mr`, `product_code`, `qty`, `qty_non_routine`, `value`, `value_non_routine`, `deleted_at`.

### F. `bridging_outlets` & `bridging_products` (Master Data Bridging)
- **Tujuan**: Menghubungkan ID outlet dan produk dari distributor ke master ID SKI.
- **`bridging_outlets`**: `distributor_id`, `distributor_outlet_id`, `distributor_outlet_name`, `outlet_id` (SKI), `is_verified`, `created_at`, `updated_at`.
- **`bridging_products`**: `distributor_id`, `distributor_product_id`, `distributor_product_name`, `product_id` (SKI), `is_verified`, `created_at`, `updated_at`.

---

## 2. DOMAIN KESEPAKATAN DOKTER (SKI) & PROPOSAL DISKON

### A. `discount_proposals` (Proposal Diskon / Kesepakatan SKI)
- **Tujuan**: Menyimpan berkas pengajuan kesepakatan komersial dengan dokter (komitmen resep, diskon, sponsorship).
- **Primary Key**: `id` (`VARCHAR(20)`)
- **Kolom Kunci**:
  - `id`, `distributor_id`, `division_id`, `marketing_structure_id`
  - `period` (`VARCHAR(6)`, `YYYYMM`), `period_start` (`VARCHAR(8)`), `period_end` (`VARCHAR(8)`)
  - `amount_actual` (`DOUBLE`), `amount_estimation` (`DOUBLE`), `amount_tax` (`DOUBLE`)
  - `status` (`VARCHAR(20)`: `APPROVE`, `INPUT`, `CONFIRM`, `CONFIRM LV2`..`LV6`, `REJECT`, `BATAL`, `TEMPORARY`)
  - `type` (`VARCHAR(4)`), `event_header_id`, `discount_proposal_category_detail_id`, `deleted_at`.

### B. `discount_proposal_payments` (Pembayaran / Transfer Dana SKI)
- **Tujuan**: Tabel transaksi pembayaran dan pencairan dana transfer kesepakatan dokter / proposal diskon.
- **Primary Key**: `id` (`BIGINT UNSIGNED AUTO_INCREMENT`)
- **Kolom Kunci & Nama Resmi**:
  - `discount_proposal_id` (`VARCHAR(20)`) $\rightarrow$ Relasi ke ID Proposal
  - `customer_id` (`VARCHAR(20)`) $\rightarrow$ ID Dokter penerima
  - `period` (`VARCHAR(6)`, `YYYYMM`) $\rightarrow$ Periode Pembayaran / Proposal
  - `transferred` (`TINYINT(1)`) $\rightarrow$ Status Transfer (**1 = Sudah Di-Transfer**, 0 = Belum)
  - `transferred_at` (`DATETIME(3)`) $\rightarrow$ Timestamp Aktual Transfer Dana
  - `transferred_amount` (`DECIMAL(18,0)`) $\rightarrow$ **Nominal Dana yang Sudah Di-Transfer**
  - `submission_amount` (`DECIMAL(18,0)`) $\rightarrow$ Nominal Pengajuan Awal
  - `canceled_transferred` (`TINYINT(1)`) $\rightarrow$ Flag Pembatalan Transfer (0 / NULL = Valid, 1 = Batal)
  - `status_transferred` (`VARCHAR(10)`), `memo_no`, `rangkuman_no`, `account_no`, `bank_transfer_fee`
  - `deleted_at` (`DATETIME(3)`) $\rightarrow$ **WAJIB menggunakan filter `deleted_at IS NULL`**
- **Query Standar SKI yang Sudah Di-Transfer**:
  ```sql
  SELECT 
      period,
      COUNT(*) AS total_transaksi_transfer,
      SUM(transferred_amount) AS total_nominal_transfer,
      MIN(transferred_at) AS transfer_pertama,
      MAX(transferred_at) AS transfer_terakhir
  FROM discount_proposal_payments
  WHERE deleted_at IS NULL
    AND transferred = 1
    AND (canceled_transferred = 0 OR canceled_transferred IS NULL)
  GROUP BY period
  ORDER BY period DESC;
  ```

### C. `discount_proposal_estimations` (Estimasi Nilai SKI / Kesepakatan yang Approve)
- **Tujuan**: Detail estimasi produk, kuantitas, dan total nominal rupiah komitmen perjanjian dokter yang telah diajukan.
- **Primary Key**: `id` (`BIGINT UNSIGNED AUTO_INCREMENT`)
- **Kolom Kunci & Nama Resmi**:
  - `discount_proposal_id` (`VARCHAR(20)`) $\rightarrow$ Relasi ke `discount_proposals.id`
  - `customer_id` (`VARCHAR(20)`), `outlet_id` (`VARCHAR(20)`), `product_id` (`VARCHAR(20)`)
  - `product_price` (`FLOAT`), `product_quantity` (`FLOAT(12,2)`)
  - `total` (`FLOAT`) $\rightarrow$ **Nilai Nominal Estimasi Perjanjian SKI (Rupiah)**
  - `distributor_discount_percent_off`, `principal_discount_percent_off`, `is_active`
  - `deleted_at` (`DATETIME(3)`) $\rightarrow$ **WAJIB `deleted_at IS NULL`**
- **Query Standar Estimasi SKI yang di-Approve**:
  ```sql
  SELECT 
      dp.period,
      COUNT(DISTINCT dp.id) AS total_proposal_approved,
      COUNT(dpe.id) AS total_item_estimasi,
      SUM(dpe.total) AS total_nominal_estimasi
  FROM discount_proposals dp
  INNER JOIN discount_proposal_estimations dpe 
      ON dp.id = dpe.discount_proposal_id 
      AND dpe.deleted_at IS NULL
  WHERE dp.deleted_at IS NULL
    AND dp.status = 'APPROVE'
  GROUP BY dp.period
  ORDER BY dp.period DESC;
  ```

### D. `master_document_proposals` & `proposal_document_statuses`
- **Tujuan**: Manajemen kelengkapan berkas fisik dan digital perjanjian kerjasama dokter.

---

## 3. DOMAIN MASTER DATA & STRUKTUR

### A. `customers` (Master Dokter & Tenaga Medis)
- **Primary Key**: `id` (`VARCHAR(20)`)
- **Kolom Kunci**: `id`, `name`, `specialty_id`, `sub_specialty_id`, `phone`, `email`, `status` (`VARCHAR(25)`), `deleted_at` (`DATETIME(3)`).
- **Catatan**: Tidak ada kolom `company_id`.

### B. `outlets` (Master Outlet / Faskes)
- **Primary Key**: `id` (`VARCHAR(20)`)
- **Kolom Kunci**: `id`, `name`, `address`, `city_id`, `province_id`, `outlet_type_id`, `is_active` (`TINYINT(1)`), `deleted_at` (`DATETIME(3)`).

### C. `accounts` (Rekening Bank Dokter/Customer)
- **Primary Key**: `id` (`BIGINT UNSIGNED`)
- **Kolom Kunci**: `id`, `customer_id`, `bank_id`, `bank_branch_id`, `account_number`, `account_name`, `is_active`, `deleted_at`.

### D. `marketing_structures` (Struktur Organisasi Sales)
- **Primary Key**: `id` (`VARCHAR(30)`)
- **Kolom Kunci**: `id`, `period` (`VARCHAR(6)`, `YYYYMM`), `user_id`, `parent_id`, `level_id`, `role_name`, `area_id`, `deleted_at`.

### E. `customer_territory_outlets` (Pemetaan Teritori Outlet)
- **Kolom Kunci**: `period` (`VARCHAR(6)`, `YYYYMM`), `customer_id`, `outlet_id`, `territory_id`, `deleted_at`.

### F. `product_prices` (Master Harga Produk)
- **Kolom Kunci**: `product_id`, `period` (`YYYYMM`), `hna` (Harga Netto Apotek), `het` (Harga Eceran Tertinggi), `price`, `effective_date`.

### G. `status_closings` (Kunci Periode Finansial & Sales)
- **Kolom Kunci**: `period` (`VARCHAR(8)`, `YYYYMMDD`), `is_closed` (`TINYINT(1)`), `module` (`VARCHAR(50)`), `closed_by`, `closed_at`.

---

## 4. RELASI & CONTOH QUERY TERVERIFIKASI

### Query 1: Total Sales FF per ASM pada Periode Tertentu
```sql
SELECT 
    asm_code,
    asm_name,
    COUNT(DISTINCT invoice) AS total_invoices,
    COUNT(DISTINCT outlet_id) AS total_outlets,
    SUM(qty_final) AS total_qty_final,
    SUM(value_sales_final) AS total_value_final
FROM sales_ffs
WHERE period = '202609'
GROUP BY asm_code, asm_name
ORDER BY total_value_final DESC;
```

### Query 2: Ringkasan Proposal Diskon Dokter per Status
```sql
SELECT 
    status,
    COUNT(*) AS total_proposal,
    SUM(amount_actual) AS total_nominal_aktual,
    SUM(amount_estimation) AS total_nominal_estimasi
FROM discount_proposals
WHERE deleted_at IS NULL
GROUP BY status
ORDER BY total_proposal DESC;
```

### Query 3: Rekap Credit Notes (CN / SPC) 12 Periode Terakhir
```sql
SELECT 
    period,
    COUNT(*) AS total_dokumen_cn,
    MIN(invoice_date) AS tanggal_invoice_pertama,
    MAX(invoice_date) AS tanggal_invoice_terakhir,
    SUM(value) AS total_nominal_cn
FROM SKI_MF_PROD.credit_notes
WHERE deleted_at IS NULL
GROUP BY period
ORDER BY period DESC
LIMIT 12;
```

### Query 4: Rekap Sales FF & Klaim 12 Periode Terakhir
```sql
SELECT 
    period,
    COUNT(*) AS total_transaksi,
    MIN(invoice_date) AS tanggal_invoice_pertama,
    MAX(invoice_date) AS tanggal_invoice_terakhir,
    SUM(value_sales) AS gross_sales_value,
    SUM(total_claim) AS total_klaim,
    SUM(value_sales_final) AS final_sales_value
FROM SKI_MF_PROD.sales_ffs
GROUP BY period
ORDER BY period DESC
LIMIT 12;
```

