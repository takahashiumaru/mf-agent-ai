# Audit kompatibilitas data dan JSON — Presence

> Laporan ini merekam keadaan **sebelum perbaikan**. Empat temuan utama telah diperbaiki pada working tree; lihat [hasil perbaikan dan verifikasi terbaru](2026-09-27-presence-data-json-fixes.md). Klaim kompatibilitas baseline di bawah berlaku untuk snapshot audit awal.

Tanggal: 27 September 2026. Baseline: `c13066ccfbbbc260c310393ea4b63bfbf1b45e31` (HEAD). Target: working tree saat audit, termasuk file service/test baru yang belum di-track.

## Kesimpulan

Tidak ditemukan regresi baru yang terkonfirmasi akibat pemisahan service pada alur yang ditinjau dan skenario yang diuji. Bukti kompatibilitas kuat pada kontrak lokal dan mock-based workflows, tetapi bukan jaminan seluruh kondisi produksi. Ada masalah data/response lama yang masih dipertahankan; kompatibel dengan versi lama tidak berarti seluruh perilaku lama sudah benar.

Tidak ada source aplikasi, database, atau konfigurasi koneksi yang diubah. Tidak ada commit. Tes dan instrumentasi tambahan dibuat pada salinan sementara terpisah; file rahasia dan konfigurasi service tidak disalin.

## Bukti kompatibilitas

| Pemeriksaan | Hasil |
| --- | --- |
| Route, controller, repository, model/domain, model/web, helper, auth, exception, app, dependency | Tidak ada diff terhadap HEAD |
| Interface service | Tidak ada diff |
| Fungsi/method service exported | 110 signature identik, diperiksa dengan Go AST |
| Kumpulan tes yang sama pada kode lama dan refactor | 311 kasus/subtes lulus di masing-masing versi, memakai 69 file tes terkini |
| Coverage seluruh package | 97,7% pada kedua versi; statement yang diekstrak berubah jumlahnya sehingga persentase bukan bukti tunggal |
| Perbandingan serialisasi JSON | 304 hasil per versi, 44 mapper, 225 grup test/mapper |
| Field/tipe/nilai non-waktu, null, array dan urutannya pada hasil tersebut | Tidak ditemukan perbedaan |
| Timestamp dinamis | 56 nilai berbeda pada 25 grup, seluruhnya waktu eksekusi/fixture `time.Now`; selisih terbesar 0,002903 detik, offset sama |
| `go test -race -count=1 ./test` | Lulus pada salinan refactor tanpa instrumentasi |
| `go vet ./...`, `go build ./...` | Lulus pada working tree |
| `git diff --check`, `gofmt -l service/*.go test/*.go` | Lulus / tidak ada keluaran format |
| `make lint` | Tidak berjalan: konfigurasi golangci-lint tidak didukung versi tool terpasang; `.golangci.yml` tidak diubah oleh refactor |

Tes lama dan baru dijalankan pada dua salinan terisolasi dengan source berbeda dan kumpulan tes identik. Untuk audit JSON, return value mapper dibungkus sementara dengan serialisasi `encoding/json` dan ditangkap per test/mapper. Nilai bukan waktu, kehadiran key, null, tipe dan urutan array dibandingkan. Perbedaan timestamp dibaca dan diklasifikasikan; tidak membuang semua field waktu secara global. Instrumentasi kemudian dilepas sebelum race test.

Bukti ini meliputi mapper/domain dan service dengan mock/spy serta tes controller yang tersedia. Ini belum merupakan perbandingan seluruh endpoint pada MySQL nyata sampai respons HTTP produksi. Tidak ada endpoint produksi dipanggil atau database dimutasi dalam audit.

## Temuan data yang sudah ada sebelum refactor

### P1 — Persetujuan HRD dapat memotong kuota periode yang salah hingga negatif

- Lokasi: `service/leave_quota_allocation.go:45` dan `:71`; pemanggil `service/leave_service_impl.go:406`.
- Pembuatan leave memilih kuota tahun berjalan jika kuota sebelumnya tidak cukup. Saat persetujuan HRD, keberadaan kuota tahun sebelumnya dengan saldo non-null sudah cukup untuk memilihnya; periode yang tersimpan pada leave dan kecukupan saldo tidak dijadikan syarat.
- Contoh: leave paid 1 hari, periode 2026, kuota 2025 tersisa 0,5. Approval menulis saldo -0,5 pada kuota 2025 dan mengganti period leave ke 2025.
- Tes karakterisasi sementara `TestAuditHrdApprovalCanDebitInsufficientPreviousQuota` membuktikan debit -0,5 dan penulisan periode lama pada **kedua versi**. Tes tersebut membuktikan adanya perilaku lama, bukan menyatakan perilakunya benar.
- Saran: putuskan sumber kuota sesuai periode alokasi, validasi saldo dan perusahaan, serta lakukan pembacaan/perubahan saldo secara atomik pada transaksi write. Lindungi dengan tes saldo pecahan, lintas tahun, dan konkurensi.

