# .agent/DATABASE_PERFORMANCE.md — MySQL Query Performance & Optimization Standards

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

This document establishes the evidence-based database performance standards for `mf-micro-service-discount-proposal`.

---

## 1. Evidence-First Optimization Principle

Never recommend or apply database optimizations (indexes, query rewrites, schema changes) based on speculative inspection alone. Every optimization proposal MUST provide:
1. **Query Shape & Frequency**: The exact SQL query, execution context, and invocation volume.
2. **Current Execution Plan (`EXPLAIN`)**: Baseline query execution plan showing scan type (`ALL`, `index`, `range`, `ref`, `eq_ref`), examined rows, and temporary/filesort flags.
3. **Cardinality & Selectivity Analysis**: Cardinality of the filtered columns in the MySQL database.
4. **Before/After Measurement**: Measured latency, examined rows, and query count before and after the change.

---

## 2. Index Strategy & Left-Prefix Rules

### Composite Index Left-Prefix Matching
- **Classification**: `PREFERRED`
- **Applies when**: Writing WHERE conditions or JOIN clauses against composite-indexed tables.
- **Rule**:
  - In MySQL B-Tree composite indexes (e.g. `idx_discount_proposal` on `discount_proposals` or `idx_cqrs_credit_notes` on `credit_notes`), filters must query columns from left to right without skipping leading prefix columns.
  - SARGable queries must avoid wrapping indexed columns in functions (e.g. use `WHERE period = '202401'` rather than `WHERE SUBSTRING(period, 1, 4) = '2024'`).
- **Why**: Non-left-prefix queries and non-SARGable functions force MySQL into full table or index scans.
- **Repository evidence**: `model/domain/discount_proposal.go:32`, `model/domain/credit_note.go:32-36`

### Avoid Redundant & Overlapping Indexes
- **Classification**: `PREFERRED`
- **Applies when**: Proposing new indexes.
- **Rule**: If an index on `(A, B, C)` exists, do NOT add a new index on `(A)` or `(A, B)` because the existing composite index already covers them.
- **Why**: Every extra index increases INSERT/UPDATE/DELETE write amplification and buffer pool churn.
- **Repository evidence**: `app/database/before_auto_migrate.sql`

---

## 3. Eliminating N+1 Queries & Loop Queries

### Batching & Eager Association Loading
- **Classification**: `PREFERRED`
- **Applies when**: Fetching child entities (e.g. estimations, recipients, events) for a list of parent proposals.
- **Rule**:
  - Never execute GORM `Find` or `First` queries inside a Go `for` loop.
  - Use GORM `.Joins()` or eager loading with `IN (?)` batched lookups.
  - Process slice aggregations in memory or via single aggregated SQL queries.
- **Why**: Loop queries generate N+1 network roundtrips, causing latency amplification under production load.
- **Repository evidence**: `repository/discount_proposal_repository_impl.go:25-47` (`discountProposalJoins`)
- **Verification**: Verify query count remains O(1) regardless of returned item count.

---

## 4. Query Bounds & Large-Result Protection

### Mandatory Bounds on List Scans
- **Classification**: `PREFERRED`
- **Applies when**: Writing list and search repository queries.
- **Rule**:
  - All unbounded queries MUST include `.Limit(N)` or pagination filters (`period`, `date range`).
  - Avoid large `OFFSET` queries on deep pagination; prefer keyset/cursor pagination on primary keys where possible.
- **Why**: Prevents accidental loading of millions of rows into server RAM.
- **Repository evidence**: `repository/discount_proposal_repository_impl.go:47` (`.Limit(100)`), `repository/credit_note_repository_impl.go`

---

## 5. Transaction Duration & Lock Contention

### Minimizing Lock Hold Times
- **Classification**: `PREFERRED`
- **Applies when**: Writing transaction-heavy services.
- **Rule**:
  - Keep transaction scopes as short as possible.
  - Perform slow operations (HTTP calls, Excel parsing, file generation, complex CPU math) **before** opening `tx := s.DB.Begin()` or **after** `tx.Commit()`.
  - Never execute external HTTP requests inside an open database transaction.
- **Why**: Extended transactions hold row and table locks, leading to lock wait timeouts (Error 1205) and deadlocks (Error 1213).
- **Repository evidence**: `service/discount_proposal_service_impl.go:130`, `helper/tx.go`

---

## 6. Connection Pool Configuration & Monitoring

Database connection pool settings should be monitored in `app/database.go`:
```go
sqlDB, err := database.DB()
if err == nil {
    sqlDB.SetMaxIdleConns(10)
    sqlDB.SetMaxOpenConns(100)
    sqlDB.SetConnMaxLifetime(time.Hour)
}
```
- **Slow Query Logging**: GORM logger outputs queries exceeding `SlowThreshold = 1 * time.Second` with SQL statement and execution time to stdout.
