# HTTP API

## Router and Registration

The service uses Gin. `app.NewRouter` creates `gin.Default()`, installs tracing/logging/recovery middleware, and calls each function in `route/`. Routes are registered directly on the root engine; no common `/api` group or version prefix is present.

Route functions also construct the module graph. A new route file is inert until registered in `app/router.go`.

## Handler Signature

Authenticated controller interfaces normally use:

```go
Method(context *gin.Context, auth *auth.AccessDetails)
```

`auth.Auth` adapts that signature to `gin.HandlerFunc`. Some processing/proxy endpoints intentionally register a plain Gin handler without authentication; do not copy those exceptions unless the endpoint contract requires it.

## Request DTOs and Decoding

Request structs live in `model/web` and generally use JSON tags plus `validate` tags. Controllers commonly decode JSON with `helper.ReadFromRequestBody`, parse path IDs with `strconv`, whitelist query filters with `helper.FilterFromQueryString`, and use `goHelper.GetPagination`.

Multipart upload endpoints parse form values/files directly; `VisitController.UpdateCheckOut` is the primary example.

`helper.ReadFromRequestBody` uses `encoding/json.Decoder`, not Gin binding. Unknown JSON fields are not rejected by that helper.

## Validation

`main.go` creates one `validator.Validate` and routes inject it into services. Services generally call `Validate.Struct(request)` before business work. Validation errors panic and global middleware maps `validator.ValidationErrors` to HTTP 400.

Validation is not uniformly invoked by every method. Follow the closest matching operation and do not remove established tags/checks.

## Response Format

Most endpoints return `model/web.WebResponse`:

```json
{
  "success": true,
  "total_data": 0,
  "message": "Record found",
  "data": {}
}
```

Fields lack `omitempty`, so zero/nil fields can still appear. Controllers choose the message and HTTP status. List messages often use `helper.MessageDataFoundOrNot`.

Exceptions include authentication errors and Google Maps proxy responses, which use `gin.H` or pass through upstream status/body.

## Pagination and Filtering

Paginated controllers set `TotalData` from repository/service results. Query conventions are provided by the private helper's `PaginationData`; common parameters are parsed by `goHelper.GetPagination` and eventually drive limit, offset, search, and order.

Allowed domain filters are explicitly listed per controller, with keys such as `v.status.eq`, `period.gte`, or `name.like`. Adding a filter requires adding it to the controller allowlist and ensuring its column/alias exists in the repository query.

## HTTP Status Codes

Observed conventions:

- Successful reads/updates: 200.
- Basic create endpoints may use 201 (`CompanyController.Create`), while complex visit creation uses 200.
- Some delete endpoints use 204 while still constructing a response; many others use 200.
- Validation/business/database constraint failures: usually 400.
- Invalid/expired JWT: 401.
- Permission sentinel: 403.
- Unhandled panic: 500.
- GORM `record not found`: middleware returns 200 with `success: true` and a not-found message.

The status conventions are inconsistent across older/newer modules. Preserve the affected endpoint's contract unless explicitly changing it.

## Authentication

`auth.Auth` extracts the bearer token, requires an HMAC-signed JWT using `ACCESS_SECRET`, validates expiration, and builds `AccessDetails` with user/company/structure/level/subordinate and checkpoint flags. It places `user_id` and `user_name` in the Gin context.

The middleware currently bypasses JWT validation for a hard-coded IP allowlist. Treat any change as security-sensitive.

## Authorization

Routes pass role slices, often `RoleAdministrator`, but the role enforcement block is commented out in `auth.Auth`. Effective authorization is mostly implemented in service flags and repository scoping using `AccessDetails`.

Never assume the route role slice currently enforces access. Preserve company/structure/ownership filters and checkpoint checks.

For every new authenticated endpoint, explicitly verify:

1. whether it is tenant-scoped by `CompanyID`;
2. whether it is limited to `StructureID` or `StructureSubordinates`;
3. whether ownership or period filters are required;
4. whether `CheckPointVisitSchedule` or `CheckPointVisitRealization` gates the action;
5. whether the apparent route role requirement needs real enforcement rather than relying on the currently inactive `roles` check.

The exact combination is domain-specific and must come from a sibling endpoint/business rule; there is no universal authorization policy table in this repository.

## Adding an Endpoint

Normally update:

1. `model/web` request/response DTOs.
2. `model/domain` mapper/model only if data shape changes.
3. repository interface and implementation when new persistence behavior is required.
4. service interface and implementation for validation/business logic/transaction.
5. controller interface and implementation for HTTP translation.
6. `route/<module>_route.go` for registration and wiring.
7. `app/router.go` only when adding a new route module.
8. handwritten test mocks and focused tests.

Use `company` as a simple CRUD example and `visit` for authenticated, paginated, multipart, and business-state examples.

Services normally call domain `To...Response` methods and return web DTOs; controllers wrap those DTOs in `WebResponse`. Keep that ownership for new conventional modules. Some proxy/report paths are exceptions, so copy the nearest module when it returns a web projection directly from a repository or writes through Gin in a service.
