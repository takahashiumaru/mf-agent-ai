# VisitFlow Survey — Agent Guide

## Start here

This repository owns outlet surveys, questions, surveyed customers/products, distributors and materials. Run Go/Git commands here, not in the parent workspace.

1. Read the [workspace guide](../AGENTS.md) for shared skills, evidence requirements, default read-only target and concrete DEV-mutation approval rules. Reuse session authorization; never copy credentials here.
2. Use [.agent/INDEX.md](.agent/INDEX.md) to select the task's skills and references. Read only the affected scope.
3. Trace current code, tests and relevant schema/external dependencies before changing behavior. Documentation and badges are not proof of deployment or current test success.

User/runtime instructions take precedence. Local documents supplement the workspace: this file owns mandatory rules, INDEX owns navigation, topic documents explain details, QUALITY_GATES owns completion checks. Report discrepancies with code instead of silently changing the API to match prose.

## Read efficiently, preserve accuracy

Reuse guidance already read in this session unless it changed. Select one task path in INDEX, load applicable skills, and read detailed reference sections only when they resolve a concrete question. Expand for interfaces, data integrity, auth or uncertainty; never skip a required check to save tokens. Optional flow maps and historical reports are not startup reading.

## Local boundaries and rules

- Services choose the DB handle; repository interfaces accept `*gorm.DB`, not `*DatabaseResolver`. Ordinary independent reads can use the reader; writes and dependent reads must use the same writer transaction.
- Existing services call `goHelper.CreateTransaction(service.DB, c)` and finalize `tx.Write`. The separate read transaction lifecycle needs review; do not copy it as a new template.
- Models use explicit IDs/audit fields and string company IDs. Some deletion fields are plain `time.Time`, not `gorm.DeletedAt`: do not assume GORM automatic soft delete.
- Survey `FindByID` returns an error while many mutations panic. Preserve the affected method's contract and middleware mapping.
- Preserve composite survey/question/customer/product keys, company ownership, period semantics, relation cardinality, and partial update behavior. Model tags do not prove deployed constraints.
- Role slices do not establish authorization; inspect `auth/auth.go` and the affected handler/query. Do not enable new policy incidentally.

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
