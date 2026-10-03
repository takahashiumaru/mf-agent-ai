---
name: api-contract
description: Design, implement, and review REST API routes, request binding, custom validators, query filters, and response envelopes. Use whenever adding, changing, or reviewing HTTP endpoints.
---

# api-contract

Guides HTTP API design, validation, and serialization in `mf-micro-service-discount-proposal`.

## Core References
- [API.md](../../API.md) — Route registration, JWT authentication flow, custom validators, response envelopes.
- [ARCHITECTURE.md](../../ARCHITECTURE.md) — Controller responsibilities and request lifecycle.
- [WORKFLOWS.md](../../WORKFLOWS.md) — Workflow 1: Adding a new API endpoint.

## Standard Workflow
1. **Define DTOs in `model/web/`**:
   - Request struct with validation tags: `validate:"required,period_month"`.
   - Response struct with JSON tags matching existing client naming contracts.
2. **Implement Controller Handler (`controller/*_controller_impl.go`)**:
   - Parse body: `helper.ReadFromRequestBody(c, &request)`.
   - Parse query filters: `helper.FilterFromQueryString(c, "period.eq", "status.eq", ...)`.
   - Invoke Service passing `auth *auth.AccessDetails`.
   - Wrap response in `web.WebResponse` and return `c.JSON(http.StatusOK, webResponse)`.
3. **Register Route in `route/*.go`**:
   - Wrap handler with `auth.Auth(handler, []string{})`.
4. **Verify**:
   - `go vet ./...`
   - `go build -o /dev/null .`

## Hard Guardrails
- **ALWAYS** return JSON responses wrapped in `model/web/web_response.go` (`web.WebResponse`).
- **ALWAYS** return HTTP 200 OK for successful responses and empty query results (`"Record not found"`).
- **DO NOT** change existing JSON response property names or types to avoid breaking mobile/web clients.
- **DO NOT** put database queries or business calculations directly in controllers.
