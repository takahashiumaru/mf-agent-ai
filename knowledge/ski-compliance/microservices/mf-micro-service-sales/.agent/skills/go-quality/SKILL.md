---
name: go-quality
description: Use when writing, modifying, or reviewing Go code to ensure idiomatic Go, clean error handling, struct conventions, and proper context propagation.
---

# Go Quality Skill

## Guidelines
1. **Idiomatic Go**: Write clean, readable, flat code with early returns.
2. **Error Handling**: Use `helper.PanicIfError(err)` for error propagation and preserve sentinel error types.
3. **Layer Separation**: Maintain strict boundaries between Controller, Service, and Repository layers.
4. **Context**: Ensure external client calls support cancellation and timeouts.
5. **Pointers vs Values**: Use pointers for DTOs and nullable/zero-value fields; use values for simple primitives.

See [.agent/GO_BEST_PRACTICES.md](../../GO_BEST_PRACTICES.md) and [.agent/CODE_STYLE.md](../../CODE_STYLE.md) for complete details.
