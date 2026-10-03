# Presence Service Package Design, SOLID, and Dependency Management Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `executing-plans` to implement this plan task-by-task after the user authorizes implementation. Steps use checkbox (`- [ ]`) syntax for tracking. No commit or push is authorized.

**Execution status:** User authorized execution after creating and pushing checkpoint `781d5e7` on `refactor/presence-service-clean-code`. Tasks 0–6 and the separately requested HRD correctness follow-up are implemented and verified. All changes remain uncommitted. Baseline and final full suite/race checks passed; caller inventory and checkpoint source snapshot are stored under `/tmp/presence-package-*`.

**Goal:** Memperjelas tanggung jawab service dan dependency yang dipakainya, mempertahankan perilaku HTTP/data, serta menghindari abstraksi yang belum dibutuhkan.

**Architecture:** Pertahankan package `service` sebagai pemilik orkestrasi bisnis, transaksi, dan kontrak service yang dipakai controller. Pisahkan transport/parsing Pondasi ke `internal/pondasi`, injeksikan dependency yang sebelumnya dibuat di dalam workflow, dan kelompokkan file berdasarkan operasi bisnis. Pembagian seluruh service menjadi package per domain ditunda sampai ada kebutuhan pemisahan yang konkret.

**Tech Stack:** Go directive 1.23, Gin, GORM 1.25.10, dbresolver, validator, SQLMock, Testify, dan dependency VisitFlow yang sudah dipin di `go.mod`.

## Global Constraints

- Implementasi plan sudah diotorisasi setelah checkpoint branch dibuat dan di-push. Perubahan setelah checkpoint harus tetap belum di-commit atau di-push.
- Jangan commit atau push. Working tree sudah berisi perubahan sebelumnya; jangan reset, stash, atau menimpanya.
- Tidak mengubah behavior/feature existing melalui pekerjaan struktur. Temuan bug bisnis dicatat sebagai pekerjaan terpisah.
- Pertahankan route, request/response DTO, JSON key/type/null/zero/empty, status HTTP, urutan hasil, validasi, error type/message, dan mutasi request yang saat ini diamati caller.
- Test workflow lintas layer tetap di `test/`; unit test package-level ditempatkan bersama package yang diuji. Perubahan constructor boleh membutuhkan penyesuaian setup test; assertion perilaku tidak boleh dilonggarkan atau dihapus.
- Services tetap memiliki transaksi; repository menerima handle caller. Tidak mengubah SQL, lock, cakupan tenant/periode, commit/rollback, soft/hard delete, atau waktu pengiriman notifikasi.
- Tidak menambah dependency eksternal, DI framework, generic repository/base service, CQRS, event bus, persistence model baru, atau migrasi database.
- Tidak menjalankan mutasi DEV/PROD atau mengirim notifikasi nyata untuk memvalidasi plan.
- Constructor Go dan field struct bukan kontrak HTTP, tetapi perubahan keduanya tetap perubahan source API: inventarisasi caller sebelum mengubahnya.

## 1. Kesimpulan dan bukti keadaan sekarang

Analisis terhadap working tree lokal pada 27 September 2026, HEAD `504b0d1`. Ini bukan bukti deployment. Ada **43 file Go, 3.844 baris termasuk komentar/baris kosong, dan 14 interface service** dalam satu package `service`. Angka ini membantu navigasi; bukan skor kualitas.

Refactor sebelumnya sudah memberi pemisahan fungsi yang berguna: perhitungan/alokasi kuota, builder model, penggabungan Pondasi, CSV, dan orkestrasi approval. Namun pemisahan file belum menjadi pemisahan package atau dependency. Tidak perlu mengubah seluruhnya menjadi arsitektur baru.

