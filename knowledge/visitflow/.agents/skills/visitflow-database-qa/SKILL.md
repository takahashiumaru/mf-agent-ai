---
name: visitflow-database-qa
description: Use when answering VisitFlow MySQL data questions, daily call totals, operational counts, record validation, or requests for SQL against a chosen database environment.
---

# Q&A Database VisitFlow

Pertanyaan jumlah/data meminta **hasil eksekusi**, bukan berhenti pada SQL. Ikuti kontrak jawaban di root `AGENTS.md`.

## Tentukan akses dan makna angka

1. Gunakan target database, akun khusus read-only, tenant/company, dan zona waktu yang sudah dipilih dalam sesi. Jangan meminta konfirmasi ulang untuk pembacaan yang sudah tercakup. Jika belum tersedia, periksa metadata koneksi yang aman lalu tanyakan hanya konteks yang kurang; jangan memilih production otomatis atau mengambil kredensial aplikasi dari `.env`.
2. Telusuri definisi metrik pada kode service/repository dan model, kemudian baca struktur tabel terkait di `DATABASE_SCHEMA_CATALOG.md`, `DATABASE_SCHEMA.md`, atau DDL terpilih dari `database_schema.sql`. Cocokkan dengan metadata database target bila tersedia. Dokumen dan dump adalah snapshot, bukan data hari ini.
3. Untuk “total call”, pastikan apakah maksudnya jadwal, check-in, selesai/check-out, unique visit, atau agregat laporan. Gunakan definisi dari endpoint/laporan yang sedang dibahas. Bila ada beberapa definisi yang menghasilkan angka berbeda dan konteks tidak menentukan, tanyakan satu klarifikasi; jangan menyamakan call dengan seluruh baris `visits`.
4. Tetapkan tanggal absolut dan zona waktu bisnis; konversikan batas ke zona penyimpanan database yang terverifikasi. Gunakan rentang `>= awal AND < awal_hari_berikutnya`. Scope company, user/structure, period, status, dan soft delete harus mengikuti model dan aturan akses, termasuk lewat join bila kolom tidak ada langsung. Periksa kardinalitas join agar hitungan tidak berlipat.

## Eksekusi dan verifikasi

- Jika target, akses, definisi, dan scope jelas, langsung jalankan SELECT terbatas untuk menjawab pertanyaan. Metadata baca saja (`SHOW`, `DESCRIBE`, SELECT `information_schema`) dan plain `EXPLAIN` dapat dipakai sesuai hak akun.
- Pilih agregasi untuk hitungan, kolom minimal untuk rincian, dan timeout yang wajar. SELECT bukan jaminan biaya rendah. Hindari query tanpa batas scope, locking reads, fungsi berefek samping, `INTO OUTFILE`, prosedur yang belum diperiksa, dan benchmark berat. Jangan menjalankan DML/DDL untuk tugas Q&A.
- Periksa hasil/error dan kewajaran hitungan. Error, koneksi gagal, atau hasil belum diperoleh bukan angka nol. Catat target, waktu pengambilan, parameter, serta SQL eksekusi selama sesi. Sebutkan potensi keterlambatan jika hasil berasal dari replica/cache.

## Bentuk jawaban

- **Data berhasil diperoleh:** awali dengan angka/jawaban aktual, kemudian tanggal/zona waktu, cakupan, definisi singkat, target dan waktu pengambilan. Satu hitungan cukup satu paragraf. Tabel hanya untuk rincian yang diminta atau diperlukan.
- **Validasi diminta:** sertakan SQL yang benar-benar digunakan beserta parameter scope/rentang waktu yang aman ditampilkan. Jika tidak diminta, cukup tawarkan query validasi singkat. Jangan mengklaim SQL rekonstruksi sebagai SQL eksekusi.
- **SQL saja diminta:** berikan query berdasarkan struktur terverifikasi dan tandai belum dieksekusi; jangan menjalankannya.
- **Akses gagal/belum tersedia:** nyatakan angka belum dapat diverifikasi, sebutkan hambatan spesifik dan konteks minimum yang dibutuhkan. Query usulan boleh membantu, tetapi bukan hasil data.

Contoh bentuk jawaban (placeholder, bukan data nyata): “Total call selesai hari ini **<hasil>**, <tanggal> WIB, company <scope>, berdasarkan checkout. Sumber: <target>, diambil <waktu>. Query validasi bisa disertakan.” Isi hanya dari bukti. Jangan menampilkan token, kredensial, atau baris pribadi yang tidak diperlukan.
