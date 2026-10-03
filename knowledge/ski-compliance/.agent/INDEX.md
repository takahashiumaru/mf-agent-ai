# Context index

Read `AGENTS.md` → this index → relevant topic/skill → owning child repository → exact source and callers. Load only the relevant sections of large generated indexes.

| Task | Guidance | Evidence navigation |
|---|---|---|
| Ask for actual numbers or records | [Data answers](DATA_ANSWERS.md), [access](DATA_ACCESS.md), `ski-database-qa` | [Schema guide](../DATABASE_SCHEMA.md), [catalog](../DATABASE_SCHEMA_CATALOG.md) |
| Understand code or diagnose a flow | `ski-code-investigation`, child architecture/domain docs | [Routes](generated/ROUTE_INDEX.md), [models](generated/MODEL_INDEX.md) |
| Brainstorm a feature, process, query, or fix | [Analysis](ANALYSIS.md), `ski-brainstorming` | [Project map](PROJECT_MAP.md), [domain](DOMAIN.md) |
| Analyze query cost | `ski-query-performance`, `db-schema-optimizer` | Exact query, table DDL/indexes, observed workload |
| Refresh knowledge | `ski-context-maintenance` | [Repository versions](generated/REPOSITORY_INDEX.md), source hashes, live metadata snapshot |
| Review inherited claims | [Accuracy audit](ACCURACY_AUDIT.md) | Child `EVIDENCE.md` and source |
| Review delivered work | [Changelog](CHANGELOG.md), [validation](VALIDATION.md) | Generated evidence and current Git status |

Canonical skills: [`.agents/skills`](../.agents/skills). JSON inventories are for targeted tooling/search; reading all 7 MB of source inventory into a conversation is unnecessary.
