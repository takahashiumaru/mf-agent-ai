# Validation record — 2026-09-27

## Checks performed

- Parsed 2,210 Go files across the workspace using the source-only AST inventory; no Go parse errors were reported. No application package was imported or started.
- Regenerated the schema catalog, table DDL, route/model indexes, repository metadata and source hashes from captured evidence.
- Compared generated table names with metadata: 183 table definitions; catalog covers 261 visible tables/views and 4,354 captured columns. Routine metadata records 131 procedures. The snapshot contains 241 distinct FK constraints/column mappings.
- Connected to the authorized SKI_MF_PROD target and observed MySQL 8.4.2 and session transaction_read_only=1. Rechecked table/view counts with an actual SELECT at **2026-09-27 01:57:48 UTC**: 183 base tables and 78 views. A later metadata refresh at 01:57:48 UTC confirmed the same object/column counts; it queried metadata and DDL only, not business rows.
- Parsed the Python tooling for syntax. Ran the offline generator successfully and parsed all six shared skill frontmatters as YAML.
- Checked 366 Markdown files and 2,092 local/anchor links, schema object anchors, balanced code fences, source hashes, and all 60 canonical Claude skill links with `.agent/tools/check_context.py`; zero issues were reported.
- Compared tracked and staged Git diff hashes against the pre-task baseline in all 16 repos; existing user code changes were preserved. The seven excluded repos' full porcelain statuses were unchanged.
- Compared the original SQL dump SHA-256 with the captured baseline; unchanged.
- Scanned produced documentation, tools and generated evidence for the actual connection host, username and password values in memory; no matches were found. Values were not printed.

## Model-to-schema audit

`python3 .agent/tools/analyze_model_schema.py` rebuilds [the six-repository comparison](generated/MODEL_SCHEMA_COMPARISON.md) from the dated live metadata snapshot and AST model inventory. It does not connect to the DB. Current counts: 53 domain structs inventoried, 44 table models compared, two persistence targets absent from the snapshot, and zero remaining modeled type/tag/key discrepancy groups after local fixes. Check the report for projection exclusions and inferred table naming.

## Reproducible offline inspection

```sh
python3 .agent/tools/check_context.py
```

This checks structural consistency and source freshness without connecting to a database, executing application code or running an application test suite. It is not proof that every natural-language claim is semantically complete. For current data use the authorized SELECT runner; the schema snapshot is dated.

## Not performed / limits

No application tests, live mutation tests, service startup, migrations, production writes, security exploits, business-data counts, load tests, or runtime deployment checks were performed. No promise of universal future answer accuracy or model compliance is made: the installed instructions, shared evidence and executable read path improve grounding, and remaining uncertainty must still be disclosed per question.

The SQL guard is conservative and has not received an independent security audit. Read-only session controls were verified through successful metadata retrieval; the service account's full grants are unknown. Query-only requests and genuinely unavailable execution remain explicit exceptions to the data-first response contract.

## Local model implementation

See [model alignment record](MODEL_SCHEMA_FIXES.md) for the 17 changed Go files, two successful builds, four dependency-blocked builds, and two unresolved database targets.
