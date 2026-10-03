# VisitFlow service Clean Code — Plan dan Hasil Refactor

> Rencana ini dibuat sebelum perubahan kode, lalu pengguna meminta pelaksanaannya. Hasil awal dicatat sebelum operasi Git; setelah itu pengguna meminta branch dan push. Commit implementasi pertama adalah `40bda18` pada `refactor/clean-code-service`.

**Goal:** meningkatkan readability dan maintainability seluruh folder `visit-flow-go/service`, dengan ekstraksi responsibility yang jelas dan tanpa mengubah behavior existing.

**Architecture:** pertahankan `route → controller → service → repository → model/mapper` dan package `service`. Pecah implementasi besar menjadi file per use case dalam package yang sama; pertahankan public interface, constructor, manual wiring, DTO, query, error, dan batas transaksi. Mulai dari helper murni; hindari generic base service, workflow engine, DI framework, atau package baru tanpa kebutuhan nyata.

**Tech stack:** Go (`go.mod`: 1.23; toolchain pemeriksaan: go1.27.1 darwin/arm64), Gin 1.9.1, validator/v10 10.14.1, GORM 1.25.4, MySQL driver 1.5.1, go-helper 0.5.9, sqlmock 1.5.2, testify 1.8.4. Tidak ada upgrade dependency dalam rencana ini.

## Batas dan hasil analisis

Analisis dilakukan pada 27 September 2026. Semua **80 file Go** dalam `service` dibaca/dipetakan: **39 implementation, 39 interface, `approval.go`, dan `confirmation_status.go`**. Total **10.479 baris fisik**, termasuk komentar dan baris kosong. AST Go mencatat **312 deklarasi function/method**, termasuk constructor; **42 lebih dari 50 baris**, **13 lebih dari 100 baris**. Ukuran bukan satu-satunya dasar prioritas: campuran responsibility, dependency tersembunyi, urutan side effect, serta kekuatan test lebih menentukan.

Penelusuran dependency diperdalam pada visit, MCL, customer/location, structure rollover, HTML, file/network, transaksi, dan error mapping. Repository/model/schema snapshot yang relevan diperiksa untuk menjelaskan batas refactor; ini bukan audit seluruh query/repository ataupun bukti schema/runtime production. Tidak ada query atau mutation database dijalankan. Dokumen plan disimpan **di luar child repository**; implementasi yang diminta kemudian mengubah source/test dalam scope `visit-flow-go/service` dan test pendukung.

## Status pelaksanaan

| Batch | Status dan perubahan aktual |
| --- | --- |
| B0 | Baseline test mock diperbaiki agar ekspektasi argumen cocok dengan query aktual pada lima kasus repository. |
| B1 | HTML visit grouping, address classification, dan completeness rules dipisahkan ke helper murni dengan tests. |
| B2 | `Customer.UpdateDynamic` dipecah menjadi action handlers dan log update; lookup legacy `SUBMIT_LOCATION` pada `SUBMIT_PROFILE` tetap. |
| B3 | Customer create/profile mapping dan draft approval mapping dipindahkan ke helper bertipe, dengan tests. |
| B4 | `Visit.Create` dibagi menjadi helper parsing jadwal, quota/config, duplikasi, approval, mapping, dan member. |
| B5 | Check-in dipisah menjadi tahapan koordinat/radius, visit/member, HTML/log, dan approver. |
| B6 | Checkout/approval dipecah sambil mempertahankan transaksi nested, urutan upload, status, dan notifikasi. |
| B7 | MCL quota, mapping, deletion, history/approval, dan clone period dipisah ke helper command. |
| B8 | Structure rollover, candidate/estimation/enrichment, boss selection, dan customer cluster stages dipisah dan diuji. |
| B9 | Location mapping, customer-location request mapping, dan structure-city cache dipisah; customer-location lifecycle serta structure-location period behavior tetap di orchestrator. |
| B10 | File readers digabung pada satu helper; product image write memakai helper dengan lifecycle Close tetap di caller; Google Maps memakai satu proxy helper; Social classifiers murni per platform; MCL notification query self/boss tetap terpisah dan token/sending loop dipakai bersama. Network coverage test memakai HTTP fixture. |
| B11 | Constructor/local naming yang menyesatkan diperjelas. `ProcessDataVisit` menunjukkan tahap master potential customer dan per-structure visit secara eksplisit. Adapter CRUD/report yang sudah ringkas dibiarkan. |
| B12 | Full test suite tanpa skip, `go vet`, race pada test async MCL notification, serta pemeriksaan batas behavior dilakukan. Rincian dan gap tercatat di bawah. |

Beberapa checklist awal merinci edge case yang tidak seluruhnya mempunyai fixture terisolasi, misalnya kegagalan read-body Maps, berbagai retry/delay Social, dan FCM send failure. Implementasi terkait mempertahankan jalur transport/retry dan side effect yang sudah ada; batas test tersebut tercatat agar hasil tidak dianggap sebagai bukti integrasi eksternal.

Checklist terperinci di tiap batch adalah kriteria karakterisasi dari plan awal. Tabel status dan hasil verifikasi menunjukkan cakupan aktual; item tanpa test khusus berarti case tersebut tidak diklaim sudah diuji secara terisolasi.

### Global constraints

- Tidak mengubah behavior atau business logic existing.
- Pertahankan public method/constructor dan interface; nama field JSON, status, message error, pagination, ordering, null/zero/empty slice juga bagian dari kontrak.
- Pertahankan sumber company/user/structure/period per flow, termasuk variasi yang terlihat tidak konsisten. Jangan mengganti field request dengan auth atau sebaliknya secara diam-diam.
- Pertahankan urutan validasi, query, write, file I/O, notification, commit/rollback, dan input mutation yang terlihat oleh caller.
- Jangan mengubah panic menjadi error return pada public chain, membungkus error dengan pesan baru, atau mengubah status HTTP sebagai bagian cleanup.
- Jangan mengganti `Save`, `Updates(struct)`, `First`, `Find`, raw SQL, `Unscoped`, batch size, conflict key, atau stored procedure selama refactor struktural.
- Jangan menggabungkan transaksi terpisah, menghilangkan transaksi read, menggeser notification menjadi after-commit, atau menjadikan goroutine sinkron. Itu perubahan behavior yang memerlukan task terpisah.
- Tidak ada migration, dependency baru, benchmark production, atau perbaikan authorization dalam scope.
- Tidak melakukan operasi Git, sesuai instruksi pengguna.

## Kesimpulan dan prioritas awal

Refactor layak dilakukan **bertahap per use case**, bukan rewrite seluruh service sekaligus. Service CRUD kecil sebagian besar sudah mudah diikuti; pertahankan bentuknya. Konsentrasikan perubahan pada orkestrasi besar dan duplikasi yang telah terbukti identik. Ukuran function di tabel berikut adalah kondisi sebelum refactor.

| Hotspot | Ukuran function | Campuran responsibility | Prioritas refactor |
| --- | ---: | --- | --- |
| `structure_service_impl.go:229` — `StructureDuplicateData` | 309 | date gate, rollover, clone, dedup, credit note, amortization, estimation, enrichment, persistence | Tinggi; setelah test tanggal dan precedence tersedia |
| `visit_service_impl.go:101` — `Create` | 275 | config, quota, status, location mapping, duplicate guard, create, approval, members | Tinggi; risiko bisnis tinggi |
| `visit_service_impl.go:570` — `UpdateCheckIn` | 168 | waktu/GPS, lokasi, member, HTML selection, customer log, approval, notification | Tinggi; pisahkan dari checkout |
| `customer_service_impl.go:145` — `UpdateDynamic` | 140 | decode tiga payload, mapping, writes, log counter | Kandidat awal setelah characterization |
| `customer_draft_service_impl.go:154` — `UpdateApprove` | 131 | patch master, categories, sinkronisasi SKI | Tinggi; ada cross-schema write |
| `visit_customer_service_impl.go:83/207/330` — Create/Delete/Approve | 123/122/118 | aturan MCL, approval, history, commit terpisah | Tinggi; ekstraksi harus menjaga transaction boundary |
| `customer_service_impl.go:401` — `UpdateProfileCustomer` | 122 | upload, normalisasi, update, sync, replace category, policy | Tinggi |
| `visit_service_impl.go:448` — `UpdateApproved` | 121 | transition, batas waktu, survey, checkpoint, routing approver, FCM | Tinggi |
| `html_service_service_impl.go:849` — `ProcessCustomerFamily` | 118 | grouping, completeness, render, persist | Awal; pure rules dapat dipisahkan |
| `location_service_impl.go:209` — `CreateProcessLocation` | 107 | lookup, naming, upload, create, approval, commit, categories | Menengah–tinggi |
| `html_service_service_impl.go:427` — `generateHtmlCustomerLocation` | 101 | address classification, JSON, JavaScript injection, template read | Awal; golden output diperlukan |

