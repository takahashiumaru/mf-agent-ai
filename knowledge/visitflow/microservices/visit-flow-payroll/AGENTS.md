# VisitFlow Payroll — Agent Guide

## Start here

This repository owns payroll PDF retrieval/counts, IMAP attachment ingestion, and email/Telegram OTP. Run Go/Git commands here, not in the parent workspace.

1. Read the [workspace guide](../AGENTS.md) for shared skills, evidence requirements, default read-only target and concrete DEV-mutation approval rules. Reuse session authorization; never copy credentials here.
2. Use [.agent/INDEX.md](.agent/INDEX.md) to select the task's skills and references. Read only the affected scope.
3. Trace current code, tests and relevant schema/external dependencies before changing behavior. Documentation and badges are not proof of deployment or current test success.

User/runtime instructions take precedence. Local documents supplement the workspace: this file owns mandatory rules, INDEX owns navigation, topic documents explain details, QUALITY_GATES owns completion checks. Report discrepancies with code instead of silently changing the API to match prose.

## Read efficiently, preserve accuracy

Reuse guidance already read in this session unless it changed. Select one task path in INDEX, load applicable skills, and read detailed reference sections only when they resolve a concrete question. Expand for interfaces, data integrity, auth or uncertainty; never skip a required check to save tokens. Optional flow maps and historical reports are not startup reading.

## Local boundaries and rules

- The active payroll flow is file/external-I/O based; there is no local repository layer. `main.go` does not initialize a payroll database. GORM dependencies/helpers alone do not prove DB-backed payroll persistence.
- Keep PDF byte responses distinct from JSON list/count/OTP envelopes. Preserve period parsing, filename behavior, null/empty collections and error mapping unless intentionally changed.
- `FindFile` does not check OTP. OTP endpoints and ingestion are not wrapped by `auth.Auth` in the current route file; the auth wrapper bypasses JWT for allowlisted client IPs and supplies empty access details; other clients undergo JWT checks, while role enforcement is commented out. These are observed limitations, not authorization policy to copy or silently change.
- Payroll files, mailbox contents, addresses, OTPs and integration credentials are sensitive. Use synthetic fixtures and temporary directories; never copy real payslips into tests, docs or logs.
- IMAP ingestion can write files; OTP issuance sends email/Telegram messages and changes token state. Do not invoke live endpoints as a smoke test. Use isolated fakes; obtain concrete authorization for external side effects.
- For path changes, verify containment, traversal, period/NIP/owner scope and overwrite behavior. For OTP changes, trace generation/storage/expiry/retry/consumption/concurrency; do not infer download protection from token validation.
- File writes, email and Telegram cannot be rolled back using a SQL transaction. Separate pure parsing from external operations when a scoped change needs testability; do not introduce an unrelated repository layer.

## Shared engineering invariants

- Keep HTTP parsing/envelopes in controllers and business orchestration in services; persistence belongs in the existing persistence layer when one exists. Preserve manual route wiring and meaningful interfaces.
- Preserve JSON names/types, null versus zero, empty arrays, ordering, status codes, validation, and error identity unless the requested change includes them.
- Carry request context into DB/network work; never retain Gin context in background tasks. Check meaningful errors, including finalization. Keep background work bounded and observable without sensitive payloads.
- Preserve legacy panic/middleware/rollback compatibility. New internal functions may return errors, but callers must propagate them through the established boundary. Do not partially migrate or swallow errors.
- Atomic writes and dependent reads share a writer transaction. Check zero-value updates, not-found semantics, tenant scope and affected rows. Success notifications follow successful persistence.
- Bound queries and batches; check joins/counts, N+1, indexes and external calls. Performance claims require measured evidence or an explicit uncertainty.
- Preserve existing user changes. Choose the smallest coherent fix; do not add frameworks, schema migrations or broad rewrites for a local task.
- Code authorization does not authorize live DB mutations or external messages. Follow workspace rules and use synthetic fixtures for tests.

## Work sequence and evidence

`Understand → inspect → plan → implement → verify → review`

For implementation, state current/desired behavior, affected callers, data/response invariants, external effects and checks, then proceed within authorization. Analysis-only requests stop after findings. Ask only for material missing decisions or required concrete approvals.

Use [PREFERRED_PATTERNS](.agent/PREFERRED_PATTERNS.md) for scoped examples, [TESTING](.agent/TESTING.md) for facilities/commands, and [QUALITY_GATES](.agent/QUALITY_GATES.md) before claiming completion. Documentation-only edits need path/consistency/scenario checks, not unrelated application tests.

Report changes, actual verification, intentional behavior differences and material gaps. Dependencies come from `go.mod`; targets from `Makefile`; current CI rules from `.gitlab-ci.yml`. Recheck these rather than repeating historical claims.

## Commit policy

Do not commit/push without session authorization. When an authorized commit is created, include a concise dated entry in `.agent/CHANGELOG.md` describing that commit. The changelog is history, not mandatory startup reading. Do not add application-change entries for routine uncommitted work.
