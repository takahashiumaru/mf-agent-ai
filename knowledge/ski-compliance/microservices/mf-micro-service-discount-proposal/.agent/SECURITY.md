# .agent/SECURITY.md — Backend Security, Trust Boundaries & Protection Standards

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

This document establishes the verified security controls, trust boundaries, and vulnerability prevention standards for `mf-micro-service-discount-proposal`.

---

## 1. Trust Boundaries & Authentication Flow

### JWT Authentication Architecture (`auth/auth.go`)
- **Mechanism**: Bearer JWT tokens signed with HMAC-SHA256 (`jwt.SigningMethodHMAC`).
- **Secret Management**: Loaded securely from `configuration/.env` (`ACCESS_SECRET`).
- **Trust Extraction**:
  - The JWT payload is verified and claims (`id`, `nip`, `name`, `role`, `level`) are mapped to `*auth.AccessDetails`.
  - Upstream services and handlers MUST trust user identity and organizational scope only from `*auth.AccessDetails`, **never** from unverified JSON body fields or query parameters.
- **Negative Test Case**: Request with an expired token, unsigned token, or mismatched HMAC algorithm (`alg: none`) must return HTTP 401 Unauthorized.

---

## 2. Authorization & Tenant Isolation

### Deriving User Scope from Authenticated Context
- **Classification**: `PREFERRED`
- **Applies when**: Reading or mutating discount proposals, credit notes, and customer balances.
- **Rule**:
  - Filter queries by user marketing hierarchy (`controller.DiscountProposalService.FindHierarchyCsv(auth)`).
  - Do NOT allow a client to view or modify proposals across different hierarchy territories by supplying arbitrary marketing structure IDs in the request body.
  - Re-enable and maintain endpoint role guards in `auth.Auth` (`TD-003`).
- **Why**: Enforces multi-tenant organizational structure boundaries across marketing teams.
- **Repository evidence**: `controller/discount_proposal_controller_impl.go:50-65`, `auth/auth.go`
- **Negative Test Case**: A Medical Rep (`MR`) must not be able to approve proposals or view reports outside their assigned territory.

---

## 3. SQL Injection & Input Validation

### Mandatory Parameterized SQL
- **Classification**: `PREFERRED`
- **Applies when**: Writing GORM queries, joins, subqueries, and raw SQL scans.
- **Rule**:
  - Every dynamic user value MUST be passed via `?` placeholder parameters.
  - NEVER interpolate variables directly into SQL queries using `fmt.Sprintf` or string concatenation (e.g. `TD-001`).
  - Allowlist sort fields and table column names before passing them to GORM `.Order(...)` or `.Select(...)`.
- **Why**: Completely neutralizes SQL injection attacks.
- **Repository evidence**: `helper/apply_filter.go:39`, `repository/discount_proposal_repository_impl.go:67`
- **Negative Test Case**: Input containing `' OR '1'='1` in query filters must be treated as a literal search string, never executed as SQL syntax.

### Input Allowlisting & Struct Validation
- **Classification**: `PREFERRED`
- **Applies when**: Handling incoming JSON payloads.
- **Rule**:
  - All request DTOs must enforce structural validation using `validator/v10` and custom regex tags (`period_month`, `period_day`, `npwp`, `ktp`, `discount_proposal_type`).
  - Reject unexpected or invalid values before passing them to the service layer.
- **Why**: Prevents malformed data from reaching the business logic and database.
- **Repository evidence**: `helper/custom_validator.go`, `model/web/discount_proposal_create_request.go`

---

## 4. Outbound Requests, Files & SSRF Prevention

### Destination & Path Traversal Controls
- **Classification**: `PREFERRED`
- **Applies when**: Calling external APIs (`ValidateClosing`, `ValidateBudget`) or handling file exports (`file/`, `file-web/`).
- **Rule**:
  - Outbound HTTP requests must only target allowlisted configuration endpoints (`NOCODE_URL`, `SYNC_URL`, `API_HOST`).
  - File generation paths must be strictly constructed using internal identifiers; sanitize any user-supplied filenames to prevent path traversal (`../`).
- **Why**: Prevents Server-Side Request Forgery (SSRF) and arbitrary file overwrite vulnerabilities.
- **Repository evidence**: `helper/validate_closing.go:40`, `helper/validate_budget.go`

---

## 5. Secret Protection & Sensitive Data Handling

### Credential Guardrails
1. **No Plaintext Secrets**: Passwords, API tokens, and JWT keys must be loaded exclusively via environment variables (`configuration/.env`), never hardcoded in source code or committed to git.
2. **Sanitized Error Responses**: Internal database errors (connection failures, table metadata, raw panic dumps) must be logged server-side and never returned verbatim to clients. Clients receive sanitized `web.WebResponse` envelopes.
3. **Database Least Privilege**: MySQL application user should only possess `SELECT`, `INSERT`, `UPDATE`, `DELETE` privileges on application tables; DDL operations (`DROP`, `ALTER`) should be restricted to migration execution.
