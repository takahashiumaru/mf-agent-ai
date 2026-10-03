# .agent/GO_BEST_PRACTICES.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Go Engineering Best Practices

Practical, high-impact Go standards for `ski-api-gateway`.

---

## 1. Flow Control & Code Structure

- **MUST**: Use early returns and guard clauses to minimize indentation depth.
- **MUST**: Give every long-lived goroutine a clear lifecycle owner, termination trigger, and context cancellation channel.
- **SHOULD**: Keep functions focused on a single responsibility; decompose monolithic handlers into helper functions or middleware.
- **AVOID**: Nested if-else trees greater than 3 levels deep.

---

## 2. Error Propagation & Context

- **MUST**: Inspect errors immediately; never discard non-nil errors silently using `_`.
- **MUST**: Preserve error chains using `fmt.Errorf("...: %w", err)` when wrapping errors so `errors.Is` and `errors.As` continue to function.
- **SHOULD**: Propagate `context.Context` (e.g., `c.Request.Context()`) to all outgoing I/O operations (HTTP requests, database calls).
- **AVOID**: Creating disconnected `context.Background()` inside active HTTP request flows.

---

## 3. Concurrency, Memory & Data Race Safety

- **MUST**: Guard all shared mutable in-memory maps or counters with `sync.Mutex` or `sync.RWMutex`.
- **MUST**: Run test suites with `-race` flag (`go test -race ./...`) before shipping changes.
- **AVOID**: Global mutable variables when dependency injection through structs is practical.
