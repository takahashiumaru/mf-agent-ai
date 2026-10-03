---
name: backend-security
description: Audit and enforce security controls, JWT token validation, SQL parameterization, and secret protection. Use whenever reviewing authentication, authorization, or input safety.
---

# Backend Security Skill

## Purpose
Protect the service against unauthorized access, privilege escalation, SQL injection, and secret leakage.

## When to Use
Use when modifying authentication logic in `auth/auth.go`, handling sensitive user data, or reviewing SQL parameterization.

## Workflow
1. **Understand**: Identify the trust boundary and external inputs.
2. **Inspect**: Verify user claims are extracted from JWT (`*auth.AccessDetails`), not untrusted request parameters.
3. **Plan**: Apply parameter binding to all dynamic SQL operations and enforce input validation.
4. **Implement**:
   - Ensure `ACCESS_SECRET` is loaded securely via Viper.
   - Use `helper.ApplyFilter` for safe parameterized queries.
   - Prevent secret values from appearing in logs or error messages.
5. **Verify**:
   - Verify unauthenticated requests return `401 Unauthorized`.
   - Run `go vet ./...`.

## Hard Rules
- Never concatenate raw user input into SQL query strings.
- Never log authentication tokens or database credentials.

## References
- [.agent/SECURITY.md](../../SECURITY.md)
- [.agent/CONSTRAINTS.md](../../CONSTRAINTS.md)
