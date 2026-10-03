---
name: api-contract
description: Design, implement, and review Gin HTTP routes, request DTOs, custom validators, and response envelopes. Use whenever adding or modifying API endpoints or request/response structures.
---

# API Contract Skill

## Purpose
Ensure backward-compatible, well-validated HTTP API endpoints and consistent response envelopes.

## When to Use
Use when creating new REST endpoints, modifying request payloads, or adjusting status code mappings.

## Workflow
1. **Understand**: Check route path, HTTP method, authentication requirement, and DTO structures.
2. **Inspect**: Check existing routes in `route/*_route.go` and handlers in `controller/*_controller_impl.go`.
3. **Plan**: Define request/response models in `model/web/` with validation tags.
4. **Implement**:
   - Wrap protected routes with `auth.Auth(...)`.
   - Use `helper.ReadFromRequestBody` and `helper.FilterFromQueryString`.
   - Return standard `web.WebResponse` envelope.
5. **Verify**:
   - Test validation errors (expect `400 Bad Request`).
   - Run `go test ./...` and `go vet ./...`.

## Hard Rules
- Maintain standard envelope: `{"success": bool, "message": string, "data": ...}`.
- Preserve existing status codes unless an explicit API breaking change is authorized.

## References
- [.agent/API.md](../../API.md)
- [.agent/ERROR_HANDLING.md](../../ERROR_HANDLING.md)
