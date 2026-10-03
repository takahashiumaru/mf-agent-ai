# SKI Compliance workspace guide

## Objective and response contract

Use this workspace to answer SKI business questions, investigate code, and design changes from evidence. Reply in the user's language (normally Indonesian). Documentation is in English. Be concise first; expand analysis when the decision needs it.

**For questions asking for data, retrieve the data and answer with the result first, then scope and interpretation, then the SQL actually executed. Do not stop at a suggested query.** SQL-only is appropriate when explicitly requested. If execution fails, say data is unverified, explain the blocker, and label any SQL as unexecuted. Never substitute fabricated numbers, a schema snapshot, or estimated table rows for actual results.

## Required answer workflow

Classify the question before answering and complete the relevant evidence steps:

| Question | Required evidence before final answer | Answer order |
|---|---|---|
| “Total call hari ini berapa?”, counts, totals, lists, comparisons | Inspect owning source and relevant schema, then execute the authorized read-only SELECT and inspect its output | Actual result → period/scope/observation time → exact executed SQL for validation |
| “Feature ini sudah ada belum?” | Trace route registration, handler, service, repository, model and actual table/column support; inspect relevant consumers and pinned dependencies | Exists / partial / not found in inspected scope / unverified → source paths and lines → gaps |
| “Bisa menerapkan feature A? Bakal lemot/bermasalah?” | Inspect current code path and schema keys, indexes, types and relationships; identify affected queries, transactions, sync and consumers | Feasibility verdict → evidence → performance and correctness risks → recommended approach and verification |

For a data request, generating SQL is an intermediate step. Complete retrieval before finalizing. The user does not need to say “execute”, “use database”, or “read-only” again. Missing a MySQL MCP is not a blocker: use the existing Python runner documented in DATA_ACCESS. Resolve its path from this guide's workspace root even when the current directory is a child repository. Attempt the authorized connection before claiming access is unavailable. Never print connection secrets.

For “hari ini”, resolve the current date at execution in Asia/Jakarta and inspect the field's business meaning/storage timezone. A call date can differ from created_at. Explain whether the result counts calls, unique customers, or another grain. Avoid guessing a universal call table or completed-status value. If ambiguity materially changes the answer, inspect independently and ask one focused scope question. A failed query or unavailable source means unverified, never zero.

For feature existence, a matching filename or model alone is insufficient. “Not found” must name the searched repos/paths and terminology; it does not prove global absence. Local source does not prove deployment. Read relevant database structure even for code questions when persistence is involved; name any unavailable schema or private dependency evidence explicitly.

For feasibility, assess query count/N+1, scans and join fanout, indexes, pagination, data volume, locks/transaction duration, network calls, retries/idempotency, authorization, API compatibility and synchronization where relevant. Explain the concrete mechanism behind each material risk. State performance as a hypothesis until measured; do not promise “no slowdown” or “safe” from source alone. Give a practical alternative when constraints prevent the request.

Before sending: Is the opening sentence the user's answer? Are numbers from executed output? Are implementation claims linked to source? Was relevant schema inspected? Are unknowns and measurement limits explicit? SQL-only is valid when the user explicitly asks only for SQL. Otherwise, an execution failure must include the sanitized failure reason and distinguish executed SQL that failed from SQL not yet executed.

## Read selectively

1. Start with [.agent/INDEX.md](.agent/INDEX.md) and the matching shared skill.
2. Find the owning repository in [.agent/PROJECT_MAP.md](.agent/PROJECT_MAP.md).
3. Read that repository's `AGENTS.md`, relevant `.agent` pages, and exact source/callers.
4. For SQL, search [DATABASE_SCHEMA_CATALOG.md](DATABASE_SCHEMA_CATALOG.md) for relevant objects; inspect their keys, column types, and indexes.
5. Do not load all generated JSON or every repository into context. Use the route/model indexes to locate evidence.

## Evidence rules

- Live authorized SELECT results establish data at execution time; record schema, period, filters, units, and observation time.
- Live metadata establishes visible structure at capture time. Local schema snapshots are dated references, not current business data.
- Current source establishes local implementation; deployment behavior needs deployment evidence.
- Trace actual imports and versions in `go.mod`. A sibling checkout is not proof of the code inside a pinned dependency.
- Separate observed facts, inference, and unresolved questions. Cite source paths and lines for important code claims.
- Recheck relevant source or metadata when changed/stale; do not silently carry old conclusions forward.
- Reports, views, transactional tables, and synchronization copies can have different grain, timing, and totals.

## Database authorization and access

The user authorized read-only inspection of `SKI_MF_PROD` using credentials already in `mf-micro-service-discount-proposal/configuration/.env`. This authorization was given on 2026-09-27 and remains valid for this workspace task unless revoked. Do not repeatedly request the same permission. It does not authorize reading unrelated schemas or changing data/schema.

Use [.agent/tools/db_readonly.py](.agent/tools/db_readonly.py) for supported SELECTs; see [.agent/DATA_ACCESS.md](.agent/DATA_ACCESS.md). The runner establishes a read-only session and transaction. The service account's privileges have not been audited; do not call it a read-only account. Never print dotenv values, DSNs, tokens, host/user credentials, or copy them into documentation.

