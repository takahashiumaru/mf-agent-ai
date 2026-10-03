# 01 — Build Repository Context

## Purpose

Create a repository-specific knowledge base that lets future AI agents work safely without repeatedly scanning the entire codebase.

Run this prompt first. It establishes the evidence-based context used by prompts `02` through `07`. Apply the shared execution contract in `README.md` when this prompt is used as part of the pack. Write all generated guidance in English.

## Role

Act as a senior Go backend engineer experienced with GORM and MySQL. Analyze the repository as it exists; do not redesign it and do not modify application code.

## Required outputs

Create or update only these documentation files:

```text
AGENTS.md
.agent/INDEX.md
.agent/PROJECT.md
.agent/ARCHITECTURE.md
.agent/CODE_STYLE.md
.agent/CONSTRAINTS.md
.agent/DOMAIN.md
.agent/DATABASE.md
.agent/GORM.md
.agent/API.md
.agent/ERROR_HANDLING.md
.agent/TESTING.md
.agent/WORKFLOWS.md
```

Preserve useful existing content. Record this documentation change in `.agent/CHANGELOG.md` when that file already exists.

## Non-negotiable rules

1. Do not modify production source code, database state, migrations, CI, or runtime configuration.
2. Do not invent architecture, commands, tables, fields, domain rules, or conventions.
3. Support repository-specific statements with real file paths and multiple examples where practical.
4. If evidence is missing, write `Not clearly established in the current repository.`
5. If old and new modules use different patterns, document both and label their scope.
6. Existing code is evidence, not automatic best practice.
7. Do not expose secrets or copy credential values into documentation.
8. Use relative repository paths; never write machine-specific absolute paths or `file://` links.

## Analysis workflow

### Phase 1 — Establish the repository shape

Inspect only files that exist, starting with:

- `go.mod`, `go.sum`, `README*`, `Makefile`;
- application entrypoints and bootstrap code;
- router, middleware, dependency wiring, and configuration loaders;
- `Dockerfile*`, Compose files, `.golangci*`, and CI/CD configuration;
- migration or schema-management files;
- the top-level directory tree.

Record the detected Go, GORM, MySQL driver, web framework, validation, authentication, observability, queue, and testing versions. Never infer a dependency from filenames alone.

Treat root `AGENTS.md` as the entry-point map, not an encyclopedia. Keep detailed knowledge in `.agent/` so ordinary tasks load only the context they need.

### Phase 2 — Sample representative implementations

Record the current branch, HEAD, dirty files, module roots, and relevant build tags. Inspect focused Git history for representative functions when available: distinguish intended behavior, fixes, and incidental cleanup. A commit title is not proof of correctness. Compare the relevant change with its parent rather than an unrelated long-diverged branch. Keep historical observations separate from current facts and re-check source before documenting them.

For a monorepo, scope commands and documentation to the detected modules; do not assume root `go test ./...` covers nested modules. Preserve existing user instructions instead of replacing them wholesale.

Inspect a small but representative sample:

- 2–4 controllers or handlers;
- 2–4 services or use cases;
- 2–4 repository implementations;
- domain and persistence models;
- request/response DTOs;
- transaction-heavy flows;
- association, preload, join, raw SQL, update, and delete examples;
- middleware and error handling;
- relevant tests.

Expand the sample only when patterns conflict or evidence is insufficient. Do not infer a repository-wide convention from one file.

### Phase 3 — Trace critical flows

For representative read and mutation requests, trace:

```text
route → middleware → controller → service/use case → repository → database/external side effect
```

Identify ownership of validation, transactions, audit logging, ETL/events, errors, and response mapping.

### Phase 4 — Write the knowledge base

Use the following contracts.

#### `AGENTS.md`

Keep it concise and operational, ideally 80–180 lines. Include:

- repository purpose and verified technology stack;
- directory map and request flow;
- highest-risk coding rules;
- agent reading strategy;
- verified run, build, format, test, vet, lint, and migration commands;
- link to `.agent/INDEX.md`.

#### `.agent/INDEX.md`

Create a task-to-document routing table and the recommended reading order:

```text
AGENTS.md → .agent/INDEX.md → task-specific document → affected module → nearest examples → tests
```

#### `.agent/PROJECT.md`

Document the service purpose, responsibilities, major modules, entrypoints, configuration, and external systems.

#### `.agent/ARCHITECTURE.md`

Document verified layers, dependency direction, request lifecycle, transaction ownership, dependency injection, and side effects.

#### `.agent/CODE_STYLE.md`

Document observed Go conventions: packages, files, names, constructors, interfaces, pointers, slices, errors, context, logging, comments, and formatting.

#### `.agent/CONSTRAINTS.md`

Separate rules into `MUST`, `MUST NOT`, `SHOULD`, and `INVESTIGATE FIRST`. Include data integrity, API compatibility, transaction, migration, and secret-handling constraints.

#### `.agent/DOMAIN.md`

Document business modules, terminology, invariants, state transitions, period/closing rules, and cross-module side effects. Clearly label uncertain rules.

#### `.agent/DATABASE.md`

Document the verified database engine, schema source of truth, migration mechanism, key tables, keys, relationships, timestamps, soft deletes, indexes, and audit fields.

#### `.agent/GORM.md`

Document initialization, model strategy, tags, updates, deletes, transactions, associations, preload/join behavior, raw SQL, errors, locking, batching, and repository-specific anti-patterns.

#### `.agent/API.md`

Document route registration, authentication, request binding, validation, filtering, pagination, response envelopes, status codes, and compatibility rules.

#### `.agent/ERROR_HANDLING.md`

Document error creation, wrapping, propagation, recovery, mapping, logging ownership, and not-found behavior.

#### `.agent/TESTING.md`

Document existing test organization, fixtures/mocks, verified commands, package-level test examples, database dependencies, and known gaps.

#### `.agent/WORKFLOWS.md`

Provide evidence-based checklists for adding an endpoint, changing business logic, changing a query, fixing a bug, and changing schema.

### Phase 5 — Evaluate nested instructions

For a large repository, identify modules that may benefit from a closer `AGENTS.md` containing genuinely module-specific domain rules. Do not create nested instruction files automatically during this first pass. Recommend them only when global guidance is insufficient and the module has stable, distinct rules.

## Quality checks

Before finishing:

1. Check every referenced path exists.
2. Remove unsupported claims and placeholders.
3. Confirm commands were actually discovered or executed; label unexecuted commands.
4. Check that documents agree on architecture and transaction ownership.
5. Search for secrets and machine-specific absolute paths.
6. Run a Markdown/link check if tooling exists; otherwise inspect headings, code fences, and relative links manually.
7. Review `git diff` and confirm only authorized documentation changed.

## Completion report

Report:

- files created or updated;
- strongest established patterns;
- conflicting or legacy patterns;
- critical constraints;
- uncertain areas requiring human confirmation;
- any modules that may justify a nested `AGENTS.md` and why;
- verification performed.

Do not claim tests, builds, or checks passed unless they were executed successfully in the current task.

## Next step

After this prompt succeeds, run `02_ENFORCE_CHANGELOG.md`.
