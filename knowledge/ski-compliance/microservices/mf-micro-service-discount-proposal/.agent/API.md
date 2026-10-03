# .agent/API.md — REST API Design, Routing & Validation

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

## 1. Route Registration & Middleware Architecture

Route initialization is centralized in `app/router.go` and defined across modular route files in `route/`:

```go
func NewRouter(db *gorm.DB, validate *validator.Validate) *gin.Engine {
    serviceName := "GO-MF-MICRO-DISCOUNT-PROPOSAL"
    initTracer()
    router := gin.Default()
    router.UseRawPath = true
    router.Use(otelgin.Middleware(serviceName)) // OpenTelemetry distributed tracing
    router.Use(ErrorHandler())                  // Central panic recovery and JSON error mapping

    // Module route registration
    route.CreditNoteRoute(router, db, validate)
    route.CustomerBalanceRoute(router, db, validate)
    route.DiscountProposalConfirmationRoute(router, db, validate)
    route.DiscountProposalConfirmationStatusRoute(router, db, validate)
    route.DiscountProposalEstimationRoute(router, db, validate)
    route.DiscountProposalEventRoute(router, db, validate)
    route.DiscountProposalPaymentRoute(router, db, validate)
    route.DiscountProposalRecipientRoute(router, db, validate)
    route.DiscountProposalReturnRoute(router, db, validate)
    route.DiscountProposalRoute(router, db, validate)
    route.ProposalDocumentStatusRoute(router, db, validate)
    // ...
    return router
}
```

---

## 2. Authentication & Authorization Middleware

Authentication is handled by `auth.Auth` in `auth/auth.go`:
```go
router.GET("/discount-proposals", auth.Auth(discountProposalController.FindAll, []string{}))
```

### Flow:
1. `ExtractToken(c.Request)` retrieves the Bearer token from the `Authorization` header.
2. `VerifyToken(tokenString)` parses the JWT using HMAC with `configuration.AccessSecret`.
3. `ExtractTokenMetadata(token)` decodes the claims into `*auth.AccessDetails`:
   - `UserID`, `Nip`, `Name`, `Role`, `Level`.
4. Passes `(c *gin.Context, auth *auth.AccessDetails)` into the controller handler.

---

## 3. Request Binding & Query Filtering

### Request Body Binding
Controllers use `helper.ReadFromRequestBody(c, &request)` (`c.ShouldBindJSON`):
```go
func (controller *DiscountProposalControllerImpl) Create(c *gin.Context, auth *auth.AccessDetails) {
    request := web.DiscountProposalCreateRequest{}
    helper.ReadFromRequestBody(c, &request)
    // ...
}
```

### Query String Filtering
Controllers use `helper.FilterFromQueryString(c, ...)` to extract query parameters into a map:
```go
filters := helper.FilterFromQueryString(c,
    "period.eq",
    "marketing_structure_id.eq",
    "city_id.eq",
    "type.eq",
    "status.eq",
    "distributor_id.eq",
)
```
The filters map is then passed through Service to Repository, where `helper.ApplyFilter(tx, filters)` constructs SQL `WHERE` clauses. Supported operators:
- `.eq` (`=`)
- `.ne` (`<>`)
- `.like` (`LIKE %val%` / upper-cased)
- `.gt` (`>`), `.gte` (`>=`)
- `.lt` (`<`), `.lte` (`<=`)
- `.in` (`IN (?)`)

---

## 4. Struct Validation & Custom Rules

Validation is executed at the service layer via `service.Validate.Struct(request)` using `github.com/go-playground/validator/v10`. Custom rules are registered in `helper/custom_validator.go`:

| Custom Validator Tag | Validation Pattern / Rule | Target Use Case |
| :--- | :--- | :--- |
| `period_month` | `^\d{4}(0[1-9]\|1[012])$` (6 digits: YYYYMM) | Accounting period fields |
| `period_day` | `^\d{4}(0[1-9]\|1[012])(0[1-9]\|[12][0-9]\|3[01])$` (8 digits: YYYYMMDD) | Period start / end dates |
| `discount_proposal_type` | `^(SKI1\|SKI2\|DPL\|DPF\|DPL2)$` | Discount Proposal classification |
| `quantity_type` | `^(FULL\|SHARED)$` | Credit note & proposal quantity allocation |
| `tax_type` | `^(GROSS UP\|TAX\|NON TAX)$` | Recipient tax calculation type |
| `discount_proposal_transfer_type`| `^(BO\|504)$` | Recipient disbursement type |
| `npwp` | `^\d{2}\.\d{3}\.\d{3}\.\d{1}-\d{3}\.\d{3}$` (20 chars) | Indonesian Tax ID |
| `ktp` | 16-digit regex | Indonesian National ID |
| `status_credit_note` | `^(OPEN\|CLOSE)$` | Credit note status |

---

## 5. Standard Response Envelope & Status Codes

All responses follow the standard `web.WebResponse` structure (`model/web/web_response.go`):

```json
{
  "success": true,
  "message": "Record found",
  "data": { ... }
}
```

### Status Code Mapping:
- **`200 OK`**:
  - Successful GET queries (with data).
  - Successful queries returning empty results (`"message": "Record not found"`).
  - Successful POST, PUT, DELETE operations.
- **`400 Bad Request`**:
  - Request body JSON syntax error.
  - Struct validation failure (`validator.ValidationErrors` formatted by `helper.ErrorRequestMessage`).
  - Business logic exception (`&exception.ErrorSendToResponse{Err: "message"}`).
  - MySQL Duplicate Key error (1062) (`helper.ErrorDuplicateMessage`).
  - MySQL Foreign Key constraint error (1451) (`helper.ErrorForeignMessage`).
- **`401 Unauthorized`**:
  - Missing or invalid JWT token (`exception.ErrUnauthorized`, `exception.ErrRefreshTokenExpired`).
- **`403 Forbidden`**:
  - Access denied (`exception.ErrPermissionDenied`).
- **`500 Internal Server Error`**:
  - Unhandled panics or fatal database failures.