Never run INSERT, UPDATE, DELETE, ALTER, DROP, TRUNCATE, migrations, stored routines, or application startup against this connection. Do not invoke a function with unknown side effects. Do not weaken the runner or switch to a direct client to bypass a rejected query. Review/simplify it or report the specific unsupported construct.

## Database environment routing and confirmation

- **SELECT and plain EXPLAIN SELECT:** use `SKI_MF_PROD` directly through the authorized read-only runner. No repeated permission request. Resolve connection secrets from the existing local dotenv; never embed a DSN/password in instructions, SQL artifacts or logs. EXPLAIN ANALYZE is not covered by this automatic execution rule.
- **Mutations (including INSERT, UPDATE, DELETE, CREATE, ALTER, DROP, TRUNCATE, migrations and index changes):** default target is `SKI_MF_DEV`, using the same authorized server/account settings with the database explicitly selected as SKI_MF_DEV. This is routing guidance, not advance approval to execute a mutation.
- Before any DEV mutation, inspect the actual DEV schema, prepare the exact SQL and a read-only affected-row/object preview, identify constraints/dependencies and recovery limits. Tell the user **“Ini hanya akan dijalankan di SKI_MF_DEV, bukan production”**, show the SQL, expected impact and recovery plan, then ask **“Apakah yakin menjalankan query ini di SKI_MF_DEV?”** Wait for explicit approval of that concrete operation. Changed SQL, scope or environment requires renewed confirmation. Elapsed time is not approval. DDL may auto-commit; do not promise transaction rollback for DROP/ALTER/TRUNCATE.
- For a request to mutate **SKI_MF_PROD**, default to providing the reviewed SQL labeled **not executed**, its impact and a recommendation to validate on DEV first. Clearly state that it targets production. Never silently execute or treat DEV approval as PROD approval. Actual production execution requires a separate explicit approval after the exact SQL, production target, impact and recovery limits have been shown.
- Immediately before an approved mutation, verify the connected database is exactly the approved schema and reject cross-schema references to other targets. Never change the production read-only runner to make writes possible. No DEV write runner is installed; DEV connectivity and grants must be verified within the concrete future task. Do not claim DEV validation from production metadata.
- After execution, report the actual environment, result/affected rows and verification; on failure report what is known to have executed. Never imply a DEV change was applied to production.

## Data accuracy checklist

- Identify entity and row grain before choosing COUNT, SUM, DISTINCT, or joins.
- Confirm real column names and data types. `customers` has no `company_id`; `sales_ffs` has no `deleted_at` in the captured schema.
- Never add universal company, soft-delete, active-status, or period filters without checking the table and business rule.
- Establish period semantics per flow: YYYYMM, YYYYMMDD, and YYYY-MM appear in different places. Do not hardcode a current reporting period.
- Check one-to-many fanout and missing joins before aggregation; reconcile totals with a simpler base query where material.
- Preserve null versus zero, business timezone, units/currency, denominator, closed/open periods, and historical mappings.
- Bound detail output (up to 200 rows). Aggregate first and minimize personal/banking fields. Explain truncation; an output cap is not a full-dataset count.
- On timeout or unavailable access, report the limitation. No result is not the same as zero rows.

## Brainstorming and implementation

Use [.agent/ANALYSIS.md](.agent/ANALYSIS.md): define the user/business decision, inspect the relevant flow and evidence, rank hypotheses, compare 2–3 materially different options, recommend with tradeoffs, and identify the smallest discriminating measurement. Include affected repos, data consistency, operating cost, rollout, and recovery when relevant. Do not promise performance gains without measurement.

Preserve current API contracts, query scope, transaction ownership, auditing, and sync effects unless change is requested. Existing code is evidence, not an automatic best practice. Before edits, inspect Git status and preserve user changes. Run tests only when requested; distinguish discovered commands from executed checks.

## Scope and shared guidance

The latest explicitly authorized agent-guidance rollout covers 12 repositories. Excluded from this rollout: `flexurio-nocode-api-config-mf-marketing`, `flexurio-nocode-web-config-mf-marketing`, `mf-micro-service-discount-proposal`, and `rest-api-pondasi-mftl`. Earlier nine/seven-repository counts in historical records describe earlier tasks, not this rollout. Do not edit excluded repositories merely because a flow references them. Reading the authorized dotenv source remains allowed. Future explicit task scopes take precedence.

Canonical skills live in `.agents/skills/`; `.claude/skills/` links to the same files. `CLAUDE.md` imports this guide. Child guides link here for data and cross-repository work.

## Known limitations

This knowledge base is not an exhaustive runtime or security audit. Route indexes list static declarations, not deployed exposure. Local JWT handling findings must be tied to actual route imports. See [.agent/ACCURACY_AUDIT.md](.agent/ACCURACY_AUDIT.md). Application tests and benchmarks were not run for this documentation task. No production source, runtime configuration, or database state is changed by documentation generation.
