# .agent/SECURITY.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Backend Security Standards

This document establishes trust boundaries, threat models, and security rules for `ski-api-gateway`.

---

## 1. Trust Boundaries

- **Public Internet / Frontend Clients**: Untrusted. May attempt authentication bypass, JWT signature tampering, path traversal, injection attacks, or flood endpoints.
- **API Gateway (`ski-api-gateway`)**: Boundary enforcer. Validates IP reputation, parses CORS, inspects API keys, verifies JWT signatures, and maps routes.
- **Internal Docker Network**: Semi-trusted. Downstream microservices trust headers forwarded by the gateway.

---

## 2. Authentication Rules

1. **Cryptographic JWT Signature Verification**:
   - Every token must be verified using `jwt.VerifyToken` with the configured HMAC secret (`ACCESS_SECRET`).
   - Signing algorithms other than HMAC-SHA256 (e.g., `none` algorithm attacks) must be explicitly rejected.
2. **API Key Security**:
   - API keys are matched against `api_keys.json`.
   - Keys must have valid expiration timestamps (`exp`) and active roles.
   - Keys must not be passed in plain HTTP query parameters in production; header-based transit (`X-API-Key`) is preferred.
3. **Secret Isolation**:
   - Secrets must be injected via environment variables (`ACCESS_SECRET`, `REFRESH_SECRET`) and never hardcoded in source code.

---

## 3. Defense Against Denial of Service (DoS)

1. **IP Rate Tracking & Auto-Blocking (`helper/block_acces.go`)**:
   - Tracks 404 responses per client IP.
   - Blocks offending IPs after 5 wrong attempts for 30 minutes.
2. **Request Body Size Limits**:
   - Gin router should protect memory by bounding incoming request sizes for file uploads or JSON payloads.
