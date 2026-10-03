# PANDUAN DOMAIN & ENTITAS SKI COMPLIANCE

## 1. Domain Terminology & Vocabulary
- **Kesepakatan Kerjasama Dokter (SKI / Surat Kesepakatan / Proposal Diskon)**:
  - Perjanjian komersial antara PT Metiska Farma dan dokter spesialis / institusi faskes mengenai target komitmen peresepan produk dengan imbalan diskon khusus atau sponsorship kegiatan ilmiah.
  - Entitas terkait: `discount_proposals`, `discount_proposal_estimations`, `discount_proposal_payments`, `master_document_proposals`, `customer_territory_products`.
  - **SKI yang Sudah di-Transfer / Realisasi Pembayaran**:
    - SUMBER TABEL UTAMA: **`discount_proposal_payments`**.
    - Syarat: `transferred = 1 AND (canceled_transferred = 0 OR canceled_transferred IS NULL) AND deleted_at IS NULL`.
    - Kolom nominal: **`transferred_amount`** (dan `submission_amount` untuk nilai pengajuan).
    - Jika ditanya transfer bulan berjalan: bandingkan filter tanggal transfer aktual (`transferred_at >= '2026-10-01'`) dan periode pengajuan (`period = '202610'`).
  - **Estimasi SKI (yang Di-Approve)**:
    - SUMBER TABEL UTAMA: **`discount_proposal_estimations`** yang di-join dengan **`discount_proposals`**.
    - Syarat: `dp.deleted_at IS NULL AND dpe.deleted_at IS NULL AND dp.status = 'APPROVE'`.
    - Kolom nominal: **`dpe.total`** (SUM total estimasi nilai perjanjian).
- **Credit Notes (`SPC` / `CN`)**:
  - Di seluruh ekosistem dan laporan SKI Compliance, istilah **`CN`** atau **`SPC`** mutlak mengacu pada **Credit Notes (Nota Kredit)** / potongan penyesuaian penjualan, retur faktur, atau klaim diskon ekstra kesepakatan dokter.
  - **TABEL SUMBER UTAMA**: Setiap kali ada pertanyaan atau perhitungan terkait **Total CN**, **Data CN per Bulan**, atau **Total SPC**, SUMBER TABEL YANG DIGUNAKAN ADALAH TABEL **`credit_notes`** (dengan kolom nominal **`value`** dan filter wajib **`deleted_at IS NULL`**), BUKAN tabel `sales_ffs`!
  - Kolom `spc_n` = Credit Notes bulan berjalan $N$, `spc_nmin1` s/d `spc_nmin6` = Credit Notes $1$ s/d $6$ bulan lalu, `spc_y` = Credit Notes tahun berjalan, `spc_ymin1` = Credit Notes tahun lalu.
- **Distributor & Bridging**:
  - `sales_distributors`: Invoice mentah dari distributor (AAM, MBS, dll.).
  - `bridging_outlets`: Memetakan `(distributor_id, distributor_outlet_id)` $\rightarrow$ `outlet_id` master.
  - `bridging_products`: Memetakan `(distributor_id, distributor_product_id)` $\rightarrow$ `product_id` master.
- **Target Marketing**:
  - Target kuota dan nilai penjualan per struktur marketing (`target_marketings`) per periode `YYYYMM`.
- **Stok Distributor**:
  - Posisi stok barang di gudang distributor (`stock_distributors`) per periode `YYYYMM`.

## 2. Aturan Format Periode (Period Semantics)
- `YYYYMM` (6 digit): `sales_ffs.period`, `marketing_structures.period`, `target_marketings.period`, `stock_distributors.period`, `customer_territory_outlets.period`. Contoh: `'202610'` untuk Oktober 2026.
- `YYYYMMDD` (8 digit): `status_closings.period`, `event_classes.period_start`, `event_classes.period_end`. Contoh: `'20261001'`.
- `YYYY-MM`: Format pencarian sinkronisasi ETL antar sistem.

## 3. Perbedaan Domain dengan VisitFlow
- **VisitFlow**: Berfokus pada aktivitas pencatatan kehadiran fisik kunjungan harian (Call Dokter, Jadwal Plan vs Realisasi, Geotagging/Check-in GPS, Master Customer List / MCL).
- **Ski Compliance**: Berfokus pada aspek komersial dan kepatuhan: Kesepakatan Kerjasama Dokter (SKI), Target & Realisasi Sales Field Force (`sales_ffs`), Credit Notes / SPC, Bridging Distributor, dan Status Closing.
