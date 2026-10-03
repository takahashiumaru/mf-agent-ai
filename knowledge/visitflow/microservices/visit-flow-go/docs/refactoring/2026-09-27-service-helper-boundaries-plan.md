# Plan ulang batas service dan helper

Tanggal: 27 September 2026. Baseline lokal: `2a6f5c9`, branch `refactor/package-design-solid-dependency`.
Status: **P1–P4 diimplementasikan di branch `refactor/service-helper-boundaries` tanpa commit atau push; P5 ditunda**.

## Kesimpulan

Ekstraksi sebelumnya memperpendek function, tetapi keputusan mempertahankan semua hasil ekstraksi di package `service` terlalu luas. Mekanisme teknis yang tidak menentukan business policy layak dipindahkan ke `helper`; business rule dan orchestration tetap di service walaupun berupa function kecil atau pure function.

Prioritas konkret: normalisasi telepon yang benar-benar duplikat, parser respons provider sosial, pembacaan/penulisan file cache kota, lalu mekanisme copy upload product. Hindari menjadikan `helper` tempat seluruh mapper, approval, query, dan transaksi. Tidak semua file harus dipindahkan utuh.

Plan ini memperinci dan merevisi keputusan penempatan helper pada [laporan Clean Code](2026-09-27-visit-flow-go-service-clean-code.md), serta menjadi tahap awal yang lebih kecil dari [plan Package Design](2026-09-27-visit-flow-go-package-design-plan.md). Pilot package domain yang lebih besar tetap ditunda. [Audit regression](2026-09-27-visit-flow-go-regression-audit.md) tetap berlaku; penguatan assertion approval tidak menutup semua gap lainnya.

## Bukti dan batas analisis

- Menelusuri fungsi hasil ekstraksi dalam service, caller dan test terkait, fungsi teknis lain pada file service, serta utility existing di helper. Pendalaman pada customer/draft, social, file/product, structure-city, Maps, notification, dan aturan visit/rollover.
- `go list -mod=readonly` berhasil untuk 12 package lokal. Dependency lokal yang teramati: `service → helper, auth, repository, model/domain, model/web`; `helper → model/domain → model/web`; `repository → helper, model/domain, model/web`. Tidak ada import cycle pada source saat ini.
- Parser sosial terhubung melalui [route](../../route/social_route.go:14), [controller](../../controller/social_controller_impl.go:21), lalu service. Kontrak response tetap `valid`, `message`, `platform`, dan `username`.
- File route/controller memilih path dan memanggil enam method FileService; baca byte berada di [readFileContents](../../service/file_service_impl.go:44).
- Ini analisis penempatan kode lokal, bukan audit seluruh endpoint, live database, atau runtime production. Tidak menjalankan test aplikasi, request eksternal, maupun query database pada tahap ini. Hasil test sebelumnya adalah bukti historis.

## Aturan penempatan

| Jenis responsibility | Pemilik |
| --- | --- |
| Tenant, auth, status, quota, approval, kategori, pemilihan penerima, urutan side effect, transaksi | `service` |
| Transformasi string yang sama di beberapa flow, parsing format provider, mekanisme file I/O tanpa business decision | `helper` atau subpackage helper yang kohesif |
| Parsing request dan penulisan response HTTP | `controller`; adapter legacy ditangani terpisah |
| Query, filter tenant pada query, persistence | `repository` |
| Mapping request yang sekaligus memilih status, company, audit field, default bisnis | Tetap dekat use case di `service` |

Helper baru tidak mengimpor `service`, `controller`, `route`, `auth`, atau `repository`; tidak menerima `*ServiceImpl`, resolver transaksi, maupun seluruh request HTTP untuk melakukan pekerjaan teknis. Pemakaian model bertipe pada serializer cache dapat diterima: dependency `helper → model/domain` sudah ada. Jangan memperluas dependency tersebut untuk memindahkan business policy ke helper.

