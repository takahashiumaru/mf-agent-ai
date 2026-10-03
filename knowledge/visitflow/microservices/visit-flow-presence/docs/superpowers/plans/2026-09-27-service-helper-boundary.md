# Service and Helper Boundary Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `executing-plans` to implement this plan task-by-task after the user requests execution. Steps use checkbox (`- [ ]`) syntax for tracking. This document is analysis only; do not commit or push its implementation without a later instruction.

**Goal:** Menempatkan mekanisme yang benar-benar umum di `helper` sambil mempertahankan aturan bisnis, transaksi, dan kontrak HTTP/data di `service`.

**Architecture:** `service` tetap mengorkestrasi alur bisnis dan memanggil repository dengan transaction handle milik caller. `helper` hanya menerima operasi kecil yang tidak mengimpor `service`, `auth`, `model/domain`, atau `model/web`: iterasi baris CSV, perhitungan jarak dalam meter, dan normalisasi token FCM. Fungsi service yang diekspor tetap tersedia sebagai wrapper bila sudah dipakai sebagai API Go.

**Tech Stack:** Go 1.23, Gin, GORM, `encoding/csv`, `mime/multipart`; test existing di `test/` dengan Testify dan SQLMock.

## Global Constraints

- Plan ini belum mengubah source. Saat eksekusi, jangan commit/push sebelum user memintanya.
- Pertahankan route, DTO, JSON key/type/null/zero/empty, status HTTP, pesan serta tipe error, urutan data, hasil CSV, dan timing efek eksternal.
- Pertahankan transaksi, scope company/user/period, locking, rollback, serta urutan notifikasi sesudah commit.
- Jangan memindahkan keputusan domain ke `helper` atau membuat interface/generic framework baru.
- Unit test murni diletakkan bersama package yang diuji; test lintas service/repository/controller tetap di `test/`. Jangan mengubah file fixture, README coverage, atau working-tree changes milik user.
- Tidak ada perubahan schema, query repository, dependency module, atau production database dalam plan ini.

---

## 1. Hasil audit batas package

| Fungsi/kelompok saat ini | Keputusan | Alasan |
| --- | --- | --- |
| `service.CalculateDistanceBetweenLocations` di `service/presence_location.go` | Pindahkan rumus ke `helper/distance.go`; pertahankan wrapper service | Haversine menerima empat `float64`, tanpa model/DB. `CheckIsInOffice` tetap memilih kantor dan radius. Wrapper menjaga pemakai API Go lama. |
| Loop pembuka file, pembaca header, dan pembaca baris di `service/office_user_csv.go` serta `service/work_hour_user_csv.go` | Satu iterator `helper.ForEachCSVDataRow`; mapping tetap di service | Kedua loop identik pada urutan file/baris, header, EOF, dan error. Helper dapat menghilangkan duplikasi tanpa mengenal office/work-hour atau mengumpulkan seluruh CSV dalam memori. |
| `service.firebaseToken` di `service/notification.go` | Pindahkan ke `helper.FirebaseToken` di file baru | Adaptasi `*string` menjadi `string` dipakai leave, meeting, dan correction; helper sudah memiliki transport FCM. Jangan menambahkannya ke `helper/send_message.go` yang sudah besar. |
| `parseCalendarCSV` | Tetap di service | Validasi kolom, minimal satu baris, dan `exception.ErrorSendToResponse` adalah kontrak kalender yang berbeda dari dua import assignment. |
| `CheckIsInOffice`, `mergePondasi*`, `expandMeetingMembers`, `leaveDay`, quota allocation, builder domain | Tetap di service | Memilih kantor, precedence ERP, keanggotaan meeting, hari cuti, kuota, dan nilai model adalah aturan bisnis. |
| `beginWriteResolver`, `commitLeaveWriteAndNotify`, serta notifikasi leave/correction | Tetap di service | Menentukan pemilik transaksi, source/write handle, rollback, status, dan kapan efek eksternal dijadwalkan. |
| `prepareLeaveProof`/`FindProofPhoto` | Tetap dalam batch ini | Nama file, batas ukuran, error, dan lifetime file terkait kontrak cuti; pemindahan I/O saja tidak memperjelas pemilik kebijakan. |
| Parser dan HTTP Pondasi di `internal/pondasi` | Tetap di sana | Package khusus ini sudah memiliki batas yang jelas. Wrapper parser di service menjaga API Go existing. |

`helper/send_message.go` saat ini sekitar 692 baris. Pemecahan transport/template email dan FCM adalah pekerjaan terpisah karena menyentuh payload eksternal dan konfigurasi sensitif. Jangan menambah fungsi baru ke file tersebut dalam refactor ini.

