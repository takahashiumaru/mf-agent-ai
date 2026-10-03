---
name: go-quality
description: Review, write, and maintain clean Go code adhering to repository architecture, panic-recovery error flow, and layer boundaries. Use whenever modifying or reviewing Go source files.
---

# go-quality

Guides writing and reviewing Go code in `mf-micro-service-discount-proposal`.

## Core References
- [GO_BEST_PRACTICES.md](../../GO_BEST_PRACTICES.md) — Standard Go idioms, error architecture, constructor DI.
- [ARCHITECTURE.md](../../ARCHITECTURE.md) — 5-tier layer separation and dependency direction.
- [CODE_STYLE.md](../../CODE_STYLE.md) — Naming conventions, constructors, slice aliases, mapper methods.

## Standard Workflow
1. **Understand**: Identify the target package (`controller`, `service`, `repository`, `helper`).
2. **Inspect**: Check layer separation rules; verify no `*gin.Context` enters service or repository layers.
3. **Plan**: Design simple, explicit control flow with early returns; design constructor injection.
4. **Implement**:
   - Use `helper.PanicIfError(err)` for infrastructure errors.
   - Use `panic(&exception.ErrorSendToResponse{Err: "..."})` for business validation errors.
   - Pass user context via `auth *auth.AccessDetails`.
5. **Verify**:
   - `go fmt ./...`
   - `go vet ./...`
   - `go test ./...`
   - `go build -o /dev/null .`

## Hard Guardrails
- **NEVER** import `github.com/gin-gonic/gin` into `service/` or `repository/`.
- **NEVER** swallow errors silently; always evaluate returned `error` values.
- **NEVER** spawn unbounded goroutines without panic recovery (`defer recover()`).
- **DO NOT** replace the established panic/recover architecture with multi-return errors across existing layers.
