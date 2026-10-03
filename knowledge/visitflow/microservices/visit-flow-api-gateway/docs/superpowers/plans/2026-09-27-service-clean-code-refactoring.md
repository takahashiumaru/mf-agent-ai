# Gateway Service Clean Code — Refactoring Plan

> Status: **refactor dan verifikasi selesai**. Plan dan hasil dieksekusi pada 27 September 2026 berdasarkan source lokal.
> Untuk pelaksana: implementasikan per tahap menggunakan skill `executing-plans` setelah ada instruksi implementasi dari user. Dokumen ini tidak mengizinkan commit, push, merge, perubahan branch, atau operasi Git lain yang mengubah state.

**Goal:** meningkatkan readability dan maintainability seluruh folder `service` tanpa mengubah behavior, business logic, kontrak API, dan efek samping existing.

**Architecture:** pertahankan package `service`, interface, constructor, manual dependency wiring, serta boundary controller → service → repository. Pecah implementasi berdasarkan responsibility; gunakan private helper yang konkret hanya untuk blok yang memang kompleks atau berulang. Transaction ownership tetap pada service.

**Tech stack:** Go 1.23 sesuai `go.mod`, Gin, GORM/MySQL, validator, JWT, bcrypt, Redis, Firebase, testify, sqlmock, dan httptest. Tidak menambah dependency.

## 1. Batasan global

- Scope implementasi pertama adalah seluruh folder `service`, bukan rewrite seluruh gateway. Controller, auth, repository, model, dan helper menjadi dependency/kontrak yang harus dilindungi.
- Jangan mengubah signature interface/constructor, exported struct fields, route, DTO, JSON tags, status HTTP, pesan error, ataupun panic identity.
- Pertahankan urutan validasi, query, transaksi, upload, token generation, notifikasi, dan cache update.
- Pertahankan nil/zero/empty semantics, filter, pagination, ordering, tenant/company scope, dan audit fields existing.
- Tidak mengganti panic dengan error-return secara menyeluruh, Gin context dengan context.Context, atau pola transaksi existing dalam tahap readability.
- Tidak menambah BaseService, generic repository, dependency container, framework, package baru, atau abstraction lintas service.
- Tidak melakukan perubahan schema, migrasi, query optimization, upgrade dependency, atau akses database live untuk menjalankan plan ini.
- Jangan commit, push, merge, membuat branch/worktree, atau menjalankan operasi Git yang mengubah state sebelum user mengizinkan.
- Existing behavior yang tampak salah dicatat sebagai pekerjaan terpisah; jangan diperbaiki diam-diam bersama refactor.
- Test menggunakan fixture sintetis, SQL mock, temporary files, dan dependency eksternal yang diisolasi. Tidak mengirim FCM/email sungguhan.

## 2. Cakupan analisis dan keterbatasan

Seluruh 10 file Go dalam `service` telah dibaca: 5 interface dan 5 implementasi, total 1.103 baris termasuk komentar dan blank lines. Dependency ditelusuri melalui route, controller user/file, repository user/session, transaction helper, error mapping, serta test yang relevan. Pola pembanding dibaca dari service presence.

Ini analisis source lokal, bukan bukti deployment atau kondisi production. Test suite belum dijalankan dalam tahap penyusunan dokumen. Detail seluruh repository role, helper eksternal `go-helper`, model/schema, dan jalur auth perlu dikonfirmasi lagi pada tahap baseline sebelum implementasi yang menyentuhnya. Tidak ada klaim bahwa semua test sudah lulus atau regression sudah terbukti tidak ada.

### Inventaris seluruh folder service

| File | Baris | Tindakan yang direncanakan |
| --- | ---: | --- |
| `user_service.go` | 27 | Pertahankan seluruh 14 method dan signature; jangan rename `FindByIdNoAuth` karena bagian dari interface |
| `user_service_impl.go` | 585 | Pecah berdasarkan use case; ekstraksi login, refresh, upload, dan mapping user |
| `file_service.go` | 8 | Pertahankan dua method dan return type |
| `file_service_impl.go` | 114 | Pisahkan file I/O dari parsing slow endpoint |
| `role_service.go` | 16 | Pertahankan lima method dan kontrak |
| `role_service_impl.go` | 127 | Naming dan komentar; transaksi tidak dimigrasikan |
| `user_role_service.go` | 15 | Pertahankan lima method dan kontrak |
| `user_role_service_impl.go` | 111 | Naming dan komentar; pertahankan filter/audit arguments |
| `role_menu_permission_service.go` | 14 | Pertahankan empat method; nama parameter boleh dirapikan |
| `role_menu_permission_service_impl.go` | 86 | Naming dan komentar; tidak perlu dipecah lebih jauh |