### P1 — Approval HRD ulang masih dapat mendebit kuota

- Lokasi: `service/leave_service_impl.go:403`.
- Record dimuat lalu kuota dikurangi tanpa guard yang menolak/mengabaikan status `approved hrd` yang sudah selesai. Permintaan yang diulang dapat memotong saldo kembali.
- Tes karakterisasi sementara `TestAuditHrdApprovalCanDebitAlreadyApprovedLeave` memberikan record yang sudah approved dan membuktikan debit serta update approval tetap dilakukan pada **kedua versi**.
- Saran: definisikan hasil retry yang idempoten dan lindungi transisi dengan status/lock atau conditional update di transaksi yang sama. Tes retry serta dua request bersamaan diperlukan.

### P2 — JSON check-out tidak berisi row database lengkap

- Lokasi: `service/presence_create.go:73`, `repository/presence_repository_impl.go:139`, `model/domain/presence.go:93`.
- Service membangun objek parsial dengan ID dan field check-out. Repository menjalankan `Updates` lalu mengembalikan objek itu tanpa reload.
- Akibatnya JSON dapat memiliki `user_id: 0`, field check-in bernilai nol, dan Office kosong meskipun row database mempertahankan data check-in/user yang sudah ada. Ini tidak membuktikan field database terhapus.
- `test/presence_workflow_test.go:119` secara eksplisit mempertahankan `result.UserID == 0`; respons ini juga cocok pada audit kedua versi.
- Saran: jika kontrak yang diinginkan adalah row lengkap, reload/merge secara benar melalui transaksi write dan tambahkan tes JSON lengkap. Perbaikan ini mengubah nilai respons lama sehingga perlu diperlakukan sebagai perubahan kontrak terencana.

### P2 — Respons Pondasi dapat belum menampilkan write pada request yang sama

- Lokasi: `service/presence_service_impl.go:140` dan `:164`.
- Insert/update dijalankan dalam transaksi dengan commit deferred. Pembacaan akhir menggunakan `readDB` di luar transaksi sebelum commit.
- Pada isolasi MySQL normal, pembacaan itu tidak melihat write yang belum committed; read replica dapat menambah lag. Pemicu adalah request yang menghasilkan perubahan dari Pondasi.
- Susunan ini identik pada HEAD. Mock pada `test/presence_pondasi_workflow_test.go:32` langsung mengembalikan objek yang dibuat dan tidak mensimulasikan visibilitas transaksi.
- Saran: baca hasil lewat transaksi yang sama atau tetapkan urutan commit dan pembacaan dari writer dengan jelas. Uji pada MySQL terisolasi; mock saja tidak membuktikan konsistensi ini.

## Risiko lama tambahan dan celah tes

- Token Firebase nil dapat dipakai pada goroutine rejection koreksi absensi (`service/attendance_correction_approval.go:52` dan `:98`), sehingga panic berada di luar recovery request. Alur ini sudah ada pada baseline; tes sekarang memakai pointer token yang tidak nil.
- Notifikasi sebelum commit, efek file upload yang tidak dapat di-rollback bersama MySQL, dan CSV kalender kosong masih merupakan perilaku lama yang dicatat dalam rencana refactor.
- Cabang Desember pada pemrosesan kuota belum diuji deterministik: `test/leave_quota_service_process_coverage_test.go:55` mengikuti bulan aktual. Tes pada September tidak membuktikan alur regenerasi tahun berikutnya saat Desember.
- Metadata schema yang dibaca mendukung analisis nullability dan key, tetapi audit ini tidak memeriksa apakah baris produksi sedang mengalami saldo negatif, null, atau inkonsistensi tersebut.

## Rekomendasi

Refactor dapat ditinjau sebagai pemisahan kode yang mempertahankan perilaku pada cakupan bukti di atas. Prioritaskan dua masalah kuota karena dapat mengubah data; lanjutkan dengan konsistensi Pondasi dan keputusan kontrak respons check-out. Buat perbaikan terpisah dari refactor agar perubahan perilakunya dapat ditinjau. Untuk pembuktian menyeluruh DB → service → JSON, siapkan integrasi pada lingkungan terisolasi; setiap mutasi DEV tetap memerlukan konfirmasi pengguna sesuai panduan workspace.
