---
name: backend-security
description: Audit and enforce backend security boundaries, JWT authentication, tenant hierarchy isolation, SQL parameterization, and secret protection. Use whenever reviewing or implementing security-critical code.
---

# backend-security

Guides security verification and trust boundary defense in `mf-micro-service-discount-proposal`.

## Core References
- [SECURITY.md](../../SECURITY.md) — Trust boundaries, JWT validation, SQL injection prevention, SSRF controls.
- [CONSTRAINTS.md](../../CONSTRAINTS.md) — Non-negotiable security guardrails.
- [TECH_DEBT.md](../../TECH_DEBT.md) — Identified security findings (`TD-001`, `TD-003`).

## Standard Workflow
1. **Trace Untrusted Input**:
   - Trace all client-supplied inputs (URL params, query strings, JSON body) to data stores.
   - Verify every query uses `?` parameter placeholders.
2. **Enforce Tenant & Hierarchy Isolation**:
   - Derive marketing hierarchy from `auth *auth.AccessDetails`, never from user-supplied request body fields.
   - Ensure users cannot query or mutate records outside their marketing structure.
3. **Verify Struct & Type Validation**:
   - Enforce regex validation tags in `model/web` (`validate:"required,period_month"`).
4. **Secret & Log Audit**:
   - Verify 0 plaintext credentials, tokens, or private endpoints in logs or source files.
5. **Verify**:
   - Run static analysis: `go vet ./...`.
   - Verify with negative security test cases (e.g. invalid tokens, out-of-territory IDs).

## Hard Guardrails
- **NEVER** use `fmt.Sprintf` or string concatenation to build SQL WHERE or JOIN clauses.
- **NEVER** trust client-supplied user IDs or role levels from the request body.
- **NEVER** hardcode credentials or commit secrets to git.
- **DO NOT** silently alter public API contracts when addressing security findings without explicit scoping.