### Temuan utama

1. **Login mencampur banyak responsibility.** `VerifyPassword` sekitar 135 baris: concurrent lookup, bcrypt, device comparison, FCM, JWT/session preparation, DB writes, Redis, dan response. Bukti: `service/user_service_impl.go:267`.
2. **Refresh memiliki nested flow dan duplikasi session mapping.** Sekitar 106 baris berisi parsing JWT, claim validation, lookup, period check, token generation, consume session, dan cache update. Bukti: `service/user_service_impl.go:480`.
3. **Create/Update mencampur mapping dan filesystem.** Pembuatan direktori dan penyimpanan gambar berulang. Urutan eksekusi berbeda harus tetap dipertahankan. Bukti: `service/user_service_impl.go:72` dan `:133`.
4. **UpdateNoAuth mempunyai cabang yang berurutan, bukan eksklusif.** Telegram ID nol melakukan clear/reload dahulu, lalu lookup existing user dan update/create. Mengubahnya menjadi early return langsung akan mengubah behavior. Bukti: `service/user_service_impl.go:190`.
5. **Parser slow endpoint bercampur dengan I/O.** Sekitar 85 baris mencakup open/read/error, splitting block, parsing field, dan penyaringan entry. Bukti: `service/file_service_impl.go:30`.
6. **Naming role tidak sesuai konteks.** Constructor menggunakan `city`; parameter menggunakan `role_id`; local `roles`, `user`, dan `roleMenu` kadang tidak menggambarkan entity. Bukti: ketiga file implementasi role.
7. **Transaksi role memerlukan penanganan terpisah.** Sejumlah method membuka `DB.Begin()` sebelum `CreateTransaction`, tetapi handle awal tidak dipakai atau difinalisasi dalam method. Test existing bahkan mengharapkan unused begin; ini bukan sekadar duplikasi yang aman dihapus. Bukti: `service/role_service_impl.go:36`, `:76`, `:114`; `service/user_role_service_impl.go:36`, `:75`, `:87`, `:99`; `test/role_services_coverage_test.go:18`.

## 3. Dependency dan alur yang wajib dipertahankan

### Wiring dan boundary

```text
main / setupJWTRouter
  → route/*.go: manual construction + auth wrapper
  → controller: binding, request parsing, response envelope
  → service: validation, orchestration, transaction ownership
  → repository / auth.CreateToken / filesystem / FCM / Redis
  → domain-to-web mapping
  → controller response atau exception.ErrorHandler
```

Local Gin API dan KrakenD proxy adalah dua surface berbeda. Plan ini tidak mengubah `configuration.json` atau downstream service.

| Flow | Dependency dan urutan existing | Kontrak sensitif |
| --- | --- | --- |
| Login | Dua lookup repository berjalan concurrent → bcrypt → keputusan dan penjadwalan FCM → JWT → transaction: delete session user, insert session, update user → Redis → response | Lookup error/password salah mengembalikan nil; controller menghasilkan 401. FCM saat ini dijadwalkan sebelum DB commit |
| Refresh | Validate → parse JWT → validate claims → lookup user/structure → cek period → JWT → transaction: consume UUID, insert session, update user → Redis | Parse error menghasilkan token kosong; replay menghasilkan unauthorized; period mismatch memakai ErrorSendToResponse |
| Logout / UpdateAccessToken | Transaction: delete seluruh session user, update access/refresh/device ke `-` → invalidate Redis | Jangan mengganti sentinel dengan string kosong/NULL |
| Create user | Validate → begin → mkdir → regex dan bcrypt → waktu join → valid username: mapping/upload/insert; invalid: HTTP 400 + empty response | Bcrypt tetap dieksekusi sebelum cabang invalid username; jangan memindahkan urutan failure |
| Update user | Validate → begin → mkdir → mapping → optional first image upload → repository update | Company berasal dari auth; pointer Firebase dan update zero value tetap sama |
| UpdateNoAuth | Validate → begin → optional clear Telegram/reload → lookup existing → update atau create → response | Jangan menyederhanakan cabang Telegram nol menjadi return; default company/role/password tetap |
| Role / membership / permission | Trace span → resolver → repository → DTO; beberapa method juga membuka transaksi awal | Read/Write handle, filter replacement, dan actor arguments jangan berubah |
| File | Open/read → parser atau raw bytes → controller | Pesan error, empty slice, order entry, dan precedence Token/Auth tetap |

