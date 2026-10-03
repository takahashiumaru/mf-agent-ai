# Audit mendalam risiko regression VisitFlow Core

Tanggal: 27 September 2026. Scope: kondisi source setelah refactor readability service dan kesiapan menjalankan plan Package Design/SOLID/Dependency Management.

## Kesimpulan

**Belum dapat dinyatakan bahwa seluruh fitur pasti tidak terganggu atau bebas error.** Plan arsitektur sebelumnya hanya dokumen, sehingga tidak mengubah executable behavior. Untuk refactor service yang sudah dilakukan, build/test/vet/race memberikan bukti positif, tetapi audit ini membuktikan bahwa sebagian test belum mampu mendeteksi hilangnya business operation penting.

Temuan paling penting: dalam eksperimen terisolasi, seluruh body `VisitServiceImpl.UpdateApproved` diganti menjadi `return web.VisitResponse{}`. **Test khusus approval dan seluruh suite tetap lulus.** Ini bukan perubahan pada project dan bukan bukti bahwa approval production sedang rusak. Ini bukti konkret bahwa test existing belum menjadi pengaman yang memadai untuk perubahan approval.

Tidak ada regression production baru yang terkonfirmasi dari pemeriksaan ini. Itu berbeda dari pembuktian tidak adanya regression. Rekomendasi: perkuat P0 sebelum memperluas refactor arsitektur, terutama assertion approval, checkout, rollover, dan transaksi.

## Perbaikan test approval (27 September 2026)

Celah R1 sudah diperbaiki pada test: subtest `UpdateApproved` kini memeriksa ID/status visit hasil, status/audit/structure pada visit yang dikirim ke repository, update approval beserta ID/status, resolver transaksi yang sama untuk kedua write, serta seluruh ekspektasi SQL/transaction. Assertion `NotNil` yang sebelumnya tidak bermakna untuk response struct dihapus. Test helper pencatat ada di `test/visit_approval_tracking_test.go`.

Pola RED/GREEN diverifikasi pada salinan source tanpa file credential: ketika implementation `UpdateApproved` di salinan sementara dibuat no-op, assertion status dan operasi repository gagal; setelah source snapshot dipulihkan, test approval lulus. Full suite sesudah perubahan menghasilkan 520 event test/subtest lulus, 0 gagal, 0 skip pada salinan terisolasi; `go vet -mod=readonly ./...` juga lulus. Salinan mengandung 10 test audit sementara tambahan, jadi angka 520 bukan jumlah test baru dalam project.

Workspace production service sudah dibandingkan dengan hash source sebelum eksperimen dan cocok. Hanya test approval yang diubah; `go.mod`, `go.sum`, dan source aplikasi tidak diubah. R2–R6 tetap menjadi gap terpisah: rollover orchestration, checkout/upload branches, MySQL integration, dan pengiriman async FCM belum seluruhnya dikunci.

Catatan eksekusi: satu pemanggilan awal test sempat berjalan di workspace sebelum isolasi yang dimaksud, ketika bagian source sedang dalam eksperimen pemulihan. Tool output tidak mencatat hasil jaringan goroutine FCM yang mungkin dipicu oleh test lama. Saya tidak dapat memastikan apakah ada request eksternal; tidak ada bukti pengiriman berhasil. Verifikasi final setelahnya dilakukan hanya di salinan tanpa `helper/service-account.json`, dan source workspace telah dipulihkan serta diverifikasi hash-nya. Tidak ada database write atau operasi Git.

## Metode dan batas

- Membandingkan source saat ini dengan snapshot filesystem sebelum refactor yang tersimpan dari pekerjaan sebelumnya. Isi snapshot yang tercakup manifest awal cocok dengan hash manifest; tidak menggunakan Git.
- Dibandingkan file Go dan module; tidak ada file Go baseline yang hilang. Perubahan executable yang ditemukan terhadap snapshot berada di `service`; route, controller, auth, app, repository, model, helper, main, dan dependency module tetap sama. Empat file test existing berubah dan ada test/helper service baru.
- Menelusuri ekstraksi planning, check-in, checkout, approval, MCL, customer draft/profile/dynamic, rollover, file/product, cache, dan social/Maps; fokus pada urutan side effect, mapping, panic/defer, DB handle, dan kontrak response.
- Menjalankan test pada salinan source dan template HTML terisolasi. File credential, `.env`, dump, dan data produksi tidak disalin. Ini mencegah test file I/O menimpa file workspace dan tidak menyediakan kredensial untuk pengiriman FCM.
- Eksperimen tambahan hanya dibuat pada direktori sementara. Tidak ada perubahan Go/test/go.mod/go.sum project, operasi Git, mutation database, atau deployment.
- Tidak menguji runtime production, seluruh matrix request, locking/isolation/replication MySQL, atau pengiriman notifikasi nyata.

