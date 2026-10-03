# Error Handling

## Dominant Error Flow

Most functions do not return errors through every layer. They call:

```go
helper.PanicIfError(err)
```

which panics when `err != nil`. `helperLogger.ErrorHandler(helper.DatabaseErrors)` in `app/router.go` recovers the panic, maps known error types/text to HTTP responses, logs a stack trace, and prevents the process from failing for request panics.

This behavior also drives transaction rollback: `goHelper.CommitOrRollback(tx.Write)` recovers, rolls back, and re-panics for the HTTP middleware.

## Error Types

- Validation errors: `validator.ValidationErrors` -> HTTP 400.
- Business/client errors: `*gitlab.com/VNEU/go-helper/exception.ErrorSendToResponse` -> HTTP 400 with its message.
- Permission/unauthorized sentinel errors from the logger exception package -> 403/401 via `errors.Is`.
- GORM/database errors: usually panic as their original `error`.
- Direct auth failures: `auth.Auth` aborts with HTTP 401 and `{"error": ...}`.

The repository itself defines no broad custom error hierarchy.

## Creation and Wrapping

Business checks typically construct `&exception.ErrorSendToResponse{Err: "..."}` and pass it to `PanicIfError`. `fmt.Errorf` with `%w` is used in authentication claim parsing, preserving a lower-level parse error. `errors.Is` is used inside external error middleware for sentinel authorization errors. `errors.As` and `errors.Join` were not found in application code.

If callers depend on error identity, preserve it with `%w`; do not convert it to an unrelated formatted string.

## Repository and GORM Errors

Most repositories immediately panic on `result.Error`. There is little translation at the repository boundary.

- `gorm.ErrRecordNotFound`: external middleware checks the exact text `record not found` and returns HTTP 200, `success: true`, message `Record not found`.
- Duplicate key: middleware looks for MySQL error 1062 text and maps known substrings from `helper.DatabaseErrors`; default is `record already exists`.
- Foreign-key/other constraint text: mapped to HTTP 400 with a configured message or `database error`.
- Other database failures: HTTP 500.
- Transaction begin/commit/rollback failure: propagated through panic; commit helper tolerates an already-finished transaction message.

Newer estimation repositories (`area_recomendation_estimation`, `product_recommendation_estimation`) return errors from some methods, and services explicitly turn missing rows into business errors. Preserve that module-local contract.

## HTTP Mapping

The mapping implementation is provided by `gitlab.com/VNEU/logger` and installed globally. Its response envelope is compatible in shape with the local `WebResponse` but defined in the dependency.

Notable behavior:

- Not-found is a successful HTTP 200, not 404.
- Business errors all become 400; there is no local typed mapping to 409/422.
- Fatal/unrecognized panics become 500 with a generic message; the recovered value is printed/logged server-side.

Do not change one endpoint to a new error contract without checking clients and global middleware.

The effective not-found JSON fields are `success: true`, `message: "Record not found"`, with the dependency envelope's remaining fields at their zero values. Recognition is brittle: middleware compares `err.Error()` exactly, so a wrapped `gorm.ErrRecordNotFound` may fall through to HTTP 500 even when `errors.Is` would succeed. Some newer services instead translate absence to `ErrorSendToResponse` and return HTTP 400. Inspect the affected module before preserving or changing this behavior.

## Logging Rules

The recovery middleware logs recovered stack traces and sends asynchronous error logs. Avoid logging the same database error at every layer. Asynchronous notification goroutines log their own delivery failures because they occur after/detached from the response flow.

Never include JWTs, DSNs, secrets, Firebase credentials, or full sensitive request bodies in errors/logs.

## Practical Rules

- In existing request flows, propagate errors with the local `PanicIfError`/business-error pattern.
- Validate before performing writes.
- Preserve the original panic so deferred transaction rollback occurs.
- Do not swallow GORM errors or return partially successful data silently.
- Keep repository methods that explicitly return `error` explicit; do not both panic and return the same error.
- Update `helper.DatabaseErrors` only for verified MySQL constraint identifiers and user-safe messages.
- Check external error middleware behavior before introducing new custom types.