Bukti wiring: `route/users_route.go`, `route/role_route.go`, `route/user_role_route.go`, `route/role_menu_permission_route.go`, `route/file.go`. Response/error: `controller/users_controller_impl.go`, `controller/file_controller_impl.go`, `exception/error_handler.go`. Transaksi lokal: `helper/tx.go`.

### Detail compatibility yang mudah terlewat

- Refresh mengonversi claim user ID menggunakan `strconv.FormatFloat(..., 'f', 1, 64)` untuk lookup pertama, sementara lookup MR memakai structure ID. Jangan menyatukan lookup login dan refresh ke helper yang mengubah argumen tersebut.
- Login membandingkan device ID yang di-trim, tetapi menyimpan `request.DeviceID` mentah. Trim hanya untuk comparison.
- Login memiliki nil guard saat membaca sebagian request, tetapi dereference request lagi setelah token creation. Jangan menganggap nil request sudah didukung atau menambah behavior baru dalam extraction.
- `UpdateNoAuth` create memakai default company ID 1 dan role Administrator. Plan ini tidak menilai ulang aturan tersebut.
- Role delete saat ini meneruskan ID role sebagai actor argument; user-role delete juga meneruskan role ID. Jangan menggantinya dengan auth user ID dalam cleanup.
- `FindAll` user-role dan role-menu-permission membuat filter role sendiri, tidak meneruskan filter input apa adanya.
- Direct `tx.Create(session)` saat login/refresh jangan otomatis diganti repository method: panic/error-return dan rollback behavior harus dibandingkan terlebih dahulu.
- `helper.CommitOrRollback` harus tetap langsung di-defer oleh pemilik transaksi. Membungkusnya dengan helper defer lain dapat mengubah kemampuan `recover()` menangkap panic.

## 4. Pola dari visit-flow-presence yang dipakai sebagai referensi

| Referensi | Pola yang diambil | Batas penerapan |
| --- | --- | --- |
| `../visit-flow-presence/service/office_service_impl.go:82` dan `:95` | Private mapping helper dengan nama spesifik create/update | Cocok untuk mapping user yang panjang; tidak untuk setiap literal kecil |
| `../visit-flow-presence/service/leave_create.go` dan `leave_service_impl.go` | Pemisahan file berdasarkan use case dengan receiver/package yang sama | Terapkan untuk login, refresh, profile, dan password tanpa menambah service interface |
| `../visit-flow-presence/service/calendar_csv.go:16` dan `:37` | Pisahkan parsing dari pekerjaan persistence | Terapkan untuk slow endpoint parser tanpa framework parser |
| `../visit-flow-presence/service/transaction.go:12` | Shared writer transaction untuk dependent reads/writes | Referensi untuk pekerjaan transaksi terpisah; tidak disalin pada tahap behavior-preserving |

Presence merupakan referensi teknik tertentu, bukan template yang harus disalin seluruhnya. Tidak semua method pendek membutuhkan helper baru.

## 5. Target susunan file

Semua tetap dalam package `service`. Lima file interface tetap ada.

```text
service/
  user_service_impl.go       # struct, constructor, read/list/department/delete
  user_profile.go            # Create, Update, UpdateNoAuth, mapping dan image helper
  user_password.go           # ResetPassword, ChangePassword
  user_login.go              # VerifyPassword dan helper khusus login/device alert
  user_session.go            # RefreshToken, CheckToken, UpdateAccessToken, session mapping
  file_service_impl.go       # constructor, raw file read, slow-file I/O
  slow_endpoint_parser.go    # pure parsing content/block menjadi SlowEntry
  role_service_impl.go       # CRUD role; naming cleanup
  user_role_service_impl.go  # membership/report; naming cleanup
  role_menu_permission_service_impl.go # permission; naming cleanup
```