## Hasil verifikasi aktual

| Pemeriksaan | Hasil | Makna dan batas |
|---|---|---|
| Full suite dengan coverage, uncached | 510 event test/subtest lulus, 0 gagal, 0 test skip | Angka mencakup test induk dan subtest; bukan 510 fitur atau seluruh kombinasi input |
| `go vet -mod=readonly ./...` | Lulus | Tidak membuktikan business behavior |
| Full suite `go test -race` | 510 event test/subtest lulus, tanpa race terdeteksi | Hanya interleaving/jalur yang benar-benar berjalan |
| Statement coverage gabungan | 95,7% | Bukan branch coverage, kualitas assertion, atau kelengkapan fitur |
| Statement coverage service | 95,4% | Beberapa flow penting tetap mempunyai coverage rendah/0% |
| Cross-package test suite saat ini pada snapshot sebelum refactor | 413 event test/subtest lulus | Source lama dan baru lulus kontrak test yang sama; tidak membuktikan kontrak yang tidak diperiksa |
| Differential rollover candidate mapping | 300 kombinasi input seeded cocok dengan algoritma snapshot lama | Memeriksa output, ordering/dedup, nil dan overlap; timestamp runtime dinormalisasi, bukan pengujian orchestration DB |
| Tambahan kontrak Maps | 8 subcase lulus pada source lama dan baru | Empat method × read-body failure / HTTP 429 passthrough; memeriksa status, body, Content-Type, dan Close pada read failure |
| Mutation test approval | Mutasi salah tidak ditangkap: targeted test dan full suite tetap lulus | Kelemahan pengaman regression terkonfirmasi |

Command utama, dijalankan dari salinan source:

```sh
go test -mod=readonly ./... -count=1 -timeout=180s -coverpkg=./... -coverprofile=/tmp/visitflow-core-deep-audit-coverage.out -json
go vet -mod=readonly ./...
go test -race -mod=readonly ./... -count=1 -timeout=180s -json
go tool cover -func=/tmp/visitflow-core-deep-audit-coverage.out
```

Package tanpa test dapat dilabeli skip oleh `go test -json`; angka 0 skip di atas khusus test/subtest, bukan package tanpa test. Coverage dihitung dengan menggabungkan block yang sama dari beberapa test package, bukan merata-ratakan persen output tiap package.

Perbandingan baseline memakai source produksi snapshot lama dan file cross-package test saat ini, termasuk fixture Social offline serta perbaikan ekspektasi mock yang sudah ada. Ini tidak diklaim sebagai menjalankan test baseline lama tanpa perubahan.

## Temuan prioritas

### R1 — Tinggi: test approval tetap hijau ketika seluruh operasi dihilangkan

[UpdateApproved](../visit-flow-go/service/visit_service_impl.go:236) semestinya memvalidasi request, lookup/validasi approval, mengubah visit, mengubah approval, dan memicu notifikasi. [Test existing](../visit-flow-go/test/service_deep_visit_test.go:330) menyiapkan expectation SQL tetapi assertion akhirnya hanya `assert.NotNil(t, resApp)` pada response struct, tanpa verifikasi pemenuhan seluruh expectation di subtest tersebut.

Eksperimen diagnostic mengganti body method hanya pada Go overlay sementara:

```go
return web.VisitResponse{}
```

Hasil:

- `TestVisitService_DeepMethods/UpdateApproved` tetap PASS.
- Seluruh suite juga tetap PASS, termasuk pemeriksaan tambahan audit: 520 event test/subtest, 0 gagal. Angka ini terdiri dari 510 event existing dan 10 event pemeriksaan tambahan.
- Tidak ada body method dalam workspace yang diganti.

**Implikasi:** kelulusan test tidak cukup untuk menjamin update approval benar-benar dijalankan. Assertion non-nil atas value struct tidak memvalidasi field, status transition, persistence, scope, atau notifikasi.

**Tindakan sebelum refactor berikutnya:** assertion exact status/ID/approved fields; repository call count dan argumen; identity DB handle; urutan update visit/approval; `ExpectationsWereMet`; permission denied dan invalid transition; panic/error yang spesifik. Uji kekuatan test: no-op mutation tersebut harus membuat test gagal.

### R2 — Tinggi: rollover bulanan belum teruji pada orchestration persistence

