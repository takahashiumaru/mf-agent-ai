# Changelog

## 2026-09-27 — `refactor: move survey key formatting into helper`

- Centralized survey, customer, and customer-product key formatting in focused helper functions.
- Added fixed-date and empty-key tests while keeping business flow in the service package.
- Verified with focused and full Go tests, vet, build, and diff checks.

## 2026-09-27 — `refactor: clarify survey service package design`

- Documented package responsibilities, dependency direction, and current interface decisions.
- Decoupled the survey mapping helper from auth details and aligned customer-product repository filenames with their domain names.
- Verified with `go test ./...`, `go vet ./...`, and `go build ./...`.

## 2026-09-27 — `refactor: clean survey service code`

- Refactored service naming, mapping, and upsert flows while preserving existing behavior.
- Moved Go tests into `test/` and added behavior characterization and response coverage.
- Verified with `go test ./...`, `make cover` (95.4%), and `go vet ./...`.

## Riwayat Commit

## 2026-09-27 — `docs: improve AI agent guidance and verification`

- Consolidated agent guidance for survey APIs, persistence, security, and test workflows.
- Added flow navigation and a thin Claude Code adapter.


## 2026-09-23 — `fix: align docker-compose image name with local build tag in deploy.sh`

- Fixed image name in [docker-compose.yml](file:///Users/takahashiumaru/Documents/company-projects/visitflow/visit-flow-survey-location-go/docker-compose.yml) from `gitlab.com/vneu/visit-flow-survey-location-go:${TAG}` to `${CI_PROJECT_NAME}:${TAG}` (matching `visit-flow-go`).
- Resolves HTTP 403 error during deployment when `docker compose up -d` tried to pull from remote GitLab registry instead of using the locally built image.
- Commented out redundant `staticcheck` install in [Dockerfile](file:///Users/takahashiumaru/Documents/company-projects/visitflow/visit-flow-survey-location-go/Dockerfile) (matching `visit-flow-go`) to speed up Docker image builds during deployment.

## 2026-09-20 — `docs: update README with service overview, endpoints, and local setup guide`

- Updated [README.md](file:///Users/takahashiumaru/Documents/company-projects/visitflow/visit-flow-survey-location-go/README.md) with comprehensive documentation including service architecture, key features, directory layout, endpoint catalogue, environment variables, local development setup, testing commands, and Docker deployment.
- Updated [.cspell/custom.txt](file:///Users/takahashiumaru/Documents/company-projects/visitflow/visit-flow-survey-location-go/.cspell/custom.txt) with domain terminology to pass `make cspell` with 0 errors.

## 2026-09-20 — `docs: enforce mandatory changelog update in agent rules and workflows`

- Updated [AGENTS.md](file:///Users/takahashiumaru/Documents/company-projects/visitflow/visit-flow-survey-location-go/AGENTS.md) with mandatory rule requiring AI agents to update `.agent/CHANGELOG.md` before committing/pushing.
- Updated [.agent/WORKFLOWS.md](file:///Users/takahashiumaru/Documents/company-projects/visitflow/visit-flow-survey-location-go/.agent/WORKFLOWS.md), [.agent/QUALITY_GATES.md](file:///Users/takahashiumaru/Documents/company-projects/visitflow/visit-flow-survey-location-go/.agent/QUALITY_GATES.md), and [.agent/INDEX.md](file:///Users/takahashiumaru/Documents/company-projects/visitflow/visit-flow-survey-location-go/.agent/INDEX.md) to integrate the mandatory changelog update into the definition of done and commit/push workflow.

## 2026-09-20 — `fix: remove unused test helper and add test domain terms to cspell`

- Removed unused `newMockResolver` helper function from `test/test_db_helper_test.go` to resolve `staticcheck` unused code warning (U1000).
- Added domain-specific words (`Stok`, `Brosur`, `Promosi`, `Kebersihan`, `Sangat`, `Raya`, `invalidop`, `oscp`, `gertd`) to `.cspell/custom.txt` to make `make cspell` and `make check-all` pass with 0 errors.

## 2026-09-20 — `test: add comprehensive unit test suite across all layers with 94.4% statement coverage`

- Created full suite of unit tests under `test/`:
  - `test/auth_test.go`: JWT token extraction, metadata decoding, and Gin middleware authorization tests.
  - `test/controller_test.go`: HTTP handler unit tests for Distributor, Material, OutletSurvey, OutletSurveyCustomer, OutletSurveyCustomerProduct, and OutletSurveyQuestion controllers.
  - `test/service_test.go`: Business logic unit tests across all 6 service implementations with comprehensive mock repositories and validation flows.
  - `test/repository_test.go`: GORM sqlmock unit tests covering CRUD, query filtering, and complex custom join / reporting queries.
  - `test/helper_test.go`: Utility tests covering panic handlers, JSON readers/writers, query string parsers, slice lookup, and dynamic SQL filter builders.
  - `test/model_test.go`: Domain model to web response mapping tests and request model validations.
  - `test/router_test.go`: Gin router initialization and endpoint registration assertions.
  - `test/mocks_test.go` & `test/test_db_helper_test.go`: Test doubles, mock repositories, and sqlmock database helpers.
- Achieved **94.4% overall statement coverage**, easily exceeding the required 70.0% CI/CD quality gate threshold.

## 2026-09-20 — `ci: configure gitlab-ci quality gate, gocritic, coverage checks, and cspell settings`

- Added CI quality gate stage in `.gitlab-ci.yml` with Go module verification, `go vet`, `gocritic`, and coverage enforcement (`make check-cov`).
- Configured gocritic in Dockerfile, added coverage threshold verification targets (`check-cov`, `check-all`, `check`) and automated cspell runner in `Makefile`.
- Added `.cspell/configuration.json` ignore paths and custom dictionary in `.cspell/custom.txt`.
- Added Mermaid architecture and ERD diagrams in `visit-app-diagram/`.

## 2026-09-20 — `docs: add comprehensive AI agent architecture, skills, and engineering guidelines`

- Added root `AGENTS.md` and detailed `.agent/` architecture, database, API, quality gates, and testing references.
- Added 13 engineering skills under `.agent/skills/`.
- Fixed package import case collision in `service/outlet_survey_customer_product_service_impl.go`.