Jangan membuat `utils.go`, `common.go`, atau transaction wrapper generik. Helper berada di file use case pemiliknya. Pemisahan file dilakukan dahulu tanpa perubahan body; ekstraksi dilakukan pada tahap berikutnya agar mudah direview.

## 6. Tahapan implementasi

Setiap tahap berakhir dengan verifikasi sendiri. Berhenti apabila muncul perbedaan behavior yang belum dijelaskan; jangan memperbarui expected result agar sekadar menjadi hijau.

### Tahap 0 — Kunci baseline dan kontrak

**File:** test existing di `test/`, route/controller terkait, repository/model/helper yang dipakai. Belum mengubah implementasi.

- [x] Konfirmasi dependency `go-helper` versi yang dipakai, khususnya `CreateTransaction` dan `CommitOrRollback`, dari module cache/source dependency.
- [x] Cocokkan model dan repository untuk users, sessions, roles, user_roles, role_menu_permissions: zero-value update, hard/soft delete, argumen tenant/actor, dan response mapping. Baca DDL relevan dari dokumentasi schema tanpa menampilkan data dump.
- [x] Audit seluruh test yang akan dieksekusi terhadap akses Firebase, Redis, SMTP, MySQL, konfigurasi, serta filesystem. Gunakan fixture/temporary directories dan konfigurasi test yang terisolasi.
- [x] Jalankan baseline targeted tests lalu suite setelah audit. Catat failure existing secara terpisah; jangan menganggap baseline selalu hijau.
- [x] Jalankan characterization tests existing pada baseline; tambahkan expected output parser penuh sebelum ekstraksi parser, lalu pertegas urutan dan field mapping Telegram. Controller/API tidak diubah sehingga kontrak HTTP existing tetap diuji oleh suite controller.
- [x] Perkuat assertion pada mapping user dan urutan sinkronisasi Telegram. Mock role/resolver legacy yang memakai `mock.Anything` tetap dipertahankan karena alur transaksi role tidak diubah.

**Deliverable:** baseline terukur dan daftar kontrak yang dikunci. Test baru yang gagal pada existing code harus dievaluasi sebagai asumsi keliru atau bug terpisah, bukan langsung mengubah business logic.

### Tahap 1 — Pisahkan user service secara mekanis

**Modify:** `service/user_service_impl.go`.
**Create:** `service/user_profile.go`, `service/user_password.go`, `service/user_login.go`, `service/user_session.go`.

- [x] Pindahkan method sesuai peta file; pertahankan receiver, signature, body, dan statement order.
- [x] Sesuaikan import di file masing-masing; jangan sekaligus rename atau mengubah transaksi.
- [x] Pastikan constructor dan exported fields tetap sama sehingga route/test tidak perlu diubah.
- [x] Jalankan seluruh test UserService dan session serta compile semua package.

**Deliverable:** file terpisah berdasarkan responsibility dengan behavior identik. Tahap ini belum menargetkan pemendekan function.

### Tahap 2 — Pisahkan parser slow endpoint

**Modify:** `service/file_service_impl.go`, `service/file_service_test.go`.
**Create:** `service/slow_endpoint_parser.go`, `service/slow_endpoint_parser_test.go`.

**Private helper contract:**

```go
func parseSlowEndpointEntries(content string) []web.SlowEntry
func splitSlowEndpointBlocks(content string) []string
func parseSlowEndpointBlock(block string) (web.SlowEntry, bool)
```

- [x] Tambahkan characterization test melalui `FileService` publik dengan expected entry penuh, bukan hanya jumlah entry.
- [x] Ekstrak splitting dan parsing persis dari loop existing; boolean menandai apakah entry lolos predicate existing.
- [x] Pertahankan open/read/close dan pemetaan error di `FindFileSlowEndpoint`; `FindFileUser` tetap sederhana.
- [x] Pertahankan urutan field: ketika Auth dan Token sama-sama muncul, field terakhir yang diproses menang.
- [x] Verifikasi blank input menghasilkan empty non-nil slice; block headerless yang hanya berisi status/duration dibuang, sedangkan headered block tetap lolos karena timestamp; invalid status tidak mengubah nilai sebelumnya; Auth/Token mengikuti urutan baris.
- [x] Jalankan test FileService serta controller slow endpoint.

