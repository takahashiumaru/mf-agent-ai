---
name: visitflow-query-brainstorm
description: Use when the user wants brainstorming, Q&A, option comparison, or EXPLAIN interpretation about VisitFlow query optimization without yet requesting code changes.
---

# Brainstorming dan Q&A Optimasi Query VisitFlow

Gunakan panduan ini saat pengguna ingin berdiskusi, bertanya, memahami `EXPLAIN`, atau membandingkan ide optimasi tanpa meminta perubahan kode. Jawab dalam bahasa pengguna. Tujuannya membantu mengambil keputusan yang masuk akal berdasarkan bukti yang tersedia.

## Mulai dari pertanyaan pengguna

- Jika pertanyaannya konseptual dan sempit, jawab langsung. Contoh: arti `Using temporary`, urutan kolom indeks, atau kapan `Preload` menimbulkan N+1. Jangan memaksa sesi tanya jawab panjang.
- Jika pertanyaannya spesifik VisitFlow, cari implementasi yang relevan di service pemilik fitur: route, controller, service, repository, model, dan konfigurasi gateway bila request melewati KrakenD. Manfaatkan file yang sudah tersedia sebelum meminta pengguna menyalin SQL atau skema.
- Bedakan tujuan yang ingin dioptimalkan: latensi endpoint, jumlah query, penggunaan CPU/IO database, lock wait, beban write, atau biaya operasional. Jaga hasil dan akses data tetap benar.
- Gunakan katalog skema root dan `.agent/DATABASE*.md` sebagai petunjuk bertanggal. Jangan menganggap statistik row, indeks, atau tag model sebagai kondisi database produksi saat ini.

## Pola percakapan

1. Berikan jawaban awal atau ringkasan pemahaman dalam beberapa kalimat.
2. Pisahkan **fakta dari kode/data**, **hipotesis**, dan **bukti yang masih diperlukan**. Jangan menyebut suatu query lambat hanya karena bentuk SQL terlihat rumit.
3. Untuk brainstorming, tawarkan dua atau tiga pendekatan yang sungguh berbeda, misalnya mengurangi query berulang, mempersempit hasil, mengubah bentuk join/aggregasi, memakai cache, atau menambah indeks. Sebutkan manfaat, biaya write/storage, dan risiko kompatibilitas tiap opsi.
4. Urutkan hipotesis berdasarkan bukti, bukan daftar anti-pattern generik. Periksa kemungkinan bottleneck di Go, Redis, jaringan, file, dan serialisasi bila gejala adalah latensi endpoint.
5. Ajukan **satu** pertanyaan lanjutan yang paling menentukan hanya jika jawaban berikutnya akan mengubah rekomendasi. Gunakan pilihan singkat bila membantu. Jangan meminta persetujuan untuk analisis baca saja.

## Bukti yang paling berguna

Pilih yang diperlukan, bukan semuanya sekaligus:

- SQL aktual beserta bentuk parameter dan jumlah eksekusi per request;
- contoh filter, periode, tenant/perusahaan, struktur, `LIMIT`, dan jumlah baris hasil;
- indeks yang benar-benar ada pada database target serta statistik ukuran tabel;
- `EXPLAIN` dan, bila aman, pengukuran durasi/query count pada beban yang mewakili;
- perbedaan cache hit/miss dan primary/replica;
- tuntutan semantik seperti urutan hasil, soft delete, konsistensi setelah write, dan akses bawahan.

Jika pengguna belum punya metrik, tetap bantu membuat hipotesis yang dapat dibedakan dengan satu pengukuran kecil. Jangan menyajikan perkiraan sebagai hasil benchmark.

## Saat membahas indeks atau rencana eksekusi

- Jangan menerapkan aturan urutan kolom indeks secara mekanis. Kecocokan bergantung pada predikat, kardinalitas, `ORDER BY`, join, versi MySQL, indeks yang sudah ada, serta biaya write.
- `type=ALL`, `Using filesort`, atau `Using temporary` adalah sinyal untuk dianalisis, bukan bukti otomatis bahwa query salah. Bandingkan rows examined, rows returned, dan waktu aktual bila ada.
- Jelaskan konsekuensi perubahan API bila usulan menyentuh pagination, urutan, filter, atau agregasi laporan.
- Pertahankan `company_id`, ownership, period, soft delete, dan transaksi meski opsi yang lebih longgar tampak cepat.

## Bentuk jawaban yang nyaman dibaca

Untuk Q&A: **jawaban langsung → alasan/bukti → batas keyakinan**. Untuk brainstorming: **tujuan → hipotesis terurut → tabel opsi dan tradeoff → satu bukti/pertanyaan berikutnya**. Sesuaikan panjang dengan kompleksitas pertanyaan; tidak perlu memakai semua bagian untuk jawaban sederhana.

Diskusi tidak memberi izin otomatis untuk mengubah kode, menjalankan benchmark, atau mengeksekusi SQL. Ketika pengguna meminta implementasi atau pengukuran, lanjutkan dengan skill `visitflow-query-performance` dan `visitflow-gorm-mysql` sesuai lingkupnya.
