# .agent/PREFERRED_PATTERNS.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Preferred vs Legacy Patterns

This document defines preferred coding patterns for new or touched code in `ski-api-gateway`, contrasting them with legacy patterns that should not be replicated.

---

## 1. Authentication & Token Handling

- **PREFERRED**: Validate tokens cryptographically via `auth.VerifyToken(tokenString, secret)` before accessing any claim data.
- **LEGACY / AVOID**: Calling `jwt.ParseUnverified` to extract user ID or permissions without prior cryptographic verification.
- **Why**: Prevent privilege escalation from tampered or crafted tokens.

---

## 2. Configuration & State Management

- **PREFERRED**: Encapsulate managers in thread-safe structs with explicit methods and mutex protection (e.g., `ApiKeyManager` in `helper/api_key.go`).
- **LEGACY / AVOID**: Bare package-level global maps with uncoordinated reads/writes.
- **Why**: Thread safety, determinism in unit testing, and prevention of data races.

---

## 3. Error Handling in Middleware & Handlers

- **PREFERRED**: Use `c.AbortWithStatusJSON(status, gin.H{"error": ...})` or structured error responses returned through the standard middleware chain.
- **ACCEPTABLE (Legacy)**: Calling `helper.PanicIfError(err)` for unrecoverable errors intercepted by `app.ErrorHandler()`.
- **AVOID**: Direct `panic("...")` with unformatted strings that bypass structured error envelopes.

---

## 4. Reverse Proxying & Upstream Communication

- **PREFERRED**: Clean director functions on `httputil.ReverseProxy` setting scheme and host, forwarding standard tracing headers (`X-Request-ID`, `X-Forwarded-For`).
- **LEGACY**: Modifying custom headers ad-hoc (e.g., `req.Header["my-header"]`).
- **Why**: Ensure upstream services receive proper client IP and tracing context.