## Dependency dan flow yang perlu dipertahankan

### Jalur HTTP dan kontrak

`app/router.go:29` memasang router, logging, recovery, lalu mendaftarkan route. `route/visit_route.go:17` mengonstruksi service dengan dependency eksplisit; controller melakukan parsing dan membentuk `web.WebResponse` (`controller/visit_controller_impl.go:109`). Service menentukan aturan bisnis dan memanggil repository. Mapping `ToVisitResponse` dan `ToVisitTempResponse` berbeda dan tidak boleh dipertukarkan.

`auth/auth.go:51` menerima roles tetapi pemeriksaan roles dikomentari sekitar baris 80. Jangan mengasumsikan role list di route merupakan enforcement. Pertahankan checkpoint dan predicate existing; perbaikan otorisasi harus menjadi perubahan tersendiri.

`app/router.go:35` memasang recovery dari dependency logger. Error/panic berhubungan dengan rollback dan HTTP mapping; referensi kontrak lokal: `.agent/ERROR_HANDLING.md`. Perubahan format error dapat mengubah hasil HTTP meskipun SQL sama.

### Visit

Entry: `route/visit_route.go`, `controller/visit_controller_impl.go`, `service/visit_service.go`.

- **Create:** validasi → transaksi → parse jadwal dan `+7h` → initial status/user prefix → mutasi subordinate auth → config/quota harian → customer/location/user → kategori dan quota kategori → validasi/create structure-location → approval config → `-7h`/default type → duplicate guard → skip-approval → persist visit → approval/FCM → expansion member → response.
- **Check-in:** baca visit/location/approval → pilih waktu → accuracy → batas jadwal → radius atau update koordinat lokasi → update visit/member → pilih HTML/customer-log flag → increment counter → update approver → notifikasi.
- **Checkout:** transaksi outer membaca visit/approval/location → accuracy/radius/survey → `UpdateCheckOutDataVisit` membuka transaksi baru → update member/file/visit/approval → notification outer → response. Jangan otomatis mengganti helper ini menjadi pemakai transaksi outer.
- **Approval/closed/reject:** `Approval` membaca next status dari repository, lalu pemeriksaan konfigurasi/checkpoint, update visit, update approval, dan FCM dengan variasi penerima.

Dependency tambahan di dalam body: concrete location/customer/category/structure-location/member repository, gateway user repository, survey outlet repository; lihat `visit_service_impl.go:129`, `:583`, `:783`, `:1476`. Field `ConfirmationStatusRepository` yang diinjeksi bukan yang dipakai oleh `Approval` (`service/approval.go:11` membuat concrete repository). Jangan mengganti jalur itu tanpa characterization.

### Customer, location, dan mapping

Entry: masing-masing `route/customer_route.go`, `route/location_route.go`, `route/customer_location_route.go`, `route/customer_draft_route.go` dan controller pasangannya.

- `Customer.UpdateDynamic`: tiga action memiliki decode/write masing-masing, lalu log update. **SUBMIT_PROFILE saat ini lookup flag SUBMIT_LOCATION** (`customer_service_impl.go:263`); jangan diperbaiki terselubung saat mengekstrak helper.
- `UpdateProfileCustomer`: update master → `UpdateVisitAndCustomerLocation` membuka transaksi terpisah → hapus category lama → validasi kombinasi 87/88 → create category baru. Memindahkan validasi ke depan akan mengubah urutan failure dan side effect.
- `CreateDataCustomerMapping` selalu create dan tidak mengisi CompanyID pada literal; `CreateUpdateCustomerLocation` pada visit melakukan lookup terlebih dahulu dan mengisi CompanyID. Jangan menyatukan keduanya sebagai upsert generik (`customer_service_impl.go:565`, `visit_service_impl.go:1476`).
- `Location.Update`: revision limit/default 3/IsForce → update → location log → sync dengan transaksi sendiri. `CreateProcessLocation` melakukan explicit commit sebelum `CQRSCreateLocationCategory` membuka transaksi baru (`location_service_impl.go:309/317`).
- `CustomerLocation.Update`: update → `DataMappingCustomerLocation` memakai transaksi baru; delete placeholder hanya bila `No Location` ditemukan dan jumlah mapping tepat 2 (`customer_location_service_impl.go:419`).
- Draft approval memetakan field nonempty ke master, mengganti category, lalu sinkronisasi SKI (`customer_draft_service_impl.go:154`). Repository menyebut **`SKI_MF_PROD.customers` secara eksplisit** (`repository/customer_draft_repository_impl.go:73/79/85`). Mengganti default database ke DEV saja tidak membuat integration test flow ini aman; gunakan mock atau lingkungan benar-benar terisolasi yang tidak dapat menjangkau production.

### MCL / VisitCustomer

Entry: `route/visit_customer_route.go:15` → controller → `VisitCustomerService`.

Create membatasi count MCL, memeriksa struktur/category, memilih status, meng-update atau create record, memproses approval, **commit**, lalu membuka transaksi untuk reload/history (`visit_customer_service_impl.go:83`). Approve, reject, delete-approved mempunyai pemisahan transaksi serupa, dengan susunan approval/history/delete yang berbeda.

`repository/visit_customer_repository_impl.go:179` memuat row existing, selalu mengisi `OutOfCity` dan audit, mengisi field lain secara kondisional, lalu `Save`. Karena itu membuat mapper baru dengan field default berbeda dapat mereset data yang sebelumnya dipertahankan. `FindByID` juga mengubah location string kosong menjadi NULL pada projection (`:254`). Pertahankan perbedaan nil dan string kosong.

Notification self/boss (`:680/:727`) mirip dan layak berbagi mekanik token-cache, tetapi query, title, log message, dan penerimanya tetap spesifik. Callback async membaca user melalui base `service.DB`, bukan resolver transaksi.

### Structure dan period processing

`route/structure_route.go:30` memanggil rollover melalui endpoint PUT; keberadaan method tidak membuktikan scheduler production. `StructureDuplicateData` hanya bekerja tanggal 25/28. Urutan: hapus/copy structure → hapus/copy location mapping → MCL approved → credit notes → amortization → estimations → enrich cluster/priority/amortization → upsert → update cluster/amortization periode.

Ada dua bentuk dedup key: customer–structure–location dan customer–structure, serta key estimation period–product–customer–structure. Precedence sumber dan urutan slice adalah bagian dari behavior. `CreateInBatches(...,500)` langsung di service tidak memeriksa `.Error` (`structure_service_impl.go:279/299`); menambahkan pengecekan adalah bug fix, bukan ekstraksi murni.

`CreateProcessStructureBoss` memilih boss nonvacant pertama dari level 2 sampai 6 kemudian delete/rebuild. `StructureLocation.Create` memutasi `request.Period` setiap iterasi (`structure_location_service_impl.go:106`). `Customer.UpdateCluster` juga dibatasi tanggal 25/28 dan memakai periode dua bulan sebelumnya (`customer_service_impl.go:628`).

### HTML, file/network, dan reporting

