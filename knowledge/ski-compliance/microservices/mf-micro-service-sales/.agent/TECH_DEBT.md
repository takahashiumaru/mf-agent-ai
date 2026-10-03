# Technical Debt Registry — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document catalogs known technical debt, legacy patterns, and risks in the codebase so future AI agents avoid replicating them.

---

## 1. High-Risk Technical Debt

### A. Lack of Context Propagation
- **Current State**: Controller handlers receive `c *gin.Context`, but Services and Repositories accept only raw IDs, DTOs, and `*gorm.DB` without `context.Context` (or `db.WithContext(ctx)`).
- **Risk**: Database operations cannot be cancelled if a client aborts the request, risking long-running hanging queries.
- **Classification**: `MIGRATE-WHEN-TOUCHED` (when introducing new service interfaces, support passing context where appropriate).

### B. Massive Service & Repository Files (e.g. `SalesFf`)
- **Current State**: [repository/sales_ff_repository_impl.go](../repository/sales_ff_repository_impl.go) is over 68KB and contains very large raw SQL queries and complex calculations.
- **Risk**: High risk of unintended regression when editing shared helper queries.
- **Classification**: `LEGACY` / `DANGEROUS`. Any changes to `SalesFf` require strict validation of existing formulas and testing.

### C. Panic-Based Error Propagation
- **Current State**: Services and repositories rely on `helper.PanicIfError(err)` and defer recovery middleware rather than returning `(Result, error)`.
- **Classification**: `ACCEPTABLE` for current repository consistency, but requires careful preservation of transaction rollback defers.

---

## 2. Pattern Classification Matrix

| Pattern | Category | Guideline for AI Agents |
| :--- | :--- | :--- |
| Layered Controller -> Service -> Repository | **PREFERRED** | Always follow this separation for new and touched code. |
| Transaction management via `service.DB.Begin()` & `defer helper.CommitOrRollback(tx)` | **PREFERRED** | Standard transaction pattern in this repo; do not alter. |
| Audit logging with `helper.CreateHistory` on mutation | **PREFERRED** | Retain for all create, update, delete operations. |
| Dynamic query filtering via `helper.ApplyFilter` | **PREFERRED** | Standard pattern for list endpoints. |
| Using `db.Save()` for partial record updates | **DANGEROUS** | Prohibited; use `Updates()` with explicit fields or pointers. |
| In-memory loops executing single DB queries (N+1) | **DANGEROUS** | Eliminate loops; replace with batch `IN` or `Joins`. |
| Unbounded `Find(&records)` without `.Limit()` on large tables | **LEGACY** | Add `.Limit(500)` or pagination when modifying list endpoints. |
| Runtime `AutoMigrate` execution | **DANGEROUS** | Strictly prohibited in production runtime. |
