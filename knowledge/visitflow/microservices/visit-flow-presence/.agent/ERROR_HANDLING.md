# Error Handling

## Overall Flow

The application uses panic-based propagation:

1. Controllers, services, repositories, and helpers call `helper.PanicIfError(err)`.
2. The helper panics when `err != nil`.
3. `app.ErrorHandler` recovers, prints a stack trace, and calls `exception.ErrorHandler`.
4. `exception.ErrorHandler` chooses an HTTP JSON response.

This is established behavior. Do not replace one layer with returned errors in isolation; interface signatures and global mapping assume panics.

## Error Types

`exception/error.go` defines sentinel errors:

- `ErrPermissionDenied`
- `ErrRecordNotFound`
- `ErrUnauthorized`
- `ErrRefreshTokenExpired`

It also defines `*exception.ErrorSendToResponse`, a custom error carrying a user-facing message. Services use it for business validation such as unavailable quota, invalid state transitions, missing manager structure, file size, and geofence failures.

`ErrRecordNotFound` exists but repository GORM errors normally flow through directly; it is not broadly translated to that sentinel.

## Creation and Wrapping

- Routine propagation: `helper.PanicIfError(err)`.
- Business message: `&exception.ErrorSendToResponse{Err: "..."}` then panic.
- Some low-level/auth/parser functions return errors and use `fmt.Errorf`.
- `%w` wrapping is used in newer presence parsing code; many Firebase errors use `%v`, which does not preserve identity.
- `errors.Join` is not used.

Use `%w` when callers need `errors.Is`/`errors.As`. Preserve the concrete `*ErrorSendToResponse` type when the HTTP mapper depends on type assertion.

## `errors.Is` / `errors.As`

`exception.ErrorHandler` uses `errors.Is` for unauthorized/refresh-expired and permission-denied sentinels. No application `errors.As` usage was found. Validation handling uses a direct assertion to `validator.ValidationErrors`; business response handling directly asserts `*ErrorSendToResponse`.

Do not wrap or replace these errors in a way that breaks the expected identity/type.

## Repository and GORM Errors

Repositories usually panic with the original GORM/MySQL error. Mapping behavior:

- `gorm.ErrRecordNotFound`: recognized by exact error text `record not found`; returns HTTP 200 and `success:true`.
- MySQL duplicate key: detected by substring `Error 1062 (23000): Duplicate entry`; returns HTTP 400 with `helper.ErrorDuplicateMessage`.
- Foreign-key violation: detected by substring `Error 1452: Cannot add or update a child row`; returns HTTP 400.
- Database unavailable/query/commit errors: no special mapping; HTTP 500.
- Transaction panic: `helper.CommitOrRollback` rolls back and re-panics. Successful return commits; commit failure panics.

`LeaveQuotaRepository.Validate` explicitly treats `gorm.ErrRecordNotFound` as expected absence and returns a zero value.

String matching makes driver messages compatibility-sensitive. If changing the driver/error translation, update error tests and HTTP expectations.

## Service Errors

Business-state failures are generally created at service level with `ErrorSendToResponse`. They map to HTTP 400 and preserve their message. State transition checks are common in `service/leave_service_impl.go` and geofence checks in `service/meeting_member_service_impl.go`.

## HTTP Mapping

All mapped errors use `web.WebResponse`:

| Error | HTTP | Success |
| --- | ---: | --- |
| validator errors | 400 | false |
| `*ErrorSendToResponse` | 400 | false |
| permission denied | 403 | false |
| foreign key | 400 | false |
| record not found | 200 | true |
| unauthorized/refresh expired | 401 | false |
| duplicate key | 400 | false |
| everything else | 500 | false |

Preferred tests: `exception/handler_test.go` for error mapping and `test/router_coverage_test.go` for recovery middleware wiring.

## Logging

Global recovery prints a stack trace with `fmt.Println`; the HTTP response hides internal error details for 500s. Request logging occurs in middleware. Async notification failures are logged in the goroutine/helper. There is no uniform structured application-error logging policy beyond these mechanisms.

Avoid logging the same error at every synchronous layer, and never include secrets, JWTs, DSNs, Firebase tokens, or credential files.

## Rules

- Preserve error identity where `errors.Is` or type assertions are used.
- Check every GORM error and transaction begin/commit/rollback error.
- Do not turn not-found into a conventional 404 incidentally; current API behavior is HTTP 200.
- Do not return raw DB/internal errors to clients.
- Do not swallow async errors; recover/log within detached goroutines.
- Add/update error mapping tests when adding a new error type.
