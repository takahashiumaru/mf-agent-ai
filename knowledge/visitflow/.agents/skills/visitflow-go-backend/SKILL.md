---
name: visitflow-go-backend
description: Use when implementing, fixing, reviewing, or refactoring Go code in VisitFlow core, presence, survey, gateway, or payroll services; for Q&A about existing endpoint behavior without edits, use visitflow-code-investigation.
---

# VisitFlow Go Backend

## Purpose

Make focused Go changes in the correct VisitFlow service without treating the five Go modules as one application. This skill belongs to the VisitFlow umbrella workspace outside the six service Git repositories. Read the repository's current instructions and source each time; this file is a navigation and reasoning guide, not a snapshot of the implementation.

## Locate the service

1. Find the requested feature under the current workspace. The backend is normally split into `visit-flow-go` (visits, customers, organization, reports), `visit-flow-presence` (attendance, leave, meetings), `visit-flow-survey-location-go` (outlet surveys), `visit-flow-api-gateway` (KrakenD proxy and Gin identity API), and `visit-flow-payroll` (PDF slips, IMAP, OTP).
2. If the current directory is a service, work there. If it is the umbrella `visitflow` directory, choose a child service before using Go or Git commands. The umbrella directory need not be a Go module or Git repository.
3. Read the selected service's `AGENTS.md` when present, followed by `.agent/INDEX.md` and only the relevant `.agent/skills/*/SKILL.md`. For payroll, inspect its `README.md`, `main.go`, route, controller, and service directly if an agent index is absent.
4. Locate the actual entrypoint and route registration. Gateway `configuration.json` describes proxy routes; its local Gin API runs separately. A gateway entry is not an implementation of downstream business logic.

## Trace a change

Follow `route → auth/middleware → controller → service → repository or external I/O → response`. For a feature that crosses modules, identify the owner of each write and the source of each imported model or repository. The common `route/`, `controller/`, `service/`, `repository/`, `model/domain/`, and `model/web/` packages are layers, not self-contained features.

Before editing, record:

- current and desired behavior, including error and status behavior;
- request and response shape, callers, and gateway mapping if the public API changes;
- database or filesystem side effects and transaction owner;
- company, structure, user, and period scope where data is involved;
- the nearest representative implementation and relevant local checks.

## Go implementation rules

- Preserve the service's dependency wiring and interfaces. Routes construct dependencies manually in the four GORM services. Payroll has no local repository layer for slip files.
- Keep HTTP parsing in controllers, business decisions in services, and persistence queries in repositories unless the existing module has a documented exception. Use `model/web` DTOs for API contracts and inspect `model/domain` mapping rather than inventing another persistence layer.
- Preserve the local error path. Several services deliberately propagate errors by panic to recovery middleware; changing one layer to a different error convention can alter HTTP behavior.
- Carry request context into database and external I/O. For work that must outlive a request, define a separate lifetime, timeout, owner, and bounded concurrency. Do not keep using `*gin.Context` after the response or launch unowned goroutines.
- Make network, Firebase, email, IMAP, Redis, and filesystem effects explicit. Do not assume they can roll back with MySQL.
- Keep existing JSON names, route spellings, and legacy identifiers such as `qouta` unless the task explicitly includes compatibility changes.
- Check the actual authorization path. Role slices passed to some `auth.Auth` wrappers are not enforced in current code. The gateway lets requests without an Authorization header continue to downstream handlers. Payroll OTP endpoints exist, but `FindFile` does not check OTP state; its auth wrapper also has an IP allowlist. Reconfirm these facts from source before relying on them.

## When to read another skill

- Use `visitflow-code-investigation` when the task is to explain existing code, validation, or an endpoint error without requesting a change.
- Use the `visitflow-gorm-mysql` skill for a GORM model, repository, transaction, schema, tenant filter, or multi-write change.
- Use the `visitflow-query-performance` skill for slow queries, N+1 behavior, indexes, pagination cost, or measurable database load.
- If the task is payroll file/IMAP/OTP behavior, trace `route/payroll_route.go`, `controller/payroll_controller_impl.go`, `service/payroll_service_impl.go`, and `helper/` before changing the flow.

## Completion note

Explain the changed service and path through the layers, the preserved API/data behavior, the relevant checks actually performed, and any remaining uncertainty. Do not claim current tests or coverage from a README badge. Follow the current session's testing instructions and the service's required quality gate.
