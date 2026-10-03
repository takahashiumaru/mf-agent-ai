---
name: db-schema-optimizer
description: Use when auditing VisitFlow MySQL schema design, keys, data types, normalization, model-to-schema drift, or planning a reviewable database migration.
---

# Audit Skema Database VisitFlow

Gunakan skill ini untuk menilai rancangan skema dan menyiapkan usulan perubahan. Skill ini berada di workspace induk VisitFlow, di luar repository Git tiap service. Mulai dari bukti yang ada; jangan menganggap snapshot lokal sama dengan skema database aktif.

## Tentukan sumber kebenaran

1. Tentukan service, database, tabel, dan aturan bisnis yang ditanyakan. Baca `AGENTS.md` service bila ada, kemudian model, repository, DTO, view, dan stored procedure yang terkait.
2. Gunakan `DATABASE_SCHEMA_CATALOG.md`, `database_schema.sql`, dan `.agent/DATABASE_SCHEMA.md` sebagai snapshot bertanggal. Periksa `SHOW CREATE TABLE`, `SHOW INDEX`, atau metadata database target secara baca saja jika akses tersedia.
3. Pisahkan fakta dari kode, fakta dari database target, dan asumsi. Tandai rekomendasi yang hanya berdasar snapshot lokal.

## Audit desain

- Cocokkan primary key, unique key, dan foreign key dengan identitas bisnis. Di VisitFlow, kombinasi `company_id`, `period`, `structure_id`, atau ID bisnis dapat menentukan keunikan dan relasi.
- Periksa tipe, rentang, presisi, panjang, `NULL`, default, timestamp, timezone, audit field, dan soft delete. Pastikan representasi Go/GORM dapat membedakan nilai kosong, nol, dan `NULL` bila diperlukan.
- Cek foreign key yang benar-benar ada di database, bukan hanya asosiasi GORM. Nilai dampak cascade terhadap histori, approval, dan laporan.
- Gunakan normalisasi untuk menemukan anomali pembaruan. Untuk denormalisasi yang disengaja, jelaskan pemilik data, waktu pembaruan, dan cara menjaga konsistensi.
- Cocokkan indeks dengan query nyata: filter tenant, join, selektivitas, urutan kolom, `ORDER BY`, serta biaya insert/update. Jangan mengusulkan indeks hanya dari bentuk tabel.
- Bedakan tabel dasar, view, tabel kerja prosedur, dan tabel laporan/materialisasi; dump lokal dapat memuat beberapa jenis objek.

## Hasil audit

Jelaskan kondisi saat ini, bukti, masalah yang ditemukan, pilihan perubahan, dampak pada Go/API, urutan rollout dan backfill, biaya lock/write, cara mengamati hasil, serta langkah rollback. Tulis SQL migrasi sebagai usulan yang dapat ditinjau. Jangan menjalankan DDL/DML pada database aktif atau menambah `AutoMigrate` saat startup hanya berdasarkan audit ini.

Gunakan skill `visitflow-gorm-mysql` untuk implementasi model atau repository, `visitflow-query-performance` untuk analisis indeks berbasis beban query, dan `visitflow-query-brainstorm` untuk diskusi pilihan sebelum perubahan kode.