| Temuan | Bukti lokal | Implikasi dan keputusan |
| --- | --- | --- |
| Leave masih menggabungkan banyak alasan perubahan | `service/leave_service_impl.go:30`, `:94`, `:238`, `:413`, `:455`; 517 baris | Pisahkan kelompok operasi; pertahankan satu pemilik transaksi per use case. |
| Dependency presence tersembunyi | `service/presence_service_impl.go:82` membuat `UserRepositoryImpl`; `service/presence_location.go:13` membuat office-user repository | Constructor belum menjelaskan kebutuhan nyata. Injeksikan dua lookup kecil melalui route. |
| Transport Pondasi bercampur aturan absensi | `service/presence_pondasi.go:15`, `:94`, `:149` | HTTP/parsing layak menjadi package mandiri. Penggabungan dengan ERP tetap milik service. |
| Dependency constructor tidak dipakai workflow | `LeaveServiceImpl.MeetingMemberRepository` dan `.ConfigRepository`; `AttendanceCorrectionServiceImpl.ConfigRepository`; `MeetingServiceImpl.OfficeRepository` | Hanya deklarasi, parameter, dan assignment ditemukan di service. Hapus bersama wiring/caller setelah inventarisasi source API. |
| Kontrak user terlalu luas untuk consumer | `service/leave_service_impl.go:33`, `service/meeting_service_impl.go:27`, `service/attendance_correction_service_impl.go:29` | Ketiganya hanya memakai `FindByID`. Gunakan satu interface consumer `UserLookup`; implementasi dan mock yang ada sudah dapat memenuhi method tersebut. |
| Service memanggil service dari module lain | `service/leave_service_impl.go:256` → `visitService.Approval` | Dependency ini menjalankan lookup status DB, bukan fungsi pure. Injeksikan fungsi yang sama agar kebutuhan terlihat dan error identity tetap sama. |
| Helper lintas workflow berada di file leave | `service/leave_service_impl.go:43`; dipakai meeting/correction | Pindahkan `firebaseToken` ke file notification di package yang sama, tanpa interface/package util baru. |
| Test Pondasi mengganti transport global | `test/presence_pondasi_workflow_test.go:66` | Client per instance memberi isolasi test tanpa interface HTTP buatan sendiri. |
| Kontrak service sekarang memang dipakai | `controller/presence_controller_impl.go:18`, `route/presence_route.go:16`, `service/leave_service.go:10` | Jangan menghapus seluruh interface service hanya karena implementasi production satu. Controller test memakai pengganti service; seam ini punya kegunaan nyata. |
| Dokumentasi transaksi sudah tertinggal | `AGENTS.md`, `.agent/ARCHITECTURE.md`, `.agent/PREFERRED_PATTERNS.md`, `.agent/INDEX.md` masih menyebut resolver terpisah pada alur lain | Source terbaru memakai `beginWriteResolver`; sinkronkan catatan yang spesifik setelah implementasi, tanpa menulis ulang panduan. |

Import service yang relevan terkonfirmasi melalui `go list ./service`: package local repository/domain/web/helper/auth, Gin, GORM, serta package dari `go-helper`, `visit-flow-go`, dan gateway. Tidak ditemukan import `visit-flow-presence/service` di empat sibling repository Go yang diperiksa. Ini tidak membuktikan tidak ada consumer di luar workspace.

### Penilaian SOLID secara praktis

| Prinsip | Penilaian | Tindakan |
| --- | --- | --- |
| Single Responsibility | Builder dan fungsi alokasi sudah fokus; transport, file, approval, dan laporan masih bercampur pada beberapa file | Pisahkan transport Pondasi dan kelompok file leave; fungsi orkestrasi tetap boleh mengoordinasikan beberapa dependency. |
| Open/Closed | Manual wiring sudah cukup. Repository/client yang dibuat di dalam workflow memaksa perubahan badan workflow untuk mengganti dependency | Sediakan seam pada I/O yang benar-benar diganti oleh test. Tidak membuat plugin/strategy registry untuk status cuti. |
| Liskov Substitution | Belum ada bukti pelanggaran substitusi formal; kontrak panic, not-found, hasil pointer, dan transaction handle harus berlaku bagi implementasi maupun fake | Uji perilaku melalui service. Jangan menyimpulkan LSP lulus hanya dari compiler atau embedding interface dalam fake. |
| Interface Segregation | User repository jauh lebih luas daripada kebutuhan `FindByID`; interface service besar belum otomatis salah karena controller memakai operasinya | Dua interface lookup kecil cukup untuk tahap ini. Jangan memecah interface leave menjadi CRUD/command/query tanpa consumer terpisah. |
| Dependency Inversion | Sebagian besar repository sudah diinjeksi; presence, HTTP Pondasi, dan pemilihan status masih tersembunyi | Pindahkan construction ke route; terima lookup kecil, concrete client, dan fungsi pemilih status. Tetap gunakan GORM/domain sekarang. |

### Catatan correctness dan follow-up HRD