Pure function bukan otomatis utility umum: `isStructureRolloverDay`, completeness customer, dan `visitApprovalMenu` tetap business rule. Sebaliknya, helper teknis boleh memiliki file I/O asalkan input/output, error, dan ownership resource jelas.

## Matriks pemindahan

| Source / bagian | Keputusan dan tujuan | Alasan / kontrak penting |
| --- | --- | --- |
| [normalizeCustomerPhone](../../service/customer_profile_mapping.go:77) dan blok identik [draft customer](../../service/customer_draft_service_impl.go:75) | Pindah ke `helper/phone.go`: `NormalizeCustomerPhone(string) string` | Dipakai create, update profile, dan draft. Hanya menghapus ASCII space dan `+`; bukan validasi nomor atau konversi kode negara. |
| [social_response_classification.go](../../service/social_response_classification.go:8) | Pindah empat classifier dan test pure ke `helper/socialprofile/response.go` dan `response_test.go` | Satu kelompok parser provider, cukup bergantung pada standard library. Subpackage mengisolasi parser dari dependency Firebase/GORM yang sudah ada pada package helper utama. |
| [readDataFromFile / writeDataToFile](../../service/structure_cities_service_impl.go:265) | Pindah ke `helper/structure_city_file.go` sebagai `ReadStructureCitiesFile` dan `WriteStructureCitiesFile` | Serializer/file I/O bertipe. Pertahankan JSON indent satu spasi, permission `0644`, pesan log, dan kebijakan error legacy pada tahap pemindahan. |
| [appendStructureCityCache](../../service/structure_city_cache.go:10) | Tetap di service, panggil helper file | Memutuskan query rows versus isi file, append, dan apakah flow berhenti. Itu kebijakan cache/use case, bukan serializer. |
| Blok `os.Create → multipart.Open → io.Copy` pada [writeProductImage](../../service/product_image.go:17) | Ekstrak ke `helper/upload.go`: `CopyUploadedFile(file, destination, registerCloser) error` | Mekanisme byte-copy tidak perlu mengetahui ID product, batas ukuran, atau nama file. Parameter callback mempertahankan kepemilikan close yang sudah ada. |
| `maxProductImageSize`, nama file/timestamp, path product, pilihan image pertama, nil/empty behavior, `closeProductImageFiles` | Tetap di service | Policy upload dan lifecycle transaksi. Jangan pindahkan seluruh `product_image.go` ke helper. |
| [readFileContents](../../service/file_service_impl.go:44) | Kandidat teknis, tunda dari batch mekanis awal | Saat ini membuka file tanpa Close. Memindahkan persis menyalin leak; langsung mengganti `os.ReadFile` sekaligus mengubah lifecycle. Rekomendasi task resource-fix kecil terpisah dengan test, memakai standard library langsung jika helper hanya akan menjadi wrapper satu baris. |
| [proxyGoogleMapsResponse](../../service/google_maps_service_impl.go:78) | Tunda pemindahan utuh | Mencampur HTTP fetch dan response Gin. Memindahkannya ke helper hanya memindahkan coupling. Pisahkan adapter fetch dan controller response pada task transport tersendiri, dengan karakterisasi kontrak. |
| `customer_profile_mapping.go` selain normalisasi; `location_mapping.go`; `customer_draft_approval.go` | Tetap di service | Menentukan company/audit/status/default, aturan patch nonzero, kategori dan nama/path upload; bukan mapper teknis bebas policy. |
| `html_customer_rules.go` | Tetap di service | Family/address completeness dan grouping untuk flow HTML customer. Tidak ada kebutuhan reusable utility lintas domain yang terbukti. |
| `customer_dynamic_update.go`, `customer_cluster.go` | Tetap di service | Command dispatch/log, kalkulasi cluster, periode minus dua bulan, history dan persistence. |
| `structure_rollover.go` | Tetap di service | Tanggal 25/28, kandidat, prioritas, dedup/amortisasi, copy/enrichment adalah business behavior meskipun sebagian pure. |
| `visit_plan.go`, `visit_checkin.go`, `visit_checkout.go`, `visit_approval.go` | Tetap di service | Schedule/quota/status, radius policy, survey, approval dan transaction order. Perhitungan jarak umum sudah menggunakan helper Haversine existing. |
| `visit_customer_commands.go`, `visit_customer_notifications.go` | Tetap di service | Pilihan penerima/token, skip, query, dan urutan pengiriman berada di use case. Transport FCM sudah ada di helper; jangan membawa repository lookup ke helper. |
| `saveCustomerProfileImages`, `saveLocationImage`, `saveVisitProofs` | Tetap di service pada tahap ini | Mutasi model, format nama, folder, timestamp, dan urutan upload berbeda. Callback upload existing sudah cukup; jangan membuat upload framework untuk menyatukannya. |