- HTML mencampur query, completeness rule, template/JSON/JS, dan write. Grouping visit yang sama muncul tiga kali, tetapi **hanya ProcessCustomer yang aktif DeleteByFlag**; location/family tidak. Pertahankan urutan customer pertama muncul dan urutan setiap visit, bukan iterasi map acak.
- Address completeness memeriksa active home/practice; payload memasukkan address lain dan unknown flag menjadi practice. Jangan mengganti dua aturan tersebut dengan satu predicate yang menyamakan semantics.
- `ProcessIncentive` mempunyai user filter tetap (`html_service_service_impl.go:124`); customer processors memakai company 1. Jangan menghapus hardcode sebagai cleanup.
- GoogleMaps service menulis langsung `c.JSON/Header/Status/Writer` (`google_maps_service_impl.go:20`). Langkah awal cukup dedup mekanik proxy dalam service; pemindahan transport ke controller memerlukan kontrak return baru dan merupakan batch terpisah.
- SocialService sudah memiliki dispatcher kecil dan rule per platform. Retry X dan TikTok berbeda; limit 64KB/1MB/2MB, header, sleep, dan precedence matching harus tetap. Hindari satu configurable retry engine.
- FileService mempunyai enam reader identik dan cleanup file lebih dari enam bulan. Reader dan destructive cleanup tetap terpisah. Penambahan Close/error handling pada legacy path dinilai terpisah dari pemindahan function karena mengubah resource lifecycle/error behavior.
- Report service umumnya sudah tipis. Stored procedures berada di repository (`visit_flow_report_repository_impl.go:143/151/159`, `html_service_repository_impl.go:76`), bukan kandidat dipindah atau ditulis ulang dalam refactor service.
- `ProcessDataVisit` menggunakan dua DB dengan per-structure work; `CallTarget` membaca SKI sebelum transaksi writer delete/create. Jangan menyatukan kedua pola atau mengklaim atomic lintas DB.

## Schema: implikasi untuk menjaga behavior

Ini hasil pembandingan **source dan snapshot lokal**, bukan verifikasi schema live:

| Area | Bukti | Konsekuensi refactor |
| --- | --- | --- |
| Customer-location | `model/domain/customer_location.go:16`, katalog workspace `DATABASE_SCHEMA_CATALOG.md:750` | Composite identity; public ID hasil konkatenasi dan DeletedAt time.Time tidak boleh diganti normalisasi generik |
| Visit customer | `model/domain/visit_customer.go:16`, repository `:512`, katalog `:2380` | Nullable location/cluster dan conflict keys harus tetap; dedup map Go tidak identik dengan unique-index MySQL |
| Structures | katalog `:2178`, `model/domain/structure.go` | Identity melibatkan id + period; clone tidak boleh memakai id saja |
| HTML | repository `html_service_repository_impl.go:50`, katalog `:906` | `CreateIgnore` sebenarnya Create lalu toleransi error string duplicate; jangan mengganti menjadi skip/upsert sembarang |
| Visits | katalog `:2494`, model/repository visit | Nullable time/radius/survey serta field denormalisasi mempengaruhi response dan update |

Ada drift yang perlu dicatat: katalog mencantumkan `uk_period_structure_customer_location` tanpa company, sementara model `VisitCustomer.CompanyID` menambahkan tag index tersebut (priority 5). Tag `idx_visit_customer` pada model LocationID juga tidak sama dengan daftar kolom katalog. Selain itu dictionary `DATABASE_SCHEMA.md:47` dan katalog berbeda collation untuk visits. Jangan menjalankan AutoMigrate atau mengubah key berdasarkan dokumen ini. Refactor murni mempertahankan SQL; bila kelak ingin mengubah dedup/upsert, verifikasi metadata aktual dulu dalam task tersendiri.

## Cara bekerja per batch

Setiap batch berakhir pada deliverable yang dapat diuji sendiri. Jangan menggabungkan batch lintas domain hanya demi mengurangi jumlah langkah.

1. Catat input, output, error/panic, perubahan input, repository calls, transaction identity, dan side effect pada function target.
2. Tambah characterization test yang **lulus pada implementasi lama** dan gagal bila satu invariant sengaja dilanggar dalam eksperimen sementara. Hapus eksperimen tersebut sebelum lanjut; jangan mengubah production behavior untuk membuat test awal merah.
3. Pindahkan satu blok responsibility persis ke private helper dalam package yang sama. Awalnya pertahankan statements, urutan, dan signature public.
4. Jalankan focused tests; bandingkan result/SQL/calls/notification payload. Baru lakukan rename local atau dedup yang sudah terbukti ekuivalen.
5. Review ukuran dan alur. Target praktis helper sekitar 15–40 baris bila natural; orchestration sekitar 30–70 baris boleh lebih jika urutan bisnis tetap lebih jelas. Ini pedoman review, bukan kuota mutlak.
6. Berhenti bila perubahan menuntut transaksi/kontrak/policy baru. Catat sebagai task behavior terpisah.

### B0 — Pulihkan baseline dan kontrak test

**Files:** `test/repository_deep_visit_and_others_test.go`, `test/repository_extended_test.go`, `test/repository_remaining_deep_test.go`, `test/test_db_helper_test.go`, `test/mocks_test.go`; test per use case di bawah. Production implementation belum diubah.

- [ ] Reproduksi kegagalan VisitMember yang tercatat dalam bagian verifikasi dan konfirmasi expectation terhadap SQL existing, model, serta dependency pin. Jangan mengubah repository agar mengikuti mock yang stale.
- [ ] Sesuaikan test hanya setelah kontrak query benar-benar dipastikan, termasuk tenant/audit/soft-delete predicate; jangan melonggarkan semua argumen menjadi AnyArg.
- [ ] Pisahkan baseline deterministic dari tes SocialService yang memakai internet. Gunakan mock HTTP untuk characterization mendatang dengan default production client tetap sama.
- [ ] Tambahkan call-recording pada mock yang dibutuhkan; tidak mengganti seluruh mock framework. Gunakan dua DB handle berbeda bila identitas read/write relevan.
- [ ] Untuk flow tanggal 25/28, tambahkan seam waktu terkecil per service yang diuji dan default `time.Now`, atau private date decision menerima waktu. Jangan mencache satu now untuk mengganti banyak panggilan lama tanpa memeriksa perbedaan semantics.
- [ ] Jalankan suite baseline sampai seluruh kegagalan existing terinventarisasi. Panic pada baseline saat ini menghentikan package; test setelah titik itu belum semuanya berjalan.

**Exit:** baseline dapat dibedakan dari regresi baru; test menyatakan behavior, bukan sekadar NotNil/NotPanics. Wiring/seam adalah perubahan implementasi kecil mendatang dan tetap menunggu permintaan pelaksanaan.

### B1 — Pilot HTML: grouping dan completeness murni

**Modify:** `service/html_service_service_impl.go`; **Create:** `service/html_customer_rules.go`, `test/html_customer_characterization_test.go`; **opsional unit test private helper:** `service/html_customer_rules_test.go`; **reuse:** `test/service_html_maps_report_test.go`, `html_template/customer_profile.html`, `customer_location.html`, `customer_family.html` (template tidak diubah).

- [ ] Rekam output tiga ProcessCustomer variants: empty list, dua customer dengan visit berulang, profile lengkap/tidak, active/inactive addresses, unknown flags, single/spouse/child combinations.
- [ ] Ekstrak grouping yang mengembalikan ordered customer IDs dan map visits; pertahankan first-seen ordering.
- [ ] Ekstrak completeness family dan address sebagai function berbeda dari payload classification. Pertahankan exact strings relationship.
- [ ] Ekstrak builder `HtmlService` hanya jika audit timestamp/pengisian fields tetap identik; jangan menggabungkan aturan DeleteByFlag/CreateIgnore.
- [ ] Uji JSON payload dan HTML dengan fixture sintetis, termasuk `[]` bukan null; expected HTML menyertakan markup/JS existing, timestamp dinormalisasi hanya pada field nondeterministic.

**Contract internal yang disarankan:** `groupCustomerVisits(visits domain.VisitCustomers) ([]string, map[string][]domain.VisitCustomer)` dan `isCustomerFamilyComplete(families domain.CustomerFamilys) bool`; tidak diekspor. Caller/projection lama tetap.

