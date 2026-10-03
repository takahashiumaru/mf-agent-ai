# Accuracy audit — 2026-09-27

## What was adopted from VisitFlow

The reference workspace demonstrates root AGENTS/CLAUDE routing, shared `.agents/skills`, `.claude/skills` links, schema reference files and task-focused guidance. SKI uses the same discoverable structure, while its facts come from SKI source and the authorized SKI_MF_PROD metadata.

The sampled VisitFlow documents disagreed on table counts (74 versus 89), and its example data-query guidance was not sufficient to guarantee data-first answers. Those values, columns, hardcoded periods and universal tenant/deletion assumptions were not transferred. VisitFlow was not edited.

## Corrections to inherited SKI guidance

| Earlier statement or gap | Evidence-based correction |
|---|---|
| All nine services share an active critical local JWT vulnerability | Local helper handling is a source concern; actual route imports differ. Bank mixes gateway/local auth, event and product routes use gateway dependency auth, and scanned sync routes have no auth wrapper. Deployment exposure and pinned gateway implementation were not verified. |
| No schema/version reference is available | Authorized metadata now records MySQL 8.4.2 and visible schema at a dated observation. It does not prove every repository deployment points to that same database. |
| A repository interface without context proves request cancellation is lost | Some services pass Gin context to an imported transaction helper. Check that helper and DB context binding before drawing a conclusion. |
| AutoMigrate occurrence proves active model migration | Inspect executable model arguments; the bank sample has commented-out models and separate SQL-file calls. Initialization must not be run for data inspection. |
| All representative flows share local helper transaction behavior | Some use local Begin/CommitOrRollback; others use pinned go-helper packages; warehouse processing uses a base DB handle in the sampled method. |
| Two sync handles prove distributed writes | Trace reads and writes individually. A concrete SyncCustomerPosition defect candidate is duplicate finalization of tx.Write with no txSki.Write finalizer in that method. Runtime impact is not established. |
| Every updateEtl callback performs ETL | Inspect the body; callbacks can be empty. Invocation order alone does not establish the actual effect. |
| Unscoped deletion is automatically a defect | It is observed hard-delete behavior; review retention, history and compatibility before changing it. |
| Schema/table estimates answer current data questions | Structure and estimated rows cannot replace successful SELECT results. Actual results lead the answer; executed SQL follows. |
| Shared optimizer mandates ESR, index drops and fixed pool values | Replaced with workload-specific index/transaction analysis and strictly read-only recommendations. |

## Remaining boundaries

- Source inventory parses 2,210 Go files; parsing and navigation do not establish semantic correctness or runtime reachability.
- Route counts include literal declarations under route/, with a static app/router.go caller match. Other registration styles, main-file routes, global middleware and deployment prefixes need direct inspection.
- Models list explicit TableName methods when visible. Default naming and external models are not automatically mapped to live tables.
- Metadata captures 183 base tables, 78 views, 4,354 columns, 131 routines (see catalog for routine kinds), and no visible triggers. Account privileges were not audited. View/routine bodies were not fetched.
- Business policies such as net sales, cancellation, ownership, active status and closing eligibility need the exact requested flow. Unknown policy is not filled by guesses.
- No business-data totals, application tests, security exploit checks, load benchmarks, deployment validation or full dependency audit were performed.
- The database runner is a conservative helper with session read-only enforcement, not an independently audited SQL sandbox or proof of least-privilege credentials.

Per-repository evidence is documented in `.agent/EVIDENCE.md` in the nine included repos. Earlier historical changelog entries remain historical; this refresh narrows unsupported claims without rewriting application code.