## Helper existing: reuse dan batas

- `helper/path.go`, `formulation_radius.go`, `get_image.go`, `json.go`, dan `send_message.go` sudah menyediakan primitive/path/integrasi. Gunakan sesuai kontrak aktual.
- `helper/json.go` menangani HTTP request/response, bukan file cache. Serializer structure-city sebaiknya di file tersendiri agar dua responsibility tidak digabung karena sama-sama JSON.
- `helper/get_image.go` melakukan resize/decode/encode PNG; jangan dipakai sebagai pengganti copy byte upload, karena hasil file dapat berubah.
- Helper existing sendiri masih bercampur: approval policy, CSV query+HTTP, dan fungsi teknis. Keberadaannya tidak menjadi alasan menambah DB/business orchestration baru ke helper. Pemisahan helper legacy itu bukan bagian batch awal.
- [CreateFileJsonCityData](../../repository/structure_cities_repository_impl.go:86) tampak mirip cache service, tetapi mempunyai query, create/truncate sebelum marshal, wrapper error, close-error handling, dan response projection berbeda. Jangan menggantinya langsung dengan helper serializer service; pelajari sebagai task repository/I/O terpisah.

## Dependency dan API target

```text
controller → service → repository
                ├──→ helper                    # phone, typed cache file I/O, copy upload
                └──→ helper/socialprofile      # pure provider response parsers

helper → model/domain → model/web               # existing local dependency
helper/socialprofile → standard library
```

- Subpackage `socialprofile` tidak perlu interface, client, constructor, atau registry. Empat function bernama `ClassifyInstagramResponse`, `ClassifyFacebookResponse`, `ClassifyXResponse`, `ClassifyTikTokResponse` cukup.
- Pindahkan ownership konstanta message yang diperlukan classifier ke subpackage. Pertahankan konstanta exported `service.MsgAccountFound`, `service.MsgAccountNotFound`, dan `service.MsgBlocked` sebagai alias const agar caller/test existing kompatibel; service tidak diduplikasi string. Konstanta connection error/limit yang masih milik transport tidak wajib ikut pindah.
- Helper phone menerima/return string; cache memakai `domain.StructureCities`; copy upload menerima `*multipart.FileHeader`, destination string, dan callback `func(io.Closer)`. Tidak ada interface buatan baru atau dependency module tambahan.
- Helper copy mengembalikan error asli. Service tetap memanggil `helper.PanicIfError` di boundary existing; jangan wrap error dengan pesan baru yang mengubah mapping middleware.
- Jangan menyisakan wrapper service untuk setiap helper yang dipindah hanya agar test lama tidak perlu berubah. Ubah caller dan pindahkan test pure; public service interface tetap kompatibel.

## Urutan pelaksanaan yang diusulkan

### P0 — Kunci snapshot dan kontrak yang benar-benar disentuh

1. Periksa diff lokal saat implementasi dimulai; jangan menimpa perubahan lain.
2. Inventaris caller/test serta exported constant yang terpengaruh. Simpan baseline dari source sebelum pemindahan.
3. Siapkan salinan test terisolasi tanpa `.env`/service-account/data produksi, HTTP fixture, dan direktori file sementara. Audit test startup/CWD agar file upload/cache tidak menulis ke workspace asli atau menghubungi provider.
4. Karakterisasi celah yang relevan sebelum memindahkan file/cache/upload. Jangan menganggap test suite hijau membuktikan urutan resource atau error branch yang belum diassert.

