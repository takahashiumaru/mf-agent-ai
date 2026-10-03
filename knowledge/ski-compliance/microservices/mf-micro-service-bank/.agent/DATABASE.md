# Database

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Technology and initialization

The module declares GORM `v1.25.1` and MySQL driver `v1.5.1` in `go.mod`. Database initialization is in `app/database.go`; inspect DSN construction and connection options there without printing environment values.

## Schema and persistence

The workspace now has a live metadata snapshot for the explicitly authorized SKI_MF_PROD connection: MySQL 8.4.2, observed 2026-09-27 01:34:40 UTC. See [schema guide](../../DATABASE_SCHEMA.md), [full catalog](../../DATABASE_SCHEMA_CATALOG.md), and [table DDL reference](../../database_schema.sql). These establish captured structure, not this repository's deployment configuration or current business totals.

Inspect model tags and explicit TableName methods against the exact repository query before choosing tables, columns, keys, periods or soft-delete filters. The [model index](../../.agent/generated/MODEL_INDEX.md) helps navigation without assuming GORM naming defaults.

`app/database.go` is initialization evidence, not proof of a release migration procedure. An AutoMigrate call with commented-out model arguments does not migrate those models. Inspect executable arguments and any before/after SQL-file calls. Do not start the application to inspect data: startup may have write side effects.

For actual results, use [authorized read-only access](../../.agent/DATA_ACCESS.md) and answer with data before SQL. Migration ownership, business retention policy and full deployment topology still require source/deployment evidence for the requested change.
