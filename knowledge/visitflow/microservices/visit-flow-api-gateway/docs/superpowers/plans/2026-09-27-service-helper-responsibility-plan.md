# Service dan Helper Responsibility Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `subagent-driven-development` or `executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Status:** plan dieksekusi lokal pada 27 September 2026. Perubahan belum di-commit atau di-push.

**Goal:** tempatkan parsing file dan operasi upload gambar yang sekarang tersembunyi di `service` ke `helper`, sambil menjaga keputusan bisnis, kontrak publik, dan urutan efek samping tetap sama.

**Architecture:** `service` tetap mengatur workflow, transaksi, error mapping, dan keputusan bisnis. `helper` menampung dua operasi mekanis yang dapat berdiri sendiri: parsing teks slow endpoint dan penyimpanan gambar user. Tidak membuat subpackage, interface, atau dependency baru.

**Tech Stack:** Go 1.23, Gin, GORM, `model/web`, sqlmock, testify. Versi modul tetap mengikuti `go.mod`.

## Batasan dan bukti awal

- Baseline: branch `refactor/service-package-design-solid-dependencies`, commit `aec0d7f`. Working tree bersih sebelum dokumen plan ini dibuat.
- `route/users_route.go` tetap memakai `NewUserService`; controller dan interface `UserService`/`FileService` tidak berubah.
- `service` mengimpor `helper`, `auth`, `repository`, `model/domain`, dan `model/web`. `auth` juga mengimpor `helper`. `helper` sudah mengimpor `model/web` dan `config`, tetapi tidak mengimpor `service`, `auth`, atau `model/domain`. Karena itu parser yang hanya memakai `model/web` dapat dipindah tanpa cycle; `helper` tidak boleh dibuat mengimpor `auth` untuk memindahkan fungsi session.
- `service/file_service_impl.go:28` membuka/membaca file dan memetakan error; `service/slow_endpoint_parser.go:10` hanya mengubah teks menjadi `[]web.SlowEntry`. Unit test melalui API publik ada di `service/file_service_test.go` dan `service/slow_endpoint_parser_test.go`.
- `service/user_profile.go:20` dan `:55` mengatur validasi, transaksi, `MkdirAll`, pemetaan user, upload, dan repository. Fungsi private `saveUserImage` di `:159` hanya memilih gambar pertama, membuat nama/path, lalu memanggil callback upload. Existing helper sudah memiliki `PathUser` (`helper/path.go:6`) dan utilitas gambar (`helper/get_image.go:13`). Test create/update dengan gambar ada di `test/user_service_coverage_test.go:403` dan `:473`.
- Tidak ada permintaan mengubah behavior. Jangan mengubah urutan validasi, hash, `MkdirAll`, upload, repository, commit/rollback, panic/error mapping, format response, atau path/nama file.
- Tidak mengakses database, Redis, atau Firebase live. Tidak mengubah konfigurasi, schema, route, `go.mod`, atau `go.sum`.

## Keputusan penempatan

| Fungsi/kelompok saat ini | Penempatan target | Alasan dan batas |
| --- | --- | --- |
| `parseSlowEndpointEntries`, `splitSlowEndpointBlocks`, `parseSlowEndpointBlock`, `parseSlowEndpointLine` | `helper/slow_endpoint_parser.go`; hanya entry point menjadi `ParseSlowEndpointEntries` | Pure text parsing; file service tetap memiliki open/read dan pesan error. `helper` sudah bergantung pada `model/web`, sehingga tidak menambah arah dependency baru. |
| `saveUserImage` | `helper/user_image.go` sebagai `SaveUserImage` | Pemilihan file pertama, nama/path, dan pemanggilan upload adalah mekanisme file. Service tetap memilih kapan operasi dilakukan dan bagaimana error dipropagasi. |
| `os.MkdirAll(helper.PathUser, os.ModePerm)` | Tetap pada posisi existing di `service/user_profile.go` | Dipanggil juga ketika tidak ada gambar dan sebelum validasi username/hashing selesai. Menggabungkannya dengan `SaveUserImage` akan mengubah efek samping dan urutan error. Wrapper satu baris terpisah belum memberi manfaat. |
| `userForCreate`, `userForUpdate`, `userForTelegramSync` | Tetap di `service/user_profile.go` | Mapper ini berisi actor/company/default dan bentuk entity untuk workflow tertentu. Memindahkannya akan memperluas `helper` menjadi tempat aturan bisnis. |
| `shouldNotifyPreviousDevice`, `notifyPreviousDevice`, `UserEffects` | Tetap di `service` | Keputusan keamanan login, scheduling efek, serta konfigurasi per instance adalah milik workflow user. Default FCM/cache memang memanggil helper existing. |
| `newSessionFromToken`, `parseRefreshJWT`, refresh/transaction functions | Tetap di `service` | Session mapping dan validasi token spesifik auth workflow. `helper -> auth` akan membuat cycle karena `auth -> helper` sudah ada. |
| Role/user-role/permission CRUD dan transaksi | Tetap di `service` | Actor, span, resolver, dan urutan transaksi adalah orkestrasi; jangan dibuat helper CRUD generik. |

