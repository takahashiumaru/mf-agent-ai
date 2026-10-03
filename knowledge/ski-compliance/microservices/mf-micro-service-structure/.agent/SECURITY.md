# Security & Access Control Guide — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document defines trust boundaries, authentication mechanisms, authorization requirements, and data protection practices for `mf-micro-service-structure`.

---

## 1. Trust Boundaries & Authentication

- **JWT Authentication (`auth/auth.go`)**:
  - Tokens are parsed using HMAC SHA256 and signed with `ACCESS_SECRET`.
  - Claims must include `id` (uint), `nip` (string), `name` (string), `role` (string), `level` (string).
  - Production environments must never use default or fallback secrets.
- **Access Details Extraction**:
  - Valid tokens inject `*auth.AccessDetails` into protected controller handlers.
  - User ID and role must be derived exclusively from verified JWT claims, never from user-supplied request body parameters.

---

## 2. Input Validation & SQL Parameterization

- **Structured Validation (`helper/custom_validator.go`)**:
  - Request DTOs are validated using Go Playground Validator before reaching business logic.
  - Periods are strictly validated against `YYYYMM` patterns.
- **SQL Injection Prevention (`helper/apply_filter.go`)**:
  - Column identifiers are sanitized and split into table/column components.
  - Filter values are bound to placeholders (`?`) for `=, >, <, >=, <=, LIKE, IN` operators.
  - Dynamic raw string interpolation into SQL clauses is prohibited.

---

## 3. Data Protection & Secrets Management

- **Environment Configuration**:
  - Secrets (`ACCESS_SECRET`, `PASSWORD_DB`) are loaded from environment variables via Viper (`configuration/configuration.go`).
  - `.env` files containing credentials must be excluded in `.gitignore`.
- **Sensitive Data in Logs**:
  - Never log JWT tokens, passwords, or raw employee personal identity numbers (NIK/KTP) in log statements or error messages.
- **Audit Trails**:
  - Sensitive master data operations (reassignments, deletions, period locks) are permanently recorded in the `histories` table with `created_by_id` and timestamp.
