# Error Handling

## Error Types

`exception/error.go` defines sentinel errors:

- `ErrPermissionDenied`
- `ErrRecordNotFound` (defined but not used by current application code)
- `ErrUnauthorized`
- `ErrRefreshTokenExpired`

It also defines `*exception.ErrorSendToResponse`, a message-carrying error mapped to HTTP 400.

GORM errors, validator errors, parsing errors, filesystem errors, and ordinary `errors.New`/`fmt.Errorf` values also flow through the system.

## Error Creation and Propagation

The dominant pattern is panic-based:

```go
err := operation()
helper.PanicIfError(err)
```

Controllers, services, and repositories use either the local helper or the equivalent private-module helper. `main.go`'s `ErrorHandler` middleware recovers, prints a stack trace, and calls `exception.ErrorHandler`.

Some functions return errors when callers need to branch, notably JWT helpers, hierarchy queries, device lookup, and GORM transaction callbacks.

## Error Wrapping

`fmt.Errorf("...: %w", err)` appears in Firebase initialization and preserves the wrapped cause. Other `fmt.Errorf` uses construct signing/configuration errors without wrapping. `errors.Join` is not used.

Preserve `%w` when callers may use `errors.Is`/`errors.As`. Do not replace sentinel errors with same-text errors where identity is significant.

## `errors.Is` and `errors.As`

- `errors.Is` is used for `gorm.ErrRecordNotFound` in user/session repositories.
- `errors.Is` is used in the HTTP mapper for unauthorized, refresh-expired, and permission-denied sentinels.
- `errors.As` is not used.

The record-not-found HTTP mapper compares `exception.Error() == "record not found"` rather than using `errors.Is`; this is an existing inconsistency.

## Repository Errors

- Most repository errors panic unchanged through `PanicIfError`.
- `FindByUserName` and `FindByEmail` translate `gorm.ErrRecordNotFound` to `exception.ErrUnauthorized` to avoid distinguishing missing credentials.
- `SessionRepository.FindByRefreshUUID` also translates not-found to unauthorized.
- `FindByDeviceIDAndUserID` returns the raw error to its service.
- Hierarchy lookup returns `errors.New("data not found")` when no user row is found.
- Refresh consumption returns a boolean based on `RowsAffected == 1`; the service returns `ErrUnauthorized` when consumption fails.

Duplicate keys and foreign-key failures are not translated in repositories. `exception/error_handler.go` matches MySQL error 1062 and 1451 text and converts them to HTTP 400 messages using helper functions.

Database-unavailable and unrecognized transaction failures reach the generic HTTP 500 handler.

## Usecase/Service Errors

- Validator failures panic as `validator.ValidationErrors`.
- Business-facing password mismatch and period-denied cases use `*ErrorSendToResponse`.
- Authentication failures use sentinel unauthorized errors or return an empty/nil token result for controller-specific 401 responses.
- Service transaction callback errors are returned to GORM, then panicked after `DB.Transaction` returns.

## HTTP Mapping

`exception.ErrorHandler` checks errors in this order:

1. validator errors -> 400, `success: false`, message `Bad Request`, validation detail in `data`
2. `*ErrorSendToResponse` -> 400
3. `ErrPermissionDenied` -> 403
4. MySQL foreign-key error text -> 400
5. error text exactly `record not found` -> 200, `success: true`, message `Record not found`
6. `ErrUnauthorized` or `ErrRefreshTokenExpired` -> 401
7. MySQL duplicate error text -> 400
8. anything else -> 500

`auth.Auth` and `GatewayAuthMiddleware` bypass this mapper for normal invalid-token handling and return `{"error": ...}` with 401.

## Logging

The panic recovery middleware prints a stack trace before mapping the error. Notification helpers log their own asynchronous failures because those errors cannot propagate to the request. Database methods generally do not log before panicking; GORM's configured logger logs SQL.

Avoid logging the same error in every layer. Never log full JWTs, refresh tokens, passwords, database DSNs, SMTP credentials, or Firebase credentials. Existing token-preview logging truncates the Firebase token.

## Rules for Future Changes

- Preserve sentinel identity wherever `errors.Is` is used.
- Return errors from `DB.Transaction` callbacks so GORM rolls back.
- If a repository method follows the panic convention, ensure the request passes through recovery middleware.
- Do not convert a not-found behavior without reviewing its HTTP contract and tests; `First` and `Find` currently have intentionally different semantics.
- If adding a new public error, update the exception mapper and focused tests together.
- Do not parse database error strings in new locations; centralize behavior in the existing mapper unless the task requires a broader error redesign.
