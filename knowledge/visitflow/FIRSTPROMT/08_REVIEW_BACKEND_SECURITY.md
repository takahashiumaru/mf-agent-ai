# 08 — Review Backend Security and Protect Business Contracts

## Scope

Review the requested Go/GORM/MySQL application surface and report evidence in English. This prompt also works independently of onboarding. Default to read-only inspection and safe local checks. Implement fixes only when the user requests remediation; a documentation or coverage request does not authorize behavioral fixes. Preserve unrelated user changes and leave work uncommitted.

## Establish trust boundaries

Identify entrypoints, authentication middleware, roles/permissions, tenant ownership, database access, external HTTP clients, file handling, background jobs and sensitive data. Trace representative untrusted inputs to sensitive operations. Inspect current source and relevant dependency versions; historical findings are leads, not confirmed current vulnerabilities.

## Review checklist

Apply each item to the actual architecture; explain inapplicable items.

1. **Authentication:** verify configured secrets, token verification and applicable required claims, expired/malformed token rejection, session handling, password/reset flows where present, and absence of fallback credentials. Never reproduce real secrets in findings.
2. **Authorization:** verify permissions for each sensitive action and object, including tenant-scoped lookups, updates, counts, exports, bulk operations and asynchronous jobs. Do not trust owner/company IDs supplied by the client. Check allowed and denied cases; possession of a valid token is not proof of authorization.
3. **SQL/GORM:** trace input into conditions, inline primary-key lookups, `Raw`, `Exec`, `Order`, `Select`, `Group`, `Table` and joins. Bind values and allowlist identifiers/expressions. Check empty scopes, association writes, writable-field allowlists and soft-delete behavior. Do not treat all GORM method arguments as automatically escaped.
4. **Files and outbound I/O:** inspect applicable path traversal, upload limits, file access controls, outbound destination validation and redirects. Enforce the intended network boundary even after URL resolution/redirects. Avoid active probing of private infrastructure.
5. **Resource consumption:** inspect request-size limits, pagination/export bounds, expensive filters, timeouts, context cancellation, retries and goroutine/pool limits. Report compatibility impact before changing established request limits.
6. **Browser/session controls:** assess cookies, CORS and CSRF for the credential mechanism actually used. Do not impose browser-session controls on unrelated server-to-server flows.
7. **Secrets, logs and dependencies:** inspect configuration defaults, safe error responses, sensitive logs, DB privileges and transport configuration. Run compatible repository security tooling where available. Triage dependency reports against version and reachable behavior; do not perform blanket upgrades.

## Verification

Use isolated synthetic fixtures for unauthenticated, unauthorized, cross-tenant, malformed, oversized and injection-shaped inputs. Assert the expected rejection and absence of writes/side effects, then verify legitimate requests still work. Preserve response contracts except for explicitly authorized security fixes; explain every intentional change.

Run applicable existing tests, `go vet ./...`, race checks and configured security analysis. When available and compatible, use `govulncheck ./...`; record tool version, scope, findings and unavailable prerequisites. A missing scanner is unverified, not clean. Consider bounded Go fuzz tests for risky parsers/validators without network or shared database access.

Do not execute exploit attempts, load tests or destructive scans against shared environments. Do not claim a full audit from a limited review or claim security solely from coverage, lint or scanner success.

## Findings and remediation

For each finding report severity, confidence, relative file/symbol, untrusted-input path, preconditions, affected data/action, safe reproduction evidence, smallest proposed fix, compatibility impact and required regression test. Distinguish confirmed defects from unresolved hypotheses and existing protections.

For authorized fixes, address one cause at a time, keep legitimate business behavior, and rerun relevant tests. If a security fix necessarily changes response or access policy, explicitly identify that change; never disguise it as optimization. Do not remove tenant checks or required transaction locks for performance.

Write the review to an existing report location or `SECURITY_REVIEW.md`, redacting sensitive details. Keep general rules in `.agent/SECURITY.md` if that knowledge base exists. Update the engineering changelog only when guidance changes. Report remaining exposure and verification gaps honestly.

## Official references

Verify applicability to the installed versions before adopting examples:

- [Go security best practices](https://go.dev/doc/security/best-practices): vulnerability analysis, fuzzing, race detection and reviewed dependency updates.
- [GORM security](https://gorm.io/docs/security.html): parameter binding and SQL-fragment injection risks.
- [OWASP authorization guidance](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html): least privilege, permission checks and authorization testing.

## Copy-and-run prompt

> Execute `FIRSTPROMT/08_REVIEW_BACKEND_SECURITY.md` for this repository. Review authentication, authorization, tenant isolation, GORM/SQL input handling, applicable file/network boundaries and resource exhaustion risks. Deliver evidence-backed findings and regression recommendations in English. Keep this run read-only except for the review report, and do not commit.
