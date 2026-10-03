# Go best practices

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Design and readability

- **MUST** keep control flow explicit, return early on errors, and give functions/packages clear responsibility.
- **SHOULD** compose the existing route/controller/service/repository pieces; add an abstraction only at a real caller or test seam.
- **AVOID** arbitrary function-length limits, package-wide rewrites, and interfaces without a substitution need.
- Follow adjacent naming, pointer/value, nil/empty-slice, and constructor conventions; these are not fully uniform repository-wide.

## Errors

- **MUST** check meaningful errors and preserve identity when callers rely on `errors.Is`/`errors.As`.
- **SHOULD** distinguish input, not-found, business, and infrastructure failures while preserving HTTP compatibility.
- **AVOID** ignoring errors, converting every error to panic, or logging the same failure at multiple layers.
- Existing paths use `helper.PanicIfError` and router recovery; preserve those boundaries until a scoped migration. JWT handling must be assessed at actual middleware call sites; see [SECURITY.md](SECURITY.md).

## Context

- New code **SHOULD** pass request context to database/network operations where supported; put it first, do not store it in long-lived structs, and respect cancellation.
- Existing service/repository interfaces generally do not expose context. Wider propagation is MIGRATE-WHEN-TOUCHED; change one flow with interface/caller review.
- **AVOID** replacing request context with `context.Background()` inside request work. Process bootstrap contexts are a separate concern.
- Official Go guidance: https://go.dev/doc/database/cancel-operations

## Interfaces, types, and concurrency

- Introduce small interfaces at real consumer-owned boundaries only.
- Keep request-driven slices/maps bounded; optimize allocations only after identifying a hot path.
- Every goroutine needs an owner, cancellation, error path, and concurrency bound. Do not add concurrency without measurement.
- Run race checks for concurrency changes when the environment supports them.

## Names, logs, comments, and security

- Use idiomatic Go names while preserving public identifiers and JSON/GORM tags.
- Comments explain invariants, why, or non-obvious trade-offs.
- Logs should provide useful operation/correlation context without tokens, secrets, or sensitive request bodies.
- Do not expose SQL internals, stack traces, filesystem paths, or credentials in public errors.
