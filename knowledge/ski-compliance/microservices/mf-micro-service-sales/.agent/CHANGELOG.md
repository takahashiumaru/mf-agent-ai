# AI Engineering & Knowledge Base Changelog

This changelog records updates, changes, and enhancements to engineering standards, guidelines, skills, and codebase modifications in this repository.

> [!IMPORTANT]
> **MANDATORY RULE FOR ALL AI AGENTS**:
> Whenever an AI Agent performs modifications or prepares a commit in this codebase, the agent **MUST** record a summary under `## Commit History` in this file using the format `## YYYY-MM-DD — `commit message`` before committing or pushing!

---

## Commit History

## 2026-09-29 — `test: execute isolated query optimization experiments` (uncommitted)

- Add a local socket-only synthetic MySQL harness and recorded results for query/index candidates.
- Reject application integration of range batching due to changed within-month result sequence; retain analytics SQL pending representative performance evidence.
- Inspect DEV metadata read-only; schema parity for proposed drops is not established. No shared index mutation.
- Go 1.23 race suite, vet, build and Python harness passed. No new application code or Git mutation.
- See [execution report](../docs/refactoring/sales-query-plan-execution.md) for partial completion and open gates.

## 2026-09-29 — `docs: plan query optimization and index safety gates` (uncommitted)

- Refresh live read-only index/FK metadata for six Sales-related tables.
- Document feature equivalence gates, three conditional duplicate-index removals and one optional covering-index experiment.
- Include unexecuted DEV SQL/recovery proposals; no application code, schema, data or Git mutation.
- See [query/index plan](../docs/refactoring/sales-query-index-plan.md).

## 2026-09-29 — `perf: use indexed territory default predicates` (uncommitted)

- Replace two Sales FF territory JOIN predicates with equivalent direct is_default equality.
- Verify live nullable numeric type and existing composite index; diagnostic EXPLAIN uses four index parts instead of two. No endpoint speedup claimed.
- Period 202609 read-only predicate comparison: zero mismatches across 69,395 rows.
- Go 1.23 race/shuffle suite, vet and build passed. No Git, schema or data mutation.
- Record remaining query hotspots, full-query EXPLAIN limitation and warehouse scope in [performance audit](../docs/refactoring/sales-query-performance-audit.md).


## 2026-09-29 — `test: align sales tests with package responsibilities` (uncommitted)

- Move workbook contracts and unchanged golden fixtures alongside internal/reportexcel; retain a public helper compatibility test.
- Separate queue, email and calendar test files and reuse queue decoding/observation setup without weakening existing assertions.
- Add target update/delete failure tests for rollback with no queued synchronization.
- Isolate the pinned hierarchy reader's relative fixture path in a temporary working directory and assert the hierarchy query arguments.
- Go 1.23 race/shuffle suite passed three iterations: 88 distinct top-level tests, coverage 92.3%. Targeted checks, concurrent header-test processes, vet, GoCritic and Staticcheck passed.
- Application source, module versions and golden contents unchanged; no Git mutation or production operation.
- See [current testing inventory](TESTING.md).


## 2026-09-29 — `refactor: improve sales package cohesion` (uncommitted)

- Split Sales FF repository methods into cohesive files without changing their declarations/bodies or SQL.
- Move workbook generation into internal/reportexcel; preserve public helper wrappers and characterize original workbook output.
- Close calendar, queue and email assertion gaps; verify four intentional behavior mutations are rejected.
- Full suite: 85 top-level tests passed; repeated shuffled race suite passed; coverage 95.5%. Go 1.23 tests/build/vet, GoCritic, Staticcheck and module checks passed. See report for exact execution sequence.
- Preserve all public interfaces/service constructors and pinned dependencies; defer conditional API changes under the approved plan's compatibility gates.
- No Git mutation, production call, database mutation or deployment.
- See [execution report](../docs/refactoring/sales-package-refactor.md).


## 2026-09-29 — `refactor: separate sales service responsibilities` (uncommitted)

