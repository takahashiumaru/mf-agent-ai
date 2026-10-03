---
name: api-contract
description: Use when changing routes, handlers, request or response DTOs, validation, HTTP statuses, errors, pagination, filters, sorting, or public enum values.
---

# API Contract

## Core Principle

Treat current externally observable behavior as a contract, including inconsistent legacy behavior. Make breaking changes explicit; do not normalize incidentally.

## Required Workflow

`UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW`

Trace route registration, auth adapter, controller parsing, web DTOs, service validation, error mapping, and handler tests before editing.

## Repository Pattern Classification

- **PREFERRED:** route/controller separation in `route/office_route.go` and `controller/office_controller_impl.go`.
- **PREFERRED:** public request/response types in `model/web/`; controllers should not expose `model/domain` GORM structs directly.
- **PREFERRED:** response envelope defined by `model/web/web_response.go` with `success`, `total_data`, `message`, and `data` behavior.
- **ACCEPTABLE COMPATIBILITY:** most successful operations return HTTP 200, and some not-found cases return a success-shaped HTTP 200. Do not change this globally during unrelated work.
- **LEGACY:** inconsistent routes, status strings, and misspelled public identifiers such as `qouta`; preserve unless a versioned migration is required.
- **DANGEROUS:** assuming route role arrays enforce authorization. `auth/auth.go` currently has the role check commented out.

## Contract Review

Inspect and preserve unless requirements say otherwise:

- path and HTTP method;
- JSON/form field names and required/optional/null/omitted semantics;
- validation messages and enum/status values;
- response JSON, `total_data`, success flag, and status code;
- error response shape from `exception/error_handler.go`;
- pagination defaults/limits and filtering/sorting semantics;
- multipart limits and file behavior;
- authentication, company scope, ownership, and authorization.

## Input and Query Safety

- Bind and validate into `model/web` DTOs using the established validator flow.
- Allowlist public sort/filter identifiers before mapping them to columns. Bind values; never pass request text directly into SQL fragments.
- Clamp list limits and keep deterministic ordering.
- Do not mass-assign request DTOs into GORM models when the caller should not control every field.

## New Endpoint Shape

Follow the existing vertical slice: route → controller/interface → service/interface → repository/interface/implementation if persistence is needed → DTO/model mapping → focused tests. Wire dependencies manually in `route/`.

## Completion Gate

Add contract tests for meaningful success/error paths, validation, tenant/ownership behavior, response envelope, status, and zero/omitted fields. If a breaking change is necessary, name affected consumers and rollout strategy explicitly.

Read `.agent/API.md`, `.agent/ERROR_HANDLING.md`, and `.agent/DOMAIN.md` for current semantics.
