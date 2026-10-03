# Go Best Practices

These rules apply when writing, reviewing, refactoring, or optimizing Go in this repository. Repository compatibility matters, but unsafe legacy code is not a template for new code.

## Mandatory Pre-Implementation Check

Before writing or modifying Go/GORM code:

1. Understand the required behavior.
2. Trace the affected request and data flow.
3. Inspect the nearest preferred repository implementation.
4. Check Go correctness.
5. Check GORM correctness.
6. Check transaction correctness.
7. Check database/query performance.
8. Check relevant indexes.
9. Check existing tests and mocks.
10. Implement the smallest safe change.

Do not optimize blindly. For suspected slow queries, gather evidence from query structure, indexes, production metrics when available, and preferably an execution plan before making a major optimization.

## General Principles

Prefer:

- simple code over clever code;
- explicit behavior over hidden mutation, globals, or panic control flow;
- small functions with one clear responsibility;
- clear ownership of HTTP, business, transaction, and persistence concerns;
- minimal side effects and narrow mutation;
- code that can be tested without a running server or real database;
- the current `route -> controller -> service -> repository` dependency direction;
- composition and concrete types until an actual abstraction boundary exists.

Keep changes local. Do not use a small feature as an excuse to rewrite the architecture.

## Repository Pattern Classification

### PREFERRED

- Manual constructor injection in `route/users_route.go` and `route/role_route.go`.
- Controllers parsing HTTP and delegating, as in `controller/role_controller_impl.go`.
- Services owning multi-step business transactions, especially callback transactions in `service/user_service_impl.go`.
- Repositories receiving the database handle to use rather than opening their own connection.
- Web DTOs in `model/web` and response mapping methods on current domain models.
- Focused mock/service and sqlmock transaction tests in `test/user_service_test.go` and `test/session_refresh_coverage_test.go`.

### ACCEPTABLE FOR COMPATIBILITY

- Existing interfaces in each layer when they provide a real test seam.
- Combined domain/GORM models in `model/domain`; introducing a second model layer is not justified for a focused change.
- Standard-library logging where a structured logger is not already available, provided secrets are excluded.

### LEGACY OR MIGRATE-WHEN-TOUCHED

- Passing `*gin.Context` into services. New internal APIs should prefer `context.Context`; controllers pass `c.Request.Context()`.
- Pointer parameters for required scalar IDs such as `*int`. Prefer values unless nil has meaning.
- Returning only a value while panicking on repository errors. Prefer `(value, error)` in new APIs and migrate existing interfaces only with all callers/mocks/tests in scope.
- Large multi-responsibility methods such as authentication flows in `service/user_service_impl.go`. Extract only cohesive, testable steps when touching them; do not perform a wholesale rewrite.
- General-purpose additions to the broad `helper` package. Put new logic in the narrowest cohesive package.
- `fmt.Println` diagnostics and unstructured request logging.

### DANGEROUS—DO NOT COPY

- Hidden global dependencies such as the mutable database singleton in `auth/auth.go`.
- Fire-and-forget goroutines without bounded lifetime, cancellation, or shutdown ownership.
- Recoverable validation/business/database errors used as normal panic control flow in new code.
- Unsynchronized reads of shared maps while other goroutines write them, as in the current IP-blocking state.
- Logging credentials, passwords, JWTs, refresh tokens, database DSNs, SMTP secrets, or full device tokens.

## Error Handling

New code should return meaningful errors explicitly. Panic is appropriate for an unrecoverable programmer/startup invariant, not an expected invalid request, missing row, duplicate key, or business rejection.

- Never discard meaningful errors. If an error is intentionally ignored, explain why locally.
- Preserve identity when callers use `errors.Is` or `errors.As`.
- Wrap with `fmt.Errorf("operation: %w", err)` when additional context helps and the cause must remain discoverable.
- Use typed or sentinel errors for behavior callers need to distinguish.
- Decide at one boundary how an error becomes an HTTP response. Do not log and wrap the same error in every layer.
- Return errors from GORM transaction callbacks so rollback occurs.
- Treat cancellation and deadline errors as meaningful; do not translate all errors to generic database failures.

Repository compatibility: current repositories frequently call `helper.PanicIfError`, and `main.go` recovers those panics. When adding to an existing legacy interface, avoid an unrelated breaking migration. When the interface and its callers are already in scope, prefer explicit error returns and update manual mocks/tests together.

See `ERROR_HANDLING.md` for the current response mapping.

## `context.Context`

For new non-HTTP functions, `context.Context` should normally be the first parameter:

```go
func (r *Repository) FindByID(ctx context.Context, db *gorm.DB, id uint) (domain.User, error)
```

Rules:

- Start with `c.Request.Context()` in a controller and propagate it through service and repository/network calls.
- Use `db.WithContext(ctx)` before GORM operations when the provided DB is not already context-bound.
- Do not replace a request context with `context.Background()` inside the request flow.
- Do not store a request context permanently in a struct.
- Respect cancellation and deadlines for database and network work.
- Derive narrower timeouts only for a justified external operation, and always call the cancel function.

