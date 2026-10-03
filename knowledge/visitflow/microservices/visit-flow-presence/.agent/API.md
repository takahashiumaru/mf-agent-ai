# HTTP API

## Router and Route Organization

The service uses Gin 1.9.1. `app.NewRouter` creates `gin.New()`, installs `helper.LoggerMiddleware` and `app.ErrorHandler`, then calls each `route/*_route.go` registration function.

Routes are registered directly on the engine rather than grouped under a version prefix. Paths include plural resources (`/offices`, `/presences`, `/leaves`), reports under `/report/...`, process/action endpoints, and some legacy singular/inconsistent paths. Preserve existing public paths.

`route/office_route.go` is the preferred compact CRUD example. `route/leave_route.go` demonstrates action endpoints; `route/presence_route.go` demonstrates reporting endpoints.

## Handler Signature and Authentication Adapter

Controller interfaces use:

```go
Method(c *gin.Context, auth *auth.AccessDetails)
```

`auth.Auth` adapts that signature to `gin.HandlerFunc`, extracts/verifies the bearer JWT, writes user metadata into Gin context for logging, and passes parsed claims. Most routes use it. A few process/log endpoints are registered without it; preserve this only where explicitly established.

Routes supply role lists, often `auth.RoleAdministrator`, but `auth.Auth` currently has its role/permission check commented out. JWT authentication is active; route-level role authorization is not currently enforced by this code.

## Request DTOs and Parsing

Request/response DTOs live in `model/web`. JSON handlers normally use `helper.ReadFromRequestBody`, which decodes with `encoding/json` and panics on error. Path IDs are read with `c.Param` and often converted with `strconv.Atoi`.

Leave create/update uses multipart parsing in `controller/leave_controller_impl.go`; office-user and work-hour-user also have CSV upload endpoints. Do not assume every request is JSON.

## Validation

The shared validator is `go-playground/validator/v10`, created in `main.go` and injected into services. DTO fields use `validate` tags such as `required`, `min`, `max`, `gte`, `lte`, latitude/longitude, and `oneof`. Services commonly call `service.Validate.Struct(request)` before starting work.

Validation is not uniform: some DTOs have few/no tags, and `helper.RegisterValidation` is empty. Match the affected service; do not claim validation that is not present.

## Response Format

Most JSON endpoints return `model/web.WebResponse`:

```json
{
  "success": true,
  "total_data": 0,
  "message": "Record found",
  "data": {}
}
```

Fields are always part of the Go struct (no `omitempty`), so zero/nil fields may serialize. List converters produce empty slices. `helper.MessageDataFoundOrNot` selects `Record found`/`Record not found` for list/value responses.

Most successful create/update/delete endpoints use HTTP 200, not 201/204. `FindProofPhoto` writes bytes directly rather than the JSON envelope. Log retrieval has its own response/header behavior in `controller/log_controller_impl.go`.

## Pagination, Filtering, and Sorting

Paginated controllers call `goHelper.GetPagination(c)` with query parameters:

- `page` (default in helper: `0`)
- `limit` (default `10`)
- `sort`
- `ascending`
- `search`

Only selected controllers populate `total_data` from a repository count; others leave it at zero. Filtering is allowlisted per controller through `helper.FilterFromQueryString`, with keys like `name.like`, `user_id.eq`, `date.gte`, and `status.in`. Repository helpers translate suffixes to operators.

Do not accept arbitrary filter columns merely because `helper.ApplyFilter` can build them. Add each allowed API key deliberately at the controller and handle specialized semantics in the repository.

## HTTP Status and Errors

- Normal successes: HTTP 200.
- Validation and `ErrorSendToResponse`: HTTP 400, `success:false`.
- Unauthorized: HTTP 401.
- Permission denied: HTTP 403 (though role enforcement is disabled).
- Record not found: HTTP 200, `success:true`, message `Record not found`.
- Duplicate/FK errors: HTTP 400.
- Other panics: HTTP 500.

See `ERROR_HANDLING.md` before modifying these unusual compatibility behaviors.

## Authentication Claims

`auth.AccessDetails` exposes user/company/structure identity, hierarchy, department, level, MKT status, and feature flags parsed from JWT claims. Services use these values for audit fields, company filters, approvals, and domain behavior. Claim type assertions in `auth/auth.go` assume expected fields/types are present.

## Authorization and Ownership

Role enforcement is commented out. Some services/repositories use `CompanyID`, `UserID`, or structure filters, but enforcement is not uniform. Before adding or changing an endpoint, inspect the closest route/service/repository and decide nothing beyond existing evidence. Security-sensitive changes require explicit validation of tenant/ownership expectations.

## New Endpoint Checklist

1. Add request/response DTOs under `model/web` if needed.
2. Add/extend controller interface and implementation.
3. Add/extend service interface and implementation for validation/business logic.
4. Add/extend repository interface and GORM implementation only for persistence needs.
5. Register and wire the endpoint in the relevant `route/*_route.go`.
6. Use `auth.Auth` consistently with neighboring routes; do not assume role lists currently enforce roles.
7. Preserve the response envelope/status/error convention.
8. Add focused controller/service/repository tests.

Preferred template: the office flow for CRUD, presence flow for pagination/reports, or leave flow for multipart/action endpoints.
