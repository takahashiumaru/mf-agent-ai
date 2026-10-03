# Changelog & AI Engineering Guidance History

All notable changes and commit history are documented in this file.

## Riwayat Commit

## 2026-09-27 — `docs: improve AI agent guidance`

- Added selective task entry points, shared workspace data-first and database environment rules, and Claude Code guidance.
- Recorded repository-specific evidence/limits and current testing inventory; clarified that historical assertions are not current verification.
- Preserved existing source and user changes; documentation only.


## 2026-09-22 — `docs: integrate live statement test coverage badge and auto-sync script in README`

- Added `scripts/update_coverage.py` to automatically compute exact statement test coverage from `coverage.out` and dynamically sync both shields.io badge and per-layer coverage table into `README.md`.
- Updated `Makefile` targets (`cov`, `cover`, `check-cov`, `update-cov`) to auto-sync coverage to `README.md` and enforce the 90.0% coverage quality gate.
- Verified complete 57 API endpoint inventory across 8 service modules in `README.md`.
- Added dedicated `Pengujian & Test Coverage` section in `README.md` with 97.6% overall statement coverage.

## 2026-09-22 — `ci: upgrade deploy runner base image to debian:latest`

- Updated `image: debian:bullseye-slim` to `image: debian:latest` across development and production deployment jobs in `.gitlab-ci.yml`, matching sibling SKI compliance microservices and resolving `openssh-client` 404 package fetch failures on Debian Bullseye repositories.

## 2026-09-21 — `docs: update API endpoint catalog in README to full English with complete route inventory`

- Updated `README.md` API Endpoint Catalog with full English descriptions, auth scopes, and complete inventory across all 8 modules (Marketing Structures, Positions, Areas, Territory Outlets, Territory Customers, Hierarchies, Offices, and Warehouse ETL).

## 2026-09-21 — `docs: document ultra-optimal MySQL database index architecture`

- Documented comprehensive MySQL index definitions across `marketing_structures`, `marketing_positions`, `marketing_structure_territory_*`, `marketing_structure_areas`, `histories`, and `hierarchies` in `.agent/DATABASE.md`.

## 2026-09-21 — `docs: remove root CHANGELOG.md and consolidate into .agent/CHANGELOG.md`

- Removed root `CHANGELOG.md` and consolidated all changelog tracking directly into `.agent/CHANGELOG.md`.

## 2026-09-21 — `ci: disable unused SKI-TL deployment jobs in gitlab-ci pipeline`

- Commented out `Deploy Development SKI-TL` and `Deploy Production SKI-TL` pipeline jobs in `.gitlab-ci.yml`.

## 2026-09-21 — `test: isolate unit tests from filesystem and protect configuration .env from reads or modifications`

- Enhanced `configuration.LoadConfig()` path resolution to automatically support root and sub-package working directories without adding any new environment variables.
- Added `test/main_test.go` with `TestMain` initializing in-memory Viper settings (`viper.Set(...)`).
- Removed all `os.MkdirAll("./configuration", ...)` and `os.WriteFile("./configuration/.env", ...)` calls across test suites (`route_app_test.go`, `exception_test.go`, `service_test.go`, `helper_test.go`).
- Refactored `TestHelper_FileAndSql` to use isolated OS temporary directory `t.TempDir()`, preventing any file deletion or modification in the repository.
- Made `FindAllByCsv` and `FindByCityCsv` resilient against missing/empty CSV files by auto-creating directories and returning safe defaults.
- Verified all unit test suites pass completely with zero side-effects on disk.

## 2026-09-20 — `docs: enforce mandatory commit changelog history and align cspell configuration`

- Established mandatory changelog update rule in `AGENTS.md` and `.agent/QUALITY_GATES.md` requiring every AI agent to log commit history under `## Riwayat Commit`.
- Created root `CHANGELOG.md` and aligned `.agent/CHANGELOG.md` with standard commit history format.
- Configured `.cspell/configuration.json`, `.cspell/custom.txt`, and `Makefile` for zero-warning spelling verification on Go source code and scripts.

## 2026-09-20 — `docs: update README with architecture overview, setup guide, and quality gates`

- Updated `README.md` with comprehensive documentation including service capabilities, architecture overview, environment configuration, local development guide, quality gate commands, and Docker deployment steps.

## 2026-09-20 — `ci: configure gitlab-ci quality gate, gocritic, coverage checks, and cspell settings`

- Added CI quality gate stage in `.gitlab-ci.yml` with Go module verification, `go vet`, `gocritic`, and coverage enforcement (`make check-cov`).
- Configured gocritic in Dockerfile, added coverage threshold verification targets (`check-cov`, `check-all`, `check`) and automated cspell runner in `Makefile`.
- Updated `.cspell/configuration.json` ignore paths and expanded `.cspell/custom.txt` custom dictionary.

## 2026-09-19 — `feat: optimize database queries, batch lookups, and parameter handling across repository and service layers`

- Optimized database queries, batch lookups, and parameter handling across repository and service layers.
- Added public ID scope filtering helper and updated router configuration.
- Enhanced query reliability, sanitized query string inputs, and prevented redundant full-table scans.

## 2026-09-19 — `test: add comprehensive test suites and agent architecture documentation`

- Added comprehensive unit test suites across controllers, services, repositories, helpers, auth, and router layers.
- Added repository engineering documentation, task-to-skill routing, and architecture guidelines under `.agent/` and `AGENTS.md`.
- Added test database helpers and mock implementations under `test/`.

## Existing baseline — 2026-09-19

- Added repository AI engineering system guidelines and task-specific skills under `.agent/`.
- Consolidated repository tests and added architecture references.

## 2026-09-27 — Evidence-first guidance rollout

- Unified selective entry points and CLAUDE imports; linked workspace data-first and environment/confirmation rules.
- Added maintenance guidance, current source/test inventory and explicit evidence limits.
- Clarified compatibility exceptions and requested-test policy over inherited blanket rules; retained detailed historical topics.
- Documentation only: no application source, dependency, runtime or database changes; no tests/build/startup performed.
