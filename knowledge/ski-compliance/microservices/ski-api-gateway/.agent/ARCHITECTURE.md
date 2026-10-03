# .agent/ARCHITECTURE.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Architectural Style

`ski-api-gateway` follows an **API Gateway / Reverse Proxy Architecture** built atop the Gin HTTP framework. It does not own relational database tables or persistent domain entities directly; instead, it provides front-door security, routing, rate control, and response normalization for the entire SKI Compliance platform.

```text
+-------------------------------------------------------------------------+
|                              Client App                                 |
+-------------------------------------------------------------------------+
                                    | HTTP / HTTPS
                                    v
+-------------------------------------------------------------------------+
|                           ski-api-gateway                               |
|                                                                         |
|  [IP Filtering] -> [CORS] -> [Error Recovery] -> [Auth Pipeline]        |
|                                                       |                 |
|                                              [Reverse Proxy]            |
+-------------------------------------------------------------------------+
          |                  |                 |                 |
          v                  v                 v                 v
+------------------+ +---------------+ +---------------+ +---------------+
| ski-auth service | | ski-proposal  | | ski-warehouse | | ski-product   |
+------------------+ +---------------+ +---------------+ +---------------+
```

---

## Layered Organization

1. **Bootstrap Layer (`cmd/main.go`)**:
   - Initializes Viper configuration (`pkg/config/config.go`).
   - Instantiates the Gin router engine (`pkg/app/router.go`).
   - Starts the standard library `http.Server` bound to `c.Port`.
   - Uses `helper.PanicIfError` to trap startup failures.

2. **Routing & Middleware Pipeline (`pkg/app/router.go`)**:
   - `helper.BlockIPMiddleware()`: Monitors 404 response codes per client IP, maintaining an in-memory tracker and blocking abusive IPs for 30 minutes.
   - `CORSMiddleware()`: Emits permissive CORS headers (`Access-Control-Allow-Origin: *`, `Access-Control-Allow-Headers: *, X-API-Key, Authorization`, etc.) and handles `OPTIONS` with 204 No Content.
   - `ErrorHandler()`: Defer-recovers from panics, logs stack traces, and delegates to `exception.ErrorHandler(c, err)`.
   - **Public Routes**: Registered directly without authentication middleware (e.g., `/users/login`, `/users/refresh-token`, summary endpoints).
   - **Protected Routes**: Chained through `helper.ApiKeyMiddleware(c.AccessSecret)` and `JWT(c.AccessSecret)`.

3. **Authentication Layer (`pkg/auth/`)**:
   - `auth.go`: Extracts Bearer tokens from `Authorization` header, parses and verifies HMAC-SHA256 signature using `accessSecret`.
   - `access_auth.go`: Provides CSV-based role and route authorization (`Auth` and `AuthCsv`), reading and caching user permission CSVs in `file/user_access/`.
   - `role.go`: Defines user role constants (e.g., `RoleAdministrator`).

4. **Helper Layer (`helper/`)**:
   - `reverse_proxy.go`: Creates a `gin.HandlerFunc` wrapping `net/http/httputil.ReverseProxy` with director rewrite (`http://<host>`).
   - `api_key.go`: Thread-safe `ApiKeyManager` reading `api_keys.json` with mtime cache invalidation, converting matched API keys into signed JWT bearer tokens.
   - `block_acces.go`: In-memory IP tracking mutex, auto-blocking, and optional IP whitelist verification.
   - `error_request_message.go`: Translates validator `ValidationErrors` into readable messages.
   - `error_duplicate_message.go`: Formats MySQL 1062 duplicate key error strings.
   - `debug_http_request.go`: Dumps HTTP requests via `httputil.DumpRequest` when debug mode is enabled.

5. **Exception Layer (`exception/`)**:
   - `error.go`: Sentinel errors (`ErrPermissionDenied`, `ErrRecordNotFound`, `ErrUnauthorized`, `ErrRefreshTokenExpired`) and `ErrorSendToResponse`.
   - `error_handler.go`: Translates errors into HTTP status codes (`400`, `401`, `403`, `500`, and `200` for legacy record-not-found) with `web.WebResponse` envelopes.

6. **Model Layer (`model/web/`)**:
   - `web_response.go`: Universal JSON response envelope `{ success, message, data }`.
