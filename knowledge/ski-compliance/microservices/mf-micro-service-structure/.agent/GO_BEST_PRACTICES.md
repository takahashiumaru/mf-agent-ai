# Go Best Practices — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document provides definitive guidelines for writing, reviewing, and refactoring Go code in `mf-micro-service-structure`.

---

## 1. Design & Readability

- **MUST** keep control flow explicit and linear. Use early returns to reduce indentation depth.
- **MUST** assign clear single responsibilities to controller, service, and repository layers.
- **SHOULD** prefer composition over inheritance or deep abstraction hierarchies.
- **AVOID** deep nesting (`> 3` levels). Extract nested loops or conditionals into private helper functions.

---

## 2. Error Handling & Recovery

- **MUST** never ignore errors silently (`_ = operation()`).
- **MUST** use `helper.PanicIfError(err)` for unexpected database and system failures to ensure rollback in `helper.CommitOrRollback(tx)` and translation in `exception.ErrorHandler(c, err)`.
- **MUST** use `*exception.ErrorSendToResponse` when raising explicit client-correctable business validation errors.
- **AVOID** duplicate error logging across layers; log only at the recovery boundary in `app/router.go`.

---

## 3. `context.Context` Propagation

- **SHOULD** pass request context `c.Request.Context()` to downstream database operations when using context-aware methods (`db.WithContext(ctx)`).
- **MUST NOT** store `context.Context` inside struct fields.
- **MUST NOT** pass `nil` as context; use `context.Background()` or `context.TODO()` only when no request context exists.

---

## 4. Interfaces & Dependency Injection

- **MUST** define interfaces where consumers require abstraction or test mocking (`service/*_service.go`, `repository/*_repository.go`).
- **MUST** use explicit constructor injection (`New<Entity>Service(...)`, `New<Entity>Controller(...)`).
- **AVOID** global state or singleton instances outside initial setup in `main.go`.

---

## 5. Structs, Types & Slices

- **MUST** use pointer receivers for methods that modify struct state or for large structs.
- **MUST** define slice aliases for domain models when implementing collection transformations (`type MarketingStructures []MarketingStructure`).
- **SHOULD** allocate slice capacity when the target size is known (`make([]web.OfficeResponse, 0, len(offices))`).

---

## 6. Concurrency & Goroutines

- **MUST** ensure every spawned goroutine has a clear owner, error handling path, and termination guarantee.
- **AVOID** spawning unmonitored background goroutines inside HTTP request handlers.
- **MUST** run tests with the `-race` flag when verifying concurrent code.