`UpdateRejectedHrd` menerima status `confirm 2` (`service/leave_service_impl.go:369`) lalu memanggil `restorePaidLeaveQuota` (`:388`). Debit kuota terlihat di `consumeApprovedHrdQuota` saat approval HRD (`service/leave_quota_allocation.go:59`). Alokasi pada create hanya mengurangi saldo variabel lokal, bukan menyimpan debit (`:45`); approval manager yang diperiksa tidak mendebit kuota.

Audit menemukan risiko penambahan saldo ketika pengajuan ditolak sebelum debit. Atas permintaan user setelah refactor, follow-up terpisah memperbaikinya: `UpdateRejectedHrd` tidak mengembalikan kuota; pembatalan setelah approval tetap mengembalikan saldo. Approval HRD juga sekarang mensyaratkan status `confirm 2` setelah lock, sambil mempertahankan retry `approved hrd` yang idempotent. Production `confirmation_statuses` diperiksa dalam transaksi read-only dan menunjukkan status manager menuju HRD adalah `confirm 2`. Regression tests ada di `test/leave_service_rejection_coverage_test.go` dan `test/leave_hrd_integrity_test.go`. Saldo individual/produksi dan seluruh jalur eksternal belum diverifikasi.

## 2. Bentuk package yang direkomendasikan

```text
route/                         manual composition: memilih implementation
controller/                    parsing HTTP, response envelope
service/                       kontrak dan orkestrasi bisnis/transaction owner
  *_service.go                 interface yang sudah dipakai controller
  *_service_impl.go            constructor, state, operasi dasar yang kohesif
  leave_create.go              create, alokasi per hari, pembuatan approval awal
  leave_manager.go             approval/rejection manager
  leave_hrd.go                 approval/rejection/cancellation HRD
  leave_queries.go             lookup/report/validasi kuota read
  leave_proof.go               fungsi file bukti yang ada
  leave_notification.go        payload dan scheduling leave yang sudah ada
  leave_quota_allocation.go    aturan periode/debit/refund yang sudah ada
  presence_reports.go         delegasi laporan presence
  presence_pondasi.go          merge ERP/Pondasi dan kompatibilitas helper public
  presence_location.go         perhitungan lokasi; tanpa construction repository
  user_lookup.go              satu kontrak lookup user, dipakai empat workflow
  notification.go             helper token lintas workflow
  transaction.go              helper transaksi yang ada, semantiknya tetap
internal/pondasi/
  client.go                    request HTTP dan decoding envelope
  parse.go                     record Pondasi dan parser nil/date/number
repository/                    query dan persistensi melalui DB/tx caller
model/domain/, model/web/      model/mapper/DTO existing
test/                          seluruh existing test dan test client/lookup baru
```

File CRUD kecil lainnya tetap di tempatnya. Struktur di atas hanya menampilkan file yang berubah atau relevan, bukan daftar seluruh file repository.

Aturan dependency:

```text
route ──> controller ──> service ──> repository ──> domain/web
  └────────────────────> service ──> internal/pondasi ──> standard library
  └────────────────────> concrete repositories / pinned status function
```

- `internal/pondasi` tidak mengimpor `service`, GORM, Gin, auth, repository, atau domain absensi.
- Service tidak membuat repository/client di tengah request. Wiring di route memilih production implementation.
- Tidak ada service lokal yang memanggil service lokal lain untuk berbagi transaksi; repository/fungsi internal cukup.
- Repository tidak mengimpor service. Tidak membuat package `common`, `utils`, `contracts`, atau `interfaces` sebagai penampung lintas domain.
- Tetap satu transaksi pemilik; pemisahan package tidak memberi client Pondasi atau repository hak membuka transaksi baru.

**Mengapa belum `service/leave`, `service/attendance`, dan seterusnya?** Pemisahan itu akan memindahkan 14 kontrak beserta constructor, mengubah import controller/test, dan membutuhkan strategi helper/compatibility. Manfaat terdekat saat ini berasal dari dependency I/O yang jelas dan pemisahan transport. Revisit package per domain bila ada consumer independen, konflik kepemilikan lintas tim, atau perubahan domain yang terus menyentuh domain lain. Jangan menambah facade kosong untuk mempertahankan seluruh package lama sekaligus memperkenalkan semua package baru.

## 3. Interface dan dependency management

Tambahkan tepat dua interface awal, keduanya karena production repository dan fake test benar-benar digunakan pada seam yang sama:

```go
// service/user_lookup.go
// Imports: gateway model/domain as userDomain; gorm.io/gorm.
type UserLookup interface {
    FindByID(db *gorm.DB, id *int) userDomain.User
}

// Di service/presence_service_impl.go, dekat definisi service.
// Imports: local model/domain; gorm.io/gorm.
type OfficeUserLookup interface {
    FindByUserID(db *gorm.DB, userID *int) *domain.OfficeUsers
}
```

`UserLookup` dipakai presence, leave, meeting, dan attendance correction. Method dan tipe hasil tetap sama dengan repository gateway yang dipin. Ini memperkecil method set; belum menghapus coupling ke model gateway. `OfficeUserLookup` hanya dipakai presence. Jangan memperkecil setiap repository interface sekaligus.

Gunakan function dependency untuk satu operasi pemilihan status:

```go
// Field LeaveServiceImpl; goHelper adalah package helper yang sudah ada.
NextLeaveStatus func(*goHelper.DatabaseResolver, string, string) string

// Call site yang menggantikan pemanggilan langsung visitService.Approval:
status = service.NextLeaveStatus(db, "leave", request.Status)
```

Route memasukkan fungsi **`visitService.Approval` yang sama** dari module terpin, tanpa menyalin algoritma/lookup/error-nya. Source fungsi tersebut terverifikasi di module cache `visit-flow-go@v0.1.89-m/service/approval.go`: fungsi membuat confirmation-status repository dan melempar error jika next status kosong. Test existing yang memeriksa SQL status tetap memakai fungsi production ini; test tambahan dapat memakai closure untuk memastikan transaction/menu/status yang diteruskan.

Client Pondasi berupa concrete `*pondasi.Client`, bukan interface baru. Bentuk yang direncanakan:

```go
// internal/pondasi; imports context, net/http, time.
type Presence struct {
    Date time.Time
    Description string
    Latitude float64
    Longitude float64
    Nip string
}

type Client struct {
    endpoint string
    httpClient *http.Client
}

// Public surface yang akan diimplementasikan pada task client:
// NewClient(endpoint string, httpClient *http.Client) *Client
// (*Client).FindPresences(ctx context.Context, nip, period string) ([]Presence, error)
// ParsePresence(raw map[string]interface{}) (Presence, error)
// ParseTime(raw string) (time.Time, error)
// ParseFloatValue(raw interface{}) (float64, error)
```

Route memberi endpoint yang sama dan `&http.Client{Timeout: 15 * time.Second}`. Test memberi client dengan `http.RoundTripper` in-memory; gunakan interface standard library yang sudah ada. Constructor hanya menyimpan dependency, tidak melakukan request. Jangan menambahkan validasi/nil fallback/retry/cache/status-code policy baru pada refactor ini.

Pertahankan `service.PondasiPresence` sebagai type alias ke `pondasi.Presence` dan tiga fungsi parser public existing sebagai wrapper sederhana ke parser baru. Wrapper ini punya alasan kompatibilitas konkret: existing test memakai simbol tersebut. Semua logic parsing hanya tinggal satu kali di package Pondasi. Tidak ada wrapper untuk semua service lainnya.

Dependency module tetap:

- `go-helper v0.5.9`, `visit-flow-go v0.1.89-m`, gateway `v0.0.101-release.0.20251211015323-7146cd5fbd1f`; GORM tetap versi yang ada.
- Jangan memakai source sibling repo sebagai bukti implementation dependency yang dibuild; gunakan versi terpilih dari `go list`/`go.mod`.
- Tidak melakukan upgrade, `go mod tidy`, penambahan `replace`, atau pemindahan ke module baru dalam pekerjaan ini. Penataan package bukan audit versi/vulnerability dependency.
- Memindahkan import external service ke route memperjelas construction, **tidak menghilangkan dependency module dari binary**. Model/repository juga masih memakai module yang sama; tidak ada klaim binary lebih kecil atau latency lebih cepat.
- Tidak membuat `Notifier`, `Clock`, `TransactionManager`, `FileStore`, atau interface untuk pure builder sekarang. Seam tambahan hanya dibuat bila ada kebutuhan substitusi/test yang belum dapat dipenuhi pola existing.

## 4. Urutan implementasi yang dapat direview

### Task 0 — Tetapkan baseline dan caller map

**Files:** existing `service/`, `route/`, `controller/`, `test/`, `go.mod`, `go.sum`; tidak ada edit production pada langkah ini.

**Consumes:** working tree existing, bukan hanya HEAD. **Produces:** catatan baseline test dan daftar caller constructor/struct literal.

