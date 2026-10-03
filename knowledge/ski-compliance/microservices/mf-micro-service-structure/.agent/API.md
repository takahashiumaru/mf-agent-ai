# API Contract & HTTP Routing Guide — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## HTTP Framework & Route Registration

The HTTP layer is built with **Gin** (`github.com/gin-gonic/gin`). Route initialization occurs in `app/router.go` by invoking modular route setup functions from the `route/` package:
- `route.HierarchyRoute`
- `route.MarketingPositionRoute`
- `route.MarketingStructureRoute`
- `route.MarketingStructureAreaRoute`
- `route.MarketingStructureTerritoryOutletRoute`
- `route.MarketingStructureTerritoryCustomerRoute`
- `route.OfficeRoute`
- `route.StructureWhProcessRoute`

## Authentication & Authorization Guard

Routes are protected by `auth.Auth(...)`:
```go
router.GET("/marketings/structures", auth.Auth(marketingStructureController.FindAll, []string{}))
router.POST("/marketings/structures", auth.Auth(marketingStructureController.Create, []string{}))
```
- Extracts Bearer token from `Authorization` header.
- Verifies JWT HMAC signature against `ACCESS_SECRET`.
- Injects `*auth.AccessDetails` (`UserID`, `Role`, `Level`, `Nip`, `Name`) directly into handler signatures:
  ```go
  func (controller *MarketingStructureControllerImpl) FindAll(c *gin.Context, auth *auth.AccessDetails)
  ```
- Public/No-Auth routes omit the wrapper:
  ```go
  router.GET("/marketings/structures-no-auth", marketingStructureController.FindAllNoAuth)
  router.GET("/marketings/structures-subordinates-no-auth", marketingStructureController.FindMarketingStructureAllLevelSubordinates)
  ```

## Request Binding & Validation

- **Query Parameters**: Extracted via `helper.FilterFromQueryString(c, allowedFilters...)`.
- **JSON Request Body**: Unmarshaled via `helper.ReadFromRequestBody(c, &request)`.
- **Validation**:
  - Validated in service layer: `err := service.Validate.Struct(request)`
  - Uses Go Playground validator with custom rules registered in `helper/custom_validator.go`:
    - `period_month`: Matches 6-digit month format `\d{4}(0[1-9]|1[012])`.
    - `period_day`: Matches 8-digit day format `\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])`.
    - `ktp`, `npwp`, `account_type`, `gender`, `religion`, etc.

## Standard Response Envelopes (`model/web/web_response.go`)

All JSON responses follow the standard envelope:
```json
{
  "success": true,
  "message": "Office created successfully",
  "data": { ... }
}
```

### Typical HTTP Status Codes

- `200 OK`: Successful read, update, or delete. Also returned for `gorm.ErrRecordNotFound` with `success: true, message: "Record not found"`.
- `400 Bad Request`: Validation failure (`validator.ValidationErrors`), custom business error (`*ErrorSendToResponse`), duplicate key error (`1062`), or foreign key error (`1451`).
- `401 Unauthorized`: Missing, invalid, or expired JWT token (`ErrUnauthorized`).
- `403 Forbidden`: Insufficient role permissions (`ErrPermissionDenied`).
- `500 Internal Server Error`: Unhandled server exceptions or connection failures.
