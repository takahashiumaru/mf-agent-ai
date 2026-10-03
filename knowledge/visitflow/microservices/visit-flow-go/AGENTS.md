# VisitFlow Core — Agent Guide

## Start here

This repository owns visits/planning/realization, customers and locations, organization, approvals, recommendations, and reporting. The parent workspace is not a Go module. Run Go/Git commands in this repository.

1. Read the [workspace guide](../AGENTS.md) for task routing, evidence requirements, selected database access, and mutation approval rules. Reuse session authorization; do not copy credentials here.
2. Choose the relevant task in [.agent/INDEX.md](.agent/INDEX.md). Load only its skills and references.
3. Trace the affected code and tests before changing behavior. Current source and verified runtime/schema facts take precedence over dated descriptions of implementation.

User instructions and runtime/system policies take precedence. Within these repository documents, use this file for mandatory local rules, `INDEX.md` for navigation, topic documents for explanations, and `QUALITY_GATES.md` for completion checks. Local guidance supplements the workspace rules; it cannot relax database approval or secret handling. If documents disagree with code, report the mismatch and verify it; do not silently change the API to match prose.

## Read efficiently, preserve accuracy

Reuse guidance already read in this session unless it changed. Select one task path in INDEX, load applicable skills, and read detailed reference sections only when they resolve a concrete question. Expand for interfaces, data integrity, auth or uncertainty; never skip a required check to save tokens. Optional flow maps and historical reports are not startup reading.

## Repository map

| Path | Responsibility |
| --- | --- |
| `main.go`, `app/` | Startup, database bootstrap, central route registration |
| `route/` | Route registration and constructor wiring |
| `controller/` | HTTP parsing and response envelope |
| `service/` | Business rules, transaction ownership, orchestration |
| `repository/` | GORM/MySQL queries using the caller's DB handle |
| `model/domain/` | GORM models and response mappers |
| `model/web/` | Request/response DTOs |
| `auth/`, `helper/` | Authentication, filters, errors, external integrations |
| `test/` | Cross-package tests and handwritten mocks; some tests remain package-local |
| `.agent/` | Task guidance; `.agent/skills/` contains service-specific skills |

Shared VisitFlow skills remain in the workspace `.agents/skills/`. Do not duplicate them here. Dependency versions come from `go.mod`; executable targets come from `Makefile`. `README.md`, diagrams, schema snapshots, and historical reports are navigation aids, not proof of deployed behavior.

## Mandatory implementation rules

- Keep transport in controllers, business decisions/transaction ownership in services, and SQL in repositories. Preserve existing interface/implementation files and manual route wiring.
- Reuse GORM-aware domain models and web DTOs. Preserve JSON keys/types, null versus zero, `[]` versus `null`, ordering, status codes, validation, and error mapping unless the requested change explicitly includes them.
- Carry request cancellation to DB/network operations. Existing APIs accept `*gin.Context`; use `c.Request.Context()` for standard-context APIs. Never retain Gin context in background work.
- Repositories use the passed transaction. Mutations and reads that must observe those mutations use the same writer transaction. Check begin, query, write, commit, and rollback errors; keep the original failure recognizable.
- The legacy resolver opens separate read/write transactions; read-handle finalization is unresolved. Do not treat the Company service or this helper as a new transaction template. See [transaction guidance](.agent/PREFERRED_PATTERNS.md#transactions--preferred).
- Preserve existing panic-to-middleware and rollback boundaries in legacy chains. New internal functions can return errors, but their caller must propagate/translate them at the existing boundary; do not swallow errors or migrate one layer in isolation. See [error contract](.agent/ERROR_HANDLING.md).
- Check GORM `.Error`. Check `RowsAffected` when no-op versus success matters. `Updates(struct)` skips zero values; use explicit maps, pointers, or `Select` when the intended patch includes zero/false/empty/null.
- Preserve tenant/company, structure/subordinate, ownership, period, checkpoint, audit, and soft-delete rules. Route role lists alone do not prove authorization. Hard deletion needs explicit business intent.
- Bind SQL values; allowlist dynamic columns/operators/order. Review changed queries for N+1, join multiplication/counts, bounds, relevant indexes, and transaction duration. Performance claims need evidence.
- Keep avoidable external work outside transactions. Notify after successful commit where notification represents persisted success. Background work needs ownership, bounds, timeouts, and error handling.
- Preserve existing user changes. Keep changes scoped; do not introduce generic base layers, migrations, dependencies, or broad error/architecture rewrites for a local fix.
- Never expose credentials, tokens, service-account material, or sensitive rows. Follow the workspace's production-read and DEV-mutation rules; code-change authorization is not authorization to mutate a live database.

## Work sequence

`Understand → inspect → plan → implement → verify → review`

For implementation, identify the current/desired behavior, affected callers/layers, data and JSON invariants, transaction/external effects, and relevant tests. State a short plan and proceed within the authorized scope. Analysis-only requests stop after findings/recommendations. Ask only for missing decisions that materially affect correctness or require explicit authorization.

Use [PREFERRED_PATTERNS.md](.agent/PREFERRED_PATTERNS.md) for implementation choices and [WORKFLOWS.md](.agent/WORKFLOWS.md) for task recipes. Treat examples as scoped illustrations, not blanket approval of every line in a file. Preserve correctness, data integrity, security, and compatibility before optimizing or normalizing legacy code.

## Verification and final answer

[QUALITY_GATES.md](.agent/QUALITY_GATES.md) owns the completion checklist. [TESTING.md](.agent/TESTING.md) owns commands, test facilities, and their limitations. Apply checks proportional to the change; documentation-only edits need link/reference/consistency checks, not an application test run unless executable behavior changed.

Report what changed and why, actual checks/results, intentional API/data differences, and material unverified behavior. Cite file/line evidence. Never infer current test success from coverage badges or old reports, or claim SQL mocks prove live MySQL isolation/replication.

## Changelog and commits

`.agent/CHANGELOG.md` is history, not required reading for normal implementation. Record material engineering-guidance changes there under an explicitly uncommitted entry. Before an authorized commit/amend, include one concise changelog entry for that commit. Do not add entries for routine uncommitted application edits. Never infer permission to commit from this policy.