- [x] Simpan `git status --short`, `git diff --stat`, dan fingerprint file Go/module ke file temporary di luar repo. Catat file untracked existing sebelum melakukan perubahan.
- [x] Inventarisasi `NewPresenceService`, `NewLeaveService`, `NewMeetingService`, `NewAttendanceCorrectionService`, dan literal keempat `*ServiceImpl` melalui `rg -n` pada semua file Go workspace. Periksa function-value assignments/field access juga, bukan hanya pemanggilan constructor.
- [x] Jalankan `go test ./... -count=1` dan `go test -race ./test -count=1`; hasil wajib hijau sebelum refactor. Jika gagal, laporkan baseline failure dan isolasikan penyebab; jangan mengubah assertion supaya lolos.
- [x] Catat risiko refund di bagian 1 sebagai masalah terpisah. Jangan menganggap test satu operasi membuktikan state machine lengkap.
- [x] Catat artifact yang dibuat test; cleanup hanya artifact baru milik eksekusi ini. `make cover` tidak dipakai karena bisa memperbarui README.

### Task 1 — Kelompokkan fungsi, tanpa mengubah badan/logika

**Files:** `service/leave_service_impl.go`, `leave_create.go`, `leave_approval.go`, `presence_service_impl.go`; baru `leave_manager.go`, `leave_hrd.go`, `leave_queries.go`, `leave_proof.go`, `presence_reports.go`, `notification.go`.

**Consumes/Produces:** method signature, receiver, body, dan public service interface tetap identik. Ini pemindahan declaration antar file dalam package yang sama.

- [x] Pindahkan `UpdateApprovedManager` dan `UpdateRejectedManager` ke `leave_manager.go`.
- [x] Pindahkan `UpdateApprovedHrd`, `approveHrdLeave`, `UpdateRejectedHrd`, `UpdateCanceledHrd` ke `leave_hrd.go`; pindahkan `createLeaveApproval` ke `leave_create.go`. Hapus `leave_approval.go` setelah seluruh deklarasinya mempunyai satu lokasi baru.
- [x] Pindahkan `FindAll`, `FindByID`, dua `FindReportLeaves*`, dan `ValidateQuota` ke `leave_queries.go`. Update/Delete/UpdateCanceled serta entry/exit security tetap di impl selama masih mudah dibaca; tidak perlu file per method.
- [x] Pindahkan `FindProofPhoto` dan `prepareLeaveProof` ke `leave_proof.go`. Jangan menyamakan perilaku upload Create dengan Update atau memindahkan I/O melewati transaction boundary.
- [x] Pindahkan lima `FindReport*` presence ke `presence_reports.go`; pindahkan `firebaseToken` ke `notification.go` dengan nama/visibility yang sama.
- [x] Sesuaikan import per file; gunakan diff pemindahan untuk memastikan isi method tidak berubah. Jangan membuat interface/struct baru pada task ini.
- [x] Jalankan `go test ./test -run 'Test(Leave|Hrd|Presence|Pondasi|AttendanceCorrection|Meeting)' -count=1`; pastikan selector benar-benar menjalankan test, lalu `go test ./... -count=1`.

### Task 2 — Hapus dependency mati dan persempit lookup user

**Files:** baru `service/user_lookup.go`; ubah `service/leave_service_impl.go`, `meeting_service_impl.go`, `attendance_correction_service_impl.go`; route pasangan ketiganya; setup test yang memanggil constructor tersebut.

**Consumes:** `UserLookup` seperti bagian 3. **Produces:** constructor yang hanya menyebut dependency yang digunakan.

Urutan parameter setelah perubahan:

```text
NewLeaveService(leave, leaveQuota, users UserLookup,
  approvalRepository, structureBosRepository, leaveCategoryRepository,
  db, validate) LeaveService
NewMeetingService(meeting, users UserLookup, meetingMemberRepository,
  approvalRepository, structureBosRepository, db, validate) MeetingService
NewAttendanceCorrectionService(corrections, structureBosRepository,
  approvalRepository, users UserLookup, presenceRepository,
  db, validate) AttendanceCorrectionService
```

Parameter lain mempertahankan tipe existing. Task 4 menambahkan function pemilih status pada constructor leave secara eksplisit.