**Deliverable:** service terbaca sebagai read → parse → return; parser dapat diuji tanpa file I/O. Jangan mengganti algoritme dengan scanner/regex baru.

### Tahap 3 — Rapikan profile dan password

**Modify:** `service/user_profile.go`, `service/user_password.go`, `test/user_service_coverage_test.go`.

- [x] Ekstrak mapping create/update/sync user yang panjang ke private helper spesifik; input memakai request/auth/timestamp yang sudah tersedia, output `*domain.User`.
- [x] Ekstrak upload opsional yang benar-benar identik: pilih gambar pertama, format nama existing, panggil callback existing, propagate error existing, return nama file. Pertahankan waktu pemanggilan `time.Now()` dan urutan mkdir/hash/upload/write.
- [x] Di `UpdateNoAuth`, beri nama blok mapping existing/new user secara jelas; pertahankan clear Telegram + reload sebelum lookup existing. Jangan mengganti alur dengan upsert atau early return.
- [x] Di `ChangePassword`, rapikan nama `getUser` menjadi `existingUser`; jangan memindahkan compare/hash keluar transaksi atau mengubah urutan old-password/confirmation validation.
- [x] Pertahankan `ResetPassword` yang sudah pendek; cukup hapus komentar kosong/typo yang tidak bernilai.
- [x] Jalankan user create/update/no-auth/password tests berikut failure upload, invalid username, zero Telegram, existing/new user, dan field mapping.

**Deliverable:** orchestration terpisah dari mapping/upload tanpa generalisasi create dan update menjadi satu fungsi dengan flag mode.

### Tahap 4 — Pecah login berdasarkan fase

**Modify:** `service/user_login.go`, `test/user_service_coverage_test.go`.
**Create:** `test/user_login_device_test.go` untuk keputusan notifikasi melalui alur login publik.

- [x] Ekstrak dua concurrent lookup ke satu helper khusus login; pertahankan dua goroutine, wait, handle DB, dan error behavior. Jangan membuat shared loader untuk refresh yang sekarang sequential dan berbeda argumen.
- [x] Ekstrak predicate device notification menjadi pure function dengan input device lama/baru dan token lama/baru. Normalisasi device saja seperti existing.
- [x] Pisahkan scheduling FCM dari predicate, tetapi pertahankan titik scheduling sebelum JWT dan DB transaction, isi pesan, serta asynchronous behavior.
- [x] Ekstrak pembuatan payload user token dan session hanya bila membuat orchestration lebih mudah dibaca; pertahankan raw device ID dan optional Firebase update.
- [x] Biarkan callback `DB.Transaction` tampak jelas: revoke old sessions → create session → update user. Jangan sembunyikan urutan ini dalam generic helper.
- [x] Pertahankan cache update sesudah transaksi berhasil dan `context.Background()` existing dalam scope refactor ini.
- [x] Uji lookup error, password salah, device matrix, token generation error, insert/update failure, rollback, serta successful response.

**Device matrix wajib:** request device kosong/`-`/sama/berbeda; whitespace; DB device kosong/`-`; old Firebase nil/kosong; new Firebase kosong/sama/berbeda.

**Deliverable:** `VerifyPassword` menjadi orchestration yang terbaca top-down. Target sekitar 40–60 baris jika natural; bukan batas wajib dan bukan alasan menyembunyikan transaksi/error handling.

### Tahap 5 — Rapikan refresh/session dan hilangkan duplikasi yang nyata

**Modify:** `service/user_session.go`, `service/user_login.go`, `test/session_refresh_coverage_test.go`, `test/user_service_coverage_test.go`.

**Shared mapping yang layak:**

```go
func newSessionFromToken(userID uint, details *auth.TokenDetails) *domain.Session {
    return &domain.Session{
        UserID: userID,
        RefreshUUID: details.RefreshUUID,
        Expired: time.Unix(details.RefreshTokenExpired, 0),
        UserAgent: details.UserAgent,
        RemoteAddress: details.RemoteAddress,
    }
}
```

