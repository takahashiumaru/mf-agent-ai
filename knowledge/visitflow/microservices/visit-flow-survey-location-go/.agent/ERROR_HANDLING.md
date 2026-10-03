# Survey Error Handling

Inspect `helper/error.go` and middleware registration in `app/router.go`. The request chain uses helper panics plus the pinned external logger's recovery mapping. Some repository methods, including outlet-survey FindByID, explicitly return errors. Preserve the affected method contract rather than applying one convention indiscriminately.

For changed behavior, trace validation → repository error → service handling → transaction completion → middleware JSON. Verify exact not-found, duplicate/constraint, auth and business mappings in the pinned dependency and an HTTP test before asserting a status code. Wrapping an error can affect exact-string classification; do not assume errors.Is alone preserves the response.

Expected errors may be returned from new internal functions; their callers must translate/propagate them through the existing boundary. Do not swallow errors, continue after a failed write, or replace error architecture in one layer. Report the triggering error and secondary rollback failures without exposing credentials or payloads.

Relevant tests: `test/controller_test.go`, `test/service_test.go`, `test/repository_test.go`, `test/router_test.go`. Mocked failures do not establish actual MySQL rollback or deployed error responses.
