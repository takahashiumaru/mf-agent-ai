# ATURAN & PANDUAN DOMAIN SKI COMPLIANCE

## 1. INTEGRITAS SKEMA & STRUKTUR TABEL (STRICT EVIDENCE RULES)
1. **Grain & Primary Key Disiplin**:
   - `sales_ffs`: Grain transaksi berada pada level `(period, outlet_id, product_id, invoice, marketing_structure_id, discount_on_principal, qty, dl_df_id)`.
   - **KOLOM RESMI \`sales_ffs\`**:
     - Nomor Invoice: **\`invoice\`** (BUKAN \`invoice_no\`!)
     - Tanggal Transaksi: **\`invoice_date\`** (BUKAN \`transaction_date\`!)
     - Nilai Penjualan Kotor: **\`value_sales\`** atau \`(price * qty)\`
     - Nilai Klaim: **\`total_claim\`** (BUKAN \`claim_amount\`!)
     - Nilai Bersih: **\`value_sales_final\`**
     - **DILARANG MENGGUNAKAN**: \`deleted_at\`, \`company_id\`, \`transaction_date\`, atau \`claim_amount\` pada tabel \`sales_ffs\`.
   - `credit_notes`: **Tabel Utama untuk Transaksi Credit Notes (CN / SPC)**
     - Kolom: \`period\` (\`YYYYMM\`), \`invoice_no\`, \`invoice_date\` (\`YYYY-MM-DD\`), \`discount_proposal_id\`, \`customer_id\`, \`outlet_id\`, \`product_id\`, \`value\` (nominal rupiah CN).
     - **WAJIB FILTER**: \`deleted_at IS NULL\`.
   - `customers`: Memiliki kolom `id` (varchar 20), `status` (varchar 25), `deleted_at`. **TIDAK MEMILIKI \`company_id\`**.
   - `outlets`: Memiliki kolom `id` (varchar 20), `is_active` (tinyint 1), `deleted_at`. Status aktif ditentukan oleh `is_active = 1` dan `deleted_at IS NULL`.
   - `accounts`: Memiliki kolom `id` (bigint unsigned), `is_active`, `deleted_at`.

2. **Aturan Format Periode (Period Semantics)**:
   - Format **\`YYYYMM\`** (varchar 6): Digunakan pada `sales_ffs.period`, `credit_notes.period`, `customer_territory_outlets.period`, `marketing_structures.period`, `target_marketings.period`, `stock_distributors.period`. Contoh: `'202609'`.
   - Format **\`YYYYMMDD\`** (varchar 8): Digunakan pada `status_closings.period`, `event_classes.period_start`, `event_classes.period_end`.
   - Format **\`YYYY-MM\`**: Digunakan pada query sinkronisasi ETL tertentu.
   - **JANGAN PERNAH** mencampuradukkan format YYYYMM dengan YYYYMMDD tanpa konversi eksplisit.

3. **Status Closing & Periode Terkunci**:
   - Sebelum kalkulasi transaksi sales final, selalu periksa status closing periode di tabel `status_closings` atau kolom `sales_ffs.closed` / `credit_notes.is_closed`.

---

## 2. FORMULA, TERMINOLOGI & KALKULASI CREDIT NOTES (CN / SPC) & SALES FF
1. **Terminologi Kunci**:
   - **\`CN\` / \`SPC\` (Credit Notes)**: Di SKI Compliance, pertanyaan mengenai **Credit Notes (CN / SPC)** merujuk ke tabel **\`credit_notes\`** (dengan kolom nominal \`value\` dan filter \`deleted_at IS NULL\`).
   - Jangan salah mencari CN ke tabel `sales_ffs` kecuali pengguna secara spesifik menanyakan kolom klaim (`total_claim`) di Sales FF!
   - Kolom-kolom report seperti `spc_n`, `spc_nmin1` s/d `spc_nmin6`, `spc_y`, `spc_ymin1` menunjukkan nilai **Credit Notes** pada bulan berjalan ($N$), bulan-bulan sebelumnya ($N-1 \dots N-6$), tahun berjalan ($Y$), dan tahun lalu ($Y-1$).

2. **Gross Sales Value**:
   $$\text{ValueSales} = \text{Price} \times \text{Qty}$$
3. **Diskon Distributor & Principal**:
   - $\text{TotalDiscountOn} = \text{DiscountOnDistributor} + \text{DiscountOnPrincipal}$
   - $\text{DiscountOffDistributor}$: Diskon off-invoice dari distributor.
4. **Klaim & Nilai Akhir (Final Sales)**:
   - $\text{QtyFinal} = \text{Qty} - \text{QtyClaim}$
   - $\text{ValueSalesFinal} = \text{ValueSales} - \text{TotalClaim}$
5. **Hirarki Field Force**:
   - `MRName`: Medical Representative (Level Pelaksana).
   - `SPVCode` & `SPVName`: Supervisor / District Manager.
   - `ASMCode` & `ASMName`: Area Sales Manager.
   - `FSMCode` & `FSMName`: Field Sales Manager / Regional Manager.
   - `MarketingStructureID`: Kode mapping struktur organisasi pemasaran pada periode terkait.

---

## 3. MASTER BRIDGING & DISTRIBUTOR
- Data invoice dari distributor masuk ke `sales_distributors`.
- `bridging_outlets` memetakan `(distributor_id, distributor_outlet_id)` $\rightarrow$ `outlet_id` master.
- `bridging_products` memetakan `(distributor_id, distributor_product_id)` $\rightarrow$ `product_id` master.
- Transaksi yang belum ter-bridge (`is_bridging = 0`) harus diselesaikan agar masuk ke perhitungan `sales_ffs`.

---

## 4. PEDOMAN QUERY SQL (READ-ONLY)
- Selalu gunakan syntax MySQL 8.x yang valid.
- Gunakan half-open range untuk tanggal (`invoice_date >= '...' AND invoice_date < '...'`).
- Batasi query detail dengan `LIMIT 100` atau `LIMIT 200` untuk menjaga performa.
- Gunakan alias tabel yang jelas dan hindari perkalian baris (*cartesian product*) pada multi-table joins.

---

## 5. ORCHESTRATION, ANALISIS KRITIS & MATRIKS TANGGUNG JAWAB TABEL (ANTI-HALLUCINATION)

Setiap permintaan/pertanyaan wajib melalui filter orkestrasi berbasis bukti (*source code & schema evidence*):

| Domain / Kebutuhan Data | Sumber Tabel Yang Benar | Sumber Yang SALAH / Wajib Ditolak | Catatan Integritas |
|---|---|---|---|
| **Realisasi Sales Aktual (Omset/Value/Qty)** | `sales_ffs` (Field Force level) & `sales_distributors` (Distributor level) | `discount_proposals`, `master_document_proposals`, `events` | `discount_proposals` **hanya** berisi pengajuan rencana diskon/kesepakatan dokter, **BUKAN** data transaksi invoice penjualan riil! |
| **SKI yang Sudah Di-Transfer / Pembayaran** | `discount_proposal_payments` | `discount_proposals`, `sales_ffs` | Filter wajib: `transferred = 1 AND (canceled_transferred = 0 OR canceled_transferred IS NULL) AND deleted_at IS NULL`. Kolom nominal: `transferred_amount`. |
| **Estimasi Nilai SKI (Disetujui / Approve)** | `discount_proposal_estimations` JOIN `discount_proposals` | `sales_ffs`, `credit_notes` | Filter wajib: `dp.status = 'APPROVE' AND dp.deleted_at IS NULL AND dpe.deleted_at IS NULL`. Kolom nominal: `dpe.total`. |
| **Kesepakatan Dokter (SKI / Komitmen)** | `discount_proposals`, `master_document_proposals`, `customer_territory_products` | `sales_ffs` (bukan penyimpan dokumen kesepakatan) | Digunakan untuk mencatat komitmen kerjasama & persetujuan diskon dokter. |
| **Credit Notes (SPC)** | `credit_notes` (transaksi detail) / kolom `spc_n` pada aggregate | Tabel produk, tabel master regulasi | `SPC` secara mutlak adalah **Credit Notes (Nota Kredit)** / potongan penyesuaian klaim retur & diskon (`credit_notes.value`). |
| **Target Penjualan** | `target_marketings` | `discount_proposals` | Target bulanan per struktur marketing dan produk (`YYYYMM`). |
| **Master Dokter / Faskes** | `customers` (status, deleted_at) & `outlets` (is_active, deleted_at) | Tabel non-eksisten seperti `doctors` / `mcl` (MCL milik VisitFlow) | Di SKI, dokter adalah `customers` dan faskes adalah `outlets`. |
| **Stok Gudang Distributor** | `stock_distributors` | `sales_ffs` | Menyimpan kuantiti stok akhir distributor per periode `YYYYMM`. |

### Aturan Self-Improvement & Skeptical Analysis:
1. **Analisis Kritis & Tolak Asumsi Keliru**: Jangan pernah menelan mentah-mentah pertanyaan atau klaim yang bertentangan dengan arsitektur data. Jika pengguna/pertanyaan mengasumsikan sales dihitung dari tabel proposal diskon, koreksi secara sopan dan jelaskan bahwa data transaksi riil ada di `sales_ffs`. Jika bertanya pembayaran/transfer, arahkan ke `discount_proposal_payments`. Jika estimasi yang di-approve, arahkan ke `discount_proposal_estimations`.
2. **Belajar & Mengembangkan Konteks**: Simpan dan terapkan setiap aturan domain baru yang terverifikasi (seperti `SPC` = Credit Notes, pembayaran transfer = `discount_proposal_payments`, estimasi approve = `discount_proposal_estimations`) ke seluruh penalaran berikutnya.

---

## 6. FORMAT PENYAJIAN ANGKA & NOMINAL RUPIAH (RAMAH PENGGUNA)
1. **Penyebutan Verbal Juta / Miliar / Triliun**:
   - Selalu sertakan sebutan verbal yang jelas di samping angka lengkap, misalnya:
     - `Rp 114.064.098.251` $\rightarrow$ **\`Rp 114,06 Miliar\`** (\`Rp 114.064.098.251\`)
     - `Rp 12.439.877.675` $\rightarrow$ **\`Rp 12,44 Miliar\`**
     - `Rp 1.510.193.066` $\rightarrow$ **\`Rp 1,51 Miliar\`** (\`1.510 Juta\`)
     - `Rp 350.000.000` $\rightarrow$ **\`Rp 350 Juta\`**
2. **Tabel Ringkasan & Visualisasi**:
   - Saat menyajikan tabel data per periode atau per produk, sediakan kolom **Nilai Ringkas (Jt / Miliar)** di samping **Nominal Lengkap (Rp)** agar eksekutif dan user dapat langsung membaca nilai dengan cepat tanpa menghitung digit nol.

