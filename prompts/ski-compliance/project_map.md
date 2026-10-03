# PETA REPOSITORI & ARSITEKTUR SKI COMPLIANCE (16 REPOSITORIES)

Sistem SKI Compliance Metiska Farma terdiri dari 16 repositori mikroservis dan modul integrasi berikut:

| Nama Repositori | Fungsi & Tanggung Jawab Utama |
|---|---|
| **`mf-micro-service-sales`** | Mengelola transaksi penjualan Field Force (`sales_ffs`), transaksi distributor (`sales_distributors`), laporan Morses, OTX, Top 50 Sectors, dan perhitungan diskon. |
| **`mf-micro-service-customer`** | Mengelola master data dokter/pelanggan (`customers`), pemetaan wilayah/produk dokter (`customer_territory_products`, `customer_territory_outlets`). |
| **`mf-micro-service-outlet-2`** | Mengelola master outlet/faskes (`outlets`), group mapping outlet (`outlet_group_mappings`), dan relasi distributor outlet. |
| **`mf-micro-service-discount-proposal`** | Mengelola alur pengajuan dan persetujuan proposal diskon / kesepakatan kerjasama dokter (SKI). |
| **`mf-micro-service-master-document-proposal`** | Mengelola berkas fisik/dokumen master proposal kesepakatan dokter, kategori proposal, dan audit file. |
| **`mf-micro-service-product`** | Mengelola katalog produk (`products`), program promosi (`product_programs`), harga jual, dan batas diskon principal/distributor. |
| **`mf-micro-service-structure`** | Mengelola pohon organisasi pemasaran (`marketing_structures`), alokasi teritori ASM, SPV, MR per periode `YYYYMM`. |
| **`mf-micro-service-bank`** | Mengelola rekening bank dokter (`accounts`), cabang bank, transfer fee, dan data pembayaran komitmen. |
| **`mf-micro-service-event`** | Mengelola pengajuan sponsorship event ilmiah/seminar kedokteran (`event_classes`, `events`), periode `YYYYMMDD`. |
| **`mf-micro-service-marketing-user`** | Mengelola akun pengguna marketing, divisi, sesi login, dan hak akses menu/grup. |
| **`ski-compliance-api-warehouse`** | Pemrosesan sales-out warehouse, kalkulasi target marketing vs pencapaian, dan agregasi data batch. |
| **`visit-flow-api-synchronize-ski-compliance`** | Orkestrator sinkronisasi data master (dokter, outlet, struktur) antara sistem SKI Compliance dan VisitFlow. |
| **`ski-api-gateway`** | Reverse proxy dan API Gateway penghubung seluruh mikroservis SKI. |
| **`rest-api-pondasi-mftl`** | Fondasi integrasi API legacy/infrastruktur dasar. |
| **`flexurio-nocode-api-config-mf-marketing`** | Konfigurasi runtime API backend no-code platform. |
| **`flexurio-nocode-web-config-mf-marketing`** | Konfigurasi template antarmuka frontend web marketing. |
