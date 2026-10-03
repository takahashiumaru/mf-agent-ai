# SKI Compliance — project knowledge base

This workspace contains 16 repositories for SKI master data, commercial workflows, warehouse processing, integration, and gateway/configuration concerns. This guide links verified source navigation and a dated database structure snapshot.

## Start here

| Need | Read |
|---|---|
| Agent operating rules | [AGENTS.md](AGENTS.md) / [CLAUDE.md](CLAUDE.md) |
| Repository responsibilities and edit scope | [Project map](.agent/PROJECT_MAP.md) |
| Actual business data, then SQL | [Data answers](.agent/DATA_ANSWERS.md), [read-only access](.agent/DATA_ACCESS.md) |
| Better brainstorming and decisions | [Analysis workflow](.agent/ANALYSIS.md) |
| Domain and period semantics | [Domain](.agent/DOMAIN.md) |
| Schema guide | [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) |
| Six-repo model/schema findings | [Comparison report](.agent/generated/MODEL_SCHEMA_COMPARISON.md) |
| Columns, indexes, and foreign keys | [Complete visible-object catalog](DATABASE_SCHEMA_CATALOG.md) |
| Table DDL reference | [database_schema.sql](database_schema.sql) |
| Routes, models, dependencies | [Context index](.agent/INDEX.md) |
| Earlier documentation corrections | [Accuracy audit](.agent/ACCURACY_AUDIT.md) |
| What was checked and what remains unknown | [Validation](.agent/VALIDATION.md) |

## Captured evidence

- Static inventory: 16 Git repositories, 2,210 Go files parsed. Only 14 repositories contain scanned Go source. This is source navigation, not code coverage.
- Database metadata: `SKI_MF_PROD`, MySQL 8.4.2, captured **2026-09-27 01:57:48 UTC** (08:57:48 WIB).
- Visible structure: **183 base tables, 78 views, 4,354 columns across tables and views, 131 routines**. No triggers were visible to the account. Visibility is subject to privileges.
- The original `SKI_MF_PROD.sql` is retained unchanged. Its 185 table definitions differ from the live snapshot; see the catalog's set comparison.
- The schema export contains structure only. No actual business totals have been precomputed here.

## Maintenance

From this workspace root, refresh source navigation with:

```sh
GOWORK=off GO111MODULE=off go run .agent/tools/source_inventory.go . > .agent/generated/source_inventory.json
python3 .agent/tools/build_context.py
python3 .agent/tools/analyze_model_schema.py
```

To intentionally refresh database metadata within the existing authorization:

```sh
python3 .agent/tools/refresh_database.py
python3 .agent/tools/build_context.py
```

The refresh reads metadata and SHOW CREATE TABLE in read-only transactions. `database_schema.sql` is a reference artifact, **not a migration to execute**. Human-written guides may need review when generated evidence changes; regeneration does not automatically prove their continued accuracy.

## Repository README refresh — 2026-09-27

The latest README task covers 13 repositories; discount-proposal, structure and sales are excluded from README edits. Earlier seven-repository exclusions describe the previous context-generation task. Each updated README is in English and includes source-based setup, architecture and an endpoint/configuration inventory.

- [flexurio-nocode-api-config-mf-marketing](flexurio-nocode-api-config-mf-marketing/README.md)
- [flexurio-nocode-web-config-mf-marketing](flexurio-nocode-web-config-mf-marketing/README.md)
- [mf-micro-service-bank](mf-micro-service-bank/README.md)
- [mf-micro-service-customer](mf-micro-service-customer/README.md)
- [mf-micro-service-event](mf-micro-service-event/README.md)
- [mf-micro-service-marketing-user](mf-micro-service-marketing-user/README.md)
- [mf-micro-service-master-document-proposal](mf-micro-service-master-document-proposal/README.md)
- [mf-micro-service-outlet-2](mf-micro-service-outlet-2/README.md)
- [mf-micro-service-product](mf-micro-service-product/README.md)
- [rest-api-pondasi-mftl](rest-api-pondasi-mftl/README.md)
- [ski-api-gateway](ski-api-gateway/README.md)
- [ski-compliance-api-warehouse](ski-compliance-api-warehouse/README.md)
- [visit-flow-api-synchronize-ski-compliance](visit-flow-api-synchronize-ski-compliance/README.md)

The Go inventories list 1,241 local declarations, including registration status where relevant. No-code documentation separately lists 288 method configurations and 144 outgoing frontend request templates. Runtime-generated no-code paths and compiled frontend network behavior are explicitly distinguished from source declarations. No deployment or application tests were run for this documentation refresh.
