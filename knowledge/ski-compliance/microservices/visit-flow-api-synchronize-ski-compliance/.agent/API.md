# API conventions

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

Routes are registered in `app/router.go` through `route/*`; endpoint paths and methods are declared in those route files. Gin `v1.9.1` is a direct dependency. Request binding, validation, authentication, and response envelope vary by handler; inspect the targeted route and controller rather than assuming a global contract.

Custom validator dependency: `v10.14.1`. Check controller binding/validation code and route middleware for actual rules. This repository does not contain `helper/custom_validator.go`. Filtering and pagination helpers exist under `helper/` (for example `apply_filter.go` and `filter_from_query_string.go`); confirm if an endpoint uses them.

Status codes, envelopes, pagination defaults, auth requirements, and compatibility guarantees: Not clearly established globally. Preserve the specific endpoint's existing behavior and check callers before changing it.

## Current evidence and shared guidance

See [EVIDENCE.md](EVIDENCE.md) for the concrete source trace, auth import scope and schema/data routing. For business-data questions, follow the workspace [data-first answer contract](../../.agent/DATA_ANSWERS.md).
