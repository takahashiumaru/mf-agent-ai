# Perbaikan hasil audit data dan JSON Presence

Tanggal: 27 September 2026. Status: diterapkan pada working tree, belum di-commit atau di-deploy. Menindaklanjuti empat temuan dalam [audit sebelum perbaikan](2026-09-27-presence-data-json-audit.md).

## Perubahan

| Temuan | Perbaikan | Bukti kode |
| --- | --- | --- |
| Approval HRD memilih tahun kuota yang salah / saldo negatif | Memakai `leave.Period` tersimpan, company/user/category yang sama, quota aktif, saldo non-null dan cukup; unpaid melewati debit. Saldo nol tetap ditulis melalui pointer. | `service/leave_quota_allocation.go:59`, `repository/leave_quota_repository_impl.go:356` |
| Approval HRD berulang memotong saldo lagi | Lock leave sesuai ID/company dan quota menggunakan `FOR UPDATE` dalam satu transaksi writer. Status `approved hrd` langsung mengembalikan hasil tanpa debit/update/notifikasi. | `service/leave_approval.go:54`, `repository/leave_repository_impl.go:251` |
| JSON check-out parsial | Sesudah update, reload row dan Office dari transaksi write yang sama, lalu gunakan mapper/DTO yang sudah ada. | `service/presence_service_impl.go:100`, `repository/presence_repository_impl.go:750` |
| Hasil Pondasi dibaca sebelum write terlihat | Final read memakai transaksi yang melakukan insert/update; kegagalan final read me-rollback write. Alur tanpa write tetap memakai read handle. | `service/presence_service_impl.go:140` dan `:168` |
| Notifikasi approval dapat terkirim saat commit gagal | Helper menyelesaikan commit sebelum mengembalikan fungsi notifikasi. Caller baru menjalankannya setelah helper berhasil. | `service/leave_service_impl.go:396`, `service/leave_approval.go:54` |

## Kontrak dan dampak

- Route, request DTO, response DTO, nama key JSON, tipe field, dan mapper tidak diubah.
- Create cuti sekarang menolak `days` nol/negatif, bukan kelipatan 0.5, NaN, atau tak hingga sebelum membuka transaksi; bentuk request/response tetap sama.
- Nilai JSON check-out sengaja diperbaiki: user, check-in, audit fields, jadwal/departemen, serta Office berasal dari hasil reload, bukan objek update parsial. Nilai tidak dipaksa non-null jika memang null pada database.
- Kuota tidak dialihkan ke tahun lain saat saldo periode alokasi habis; approval ditolak dengan jenis/pesan error kuota yang sudah digunakan sebelumnya.
- Approval ID milik company lain ditolak oleh lookup scoped (not-found). Tidak ada perubahan umum kebijakan role.
- HRD memakai satu transaksi writer untuk seluruh read/write approval; tidak membuka transaksi replica tambahan.
- Check-out menambah satu SELECT dengan join Office berbasis primary key. Lookup leave memakai ID/company; lookup quota dibatasi satu row menurut user/category/company/period/active dengan urutan ID. Tidak ada query tambahan per item, perubahan schema, indeks, atau dependency.
- Metadata `DATABASE_SCHEMA_CATALOG.md` menunjukkan kolom saldo nullable dan primary key quota; uniqueness quota meliputi rentang tanggal, bukan hanya period. Perbaikan ini tidak merombak alokasi atau membersihkan duplikasi data historis. Eksekusi plan dan contention produksi belum diukur.

## Verifikasi aktual

Seluruh tes berada di `test/`, package `test`. Database dan HTTP menggunakan mock/transport in-memory.

| Pemeriksaan | Hasil |
| --- | --- |
| `go test ./... -count=1 -coverpkg=./... -coverprofile=/tmp/presence-fixes-coverage.out -json` | 345 kasus/subtes lulus; 0 gagal |
| `go tool cover -func=/tmp/presence-fixes-coverage.out` | 97,8% seluruh package |
| `go test -race ./test -count=1` | Lulus |
| `go vet ./...` | Lulus |
| `go build ./...` | Lulus |
| `git diff --check`, `gofmt -l service repository test` | Bersih |
| Review spec dan standar | Tidak ada temuan correctness/standar tersisa pada perbaikan ini |

Tes regresi membuktikan kegagalan sebelum fix dan keberhasilan setelahnya untuk pemilihan periode, retry approval, JSON check-out, transaksi final-read Pondasi, dan notifikasi saat commit gagal.

