# Security Standards & Trust Boundaries

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document defines the security architecture, trust boundaries, authentication mechanisms, authorization rules, and data protection guidelines for `mf-micro-service-sales`.

---

## 1. Trust Boundaries & Authentication

### JWT Authentication
- **Token Verification**: Protected routes use the `auth.Auth(...)` middleware ([auth/auth.go](../auth/auth.go)) which validates HMAC SHA256 JWT tokens using `config.Get("JWT_KEY")`.
- **Claims Extraction**: Decoded claims (`auth.JwtCustomClaims`) provide `UserID`, `Username`, `CompanyID`, `LevelID`, `Roles`, and `DistributorID`.
- **No Insecure Fallbacks**: Production configurations must never use hardcoded, empty, or default JWT secret keys.

```
[External Client / Frontend]
         │ (Authorization: Bearer <token>)
         ▼
[Gin HTTP Router (app/router.go)]
         │
         ▼
[auth.Auth Middleware] ─── Validates JWT Signature & Expiry
         │
         ▼ (Stores Claims in gin.Context)
[Controller Layer]
```

---

## 2. Authorization & Tenant Isolation

- **Scope Derivation**: Tenant scope (`CompanyID`, `DistributorID`) must always be derived from authenticated JWT claims or verified against user role permissions, never blindly trusted from client request parameters.
- **Role Verification**: Actions on sensitive data (e.g. Closing validation, Claims approval, Target Marketing generation) must verify that the caller possesses required roles.
- **Audit Logging**: All mutation operations (Create, Update, Delete) record user attribution via `helper.CreateHistory(...)` with `user_id` and timestamp.

---

## 3. Input Validation & SQL Injection Prevention

### SQL Parameterization
- **Strict Rule**: Never concatenate untrusted strings, user input, or request parameters directly into raw SQL query strings.
- **GORM Safe Expressions**: Always use parameterized placeholders (`?`) with bound arguments:
  ```go
  // SAFE: Parameterized
  tx.Where("distributor_id = ? AND period = ?", req.DistributorID, req.Period)

  // DANGEROUS: Do NOT concatenate raw input
  // tx.Where(fmt.Sprintf("distributor_id = '%s'", req.DistributorID))
  ```
- **Filter Whitelisting**: Dynamic sorting and filtering via [helper/filter.go](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/helper/filter.go) must only accept validated column names and allowed operators (`eq`, `in`, `like`, `gte`, `lte`, `between`).

### Request DTO Validation
- All request structs must declare Go Playground Validator tags (`validate:"required,..."`).
- Custom validators in [helper/custom_validator.go](../helper/custom_validator.go) validate formatted inputs such as KTP and NPWP.

---

## 4. Sensitive Data & Secrets Management

- **No Secrets in Source Code**: Secrets, database passwords, and API tokens must be loaded exclusively via Viper from environment variables / `.env` ([configuration/configuration.go](../configuration/configuration.go)).
- **Log Sanitization**: Passwords, tokens, and PII must never be written to stdout or OpenTelemetry traces.
- **Error Obfuscation**: Internal database error details or SQL stack traces must not be leaked to the client response; the global error handler in [exception/error_handler.go](../exception/error_handler.go) returns structured, sanitized error messages.

---

## 5. Security Review Checklist

Before completing security-sensitive changes, verify:
- [ ] Endpoint is protected by `auth.Auth` middleware unless intentionally public.
- [ ] User ID and tenant identifiers are extracted from verified JWT claims.
- [ ] All database queries use parameterized GORM queries (`?`).
- [ ] No raw string concatenation or unsanitized `ORDER BY` clauses exist.
- [ ] Input DTO has proper validation tags and passes `validator.Struct(req)`.
- [ ] Mutation operations trigger `helper.CreateHistory(...)` for audit trail.
- [ ] No secrets, tokens, or private credentials are hardcoded or logged.