- [x] Gunakan mapping tersebut pada callback token creation login/refresh; jangan memindahkan creation ke DB sebelum transaksi.
- [x] Ekstrak parsing JWT dan pembacaan claims ke helper khusus refresh dengan pembedaan parse error, unauthorized, dan expired yang sama.
- [x] Ratakan nesting melalui guard clauses hanya bila return/panic dan urutan query sama. Period mismatch tetap sesudah kedua lookup.
- [x] Pertahankan transaction callback eksplisit: consume UUID → conditional session insert → user update. Consume false harus rollback dan unauthorized.
- [x] `CheckToken` boleh disederhanakan menjadi error guard dan return literal; jangan mengubah semua repository error yang saat ini menjadi unauthorized.
- [x] `UpdateAccessToken` tetap pendek; pertahankan revoke/update sentinel/cache invalidate order.
- [x] Jalankan refresh success/replay tests; tambahkan exact claims/lookup assertions, missing/wrong claims, expired/malformed token, missing secret, period mismatch, serta DB failure paths.

**Deliverable:** flow refresh lebih datar dan mapping session tidak terduplikasi; login/refresh tetap memiliki orchestration sendiri.

### Tahap 6 — Naming konsisten pada role services

**Modify:** ketiga `*_role*service_impl.go` yang relevan, `service/role_service_impl.go`, dan nama parameter interface jika diperlukan tanpa perubahan signature type.

- [x] Rename constructor parameter `city` menjadi `roleRepository`, `userRoleRepository`, atau `roleMenuPermissionRepository` sesuai service.
- [x] Rename local/parameter `role_id` dan `role_ID` menjadi `roleID`; `mapFilter` menjadi `roleFilters`; nama hasil menjadi `userRoles` atau `rolePermissions` sesuai entity.
- [x] Rapikan blank lines, komentar kosong, dan komentar yang sekadar mengulang statement. Gunakan komentar untuk alasan compatibility yang tidak jelas.
- [x] Jangan menghapus Begin, mengganti finalization, memperbaiki actor ID, mengubah filter, menghapus output log, atau mengganti span name dalam tahap ini.
- [x] Jangan memecah CRUD yang sudah pendek menjadi helper satu baris atau mapping generik.
- [x] Jalankan role/member/permission service tests dan controller tests; implementasi filter dan argumen repository tidak diubah.

**Deliverable:** penamaan sesuai domain tanpa abstraction baru dan tanpa perubahan SQL/transaction behavior.

### Tahap 7 — Verifikasi akhir dan review readability

- [x] Review seluruh 10 file awal dan file hasil pemisahan; setiap method memiliki lokasi dan responsibility yang jelas.
- [x] Bandingkan daftar method interface/constructor, route, JSON fields, error strings, query arguments, dan external effect order sebelum/sesudah.
- [x] Pastikan tidak ada perubahan repository SQL, GORM update mode, transaction owner, atau nil/empty response yang terselip.
- [x] Jalankan focused tests, full suite, vet, build, dan race sesuai audit lingkungan test.
- [x] Periksa helper baru: nama menjelaskan pekerjaan, parameter bukan kumpulan flag mode, tidak hanya memindahkan kompleksitas ke abstraction generik.
- [x] Laporkan hasil aktual, failure existing, test yang belum dapat dijalankan, dan risiko yang masih belum terverifikasi.

## 7. Matriks regression minimum