### P1 — Normalisasi telepon bersama

Files: buat `helper/phone.go`, `helper/phone_test.go`; ubah `service/customer_profile_mapping.go` dan `service/customer_draft_service_impl.go`.

- Pindahkan dua replace yang sama tanpa regexp, E.164, trim whitespace lain, atau normalisasi prefix.
- Ganti tepat tiga pemakaian: create customer, update profile via mapper, dan create/update draft.
- `submitCustomerProfile` memakai `request.Telepon` langsung di [customer_dynamic_update.go](../../service/customer_dynamic_update.go:72); **jangan** otomatis menormalisasinya karena behavior-nya berbeda.
- Test input kosong, `+62 812`, beberapa `+`, tab/newline, tanda minus, Unicode whitespace; pastikan hanya karakter existing yang dibuang. Pertahankan test mapping customer/draft sebagai pengaman caller.

### P2 — Parser sosial sebagai kelompok helper tersendiri

Files: pindahkan `service/social_response_classification.go` dan test-nya ke `helper/socialprofile/`; ubah caller dan const alias dalam `service/social_service_impl.go`.

- Pertahankan urutan matching: Instagram 404 mendahului marker, X suspension mendahului account marker, TikTok captcha mendahului 404; pertahankan case sensitivity dan seluruh message string.
- Pertahankan batas Facebook 1000/38000 serta Instagram 100 byte; jangan menafsirkan ulang provider heuristics.
- Client, retry/delay, URL, header, dan batas read body tetap pada flow existing. Tidak melakukan request provider nyata dalam test.
- Pindahkan table tests existing, tambahkan boundary yang belum teruji, lalu jalankan fixture service `TestSocialService_Coverage` dan controller contract yang relevan.

### P3 — Pisahkan serializer/file cache dari policy cache

Files: buat `helper/structure_city_file.go` dan test; ubah `service/structure_cities_service_impl.go`, `service/structure_city_cache.go`, serta `service/structure_city_cache_test.go`.

- Pindahkan dua function I/O bertipe dengan nama spesifik; tahap ini mempertahankan return type serta log/error semantics existing (read mengembalikan error; write log-and-return). Ini kompatibilitas legacy, bukan pola error baru untuk seluruh helper.
- Test JSON exact formatting, nil (`null`) versus empty (`[]`), read missing/corrupt file, write gagal, byte output, serta file mode pada kondisi umask yang dikendalikan.
- Tetap uji policy append di service: file missing menggunakan query rows, file existing menggunakan isi file, file corrupt menghentikan flow, dan gagal write saat ini tidak otomatis membuat append mengembalikan false. Mengubah perilaku terakhir adalah bugfix terpisah.
- Jangan mengubah refresh query, menambahkan cache-hit bypass DB, lock, atomic rename, atau memindahkan write keluar transaksi dalam batch ini.

### P4 — Ekstrak mekanisme copy upload dengan ownership tetap

Files: buat `helper/upload.go`, `helper/upload_test.go`; ubah hanya blok copy dalam `service/product_image.go`; test caller di `test/` diperkuat bila perlu.

- Urutan helper: create destination → register destination closer → open multipart → register source closer → copy. Jika open source gagal, destination harus sudah terdaftar untuk cleanup caller.
- Service tetap memegang daftar closer dan defer penutupan terbalik. Jangan menutup file di helper atau memindahkan defer transaksi. Close error existing tetap diabaikan pada batch mekanis.
- Batas 1MB, pesan error, `MkdirAll` sebelum nil check, sampling waktu, pemilihan image pertama, dan perbedaan nil versus slice kosong tetap persis existing. Empty non-nil slice saat ini dapat panic; jangan diam-diam menjadikannya no-op.
- Test content byte, create/open/copy failure, urutan register/close dan close sebelum finalisasi transaksi, nil/empty, tepat 1MB dan lebih besar; gunakan recorder/fake kecil sesuai dependency yang benar-benar diuji.
- Existing `TestProductService_ImageUploadBranches` dan `TestFileAndProductService_DeepPhoto` membantu caller coverage, tetapi bukan bukti lengkap lifecycle/close order.

