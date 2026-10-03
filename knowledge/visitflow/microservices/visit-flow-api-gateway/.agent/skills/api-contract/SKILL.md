---
name: api-contract
description: "Change or review routes, handlers, request/response DTOs, validation, status codes, error shapes, pagination, filters, sorting, or other HTTP compatibility behavior."
---

# API Contract

Use with `go-testing`; add `backend-security` for authentication, authorization, uploads, or sensitive data.

Follow `UNDERSTAND -> INSPECT -> PLAN -> IMPLEMENT -> TEST -> REVIEW`.

## Identify the API Surface

This process exposes two distinct surfaces:

- KrakenD proxy routes in `configuration.json`.
- Local Gin identity/file routes assembled by `setupJWTRouter` and `route/*.go`.

Determine which listener owns the change. Do not implement downstream business logic locally merely because a proxy endpoint exists.

## Inspect Before Changing

Review:

- path, method, route parameters, and authentication wrapper;
- request content type and JSON/form field names;
- required/optional/zero/null semantics and validator tags;
- response JSON, `count_data`, messages, and null versus omitted fields;
- success/error status codes and error envelope;
- pagination/filter/sort defaults and bounds;
- callers/consumers when available;
- controller/service tests.

Do not rename/remove a field or change a status code casually. Identify any required breaking change explicitly.

## Repository Contracts

PREFERRED local JSON pattern — `controller/role_controller_impl.go` returns `web.WebResponse` and delegates behavior to the service.

PREFERRED route wiring — `route/role_route.go` and `route/users_route.go` explicitly declare auth wrapping.

ACCEPTABLE compatibility — current DTO mapping methods in `model/domain` return `model/web` responses. Do not expose new GORM models directly.

LEGACY inconsistencies requiring preservation or explicit migration:

- Most local responses use `web.WebResponse`, while auth middleware sometimes returns `gin.H{"error": ...}`.
- Record-not-found may map to HTTP 200/success.
- Most mutations return 200, while user creation returns 201.
- Some routes named `no-auth`, password reset, device token lookup, and refresh are unauthenticated by route design.

## Pagination, Filter, and Sort Safety

- Validate positive page/limit and enforce a maximum for potentially large lists.
- Preserve `count_data` unless changing the public contract.
- Allowlist filter fields/operators and sort columns/directions.
- Do not pass raw request strings into SQL fragments or GORM `Order`.
- Verify filters actually reach the query; current chain handling has known legacy bugs.

## Compatibility and Validation

- Adding an optional field is usually safer than changing/removing an existing one, but still review old clients.
- Distinguish omitted from explicit zero with pointer fields when patch semantics require it.
- Keep business validation in services and HTTP parsing in controllers.
- Never remove authentication/authorization/validation to make a test pass.
- Keep gateway header/query forwarding intentional; avoid forwarding sensitive headers unnecessarily.

## Test Gate

- Route and auth wrapper covered.
- Request binding/validation covered.
- Exact status and response/error shape asserted.
- Pagination/filter/sort compatibility tested when changed.
- Breaking behavior declared rather than hidden.

Read `../../API.md`, `../../ERROR_HANDLING.md`, and `../../DOMAIN.md` for current contracts.
