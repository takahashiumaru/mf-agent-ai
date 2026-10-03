# VisitFlow workspace guide

This directory is a shared workspace, not a Git repository or Go module. Work in the owning child repository. Keep shared VisitFlow skills in `.agents/skills/`, outside the child repositories. This file and those skills are the canonical instructions for Codex, Claude Code, and Antigravity when opened from this workspace.

## Find the owner quickly

| Area | Directory |
| --- | --- |
| Visits, customers, organization, approvals, reporting | `visit-flow-go/` |
| Attendance, offices, leave, corrections, meetings | `visit-flow-presence/` |
| Outlet surveys, survey questions, distributors, materials | `visit-flow-survey-location-go/` |
| KrakenD proxy plus local Gin identity/session API | `visit-flow-api-gateway/` |
| Payroll PDF, IMAP ingest, OTP endpoints | `visit-flow-payroll/` |
| AI prompt/tool project | `visitflow-agent-ai/` |

For a public URL, use gateway `configuration.json` to find the upstream, then inspect the owning service's route. The gateway also has its own Gin routes. The Obsidian vault at `~/Documents/Obsidian Vault/01 Perusahaan/VisitFlow Backend/` has route, gateway, schema, and domain indexes; it is a dated navigation aid. Current source code and the target runtime/database are the evidence for current behavior.

## Route each question

- Existing code, request validation, unexpected response, or endpoint error: use `visitflow-code-investigation`.
- Feature availability or feasibility ("sudah ada?", "bisa diterapkan?", "akan lemot?"): use `visitflow-code-investigation`; inspect the affected schema and use `visitflow-query-brainstorm` for performance/design tradeoffs. A question requests analysis; an implementation request authorizes implementation within its stated scope.
- A question about actual MySQL rows/counts or a read-only SQL answer: use `visitflow-database-qa`.
- Brainstorming, conceptual Q&A, or `EXPLAIN` discussion about query optimization: use `visitflow-query-brainstorm`.
- Measured slow query or endpoint: use `visitflow-query-performance`.
- Schema design or migration audit: use `db-schema-optimizer`.
- Go or GORM implementation: use `visitflow-go-backend` and `visitflow-gorm-mysql` when persistence is involved.

Answer a narrow conceptual question directly. For a VisitFlow-specific question, locate only the relevant route, handler, service, repository, model, and error mapping. Read the selected child's `AGENTS.md` and relevant `.agent` guidance as needed. Cite file paths and line numbers for conclusions drawn from source. Distinguish observed code, live evidence, and hypotheses; identify the smallest missing log/request/DB fact when a cause cannot be confirmed. Do not present a dated report or Obsidian snapshot as proof of the deployed state.

## Answer contract: result, evidence, implications

Answer in the user's language, with the conclusion first and detail proportional to the question. Reuse target, scope, and preferences already established in the session. Investigate available evidence before asking the user to repeat it.

| User asks | Required work and answer |
| --- | --- |
| "Total call hari ini berapa?" or another data question | Verify the metric in code and schema, execute a scoped read-only query on the chosen database, then give the actual result first. Include absolute date, business timezone, tenant/structure scope, metric definition, target and retrieval time. A single count needs a short paragraph, not a mandatory report. |
| "Kirim query untuk validasi" | Provide the SQL actually used and safe parameter values after the result. Preserve its definition, scope, and time bounds. If the SQL was not retained, say so rather than inventing execution history. |
| "Buat query saja" | Provide SQL based on verified structure, identify missing parameters, and mark it unexecuted. Do not execute a query-only request. |
| "Fitur ini sudah ada belum?" | Trace the working path through route/job/consumer, handler, service, repository/external dependency, model/schema, and relevant tests. Answer implemented, partial, or not found in the inspected scope, with file/line evidence and remaining gaps. A route, DTO, table, README, or Postman entry alone does not prove implementation or deployment. |
| "Bisa menerapkan fitur A? Akan lemot atau bermasalah?" | Give a feasibility verdict supported by current code and relevant database structure; explain required changes, compatibility, data integrity, performance risks, a recommended approach, and the checks needed to resolve uncertainty. If infeasible as proposed, explain the blocker and a practical alternative. |

Live database questions require an explicitly chosen target and a dedicated read-only MySQL account. When those and the metric/scope are established, execute the necessary bounded reads without asking again; do not stop after drafting SQL. Do not reuse service `.env` credentials for exploratory queries. If access is missing or execution fails, state that the actual total is unverified and identify the smallest missing input. An error is not zero; a dump or schema row estimate is not today's result. Keep tenant/company, structure/user, period, and soft-delete scope in view, and avoid exposing credentials or personal/payroll rows in answers or Obsidian notes.

For "call", resolve the application's definition (scheduled, checked in, completed, unique visit, or report aggregate) instead of choosing a similarly named table. Use the report/endpoint context when available; ask one targeted clarification when multiple definitions would change the answer. Resolve "today" at execution time in the agreed business timezone, verify timestamp storage semantics, and use half-open date ranges (`>= start`, `< next_day`). Check join cardinality before counting.

For feature feasibility, inspect table/column types, nullability, business keys, uniqueness, foreign keys, indexes, tenant/period joins, soft delete, views/procedures, and migration needs relevant to the feature. Trace transaction ownership, retries/idempotency, concurrency, external effects, auth, and existing callers. Assess query count/N+1, expected rows, filters, sort/pagination, locks, cache invalidation, payload, and background work where applicable. Scale the analysis to the feature. Say what is measured and what is an estimate; do not promise "no slowdown" without representative measurements. Do useful code/schema analysis even when live database access is unavailable, and state what remains unverified.

