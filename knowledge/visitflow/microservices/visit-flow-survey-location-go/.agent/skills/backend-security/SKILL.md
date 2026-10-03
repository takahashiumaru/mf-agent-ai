---
name: backend-security
description: Use when handling request input, authentication, authorization, tenant ownership, database queries, file access or uploads, secrets, logs, or sensitive responses.
---

# Backend Security

## Outcome

Preserve authentication, authorization, tenant isolation, input safety, and confidentiality across Visit Flow's HTTP-to-database path.

## Required Reading

Read `../../../AGENTS.md`, `../../CONSTRAINTS.md`, `../../API.md`, and the affected route, auth middleware, controller, service, repository, DTOs, and tests.

## Threat Review

For the changed path, examine:

- authentication and token validation;
- role, company, structure, subordinate, resource-owner, and period authorization;
- IDOR through identifier-only reads/updates/deletes;
- request validation and mass assignment;
- SQL injection and request-controlled identifiers;
- path traversal, filename handling, size/type validation, and upload destination;
- secrets or personal data in logs, errors, responses, files, and images;
- insecure defaults and bypass paths.

## Rules

- Never weaken authentication, authorization, ownership checks, or validation to make tests pass.
- Route middleware is not proof of resource authorization; enforce ownership where the resource is resolved or mutated.
- Preserve tenant predicates in reads, updates, deletes, joins, counts, and background work.
- Bind client input into dedicated DTOs and explicitly map allowed fields. Do not mass-assign a request into a persistence model.
- GORM parameterizes values, not arbitrary identifiers. Treat dynamic `Order`, `Select`, `Table`, `Joins`, `Raw`, and `Exec` fragments as injection-sensitive and allowlist them.
- Never log or return passwords, JWTs, access/refresh tokens, API keys, service-account data, private keys, connection strings, or full sensitive payloads.
- Treat configuration and any credential-bearing artifacts as sensitive; never copy values. Inspect existence before claiming a particular secret file is present.

## Repository Risks

- DANGEROUS: role checks in `../../../auth/auth.go` are currently commented; do not assume role authorization is active.
- DANGEROUS: identifier-only survey repository paths can permit cross-tenant access unless service/repository scope is verified.
- Treat configuration and any credential-bearing artifacts as sensitive; never copy values. Inspect existence before claiming a particular secret file is present.
- MIGRATE-WHEN-TOUCHED: hard-coded IP bypass and ad hoc auth exceptions require explicit business/security confirmation.
- PREFERRED: filter operators/columns are passed as controller-owned literals rather than raw user identifiers.

## Testing

Apply `../go-testing/SKILL.md`. Include unauthenticated, invalid-token, unauthorized role, cross-company/cross-structure, non-owner, invalid input, malicious filter/path, and redaction cases relevant to the change.

## Red Flags

- “The route is authenticated, so ID access is safe.”
- “GORM makes dynamic SQL safe.”
- “This auth check can be disabled temporarily.”
- “The credential is ignored by Git, so Docker cannot include it.”

Stop and resolve these claims with evidence.