- [x] Tambahkan interface `UserLookup` satu method persis bagian 3; ubah field/parameter user pada tiga service menjadi tipe itu.
- [x] Hapus hanya empat field/parameter mati yang terdaftar pada tabel temuan. Hapus pembuatan dependency tersebut pada tiga route.
- [x] Perbarui seluruh caller hasil inventarisasi Task 0 dan setup test. Pertahankan semua fake/mock existing dan assertion bisnisnya; jangan menulis constructor kompatibilitas baru tanpa consumer yang memerlukannya.
- [x] Tambahkan `test/service_user_lookup_test.go`: fake hanya mengimplementasikan `FindByID`, tanpa embedding repository besar; gunakan pada workflow meeting/leave/correction yang sudah diuji. Tambahkan compile-time assertion `var _ service.UserLookup = (*userLookupFake)(nil)`.
- [x] Bila ditemukan consumer di luar cakupan yang harus mempertahankan signature Go, hentikan penghapusan signature pada constructor itu dan laporkan constraint source compatibility. Jangan menganggap HTTP compatibility cukup untuk consumer Go.
- [x] Jalankan `go test ./... -count=1` dan `go build ./...` untuk menangkap semua caller, kemudian review diff setup test memastikan expectation/query/DTO tidak berubah.

### Task 3 — Jadikan lookup presence eksplisit

**Files:** `service/presence_service_impl.go`, `presence_create.go`, `presence_location.go`, `route/presence_route.go`; `test/presence_workflow_test.go`, `presence_service_test.go`, `presence_service_query_coverage_test.go`, `presence_pondasi_workflow_test.go`, `services_full_coverage_test.go`; baru `test/presence_dependency_test.go`.

**Consumes:** `UserLookup`, `OfficeUserLookup` bagian 3. **Produces:** presence menerima kedua lookup melalui constructor.

Constructor pada akhir task ini:

```text
NewPresenceService(presence repository.PresenceRepository,
  config visitRepository.ConfigRepository, users UserLookup,
  offices OfficeUserLookup, pondasiClient *pondasi.Client, db *gorm.DB,
  validate *validator.Validate) PresenceService
```

- [x] Tambahkan field lookup user dan office-user pada `PresenceServiceImpl`. Hapus construction `UserRepositoryImpl{}` dari `Create`.
- [x] Ganti semua panggilan `getOfficeUser` dengan `service.OfficeUserRepository.FindByUserID` menggunakan handle yang sama. Hapus helper construction tersebut; pertahankan `CheckIsInOffice` dan perhitungan jarak tanpa perubahan.
- [x] Route menginjeksi `user.NewUserRepository()` dan `repository.NewOfficeUserRepository()`; update semua constructor/literal service pada test. Test SQL existing tetap memakai concrete repository yang sama agar bentuk query terjaga.
- [x] Pada test dependency baru, fake user/office merekam handle DB. Lookup check-in dan check-out berbagi transaction connection dengan write; error lookup menghentikan write dan menyebabkan rollback sesuai flow existing.
- [x] Verifikasi tidak ada repository construction tersisa di workflow presence melalui `rg -n 'RepositoryImpl\{|New.*Repository' service/presence*`.
- [x] Jalankan test `TestPresence*` dan `TestPondasi*`, lalu seluruh suite. Tidak memperbaiki tanggal `+7 hour`, scope, radius, atau konfigurasi presence dalam task injection.

### Task 4 — Tampilkan dependency pemilihan status leave

**Files:** `service/leave_service_impl.go`, `leave_manager.go`, `route/leave_route.go`; caller constructor di `test/`; baru `test/leave_status_dependency_test.go`.

**Consumes:** field/function signature bagian 3. **Produces:** constructor leave menambahkan `nextLeaveStatus func(*goHelper.DatabaseResolver, string, string) string` tepat sebelum `db`.

- [x] Simpan function argument ke field `NextLeaveStatus`; ubah satu pemanggilan di manager approval menjadi `service.NextLeaveStatus(db, "leave", request.Status)`.
- [x] Route memasukkan `visitService.Approval` terpin; pindahkan import package service eksternal dari local service ke route. Jangan mengganti foreign exception dengan exception lokal.
- [x] Existing manager approval SQL test memasukkan fungsi production yang sama. Test closure memeriksa menu `leave`, status setelah aturan `IsMkt`, dan identitas resolver transaksi.
- [x] Panic dari closure tetap menyebabkan rollback sebelum dependency approval/notifikasi dijalankan. Urutan lookup struktur/status/approval dipertahankan.
- [x] Jalankan test terfokus manager approval/status/presence dependency; full suite menjadi bagian quality gate akhir Task 6.

