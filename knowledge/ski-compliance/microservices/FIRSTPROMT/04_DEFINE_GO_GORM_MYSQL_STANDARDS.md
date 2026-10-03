# 04 — Define Go, GORM, and MySQL Engineering Standards

## Purpose

Create practical, repository-specific standards for writing, reviewing, refactoring, and optimizing a Go + GORM + MySQL backend.

Run this prompt after the repository context and legacy-quality assessment exist.

## Authorized outputs

Create or update:

```text
.agent/GO_BEST_PRACTICES.md
.agent/GORM_BEST_PRACTICES.md
.agent/DATABASE_PERFORMANCE.md
.agent/CODE_QUALITY.md
.agent/SECURITY.md
.agent/INDEX.md
AGENTS.md
.agent/CHANGELOG.md
```

Do not modify application code. Keep `AGENTS.md` short; link detailed rules instead of duplicating them.

## Source-of-truth priority

Use this order when rules compete:

1. correctness and data integrity;
2. security and explicit business requirements;
3. API/backward compatibility;
4. verified preferred repository patterns;
5. official Go, GORM, and MySQL behavior;
6. maintainability and testability;
7. measured database/runtime performance;
8. consistency with acceptable existing code.

Write in English. Identify unsafe behavior and the intended correction, but do not silently implement a security or business-policy change during documentation, testing, or optimization work. Preserve current contracts until a behavior-changing fix is explicitly in scope. Do not introduce theoretical best practices without checking compatibility.

## Analysis method

1. Read `AGENTS.md`, `.agent/INDEX.md`, `.agent/PREFERRED_PATTERNS.md`, `.agent/TECH_DEBT.md`, `.agent/REFACTORING.md`, and `.agent/QUALITY_GATES.md`.
2. Inspect representative preferred and legacy examples.
3. Confirm dependency and library versions from `go.mod`.
4. Distinguish established repository rules from proposed improvements.
5. Use real relative paths as examples.
6. Mark uncertainty explicitly; never invent behavior.

## Document requirements

### `.agent/GO_BEST_PRACTICES.md`

Cover these topics with concise `MUST`, `SHOULD`, and `AVOID` rules:

#### Design and readability

- simple, explicit control flow;
- focused functions and clear responsibility ownership;
- early returns and limited nesting;
- composition before abstraction;
- cohesive packages and dependency direction;
- no arbitrary function-length limits.

#### Errors

- never ignore meaningful errors;
- preserve identity with `%w` when `errors.Is`/`errors.As` matters;
- distinguish infrastructure, validation, not-found, and business errors;
- follow the repository's established recovery/response convention;
- avoid duplicate logging across layers.

If the repository intentionally uses panic/recovery, document its boundary and do not replace it casually with generic advice.

#### `context.Context`

- propagate request context when the architecture supports it;
- place it first in function signatures;
- use it for database/network operations;
- do not store it in long-lived structs;
- do not create `context.Background()` inside request flows;
- respect cancellation and deadlines.

Label broad context adoption as a migration if existing interfaces do not support it.

#### Interfaces and dependency injection

- introduce interfaces only at real abstraction/test boundaries;
- prefer small consumer-owned interfaces where compatible;
- use explicit constructor injection;
- avoid service locators and new hidden global dependencies.

#### Types, collections, and concurrency

- explain pointer/value and nil/empty-slice conventions;
- avoid unnecessary allocations in hot paths;
- give every goroutine an owner, cancellation path, error path, and bound;
- check races and avoid loop-variable capture mistakes;
- do not add concurrency without measurable benefit.

#### Naming, logging, comments, and security

- follow idiomatic initialisms and repository conventions;
- use structured, non-duplicated logs with useful identifiers;
- never log secrets or sensitive payloads;
- write comments explaining why, invariants, or non-obvious trade-offs.

### `.agent/GORM_BEST_PRACTICES.md`

Document verified repository patterns and GORM behavior for:

#### Context and errors

- use `db.WithContext(ctx)` when context is available;
- always inspect `Error` and relevant `RowsAffected`;
- handle `gorm.ErrRecordNotFound` according to the API/domain contract;
- do not treat every not-found result as an infrastructure failure.

#### Create and update

- check create errors, generated keys, hooks, and audit effects;
- explain that `Updates(struct)` normally skips zero-value fields;
- prefer explicit `map[string]any`, pointer DTOs, `Select(...).Updates(...)`, or targeted `Update` when `0`, `false`, or `""` must be written;
- avoid `Save` for partial updates because it can persist unintended fields;
- whitelist writable columns for user-controlled changes.

#### Delete and soft delete

- preserve the repository's soft-delete and audit conventions;
- distinguish delete from business-state transitions;
- require explicit evidence and authorization for `Unscoped` hard deletes.

#### Transactions

- define one clear owner, normally service/use-case level if supported;
- pass and reuse the same `*gorm.DB` transaction;
- never fall back to the base DB inside a transaction;
- handle begin/commit/rollback errors according to the established helper;
- avoid external network calls while locks are held when possible;
- avoid nested transactions unless behavior is verified.