**Check:** `go test -mod=readonly ./test -run 'Test(HtmlServiceService|HtmlCustomer)' -count=1`.

### B2 — Customer dynamic update

**Modify:** `service/customer_service_impl.go`; **Create:** `service/customer_dynamic_update.go`, `test/customer_dynamic_characterization_test.go`; **reuse:** `test/service_deep_customer_test.go`.

- [ ] Uji masing-masing action, unknown action, invalid JSON/date, empty arrays, existing/missing log, log counter nol, dan failure write ke-n.
- [ ] Pindahkan tiap case ke private method: submit family, submit location, submit profile. Method menerima resolver yang sudah dibuka caller; tidak membuat transaksi baru.
- [ ] Ekstrak mekanik log setelah branch tests membuktikan field dan decrement sama. Pertahankan flag lookup profile yang sekarang memakai SUBMIT_LOCATION, frekuensi log per item, serta unsigned counter behavior.
- [ ] Pertahankan switch outer sebagai alur yang langsung terbaca; unknown action tetap tidak menulis. Jangan menambahkan default error.

**Exit:** semua branches memiliki unit responsibility jelas; ordered writes, panic, dan input semantics tetap.
**Check:** `go test -mod=readonly ./test -run 'Test(CustomerService|CustomerDynamic)' -count=1`.

### B3 — Customer create/profile dan draft mapping

**Modify:** `service/customer_service_impl.go`, `service/customer_draft_service_impl.go`; **Create:** `service/customer_profile_mapping.go`, `service/customer_draft_approval.go`, `test/customer_profile_characterization_test.go`, `test/customer_draft_characterization_test.go`.

- [ ] Kunci normalisasi phone, DateOfBirth zero/nil, Hobby/Website kosong, category 87/88, category malformed, input category order, dan pemilihan file pertama.
- [ ] Pisahkan request→domain mapping, file naming/saving, category replacement, serta master/SKI mapping. Gunakan typed mapper per request yang berbeda; tanpa reflection atau bool flags untuk membedakan create/update/draft.
- [ ] Pertahankan update→sync transaksi lain→delete categories→validation→insert categories. Pisahkan function, bukan ubah urutan.
- [ ] Draft approval: uji field kosong versus populated, KS false/true, master ditemukan/tidak, SKI ditemukan/tidak, specialist list; pastikan record args persis termasuk ID behavior existing.
- [ ] Dedup upload hanya dalam flow yang filename, path, waktu, error, dan save callback-nya identik. Jangan menyamakan policy create master dan draft.

**Check:** `go test -mod=readonly ./test -run 'Test(CustomerService|CustomerDraftService|CustomerProfile|CustomerDraftCharacterization)' -count=1`.
**Exit:** mapper tidak melakukan DB/network; orchestrator menampilkan setiap persistence phase. SKI hanya mock, tidak menjalankan live sync.

### B4 — Visit planning / Create

**Modify:** `service/visit_service_impl.go`; **Create:** `service/visit_plan.go`, `test/visit_plan_characterization_test.go`; **reuse:** `test/service_deep_visit_create_and_customer_create_test.go`, `test/mocks_test.go`.

- [ ] Uji quota normal/hari ini, kategori USER/KPDM, config aktif/nonaktif/kosong, duplicate customer/NON outlet, status prefix 70, skip approval, request.Type kosong, structure-location missing.
- [ ] Ekstrak blok berurutan: jadwal, quota, customer-category policy, structure-location, duplicate rule, status selection, domain mapping, member expansion. Jangan memuat semua config lebih awal atau mengganti query individual menjadi batch.
- [ ] Pertahankan mutasi auth subordinate dan request.Type. Jangan mengganti `+7h/-7h/.Local()` menjadi timezone helper baru.
- [ ] Uji member eksplisit, ALL-prefix, duplicate, empty subordinate, vacant user; explicit member UserID pointer zero berbeda dari ALL branch nil.
- [ ] Approval tetap sebelum member persistence. Jangan memindahkan notifikasi melewati commit.

**Check:** `go test -mod=readonly ./test -run 'Test(VisitService|VisitPlan)' -count=1`.
**Exit:** Create terbaca sebagai orkestrasi berurutan, public contract dan query count tidak berubah.

### B5 — Visit check-in

**Modify:** `service/visit_service_impl.go`; **Create:** `service/visit_checkin.go`, `test/visit_checkin_characterization_test.go`.

- [ ] Uji custom/default checkin time, batas usia jadwal tepat/lebih 7 hari, accuracy/radius threshold, outlet/NON, manual radius 2×, koordinat lokasi nol/nonzero.
- [ ] Ekstrak pemilihan waktu, mapping visit/member, update lokasi branch, pemilihan flag HTML, customer-log update, approval mapping.
- [ ] Pertahankan guard koordinat memakai dua koordinat nonzero, CheckInRadius nil versus pointer zero, dan flag_time format RFC3339.
- [ ] Uji log 0→1 dan >3, random HTML selection melalui input deterministic/seam minimal, payload penerima notifikasi, serta failure sebelum/sesudah update member.

**Check:** `go test -mod=readonly ./test -run 'Test(VisitService|VisitCheckIn)' -count=1`.
**Exit:** branch GPS tidak menduplikasi mapping identik, tanpa memindahkan update/notification.

### B6 — Visit checkout, approval, reject, dan reschedule

**Modify:** `service/visit_service_impl.go`, `service/approval.go` hanya bila ada ekstraksi yang diperlukan; **Create:** `service/visit_checkout.go`, `service/visit_approval.go`, `test/visit_transition_characterization_test.go`.

- [ ] Checkout: kunci status bukan check-in, No Location/NON/outlet, survey ada/tidak, custom timestamp nil/zero/nonzero, pointer lat/lng, upload kosong/berisi/gagal.
- [ ] Pertahankan No Location memakai `timeNow` yang dipass existing, tidak otomatis memakai waktu request. Pertahankan notification yang tetap terpanggil pada branch no-update.
- [ ] Pindahkan helper checkout utuh terlebih dahulu, termasuk transaksi tambahan. Ekstrak pembentukan model dan upload di dalam boundary yang sama.
- [ ] Approval: uji status intermediate/final, menu call/meeting, expiry, KPDM wajib survey, tiap checkpoint, rejection note, dan approver/submission recipient. State machine tetap berasal dari repository.
- [ ] Reschedule: status draft/plan-approved saja, NON mapping dan IsSurvey false, synchronize customer-location hanya pada syarat existing.
- [ ] Ekstrak mapping/pure comparison yang identik; jangan satukan check-in/out radius karena manual multiplier hanya berlaku pada check-in.

**Check:** `go test -mod=readonly ./test -run 'Test(VisitService|VisitTransition)' -count=1`.
**Exit:** boundary transaksi, status strings, error precedence, path file dan notification semantics tidak berubah. Lifecycle fix dicatat terpisah.

### B7 — MCL create, delete, approval, history

**Modify:** `service/visit_customer_service_impl.go`; **Create:** `service/visit_customer_commands.go`, `service/visit_customer_approval.go`, `test/visit_customer_characterization_test.go`; **reuse:** `test/visit_customer_service_test.go`, `test/service_deep_visit_test.go`.

- [ ] Kunci MCL quota, structure tanpa user, category list ordering, existing approved vs other, location nil/string, initial status, auto-approve.
- [ ] Ekstrak validation policy, domain mapper, approval model, dan history mapper (gunakan helper existing `createVisitCustomerHistory`; jangan menyalin lagi).
- [ ] Delete: lock cluster/amortization, day threshold `>=`, auto-delete versus to-delete, endpoint approve/reject serta history status.
- [ ] Buat ordered transaction tests untuk Create/Approve/Reject/DeleteApproved. Gagal history setelah commit pertama harus dikarakterisasi sebagai partial persistence legacy, bukan diklaim rollback seluruh operasi.
- [ ] Uji `UpdateApproved` dengan duplication count 0/1/>1; pertahankan shadowing/perubahan period aktual sampai task behavior terpisah disetujui. Jangan menyimpulkan loop sudah menghasilkan bulan berurutan.
- [ ] Hindari mengganti Save semantics repository atau field default OutOfCity.