### P5 — Tunda perubahan yang membutuhkan keputusan behavior/transport tersendiri

- File reader: koreksi kebocoran file handle harus dinyatakan sebagai resource bugfix tersendiri. Bandingkan error/byte behavior sebelum memilih `os.ReadFile`; jangan membuat abstraction hanya untuk membungkus standard library.
- Maps: pisahkan fetch dari rendering HTTP setelah test reach-error versus body-read-error, status passthrough, body, header, dan Close tersedia. Jangan menambah timeout/context/retry saat sekadar memindahkan responsibility karena failure mode ikut berubah.
- Pemisahan I/O repository cache dan penataan helper legacy dapat menyusul setelah batch kecil terbukti bermanfaat. Tidak perlu mengerjakan seluruhnya sekaligus.

## Verifikasi saat implementasi, bukan hasil tahap plan

Jalankan di salinan test terisolasi yang sudah diaudit:

```sh
# Setelah destination package tersedia:
go test -mod=readonly ./helper/... ./service -count=1
# Pilih named tests caller yang disentuh dan pastikan bukan "no tests to run".
go test -mod=readonly ./test -run 'Test(SocialService_Coverage|GoogleMapsService_AllEndpoints|ProductService_ImageUploadBranches|FileAndProductService_DeepPhoto|StructureCitiesService_DeepMethods)' -count=1
go test -mod=readonly ./... -count=1 -timeout=180s
go vet -mod=readonly ./...
go list -mod=readonly ./...
```

Pilih focused test sesuai batch; Maps tidak perlu dijalankan ulang hanya karena pemindahan phone. Race test hanya untuk jalur concurrency yang disentuh. Periksa gofmt pada file Go yang berubah dan `git diff --check`; jangan menjalankan tidy/upgrade atau coverage updater sebagai bagian pemindahan.

Syarat selesai per batch: business decision tetap terlihat di service, helper tidak menarik dependency balik, tidak ada duplicate implementation, public contract/error/side-effect order tetap, tests caller dan helper berjalan, dan celah verifikasi dilaporkan. Untuk perubahan ini tidak perlu migration atau DB mutation; unit/sqlmock tidak membuktikan MySQL/FCM production.

## Hasil tahap ini

Plan ini dieksekusi pada worktree terpisah di branch `refactor/service-helper-boundaries`; checkout tempat dokumen ini berada tetap tidak menerima perubahan source. Batch P1–P4 selesai: normalisasi telepon dipusatkan, classifier response sosial dipindahkan ke `helper/socialprofile`, I/O file structure city dipisahkan ke helper, dan copy upload diekstrak sambil mempertahankan ownership closer di service. P5 tetap ditunda sesuai keputusan plan.

Verifikasi pada salinan test sementara yang tidak menyertakan `.env` atau service account: `go test ./...`, `go vet -mod=readonly ./...`, `go list -mod=readonly ./...`, serta `git diff --check` lulus. Test service/helper dan test integrasi image tepat 1 MiB juga lulus. Test tidak mengirim request ke provider sosial; suite memunculkan error konfigurasi Firebase yang tertangani oleh test dan tidak membuktikan pengiriman FCM berhasil. Tidak ada verifikasi MySQL/runtime production.

Coverage karakterisasi: test nil versus slice kosong, batas Facebook, dan file mode terkontrol ditambahkan. Jalur `io.Copy` failure dan observasi runtime urutan close-before-transaction-finalization belum punya test langsung; urutan defer existing pada service tidak dipindahkan. Tidak ada klaim bebas regresi absolut.

Perubahan source berada di worktree `.worktrees/service-helper-boundaries`, branch tersebut belum di-commit atau di-push. File plan tetap untracked di checkout asal; Git index tidak diubah.
