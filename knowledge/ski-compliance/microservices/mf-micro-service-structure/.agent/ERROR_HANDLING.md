# Error Handling & Recovery Guide — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Global Panic-Recovery Architecture

`mf-micro-service-structure` uses a structured panic-recovery flow for error propagation:

```text
Error occurs (DB / Validator / Business Rule)
                   │
                   ▼
       helper.PanicIfError(err)
                   │
                   ▼
         [Panic Propagates Up]
                   │
                   ▼
  helper.CommitOrRollback(tx) (deferred in Service)
  - Intercepts panic via recover()
  - Executes tx.Rollback()
  - Re-panics with original err
                   │
                   ▼
  app.ErrorHandler() (deferred in Gin Middleware)
  - Intercepts panic via recover()
  - Prints debug stack trace: fmt.Println("stacktrace from panic: \n" + string(debug.Stack()))
  - Invokes exception.ErrorHandler(c, err)
                   │
                   ▼
       exception.ErrorHandler()
  - Matches error type and writes JSON response with appropriate status code
```

## Error Type Mapping Matrix (`exception/error_handler.go`)

| Error Condition / Type | Matcher Logic | HTTP Status Code | Response Envelope |
|---|---|---|---|
| Validation Errors | `validator.ValidationErrors` | `400 Bad Request` | `{"success": false, "message": "Bad Request", "data": helper.ErrorRequestMessage(err)}` |
| Business/Client Error | `*exception.ErrorSendToResponse` | `400 Bad Request` | `{"success": false, "message": err.Error()}` |
| Duplicate Entry (MySQL 1062) | `strings.Contains(err.Error(), "Error 1062 (23000): Duplicate entry")` | `400 Bad Request` | `{"success": false, "message": helper.ErrorDuplicateMessage(err)}` |
| Foreign Key Failure (MySQL 1451) | `strings.Contains(err.Error(), "Error 1451 (23000): Cannot delete or update a parent row")` | `400 Bad Request` | `{"success": false, "message": "A foreign key constraint fails"}` |
| Record Not Found | `err.Error() == "record not found"` | `200 OK` | `{"success": true, "message": "Record not found"}` |
| Unauthorized Token | `errors.Is(err, ErrUnauthorized) \|\| errors.Is(err, ErrRefreshTokenExpired)` | `401 Unauthorized` | `{"success": false, "message": err.Error()}` |
| Permission Denied | `errors.Is(err, ErrPermissionDenied)` | `403 Forbidden` | `{"success": false, "message": err.Error()}` |
| Unknown / Unhandled Error | Fallback `internalServerError` | `500 Internal Server Error` | `{"success": false, "message": "Internal Server Error"}` |

## Error Rules for Agents

1. **Do Not Convert Errors to Silent Returns**: Never return `nil` or ignore errors in service/repository implementations.
2. **Use `helper.PanicIfError(err)`**: Call this helper whenever an error should abort the transaction.
3. **Use `exception.NewErrorSendToResponse(msg)`**: When returning explicit user-facing business validation rejections (e.g. "Structure is already locked for this period"), construct and panic with `*exception.ErrorSendToResponse`.
4. **Preserve `record not found` Contract**: Be aware that the existing API contract maps GORM `record not found` to HTTP `200 OK` with `Success: true, Message: "Record not found"`. Changing this behavior changes public API semantics and requires explicit authorization.
