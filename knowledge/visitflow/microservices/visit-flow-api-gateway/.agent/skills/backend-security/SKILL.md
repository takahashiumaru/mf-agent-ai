---
name: backend-security
description: "Review or modify backend request handling, authentication, authorization, ownership, database input, uploads/files, secrets, or sensitive logging for security risks."
---

# Backend Security

Use for security-sensitive behavior; this is not permission for an unrelated full audit.

Follow `UNDERSTAND -> INSPECT -> PLAN -> IMPLEMENT -> TEST -> REVIEW`.

## Threat Review

Inspect the affected flow for:

- authentication and token/session validity;
- authorization, role enforcement, IDOR, ownership, and tenant/company isolation;
- SQL injection and unsafe dynamic identifiers/fragments;
- mass assignment and patch allowlists;
- input size/type/range validation;
- path traversal and file upload/access controls;
- secret/token/password exposure in code, logs, responses, images, or CI;
- insecure defaults and unauthenticated routes;
- concurrency/replay/race behavior.

Never weaken auth, authorization, or validation to make tests pass.

## Repository Security Baseline

PREFERRED:

- bcrypt password hashing in `service/user_service_impl.go`.
- HMAC signing-method checks in `auth/auth.go`.
- Database-backed access-token revocation and atomic single-use refresh consumption.
- Bound values in current `Where` and recursive `Raw` calls.
- Web response DTOs omit passwords/access/refresh tokens.

High-risk repository facts:

- Role checks in `auth.Auth` are commented out; route role lists are not enforced. Do not claim otherwise or silently change it in unrelated work.
- Several user routes are intentionally unauthenticated, including no-auth update/get and password reset. Confirm requirements before changing or relying on them.
- `GatewayAuthMiddleware` permits requests with no Authorization header; it validates only when a header is present.
- Raw `sort` and interpolated search helpers can create SQL-injection risk despite GORM.
- User/file multipart flows do not clearly enforce size/MIME limits.
- File serving composes a request path segment with a local directory; review canonicalization/containment before expanding it.
- Local environment and service-account files are sensitive; never reproduce their contents.
- Login queries retrieve sensitive full user rows; prefer narrow projections when touched.

## SQL and GORM

GORM parameterizes values, not arbitrary identifiers/fragments. Review request influence on `Order`, `Select`, `Raw`, `Exec`, `Table`, and `Joins`. Allowlist columns/directions and bind values. Never concatenate untrusted input.

For updates, build an explicit field allowlist; do not pass client maps or GORM models directly into mass updates.

## Tokens and Secrets

- Never log passwords, JWTs, refresh UUIDs/tokens, database DSNs, SMTP/API secrets, or private keys.
- Avoid returning sensitive fields in errors or responses.
- Preserve refresh replay prevention and access-token revocation transaction correctness.
- Use constant-time/standard cryptographic libraries; do not invent crypto.
- Treat default/fallback secrets and unauthenticated reset behavior as human-confirmation items before security changes.

## Files

- Enforce allowed path containment after cleaning/canonicalization.
- Bound request/file size and validate expected content type/extension/content.
- Generate server-controlled filenames and avoid trusting user names.
- Define overwrite, executable-content, and authorization behavior.

## Security Test Gate

- Unauthorized and forbidden cases covered.
- Ownership/company boundaries covered when relevant.
- Injection/path traversal/mass-assignment inputs rejected.
- Token replay/revocation behavior preserved.
- No secret appears in logs, responses, fixtures, Docker layers, or docs.

Read `../../CONSTRAINTS.md`, `../../API.md`, and `../../DOMAIN.md` for repository-specific rules.