- Split Sales FF by responsibility; extract CSV conversion, Sales Share mapping, recipient lookup, distributor enqueue and calendar closing checks.
- Preserve interfaces, routes, queries, transaction ownership, nil results, existing closing semantics and external side-effect timing. Keep already-small service wrappers unchanged.
- Add isolated HTTP/SQL characterization tests; enforce SQL expectations and environment cleanup.
- Verification: baseline and original-source overlay tests passed; final race-enabled suite passed (83 top-level tests); build, vet and diff whitespace checks passed. Independent static review found no actionable issues.
- No Git mutation, database operation, application startup or deployment. Runtime integration and Go 1.23-specific execution remain unverified.
- See [implementation and verification report](../docs/refactoring/sales-service-refactor.md).


## 2026-09-25 — `feat: add /hello endpoint returning Hello World JSON`

- **Added `/hello` Endpoint in [app/router.go](../app/router.go)**:
  - Added HTTP GET `/hello` endpoint returning JSON response `{"message": "hello world"}`.
- **Added Unit Test in [test/app_test.go](../test/app_test.go)**:
  - Verified endpoint response status `200 OK` and JSON body `{"message": "hello world"}`.
- **Verification**:
  - `go test -v ./test -run TestNewRouter`: PASS
  - `go test ./...`: PASS

## 2026-09-24 — `fix: restore original MORSES Excel sheet structure and column layout for Top 50, Stock, and MCL`