### Task 5 — Ekstrak client Pondasi dan isolasikan test HTTP

**Files:** baru `internal/pondasi/client.go`, `internal/pondasi/parse.go`, `internal/pondasi/client_test.go`; ubah `service/presence_pondasi.go`, `presence_service_impl.go`, `route/presence_route.go`, dan semua caller constructor/literal presence dari Task 3.

**Consumes:** concrete client/types/signature bagian 3. **Produces:** field `PondasiClient *pondasi.Client`; constructor presence menerima `pondasiClient *pondasi.Client` setelah `offices` dan sebelum `db`.

- [x] Pindahkan record/parsing dan badan HTTP ke `internal/pondasi` dengan public surface bagian 3. Perubahan mekanis: service record menjadi `Presence`, parser menjadi nama yang ditetapkan, request memakai endpoint/client field.
- [x] Pertahankan endpoint, GET, parameter `nip`/`period`, timeout 15 detik, request context, body-close, aturan parse, urutan record, skip record invalid, serta hasil nil bila envelope data tidak sesuai.
- [x] Jangan menambah penolakan HTTP non-2xx, retry, limit body, normalisasi timestamp, escaping parameter yang mengubah request, atau perubahan fallback sebagai bagian ekstraksi. Itu pekerjaan behavior terpisah jika dibutuhkan.
- [x] Di service, pertahankan `type PondasiPresence = pondasi.Presence` dan wrapper `ParsePondasiPresence`, `ParsePondasiTime`, `ParseFloatValue` dengan signature existing. Hapus HTTP implementation dari service; merge tetap di sana.
- [x] Ganti panggilan fetch menjadi `service.PondasiClient.FindPresences(c.Request.Context(), nip, period)`. Pertahankan fallback ERP-only ketika error diabaikan oleh orchestration existing.
- [x] Route memberi client HTTP production. Test Pondasi memberi `http.Client{Transport: fakeRoundTripper}` per instance; hapus perubahan `http.DefaultTransport` hanya dari test Pondasi yang telah dimigrasi. Jangan mengubah test notifikasi lain sekaligus.
- [x] Test client melalui `internal/pondasi/client_test.go`: path/method/query, context cancellation, transport error, read error, invalid JSON, envelope missing/null/non-array, mixed valid/invalid records, urutan, dan body ditutup. Gunakan test parsing existing melalui wrapper sebagai regression guard.
- [x] Jalankan `go test ./test -run 'Test(Pondasi|Presence)' -count=1`, kemudian full suite dan race. Tambahkan pemeriksaan import `go list -f '{{join .Imports "\n"}}' ./internal/pondasi`; hasil hanya standard library.

### Task 6 — Review kontrak, dependency, dan panduan

**Files:** `.agent/ARCHITECTURE.md`, `.agent/INDEX.md`, `.agent/PREFERRED_PATTERNS.md`, `AGENTS.md`; source/test hanya bila review menemukan perubahan yang tidak sesuai plan.

**Consumes:** seluruh task sebelumnya lulus. **Produces:** verifikasi akhir dan panduan singkat yang cocok dengan kode aktual.

- [x] Perbarui path file yang pindah dan catatan resolver yang usang. Tambahkan panduan singkat package boundary serta pemilik transaction/client tanpa menggandakan dokumentasi.
- [x] Bandingkan DTO/mapper/routes/repository dengan baseline: tidak ada perubahan kontrak/SQL. Diff route hanya mengubah wiring constructor; handler/path/role slice tidak berubah.
- [x] Jalankan `go test ./... -count=1`, `go test -race ./test -count=1`, `go vet ./...`, `go build ./...`, `git diff --check`, dan `gofmt -l` untuk Go file terkait.
- [x] Coverage tambahan tidak diperlukan oleh gate perubahan struktur ini; updater README tidak dijalankan.
- [x] Pastikan `go.mod`/`go.sum` sama dengan baseline, package Pondasi hanya mengimpor standard library, dan tidak ada package util/interface generik baru.
- [x] Jalankan validator panduan workspace dan 9 unit test validator; review kandidat API/TESTING dan pastikan tidak memuat path yang pindah atau aturan resolver usang.
- [x] Review diff per task: Task 1 dan 2 disetujui; Task 3–5 disetujui tanpa temuan regresi. Implementation changes tetap belum di-commit/push.

## 5. Matriks perlindungan behavior

