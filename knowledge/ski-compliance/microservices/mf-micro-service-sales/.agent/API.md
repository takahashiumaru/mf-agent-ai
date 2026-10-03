# HTTP API Conventions — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document outlines HTTP routing, handler signatures, request validation, response serialization, and authentication conventions.

---

## 1. Web Framework & Routing
- **Framework**: Gin Web Framework (`github.com/gin-gonic/gin v1.9.1`).
- **Router Setup**: [app/router.go](../app/router.go).
- **Route Registration**: Defined per domain inside `route/<entity>_route.go` files and attached in `app.NewRouter`.

---

## 2. Handler & Controller Signatures

Controllers implement explicit interfaces where methods accept `*gin.Context` and authenticated user metadata `*auth.AccessDetails`:
```go
type BridgingOutletController interface {
    FindAll(c *gin.Context, auth *auth.AccessDetails)
    FindByID(c *gin.Context, auth *auth.AccessDetails)
    Create(c *gin.Context, auth *auth.AccessDetails)
    UpdateStatus(c *gin.Context, auth *auth.AccessDetails)
    Delete(c *gin.Context, auth *auth.AccessDetails)
}
```

---

## 3. Request DTOs & Validation

### A. Parsing Request Body
Request structs reside in `model/web/<entity>_<action>_request.go`:
```go
type BridgingOutletCreateRequest struct {
    DistributorID         string `validate:"required,max=10" json:"distributor_id"`
    OutletID              string `validate:"required,max=20" json:"outlet_id"`
    OutletDistributorID   string `validate:"required,max=50" json:"outlet_distributor_id"`
    BranchDistributorID   string `validate:"required,max=20" json:"branch_distributor_id"`
    BranchDistributorName string `validate:"required,max=100" json:"branch_distributor_name"`
}
```

In the Controller:
```go
request := web.BridgingOutletCreateRequest{}
helper.ReadFromRequestBody(c, &request)
```

In the Service:
```go
err := service.Validate.Struct(request)
helper.PanicIfError(err)
```
Validation errors are automatically caught and transformed into a formatted HTTP 400 response.

### B. Dynamic Filtering
Query parameters are captured using `helper.FilterFromQueryString`:
```go
filters := helper.FilterFromQueryString(c, "distributor_id.eq", "outlet_id.eq", "outlet_distributor_id.like")
```
Supported operators in query keys:
- `.eq` -> `=`
- `.like` -> `LIKE %val%`
- `.in` -> `IN (val1,val2)`
- `.gt`, `.gte` -> `>`, `>=`
- `.lt`, `.lte` -> `<`, `<=`
- `.ne` -> `<>`
- `.bw` -> `BETWEEN`

---

## 4. Response Format

All JSON responses adhere to the standard envelope defined in [model/web/web_response.go](../model/web/web_response.go):
```go
type WebResponse struct {
    Success bool        `json:"success"`
    Message string      `json:"message"`
    Data    interface{} `json:"data,omitempty"`
}
```

### Typical Controller Responses
- **Success (Single Item / Mutation)**:
  ```go
  webResponse := web.WebResponse{
      Success: true,
      Message: "Bridging Outlet created successfully",
      Data:    bridgingOutletResponse,
  }
  c.JSON(http.StatusOK, webResponse)
  ```
- **Success (List)**:
  ```go
  webResponse := web.WebResponse{
      Success: true,
      Message: helper.MessageDataFoundOrNot(responses),
      Data:    responses,
  }
  c.JSON(http.StatusOK, webResponse)
  ```

---

## 5. Authentication & Authorization

Authentication is enforced via `auth.Auth` middleware in [auth/auth.go](../auth/auth.go):
```go
router.GET("/bridging-outlets", auth.Auth(bridgingOutletController.FindAll, []string{}))
```
- Extracts JWT from `Authorization: Bearer <token>` header.
- Verifies token signature using HMAC with `configuration.AccessSecret`.
- Parses claims into `auth.AccessDetails{UserID, Nip, Name, Role, Level}`.
- Forwards `auth *auth.AccessDetails` directly to the controller handler.
