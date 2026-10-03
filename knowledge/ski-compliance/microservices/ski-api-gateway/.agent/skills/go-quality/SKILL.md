---
name: go-quality
description: Review and write high-quality, idiomatic Go code for ski-api-gateway. Use whenever writing, reviewing, or refactoring Go handlers, middleware, helpers, or packages.
---

# Go Quality Skill

## Purpose & Trigger
Enforce clean, idiomatic, error-safe, and race-free Go code across all `ski-api-gateway` packages.

## Workflow
1. **Understand**: Identify target package responsibility (`cmd/`, `pkg/app`, `pkg/auth`, `pkg/config`, `helper/`, `exception/`).
2. **Inspect**: Check function signatures, error returns, context propagation, and mutex usage.
3. **Plan**: Formulate the minimal change adhering to early returns and explicit error checking.
4. **Implement**: Write code with clean error formatting (`fmt.Errorf("...: %w", err)`), avoiding unchecked panics.
5. **Verify**: Run `go fmt ./...`, `go vet ./...`, and `go test -race ./...`.

## Hard Rules
- Never ignore non-nil errors.
- Synchronize all shared mutable state with `sync.Mutex` or `sync.RWMutex`.
- Format code with standard `go fmt`.
