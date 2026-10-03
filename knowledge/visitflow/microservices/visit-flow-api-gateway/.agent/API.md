# API Conventions

## Routers

Two HTTP routers run in one process:

- KrakenD uses its Gin router adapter and reads proxy endpoint definitions from `configuration.json`.
- A standalone `gin.Engine` serves local identity/file endpoints registered by `setupJWTRouter` in `main.go`.

Default ports are 9000 for KrakenD (`configuration.json`) and 8090 for the local Gin service (`-jwt-port`).

## Route Organization

Local routes are grouped by resource under `route/`:

- `route/users_route.go`
- `route/role_route.go`
- `route/user_role_route.go`
- `route/role_menu_permission_route.go`
- `route/file.go`

Each route function performs manual dependency construction and registers methods directly on `*gin.Engine`; no route groups or version prefixes are used.

Gateway routes are data entries in `configuration.json`, each defining public method/path, forwarded headers/query parameters, and one backend method/path/host.

## Handler Signature

Controller interfaces use one of:

```go
Method(context *gin.Context)
Method(context *gin.Context, auth *auth.AccessDetails)
```

Protected routes wrap the second form with `auth.Auth`, which verifies the token and injects access details by argument rather than storing them in Gin context.

## Request DTOs

Request structs live in `model/web`. JSON bodies are decoded by `helper.ReadFromRequestBody`; multipart user create/update handlers manually read `PostForm` fields and `MultipartForm` files.

Path parameters are parsed in controllers with `strconv.Atoi`, and query filters are allowlisted at the controller boundary.

## Validation

Services own validation and call `service.Validate.Struct(request)`. DTOs use `validate` tags from `go-playground/validator/v10`, including `required`, length bounds, `gt`, `omitempty`, and `oneof`.

Not every DTO field has validation, and no custom validator registration was found. Multipart parsing/file size/MIME validation is not clearly established in the current repository.

## Response Format

Normal local JSON endpoints return `web.WebResponse`:

```json
{
  "success": true,
  "count_data": 0,
  "message": "...",
  "data": {}
}
```

Because fields have no `omitempty`, zero values are normally serialized. Error responses use the same envelope in the centralized handler, except `auth.Auth` and `GatewayAuthMiddleware` return `gin.H{"error": "..."}` for some unauthorized cases.

File download returns raw bytes and sets `Access-Control-Allow-Origin: *` rather than using the envelope.

Gateway responses use KrakenD `no-op` encoding for configured endpoints and therefore generally pass downstream responses through rather than wrapping them locally.

## Pagination Response

List controllers set `CountData` to the repository's total count and `Data` to the response slice. Input query parameters are `page`, `limit`, `sort`, `ascending`, and `search` via go-helper. Default behavior comes from that dependency; review its helper before changing semantics.

## HTTP Status Codes

Observed local conventions:

- 200 for reads and most create/update/delete operations.
- 201 for user creation.
- 400 for validation errors, `ErrorSendToResponse`, duplicate keys, and foreign-key restrictions.
- 401 for invalid/missing/revoked tokens and refresh errors.
- 403 for `ErrPermissionDenied` (although role enforcement is currently disabled).
- 500 for otherwise unrecognized panics/errors.
- `gorm` record-not-found text maps to HTTP 200 with `success: true` and no data.

See `ERROR_HANDLING.md` before altering these contracts.

## Authentication

- `auth.Auth` requires a bearer token, verifies HMAC signature/expiry, parses selected claims, and checks that the exact token is still stored on a non-deleted user row.
- `GatewayAuthMiddleware` allows requests without an Authorization header; if a header is present, it verifies the token/revocation state.
- Local public routes in `route/users_route.go` include user creation, no-auth get/update, password verification, password reset, device token lookup, and refresh-token exchange.
- JWT secrets come from environment variables.

## Authorization

Routes pass allowed roles to `auth.Auth`, often `Administrator`, but the code that checks the list is commented out. Authentication is enforced on wrapped routes; role authorization is not currently enforced. Treat any change here as an explicit security/API change.

## Middleware

Gateway: permissive-origin CORS, secure headers, rate limit of 20 through `gin-limit`, then optional-token gateway auth.

Local Gin service: permissive-origin CORS, IP blocking after repeated 404s, and panic recovery/error mapping. Per-route `auth.Auth` handles authentication.

## New Endpoint Workflow

For a local endpoint:

1. Add/reuse a request/response DTO in `model/web`.
2. Add the method to the appropriate controller and service interfaces.
3. Implement controller parsing and `WebResponse` creation.
4. Implement validation/business behavior in the service.
5. Add a repository interface method and GORM implementation only when persistence is needed.
6. Wire/register it in the relevant `route/*.go` file.
7. Decide authentication explicitly; do not infer role enforcement from the roles argument.
8. Add controller/service/repository tests matching the affected layers.

Preferred JSON CRUD example: roles across `route/role_route.go`, `controller/role_controller_impl.go`, `service/role_service_impl.go`, and `repository/role_repository_impl.go`.

For a proxied endpoint, update only `configuration.json` after confirming the intended public contract, upstream host/path, forwarding rules, and authentication expectations. No local controller/service/repository is needed unless the endpoint is meant to be implemented by this process.
