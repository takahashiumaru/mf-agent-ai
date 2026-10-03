# ski-api-gateway — AI Agent Guide

## Start here

Gateway route collections, reverse proxying, API-key/JWT middleware and upstream integration. Read only the topic needed for the current task:

1. [Workspace rules](../AGENTS.md): response contract, authorization and database environment policy.
2. [Task index](.agent/INDEX.md): select the relevant domain document and skill.
3. [Current evidence and exceptions](.agent/EVIDENCE.md): distinguish observed behavior from preferred design.
4. Trace Backend mappings, router registration order, middleware and reverse-proxy behavior; inspect downstream persistence only when the task depends on it.

Direct user instructions take precedence over local guidance. This documentation rollout explicitly includes this repository. The current exclusions are the two Flexurio config repos, discount-proposal and rest-api-pondasi-mftl; earlier exclusions describe previous tasks. Existing source behavior is evidence, not automatic approval to refactor it. Preserve unrelated working-tree changes.

## Required answers

| Request | Work required | Answer |
| --- | --- | --- |
| Actual count, total or records | Inspect business grain/date/filter semantics and schema; execute authorized SELECT | Actual result first, scope and observation time, then exact executed SQL |
| Does a feature exist? | Trace registered route through its implementation, dependencies and persistence | Implemented / partial / not found in inspected scope / unverified, with source locations |
| Can a feature be added? | Inspect current flow, schema/indexes, transaction ownership, consumers and sync effects | Feasibility, concrete correctness/performance risks, recommended approach and verification |
| Query only | Validate schema and semantics | SQL labeled as unexecuted |

Do not substitute suggested SQL for an actual-data answer. On failure, report the observed sanitized blocker; distinguish a failed query from one never executed. Do not infer deployment from local code or promise performance without measurement.

## Database boundary

Use [workspace data access](../.agent/DATA_ACCESS.md). From this repository, feed reviewed SQL through stdin to `python3 ../.agent/tools/db_readonly.py`.

- SELECT/plain EXPLAIN SELECT: authorized SKI_MF_PROD read-only path; no repeated permission request. EXPLAIN ANALYZE is not covered.
- Mutations: default SKI_MF_DEV, inspect DEV first, show exact SQL and affected scope/recovery limits, explicitly state DEV only, and wait for user confirmation before execution.
- Production mutations: default to an unexecuted SQL proposal and impact explanation. Execution requires separate explicit production approval after the concrete operation is shown.
- Verify the approved schema and explicit cross-schema references. DEV approval never covers PROD. Never start the application or bypass the read-only runner to retrieve analytical data.
- Keep credentials in the authorized local configuration; never print or copy values into documentation.

## Change rules

- Trace transaction ownership and the actual database handle used by each query before editing. Do not add nested transactions or move commit/rollback mechanically. See known exceptions in EVIDENCE.md.
- Preserve existing JSON envelopes, status codes, export content types, file headers and API fields unless the task authorizes changing them. Excel responses are not JSON responses.
- For intended zero/NULL writes, use an explicit update strategy and verify GORM semantics; preserve omission versus zero/null semantics of the DTO.
- Preserve business period/closing checks, hierarchy scopes, soft-delete rules, history and sync effects. Do not invent universal filters.
- Do not start proxy traffic or invoke upstream mutations as a documentation check. Preserve upstream path, method, headers and authentication ordering.
- A pinned module version may differ from a sibling checkout; inspect the imported version before claiming its behavior.

## Verification and completion

Run application tests only when requested. Document checks actually executed, their result, date and source revision; commands listed in documentation are not evidence they passed. For documentation-only changes, verify links, examples against source and scope of the diff. Do not run service startup, deployment or database mutation as a documentation check.

See [testing inventory](.agent/TESTING.md), [quality gates](.agent/QUALITY_GATES.md), [constraints](.agent/CONSTRAINTS.md) and [maintenance](.agent/MAINTENANCE.md).
