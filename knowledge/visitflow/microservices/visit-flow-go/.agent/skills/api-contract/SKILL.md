---
name: api-contract
description: Use when changing routes, controllers, request or response DTOs, validation, HTTP statuses, errors, pagination, filtering, sorting, or JSON field semantics.
---

# API Contract

## Outcome

Make deliberate, compatible API changes without normalizing unrelated legacy behavior.

## Required Reading

Read `../../../AGENTS.md`, `../../API.md`, `../../ERROR_HANDLING.md`, the route/controller/service, affected DTOs and mappers, and relevant tests.

## Characterize First

Record the current:

- route path and HTTP method;
- authentication wrapper and role/ownership expectations;
- request JSON names, types, validation, and optional/required semantics;
- distinction among omitted, zero, empty, false, and explicit `null`;
- response envelope, field names, omitted/null behavior, enums/status values;
- success and error HTTP status codes and error shape;
- pagination metadata, filter allowlists, sorting, and defaults.

Do not infer a desired contract from inconsistent sibling endpoints. Confirm the affected endpoint and consumer expectation.

## Rules

- Keep parsing and HTTP response construction in `controller/`; keep business decisions in `service/`.
- Reuse request/response DTOs rather than exposing GORM models directly.
- Do not casually rename/remove fields, change types, reinterpret `null`, or alter status codes.
- Preserve current behavior unless the requested change explicitly authorizes a contract change.
- Treat enum/status vocabulary as a compatibility boundary; trace it through domain constants, validation tags, persistence, and clients.
- Keep dynamic filter/sort column names behind closed allowlists.
- When a breaking change is required, identify it explicitly and describe migration/versioning needs.
- A `*bool` or other pointer can distinguish omitted from zero, but ordinary JSON decoding may not distinguish omitted from explicit `null`; use presence tracking only when the contract requires it.

## Repository Examples

- PREFERRED: `../../../controller/company_controller_impl.go` constructs `web.WebResponse` and delegates business behavior.
- PREFERRED: `../../../model/domain/` `To...Response` methods map persistence/domain values into API DTOs.
- ACCEPTABLE: `helper.FilterFromQueryString` calls with literal allowlists constrain dynamic filters.
- LEGACY — DO NOT COPY AS A GLOBAL STANDARD: status and validation behavior varies among endpoints; preserve or deliberately migrate the scoped contract.

## Testing

Apply `../go-testing/SKILL.md`. Cover valid input, validation failures, omitted/zero/null semantics, auth/ownership, not found, response JSON, status codes, error envelope, pagination/filter/sort behavior, and regression cases.

## Completion Gate

- Contract delta is written down.
- DTOs, mappers, controllers, services, interfaces, mocks, and tests agree.
- Breaking changes and unverified consumer assumptions are clearly identified.
