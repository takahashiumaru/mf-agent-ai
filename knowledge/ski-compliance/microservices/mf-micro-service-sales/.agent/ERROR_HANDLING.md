# Error & Exception Handling — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document outlines the error-handling paradigm, exception types, panic-recovery mapping, and HTTP status code translation.

---

## 1. Core Error Philosophy: Panic-and-Recover

The repository utilizes a centralized panic-and-recover flow:
1. When an unexpected or validation error occurs at any layer, the code invokes `helper.PanicIfError(err)` or panics with an error instance (e.g. `panic(&exception.ErrorSendToResponse{Err: "message"})`).
2. Inside services, `defer helper.CommitOrRollback(tx)` catches the panic, rolls back the active database transaction, and re-panics.
3. At the HTTP root, the Gin middleware `app.ErrorHandler()` recovers the panic and forwards it to `exception.ErrorHandler(c, err)`.

---

## 2. Standard Exception Types

Declared in [exception/error.go](../exception/error.go):

| Error Type / Variable | Description |
| :--- | :--- |
| `validator.ValidationErrors` | Triggered by failed DTO struct validations (`service.Validate.Struct`) |
| `*exception.ErrorSendToResponse` | Custom business logic error containing user-facing error message |
| `exception.ErrUnauthorized` | Missing, invalid, or malformed JWT token |
| `exception.ErrRefreshTokenExpired` | Expired refresh token |
| `exception.ErrPermissionDenied` | User does not hold necessary permissions / roles |
| `exception.ErrRecordNotFound` | Specific sentinel error for missing records |

---

## 3. Panic to HTTP Status Code Mapping

Handled in [exception/error_handler.go](../exception/error_handler.go):

| Recovered Error Condition | HTTP Status | Response Payload |
| :--- | :--- | :--- |
| `validator.ValidationErrors` | **400 Bad Request** | `{"success": false, "message": "Bad Request", "data": [...]}` |
| `*ErrorSendToResponse` | **400 Bad Request** | `{"success": false, "message": "<err_message>"}` |
| MySQL Error 1062 (`Duplicate entry`) | **400 Bad Request** | `{"success": false, "message": "<field> already exists"}` |
| MySQL Error 1452 (`FK constraint`) | **400 Bad Request** | `{"success": false, "message": "A foreign key constraint fails"}` |
| `ErrUnauthorized` / `ErrRefreshTokenExpired` | **401 Unauthorized** | `{"success": false, "message": "unauthorized"}` |
| `ErrPermissionDenied` | **403 Forbidden** | `{"success": false, "message": "permission denied"}` |
| `err.Error() == "record not found"` | **200 OK** *(Repository Specific)* | `{"success": true, "message": "Record not found"}` |
| Unhandled / General Error | **500 Internal Server Error** | `{"success": false, "message": "Internal Server Error"}` |

> [!NOTE]
> **Record Not Found Behavior**: In this repository, `gorm.ErrRecordNotFound` is caught by `recordNotFoundError` and returns **HTTP 200 OK** with `{"success": true, "message": "Record not found"}`. AI agents must preserve this behavior to avoid breaking frontend integrations.

---

## 4. Error Rules for Future Agents

1. **For Input Validation**: Rely on `validate.Struct(request)` and `helper.PanicIfError(err)`.
2. **For Business Rule Rejections**: Return or panic with `&exception.ErrorSendToResponse{Err: "Custom business error message"}`.
3. **For Database Operations**: Always check `err := db...Error` and pass to `helper.PanicIfError(err)`.
4. **Preserve Error Identity**: Do not mask errors with arbitrary string formats if higher layers or error handlers rely on `errors.Is` / type assertion.
