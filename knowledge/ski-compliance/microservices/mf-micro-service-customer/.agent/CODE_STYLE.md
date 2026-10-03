# Code style

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

Observed conventions are conventional Go package directories and paired interface/implementation files (for example `*_controller.go` with `*_controller_impl.go`, and corresponding service/repository pairs). Follow the nearest neighboring implementation rather than imposing one pattern repo-wide.

- Format Go changes with `gofmt`.
- Preserve exported identifiers and JSON/GORM tags; treat them as compatibility contracts.
- Check existing constructor and interface patterns in the target package before adding abstractions.
- Keep `context.Context`, pointer/value choices, error wrapping, and logging consistent with adjacent functions; repository-wide uniformity is not established.
- Avoid assuming comments or helper names alone prove behavior; inspect callers and tests.
