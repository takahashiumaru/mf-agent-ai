# Go Best Practices — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

Practical engineering guidelines for writing robust, readable, and idiomatic Go code in this repository.

---

## 1. Core Principles
- **Simplicity Over Cleverness**: Write clear, explicit, readable code. Avoid unnecessary reflection, generic wrappers, or convoluted abstractions.
- **Explicit Ownership & Layering**:
  - `controller`: HTTP binding, parameter parsing, envelope response formatting.
  - `service`: Input validation (`validator.Struct`), transaction management (`tx := db.Begin()`), and business orchestration.
  - `repository`: Database interaction via passed `*gorm.DB`, audit history logging, and ETL callbacks.
- **Early Returns & Flat Control Flow**: Minimize indentation depth. Handle failure conditions early.

---

## 2. Error Handling
- **Panic-and-Recover Flow**:
  - In this repository, unexpected errors and validation failures trigger `helper.PanicIfError(err)` or custom errors like `panic(&exception.ErrorSendToResponse{Err: "message"})`.
  - Service transactions catch panics using `defer helper.CommitOrRollback(tx)` to guarantee rollbacks before re-panicking.
  - The root Gin middleware `app.ErrorHandler()` intercepts all panics and delegates to `exception.ErrorHandler(c, err)`.
- **Preserve Error Identity**:
  - Do not wrap or obscure sentinel errors (`exception.ErrUnauthorized`, `exception.ErrPermissionDenied`, `gorm.ErrRecordNotFound`) where caller middleware or handlers rely on type checking.
  - Never swallow errors silently without logging or re-panicking.

---

## 3. `context.Context` Handling
- When introducing asynchronous operations, HTTP client calls (e.g. `FindDataEtl`, `ValidateClosing`), or long-running workers, ensure `context.Context` is passed as the first parameter.
- Never store `context.Context` permanently inside struct fields.
- Avoid using `context.Background()` inside active HTTP request flows when a request context is available.

---

## 4. Structs, Pointers, and Values
- **DTOs**: Pass DTOs by pointer (`request *web.BridgingOutletCreateRequest`) to prevent large memory copies.
- **Domain Entities**: Return pointers or type-aliased slices (e.g., `domain.BridgingOutlets`) from repositories.
- **Optional & Zero-Value Fields**: Use pointers (`*bool`, `*uint`, `*time.Time`) for fields that may legitimately hold Go zero values (e.g., `false`, `0`) to ensure GORM distinguishes between unset values and intentional zero values during updates.

---

## 5. Concurrency & Goroutines
- **Lifecycle Ownership**: Every goroutine must have an explicit owner.
- **ETL Synchronization**: Background goroutines triggered via `go helper.EtlToMssql(...)` or `go helper.SendRedisJob(...)` must capture necessary variables by value to prevent race conditions.
- **No Unbounded Spawning**: Avoid launching uncontrolled goroutines inside loops without rate limiting or worker pools.

---

## 6. Package Design & Naming
- Maintain cohesive packages without circular dependencies.
- Follow Go conventions for abbreviations: `ID`, `URL`, `HTTP`, `SQL`, `JSON` (e.g. `OutletID`, `SyncUrl`).