Cakupan tambahan: periode berjalan/sebelumnya, saldo setengah hari menjadi nol, unpaid tanpa quota, quota hilang/null/nol/negatif/tidak cukup, SQL lock dan company scope, SQL error/not-found, kegagalan begin/lock/debit/update/commit, rollback ketika reload check-out/Pondasi gagal, dan key/nilai JSON check-out.

Tes utama: `test/leave_hrd_integrity_test.go`, `test/approval_repository_lock_test.go`, `test/leave_service_rejection_coverage_test.go`, `test/presence_workflow_test.go`, `test/presence_pondasi_workflow_test.go`.

## Batas pembuktian

SQL mock membuktikan bentuk query dan penggunaan transaksi, bukan perilaku dua transaksi MySQL nyata yang berlomba. Race detector memeriksa race Go, bukan lock database. Uji konkurensi MySQL terisolasi dan end-to-end deployment belum dilakukan; tidak ada klaim aman 100% atau seluruh data historis sudah benar.

Tidak ada query mutasi DEV/PROD, migrasi, perbaikan saldo historis, atau commit. Temuan legacy lain dalam laporan audit tetap di luar perbaikan ini. `make lint` sebelumnya terhalang incompatibility konfigurasi dengan golangci-lint terpasang; konfigurasi/tool tersebut tidak diubah.

## Tindak lanjut clean code dan ketahanan error

- Approval HRD sekarang membaca maksimal dua kuota aktif untuk kombinasi user/kategori/company/periode. Bila ada lebih dari satu, transaksi rollback dengan error domain sebelum saldo dipotong; identitas baris kuota belum tersimpan pada leave sehingga kasus ganda tidak dapat dipilih secara aman hanya dari periode.
- Pemeriksaan agregat read-only pada `VISITFLOW_MF_PROD` tanggal 27 September 2026 tidak menemukan grup kuota aktif ganda untuk periode 2025, 2026, atau 2027. Hasil ini tidak menjamin data baru atau periode lain.
- Notifikasi meeting serta create/approval/rejection koreksi absensi dijadwalkan setelah commit berhasil dan memakai context baru dengan timeout melalui helper yang sudah ada. Tidak ada perubahan route atau DTO.
- Notifikasi leave create, manager approval/rejection, HRD rejection, dan HRD cancellation kini dijadwalkan setelah commit berhasil. Payload dan urutan query/write dipertahankan.
- HRD cancellation/rejection mengunci leave berdasarkan ID dan company, mengembalikan kuota hanya untuk cuti `paid`, memakai kuota aktif dari company/periode yang tersimpan, dan menolak transisi berulang sebelum saldo dapat dikreditkan dua kali. Baris kuota bersaldo nol tetap dapat ditemukan dan dikreditkan.
- Alur transaksi service leave kini memakai satu transaksi writer yang dibagi untuk read/write terkait; `ValidateQuota` memakai query biasa dan `FindProofPhoto` tidak membuka transaksi database. File bukti yang dibaca ditutup setelah selesai.
- Operasi create/approval meeting, presence, attendance correction, serta update kuota nonaktif kini juga berbagi satu transaksi writer untuk read/write yang saling bergantung. Tidak ada lagi pemanggilan `goHelper.CreateTransaction` di service yang membuka handle read tanpa finalisasi.
- Checkout meeting dengan waktu check-in `nil` atau nol mengembalikan error validasi yang sama, bukan panic nil pointer.
- Finalisasi transaksi pada alur update leave dipasang sebagai deferred function langsung agar panic tetap memicu rollback melalui semantik helper transaksi; regression test memaksa lookup kategori gagal sesudah write dan memastikan rollback, bukan commit.
- CSV kalender kosong, kolom kurang, dan baris rusak menghasilkan error domain sebelum write; file upload ditutup. Valid CSV tetap mengikuti urutan delete/create dan mengembalikan baris pertama.
- Pemrosesan kuota memakai satu timestamp per eksekusi. Request Pondasi meneruskan context request untuk pembatalan; fallback ERP-only pada error Pondasi tetap mengikuti perilaku lama.

Tes regresi untuk CSV kosong/kolom kurang/baris rusak, kuota aktif ganda, serta rollback leave saat lookup gagal lulus. Pemeriksaan terbaru: `go test ./... -count=1`, `go test -race ./test -count=1`, `go vet ./...`, `go build ./...`, `gofmt`, dan `git diff --check` lulus. Tes tersebut memakai mock dan tidak membuktikan persaingan transaksi MySQL atau pengiriman FCM nyata. Perubahan ini tetap lokal dan belum di-commit/deploy.

Error Pondasi tetap memakai fallback ERP-only ketika upstream gagal. Konkurensi DB nyata dan pengiriman FCM/email production belum diuji.
