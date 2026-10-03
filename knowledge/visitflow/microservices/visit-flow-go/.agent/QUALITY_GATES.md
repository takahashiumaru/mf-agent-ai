# Quality Gates

This file owns completion checks; AGENTS.md owns mandatory local rules. Apply these gates to changed executable code according to risk. Documentation-only changes use Gate 10 plus path/reference/command consistency and relevant instruction scenarios; do not run unrelated application tests merely to edit prose. Do not claim a gate passed unless the command/evidence was actually obtained.

## Gate 1: Scope and Behavior

- The requested behavior and non-goals are explicit.
- The affected route, controller, service, repository, model/DTO, callers, and tests were inspected.
- Existing client-visible status, JSON, not-found, and validation behavior is preserved unless intentionally changed.
- No unrelated cleanup, dependency, or architecture rewrite is included.

Failure blocks completion.

## Gate 2: Architecture and Dependency Direction

- HTTP parsing/response stays in controllers.
- Business/authorization decisions stay in services.
- GORM/raw SQL stays in repositories.
- New dependencies use explicit constructor injection and route wiring.
- Shared interface changes include all implementations/callers/mocks.
- No new generic base repository/service or reflection framework was introduced.

Legacy exceptions may remain outside the touched path.

## Gate 3: Go Correctness

- All meaningful errors are handled.
- Wrapped errors preserve identity with `%w` where callers classify them.
- New internal APIs return expected/recoverable errors. In an existing panic-based chain, retain the established compatibility boundary that turns an error into the middleware/rollback flow. Do not partially migrate that chain or swallow the error; see `ERROR_HANDLING.md` and `PREFERRED_PATTERNS.md`.
- Context cancellation/deadlines reach database/network operations.
- Nil, zero, empty, bounds, and parse failures are considered.
- Goroutines have bounded ownership, lifecycle, timeout/cancellation, and error handling.
- Secrets and sensitive payloads are absent from logs/errors.

## Gate 4: Transaction Correctness

- The service clearly owns the transaction.
- All atomic writes use the passed `tx.Write`, not the base DB.
- Reads dependent on prior writes use the same `tx.Write` transaction.
- No accidental nested transaction or mid-flow commit was added.
- Rollback preserves the triggering error and reports secondary rollback failure.
- Avoidable network/file/CPU-heavy work is outside transaction scope.
- Failure at each write boundary cannot leave unintended partial state.

Transaction-helper or resolver changes require MySQL integration tests and a dedicated review.

## Gate 5: GORM Safety

- Every GORM operation checks `.Error`.
- `RowsAffected` is checked when no-op versus success matters.
- Partial updates correctly handle `0`, `false`, `""`, and null.
- `Save` is not used for a partial update.
- `First`/`Take`/`Find` choice matches not-found semantics.
- Soft delete, audit fields, and `Unscoped` behavior are intentional.
- Upsert conflict keys match verified unique constraints.
- Automatic association persistence cannot save an unintended graph.

## Gate 6: Query and Database Performance

- No obvious DB/network call was introduced inside a loop.
- Public/growing list queries are bounded.
- Relation loading is deliberate: targeted preload, join/projection, or batch lookup.
- Join multiplication and count semantics were checked.
- Wide columns/associations are not loaded unnecessarily on significant queries.
- Filter/sort identifiers are allowlisted; values are parameterized.
- Relevant production indexes were inspected for significant queries.
- Suspected performance improvements are supported by sanitized SQL/plans or clearly labeled unverified.
- Transaction duration and batch size were reviewed.

## Gate 7: Security and Tenancy

- `CompanyID`, `StructureID`, subordinate, ownership, and period restrictions are preserved as required.
- Checkpoint/approval flags are enforced for the action.
- The inactive route-role enforcement is not mistaken for authorization.
- Raw SQL contains no concatenated user input.
- File paths/uploads and external requests use existing validation constraints.
- No credentials, DSNs, JWTs, Firebase material, or API keys were added/exposed.

## Gate 8: Tests

At minimum:

1. add/update a focused regression test;
2. run the affected package/test;
3. run `go test ./...` when practical;
4. update handwritten mocks for interface changes;
5. test failure behavior, not only success.

Risk-specific cases:

- update: omitted and explicit zero/false/empty/null;
- tenant/auth: allowed and cross-tenant/unauthorized cases;
- not-found: expected HTTP/service contract;
- transaction: rollback at each failing write and read-your-writes;
- query refactor: same result ordering/deduplication and reduced query count;
- delete: soft/hard visibility and audit fields;
- batch/upsert: duplicates, partial error, and empty batch.

Unit tests do not prove MySQL/stored-procedure/replica behavior. State the integration coverage gap when such verification is unavailable.

## Gate 9: Tooling

Run only configured/available tools and report exact outcomes:

```sh
make fmt
go test ./path/to/affected/package
go test ./...
go vet ./...
make lint       # requires golangci-lint
make static     # requires staticcheck
```

Use `go test -race` for concurrency-sensitive packages when practical. Do not run `make tidy` merely as a check because it can modify module files. Do not treat Docker's build-time `go fmt` as a substitute for reviewing diffs.

## Gate 10: Diff and Documentation Hygiene

- `gofmt` produced no unexpected unrelated changes.
- `git diff --check` passes.
- Source changes are limited to the requested behavior.
- No runtime/debug/coverage/generated artifacts were added.
- Generated files, if any appear later, are regenerated from source rather than edited.
- Changed conventions, commands, API contracts, or schema requirements are documented.
- Existing user changes in the worktree were preserved.

## Minimum Definition of Done

A change is ready only when:

- behavior is correct and scoped;
- affected tests pass;
- errors/context/transactions are reviewed;
- tenant and security constraints are intact;
- GORM zero-value/delete/not-found behavior is deliberate;
- query performance has no obvious regression;
- no N+1 or unbounded operation was introduced;
- required integration gaps are disclosed;
- the final report names what was verified and what remains uncertain.

## Review Severity

- **Blocker:** data loss/corruption, cross-tenant access, credential exposure, injection, broken atomicity.
- **High:** ignored DB errors, unsafe partial update, wrong not-found/status transition, hard delete without safeguards, clear N+1 on unbounded data.
- **Medium:** hidden dependency, long transaction, unbounded endpoint believed low-volume, insufficient regression coverage.
- **Low:** local naming/readability issue without behavior risk.

Do not block a change on personal style when repository conventions and correctness are satisfied.
