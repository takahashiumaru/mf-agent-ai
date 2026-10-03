## Riwayat Commit

## 2026-09-27 — `test: isolate unit tests and verify request contracts`

+- Move request validation and JSON contract checks beside `model/web`; keep distance checks beside `helper`.
- Isolate CSV and FCM tests from local files and external delivery.

## 2026-09-27 — `docs(refactor): clarify regression audit chronology`

- Marked approval no-op results as pre-hardening and dated the package inventory to its analysis snapshot.

## 2026-09-27 — `docs(refactor): add package design and dependency plan`

- Added the Package Design/SOLID/Dependency Management plan and its regression audit, with repository-relative source links and clarified audit scope.

## 2026-09-27 — `docs(refactor): clarify Clean Code baseline audit`

- Documented all five sqlmock argument corrections and clarified when the audit results were recorded relative to Git operations.

## 2026-09-27 — `refactor(service): improve readability while preserving behavior`

- Extracted cohesive helpers from customer, location, visit, structure, product, HTML, file, and social service flows.
- Strengthened approval regression checks for persisted visit/approval state and transaction identity.

## 2026-09-27 — `docs: improve AI agent guidance and verification`

- Updated the canonical agent entry points, task routing, and testing guidance.
- Added flow navigation and a thin Claude Code adapter.

## 2026-09-21 — `perf(model): add idx_period_boss and idx_period_user composite index tags to Structure domain`

- Added `idx_period_boss` (period, boss_code) and `idx_period_user` (period, user_id) composite index tags on `Structure` domain model to reflect MySQL schema indexes.
- Updated `structure_cities_cache_test.go` sqlmock query matcher to be resilient against map iteration ordering.

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