**Check:** `go test -mod=readonly ./test -run 'TestVisitCustomer' -count=1`.
**Exit:** tiap lifecycle tetap terpisah, history/approval tidak dipaksa ke generic executor.

### B8 — Monthly structure dan cluster jobs

**Modify:** `service/structure_service_impl.go`, `service/customer_service_impl.go`; **Create:** `service/structure_rollover.go`, `service/structure_boss_mapping.go`, `test/structure_rollover_characterization_test.go`, `test/customer_cluster_characterization_test.go`.

- [ ] Jalankan deterministic date cases 24/25/26/28/29, Des→Jan, empty/nonempty input, failure setiap persistence boundary; date seam default tetap clock existing.
- [ ] Ekstrak clone structures, clone locations, collect approved MCL, credit-note candidates, amortization candidates, product estimation, cluster/priority enrichment.
- [ ] Pertahankan source order, key formats, trim product IDs, nil location, skip vacant, overlap CN/amortization, audit constants, batch 500, dan update flag response.
- [ ] Dedup estimation building di dua loop boleh berbagi helper typed; pertahankan waktu assignment dan posisi append. MCL candidate policies tetap berbeda.
- [ ] Ekstrak pemilihan boss level 2→6; uji semua vacant dan setiap level pertama yang tersedia.
- [ ] Cluster job: lock batas numeric `determineCluster`, periode -2, angka parameter lookback 7, date gate, reset/delete/create order dan empty customerID skip.
- [ ] Direct GORM dipindah ke repository hanya pada batch lanjutan yang menjaga error semantics persis; jangan sekaligus memperbaiki error yang sekarang diabaikan.

**Check:** `go test -mod=readonly ./test -run 'Test(StructureService|StructureRollover|CustomerService_DeepCreateAndClusters|CustomerCluster)' -count=1`.
**Exit:** orchestrator menampilkan fase rollover; hasil batch serta urutan key/calls sama dengan fixtures lama.

### B9 — Location, customer-location, structure-city

**Modify:** `service/location_service_impl.go`, `service/customer_location_service_impl.go`, `service/structure_cities_service_impl.go`, `service/structure_location_service_impl.go`.
**Create sesuai kebutuhan:** `service/location_mapping.go`, `service/customer_location_approval.go`, `service/structure_city_cache.go`, `test/location_mapping_characterization_test.go`.

- [ ] Kunci revision default/config/IsForce, LocationSub pointer, name derivation, photo filename, category replace dan explicit commit sebelum category create.
- [ ] Customer-location: lock status approve/confirm/draft, start/end periods, best/work hour empty policy, duplicate behavior per entrypoint dan placeholder No Location.
- [ ] Structure-city: lock DB-write→approval→file ordering, auth/request structure differences, file missing/present/corrupt, empty response pada read error, write failure yang sekarang hanya dilog.
- [ ] Pisahkan file-cache helper dari business mapping tanpa mengganti error policy atau invalidation timing. Approve/reject/delete cache behavior tidak diseragamkan.
- [ ] Structure-location: kunci config count 0/1/>1, struktur missing, mapping existing/new, request.Period mutation, dan response iterasi terakhir. Jangan menambah fallback return untuk nil sebagai cleanup.

**Check:** `go test -mod=readonly ./test -run 'Test(LocationService|CustomerLocationService|StructureCitiesService|StructureLocationService|LocationMapping)' -count=1`.
**Exit:** dependency/side effects lebih terlihat; scope dan behavior setiap domain tetap berbeda bila sebelumnya berbeda.

### B10 — File, product upload, GoogleMaps, Social, notifications

Laksanakan sebagai sub-batch terpisah: **B10a files/product**, **B10b Maps**, **B10c Social**, **B10d MCL notifications**. Tidak harus saling menunggu.

**Modify:** `service/file_service_impl.go`, `service/product_service_impl.go`, `service/google_maps_service_impl.go`, `service/social_service_impl.go`, `service/visit_customer_service_impl.go`.
**Create:** `test/file_io_characterization_test.go`, `test/maps_proxy_characterization_test.go`, `test/social_characterization_test.go`, `test/visit_customer_notification_characterization_test.go`; helper file hanya jika memudahkan navigasi.

- [ ] File readers: fixture path valid/missing/empty/error; satukan reader mekanik dengan legacy panic boundary. Cleanup umur file tidak dipanggil pada folder runtime; fixture temporary saja. Jangan menambahkan security/path policy baru dalam task ini.
- [ ] Product: duplicate create/update upload, size tepat/lebih 1MB, nil versus nonnil-empty image slice, filename ID/time, no-image update field. Jika helper membuat defer Close lebih dini, catat sebagai perubahan resource lifecycle terpisah dan uji sebelum memasukkannya.
- [ ] Maps: empat endpoint diuji dengan mock HTTP; assert URL/query encoding, upstream status/body/header, invalid latlng format/range, transport/read errors. Dedup proxy helper boleh tetap menggunakan Gin di boundary existing; public interface tidak diubah.
- [ ] Social: classifier pure per platform; HTTP fixtures untuk 200/404/login wall/captcha/private, case matching, retry count/headers/body limit/delay/error. Pisahkan policy retry X/TikTok. Default timeout tidak berubah.
- [ ] MCL notification: query self/boss tetap terpisah; helper token-cache/sending menerima title dan data yang eksplisit. Test duplicate user, ID 0, nil/empty token, send error, title, message, jumlah lookup dan ordering. Test seam default mempertahankan async launch timing/base DB access.

**Check:** `go test -mod=readonly ./test -run 'Test(File|ProductService|GoogleMapsService|MapsProxy|SocialCharacterization|VisitCustomerNotification)' -count=1`; race test hanya setelah dependency async dapat diisolasi.
**Exit:** tidak memakai generic retry engine, generic uploader lintas semua domain, atau notification queue baru.

### B11 — Service tipis, naming, dan report/batch adapters

**Files:** implementation yang diklasifikasikan ringan pada inventaris akhir, serta `service/visit_flow_report_service_impl.go`, `service/process_data_visit_service_impl.go`, `service/call_target_service_impl.go`, kedua estimation services.

- [ ] Rename lokal yang menyesatkan: constructor parameter `city`→nama repository yang sesuai, `Companys`→`companies`, `structure_locations`→`structures` ketika memang berisi structure, `fileKpt`→`ktpFiles`, `nextMont`→`nextMonth`. Nilai SQL/JSON dan exported names tidak disentuh.
- [ ] Hapus komentar salinan atau code commented-out hanya bila tidak menghilangkan penjelasan alasan bisnis. `confirmation_status.go` kosong bukan prioritas; boleh dibiarkan.
- [ ] Pertahankan CRUD mapping eksplisit jika sudah pendek. Jangan mengekstrak literal lima field menjadi helper hanya agar semua function di bawah angka tertentu.
- [ ] Report/estimation adapters: pertahankan order args, error translation, Qty nil/zero, HNA multiplication, pointer timestamp, dan procedure names. Tidak menulis ulang repository.
- [ ] ProcessDataVisit: beri nama tahap potential customer/per-structure visit; jangan mengaktifkan commitment block yang dikomentari, mengubah loop jadi parallel, atau menambahkan transaksi global.
- [ ] CallTarget: pertahankan source read sebelum writer begin dan panic rollback; helper transaksi generik tidak diperlukan.

**Check:** test per family pada `test/service_master_test.go`, `service_core_test.go`, `area_config_service_test.go`, `report_service_test.go`, `service_deep_product_misc_test.go`, `service_deep_visit_create_and_customer_create_test.go`; kemudian suite package.
**Exit:** perapihan lokal yang manfaatnya terlihat, tanpa abstraction baru untuk CRUD.

### B12 — Review compatibility dan verifikasi akhir

