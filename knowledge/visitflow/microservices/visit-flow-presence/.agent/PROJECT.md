# Project

## Project Purpose

`visit-flow-presence` is an HTTP backend for workforce presence and time-related workflows. It records office attendance, produces attendance and lateness reports, manages office/work-hour assignments and calendars, manages leave categories/periods/quotas/requests, processes attendance corrections, and creates meetings with members and approvals.

Evidence: route registration in `app/router.go` and the domain-specific files under `route/`, `service/`, and `model/domain/`.

## Main Responsibilities

- Presence check-in/check-out records and monthly/reporting queries (`presence_*`).
- Office records and employee-to-office assignments (`office_*`).
- Work-hour definitions and user assignments (`work_hour_*`).
- Company calendars and calendar regeneration (`calendar_*`).
- Leave categories, periods, configured quota categories, generated user quotas, leave requests, approval/rejection/cancellation, and reports (`leave_*`).
- Attendance correction requests with boss/HR approval and presence synchronization (`attendance_correction_*`).
- Meeting creation and meeting-member check-in/out (`meeting_*`).
- Request logging and log retrieval (`helper/logger.go`, `controller/log_controller_impl.go`).

## Main Modules

The project is organized by technical layer, so a business module spans directories. Common stems are `presence`, `office`, `office_user`, `calendar`, `work_hour`, `work_hour_user`, `leave_category`, `leave_qouta_category` (existing spelling), `leave_quota`, `leave_period`, `leave`, `attendance_correction`, `meeting`, and `meeting_member`.

## External Systems

- MySQL primary and read replica, configured by `DB_DSN_SOURCE_1` and `DB_DSN_REPLICATION_1`; connection creation is delegated from `app/database.go` to `gitlab.com/VNEU/go-helper/helper`.
- `gitlab.com/VNEU/visit-flow-api-gateway`: shared user models and repository access.
- `gitlab.com/VNEU/visit-flow-go`: structures, approvals, configuration repositories, and approval logic.
- Firebase Cloud Messaging using `helper/service-account.json` (`helper/send_message.go`).
- HTTP email endpoints in `helper/send_message.go`.
- Local leave proof storage at `file/leave/` (`helper/path.go`); Docker mounts `/app/file`.
- OpenTelemetry instrumentation for GORM via `app/database.go`.
- No Redis or message broker usage was found.

## Entrypoints

- `main.go`: executable entrypoint; loads config, connects the DB, initializes logging and validation, builds the router, and starts `net/http`.
- `app/router.go`: application route aggregation and global Gin middleware.
- `app/database.go`: DB connection and GORM plugin setup.
- `route/*.go`: manual dependency wiring and endpoint registration.

## Configuration

`main.go` calls `go-helper` v0.5.9's `LoadConfig`, which loads `./configuration/.env` with godotenv/Viper. The values used here include port, source DSN, replica DSN, and debug mode. JWT verification independently reads `ACCESS_SECRET` from the process environment in `auth/auth.go`; loading the `.env` file makes it available.

There is also a local `configuration/configuration.go` and `helper/configuration.go`, but `main.go` uses the external `go-helper` loader. Treat these as coexisting/legacy configuration helpers; inspect callers before changing one.

The repository contains sensitive configuration artifacts. Never reproduce their values in logs, documentation, tests, or responses. Deployment replaces `configuration/.env` through `.gitlab-ci.yml` before running `deploy.sh`.
