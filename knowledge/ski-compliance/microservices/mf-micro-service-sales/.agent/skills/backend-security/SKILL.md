---
name: backend-security
description: Use when reviewing authentication, JWT token validation, SQL injection prevention, input sanitization, and permission verification.
---

# Backend Security Skill

## Guidelines
1. **JWT Verification**: Protected endpoints must use `auth.Auth(...)` middleware with HMAC secret verification.
2. **SQL Injection Prevention**: Never concatenate raw strings into SQL queries. Always use GORM parameterized inputs.
3. **Input Validation**: Enforce strict validation tags on DTO fields (`required`, `max`, custom format validators like `ktp`, `npwp`).
4. **Secrets Protection**: Read secrets solely from Viper configuration; never commit secrets to git.

See [.agent/SECURITY.md](../../SECURITY.md), [.agent/CONSTRAINTS.md](../../CONSTRAINTS.md), and [auth/auth.go](../../../auth/auth.go).