- [ ] Re-run setiap batch pada kode final; compile seluruh package dan manual route wiring tetap valid.
- [ ] HTTP characterization menggunakan Gin + recovery yang sama, dengan output/headers/status/validation/not-found/business errors dibandingkan baseline.
- [ ] Bandingkan ordered repository calls, handles, args, query count, affected fields, fixture rows, approval/history/notification payload, input mutation, dan file output.
- [ ] Jalankan semua test deterministic dan full suite setelah network test dimock; jangan menyatakan full suite hijau bila masih skip atau panic existing.
- [ ] Jalankan `go vet -mod=readonly ./...` dan race pada paths async yang disentuh. Jalankan formatter hanya pada file yang diubah saat implementasi; tahap plan ini tidak menjalankan formatter.
- [ ] Jika ingin membuktikan real FK/constraint/replica/rollback, gunakan integration environment yang aman dan review seluruh cross-schema reference. DEV write harus melalui persetujuan SQL konkret sesuai AGENTS workspace; tidak memakai production untuk verification write.
- [ ] Review readability: orchestrator dibaca atas-ke-bawah, nama menjelaskan business step, helper tidak menyembunyikan commit/I/O, tidak ada `utils.go` serba-guna, parameter tidak berupa kumpulan flag yang sulit diartikan.
- [ ] Laporkan hasil actual, failure existing, gap integration, dan perubahan behavior yang sengaja tidak dilakukan. Tidak commit/push/merge/operasi Git.

## Perubahan yang sengaja dikeluarkan dari refactor struktural

| Temuan | Mengapa dipisah |
| --- | --- |
| Resolver membuka dua transaksi; defer umumnya hanya writer | Mengubah lifecycle/replica visibility/rollback memerlukan desain dan MySQL integration test |
| Checkout/sync/history memakai transaksi terpisah | Menggabungkan mengubah atomicity dan partial-failure behavior |
| Notification terjadi sebelum commit atau menggunakan Gin context pada goroutine | After-commit/context lifetime baru mengubah delivery/cancellation timing |
| Parse error diabaikan, config index `[0]`, nil token, file handle/Walk errors | Guard/error baru mengubah failure mode; diagnosis dan regression test khusus diperlukan |
| MCL approval period loop/shadowing; profile log SUBMIT_LOCATION | Perubahan business output/log; tidak dibenahi hanya karena terlihat seperti typo |
| Duplicate-company/index drift dan unscoped/broad write | Perlu konfirmasi schema dan policy, bukan normalisasi string/key |
| Role enforcement dan hardcoded user/company | Mengubah siapa/data apa yang boleh diproses |
| SQL batching/N+1/cache/performance tuning | Bisa mengubah order, visibility, error timing; manfaat harus diukur |
| Semua Gin interfaces→context.Context atau exported legacy naming | Dampak controller/callers/mocks besar; manfaat tidak sebanding pada tahap awal |

Mempertahankan behavior bukan menyatakan semua behavior lama benar. Temuan tersebut dipertahankan dalam baseline dan diselesaikan melalui task perbaikan terpisah bila diminta.

## Kriteria selesai setelah implementasi nantinya

Refactor selesai hanya jika (1) responsibilities terpisah secara natural; (2) public contract dan urutan business flow tetap; (3) focused serta existing tests berjalan dengan hasil yang tercatat; (4) tidak ada regresi baru pada error/data/side effect yang diuji; (5) wiring/interface/mocks konsisten; (6) tidak ada perubahan query/migration/authorization tersembunyi. Tidak ada jaminan absolut semua fitur bebas regresi dari unit test saja; gap runtime, MySQL, dan layanan eksternal harus dituliskan.

Urutan pelaksanaan yang digunakan: **B0 → B1 → B2 → B3 → B4 → B5 → B6 → B7 → B8 → B9 → B10 per sub-batch → B11 → B12**. Detail checklist tetap menjadi catatan criteria characterization; status aktual ada pada tabel pelaksanaan di atas dan hasil test di bawah.

## Hasil verifikasi yang benar-benar dijalankan

- `go test -mod=readonly ./... -count=1 -timeout=180s` — lulus semua package, tanpa skip. `TestSocialService_Coverage` kini memakai HTTP fixture deterministik.
- `go vet -mod=readonly ./...` — lulus.
- `go test -race -mod=readonly ./test -run '^(TestVisitCustomerService_DeleteAndRecommendations_FullBranches|TestVisitCustomerService_DeepMethods)$' -count=1 -timeout=180s` — lulus pada test MCL notification async yang disentuh; race detector tidak dijalankan pada seluruh suite.
- Test terarah untuk `TestClassify*`, customer-location mapping, rollover/cluster, location mapping/cache, product upload, Maps, Social, Visit, dan MCL — lulus.

Baseline awal menunjukkan mismatch sqlmock pada lima kasus: soft-delete VisitMember dan delete Product mengharapkan argumen tambahan; Structure.Update mengharapkan argumen tambahan; StructureLocation.Update mengharapkan argumen bind yang tidak dipakai; LocationLocationCategory.Update tidak mengharapkan argumen `id` tambahan. Ekspektasi di `test/repository_deep_visit_and_others_test.go`, `test/repository_extended_test.go`, dan `test/repository_remaining_deep_test.go` diselaraskan dengan SQL yang benar-benar dibentuk repository, tanpa mengubah kode query production.

Sebelumnya `TestSocialService_Coverage` melakukan request jaringan. Test kini menggunakan transport fixture, sehingga full suite berjalan tanpa pengecualian dan tanpa koneksi layanan eksternal. Mock resolver (`test/test_db_helper.go:43`) menggunakan handle Read/Write yang sama, jadi hasil test tidak membuktikan replica visibility atau atomicity MySQL. Tidak dilakukan live integration, deployment smoke test, atau benchmark; tidak ada klaim coverage persen atau jaminan runtime production bebas regresi.

## Inventaris awal 39 implementation beserta dependency

Path berikut relatif terhadap `/Users/takahashiumaru/Documents/company-projects/visitflow/visit-flow-go`; ukuran dan function terpanjang adalah baseline sebelum refactor. Dependency di kolom mencakup field repository dan concrete repository yang dibuat dalam body (hasil ekstraksi source, bukan runtime call graph). Detail use case berisiko telah dijelaskan di atas.

