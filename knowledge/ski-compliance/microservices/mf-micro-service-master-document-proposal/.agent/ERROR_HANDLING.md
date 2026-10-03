# Error handling

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

Cross-cutting error code is in `exception/error.go`, `exception/error_handler.go`, and `helper/error*.go`; inspect these before creating or mapping errors. Router middleware is configured in `app/router.go`; verify panic recovery and logging behavior there.

Trace errors from repository through service and controller to the HTTP response. Determine which layer logs each error to avoid duplicate or missing logs. Not-found, validation, duplicate, and database error mappings can differ by endpoint. Do not expose SQL details, credentials, or internal stack traces in public responses.
