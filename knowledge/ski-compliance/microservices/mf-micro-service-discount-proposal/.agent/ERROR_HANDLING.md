# .agent/ERROR_HANDLING.md — Error Architecture & Exception Flow

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

## 1. Centralized Panic & Recover Error Flow

This codebase uses a **panic-recovery** architecture to handle error propagation cleanly across architectural layers without multi-return boilerplate.

```text
 ┌────────────────────────────────────────────────────────┐
 │ Service / Repository / Helper                          │
 │ - Raises error: `helper.PanicIfError(err)`             │
 │ - Raises custom message: `panic(&ErrorSendToResponse)` │
 └───────────────────────────┬────────────────────────────┘
                             │ (panic unwinds stack)
                             ▼
 ┌────────────────────────────────────────────────────────┐
 │ Transaction Boundary: `helper.CommitOrRollback(tx)`    │
 │ - Intercepts panic via `recover()`                     │
 │ - Executes `tx.Rollback()`                             │
 │ - Re-panics to bubble to top level                     │
 └───────────────────────────┬────────────────────────────┘
                             │ (re-panic)
                             ▼
 ┌────────────────────────────────────────────────────────┐
 │ Gin Middleware: `app.ErrorHandler()`                   │
 │ - Catches panic via `recover()`                        │
 │ - Prints stack trace: `debug.Stack()`                  │
 │ - Invokes `exception.ErrorHandler(c, err)`             │
 └───────────────────────────┬────────────────────────────┘
                             │ (maps error type)
                             ▼
 ┌────────────────────────────────────────────────────────┐
 │ HTTP JSON Response (`model/web/web_response.go`)       │
 │ - Emits standard JSON with matching HTTP status code   │
 └────────────────────────────────────────────────────────┘
```

---

## 2. Exception Types & Sentinel Errors

Defined in `exception/error.go`:

```go
package exception

import "errors"

var (
    ErrPermissionDenied    = errors.New("permission denied")
    ErrRecordNotFound      = errors.New("record not found")
    ErrUnauthorized        = errors.New("unauthorized")
    ErrRefreshTokenExpired = errors.New("refresh token expired")
)

type ErrorSendToResponse struct {
    Err string
}

func (e *ErrorSendToResponse) Error() string {
    return e.Err
}
```

---

## 3. Central Error Dispatcher (`exception/error_handler.go`)

The `exception.ErrorHandler` function maps intercepted panics to specific HTTP responses:

```go
func ErrorHandler(c *gin.Context, err interface{}) {
    if validationError(c, err) {
        return // 400 Bad Request with field validation map
    }
    if sendToResponseError(c, err) {
        return // 400 Bad Request with custom error message
    }
    if permissionDeniedError(c, err) {
        return // 403 Forbidden
    }
    if foreignKeyError(c, err) {
        return // 400 Bad Request (MySQL Error 1451)
    }
    if recordNotFoundError(c, err) {
        return // 200 OK with "Record not found"
    }
    if unauthorizedError(c, err) {
        return // 401 Unauthorized
    }
    if duplicateError(c, err) {
        return // 400 Bad Request (MySQL Error 1062)
    }
    internalServerError(c, err) // 500 Internal Server Error
}
```

---

## 4. Error Responses by Category

### 1. Business Logic Error (`ErrorSendToResponse`)
- **Trigger**: `panic(&exception.ErrorSendToResponse{Err: "Period end harus lebih besar dari period start"})`
- **Status Code**: `400 Bad Request`
- **Response**:
  ```json
  {
    "success": false,
    "message": "Period end harus lebih besar dari period start"
  }
  ```

### 2. Validation Error (`validator.ValidationErrors`)
- **Trigger**: `err := service.Validate.Struct(request); helper.PanicIfError(err)`
- **Status Code**: `400 Bad Request`
- **Response**:
  ```json
  {
    "success": false,
    "message": "Bad Request",
    "data": {
      "period": "period is a required field",
      "type": "type must be a valid discount_proposal_type"
    }
  }
  ```

### 3. Record Not Found (`ErrRecordNotFound` or `"record not found"`)
- **Trigger**: `gorm.ErrRecordNotFound`
- **Status Code**: `200 OK` (Note: standard in this system)
- **Response**:
  ```json
  {
    "success": true,
    "message": "Record not found"
  }
  ```

### 4. Duplicate Key (`Error 1062`)
- **Trigger**: MySQL unique constraint violation
- **Status Code**: `400 Bad Request`
- **Response**:
  ```json
  {
    "success": false,
    "message": "Duplicate entry '...' for key '...'"
  }
  ```

### 5. Foreign Key Violation (`Error 1451`)
- **Trigger**: MySQL foreign key parent constraint violation on delete/update
- **Status Code**: `400 Bad Request`
- **Response**:
  ```json
  {
    "success": false,
    "message": "Cannot delete or update a parent row: a foreign key constraint fails"
  }
  ```

### 6. Unauthorized & Forbidden
- **Status Code**: `401 Unauthorized` (`ErrUnauthorized`), `403 Forbidden` (`ErrPermissionDenied`).
- **Response**:
  ```json
  {
    "success": false,
    "message": "unauthorized"
  }
  ```