Current state: `goHelper.CreateTransaction` binds the request context, but most plain user/session GORM flows do not. This is legacy behavior, not the target for new code. Background contexts in `helper/notification_helper.go` belong to detached notification work, whose lifecycle is itself a legacy concern.

## Interfaces

- Create an interface at a real consumer/implementation boundary, not automatically for every struct.
- Prefer small interfaces containing only methods the consumer needs.
- Keep interfaces close to the consuming layer when a new design permits it.
- Do not create `BaseRepository`, `BaseService`, or a generic CRUD interface to remove superficial repetition.
- Before changing an existing interface, find all implementations and handwritten mocks under `test/`.

The current controller/service/repository interfaces are established compatibility boundaries and test seams. Preserve them for focused work; improve signatures only when the change scope includes all dependents.

## Dependency Injection

- Prefer explicit constructor injection, matching `route/*.go`.
- Constructors should validate only invariants they can meaningfully enforce; avoid hidden I/O.
- Pass dependencies through structs rather than package globals.
- Do not add service locators or dependency-injection frameworks to this small repository.
- Avoid adding another global like `auth.dbInstance`; where auth behavior is already being redesigned, inject a token-store/repository dependency explicitly.

## Functions and Control Flow

- Keep functions focused on one operation or orchestration step.
- Use early returns for invalid inputs and errors.
- Keep the success path easy to follow and nesting shallow.
- Name steps by business intent, not mechanics.
- Extract a helper only when it creates a meaningful abstraction or test seam.
- Do not split readable sequential code into many one-line functions.

There is no arbitrary maximum function length. Complexity, responsibility count, and testability are the reasons to extract.

## Structs and Pointers

- Use values for small required scalars and immutable configuration.
- Use pointers when mutation is intended, a value is expensive to copy, nil has domain meaning, or an existing interface requires it.
- Avoid pointers to interfaces and double pointers unless a library contract requires them.
- Use pointer fields in update DTOs when omission must be distinguished from an explicit zero/false/empty string.
- Keep receiver choice consistent: pointer receivers for mutable/service/repository structs; values for small immutable types.

Current domain nullable fields use pointers and `gorm.DeletedAt`. Follow the model being changed, but do not add a pointer merely because older ID parameters use one.

## Collections

- Return initialized empty slices when the JSON contract expects `[]`; current `To...Responses` methods do this.
- Nil slices are acceptable internally when nil and empty are semantically equivalent.
- Preallocate with `make(..., 0, len(source))` when the final size is known and the collection is material.
- Avoid copying large slices unnecessarily.
- Do not convert a set-based database operation into per-element queries.

## Concurrency

Do not introduce concurrency unless independent work is measurably or operationally worth parallelizing.

- Every goroutine needs an owner and a clear completion or shutdown path.
- Propagate cancellation and errors.
- Bound fan-out; never start unbounded goroutines from request-sized input.
- Protect all shared mutable state consistently and run race tests for concurrency changes.
- Keep database transactions out of goroutines unless each goroutine's DB/session semantics are explicitly safe.
- Do not capture loop variables or mutable request data unsafely.

The two independent structure lookups in `UserServiceImpl.VerifyPassword` are an established bounded parallel operation. The notification goroutines and process-local IP blocker are legacy patterns: do not copy their detached lifecycle or shared-state design.

## Package Design

- Keep HTTP code in `controller`, orchestration in `service`, persistence in `repository`, and contracts in `model/web`.
- Add code to an existing cohesive package before inventing a new layer.
- Do not turn `helper` into a larger miscellaneous dumping ground.
- Avoid circular-dependency workarounds; correct the dependency direction instead.
- Keep gateway proxy configuration separate from local identity business logic.

## Naming

- Follow Go initialism casing in new identifiers: `ID`, `URL`, `HTTP`, `JWT`, `DB`.
- Use concise package names and avoid stuttering.
- Prefer descriptive business names over inherited placeholder names such as constructor parameters named `city` or `product` in role code.
- Preserve public JSON and database names unless the requested change includes compatibility work.
- Use `ctx`, `tx`, `db`, and `err` only where their meaning is local and obvious.

## Logging

No repository-wide structured logger exists. Do not introduce a new logging framework for a small change.

- Log at the boundary that can act on or observe the failure.
- Include safe correlation data such as user ID, route, or operation when useful.
- Never log secrets or complete authentication/device tokens.
- Avoid duplicate logs across repository, service, middleware, and controller.
- Do not use `fmt.Println` for production diagnostics in new code.
- If broader logging work is explicitly requested, choose one injected structured logger and migrate coherently rather than mixing more styles.

## Comments

Comments should explain why a decision, constraint, or unusual query exists. Do not narrate obvious assignments. Document exported APIs when their contract is not self-evident, especially error behavior, transaction ownership, and security effects.

## New Code Rule

Choose patterns in this order:

1. a sound **PREFERRED** repository pattern;
2. idiomatic Go;
3. compatibility constraints with the affected legacy interface.

Never copy a poor legacy pattern solely because it already exists.
