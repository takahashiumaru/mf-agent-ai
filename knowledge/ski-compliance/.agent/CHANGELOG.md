# Workspace knowledge changelog

## 2026-09-27 — Evidence-based data and repository context

- Added root AGENTS.md, CLAUDE.md, README, task routing, domain/project maps, data-access and data-answer contracts, analysis guidance, and accuracy audit.
- Added five SKI-specific shared skills and revised db-schema-optimizer; linked the canonical skills into Claude discovery at workspace and nine child repos.
- Added offline Go AST navigation and reproducible schema/catalog generation tools.
- Read authorized SKI_MF_PROD metadata and table DDL through read-only sessions using the existing discount-proposal dotenv without exposing credentials.
- Preserved the original dump; generated a separate structure-only table DDL reference and full visible-object catalog.
- Added repository-specific evidence traces to nine included repos and corrected categorical auth/cancellation/schema/transaction claims in their inherited guides.
- Later refreshed live schema metadata and added an AST-based model-to-live-schema comparison for bank, customer, event, marketing-user, outlet, and product repositories.
- Seven excluded repositories and VisitFlow remain unedited. No production source, database contents/schema, runtime settings, Git index or deployment was changed.
- Application tests were not run. See VALIDATION.md for the checks actually performed and evidence limitations.

## 2026-09-27 — Authorized model alignment

- Updated 17 Go source files across the six requested repositories against captured live metadata.
- Added read-only mappings for additional customer/product columns and corrected known type, primary-key, length and nullability differences.
- Refreshed source inventory and comparison: zero remaining modeled type/tag warnings across 44 matched models; two missing table targets remain unresolved.
- Bank/customer compile successfully; four other builds require unavailable dependencies. See [implementation record](MODEL_SCHEMA_FIXES.md). No database writes or excluded-repository edits.

## 2026-09-27 — Result-first answer enforcement

- Added explicit data/existence/feasibility answer workflow to root AGENTS and all nine included repository entry points, inherited by CLAUDE imports.
- Clarified child-directory runner invocation, existing authorization, current business-date semantics, source/schema evidence, and failed-versus-unexecuted SQL.
- Live connection probe succeeded at 02:20:21 UTC with session_read_only=1. A subsequent authorized metadata aggregate returned 183 base tables and 78 views. No call total was queried or claimed.
- Structural validation: 368 Markdown files, 2095 links, 60 skill links, zero issues. This verifies access and guidance structure, not guaranteed behavior across every future agent/session. Shared skills inherit the strengthened root/data/analysis guides; skill bodies were not changed.

## 2026-09-27 — Environment routing and confirmation

- SELECT/plain EXPLAIN SELECT remain directly authorized on SKI_MF_PROD; runner now validates the inner SELECT with its existing conservative guard. EXPLAIN ANALYZE and mutation plans are unsupported.
- Proposed mutations default to SKI_MF_DEV, with exact SQL, affected scope, explicit DEV-only notice and user confirmation required before execution. Production mutation requests default to unexecuted SQL and impact disclosure; any execution requires separate concrete production approval.
- Updated root and nine child guides, access documentation and stale EXPLAIN capability statements in two shared skills. Credentials were not copied. No DEV connection or mutation was performed.
- Structural checker: 368 Markdown files, 2105 links, 60 skill links, zero issues. Plain EXPLAIN SELECT 1 successfully exercised the production read-only path. No application test suite was run.

## 2026-09-27 — Twelve-repository agent guide rollout

- Applied concise AGENTS/CLAUDE entry points, evidence-based exceptions, current testing inventories, maintenance/verification guidance and local/shared skill links to twelve explicitly requested repositories.
- Preserved both no-code config repositories, discount-proposal and rest-api-pondasi-mftl byte-for-byte. Updated root guidance to record this latest task scope.
- Verified 471 Markdown guides and 230 skill links: no broken local file links. Compared existing file hashes: no non-Markdown file changes; all excluded files unchanged. No application tests, builds, database operations or service startup.