## 2. File target

| File | Tanggung jawab sesudah refactor |
| --- | --- |
| `helper/csv.go` (baru) | Membuka setiap multipart file, melewati header, lalu mengunjungi baris berurutan; mengembalikan error tanpa mapping domain. |
| `helper/distance.go` (baru) | Menghitung jarak meter dengan rumus dan konstanta yang sekarang dipakai. |
| `helper/firebase_token.go` (baru) | Mengubah pointer token nil menjadi string kosong; nilai lain dikembalikan tanpa normalisasi tambahan. |
| `service/office_user_csv.go` | Trim/skip row, parse user ID, dan bentuk `domain.OfficeUser` beserta ordered ID list. |
| `service/work_hour_user_csv.go` | Trim/skip row, parse user/work-hour ID, dan bentuk `domain.WorkHourUser` beserta ordered ID list. |
| `service/presence_location.go` | Memilih kantor; wrapper exported `CalculateDistanceBetweenLocations` tetap tersedia. |
| `service/notification.go` | Dihapus setelah seluruh pemanggil memakai `helper.FirebaseToken`. |
| `helper/csv_test.go` (baru) | Karakterisasi urutan multi-file, duplikasi, header/EOF, dan error CSV pada helper. |
| `test/user_csv_service_coverage_test.go`, `test/presence_service_test.go` | Perlindungan service/API existing; tambah hanya kasus yang belum terwakili. |
| `AGENTS.md`, `.agent/ARCHITECTURE.md` | Jelaskan bahwa helper mengurus mekanisme umum dan service tetap pemilik aturan bisnis/transaction. |

## 3. Langkah implementasi

**Execution status:** Semua task selesai dan direview. Semua perubahan tetap uncommitted sesuai instruksi user.

### Task 0 — Ambil baseline dan lindungi working tree

**Files:** Tidak ada source edit.

- [x] Catat `git status --short`, branch/HEAD, dan daftar file user yang sudah berubah. Di baseline audit ini: `README.md`, dua fixture PNG tracked yang terhapus, dan dua PNG untracked. Jangan restore, stage, atau hapus file tersebut.
- [x] Jalankan `go test ./... -count=1`; catat hasil. Test dapat membuat PNG; bandingkan inventaris sebelum/sesudah, lalu hapus hanya artifact baru dari run ini.
- [x] Inventarisasi pemanggil exported `service.CalculateDistanceBetweenLocations` di workspace dengan `rg -n 'CalculateDistanceBetweenLocations' --glob '*.go'` dari direktori VisitFlow. Audit ini menemukan pemakai lokal pada service dan test; wrapper tetap disediakan untuk pemakai Go di luar workspace yang tidak terinventarisasi.

### Task 1 — Ekstraksi pembaca baris CSV yang benar-benar dipakai dua alur

**Files:** Create `helper/csv.go`, `helper/csv_test.go`; modify `service/office_user_csv.go`, `service/work_hour_user_csv.go`.

**Interface baru:**

```go
func ForEachCSVDataRow(files []*multipart.FileHeader, visit func([]string) error) error
```

`ForEachCSVDataRow` membuka file sesuai urutan input, memakai `csv.NewReader` dengan comma `,`, membaca satu header per file, menerima header-only/empty file seperti sekarang, dan mengunjungi tiap data row tanpa buffering seluruh file. Error dari open/read/visitor dikembalikan apa adanya. `Close` dipanggil per file dan perilaku pengabaian error close tetap sama.

- [x] Tambah test `helper/csv_test.go` untuk dua file berurutan dengan user ID duplikat, empty/header-only file, malformed field count, dan visitor error. Fixture multipart lokal menjaga unit test bebas dependency pada setup package `test`; assert urutan baris serta error asli.
- [x] Jalankan `go test ./test -run 'Test(HelperCSV|OfficeAndWorkHourUserCsvImport|UserCsvImport)' -count=1` dan pastikan test helper baru gagal sebelum implementasi.
- [x] Implementasikan iterator tersebut di `helper/csv.go`. Gunakan closure per file sehingga `defer file.Close()` selesai sebelum file berikutnya; `io.EOF` saat header atau row tetap dianggap akhir file. Jangan mengubah `FieldsPerRecord` default.
- [x] Ganti hanya loop `Open`/header/`Read` pada dua parser service dengan iterator. Callback tetap menjalankan `len(record)<2`, trim, `strconv.ParseUint`, append ID, dan append model seperti source sekarang. Setelah iterator mengembalikan error, panggil `helper.PanicIfError(err)` di service agar panic/error identity dan rollback tidak berubah.
- [x] Jalankan test CSV dan test rollback `TestOfficeUserCsvImportRollsBackAfterReplacementStarts`. Pastikan duplicate user IDs, urutan replacement, zero rows, dan malformed CSV tetap sama.

