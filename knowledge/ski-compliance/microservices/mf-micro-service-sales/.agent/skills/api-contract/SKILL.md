---
name: api-contract
description: Use when creating or modifying HTTP endpoints, request/response DTOs, Gin routes, and validator validation rules.
---

# API Contract Skill

## Guidelines
1. **Envelope Structure**: All responses must use `web.WebResponse{Success: bool, Message: string, Data: ...}`.
2. **DTO Separation**: Inputs use `model/web/*_request.go` with `validate:"..."` tags; outputs use `model/web/*_response.go`.
3. **Query Filtering**: Use `helper.FilterFromQueryString(c, ...)` and `helper.ApplyFilter(tx, filters)`.
4. **Error Responses**: Validation failures yield 400 Bad Request; missing records return 200 OK with `"Record not found"`.

See [.agent/API.md](../../API.md) and [.agent/ERROR_HANDLING.md](../../ERROR_HANDLING.md).
