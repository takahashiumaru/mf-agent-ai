# Audit ulang SOLID, Design Patterns, dan kompatibilitas

Tanggal: 27 September 2026. Target: working tree `refactor/presence-service-clean-code`, dibandingkan dengan checkpoint `781d5e7`. Dua bug HRD yang teridentifikasi sudah diperbaiki atas permintaan user; perubahan belum di-commit/push. Status alur `leave` juga diverifikasi lewat query konfigurasi terbatasi dalam transaksi production read-only, tanpa membaca data pengajuan atau saldo.

## Kesimpulan

Struktur refactor sudah sesuai pendekatan Go yang pragmatis: dependency disusun melalui route, kontrak lookup dipersempit, transport Pondasi terpisah, dan service tetap memiliki orkestrasi/transaksi. Tidak ditemukan regresi runtime baru dari diff refactor yang diperiksa. Dua masalah transisi/kuota HRD yang sudah ada pada checkpoint kini diperbaiki dan memiliki regression test.

## Temuan

### P1 — FIXED: Penolakan HRD menambah kuota sebelum debit

- `service/leave_hrd.go:81` hanya menerima penolakan dari `confirm 2`; baris 99 memanggil `restorePaidLeaveQuota`.
- `service/leave_quota_allocation.go:89` menambahkan `leaveData.Days` ke saldo DB.
- Create menggunakan `leaveAllocationQuota.allocate` (baris 44) untuk mengurangi variabel lokal; debit persisten ada di `consumeApprovedHrdQuota` (baris 59), dipanggil saat approval HRD (`service/leave_hrd.go:138`). Manager approval tidak mendebit kuota.
- Contoh menurut jalur kode lokal: saldo 10, pengajuan paid 1 hari, ditolak saat `confirm 2` → saldo 11. Ini dapat berulang melalui pengajuan ulang dan penolakan berikutnya.
- `test/leave_service_rejection_coverage_test.go:115` justru mengharapkan penambahan saldo. Test hijau mempertahankan perilaku itu, bukan membuktikan integritas saldo.
- Perbaikan: `UpdateRejectedHrd` tidak lagi memanggil `restorePaidLeaveQuota`; refund tetap dilakukan saat pembatalan pengajuan yang sudah `approved hrd`.
- Regression test sekarang memastikan penolakan dari `confirm 2` tidak memanggil lookup/update kuota dan saldo tetap. Test cancellation memastikan refund tetap ada.
- Asal: bug ada pada checkpoint. Trigger/proses eksternal dan saldo/data produksi tidak diperiksa.

### P1 — FIXED: Approval HRD belum membatasi status asal

- `service/leave_hrd.go:134` hanya menangani idempotensi ketika status sudah `approved hrd`; semua status lain lanjut ke debit kuota dan perubahan menjadi approved.
- Route `route/leave_route.go:41` dan controller `controller/leave_controller_impl.go:190` langsung meneruskan approval. `repository/leave_repository_impl.go:251` mengunci berdasarkan ID/company tanpa filter status.
- Akibatnya request approval atas record `cancel` atau `rejected hrd` dapat diteruskan sampai debit/update bila dependency dan saldo memenuhi kondisi. Lock baris menjaga serialisasi, tetapi tidak memvalidasi transisi status.
- Konfigurasi production `confirmation_statuses` untuk `leave` yang diperiksa read-only memuat `input`, `confirm 1`, `confirm 2`, dan `approve hrd`; kondisi route manager mengirim ke endpoint HRD ketika hasilnya `confirm 2`. Record `approved hrd` tetap ditangani sebagai retry idempotent.
- Perbaikan: sesudah lock baris, approval HRD hanya memproses `confirm 2`; status lain mengembalikan error bisnis sebelum kuota, approval, atau notifikasi dijalankan.
- Regression test meliputi `input`, `confirm 1`, `cancel`, dan `rejected hrd`, serta memastikan tidak ada debit/write lanjutan. Test retry `approved hrd` tetap lulus.
- Asal: tidak ada guard pada checkpoint; ini bukan regresi ekstraksi file. Query production hanya memeriksa konfigurasi status, bukan keadaan leave tertentu.

### P2 — FIXED: Panduan GORM bertentangan dengan implementasi

