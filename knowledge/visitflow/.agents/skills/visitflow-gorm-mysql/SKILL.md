---
name: visitflow-gorm-mysql
description: Use when changing or reviewing VisitFlow GORM models, MySQL repository queries, tenant filters, transactions, schema alignment, or multi-write flows.
---

# VisitFlow GORM and MySQL

## Purpose and scope

Protect data correctness across the VisitFlow Go services that use GORM: `visit-flow-go`, `visit-flow-presence`, `visit-flow-survey-location-go`, and the local identity API inside `visit-flow-api-gateway`. Payroll stores slip files locally and does not have a payroll GORM repository in this workspace.

This skill belongs to the VisitFlow umbrella workspace outside the six service Git repositories. Locate the current checkout and read its `AGENTS.md`, `.agent/INDEX.md`, `.agent/DATABASE.md`, `.agent/GORM.md`, and the nearest service/model/repository before acting. Use the `visitflow-go-backend` skill as well when changing application code.

## Establish the data contract

1. Identify the operation, its actor, tenant/company, structure or user scope, business period, and expected rows. Never infer access scope from a route's role slice alone.
2. Read the GORM model, its `TableName`, tags, embedded `gorm.Model`, associations, and any mapping to `model/web` DTOs. Check the repository's actual SQL and the caller's transaction handle.
3. Compare model fields and index tags against the relevant `.agent/DATABASE_SCHEMA.md` and root schema artifacts if available. The umbrella `DATABASE_SCHEMA_CATALOG.md` is a dated database snapshot, while `database_schema.sql` is a local dump; neither proves the current target database schema. If live schema access is authorized and available, inspect it before a migration or index claim.
4. Record nullable fields, composite keys, uniqueness, foreign keys, soft-delete predicates, timestamp/audit fields, and the exact columns used by filters and joins.

## Tenant and ownership boundary

- For core visits and MCL, check `company_id`, `structure_id`, period, and subordinate visibility in the relevant service and repository. `visit-flow-go/repository/visit_customer_repository_impl.go` is a useful example, but not every method there has the same scope.
- For presence, trace user, company, office, leave category/quota, and approval ownership. A `JOIN` must preserve the business key, including company and period when they are part of the relationship.
- For survey records, check company ownership of outlet survey, customers, questions, distributor, and materials across reads and writes.
- For gateway identity, distinguish a user's own record from administrator or organization queries; joins with `structures` use period and company data. Check Redis cache keys and invalidation when query results are cached.
- Parameterize values in `Where`, `Raw`, `Exec`, and joins. Build dynamic column/order expressions only from a closed allowlist. A filter helper returning `*gorm.DB` must have its returned handle retained.

## Transaction and write integrity

- The service orchestrating the business operation normally owns its transaction. Pass that exact handle through every repository call participating in the write. Do not escape to a root DB or a read replica midway.
- Core and survey commonly use `go-helper` `DatabaseResolver` with `Read` and `Write`; presence mixes resolver flows with direct `Begin`; gateway identity has direct transactions, resolver legacy, and callback transactions for atomic login/refresh flows. Inspect the nearest existing path instead of applying one pattern to every service.
- Use the write connection for a read that must see earlier writes in the same operation. Check rollback behavior on validation, not-found, SQL failure, and side-effect failure.
- `Updates(struct)` omits zero values; use an explicit allowlisted map, `Select`, or pointer fields when `false`, `0`, empty string, or NULL is intentional. Treat `Save` as full-object persistence.
- Check `.Error` and `RowsAffected` when the business rule requires exactly one changed row. Ordinary `Delete` on `gorm.Model` is soft delete; `Unscoped` is an explicit hard-delete decision.
- Database commit cannot roll back Firebase, SMTP, file writes, or HTTP calls. State their order and failure/retry policy. Avoid long network calls while holding a transaction unless the existing business invariant requires it.
- Do not introduce `AutoMigrate` or apply DDL merely because a model tag changed. Establish the repository's actual schema rollout process and the target database first.

## Deliverable for a database change

Summarize the affected table/model, query or write path, tenant predicates, transaction boundary, schema evidence, compatibility impact, and checks actually performed. If the target database or production execution plan is unavailable, label that uncertainty explicitly rather than declaring the schema synchronized.

For substantial query cost or an index decision, use the `visitflow-query-performance` skill too.