[StructureDuplicateData](../visit-flow-go/service/structure_service_impl.go:167) hanya menjalankan rollover tanggal 25 atau 28. Saat audit tanggal 27, test masuk early return. [Test existing](../visit-flow-go/test/service_deep_structure_test.go:181) hanya memeriksa message tidak kosong.

Coverage existing pada run ini:

| Function | Statement coverage |
|---|---:|
| StructureDuplicateData | 7,7% |
| copyStructuresForNextPeriod | 0% |
| copyStructureLocationsForNextPeriod | 0% |
| enrichRolloverVisitCustomers | 0% |
| buildStructureRolloverCandidates | 97,3% |

Differential test tambahan dengan 300 kombinasi input cocok dengan algoritma lama untuk pembentukan kandidat. Ini memperkuat dedup/ordering/mapping, tetapi tidak menutup delete/copy/upsert, enrichment query, transaksi, dan failure boundary.

**Tindakan:** waktu deterministik pada seam terkontrol dengan default produksi tetap `time.Now`; test tanggal 25/28 dan tanggal lain, pergantian bulan/tahun, data kosong/overlap, serta kegagalan pada setiap write penting. Verifikasi delete/copy/upsert dan DB handle secara eksplisit. Jangan memakai perubahan jam mesin atau menjalankan rollover pada database produksi untuk test.

### R3 — Tinggi: checkout survey dan upload bukti belum cukup dikunci

Coverage orchestrator [UpdateCheckOut](../visit-flow-go/service/visit_service_impl.go:352) mencapai 98,7%, tetapi helper yang memuat percabangannya tidak setinggi itu:

| Function | Statement coverage |
|---|---:|
| checkOutStartedVisit | 34,8% |
| UpdateCheckOutDataVisit | 97,0% |
| saveVisitProofs | 20,0% |

[Survey gate](../visit-flow-go/service/visit_checkout.go:42) mempunyai kombinasi survey ada/tidak ada dan checkout time supplied/nil/zero. [Upload](../visit-flow-go/service/visit_checkout.go:122) harus mempertahankan urutan foto, signature, update visit, dan error. [Helper checkout](../visit-flow-go/service/visit_checkout.go:61) membuka transaksi tersendiri di dalam flow outer checkout, seperti baseline.

**Tindakan:** table-driven test kombinasi lokasi normal/NON/No Location, status check-in/non-check-in, survey kosong/ada, timestamp supplied/nil/zero, foto/signature kosong/ada, callback upload gagal pertama/kedua, dan kegagalan update/approval. Periksa response dan urutan efek, bukan hanya tidak panic atau response non-nil. Pertahankan transaction boundary legacy saat refactor; perbaikannya merupakan task behavior tersendiri.

### R4 — Tinggi: mock transaksi tidak membuktikan atomicity/replica

[newMockResolver](../visit-flow-go/test/test_db_helper_test.go:39) memakai objek DB yang sama pada `Read` dan `Write`. [expectTransaction](../visit-flow-go/test/test_db_helper_test.go:55) mengharapkan dua Begin dan satu Commit; helper ini memodelkan behavior legacy, bukan memverifikasi finalisasi semua handle.

Dependency `go-helper@v0.5.9` yang diperiksa memang membuka transaksi writer dan reader terpisah. Source service umumnya hanya men-defer `CommitOrRollback(tx.Write)`. Audit tidak mengganti resolver atau transaction boundary.

**Tindakan:** gunakan distinct handles untuk assertion penerusan transaksi; wajib cek expectation; test rollback pada failure boundary. Bukti atomicity/read-your-writes sesungguhnya memerlukan harness MySQL terisolasi. Test sqlmock tidak cukup untuk membuktikan replication lag atau isolation. Tidak ada izin mutation database tersirat dari plan ini.

### R5 — Menengah: asynchronous notification belum dibuktikan terkirim dan konsisten

[Check-in](../visit-flow-go/service/visit_service_impl.go:333) dan [checkout](../visit-flow-go/service/visit_service_impl.go:377) meluncurkan goroutine dengan Gin context. [MCL notification](../visit-flow-go/service/visit_customer_service_impl.go:489) juga mengembalikan hasil tanpa menunggu pengiriman selesai. Pola ini terlihat pada baseline; bukan regression baru yang dikonfirmasi.

[Test notifikasi](../visit-flow-go/test/service_coverage_boost_90_test.go:449) memeriksa jumlah response, bukan seluruh hasil pengiriman. Full race PASS tidak membuktikan payload benar, worker selesai sebelum shutdown, retry, lifetime context, atau tepat sekali kirim. Salinan audit tidak membawa credential FCM sehingga tidak membuktikan successful delivery.