| Area | Invariant yang dilindungi | Bukti/test yang digunakan |
| --- | --- | --- |
| Presence check-in/out | Lookup hari/user sama, radius sama, DTO checkout dari reload writer; user/check-in/office/null tetap | `test/presence_workflow_test.go`, `presence_service_query_coverage_test.go` |
| Pondasi | Format tanggal, offset existing, precedence ERP, duplicate/order, fallback ERP-only, final read dalam writer ketika ada write | `test/presence_service_test.go`, `presence_pondasi_workflow_test.go`; client test baru |
| Leave create | Validasi 0,5 hari, paid/unpaid/periode, reuse record, proof filename/lifecycle, hasil terakhir dan approval awal | `test/leave_days_validation_test.go`, `leave_create_approval_test.go`, `leave_create_unpaid_test.go`, `leave_create_proof_test.go` |
| HRD | Company/period/active quota, lock, nol/null, retry, begin/commit/rollback, notification sesudah commit | `test/leave_hrd_integrity_test.go`, `approval_repository_lock_test.go`, `leave_service_rejection_coverage_test.go`; risiko alur refund tetap tercatat terpisah |
| Koreksi absensi | Create/history/update urutan sama, handle transaction sama, status/notification identity tetap | `test/attendance_correction_approval_coverage_test.go` |
| Meeting | Expansion member/order/dedup, error check-in/out, timestamp explicit/default, rollback member failure | `test/meeting_service_creation_test.go`, `meeting_member_service_coverage_test.go`, `services_full_coverage_test.go` |
| CSV dan CRUD lain | Header/malformed/empty handling, urutan delete/create, duplicate dan response first/last existing | `test/calendar_csv_service_test.go`, `user_csv_service_coverage_test.go` dan existing CRUD tests |

Skema lokal mendukung pentingnya invariants tersebut: `leaves` mempunyai business key tanggal/company/user/kategori dan saldo `leave_quota.day_remaining` nullable; unique quota pada katalog melibatkan rentang tanggal, tidak hanya periode (`../DATABASE_SCHEMA_CATALOG.md:1120`, `:1155`). Model quota memakai pointer untuk saldo; jangan mengubahnya menjadi scalar saat mempersempit dependency. Tidak ada kebutuhan schema/index change dalam plan ini. Katalog adalah snapshot, bukan bukti schema production terbaru.

Panic identity/ordering, timestamp capture, commit sebelum notifikasi, dan jumlah/urutan query lebih penting daripada sekadar test hijau. Jangan memperkenalkan transaction callback abstraction atau menyatukan helper commit sebagai bagian pemindahan. Jika kemudian perlu mengubah mekanisme transaksi, gunakan review khusus dan verifikasi MySQL terisolasi sesuai quality gate; SQLMock dan Go race tidak membuktikan locking MySQL.

## 6. Kriteria selesai dan batas analisis

- Dua lookup presence dan client HTTP terlihat pada wiring; tidak ada construction tersembunyi pada request path tersebut.
- Empat dependency mati dihapus setelah caller review; service user dependency hanya meminta method yang dipakai.
- HTTP/parsing Pondasi berada dalam package mandiri dengan satu arah import; aturan absensi tetap di service.
- File leave terkelompok berdasarkan pekerjaan bisnis tanpa menambah interface service atau lapisan generik.
- Test existing tetap menguji hasil yang sama; fixture/setup injection dapat berubah secara mekanis. Semua pemeriksaan akhir benar-benar dijalankan saat implementasi.
- Dependency module, schema, SQL, DTO, public HTTP behavior, serta transaction/notification semantics tidak berubah akibat refactor.
- Refactor ini tidak menyelesaikan secara otomatis temuan bisnis refund, keamanan/auth legacy, performa produksi, atau seluruh dependency module coupling.

### Follow-up penempatan unit test

Atas permintaan pengguna setelah plan ini dijalankan, tes murni Pondasi, helper, domain, dan exception ditempatkan di direktori package masing-masing. Tes service, repository, controller, dan route yang menguji kolaborasi lintas package tetap berada di `test/`. Assertions dan skenario tidak diubah.

Pada tahap penyusunan plan hanya dilakukan inspeksi source, caller, metadata module, dan schema lokal. `go list ./service` berhasil. Test aplikasi tidak diulang karena belum ada perubahan aplikasi; hasil test pada turn perbaikan sebelumnya bukan verifikasi implementasi plan ini. Seluruh langkah implementasi masih belum dijalankan.
