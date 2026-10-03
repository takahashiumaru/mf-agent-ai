# VisitFlow Presence — Agent Guide

## Start here

This repository owns attendance, offices, work hours, leave/quota, corrections and meetings. Run Go/Git commands here, not in the parent workspace.

1. Read the [workspace guide](../AGENTS.md) for shared skills, evidence requirements, default read-only target and concrete DEV-mutation approval rules. Reuse session authorization; never copy credentials here.
2. Use [.agent/INDEX.md](.agent/INDEX.md) to select the task's skills and references. Read only the affected scope.
3. Trace current code, tests and relevant schema/external dependencies before changing behavior. Documentation and badges are not proof of deployment or current test success.

User/runtime instructions take precedence. Local documents supplement the workspace: this file owns mandatory rules, INDEX owns navigation, topic documents explain details, QUALITY_GATES owns completion checks. Report discrepancies with code instead of silently changing the API to match prose.

## Read efficiently, preserve accuracy

Reuse guidance already read in this session unless it changed. Select one task path in INDEX, load applicable skills, and read detailed reference sections only when they resolve a concrete question. Expand for interfaces, data integrity, auth or uncertainty; never skip a required check to save tokens. Optional flow maps and historical reports are not startup reading.

## Local boundaries and rules

- Keep HTTP parsing/response formatting in `controller/`, business rules and transaction boundaries in `service/`, and GORM queries in `repository/`.
- Keep reused generic mechanisms in `helper/` (CSV row iteration, distance math, nil-token conversion). `service/` owns assignment mapping, office selection, notification decisions, and transaction orchestration. Dependencies run `service → helper`; `helper` must not import `service`, `auth`, `model/domain`, or `model/web`.
- Keep `service` as the business orchestration package; group related workflow functions by file. Routes compose concrete dependencies, while services accept only what they use. Add narrow consumer interfaces or function dependencies for real substitution seams, not for symmetry.
- Keep isolated Pondasi transport/parsing in `internal/pondasi`; presence merge and fallback policy stay in `service`.
- Pass the service's context-bound DB or transaction into repository methods; repositories do not own a global DB.
- Inspect the affected module's transaction style before extending it. Independent office reads use a context-bound DB; local atomic writes use transactions. Resolver-based write flows share one writer transaction across both fields; preserve the caller's handle and finalization.
- Never substitute the root DB for the transaction passed through a write flow.
- `model/domain` structs are deliberately GORM-aware. Do not create a second persistence model layer without an explicit requirement.
- Return API DTOs from `model/web`; do not return GORM domain structs directly from controllers.
- Treat `Updates(struct)` as non-zero-field updates. Use pointers, a map, or explicit `Select` only after checking the nearest repository pattern when zero values must be written.
- Check every GORM result error using the established panic flow; do not ignore `Error`.
- Use parameter placeholders for SQL values. Do not concatenate request values into raw SQL.
- Preserve explicit hard-delete (`Unscoped`) versus soft-delete behavior; both exist by module.
- Do not add startup migration models casually. The current `AutoMigrate` call has an empty list and no repository migration system is present.
- Preserve tenant/company and authorization filters already required by the affected flow; verify them rather than assuming all repositories apply them consistently.
- Do not expose or copy credentials from `configuration/.env` or `helper/service-account.json`.
- Role enforcement in `auth.Auth` is currently commented out. Do not claim route role slices enforce authorization, and do not change this behavior incidentally.
- Preserve panic-based error identity and strings relied on by `exception.ErrorHandler`.
- Notification goroutines run after being scheduled and may outlive request transactions. Use the existing bounded helper where the surrounding module does.
- Keep changes focused; spelling such as `qouta` is part of existing identifiers, tables, and routes.

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

Do not commit/push without session authorization. When an authorized commit is created, add a short top entry to `.agent/CHANGELOG.md` with heading `YYYY-MM-DD — commit message` and 1–3 bullets describing that exact commit; include it in the **same commit**. Do not create an entry when no commit is created. Changelog is history, not mandatory startup reading.