- **Restored MORSES Excel Report Structure in [helper/sales_ff_excel.go](file:///home/maki/PORTABEL/MICROSERVICE%20(COPY)/mf-micro-service-sales/helper/sales_ff_excel.go)**:
  - **Top 50**: Restored multi-sheet per sector generation (`Top 50 <Sektor>`) with dynamic period pivot columns (`outlet_name`, periods..., `DELTA LM`, `DELTA MAX`, and `asm`/`fsm` for all-area).
  - **Stock Product & Stock Product ED < 1 Tahun**: Restored original column sequence (`product_id`, `product_name`, `qty_sales_*`, `qty_stock_*`, `branch_distributor`, and trailing `asm`/`fsm` if `isAllArea`) with green header styling and tab color (`#92D050`).
  - **MCL User Team**: Restored sheet name `Mcl User Team` and original headers/structure with orange tab color (`#FFA500`).
  - **Sales Vs Target**: Preserved ON/OFF breakdown variant headers, and merged `total_netbyu` header (`R1:R2`) removing the `(p+q)` sub-header text.
  - **Workbook Tab Colors**: Re-applied exact tab colors via `writeExcelWithTabColors`.
- **Verification**:
  - `go build ./...`: SUCCESS
  - `go test -v ./test -run TestHelperUtils`: ALL PASS

## 2026-09-24 — `Merge branch 'add_filter_deleted_at' into refactor/clean-code-and-mysql-perf`

- **Resolved Merge Conflicts**:
  - Integrated `add_filter_deleted_at` changes into `refactor/clean-code-and-mysql-perf`.
  - In [app/router.go](file:///home/maki/PORTABEL/MICROSERVICE%20(COPY)/mf-micro-service-sales/app/router.go): Safely merged tracing disable logic when `APP_ENV=local` or collector URL is empty.
  - In [service/sales_ff_service_impl.go](file:///home/maki/PORTABEL/MICROSERVICE%20(COPY)/mf-micro-service-sales/service/sales_ff_service_impl.go): Preserved clean service layer by routing MORSES report email dispatching through [helper/sales_ff_email.go](file:///home/maki/PORTABEL/MICROSERVICE%20(COPY)/mf-micro-service-sales/helper/sales_ff_email.go).
  - In [helper/sales_ff_excel.go](file:///home/maki/PORTABEL/MICROSERVICE%20(COPY)/mf-micro-service-sales/helper/sales_ff_excel.go): Integrated updated multi-row merged headers and On/Off columns (`SalesMin3On`, `SalesMin3Off`, `SalesNOn`, `SalesNOff`, etc.) for target report sheet.
  - In [test/helper_test.go](file:///home/maki/PORTABEL/MICROSERVICE%20(COPY)/mf-micro-service-sales/test/helper_test.go): Updated mock structs to match new domain fields.
- **Verification**:
  - `go build ./...`: SUCCESS
  - `go test -v ./test/...`: ALL PASS

## 2026-09-22 — `perf: optimize MySQL connection pool, harden transaction rollback to prevent blocking, and configure slow query logging`

- **Configured Production Connection Pool in [app/database.go](../app/database.go)**:
  - Configured `sqlDB.SetMaxIdleConns(10)` to keep idle connections ready for immediate reuse and avoid constant TCP connection churn (buka-tutup koneksi berulang).
  - Configured `sqlDB.SetMaxOpenConns(100)` to prevent connection pool exhaustion and avoid overloading the MySQL server during traffic bursts.
  - Configured `sqlDB.SetConnMaxLifetime(1 * time.Hour)` to automatically refresh connections before MySQL `wait_timeout` drops them.
  - Configured `sqlDB.SetConnMaxIdleTime(10 * time.Minute)` to reclaim unused idle connections.
- **Configured Slow Query Detection**:
  - Tuned GORM logger `SlowThreshold` to `200ms` with `logger.Warn` level in [app/database.go](../app/database.go) to automatically detect and log any query taking longer than 200ms.
- **Hardened Transaction Rollback & Query Unblocking in [helper/tx.go](../helper/tx.go)**:
  - Enhanced `helper.CommitOrRollback(tx)` to immediately rollback transactions on panic or when `tx.Error != nil`, releasing row/table locks without delay.
  - Standardized transaction handling in `TargetMarketingServiceImpl.Create` with `defer helper.CommitOrRollback(tx)` to eliminate partial transactions and dangling locks.
- **Verification & Quality Gates**:
  - `staticcheck ./...`: 0 issues
  - `gocritic check ./...`: 0 issues
  - `go test -race ./...`: PASS
  - Statement test coverage: **94.7%**

## 2026-09-22 — `docs: audit and list all 62 API endpoints, add dynamic test coverage synchronization to README and Makefile`

- **Comprehensive API Endpoint Audit & Documentation**:
  - Re-audited and cross-checked every single route across all 14 domain route definitions against actual controller and repository implementations.
  - Formatted and organized all 62 endpoints in [README.md](../README.md) across 7 clearly defined business domains:
    1. **Master Data Bridging**: 10 endpoints (5 Outlets, 5 Products).
    2. **Sales Field Force (`SalesFf`)**: 17 endpoints (Sales calculations, structure summaries, target/CN comparisons, sector breakdowns, closing workflows).
    3. **Sales Distributor & Stock Distributor**: 8 endpoints (Invoices, monitoring, PDU import, stock movements, and email reconciliation).
    4. **Sales Principal & Sales Share**: 8 endpoints (Principals, unregistered territory outlets, allocations, composite key share deletions).
    5. **Target Marketing**: 6 endpoints (Headers, details, CSV uploads, update/delete).
    6. **Distributor Extra Discount & Claims**: 6 endpoints (Agreements, calculation processing, claims submission & lifecycle).
    7. **Work Calendar, Sales Out & Background Redis Jobs**: 7 endpoints (Calendar settings, sales out calculation, warehouse staging, Redis worker dispatch).
- **Dynamic Non-Hardcoded Test Coverage Synchronization**:
  - Created [scripts/update_coverage.py](../scripts/update_coverage.py) to parse `coverage.out` and dynamically synchronize:
    - Top shields.io Coverage badge (e.g. `94.9%`, `brightgreen`).
    - Code coverage and quality metrics table in Section 7 of [README.md](../README.md).
  - Integrated `scripts/update_coverage.py` into [Makefile](../Makefile) targets (`make cov`, `make cover`, `make update-cov`, `make check-cov`).

- **Relocated Email & Excel Generation Utilities from Service to Helper Layer**:
  - Moved stock distributor evaluation and stock-vs-sales email dispatchers and Excel builders from `service/` to [helper/stock_distributor_email.go](../helper/stock_distributor_email.go).
  - Extracted Rupiah currency formatter into [helper/format_rupiah.go](../helper/format_rupiah.go).
  - Extracted MORSES multi-sheet report Excel workbook builder and string helpers into [helper/sales_ff_excel.go](../helper/sales_ff_excel.go).
  - Extracted multipart email client and ASM/HO reporting dispatchers into [helper/sales_ff_email.go](../helper/sales_ff_email.go).
- **Extracted External API HTTP Callers to Helper Layer**:
  - Extracted external PDU API request from `SalesDistributorServiceImpl` into [helper/sales_pdu.go](../helper/sales_pdu.go).
  - Extracted warehouse target marketing sync API request from `TargetMarketingServiceImpl` into [helper/warehouse_sync.go](../helper/warehouse_sync.go).
- **Audited and Enforced Service Layer Invariants**:
  - Audited all 28 service files across the repository to ensure strict adherence to clean architecture: `service/` contains only service interfaces (`*_service.go`) and implementations (`*_service_impl.go`) responsible for business orchestration, transaction lifecycle, and validation.
  - Eliminated raw HTML generation, Excel sheet manipulation (`excelize`), and low-level HTTP transport logic from all service implementations.
- **Verification & Quality Gates**:
  - `go test -race ./...` (PASS)
  - `staticcheck ./...` (0 issues)
  - `gocritic check ./...` (0 issues)
  - Statement test coverage: **95.5%**

## 2026-09-22 — `fix: enhance error handling, reduce internal server errors, and provide clear user-facing error explanations`

- **Reclassified Client-Originating Errors from HTTP 500 to HTTP 400 Bad Request**:
  - **String Panics**: Intercepts `string` panics in [exception/error_handler.go](../exception/error_handler.go) and returns HTTP 400 Bad Request with the panic message as `webResponse.Message`.
  - **JSON Syntax & Unmarshal Type Errors**: Intercepts `*json.SyntaxError`, `*json.UnmarshalTypeError`, and `io.EOF` returning clear, descriptive messages (e.g. `Invalid value for field 'xyz': expected int, got string`, `Request body cannot be empty`, `Invalid JSON syntax at offset N`) instead of generic 500.
  - **Parameter Parse Errors**: Intercepts `*strconv.NumError` returning `Invalid numeric parameter '<val>': <err>` (HTTP 400).
  - **Filter Operator Errors**: Intercepts invalid query parameter operators (e.g. `operator symbol paramater is not valid`) returning `Invalid query filter: <err>` (HTTP 400).
  - **MySQL Field Length Exceeded**: Intercepts MySQL Error 1406 (`Data too long for column`) returning HTTP 400 Bad Request with field details.
- **Enhanced Internal Server Error (HTTP 500) Explanations**:
  - Modified `internalServerError` in [exception/error_handler.go](../exception/error_handler.go) to populate `webResponse.Data` with the actual stringified error detail (`err.Error()` / string details) rather than leaving it empty, allowing users, developers, and API consumers to immediately understand the exact failure cause.
- **Service Layer Panic Cleanup & Bounds Safety**:
  - Replaced raw string panics in [service/target_marketing_service_impl.go](../service/target_marketing_service_impl.go) (`panic("Failed to open the file")`, `panic("Failed to read the file")`) with structured `&exception.ErrorSendToResponse{}`.
  - Added slice bounds check (`len(productPrice) == 0`) before indexing in `TargetMarketingService.Update` to prevent runtime index out of range panics.
- **Expanded Test Suite**:
  - Added 8 comprehensive test cases in [test/error_handler_test.go](../test/error_handler_test.go) covering string panics, JSON syntax errors, unmarshal type mismatches, EOF empty bodies, invalid numeric params, data-too-long errors, query operator errors, and detailed 500 error responses.
  - Overall statement coverage increased to **93.7%** with 0 `staticcheck` / `gocritic` warnings.

## 2026-09-22 — `refactor: codebase-wide clean code refactoring, modularization, and safety hardening`

- **Modularization of God Objects**:
  - Decomposed 1,500+ line `sales_ff` service and repository into cohesive single-responsibility modules:
    - [service/sales_ff_analytics_service.go](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/service/sales_ff_analytics_service.go): analytics queries, calculations, sector/achievement processing.
    - [service/sales_ff_email_service.go](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/service/sales_ff_email_service.go): email generation, Morses / OTX reporting with safe attachment handling.
    - [service/stock_distributor_email.go](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/service/stock_distributor_email.go): evaluation and stock vs sales email distribution.
    - [repository/sales_ff_analytics_repository.go](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/repository/sales_ff_analytics_repository.go): analytics and summary queries.
    - [repository/sales_ff_processing_repository.go](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/repository/sales_ff_processing_repository.go): complex stored procedure and ETL execution (`sp_sales_ff`, `vw_sales_ff_to_wh`).
    - [repository/sales_ff_morses_repository.go](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/repository/sales_ff_morses_repository.go): Morses ASM / SM reporting queries.
    - [helper/sales_ff_excel.go](../helper/sales_ff_excel.go): Excel generation utilities (`excelize/v2`).
    - [model/domain/sales_ff_mapper.go](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/model/domain/sales_ff_mapper.go): domain-to-web response mappers.
- **Safety, Nil-Check, and Pointer Bug Fixes**:
  - Fixed pointer value equality check bugs in `SalesPrincipalService.ProcessCloseOpen` and `SalesFfService.ProcessCloseOpen` (changed `ptr1 == ptr2` address comparison to safe dereferenced comparison `ptr1 != nil && ptr2 != nil && *ptr1 == *ptr2`).
  - Fixed transaction propagation bug in `SalesOutWhService.ProcessToSalesOutWh` by properly passing active `tx` instead of global `service.DB`.
  - Added defensive nil and empty checks for `filters` across all repositories and helpers ([helper/apply_filter.go](../helper/apply_filter.go), `SalesPrincipalRepositoryImpl`, `SalesDistributorRepositoryImpl`, `SalesShareRepositoryImpl`).
  - Fixed non-pointer struct passed to GORM `.Find(sales)` in `SalesDistributorRepositoryImpl.FindClosed` and added method to `SalesDistributorRepository` interface.
  - Hardened [helper/history.go](../helper/history.go) reflection logic against nil pointer dereferences and eliminated `reflect.Value` serialization leaks.
- **Performance & Pre-allocation**:
  - Precompiled all regular expressions as package-level variables in [helper/custom_validator.go](../helper/custom_validator.go) for ~100x faster validation without per-request recompilation allocations.
  - Replaced $O(N \times M)$ linear searches with $O(1)$ hash map lookup (`priceMap`) in `TargetMarketingService.Create`.
  - Pre-allocated response slices across all domain models in `model/domain/`.
  - Added 60s timeout to `http.Client` in `SalesDistributorService.ProcessSalesPdu`.
- **Clean Code & Architecture Invariants**:
  - Replaced ad-hoc repository instantiations in `DistributorExtraDiscountClaimService` with injected `DistributorExtraDiscountRepository`.
  - Cleaned up naming conventions (struct names, receiver names, unused strings hacks, copy-pasted comments).
  - Maintained 100% API contract, route, and GORM query compatibility.
  - Quality gates verified: `staticcheck ./...` (0 issues), `gocritic check ./...` (0 issues), `go test -race ./...` (PASS), coverage **93.1%** (`make check-cov`).

## 2026-09-21 — `ci: disable development deployment job for SKI-TL in gitlab-ci`

- Commented out `Deploy Development SKI-TL` job in [.gitlab-ci.yml](../.gitlab-ci.yml) to streamline development stage pipeline execution.

## 2026-09-21 — `docs: sanitize confidential company and database references in README`

- Sanitized [README.md](../README.md) by removing confidential company names, container identifiers, and specific database names (`SKI_MF_PROD`, `SKI_TL_PROD`, `COMPANY=mf`, `COMPANY=tl`).
- Registered `JobRedisRoute` in [app/router.go](../app/router.go) ensuring complete router alignment.
- Verified all 56 API endpoints and confirmed full test coverage (**90.0%**).

## 2026-09-21 — `build: lock go version to 1.23 in go.mod for gitlab ci runner compatibility`

- Locked Go toolchain and module language version to `go 1.23` in [go.mod](../go.mod) and downgraded `github.com/gin-contrib/gzip` to `v0.0.6` to ensure full compatibility with GitLab CI `golang:1.23` runner and prevent `go: go.mod requires go >= 1.25.0` build failures.
- Verified all quality gates, staticcheck, gocritic, and unit tests pass with **90.0% statement coverage** (`make check`).

## 2026-09-21 — `perf: optimize api latency with gzip compression and pre-allocated slice mapping`

- Integrated `github.com/gin-contrib/gzip` middleware in [app/router.go](../app/router.go) to compress high-volume HTTP responses (reducing payload size for `/sales-ffs` by ~92% from 4.48 MB to ~350 KB with zero contract changes).
- Replaced dynamic slice `append` loops with pre-allocated `make([]T, len(src))` in domain response converters in [model/domain/sales_ff.go](../model/domain/sales_ff.go) and [model/domain/sales_principal.go](../model/domain/sales_principal.go), reducing heap reallocations during large dataset transformations.
- Removed unnecessary `service.DB.Begin()` transaction wraps for read-only queries (`FindAll`, `FindProduct`, `FindReport`) in [service/sales_ff_service_impl.go](../service/sales_ff_service_impl.go) and updated unit test expectations in [test/service_test.go](../test/service_test.go).
- Maintained **90.0% statement coverage** (`make check-cov`) and verified 100% data contract compatibility.

## 2026-09-21 — `fix: ensure jwt token verification error checking and test auth secret fallback`

- Fixed `VerifyToken` and `ExtractTokenMetadata` in [auth/auth.go](../auth/auth.go) to properly evaluate `jwt.Parse` errors and validate token claims, avoiding nil pointer dereferences on invalid tokens.
- Added default secret fallback and explicit test environment variable setting in [test/auth_test.go](../test/auth_test.go) for fully isolated CI test runner execution.
- Verified test suite passes (`make check-all` and `make check-cov`) with **90.0% statement coverage**.

## 2026-09-21 — `fix: decouple config loading and tracer initialization from local .env presence`

- Updated [configuration/configuration.go](../configuration/configuration.go) to bind all environment variables with `viper.BindEnv` and gracefully handle missing local `.env` files, allowing seamless configuration via CI/Docker/Kubernetes environment variables without requiring a `.env` file on disk.
- Updated `initTracer` in [app/router.go](../app/router.go) to safely handle empty collector URLs or OTLP initialization failures without calling `log.Fatal` / crashing tests or services.
- Replaced `log.Fatalln` calls in [auth/auth.go](../auth/auth.go), [helper/etl_to_mssql.go](../helper/etl_to_mssql.go), [helper/validate_closing.go](../helper/validate_closing.go), [service/stock_distributor_service_impl.go](../service/stock_distributor_service_impl.go), and [service/sales_ff_service_impl.go](../service/sales_ff_service_impl.go) with appropriate error propagation and structured panic handlers (`exception.ErrorSendToResponse`).
- Added environment variable unmarshaling test cases in [test/configuration_test.go](../test/configuration_test.go).
- Verified full test suite passes with **90.1% statement coverage** (`make check-cov`).

## 2026-09-21 — `test: audit unit test filesystem safety and refine temporary file cleanup`

- Audited all unit test files in `test/` for filesystem safety and side effects.
- Refined temporary hierarchy CSV test cleanup in [test/service_test.go](../test/service_test.go) (`FindReportHeader`) to specifically remove only the created test file (`file/hierarchy/1.csv`) and directory (`file/hierarchy`), preventing any recursive directory deletion (`os.RemoveAll`).
- Confirmed all tests use `go-sqlmock` (zero real database mutations) and isolated temporary mock servers.
- Verified test suite passes (`make check-cov`) with **90.3% statement coverage**.

## 2026-09-20 — `docs: update README with architecture overview, setup guide, and quality gates`

- Updated [README.md](../README.md) with comprehensive documentation including service capabilities, architecture overview, environment configuration, local development guide, quality gate commands, and Docker deployment steps.
- Converted `Url` and `UrlPdu` in [helper/file_path.go](../helper/file_path.go) from `const` to `var` to enable mocking in isolated unit tests.
- Fixed SQL mock expectations and parameter alignments in [test/service_test.go](../test/service_test.go) across `DistributorExtraDiscountClaimService`, `SalesFfService`, `SalesPrincipalService`, `TargetMarketingService`, and `SalesShareService`.
- Added missing error check in [service/target_marketing_service_impl.go](../service/target_marketing_service_impl.go) after `TargetMarketingRepository.Create`.
- Fixed coverage percentage parser in [Makefile](../Makefile).

## 2026-09-20 — `ci: configure gitlab-ci quality gate, gocritic, coverage checks, and cspell settings`

- Added CI quality gate stage in [.gitlab-ci.yml](../.gitlab-ci.yml) with Go module verification, `go vet`, `gocritic`, and coverage enforcement (`make check-cov`).
- Configured gocritic in [Dockerfile](../Dockerfile), added coverage threshold verification targets (`check-cov`, `check-all`, `check`) and automated cspell runner in [Makefile](../Makefile).
- Updated `.cspell/configuration.json` ignore paths and expanded `.cspell/custom.txt` custom dictionary.

## 2026-09-20 — `test: expand test coverage >= 90% and add edge cases across domain packages`

- Expanded unit test coverage across all domain packages in `test/` ([test/auth_test.go](../test/auth_test.go), [test/helper_test.go](../test/helper_test.go), [test/repository_test.go](../test/repository_test.go), [test/service_test.go](../test/service_test.go)).
- Relocated and consolidated all unit tests into the dedicated `test/` package (`package test`), decoupling test runner logic from production business packages.
- Exported helper utilities in `service/` (`ToExcelColumnName`, `SanitizeSheetName`, `ToTitleCase`, `FormatRupiah`) to permit direct invocation from `package test`.
- Removed old distributed `*_test.go` files from source directories.
- Verified statement test coverage increased to **90.3%** across all packages (`make check-cov`).

## 2026-09-20 — `sec: backend security review and concurrency race condition fixes`

- Created comprehensive security audit report in [SECURITY_REVIEW.md](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/SECURITY_REVIEW.md) covering trust boundaries, threat models, CWE classifications, and remediation roadmaps.
- Audited JWT authentication (`auth/auth.go`), dynamic query filter construction (`helper/apply_filter.go`), raw CTE string interpolations (`repository/sales_ff_repository_impl.go`), and CSV upload handlers (`service/target_marketing_service_impl.go`).
- Fixed concurrency data race in [configuration/configuration.go](../configuration/configuration.go) by instantiating local `viper.New()` instances during `LoadConfig()`, verified with `go test -race ./...`.

## 2026-09-19 — `feat: optimize database queries, batch lookups, and parameter handling across repository and service layers`

- Optimized database queries, batch lookups, and parameter handling across repository and service layers.
- Added public ID scope filtering helper and updated router configuration.
- Enhanced query reliability, sanitized query string inputs, and prevented redundant full-table scans.
- Aligned production database columns with Go domain structs in `model/domain/` (`SalesPrincipal`, `SalesShare`, `SalesFf`, `SalesDistributor`, `DistributorExtraDiscount`).

## 2026-09-19 — `test: add comprehensive test suites and agent architecture documentation`

- Added comprehensive unit test suites across controllers, services, repositories, helpers, auth, and router layers using `go-sqlmock` and `testify`.
- Added repository engineering documentation, task-to-skill routing, and architecture guidelines under `.agent/` and [AGENTS.md](../AGENTS.md).
- Added test database helpers and mock implementations under `test/`.

## Existing baseline — 2026-09-19

- Added repository AI engineering system guidelines and task-specific skills under `.agent/`.
- Consolidated repository tests and added architecture references.

## 2026-09-27 — Evidence-first guidance rollout

- Unified selective entry points and CLAUDE imports; linked workspace data-first and environment/confirmation rules.
- Added maintenance guidance, current source/test inventory and explicit evidence limits.
- Clarified compatibility exceptions and requested-test policy over inherited blanket rules; retained detailed historical topics.
- Documentation only: no application source, dependency, runtime or database changes; no tests/build/startup performed.

## 2026-09-27 — `docs: improve AI agent guidance`

- Added selective task entry points, shared workspace data-first and database environment rules, and Claude Code guidance.
- Recorded repository-specific evidence/limits and current testing inventory; clarified that historical assertions are not current verification.
- Preserved existing source and user changes; documentation only.
