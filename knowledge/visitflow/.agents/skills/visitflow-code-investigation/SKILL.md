---
name: visitflow-code-investigation
description: Use when answering VisitFlow code Q&A, feature availability or feasibility questions, request validation, business behavior, or endpoint errors without a request to change code.
---

# Investigasi Kode dan Error Endpoint VisitFlow

Berikan jawaban langsung dari source yang relevan. Gunakan skill ini untuk pertanyaan seperti "kenapa endpoint ini 500?", "validasi field ini di mana?", "kenapa data tidak muncul?", atau "alur kode fungsi ini bagaimana?". Jika pertanyaannya konseptual dan tidak bergantung pada kode VisitFlow, jawab singkat tanpa memindai repository.

## Temukan jalur request

1. Cocokkan method dan path pada `route/*.go` di service pemilik. Untuk URL publik, cocokkan juga `visit-flow-api-gateway/configuration.json` dengan upstream-nya. Katalog Obsidian di `~/Documents/Obsidian Vault/01 Perusahaan/VisitFlow Backend/03 API dan Kontrak.md` serta `08 Peta Gateway.md` dapat mempercepat navigasi, lalu konfirmasi di source terkini.
2. Baca `AGENTS.md` service dan petunjuk `.agent` yang relevan. Telusuri `route → auth/middleware → controller → service → repository atau I/O eksternal → error/response mapper`. Gateway proxy dan Gin identity adalah dua alur berbeda.
3. Periksa request DTO, binding/validator, default filter, status code, error sentinel, recovery panic, ownership/tenant, period, soft delete, transaksi, dan error dependency yang mungkin menjelaskan gejala. Untuk payload atau log yang diberikan, cocokkan dengan cabang kode yang tepat.
4. Untuk perilaku yang melibatkan database, lanjutkan dari model/repository ke struktur tabel terkait pada root `DATABASE_SCHEMA_CATALOG.md`, `DATABASE_SCHEMA.md`, atau DDL terpilih dari `database_schema.sql`. Cocokkan kolom, tipe/nullability, key/relasi, index, period/tenant, soft delete, serta view/procedure yang dipanggil. Catat ketidaksesuaian; verifikasi metadata target bila jawaban bergantung pada schema live. Dump berisi data sensitif: jangan tampilkan INSERT atau mengimpornya.

## Pertanyaan fitur

- **“Sudah ada?”** Telusuri jalur implementasi sampai efek dan responsnya, termasuk wiring, validasi, otorisasi, query, schema, dan tes yang relevan. Untuk fitur otomatis, cari scheduler/job/consumer selain route HTTP. Route atau entri Postman saja belum membuktikan fitur selesai. Lanjutkan pemeriksaan yang tersedia sebelum menjawab; bedakan **sudah diimplementasikan**, **sebagian**, dan **belum ditemukan dalam lingkup pencarian**. Sertakan file/baris dan keterbatasan. Kode lokal tidak membuktikan fitur sudah aktif di production.
- **“Bisa ditambah? Akan lemot/bermasalah?”** Jawab kelayakan berdasarkan alur sekarang dan struktur database, perubahan minimum yang diperlukan, kompatibilitas API/data, transaksi/concurrency/idempotency, serta dampak query/indeks dan I/O. Berikan pendekatan yang disarankan dan cara mengujinya. Jika usulan tidak layak, jelaskan kendala konkret dan alternatif. Gunakan `visitflow-query-brainstorm` untuk opsi performa. Tanpa benchmark, nyatakan risiko dan asumsi, bukan jaminan bebas lambat/error.
- Bentuk jawaban: **status/kelayakan → bukti kode dan schema → dampak/gap → rekomendasi atau verifikasi berikutnya**. Pertanyaan analisis tidak otomatis meminta implementasi; ikuti instruksi implementasi yang sudah diberikan dalam sesi bila ada.

## Jawab dengan tingkat kepastian yang benar

- Awali dengan penyebab yang terbukti atau hipotesis terkuat. Tunjukkan path dan baris yang mendukung, serta kondisi yang memicu cabang tersebut.
- Bila hanya kode lokal tersedia, jelaskan perilaku yang mungkin dihasilkan; runtime produksi, data aktif, header, dan log masih bisa berbeda.
- Untuk 404/401/403, periksa route publik dan lokal, method, auth wrapper, token, permission yang benar-benar ditegakkan, serta lookup yang bisa mengembalikan not-found.
- Untuk 400/422, periksa parsing, tag validasi, nilai default, dan bentuk payload. Untuk 500/timeout, telusuri error propagation, query/I/O eksternal, dan middleware recovery.
- Untuk hasil data yang keliru/kosong, telusuri filter `company_id`, ownership, `structure_id`, `period`, soft delete, join, pagination, cache, dan replica. Gunakan `visitflow-database-qa` bila jawaban memerlukan baris database aktif.
- Jika ada beberapa penyebab yang belum dapat dibedakan, sebutkan satu bukti berikutnya yang paling menentukan, misalnya request contoh yang disamarkan, status/body, trace ID, atau potongan log. Jangan menebak akar masalah definitif dari status HTTP saja.

Berikan format ringkas: **jawaban → bukti kode → cara memastikan atau memperbaiki**. Untuk perubahan kode, lanjutkan dengan `visitflow-go-backend` dan instruksi service. Untuk pertanyaan performa, gunakan `visitflow-query-performance` atau `visitflow-query-brainstorm` sesuai maksud pengguna.
