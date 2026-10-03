# Error handling

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

Cross-cutting error helpers are in `helper/error.go` and `helper/error_duplicate_message.go`. `app/router.go` installs logger/error middleware from `gitlab.com/VNEU/logger`; inspect its usage here and the local `helper.DatabaseErrors` mapping. This repository has no local `exception/` directory.

Trace errors from repository through service and controller to the HTTP response. Determine which layer logs each error to avoid duplicate or missing logs. Not-found, validation, duplicate, and database error mappings can differ by endpoint. Do not expose SQL details, credentials, or internal stack traces in public responses.
