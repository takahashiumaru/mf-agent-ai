# .agent/GO_BEST_PRACTICES.md — Go Engineering Standards & Idioms

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

This document establishes the repository-specific Go engineering standards for `mf-micro-service-discount-proposal`.

---

## 1. Design & Control Flow

### Simple, Explicit Control Flow with Early Returns
- **Classification**: `PREFERRED`
- **Applies when**: Implementing controller handlers, service validations, and repository methods.
- **Rule**: Prefer early returns / guards to reduce deep nesting. Avoid `else` blocks after returns or panics.
- **Why**: Keeps the happy path left-aligned and makes invariant enforcement easily readable.
- **Repository evidence**: `controller/discount_proposal_controller_impl.go:244-247`
- **Verification**: `go vet ./...` and code review.

### Layer-Separated Dependency Direction
- **Classification**: `PREFERRED`
- **Applies when**: Adding or refactoring application logic.
- **Rule**:
  - `Route` wires dependencies and registers endpoints on Gin.
  - `Controller` handles HTTP binding, query filter extraction, and calls Service.
  - `Service` orchestrates business logic, validations, and transaction lifecycles.
  - `Repository` executes database queries and audit snapshots.
  - Never import `*gin.Context` or `github.com/gin-gonic/gin` in `service/` or `repository/`.
- **Why**: Protects business logic from HTTP transport coupling and enables isolated unit testing.
- **Repository evidence**: `service/discount_proposal_service_impl.go`, `controller/discount_proposal_controller_impl.go`

---

## 2. Error Handling & The Panic-Recovery Architecture

### Panic-Based Layer Bailing (`helper.PanicIfError` & `exception.ErrorSendToResponse`)
- **Classification**: `PREFERRED`
- **Applies when**: Handling unexpected runtime errors or business validation failures within services and repositories.
- **Rule**:
  - For unexpected errors: call `helper.PanicIfError(err)`.
  - For business validation errors: call `panic(&exception.ErrorSendToResponse{Err: "Penjelasan error"})`.
  - Do NOT casually replace the repository's panic/recover architecture with multi-value error returns unless refactoring a self-contained pure helper function.
- **Why**: The transaction helper `helper.CommitOrRollback(tx)` and Gin middleware `app.ErrorHandler()` rely on panic interception to guarantee transaction rollback and format consistent HTTP responses.
- **Repository evidence**: `helper/error.go`, `exception/error_handler.go`, `helper/tx.go`
- **Verification**: Check that transaction rollback occurs on panic and HTTP 400 is returned to client.

### Never Swallow Errors Silently
- **Classification**: `DANGEROUS` (when violated)
- **Applies when**: Calling GORM operations, JSON serialization, or external HTTP requests.
- **Rule**: Every returned `error` MUST be evaluated immediately with `helper.PanicIfError(err)` or explicit handling.
- **Why**: Ignoring errors results in partial writes, corrupt audit logs, and silent failures in background jobs.
- **Repository evidence**: `service/discount_proposal_service_impl.go:149`, `exception/error_handler.go`

---

## 3. `context.Context` Propagation

### Request Context Status & Adoption Strategy
- **Classification**: `LEGACY` (Current State) | `PREFERRED` (Target Direction)
- **Applies when**: Writing new helper packages or designing new services.
- **Rule**:
  - In existing services/repositories, user identity is passed as `auth *auth.AccessDetails`. Do not perform global signature rewrites in ordinary tasks.
  - In new pure utility functions and external HTTP clients, accept `ctx context.Context` as the first parameter and pass it to `http.NewRequestWithContext`.
  - Never store `context.Context` inside long-lived struct fields.
  - Do not call `context.Background()` inside request flows when a parent context is available.
- **Why**: Enables request cancellation, timeout propagation, and OpenTelemetry trace propagation without breaking existing repository interfaces.
- **Repository evidence**: `app/router.go:93` (`otelgin.Middleware`), `auth/auth.go:21` (`AccessDetails`)

---

## 4. Interfaces & Dependency Injection

### Explicit Constructor Injection
- **Classification**: `PREFERRED`
- **Applies when**: Creating controllers, services, and repositories.
- **Rule**:
  - Structs must declare their dependencies as interface fields.
  - Constructors must accept interface parameters and return interface types:
    ```go
    func NewDiscountProposalService(
        discountProposal repository.DiscountProposalRepository,
        db *gorm.DB,
        validate *validator.Validate,
    ) DiscountProposalService
    ```
  - Avoid global state, singletons, and package-level mutable variables.
- **Why**: Allows injecting mock implementations during unit testing without real database connections.
- **Repository evidence**: `service/discount_proposal_service_impl.go:88`, `controller/discount_proposal_controller_impl.go:31`
- **Verification**: Verify that `go build -o /dev/null .` compiles without relying on hidden global variables.

---

## 5. Types, Pointers, Slices & Concurrency

### Pointer vs Value Semantics
- **Classification**: `PREFERRED`
- **Applies when**: Defining domain models and DTO structs.
- **Rule**:
  - Use pointer fields (`*float64`, `*bool`, `*string`, `*uint`, `*time.Time`) for database columns that are nullable.
  - Pass request/response structs by pointer (`*web.DiscountProposalCreateRequest`).
  - Pass domain slices by value (`domain.DiscountProposals`).
- **Why**: Distinguishes SQL `NULL` from zero-values (`0`, `false`, `""`) in database serialization.
- **Repository evidence**: `model/domain/discount_proposal.go:71-73`, `model/domain/credit_note.go:52-53`

### Managed Concurrency & Goroutine Boundaries
- **Classification**: `MIGRATE-WHEN-TOUCHED`
- **Applies when**: Dispatching asynchronous background tasks (e.g. MSSQL ETL sync).
- **Rule**:
  - Do NOT spawn unbounded, unmonitored goroutines (`go helper.EtlToMssql(...)`) without error logging or recovery guards.
  - Ensure any background worker captures panic with `defer recover()` and handles timeouts gracefully.
- **Why**: Uncaught panics inside spawned goroutines crash the entire Go HTTP process.
- **Repository evidence**: `repository/discount_proposal_repository_impl.go:469`, `helper/etl_to_mssql.go`

---

## 6. Logging, Sensitive Data & Comments

### Structured Logging & Zero Credential Leaks
- **Classification**: `PREFERRED`
- **Applies when**: Adding log messages or debugging output.
- **Rule**:
  - Never print or log sensitive customer information, plaintext tokens, passwords, or connection strings.
  - Avoid duplicate log entries across layers (logging the same error in repository, service, and controller).
  - Write comments explaining the *rationale* and *invariants*, not merely repeating what the code syntax does.
- **Why**: Protects customer confidentiality and prevents log file bloat in production.
- **Repository evidence**: `app/router.go:30` (stack trace on panic), `helper/login_mpi.go`