| Area | Existing test | Tambahan/verifikasi yang diperlukan |
| --- | --- | --- |
| User reads/delete | `test/user_service_coverage_test.go` | Exact ID/filter/pagination/actor, nil/empty mapping, begin/commit/rollback |
| Create/update | `test/user_service_coverage_test.go` | Full mapped fields, invalid username HTTP 400, bcrypt cost/verification, first image only, upload failure dan urutan |
| Telegram sync | `test/user_service_coverage_test.go` | Ordered clear/reload/lookup/update/create; zero Telegram; default fields |
| Password | `test/user_service_test.go`, `test/user_service_coverage_test.go` | Error type + exact message termasuk whitespace; no write on rejected password |
| Login | `test/user_service_test.go`, `test/user_service_coverage_test.go` | Device decision matrix, same tx identity, failure rollback, FCM/cache order tanpa pengiriman nyata |
| Refresh/replay | `test/session_refresh_coverage_test.go` | Exact lookup arguments, consume false, insert/update/commit failure; JWT claims/expiry dengan toleransi waktu |
| Logout/check token | `test/user_service_coverage_test.go` | Sentinel `-`, session hard delete, invalidate setelah sukses, unauthorized error identity |
| Roles/permissions | `test/role_services_coverage_test.go` | Actor/filter exactness; resolver Read/Write identity; jangan hanya `mock.Anything` |
| Parser/files | `service/file_service_test.go`, `test/gateway_misc_coverage_test.go` | Empty/nonexistent/read errors; malformed/duplicate fields; unknown text; Auth/Token order |
| HTTP contracts | `test/users_controller_coverage_test.go`, `test/routes_coverage_test.go`, `main_coverage_test.go` | Tambah integrated handler+real service+mock repository bila controller-only mock belum melindungi error path |

Test SQL mock membuktikan panggilan dan expectation, bukan isolation/locking MySQL atau race replay pada DB nyata. Test goroutine FCM existing menggunakan sleep singkat; ini belum membuktikan timing atau delivery. Bila diperlukan test seam, gunakan hook private yang sempit dan pertahankan constructor publik; jangan memperkenalkan interface eksternal baru hanya untuk mengejar coverage.

## 8. Perintah verifikasi yang direncanakan

Jalankan dari root `visit-flow-api-gateway`, sesudah audit side effect test. Perintah berikut **belum dijalankan** saat dokumen dibuat.

```bash
# Targeted characterization/regression
go test ./test -count=1 -run 'Test(UserService|RoleService|UserRole|RoleMenuPermission|SessionRepository|FileService)'

# Pure helper tests yang baru dibuat
go test ./service -count=1

# Full regression, static checks, dan build tanpa binary dalam repository
go test ./... -count=1
go vet ./...
go build -o /tmp/visit-flow-api-gateway-refactor-check .

# Race: terutama login concurrent lookup dan background notification
go test -race ./... -count=1

# Coverage tanpa mengubah README
go test ./... -count=1 -coverpkg=./... -coverprofile=/tmp/visit-flow-api-gateway-refactor-coverage.out
go tool cover -func=/tmp/visit-flow-api-gateway-refactor-coverage.out
```

Expected: test/build/vet/race lulus; bila baseline memiliki failure, identifikasi terpisah dan jangan klaim seluruh gate lulus. Coverage dibandingkan dengan baseline dan minimum Makefile 70%, bukan digunakan sebagai bukti tunggal tidak ada regression. Jalankan staticcheck/gocritic sesuai quality gate bila tool tersedia; catat jika tidak tersedia.

`gofmt` hanya dijalankan pada file Go yang berubah saat implementasi. Jangan menjalankan `make cover`, `make check-cov`, atau `make check-all` tanpa memperhitungkan efeknya menulis coverage dan memperbarui README. Tidak menjalankan `go mod tidy` untuk refactor ini.

## 9. Pekerjaan terpisah yang tidak termasuk refactor ini

| Temuan | Alasan dipisahkan |
| --- | --- |
| Unused Begin dan lifecycle resolver role | Mengubah transaksi, finalization, error timing, dan expectation existing; butuh review dependency dan verifikasi database khusus |
| FCM sebelum commit, goroutine lifetime, logging device/token | Memindahkan notifikasi/log mengubah side effect; perlu keputusan behavior dan test seam sendiri |
| Gin context di service, plain DB tanpa request context | Migrasi signature/context mengubah cancellation behavior dan callers |
| Direct session insert di service | Memindahkan ke repository dapat mengubah error/panic flow; tidak perlu untuk readability tahap pertama |
| Nil request login, refresh ID conversion, actor role delete | Potensi bug/legacy contract; konfirmasi business intent sebelum perbaikan |
| Filter input diabaikan atau company/audit default | Perubahan dapat mengubah hasil dan data yang ditulis |
| Role enforcement/auth route, validation tambahan, path hardening | Security/behavior change harus dibahas tersendiri; tidak diselipkan ke cleanup |
| Upload cleanup saat DB rollback atau handling close error baru | Menambah efek samping atau mengubah outcome kegagalan existing |