## Default production connection for read-only questions

The user selected production `VISITFLOW_MF_PROD` on 2026-09-27. Use the local MySQL login path `visitflow-production-readonly` (`mysql --login-path=visitflow-production-readonly --database=VISITFLOW_MF_PROD`) for subsequent read-only data questions unless the user selects another target. The supplied `VISITFLOW_MF_PRD` spelling was inaccessible; `VISITFLOW_MF_PROD` was discovered and successfully queried. Credentials are in the local MySQL login profile, never in workspace documentation.

Standing user authorization: directly use this profile for scoped `SELECT`, plain `EXPLAIN SELECT` (including `FORMAT=JSON`), and relevant read-only schema metadata inspection. Do not ask again which database/account to use or request approval for these reads. This selected profile satisfies the connection prerequisite in shared skills and child `.agent` guidance. Ask only for a genuinely missing business filter that changes the answer. An explicit request to write SQL without executing still remains unexecuted. `EXPLAIN ANALYZE` executes the query; assess its actual cost separately and do not treat it as plain EXPLAIN or authorization for an unrestricted benchmark.

This user-selected account is an explicit exception to the dedicated-account prerequisite above: its verified grants include write privileges. The profile name does not enforce read-only access. Execute analysis inside `START TRANSACTION READ ONLY` and issue only vetted reads/metadata inspection with bounded scope and timeouts. This default grants no permission for writes, migrations, imports, or stored procedures with side effects. Reuse the established company scope; state any all-company scope explicitly. If the profile is unavailable, request reconnection without copying application credentials.

## Database mutations: DEV only, confirm before execution

For `UPDATE`, `DELETE`, and `DROP`, the user requires `VISITFLOW_MF_DEV` on the same configured server/account. Reuse the local login profile with an explicit `--database=VISITFLOW_MF_DEV`; the profile name is not proof of the selected database. This standing preference chooses the target only, not permission to execute a mutation. Do not execute these operations on production under this authorization. Apply the same DEV-first confirmation requirement to other database mutations such as INSERT, ALTER, TRUNCATE, migrations, imports, and procedures with write effects.

Before every concrete mutation:

1. Prepare the exact SQL and parameters. Verify `SELECT DATABASE()` equals `VISITFLOW_MF_DEV`, and inspect fully qualified references, views/routines, triggers, and cascade effects relevant to the operation so it cannot write to production indirectly.
2. Use read-only inspection to establish the affected tables, predicates, tenant/company scope, and expected row count. For DROP or other DDL, state the affected object and dependency/data-loss impact. Describe rollback/recovery limits; do not imply MySQL DDL is transactionally reversible.
3. Tell the user explicitly: **"Ini hanya di DEV (`VISITFLOW_MF_DEV`), bukan production."** Show the concrete SQL or a precise reviewable description, expected impact, and recovery plan. Ask **"Apakah yakin ingin mengeksekusi perubahan ini di DEV?"**
4. Wait for explicit confirmation of that concrete action before execution. A request to draft SQL, this default-target instruction, silence, or previous approval of a different action is not confirmation. If target, SQL scope, or impact changes materially, explain the change and obtain confirmation again. An explicitly confirmed batch may execute as the reviewed batch.
5. After execution, verify the outcome and report the DEV database, affected rows/objects, and any errors. Do not automatically repeat the operation on production.

Keep credentials in the existing local MySQL login profile; never copy passwords into SQL files, documentation, or output. If the profile or DEV access is unavailable, report the blocker instead of falling back to production. Read-only SELECT/plain EXPLAIN remain covered by the production default above; inspection performed to prepare a DEV mutation must explicitly target DEV.

## Read code and database structure together

- Current source establishes local implementation; the selected runtime/database establishes deployed behavior and live data. Tests support only the scenarios they exercise.
- `DATABASE_SCHEMA_CATALOG.md` is a dated structural index; `DATABASE_SCHEMA.md` provides a domain dictionary and query guidance. Read the relevant tables after tracing code, and compare their columns/keys with actual model and repository usage. Neither document is an operational count or proof of current production schema.
- `database_schema.sql` is a sensitive dump that also contains INSERT statements. Extract only relevant DDL/view/procedure definitions locally; do not print row inserts, import, or execute the dump for Q&A. Inspect routine bodies before treating a call as read-only.
- `README.md`, child `.agent/` documents, and `VisitFlow_API_Testing.postman_collection.json` are navigation aids. For Postman inspect only needed method/path, parameter names, and body structure with values redacted; never run the entire collection to answer a question.
- If artifacts disagree, report the specific mismatch and which source supports the answer. A historical row count, coverage badge, endpoint count, or hardcoded period must not silently become a current fact. Verify target metadata with permitted read-only inspection when a live schema claim is needed.

Treat `*/configuration/.env`, `visitflow-agent-ai/.env`, the Postman collection, SQL dumps, production backup, and files with tokens or customer/payroll rows as sensitive. For ordinary Q&A, inspect only the relevant code and metadata. Never copy secret values or raw sensitive records into prompts, logs, generated reports, Obsidian, or external tools. Agent instructions guide behavior; actual MySQL read-only privileges and filesystem/tool permissions are separate controls.