- `.agent/GORM.md:115` mencontohkan `goHelper.CreateTransaction` dengan reader/writer terpisah dan menyebut meeting/correction/leave sebagai contoh.
- `service/transaction.go:11` sekarang memakai satu writer transaction untuk kedua field resolver.
- `.agent/GORM.md:131` menyatakan tidak ada row locking; `repository/leave_repository_impl.go:253` dan `repository/leave_quota_repository_impl.go:359` memakai `clause.Locking{Strength: "UPDATE"}`.
- Perbaikan: `.agent/GORM.md` sekarang menjelaskan resolver writer bersama dan row lock yang dipakai repository. Validator tautan tidak membuktikan semantik; isi dicocokkan langsung dengan source.

## Penilaian SOLID dan pola desain

| Aspek | Penilaian berdasarkan source |
| --- | --- |
| Single Responsibility | Membaik: file leave mengikuti operasi bisnis; transport/parsing Pondasi keluar dari service. Satu tipe service masih mengoordinasikan satu domain, sesuai kebutuhan sekarang. Pemisahan file sendiri bukan bukti SRP sempurna. |
| Open/Closed | Lookup, HTTP transport, dan pemilih status dapat diganti melalui constructor tanpa mengedit badan workflow. Tidak perlu registry atau framework tambahan. |
| Liskov Substitution | Signature lookup sesuai implementasi produksi; fake menguji transaksi/panic pada skenario terpilih. Tidak ada pelanggaran baru ditemukan; tidak membuktikan semua kemungkinan implementasi substitusi. |
| Interface Segregation | `UserLookup` hanya `FindByID`; `OfficeUserLookup` hanya `FindByUserID`. Interface service lama masih luas, tetapi dipakai controller/mocks; belum ada alasan memecahnya secara mekanis. |
| Dependency Inversion | Construction berpindah ke route. Coupling ke GORM, model gateway, dan concrete client Pondasi masih ada secara sengaja; ini bukan Clean Architecture yang independen framework. |
| Design Patterns | Manual constructor injection, service layer, repository, serta adapter/wrapper parser kompatibilitas digunakan dengan alasan konkret. Tidak ditemukan kebutuhan generic repository, singleton, event bus, CQRS, atau DI framework. |

## Pemeriksaan kompatibilitas

- AST function comparison: 175 deklarasi checkpoint → 173 deklarasi service sekarang. 13 deklarasi berbeda/hilang sesuai perubahan yang direncanakan: empat constructor, lookup presence, pemanggilan fungsi status, wrapper parser, dan penghapusan dua helper construction/HTTP. Pemindahan method lain mempertahankan deklarasi/badan.
- Tidak ada diff pada `model/`, `controller/`, `repository/`, `exception/`, `auth/`, `go.mod`, atau `go.sum` terhadap checkpoint.
- Diff route hanya wiring constructor; path, HTTP method, handler, dan role slice tetap.
- `service/transaction.go` dan `service/leave_notification.go` tidak berubah terhadap checkpoint.
- Request Pondasi tetap GET, endpoint/query/timeout 15 detik sama, body ditutup, error/fallback dan skip record invalid dipertahankan. Merge ERP tetap di service.
- Signature constructor Go berubah; caller lokal sudah diperbarui. Consumer Go di luar workspace tidak diverifikasi.
- Skema lokal `../DATABASE_SCHEMA_CATALOG.md:1120` dan `:1155` diperiksa: saldo nullable serta business key company/user/kategori/tanggal tetap relevan. Katalog adalah snapshot, bukan bukti schema/data produksi saat ini.

## Verifikasi yang dijalankan ulang

- `go test ./... -count=1`: lulus.
- `go test -race ./test -count=1`: lulus.
- `go vet ./...`: lulus.
- `go build ./...`: lulus.
- `git diff --check`: lulus sebelum penulisan laporan; diperiksa ulang setelahnya.
- Seluruh 76 file `*_test.go` aplikasi berada di `test/`; regression test kuota/status ditambahkan ke file test yang sudah ada di folder itu.

SQLMock dan HTTP fake menguji skenario terpilih. Query production read-only hanya memvalidasi konfigurasi status, bukan saldo atau record. Tes tidak membuktikan locking MySQL nyata, delivery notifikasi, semua data/schema production, atau keamanan seluruh endpoint. Jalankan ulang status/quota tests dan pemeriksaan source sebelum memperluas state transition lain.