| Implementation | Baris | Function terpanjang | Batch / keputusan | Repository dependencies | Route wiring |
| --- | ---: | --- | --- | --- | --- |
| `service/approval_service_impl.go` | 40 | `NewApprovalService` (11, L20) | B11: Tipis; local naming saja. Approval transition tetap pada approval.go. | ApprovalRepository | `route/approval_route.go` |
| `service/area_recomendation_estimation_service_impl.go` | 155 | `AreaRecomendationEstimationServiceImpl.Update` (33, L96) | B11: Adapter pendek; Qty pointer, HNA lookup, not-found translation tetap. | AreaRecomendationEstimationRepository | `route/area_recomendation_estimation_route.go` |
| `service/area_service_impl.go` | 132 | `AreaServiceImpl.Create` (27, L45) | B11: CRUD pendek; Update memicu async location sync dengan transaksi tersendiri. | AreaRepository, LocationRepositoryImpl | `route/areas_route.go` |
| `service/bridging_product_specialist_service_impl.go` | 54 | `NewBridgingProductSpecialistService` (11, L20) | B11: Read adapter sudah pendek; tidak perlu helper baru. | BridgingProductSpecialistRepository | `route/bridging_product_specialist_route.go` |
| `service/call_target_service_impl.go` | 51 | `CallTargetServiceImpl.CallTargetProcess` (21, L31) | B11: Cross-DB source read lalu writer delete/create; transaction ownership eksplisit. | CallTargetRepository | `route/call_target_route.go` |
| `service/company_service_impl.go` | 118 | `CompanyServiceImpl.Create` (27, L46) | B11: CRUD cukup jelas; rename city/Companys lokal tanpa generic service. | CompanyRepository | `route/company_route.go` |
| `service/config_service_impl.go` | 137 | `ConfigServiceImpl.Create` (29, L60) | B11: Auth/no-auth read berbeda; nilai serta periode config tidak dinormalisasi. | ConfigRepository | `route/config_route.go` |
| `service/customer_category_service_impl.go` | 118 | `CustomerCategoryServiceImpl.Create` (27, L46) | B11: CRUD sederhana; preserve group/code dan sumber company. | CustomerCategoryRepository | `route/customer_category_route.go` |
| `service/customer_customer_category_service_impl.go` | 116 | `CustomerCustomerCategoryServiceImpl.Create` (26, L46) | B11: Mapping CRUD; company berasal request pada create/update, tetap. | CustomerCustomerCategoryRepository | `route/customer_customer_category_route.go` |
| `service/customer_draft_service_impl.go` | 284 | `CustomerDraftServiceImpl.UpdateApprove` (131, L154) | B3: Upload/upsert draft dan master+SKI approval; typed mappers. | CustomerCustomerCategoryRepositoryImpl, CustomerDraftRepository, CustomerRepository | `route/customer_draft_route.go` |
| `service/customer_hobby_service_impl.go` | 78 | `CustomerHobbyServiceImpl.Create` (23, L45) | B11: Tiga operasi pendek; naming data hasil query lebih jelas. | CustomerHobbyRepository | `route/customer_hobby_route.go` |
| `service/customer_location_service_impl.go` | 538 | `CustomerLocationServiceImpl.Create` (85, L73) | B9: Mapping, state transitions, placeholder cleanup, hidden deps/transaksi. | ApprovalRepository, ConfigRepository, CustomerLocationRepository, CustomerRepositoryImpl, LocationRepositoryImpl, StructureBosRepository, StructureLocationRepository, StructureRepositoryImpl, UserRepository, UserRepositoryImpl | `route/customer_location_route.go` |
| `service/customer_service_impl.go` | 708 | `CustomerServiceImpl.UpdateDynamic` (140, L145) | B2/B3/B8: Dynamic actions, upload/profile/category, sync dan cluster jobs. | ConfigRepository, CustomerAddressRepository, CustomerCustomerCategoryRepositoryImpl, CustomerFamilyRepository, CustomerLocationRepositoryImpl, CustomerLogRepository, CustomerRepository, LocationRepositoryImpl, StructureCityRepositoryImpl, UserRepositoryImpl, VisitRepositoryImpl | `route/customer_route.go` |
| `service/dashboard_promotion_service_impl.go` | 53 | `DashboardPromotionServiceImpl.Process` (11, L43) | B11: Read HTML/process adapter; tidak perlu dipotong lagi. | DashboardPromotionRepository | `route/dashboard_promotion_route.go` |
| `service/file_service_impl.go` | 100 | `FileServiceImpl.DeleteFileOlder6Month` (21, L80) | B10a: Enam reader identik; retention cleanup terpisah. | HTTP/filesystem; tanpa repository | `route/file_route.go` |
| `service/google_maps_service_impl.go` | 136 | `GoogleMapsServiceImpl.GeocodeReverse` (43, L70) | B10b: Empat proxy response block duplikat; public Gin contract tetap. | HTTP/filesystem; tanpa repository | `route/google_maps_route.go` |
| `service/html_service_service_impl.go` | 975 | `HtmlServiceServiceImpl.ProcessCustomerFamily` (118, L849) | B1: Grouping, completeness, rendering, persistence dipisah; template strings tetap. | CustomerAddressRepository, CustomerFamilyRepository, CustomerRepository, HtmlServiceRepository, UserRepository, VisitCustomerRepository | `route/html_service_route.go` |
| `service/location_categories_service_impl.go` | 114 | `LocationCategoryServiceImpl.Create` (25, L46) | B11: CRUD sudah pendek; pertahankan nama public legacy. | LocationCategoryRepository | `route/location_categories_route.go` |
| `service/location_group_service_impl.go` | 132 | `LocationGroupServiceImpl.Create` (35, L51) | B11: CRUD + satu upload; jangan generalisasi semua uploader. | LocationGroupRepository | `route/location_group_route.go` |
| `service/location_location_categories_service_impl.go` | 127 | `LocationLocationCategoryServiceImpl.Create` (26, L46) | B11: CRUD + join adapter; source company/request dipertahankan. | LocationLocationCategoryRepository | `route/location_location_categories_route.go` |
| `service/location_service_impl.go` | 561 | `LocationServiceImpl.CreateProcessLocation` (107, L209) | B9: Revision policy, upload/categories, approval, denormalized sync. | ApprovalRepository, AreaRepositoryImpl, ConfigRepository, CustomerLocationRepositoryImpl, LocationGroupRepositoryImpl, LocationLocationCategoryRepositoryImpl, LocationLogRepository, LocationRepository, LocationSubRepositoryImpl, StructureBosRepository, StructureCityRepositoryImpl, UserRepository, VisitRepositoryImpl | `route/location_route.go` |
| `service/location_sub_service_impl.go` | 114 | `LocationSubServiceImpl.Create` (25, L46) | B11: CRUD sederhana; local names saja. | LocationSubRepository | `route/location_subs_route.go` |
| `service/process_data_visit_service_impl.go` | 68 | `ProcessDataVisitServiceImpl.InsertDataVisitProcess` (31, L38) | B11: Potential import per structure; jangan aktifkan commitment commented-out. | DataCommitmentRepository, DataPotentialRepository, StructureAllRepository | `route/process_data_visit.go` |
| `service/product_recommendation_estimation_service_impl.go` | 90 | `ProductRecommendationEstimationServiceImpl.Update` (26, L65) | B11: Read/update tipis; quantities dan pointer/time mapping tetap. | ProductRecommendationEstimationRepository | `route/product_recommendation_estimation_route.go` |
| `service/product_service_impl.go` | 224 | `ProductServiceImpl.Create` (56, L88) | B10a: Create/update upload duplikat; retain size/filename/error differences. | ProductRepository | `route/product_route.go` |
| `service/social_service_impl.go` | 347 | `SocialServiceImpl.checkTikTok` (56, L208) | B10c: Classifier per platform + HTTP; jangan satukan policy retry. | HTTP/filesystem; tanpa repository | `route/social_route.go` |
| `service/structure_bos_service_impl.go` | 123 | `StructureBosServiceImpl.Create` (30, L46) | B11: CRUD pendek; public Bos/Id tetap demi compatibility. | StructureBosRepository | `route/structure_boss_route.go` |
| `service/structure_cities_service_impl.go` | 366 | `StructureCityServiceImpl.Create` (72, L67) | B9: Approval + JSON cache + filesystem failure semantics. | ApprovalRepository, ConfigRepository, StructureBosRepository, StructureCityRepository, StructureCityRepositoryImpl, StructureRepositoryImpl, UserRepository | `route/structure_cities.go` |
| `service/structure_location_service_impl.go` | 161 | `StructureLocationServiceImpl.Create` (59, L55) | B9: Multi-period loop, request mutation, config count; jangan ubah nil path. | ConfigRepository, StructureLocationRepository, StructureRepositoryImpl | `route/structure_location_route.go` |
| `service/structure_position_service_impl.go` | 117 | `StructurePositionServiceImpl.Create` (27, L46) | B11: CRUD; checkpoint mapping commented-out tidak diaktifkan. | StructurePositionRepository | `route/structure_position_route.go` |
| `service/structure_service_impl.go` | 537 | `StructureServiceImpl.StructureDuplicateData` (309, L229) | B8: Rollover dan boss selection dipisah dari CRUD. | ProductRecommendationEstimationRepositoryImpl, StructureBosRepository, StructureLocationRepositoryImpl, StructureRepository, VisitCustomerRepositoryImpl | `route/structure_route.go` |
| `service/visit_api_log_service_impl.go` | 120 | `VisitApiLogServiceImpl.Create` (27, L46) | B11: CRUD log, bukan HTTP caller; jangan menambah request dispatch. | VisitApiLogRepository | `route/visit_api_log_route.go` |
| `service/visit_api_service_impl.go` | 119 | `VisitApiServiceImpl.Create` (27, L46) | B11: CRUD konfigurasi API; preserve request fields. | VisitApiRepository | `route/visit_api_route.go` |
| `service/visit_customer_service_impl.go` | 772 | `VisitCustomerServiceImpl.Create` (123, L83) | B7/B10d: MCL lifecycle/history dan dua async notification paths. | ApprovalRepository, ConfigRepository, ConfigRepositoryImpl, CustomerCustomerCategoryRepositoryImpl, CustomerRepositoryImpl, StructureBosRepository, StructureRepositoryImpl, UserRepository, VisitCustomerRepository | `route/visit_customer_route.go` |
| `service/visit_flow_report_service_impl.go` | 111 | `NewVisitFlowReportService` (11, L20) | B11: Sudah tipis; query/procedure tetap di repository. | VisitFlowReportRepository | `route/visit_flow_report_route.go` |
| `service/visit_member_service_impl.go` | 139 | `VisitMemberServiceImpl.Create` (35, L46) | B11: CRUD + projection; baseline repository mock failure dicatat terpisah. | VisitMemberRepository | `route/visit_member_route.go` |
| `service/visit_product_service_impl.go` | 150 | `VisitProductServiceImpl.Create` (29, L56) | B11: CRUD + estimation filter extraction sudah sederhana. | VisitProductRepository | `route/visit_product_route.go` |
| `service/visit_service_impl.go` | 1512 | `VisitServiceImpl.Create` (275, L101) | B4–B6: Planning/check-in/checkout/approval/report/file dalam satu implementation. | ApprovalRepository, ConfigRepository, ConfirmationStatusRepository, CustomerCustomerCategoryRepositoryImpl, CustomerLocationRepositoryImpl, CustomerLogRepository, CustomerRepositoryImpl, HtmlServiceRepository, LocationRepositoryImpl, OutletSurveyRepositoryImpl, StructureBosRepository, StructureLocationRepositoryImpl, StructureRepository, StructureRepositoryImpl, UserRepository, UserRepositoryImpl, VisitMemberRepository, VisitMemberRepositoryImpl, VisitRepository | `route/visit_route.go` |
| `service/vw_product_service_impl.go` | 41 | `NewVwProductService` (11, L20) | B11: Satu read adapter; tidak perlu abstraction tambahan. | VwProductRepository | `route/vw_product_route.go` |