Inspect read/write resolver and transaction-helper implementations, including external module source when available. Account for every opened transaction and connection; verify dependent reads observe the intended writes. A shared mock connection cannot prove primary/replica routing. Changing `Find` to `First`, error wrapping, transaction finalization, or read handles can change public behavior and needs focused regression evidence.

#### Reads and associations

- select only needed columns for large/hot queries;
- prevent N+1 queries with deliberate joins, preload, or batching;
- explain `Preload` versus `Joins` trade-offs without declaring one universally superior;
- bound list queries and define stable pagination/order;
- parameterize raw SQL and dynamic predicates;
- close and check `Rows` errors when iterating manually.

#### Advanced behavior

Document repository-relevant hooks, scopes, upserts, batches, locks, association writes, and prepared statements. Warn about hook/soft-delete behavior bypassed by raw SQL.

### `.agent/DATABASE_PERFORMANCE.md`

Require evidence before performance claims. Cover:

- query shape, cardinality, selectivity, and data volume;
- N+1 and database calls inside loops;
- SARGable predicates and implicit conversions;
- composite-index left-prefix behavior;
- redundant/overlapping indexes and write cost;
- `EXPLAIN`/`EXPLAIN ANALYZE` appropriate to the verified MySQL version;
- bounded results, stable keyset pagination, and large-offset trade-offs;
- joins, aggregation, temporary tables, filesort, and large `IN` lists;
- transaction duration, locking, deadlocks, and retry policy;
- connection-pool configuration and observation;
- slow-query evidence and before/after comparison.

Never recommend an index from a `WHERE` clause alone. Require query shape, existing indexes, cardinality/selectivity, write impact, and an execution plan.

### `.agent/SECURITY.md`

Document the actual trust boundaries, authentication mechanisms, authorization ownership, tenant isolation, sensitive data and externally reachable inputs. Separate verified protections, confirmed findings and unverified risks. Do not claim security from framework choice or passing unit tests.

Define repository-specific requirements for:

- Authentication: configured secrets, accepted algorithms and applicable token claims, expiry, session lifecycle and revocation; no development-secret fallback in production.
- Authorization: object-level and action-level checks on reads, writes, exports and batch operations; derive trusted scope from authenticated context, not request-controlled company/owner IDs.
- Input and persistence: writable-field allowlists, parameterized values, allowlisted SQL identifiers/sort directions, bounded request/query sizes, and safe handling of empty filters.
- Outbound requests and files: applicable SSRF, redirects, destination validation, filesystem traversal, upload size/type and access checks.
- Browser-facing authentication: cookie flags, CORS and CSRF controls appropriate to the actual credential mechanism; do not impose irrelevant controls on unrelated APIs.
- Resource exhaustion: request/body limits, timeouts, cancellation, bounded concurrency, expensive search/export paths and repository-supported rate controls.
- Secrets and dependencies: redacted logs/errors, no secrets in fixtures, least-privilege DB credentials, secure transport configuration, compatible vulnerability tooling and actionable dependency triage.

Use `08_REVIEW_BACKEND_SECURITY.md` in this prompt pack as the review workflow when available. Generated guidance must remain self-contained after the pack is removed: keep operative rules in `.agent/SECURITY.md` and route the generated `backend-security` skill there.

For each applicable control specify evidence, owner and negative test. A discovered vulnerability does not authorize silently changing a public contract during documentation/testing/optimization. Report the issue and implement only fixes within the requested scope.

### `.agent/CODE_QUALITY.md`

Define a proportional review checklist covering:

- requested behavior and compatibility;
- architecture and scope discipline;
- Go correctness and error paths;
- GORM write safety and transaction integrity;
- SQL injection and authorization boundaries;
- query bounds and performance evidence;
- deterministic tests and race/concurrency concerns;
- observability and sensitive-data handling;
- documentation and changelog;
- no unrelated refactoring.

Include a Definition of Done that requires fresh verification evidence. Never equate compilation with behavioral correctness.

## Pattern presentation

For important rules, use:

```markdown
### Rule name

- Classification: PREFERRED | ACCEPTABLE | LEGACY | MIGRATE-WHEN-TOUCHED | DANGEROUS
- Applies when: ...
- Rule: ...
- Why: ...
- Repository evidence: `relative/path.go`
- Verification: ...
```

Use compact examples only when they materially clarify the rule.

## Guardrails

- No production-code modifications during this task.
- No generic repository, DDD, CQRS, or framework rewrite without clear need.
- No absolute local paths or unverified commands.
- No duplicated textbook content that does not affect this repository.
- No performance guarantee without measurement.
- No secret values or sensitive production data.

## Verification and completion

1. Confirm all referenced paths exist.
2. Check rules against the installed Go, GORM, and MySQL driver versions.
3. Reconcile contradictions with existing repository instructions.
4. Check headings, code fences, relative links, and placeholders.
5. Review the diff and update `.agent/CHANGELOG.md`.
6. Report files changed, key standards, legacy risks, uncertainties, and checks actually run.

## Next step

When the full documentation sequence is authorized, continue to `05_BUILD_AGENT_SKILLS.md`; otherwise deliver the requested standards.