**Tindakan:** fake sender dan synchronization deterministik; periksa token kosong/nil, user duplikat/cache lookup, title/body/data, jumlah kirim, send failure, dan jalur self/boss. Jangan sekaligus memindahkan notification setelah commit atau mengganti lifetime context di bawah label refactor behavior-preserving.

### R6 — Menengah: kontrak response/error dan external I/O perlu assertion lebih kuat

Beberapa test mengukur traversal method dan status saja. Coverage tidak menjamin JSON/null/empty collection, exact error, ordering, atau semua failure I/O.

Tambahan audit Maps membuktikan read failure dan non-200 passthrough cocok antara versi lama/baru pada 8 subcase, tanpa request Google sungguhan. Ini menutup sebagian ketidakpastian analitis, tetapi temporary test tersebut **belum menjadi regression test permanen project**.

**Tindakan:** jadikan case berisiko bagian test permanen pada pekerjaan berikutnya; pertahankan fixture deterministik dan exact observable contract. Audit serupa diperlukan pada upload/file/cache serta response mapper yang tersentuh, bukan snapshot besar tanpa tujuan.

## Bagian yang mempunyai bukti positif

- File route/controller/auth/model/repository dan module dependency sama dengan snapshot baseline yang diperiksa; tidak ditemukan perubahan direct route, DTO tag, SQL repository, atau versi module dari refactor service tersebut.
- Checkout masih memakai survey repository melalui `tx.Read` dan mempertahankan transaksi nested; bukan diganti HTTP atau digabung diam-diam.
- Social masih memakai request/retry implementation existing; perubahan classification diekstrak ke helper. Tidak ditemukan normalisasi policy transport baru pada diff yang diperiksa.
- Product image helper tetap menutup file melalui caller dalam urutan terbalik sebelum defer transaksi; scope close tidak sekadar dipindahkan menjadi defer di helper berumur pendek.
- Response/cache behavior legacy tetap terlihat pada diff yang diperiksa, termasuk empty response saat pembacaan cache kota gagal.
- Algoritma rollover kandidat cocok pada eksperimen differential yang dijelaskan; seluruh full suite, vet, dan race run source asli saat ini berhasil.

Bukti tersebut bersifat terbatas pada snapshot, jalur, dan input yang diperiksa. Tidak mencakup seluruh runtime produksi atau formal equivalence semua program.

## Dampak pada plan arsitektur

[P0 pada plan Package Design](2026-09-27-visit-flow-go-package-design-plan.md) harus menjadi gate nyata, dengan urutan:

1. Perkuat approval sampai no-op mutation terdeteksi.
2. Kunci checkout survey/upload dan rollover dengan waktu deterministik.
3. Bedakan transaksi Read/Write dalam test, verifikasi expectations dan failure boundaries.
4. Tambahkan fake notifier serta assertion kontrak response/I/O yang disentuh.
5. Baru jalankan pilot package dan dependency injection per use case; setelah setiap batch jalankan focused test, full suite, dan pemeriksaan yang sesuai risiko.

Pekerjaan ini tidak membutuhkan rewrite arsitektur untuk mulai meningkatkan keamanan. Prioritasnya membuat test menguji hasil business operation secara nyata. Sampai gap tersebut ditutup, status yang tepat adalah **“test existing lulus, beberapa kesamaan behavior terverifikasi, tetapi jaminan seluruh fitur belum cukup kuat.”**

## Artefak dan integritas workspace

Bukti mesin sementara tersedia pada `/tmp/visitflow-core-deep-audit-tests.jsonl`, `/tmp/visitflow-core-deep-audit-race.jsonl`, `/tmp/visitflow-core-deep-audit-functions.txt`, `/tmp/visitflow-core-baseline-audit-tests.jsonl`, dan `/tmp/visitflow-core-audit-noop-all.jsonl`. Source eksperimen berada di temporary directory yang dicatat `/tmp/visitflow-core-deep-audit-location`; overlay mutation berada di `/tmp/visitflow-core-audit-noop-overlay.json`. File sementara bukan artefak deployment dan dapat hilang sesuai lifecycle sistem.

Hash source/test/module/template workspace diperiksa terhadap manifest awal audit dan tidak berubah. Dokumen audit ini serta penambahan gate pada plan berada di workspace induk, di luar child repository. Tidak ada commit, push, merge, atau operasi Git lainnya.
