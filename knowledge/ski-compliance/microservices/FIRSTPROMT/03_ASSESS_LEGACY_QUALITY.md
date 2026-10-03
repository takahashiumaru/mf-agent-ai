# 03 — Assess Legacy Quality and Define Safe Direction

## Purpose

Analyze an existing Go + GORM + MySQL repository and define a safe, incremental engineering direction before creating detailed standards or changing application code.

Run this prompt after `01_BUILD_REPOSITORY_CONTEXT.md` and `02_ENFORCE_CHANGELOG.md`.

## Role

Act as a senior maintainer of a production Go service. Distinguish proven strengths from accidental legacy patterns without proposing a wholesale rewrite.

## Authorized files

Create or update only:

```text
.agent/TECH_DEBT.md
.agent/PREFERRED_PATTERNS.md
.agent/REFACTORING.md
.agent/QUALITY_GATES.md
.agent/INDEX.md
AGENTS.md
.agent/CHANGELOG.md
```

Update `AGENTS.md` and `.agent/INDEX.md` only when necessary to route agents to the new guidance. Do not modify application code.

## Evidence rules

1. Read `AGENTS.md`, `.agent/INDEX.md`, and the relevant context documents first.
2. Use multiple real repository examples before declaring a pattern repository-wide.
3. Trace callers, data flow, and tests for high-risk findings.
4. Separate facts, inferences, and recommendations.
5. Mark insufficient evidence as `Needs investigation`.
6. Never expose credential values or production data.
7. Write in English. Include current source symbols and the reviewed revision for material findings. Historical documentation may be stale: verify claims against current code and tests.
8. Preserve business decisions and endpoint output during assessment. A security or correctness finding requires an explicit fix scope; discovery alone does not authorize behavior changes.

## Pattern classification

Classify significant patterns consistently:

- **PREFERRED** — default for new code and safe touched code.
- **ACCEPTABLE** — valid; no migration required.
- **LEGACY** — retained for compatibility but not copied into new code.
- **MIGRATE-WHEN-TOUCHED** — improve only when related code is already changing and behavior is protected.
- **DANGEROUS** — meaningful correctness, security, data-integrity, transaction, concurrency, or reliability risk requiring prioritization.

Do not label a pattern dangerous merely because it is stylistically unfashionable.

## Assessment scope

Inspect representative evidence for:

- package boundaries and dependency direction;
- dependency injection and hidden globals;
- `context.Context` propagation;
- error identity, wrapping, panic/recovery, and duplicated logging;
- duplicated business logic and testability;
- transaction ownership and accidental base-DB use inside transactions;
- `Save`, `Updates`, zero values, and unintended writes;
- `ErrRecordNotFound` behavior;
- soft delete and `Unscoped` usage;
- `Preload`, joins, associations, and N+1 queries;
- raw SQL parameterization;
- query bounds, pagination, sorting, and indexes;
- schema/model alignment and migration practices;
- authentication, authorization, validation, secrets, and sensitive logs;
- tests, race risks, observability, Docker, and CI gates.

## Output contracts

### `.agent/TECH_DEBT.md`

For each meaningful item include:

```markdown
## TD-### — Short title

- Classification: LEGACY | MIGRATE-WHEN-TOUCHED | DANGEROUS
- Evidence: `real/path.go` and relevant symbol/behavior
- Impact: Concrete failure or maintenance risk
- Scope: Affected modules
- Recommended action: Smallest safe improvement
- Verification: Tests, query plan, or checks needed
- Priority: Critical | High | Medium | Low
```

Do not turn preferences into debt. Group repeated instances under one item.

### `.agent/PREFERRED_PATTERNS.md`

Define the preferred direction for new code with real repository examples. Cover:

- layer boundaries and dependency direction;
- constructors and dependency injection;
- request validation and error handling;
- transaction ownership;
- safe GORM reads, creates, updates, and deletes;
- bounded list queries and association loading;
- model/DTO mapping;
- audit/event/ETL side effects;
- tests and observability.

For every pattern state when it applies, why it is preferred, and which legacy alternative must not be copied.

### `.agent/REFACTORING.md`

Define a safe migrate-when-touched workflow:

```text
characterize behavior → identify callers/side effects → add protection → make one focused change → verify → review diff
```

Require separate dedicated tasks for schema redesign, public API changes, cross-module rewrites, broad context propagation, dependency replacement, and risky performance work.

### `.agent/QUALITY_GATES.md`

Define proportional gates for every change:

- formatting and compilation/static analysis;
- targeted and broader tests;
- architecture and transaction review;
- API/backward-compatibility review;
- GORM and SQL safety;
- migration and rollback checks when applicable;
- security and sensitive-data review;
- performance evidence when performance is claimed;
- documentation and changelog update.

Differentiate mandatory gates from conditional gates. Commands must be verified against repository tooling.

## Guardrails

- Preserve behavior unless the task explicitly changes it.
- Prefer small, testable changes over broad cleanup.
- Do not introduce generic repositories, CQRS, DDD restructuring, frameworks, or layers without demonstrated value.
- Do not add interfaces solely because a concrete type exists.
- Do not optimize without evidence when measurement is practical.
- Never trade correctness, integrity, or compatibility for minor performance gains.
- Best practice is guidance, not permission for unrelated refactoring.

## Verification

Before finishing:

1. Confirm every example path exists.
2. Confirm classifications are supported by more than an isolated example, or narrow their stated scope.
3. Check the four documents do not contradict each other or `AGENTS.md`.
4. Remove vague recommendations that lack an action and verification method.
5. Review the final diff and update `.agent/CHANGELOG.md`.

## Completion report

Summarize:

- strongest existing patterns;
- highest-risk technical debt;
- preferred direction;
- safe migrate-when-touched opportunities;
- refactors requiring dedicated tasks;
- evidence and verification performed.

## Next step

When the user authorized the full documentation sequence, continue to `04_DEFINE_GO_GORM_MYSQL_STANDARDS.md` without another approval checkpoint. Otherwise deliver the requested assessment.