Pemindahan dua fungsi tidak dijadikan alasan untuk memindahkan seluruh isi `service`. Tambahan fungsi exported di `helper` dibatasi pada dua operasi yang benar-benar dipanggil service; semua langkah internal parser tetap private.

## Kontrak behavior yang harus dikunci

1. Parser: input kosong/whitespace menghasilkan slice kosong **non-nil**; pemisahan berdasarkan `"\n### "`; entry tanpa timestamp/method/path/filter/token dibuang meskipun memiliki status/duration; status invalid tetap nol; `Auth` dan `Token` terakhir sesuai urutan baris menang.
2. File service: open/read failure tetap menghasilkan panic `exception.ErrorSendToResponse` dengan pesan existing; hasil parse tetap `[]web.SlowEntry` dalam urutan existing.
3. Gambar user: tanpa gambar menghasilkan `""` tanpa memanggil callback; hanya `images[0]` disimpan; format nama tetap `name + "-" + UnixSeconds + ".png"`; path tetap `helper.PathUser + filename`; fungsi mengembalikan filename dan error callback yang sama.
4. Create/Update: `MkdirAll` tetap pada lokasi dan mode existing, upload tetap setelah mapping dan sebelum repository write, dan panic/error callback tetap melalui `helper.PanicIfError`. File yang sudah terunggah tidak otomatis dibatalkan ketika transaksi DB gagal; itu behavior existing.
5. Jangan sekalian sanitasi filename, ubah ekstensi, ganti clock, atur timeout, ubah penggunaan `gin.Context`, atau memindahkan notifikasi ke setelah commit. Semua itu perlu perubahan behavior yang terpisah.

## Task 1 — Perkuat contract tests sebelum memindahkan fungsi

**Files:** modify `service/file_service_test.go` dan `test/user_service_coverage_test.go`; pertahankan `service/slow_endpoint_parser_test.go`.

- [x] Tambahkan `assert.NotNil` untuk hasil file kosong, dan pertahankan tabel entry selection/order yang sudah ada.
- [x] Pada create/update tanpa gambar, assert callback tidak dipanggil dan `user.Image == ""`. Untuk gambar, assert callback menerima file pertama dan path tepat berbentuk `file/user/<name>-<UnixSeconds>.png`; gunakan regex untuk detik, bukan detik tertentu.
- [x] Tambahkan callback yang mengembalikan sentinel error; assert panic membawa error yang sama dan repository write tidak dipanggil. Untuk create invalid username, pastikan test tetap memeriksa status 400 dan directory side effect existing tanpa mengubah urutan operasi.
- [x] Jalankan test yang menyentuh file/profile sebelum perubahan untuk mendapatkan baseline; semua assertion baru harus lulus pada kode lama.

**Gate:** `go test ./test -count=1 -run 'TestFileService|TestParseSlowEndpointEntries|TestUserService_(Create|Update)'`. Test baru menggunakan temp directory, sqlmock, dan callback fake; tidak menyentuh file/user asli atau layanan eksternal.

## Task 2 — Pindahkan parser slow endpoint ke helper

**Files:** create `helper/slow_endpoint_parser.go`; remove `service/slow_endpoint_parser.go`; modify `service/file_service_impl.go` dan `service/doc.go`.