Tidak adanya perbaikan tersebut dalam tahap ini bukan endorsement pola legacy. Tujuannya menjaga refactor dapat dibedakan dari perubahan behavior.

## 10. Definition of done

- [x] Semua service tetap dapat dipakai melalui interface dan wiring existing.
- [x] Login, refresh, profile, password, role, permission, file, dan parser memiliki regression evidence yang relevan.
- [x] Function kompleks lebih kecil berdasarkan responsibility; CRUD sederhana tidak dibuat lebih rumit.
- [x] Flow utama dapat dibaca dari atas ke bawah, dengan transaction boundary dan efek eksternal terlihat jelas.
- [x] Mapping session dan upload identik yang layak dibagi tidak lagi terduplikasi; tidak ada abstraction generik baru.
- [x] Tidak ada perubahan business rules, query parameters, auth behavior, response/error contracts, atau external effect ordering.
- [x] Existing dan tambahan test lulus sesuai gate yang benar-benar dijalankan; keterbatasan integrasi dinyatakan.
- [x] Tidak ada perubahan secret/config/schema/dependency, dan tidak ada commit/push/merge/perubahan Git tanpa izin.

Urutan yang dijalankan: **baseline → pemisahan file → parser → profile/password → login → refresh/session → naming role → verifikasi akhir**. Lihat catatan pelaksanaan di bawah untuk hasil gate dan keterbatasan verifikasi.


## Catatan pelaksanaan — 27 September 2026

- Method `UserService` kini dipisah menurut profile, password, login, dan session; mapping user, upload image, lookup login/refresh, predicate device notification, pembuatan session, parsing JWT, dan parsing slow endpoint berada pada helper private yang bernama sesuai tugasnya.
- Naming role diperjelas; interface method types, constructor wiring, route, query repository, transaksi, filter, log output, sentinel, dan external effect order tetap. `FindByIdNoAuth` dipertahankan sebagai nama legacy.
- Regression evidence mencakup output parser lengkap, status-only headered block, precedence Auth/Token, kegagalan read, field mapping user, file upload pertama, matrix device, mapping session, urutan UpdateNoAuth, create defaults, refresh success/replay, dan semua test existing.
- Unit test perilaku package service yang mandiri ditempatkan di `service/`; test alur lintas-package tetap di `test/` dan menggunakan API service publik. Root `main_coverage_test.go` tetap di root karena menguji fungsi privat package `main` yang tidak dapat diakses dari package test lain tanpa memindahkan kode produksi.
- Perilaku yang terlihat pada test parser diperbarui akurat: blok dengan heading selalu membawa timestamp dan dapat masuk hasil meskipun hanya memiliki `Status`; blok pembuka tanpa heading tidak masuk jika hanya memiliki field yang tidak termasuk predicate existing.
- Baseline full suite dan final full suite lulus. Final suite dijalankan dengan `FIREBASE_CREDENTIALS_FILE=/tmp/visitflow-no-firebase-credentials.json`; test email menggunakan SMTP lokal dan test Redis menggunakan server lokal yang sengaja tidak aktif.
- Gate yang dijalankan: `go test ./... -count=1`, `go test -race ./... -count=1`, `go vet ./...`, `go build -o /tmp/visit-flow-api-gateway-refactor-check .`, `staticcheck ./...`, dan `gocritic check ./...`; semuanya selesai tanpa error. Coverage final dari `go test ./... -coverpkg=./... -coverprofile=/tmp/visit-flow-api-gateway-refactor-coverage.out` adalah **95,3% total statements**.
- `go-helper` v0.5.6 `CreateTransaction` membuat transaksi writer lalu reader; pola/urutan dan defer existing pada role services sengaja tidak diubah. Schema comparison memakai dokumentasi DDL yang tersedia, bukan inspeksi live database; tidak ada model, repository SQL, atau schema yang diubah.
- Tidak dibuat commit, push, merge, branch, atau worktree. Tidak ada perubahan Git metadata.
- Batas bukti: test SQL memakai sqlmock dan tidak membuktikan isolation/locking MySQL production. Perubahan ini tidak mengubah query atau transaksi, sehingga verifikasi integration/live database tidak dilakukan.
