---
name: go-gorm-clean-code
description: Apply clean-code refactoring to existing Go and GORM code in MF Micro Service Sales while preserving business behavior, API contracts, transactions, audit history, ETL callbacks, and query semantics. Use for readability cleanup, decomposition, duplication removal, or restructuring; do not use for feature or schema changes.
---

# Go GORM Clean Code

Improve code readability and maintainability without changing what the service does. Prefer small, reviewable edits over architectural rewrites.

## Read Before Editing

Always read `AGENTS.md`, `.agent/INDEX.md`, and the files directly involved in the requested flow. Then read:

- `.agent/REFACTORING.md` and `.agent/TECH_DEBT.md` for refactoring scope and known risks.
- `.agent/CODE_STYLE.md` and `.agent/GO_BEST_PRACTICES.md` for local Go conventions.
- `.agent/GORM.md` and `.agent/GORM_BEST_PRACTICES.md` when a query, model, or transaction is involved.
- `.agent/CONSTRAINTS.md` for invariants that must survive the refactor.
- `.agent/TESTING.md` and `.agent/QUALITY_GATES.md` before verification.

Inspect the complete request flow from route to model, but avoid scanning unrelated modules. Use the nearest established implementation as the structural reference.

## Freeze Observable Behavior

Before editing, state which behavior must remain unchanged and identify its current tests. Preserve:

- Routes, HTTP methods, status codes, JSON field names, response envelopes, and validation results.
- Business calculations, closing-period rules, authorization scope, filtering, ordering, pagination, and record-selection semantics.
- Panic-based error propagation and error identities used by the global error handler.
- Transaction boundaries, operation order, rollback behavior, audit-history writes, ETL callbacks, Redis jobs, emails, and other side effects.
- GORM table names, associations, selected columns, predicates, joins, locking behavior, soft deletes, and zero-value update semantics.

If intended behavior is unclear or untested, add a characterization test before refactoring. Do not silently treat a suspected bug as cleanup; report it separately.

## Clean-Code Rules

- Keep the dependency direction `route -> controller -> service -> repository -> GORM`.
- Keep controllers limited to HTTP input/output, services to validation and orchestration, and repositories to persistence plus established audit/ETL responsibilities.
- Keep pure, reusable utilities in `helper` (for example Excel formatting/workbook helpers, query-filter utilities, and value formatting); keep service-specific orchestration and business decisions in `service`.
- A helper must not depend on `service`, controllers, Gin context, or repository interfaces. If a function needs a service receiver, transaction, authorization, or business rule, it remains in the service layer.
- Give functions one clear responsibility. Extract cohesive private helpers when a block can be named by intent.
- Prefer early returns, explicit names, and shallow control flow. Avoid clever abstractions, reflection, and generic repository frameworks.
- Remove duplication only when the duplicated behavior is genuinely identical. Keep domain differences explicit.
- Split oversized files by responsibility within the same Go package before considering package or public-interface changes.
- Preserve public interfaces and constructor signatures unless the user explicitly authorizes a contract change.
- Keep comments for business reasons and non-obvious constraints; do not narrate straightforward code.
- Make mechanical moves separately from logic edits so diffs remain reviewable.

## GORM Safety Rules

- Services own write transactions using `DB.Begin()` and `defer helper.CommitOrRollback(tx)`; repositories use the supplied `*gorm.DB`.
- Do not replace the supplied transaction with a global connection.
- Never enable runtime `AutoMigrate`.
- Do not use `Save()` for partial updates. Preserve intentional zero values with pointers, maps, `Select`, or targeted `Update` calls.
- Keep queries parameterized. Do not introduce raw SQL concatenation, N+1 queries, or unbounded reads on large tables.
- Treat changes to GORM call ordering as behavioral changes. For example, moving `Where`, `Model`, `Updates`, `Joins`, or `First` can alter the generated SQL.
- Keep mutation history inside the active transaction and preserve the timing of callbacks that run after database work succeeds.
- Do not introduce `Unscoped()` or hard deletion without explicit authorization and an audit-preservation design.

## Slow-Query Optimization

Treat performance work as a separate behavior-preserving change, not as an incidental cleanup.

- Identify the exact endpoint/repository method and capture the generated SQL, bind values, row volume, and timing before editing.
- Use `EXPLAIN`/`EXPLAIN ANALYZE` against a representative database or approved query plan fixture before proposing an index or query rewrite.
- Check composite-index order, sargability, join predicates, selected columns, grouping, sorting, pagination, and whether a loop causes N+1 queries.
- Prefer a selective existing index, bounded reads, batch `IN` queries, or a semantically equivalent join before adding schema changes.
- Never add an index, change a predicate, remove a join, or alter transaction scope without a regression test proving identical rows, totals, ordering, and side effects.
- Record before/after evidence (plan shape, rows examined, duration, and memory where available). If no production-like plan is available, make only static, low-risk improvements and state that measurement is pending.

## Refactoring Workflow

1. Define the narrow target and trace its callers, database effects, and asynchronous effects.
2. Run the smallest relevant test as a baseline. Add characterization coverage for unprotected behavior.
3. Make one coherent change: rename, extract, split, flatten, or remove proven duplication.
4. Format and rerun focused tests immediately.
5. Compare the diff against the frozen behavior list and inspect GORM chains line by line.
6. Continue only while each step remains behavior-preserving and easy to review.
7. Run the repository quality gates and update `.agent/CHANGELOG.md` before declaring completion or committing.

Stop and ask for direction when preserving behavior conflicts with the desired structure, when tests reveal uncertain business rules, or when a proposed change requires an API, schema, transaction, or side-effect change.

## Verification

Run checks proportionate to the change, ending with:

```bash
go fmt ./...
go vet ./...
go test ./...
golangci-lint run
```

Use `go test -race ./...` when goroutines, callbacks, shared state, or concurrent tests are touched. If a command is unavailable or fails for a pre-existing reason, report the exact command and evidence rather than claiming success.

## Completion Report

Summarize:

- The readability problem addressed and the files changed.
- The behavior and contracts deliberately preserved.
- Tests and quality gates actually executed.
- Remaining risks or deferred cleanup, without mixing them into the completed refactor.