- [x] Pindahkan seluruh isi parser **tanpa mengubah algoritme**, dengan satu perubahan nama entry point: `parseSlowEndpointEntries(content string) []web.SlowEntry` menjadi `helper.ParseSlowEndpointEntries(content string) []web.SlowEntry`. Tiga fungsi `splitSlowEndpointBlocks`, `parseSlowEndpointBlock`, dan `parseSlowEndpointLine` tetap private di `helper`.
- [x] Pada `FindFileSlowEndpoint`, ganti hanya baris return menjadi `return helper.ParseSlowEndpointEntries(string(fileBytes))`; cabang error open/read dan isi `web.SlowEntry` tidak berubah.
- [x] Sesuaikan komentar `service/doc.go` agar menyebut parsing file mekanis berada di `helper`, sedangkan transaksi dan mapping workflow tetap di `service`.
- [x] Periksa `rg -n 'parseSlowEndpointEntries|ParseSlowEndpointEntries' service helper test` dan `go list ./...` untuk memastikan tidak ada caller tertinggal atau import cycle.

**Gate:** focused test Task 1 dan `go test ./... -count=1`; review diff fungsi parser sebelum/sesudah untuk memastikan hanya package dan nama entry point berubah.

## Task 3 — Pindahkan operasi simpan gambar user ke helper

**Files:** create `helper/user_image.go`; modify `service/user_profile.go`; test yang sama dengan Task 1.

- [x] Pindahkan fungsi private menjadi `helper.SaveUserImage` dengan signature persis: `func SaveUserImage(name string, images []*multipart.FileHeader, saveUploadedFile func(file *multipart.FileHeader, dst string) error) (string, error)`.
- [x] Isi fungsi tetap: jika `len(images) == 0`, return `"", nil`; buat `fmt.Sprintf("%s-%d.png", name, time.Now().Unix())`; panggil `saveUploadedFile(images[0], PathUser+filename)`; return `filename, err`. Jangan mengganti `time.Now()` atau memperlakukan nil callback secara berbeda.
- [x] Pada Create/Update, ganti hanya pemanggilan `saveUserImage(...)` menjadi `helper.SaveUserImage(...)`. Pertahankan `os.MkdirAll` di lokasi existing; hapus import `fmt`/`mime/multipart` hanya bila tidak lagi dipakai (method signature masih memakai multipart; `time` masih dipakai join date).
- [x] Bandingkan urutan `Validate -> Begin -> MkdirAll -> mapping/upload -> repository -> commit/rollback` sebelum dan sesudah.

**Gate:** focused create/update tests, termasuk no-image, first-image, error callback, lalu `go test ./... -count=1`.

## Task 4 — Review dependency dan verifikasi akhir

**Files:** tidak ada production edit tambahan kecuali temuan langsung dari Task 2–3. Dokumentasi plan ini boleh diberi status hasil aktual saat implementasi nanti.

- [x] Jalankan `gofmt -l` pada file Go yang berubah, `go list ./...`, `go test ./... -count=1`, `go test -race ./... -count=1`, `go vet ./...`, `staticcheck ./...`, `gocritic check ./...`, `go build -o /tmp/visit-flow-api-gateway-helper-refactor-check .`, dan `git diff --check`.
- [x] Review `git diff` untuk kontrak `UserService`, `FileService`, route/controller, response/status/error, upload side effects, dan import graph. `go.mod`, `go.sum`, SQL, serta konfigurasi harus tetap bersih.
- [x] Catat hasil aktual dan keterbatasan: mock/file temp membuktikan behavior lokal, bukan integrasi MySQL/Redis/Firebase live.
- [x] Jangan commit, push, atau merge sebagai bagian plan ini; lakukan hanya jika ada instruksi baru yang jelas.

## Kriteria penerimaan

- Parser dan upload mekanis berada di `helper`; decision/auth/session/transaction ownership tetap di `service`.
- Tidak ada import cycle, helper yang sekadar pass-through, interface baru, atau dependency baru.
- Semua behavior yang tercantum di atas tetap identik, termasuk nil/empty, path, filename, urutan, panic identity, dan error message.
- Test existing dan test tambahan lulus; pemeriksaan build/static/diff lulus.
- Perubahan dapat direview sebagai diff kecil; belum ada commit/push berdasarkan permintaan saat ini.

## Hasil eksekusi

- Focused baseline characterization tests passed before production changes.
- Parser source matches the baseline exactly except for package name and exported entry-point name.
- `go test ./test -count=1 -run 'TestFileService|TestParseSlowEndpointEntries|TestUserService_(Create|Update)'` — passed.
- `go list ./...` — passed; no import cycle.
- `go test ./... -count=1` and `go test -race ./... -count=1` — passed.
- `go vet ./...`, `staticcheck ./...`, `gocritic check ./...`, build, `gofmt -l` for changed Go files, and `git diff --check` — passed.
- No live MySQL, Redis, or Firebase integration was exercised.
- No commit or push was made.
