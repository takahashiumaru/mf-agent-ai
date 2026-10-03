# .agent/ERROR_HANDLING.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Error Handling & Recovery Architecture

`ski-api-gateway` employs a multi-tiered error recovery and translation system designed to prevent unhandled panics from crashing the HTTP server and to return normalized JSON error envelopes.

---

## 1. Panic Recovery Middleware (`pkg/app/router.go`)

The Gin engine attaches the `ErrorHandler()` middleware at root level:

```go
func ErrorHandler() gin.HandlerFunc {
    return func(c *gin.Context) {
        defer func() {
            if err := recover(); err != nil {
                fmt.Println("stacktrace from panic: \n" + string(debug.Stack()))
                exception.ErrorHandler(c, err)
            }
        }()
        c.Next()
    }
}
```

---

## 2. Centralized Error Dispatcher (`exception/error_handler.go`)

`exception.ErrorHandler(c *gin.Context, err interface{})` checks errors in specific order:

1. **Validation Errors (`validator.ValidationErrors`)**:
   - Status: `400 Bad Request`
   - Response: `WebResponse{ Success: false, Message: "Bad Request", Data: helper.ErrorRequestMessage(exception) }`
2. **Custom Response Errors (`*exception.ErrorSendToResponse`)**:
   - Status: `400 Bad Request`
   - Response: `WebResponse{ Success: false, Message: err.Error() }`
3. **Permission Denied (`exception.ErrPermissionDenied`)**:
   - Status: `403 Forbidden`
   - Response: `WebResponse{ Success: false, Message: "permission denied" }`
4. **Foreign Key Violation (`Error 1452: Cannot add or update a child row`)**:
   - Status: `400 Bad Request`
   - Response: `WebResponse{ Success: false, Message: "A foreign key constraint fails" }`
5. **Record Not Found (`"record not found"`)**:
   - Status: `200 OK` (Legacy compatibility)
   - Response: `WebResponse{ Success: true, Message: "Record not found" }`
6. **Unauthorized (`exception.ErrUnauthorized`, `exception.ErrRefreshTokenExpired`)**:
   - Status: `401 Unauthorized`
   - Response: `WebResponse{ Success: false, Message: err.Error() }`
7. **Duplicate Entry (`Error 1062: Duplicate entry`)**:
   - Status: `400 Bad Request`
   - Response: `WebResponse{ Success: false, Message: helper.ErrorDuplicateMessage(exception) }`
8. **Fallback (Unhandled Errors / Panics)**:
   - Status: `500 Internal Server Error`
   - Response: `WebResponse{ Success: false, Message: "Internal Server Error" }`

---

## 3. Best Practices for New Errors

- When defining new error conditions, add sentinel errors to `exception/error.go` using `errors.New(...)`.
- Avoid leaking internal database connection strings, credentials, or file paths in client-facing error messages.