### Task 2 — Letakkan rumus jarak murni di helper

**Files:** Create `helper/distance.go`; modify `service/presence_location.go`.

**Interface baru:**

```go
func DistanceMeters(latitudeUser, longitudeUser, latitudeOffice, longitudeOffice float64) float64
```

- [x] Pindahkan badan rumus Haversine dari `service.CalculateDistanceBetweenLocations` ke `helper.DistanceMeters` tanpa mengganti urutan argumen, radius bumi `6371.0`, unit meter, atau pembulatan.
- [x] Biarkan `service.CalculateDistanceBetweenLocations` sebagai wrapper kompatibilitas yang hanya memanggil `helper.DistanceMeters`. `CheckIsInOffice` boleh memanggil helper langsung; pemilihan office dan `radius <= Office.Radius` tetap di service.
- [x] Jalankan `go test ./test -run 'TestPondasi_(CalculateDistanceBetweenLocations|CheckIsInOffice)' -count=1` dan kasus presence workflow. Jangan menyatukan kalkulasi ini dengan helper Haversine modul Visit Flow lain tanpa membuktikan satuan/edge case sama.

### Task 3 — Tempatkan normalisasi token FCM bersama helper notifikasi

**Files:** Create `helper/firebase_token.go`; modify service callsites `leave_create.go`, `leave_hrd.go`, `leave_manager.go`, `meeting_service_impl.go`, `attendance_correction_service_impl.go`, `attendance_correction_approval.go`; delete `service/notification.go`.

**Interface baru:**

```go
func FirebaseToken(token *string) string {
    if token == nil {
        return ""
    }
    return *token
}
```

- [x] Ganti seluruh `firebaseToken(x)` menjadi `helper.FirebaseToken(x)` tanpa trim atau fallback baru. Periksa `rg -n 'firebaseToken\(' service` kosong sebelum menghapus file lama.
- [x] Jalankan test leave, meeting, correction, dan notifikasi yang ada; periksa nilai nil, string kosong, dan token berisi nilai. Kode transport, payload FCM, waktu penjadwalan, dan `RunAsyncNotification` tidak berubah.

### Task 4 — Review batas, dokumentasi, dan verifikasi akhir

**Files:** Modify `AGENTS.md`, `.agent/ARCHITECTURE.md` hanya untuk aturan kepemilikan yang berubah.

- [x] Review `git diff` per task: tidak ada perubahan controller, route, repository, model, schema, SQL, response JSON, atau payload notifikasi. Jangan menyertakan README/PNG dari baseline.
- [x] Pastikan `helper` tidak mengimpor `service`, `auth`, `model/domain`, atau `model/web`; `go list ./helper ./service` berhasil tanpa import cycle. Tidak ada interface baru.
- [x] Jalankan `go test ./... -count=1`, `go test -race ./test -count=1`, `go vet ./...`, `go build ./...`, `git diff --check`, dan `gofmt -l` pada file Go yang berubah. Inventaris dibandingkan dan hanya PNG baru dari test run dibersihkan.
- [x] Pastikan unit test murni berada bersama package yang diuji, test lintas layer tetap di `test/`, contoh di dokumentasi mengarah ke file aktual, dan validator panduan workspace tetap hijau setelah agent docs diubah.
- [x] Laporkan perubahan, hasil test aktual, dan batas pembuktian. Seluruh implementasi tetap uncommitted sampai ada instruksi commit/push dari user.

## 4. Batas penerimaan

- Semua alur CSV tetap menghasilkan assignment dan ID list dalam urutan yang sama, termasuk duplikasi dan error yang menyebabkan rollback.
- Nilai jarak, pemilihan kantor, dan API Go `service.CalculateDistanceBetweenLocations` tetap sama.
- Token FCM nil/kosong/berisi nilai menghasilkan string yang sama dan tidak mengubah penjadwalan notifikasi.
- Struktur dependency tetap satu arah (`service → helper`), tanpa business rule atau transaction owner baru di helper.
- Seluruh test existing lulus; tidak ada perubahan route, JSON, SQL, model, atau data production.

### Follow-up penempatan unit test

Atas permintaan pengguna setelah plan ini dijalankan, unit test helper yang sebelumnya berada di `test/helper_csv_test.go`, `test/firebase_token_test.go`, `test/helper_test.go`, dan `test/helper_coverage_test.go` dipindahkan ke `helper/`. Test package service/import lintas layer tetap berada di `test/`. Pemindahan ini hanya menyesuaikan lokasi dan setup test; kontrak helper tidak berubah.
