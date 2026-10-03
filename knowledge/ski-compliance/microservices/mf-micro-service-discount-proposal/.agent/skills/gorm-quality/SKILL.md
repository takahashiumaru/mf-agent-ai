---
name: gorm-quality
description: Review and modify GORM queries, model definitions, zero-value updates, soft-delete filtering, and service-level transactions. Use whenever interacting with GORM or writing database repositories.
---

# gorm-quality

Guides safe GORM data access and persistence in `mf-micro-service-discount-proposal`.

## Core References
- [GORM_BEST_PRACTICES.md](../../GORM_BEST_PRACTICES.md) — Zero-value update rules, soft deletes, transactions.
- [GORM.md](../../GORM.md) — GORM model tags, preloading, joins, raw SQL scans.
- [DATABASE.md](../../DATABASE.md) — MySQL schema, composite primary keys, table relationships.

## Standard Workflow
1. **Understand**: Identify whether the query is a Read, Create, Update, or Delete.
2. **Inspect Model**:
   - Check if model uses `gorm.DeletedAt` (auto-filtered) or `*time.Time` (requires explicit `deleted_at IS NULL`).
   - Check if primary key is compound (`DiscountProposal`, `CreditNote`, `CustomerBalance`).
3. **Plan Transaction & Query**:
   - Mutations MUST receive `tx *gorm.DB` initiated in the service layer.
   - For zero-value or nullable updates, prepare `Updates(map[string]interface{}{...})`.
   - Parameterize all dynamic predicates with `?`.
4. **Implement**:
   - Check `tx.Error` or `db.Error` immediately with `helper.PanicIfError(err)`.
   - Record audit history via `helper.CreateHistory(db, entity, action, userId)`.
   - Return callback closure `func()` if triggering async MSSQL ETL sync.
5. **Verify**:
   - `go vet ./...`
   - `go build -o /dev/null .`

## Hard Guardrails
- **NEVER** use `db.Updates(&struct)` when updating fields to `nil`, `false`, `0`, or `""`.
- **NEVER** use `db.Save()` for partial record updates.
- **NEVER** open separate transactions inside repositories; receive `db *gorm.DB` from service.
- **NEVER** interpolate SQL strings with `fmt.Sprintf` in `.Where()`, `.Joins()`, or `.Raw()`.
- **DO NOT** execute `AutoMigrate()` or `CreateConstraint()` at application runtime.
