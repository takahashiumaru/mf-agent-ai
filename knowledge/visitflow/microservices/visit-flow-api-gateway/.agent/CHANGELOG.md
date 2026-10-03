## Riwayat Commit

## 2026-09-27 — `test: keep helper and email tests local`

+- Move helper response assertions beside the helper package.
- Exercise sender formats with a test-only local SMTP server instead of assuming an external port is closed.

## 2026-09-27 — `refactor: move file utilities to helper`

- Move slow endpoint parsing and user image upload mechanics into focused helper files while preserving service workflow behavior.
- Add characterization tests and document execution/verification.

## 2026-09-27 — `refactor: isolate user workflow effects`

- Add per-instance user effects for FCM and active-token cache while preserving the existing constructor and service struct layout.
- Strengthen login/session regression coverage and document the package design decisions and verification results.

## 2026-09-27 — `refactor: clean up gateway service code`

- Split user service responsibilities into focused profile, password, login, and session files while preserving existing behavior.
- Extract the slow endpoint parser, clarify role service naming, and add regression coverage under `test/` with the refactoring plan.
- Verify the full quality gate with 95.3% statement coverage.

## 2026-09-27 — `docs: improve AI agent guidance and verification`

- Clarified gateway-specific routes, local identity API guidance, and quality gates.
- Added flow navigation and reusable preferred-pattern and quality-gate references.


## 2026-09-22 — `fix: downgrade go-redis to v9.7.0 to maintain Go 1.23 compatibility`

- Downgraded `github.com/redis/go-redis/v9` from `v9.22.0` to `v9.7.0` to maintain strict compatibility with Go 1.23.
- Locked `go.mod` directive to `go 1.23` without requiring Go 1.24 upgrade on GitLab CI runners or Docker containers.

## 2026-09-21 — `perf: implement redis caching for fast login and optimize db connection pooling`

- Added Redis client initialization with in-code defaults and graceful fallback to MySQL direct query when offline/unreachable.
- Integrated Redis cache into `UserRepositoryImpl.JoinUserAndStructure` and `JoinUserAndStructureMR` to eliminate multi-second recursive SQL queries (`WITH RECURSIVE`) on login.
- Added Redis active token caching in `auth.ExtractTokenMetadata` and tuned MySQL `sql.DB` connection pool (`MaxIdleConns: 10`, `MaxOpenConns: 50`).

## 2026-09-20 — `fix: support env fallback in loadconfig, add login route aliases, and harden ip block middleware`

- Enhanced `configuration.LoadConfig()` to automatically fall back to OS/container environment variables and gracefully handle missing `.env` files in CI/CD runners and containers.
- Added route aliases `/login` and `/verify-password` to `route.UserRoute` to prevent 404s when clients call alternate auth paths, and updated `BlockIPMiddleware` to respond with `403 Forbidden` JSON.
- Updated misc coverage tests to be hermetic using `t.TempDir()` and `t.Setenv()`, added `configuration/.env.example`, and updated cspell ignore patterns.

## 2026-09-20 — `docs: add comprehensive project README with architecture, endpoints, and local guide`

- Added comprehensive `README.md` covering dual runtime roles (KrakenD & Gin IAM), system architecture diagram, directory tree, API endpoint reference, environment configurations, local development workflow, quality gates, and Docker deployment guide.

## 2026-09-20 — `docs: enforce mandatory changelog update on every commit and push`

- Updated AGENTS.md to strictly mandate that every commit/push must include an entry in CHANGELOG.md with exact commit date and message.

## 2026-09-20 — `docs: clean up header in agent changelog`

- Removed instructional rules and format boilerplate from CHANGELOG.md to keep the history concise and focused.

## 2026-09-20 — `ci: add test and quality gate pipeline, update Dockerfile checks, and configure cspell`

- Added CI/CD `Test & Quality Gate` stage in `.gitlab-ci.yml` covering module verification, go vet, gocritic, and coverage threshold checks.
- Enabled gocritic and formatting checks in `Dockerfile`, and added `check-cov`, `check-all`, and `cspell` targets in `Makefile`.
- Configured `.cspell/configuration.json` ignore paths and added project domain vocabulary and localization terms to `.cspell/custom.txt`.

## 2026-09-19 — `test: expand unit test coverage across routes, repositories, controllers, and services`

- Added unit test suites for repositories, controllers, routes, auth, and services using sqlmock and mock repositories.
- Added Makefile for standard project workflows (test, cover, fmt, run).
- Removed untracked binary artifacts and updated .gitignore.
