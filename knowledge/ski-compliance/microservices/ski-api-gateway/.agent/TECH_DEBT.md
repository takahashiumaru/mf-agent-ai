# .agent/TECH_DEBT.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Technical Debt Inventory

This document catalogs technical debt items identified in `ski-api-gateway`, classified by operational risk and remediation complexity.

---

## TD-001 — Unverified JWT Parsing in CSV Access Authorization

- **Classification**: DANGEROUS
- **Evidence**: `pkg/auth/access_auth.go:156` uses `new(jwt.Parser).ParseUnverified(stringToken, jwt.MapClaims{})` when extracting token claims for user access checks.
- **Impact**: If `AuthCsv` or `Auth` is used without prior signature verification middleware, forged tokens could bypass role checks.
- **Scope**: `pkg/auth/access_auth.go`
- **Recommended Action**: Ensure `VerifyToken` is called first, or pass verified `AccessDetails` directly from the authenticated context instead of parsing unverified tokens.
- **Verification**: Unit tests with tampered/invalid signature tokens in `test/auth_test.go`.
- **Priority**: High

---

## TD-002 — Disk-Bound CSV Access Lookups on Every Request

- **Classification**: MIGRATE-WHEN-TOUCHED
- **Evidence**: `pkg/auth/access_auth.go:81` opens and unmarshals CSV files from disk (`file/user_access/<userID>.csv`) on every HTTP request matching an authorization check.
- **Impact**: Disk I/O bottleneck under concurrent load; file locking and permission errors could cause request timeouts.
- **Scope**: `pkg/auth/access_auth.go`
- **Recommended Action**: Implement an in-memory cache with TTL or mtime invalidation similar to `ApiKeyManager` in `helper/api_key.go`.
- **Verification**: Concurrency benchmark and load test under simulated user traffic.
- **Priority**: Medium

---

## TD-003 — Global Mutable State in IP Blocker without Distributed Coordination

- **Classification**: ACCEPTABLE / MIGRATE-WHEN-TOUCHED
- **Evidence**: `helper/block_acces.go:12-15` uses in-process maps (`ipAccessTracker`, `blockList`) protected by a local mutex.
- **Impact**: IP block counts and timers are local to a single process/replica. In multi-instance deployments, blocks are not synchronized across pods.
- **Scope**: `helper/block_acces.go`
- **Recommended Action**: For multi-replica production setups, migrate rate limiting and blocking to Redis or an ingress controller (e.g., NGINX / Traefik / Cloudflare).
- **Verification**: Verify local mutex thread-safety with `go test -race`.
- **Priority**: Low

---

## TD-004 — Request Body Dumping in Debug Helper

- **Classification**: MIGRATE-WHEN-TOUCHED
- **Evidence**: `helper/debug_http_request.go:15` executes `httputil.DumpRequest(c.Request, true)`, which reads and prints entire request payloads including headers to standard output.
- **Impact**: Could leak sensitive tokens, passwords, or PII into container logs if enabled in production.
- **Scope**: `helper/debug_http_request.go`, `helper/reverse_proxy.go`
- **Recommended Action**: Guard debug dumping behind a strict configuration flag (`c.Debug == true`) and sanitize `Authorization` and `X-API-Key` headers before logging.
- **Verification**: Test that debug dump is silenced or redacted in standard test/prod mode.
- **Priority**: Medium
