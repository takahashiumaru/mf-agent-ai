# .agent/API.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## API Gateway Contract & Routing Standards

This document defines route registration, request security, response envelopes, and reverse proxy behaviors in `ski-api-gateway`.

---

## 1. Route Registration (`pkg/app/router.go`)

Routes are registered on the `*gin.Engine` instance created in `NewRouter(c *config.Config)`:

```go
type Backend struct {
    Api    string
    Host   string
    Method string
}
```

Routes are categorized into two groups:
1. **Public Routes (Unauthenticated)**: Registered before the authentication middleware.
   - Example: `/users/login`, `/users/refresh-token`, `/summary_ffs`, `/products/no-auth`, `/customers/no-auth`.
2. **Protected Routes (Authenticated)**: Registered after `ApiKeyMiddleware` and `JWT` middleware.
   - Requires valid `Authorization: Bearer <token>`, `X-API-Key: <key>`, `Authorization: ApiKey <key>`, or `?api_key=<key>`.

---

## 2. Authentication & Authorization Pipeline

### Flow

```text
Request Arrives
   ↓
[ApiKeyMiddleware] -> If API key found in header/query and valid in api_keys.json:
                      Generates mock JWT claims and injects `Authorization: Bearer <token>`
   ↓
[JWT Middleware]    -> Extracts Bearer token from header.
                      Calls auth.VerifyToken(token, accessSecret).
                      If invalid/expired, aborts with HTTP 401 Unauthorized.
   ↓
[ReverseProxy]     -> Modifies URL Host & Scheme, delegates to downstream service.
```

---

## 3. Universal Response Envelope

All API error responses generated at the gateway level adhere to `model/web/web_response.go`:

```json
{
  "success": true,
  "message": "Operation description or error message",
  "data": null
}
```

### HTTP Status Code Mapping

- `200 OK`: Successful response, or legacy "Record not found".
- `400 Bad Request`: Validation failure, duplicate key (MySQL 1062), or foreign key failure (MySQL 1452).
- `401 Unauthorized`: Missing, expired, or invalid JWT / API key.
- `403 Forbidden`: Permission denied / role access check failure.
- `500 Internal Server Error`: Unhandled panic or server exception.

---

## 4. CORS Policy

Enforced by `CORSMiddleware()`:
- `Access-Control-Allow-Origin: *`
- `Access-Control-Allow-Credentials: true`
- `Access-Control-Allow-Headers: *, X-API-Key, Authorization`
- `Access-Control-Allow-Methods: *`
- Responds with `204 No Content` on `OPTIONS` preflight requests.