## Inventaris interface dan file pendukung

Semua interface dipertahankan pada batch pertama. Nama public legacy `Bos`, `HtmlServiceService`, `Recomendation`, dan ejaan filename yang berbeda tidak diubah sebagai cleanup lintas modul.

| File | Baris | Keputusan |
| --- | ---: | --- |
| `service/approval.go` | 21 | Approval lookup/status panic contract; hidden concrete dependency belum diganti. |
| `service/approval_service.go` | 11 | Pertahankan public contract `ApprovalService`. |
| `service/area_recomendation_estimation_service.go` | 17 | Pertahankan public contract `AreaRecomendationEstimationService`. |
| `service/area_service.go` | 15 | Pertahankan public contract `AreaService`. |
| `service/bridging_product_specialist_service.go` | 12 | Pertahankan public contract `BridgingProductSpecialistService`. |
| `service/call_target_service.go` | 5 | Pertahankan public contract `CallTargetService`. |
| `service/company_service.go` | 15 | Pertahankan public contract `CompanyService`. |
| `service/config_service.go` | 16 | Pertahankan public contract `ConfigService`. |
| `service/confirmation_status.go` | 1 | Hanya package declaration; biarkan, tidak perlu perubahan demi metrik. |
| `service/customer_category_service.go` | 15 | Pertahankan public contract `CustomerCategoryService`. |
| `service/customer_customer_category_service.go` | 15 | Pertahankan public contract `CustomerCustomerCategoryService`. |
| `service/customer_draft_service.go` | 17 | Pertahankan public contract `CustomerDraftService`. |
| `service/customer_hobby_service.go` | 13 | Pertahankan public contract `CustomerHobbyService`. |
| `service/customer_location_service.go` | 26 | Pertahankan public contract `CustomerLocationService`. |
| `service/customer_service.go` | 26 | Pertahankan public contract `CustomerService`. |
| `service/dashboard_promotion_service.go` | 11 | Pertahankan public contract `DashboardPromotionService`. |
| `service/file_service.go` | 13 | Pertahankan public contract `FileService`. |
| `service/google_maps_service.go` | 12 | Pertahankan public contract `GoogleMapsService`. |
| `service/html_service_service.go` | 15 | Pertahankan public contract `HtmlServiceService`. |
| `service/location_categories.go` | 15 | Pertahankan public contract `LocationCategoryService`. |
| `service/location_group_service.go` | 18 | Pertahankan public contract `LocationGroupService`. |
| `service/location_location_categories.go` | 16 | Pertahankan public contract `LocationLocationCategoriesService`. |
| `service/location_service.go` | 24 | Pertahankan public contract `LocationService`. |
| `service/location_sub_service.go` | 15 | Pertahankan public contract `LocationSubService`. |
| `service/process_data_visit_service.go` | 7 | Pertahankan public contract `ProcessDataVisitService`. |
| `service/product_recommendation_estimation_service.go` | 13 | Pertahankan public contract `ProductRecommendationEstimationService`. |
| `service/product_service.go` | 18 | Pertahankan public contract `ProductService`. |
| `service/social_service.go` | 5 | Pertahankan public contract `SocialService`. |
| `service/structure_bos_service.go` | 16 | Pertahankan public contract `StructureBosService`. |
| `service/structure_cities_service.go` | 17 | Pertahankan public contract `StructureCityService`. |
| `service/structure_location_service.go` | 15 | Pertahankan public contract `StructureLocationService`. |
| `service/structure_position_category_service.go` | 15 | Pertahankan public contract `StructurePositionService`. |
| `service/structure_service.go` | 19 | Pertahankan public contract `StructureService`. |
| `service/visit_api_log_service.go` | 15 | Pertahankan public contract `VisitApiLogService`. |
| `service/visit_api_service.go` | 15 | Pertahankan public contract `VisitApiService`. |
| `service/visit_customer_service.go` | 22 | Pertahankan public contract `VisitCustomerService`. |
| `service/visit_flow_report_service.go` | 18 | Pertahankan public contract `VisitFlowReportService`. |
| `service/visit_member_service.go` | 16 | Pertahankan public contract `VisitMemberService`. |
| `service/visit_product_service.go` | 17 | Pertahankan public contract `VisitProductService`. |
| `service/visit_service.go` | 38 | Pertahankan public contract `VisitService`. |
| `service/vw_product_service.go` | 11 | Pertahankan public contract `VwProductService`. |

## Contoh ekstraksi B1 yang diterapkan

Contoh helper internal berikut menunjukkan grouping yang mempertahankan urutan kemunculan pertama. Public interface tidak berubah.

```go
func groupCustomerVisits(visits domain.VisitCustomers) ([]string, map[string][]domain.VisitCustomer) {
    customerIDs := make([]string, 0, len(visits))
    visitsByCustomer := make(map[string][]domain.VisitCustomer, len(visits))
    for _, visit := range visits {
        if _, exists := visitsByCustomer[visit.CustomerID]; !exists {
            customerIDs = append(customerIDs, visit.CustomerID)
        }
        visitsByCustomer[visit.CustomerID] = append(visitsByCustomer[visit.CustomerID], visit)
    }
    return customerIDs, visitsByCustomer
}
```

`service/html_customer_rules_test.go` mengunci urutan ID dan urutan visit per customer, termasuk input kosong dan customer ID kosong. Test service yang ada tetap mencakup boundary repository.

Dokumen ini dimulai sebagai refactor plan di workspace parent dan diperbarui setelah pelaksanaan. Salinan ini menyertai perubahan service/test pada branch Clean Code agar rationale dan hasil verifikasinya dapat direview bersama source. Catatan “tidak ada perubahan Git” merujuk pada saat hasil audit awal ditulis, sebelum permintaan branch dan push.
