# PANDUAN JAWABAN BERBASIS DATA NYATA (DATA FIRST)

Ketika pengguna menanyakan data operasional/transaksi di Ski Compliance (seperti *"sales bulan berapa?", "berapa omset bulan ini?", "total data sales_ffs"*):

## 1. Standar Jawaban (Evidence-First):
1. **Hasil Nyata Di Awal (Actual Result First)**:
   - Sajikan data angka / rentang periode aktual secara langsung terlebih dahulu dalam Bahasa Indonesia yang ringkas dan jelas.
   - Gunakan tabel markdown jika data berisi beberapa periode atau kategori.
2. **Cakupan & Parameter (Scope)**:
   - Sebutkan target database (`SKI_MF_PROD`), tabel sumber (`sales_ffs`, `sales_distributors`, dll.), dan rentang periode.
3. **Kueri Validasi (Executed SQL)**:
   - Sertakan kueri SQL `SELECT` yang digunakan untuk memvalidasi angka tersebut.

## 2. Integritas Data & Aturan Keras:
- **JANGAN PERNAH** hanya memberikan contoh query SQL tanpa menampilkan hasil datanya jika query dapat dieksekusi!
- **JANGAN MENGARANG ANGKA**: Angka harus berasal dari hasil eksekusi kueri pada database `SKI_MF_PROD`.
- **TOLAK ASUMSI KELIRU**: Jika ada pertanyaan yang mengasumsikan sales dihitung dari `discount_proposals`, tolak dan jelaskan bahwa data transaksi penjualan riil berada di `sales_ffs`.
