---
name: backend-security
description: Use when handling request input, authentication, authorization, ownership, tenant scope, dynamic SQL, file access, uploads, secrets, tokens, or sensitive logs.
---

# Backend Security

## Core Principle

Authenticate, authorize, validate, and scope every sensitive operation explicitly. Existing insecure behavior is evidence of risk, not a pattern to copy.

## Required Workflow

`UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW`

Trace attacker-controlled input through controller, service, repository, filesystem/network calls, logs, and response output.

## Repository Risk Classification

- **PREFERRED:** parameter placeholders used by most repository `Where`, `Raw`, and join conditions.
- **PREFERRED:** authentication adapter in `auth/auth.go` for token parsing; still verify authorization separately.
- **DANGEROUS:** role authorization is commented out in `auth/auth.go`; route role slices do not currently enforce access.
- **DANGEROUS:** external pagination/search helpers can construct SQL fragments from request values. Allowlist column names/directions and bind search values locally.
- **DANGEROUS:** tracked/local secret-bearing artifacts such as `helper/service-account.json` and `configuration/.env` must never be copied, logged, documented, or baked into images.
- **MIGRATE-WHEN-TOUCHED:** leave-proof file path handling and upload logic should be reviewed for traversal, MIME/content validation, naming, and size enforcement.

## Review Checklist

- Authentication: token signature/expiry and failure behavior remain enforced.
- Authorization: role, ownership, company/tenant, and record-scope checks are explicit; prevent IDOR.
- SQL: request input never controls `Order`, `Select`, `Table`, `Joins`, `Raw`, or `Exec` syntax without an allowlist.
- Validation: required fields, lengths, ranges, enums, and cross-field rules are enforced before side effects.
- Mass assignment: copy only permitted DTO fields into domain/GORM models.
- Files: clean/contain paths, reject traversal, validate size and actual content type, and generate server-controlled names.
- Secrets: no passwords, JWTs, refresh tokens, service-account keys, API keys, DSNs, or private payloads in source, image layers, logs, or responses.
- Logs: identifiers may be useful; sensitive payloads and claims are not.
- External calls: use request context/timeouts, validate destinations, and handle failure without leaking internals.

## Rules

- GORM parameterization does not make dynamic identifiers safe.
- Never weaken auth, validation, tenant filters, or tests for convenience.
- Do not claim route authorization exists until the actual role check is restored and covered.
- For a new protected endpoint, missing role/ownership policy is a requirements blocker: ask the owner; do not invent roles or ship authentication-only access by assumption.
- Security fixes that change public authorization behavior require explicit compatibility/rollout review.

## Completion Gate

Add focused negative tests for unauthorized, wrong-company, wrong-owner, injection-shaped, and invalid-file input when relevant. Record any policy that still requires human confirmation.

Use `api-contract` for public behavior changes and `docker-production` for build/runtime secret handling. Read `.agent/CONSTRAINTS.md` for current restrictions.
