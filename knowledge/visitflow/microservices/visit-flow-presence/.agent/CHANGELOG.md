## Riwayat Commit

## 2026-09-27 — `test: isolate leave files and remove duplicate mapper tests`

+- Run leave upload tests in temporary directories to avoid modifying repository fixtures.
- Keep mapper assertions in `model/domain` and remove duplicate or self-checking service tests.

## 2026-09-27 — `refactor: extract shared presence helpers`

- Extract shared CSV row iteration, Haversine distance calculation, and nullable Firebase token conversion into focused helper files.
- Preserve service ownership of assignment mapping, office policy, transaction flow, and notification timing; add regression tests and clarify package guidance.

## 2026-09-27 — `refactor: clarify presence service package design`

- Group service workflows, inject narrow dependencies, and isolate Pondasi transport in an internal package.
- Guard HRD approval state and prevent quota restoration before quota consumption.
- Update agent guidance, refactor plan, audit notes, and regression tests.

## 2026-09-27 — `refactor: organize presence services and strengthen regression coverage`

- Split service workflows into focused functions and preserve API response contracts.
- Add quota locking, transaction lifecycle, checkout response, and error-path regression coverage.
- Record audit findings and the next package/dependency refactor plan, including the unresolved HRD rejection quota risk.

## 2026-09-27 — `docs: improve AI agent guidance and verification`

- Clarified service boundaries, attendance flows, test guidance, and agent task routing.
- Added flow navigation and reusable preferred-pattern and quality-gate references.


## 2026-09-20 — `docs: add comprehensive README documentation`

- Added root `README.md` covering architecture, features, directory structure, API routes, environment configurations, local development instructions, testing/quality gates, and Docker setup.

## 2026-09-20 — `docs: update changelog and enforce commit changelog rules`

- Cleaned up CHANGELOG header and verified mandatory AI agent changelog update workflow.

## 2026-09-19 — `fix(ci): remove staticcheck in favor of native go vet and gocritic`

- Removed `staticcheck` from CI pipeline to eliminate iterator panic with Go 1.23 standard library.
- Retained `go mod verify`, `go vet`, `gocritic`, and unit test coverage checks.

## 2026-09-19 — `fix(ci): pin staticcheck to v0.4.3 compatible with Go 1.23`

- Pinned staticcheck to `v0.4.3` to resolve Go toolchain version incompatibility in CI runner.
- Streamlined `Test & Quality Gate` steps and output in `.gitlab-ci.yml`.

## 2026-09-19 — `fix(ci): delegate quality gate to make check-all and fix yaml parsing`

- Fixed GitLab CI YAML parsing error caused by unquoted colon in coverage grep command.
- Streamlined `Test & Quality Gate` stage in `.gitlab-ci.yml` to run `make check-all`.

## 2026-09-19 — `ci: add test and coverage quality gate to pipeline and resolve linter warnings`

- Added CI quality gate in `.gitlab-ci.yml` verifying test coverage (>= 70%), staticcheck, gocritic, and module integrity before deploy.
- Added `make check-cov` and `make check-all` targets and added npx fallback for `make cspell`.
- Fixed linter and static analysis warnings across controllers, services, repositories, and test files.

## 2026-09-19 — `feat: increase test coverage to 91.6% and clean up dead database migration code`

- Raised test statement coverage across services, repositories, controllers, helpers, and auth to 91.6%.
- Cleaned up commented-out database auto-migration and removed unused `RunSQLFromFile` helper.
- Added comprehensive unit tests and mock suites under `test/`.

## Existing baseline — 2026-09-19

- Added repository engineering documentation and task-to-skill routing under `.agent/`.
- Consolidated repository tests under `test/` and added Go, GORM, database, API, security, Docker, CI, and refactoring guidance.
