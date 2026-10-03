# Safe refactoring

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

Use this sequence for changes intended to preserve behavior:

`characterize behavior → identify callers/side effects → add protection → make one focused change → verify → review diff`

## Required review

1. Compare current and intended behavior at the endpoint and persistence layers.
2. Inspect callers, route middleware, transactions, history/ETL, and database resolver handles.
3. Protect existing payload, status, ordering, authorization, row scope, and side effects with focused tests where feasible.
4. Change one concern at a time; avoid broad file renames or generated-style rewrites.
5. Review the final diff for accidental API, data, or dirty-file changes.

## Safe touched-code opportunities

- Replace ignored JWT parse errors only under an explicit security-fix scope and with negative tests; see [SECURITY.md](SECURITY.md).
- Make zero-value writes explicit when behavior requires them; preserve the input field allowlist.
- Improve context propagation only through a bounded call path and compatible interface updates.
- Replace hard deletes only after confirming retention and client-visible behavior.

## Dedicated tasks required

Use a separate plan for schema redesign, public API changes, cross-database synchronization redesign, broad context propagation, dependency replacement, or high-impact query optimization. Do not use a refactor as cover for changing business behavior.

## Verification

Run focused tests first, then module-level checks that are available. For SQL changes, compare rows and query behavior in isolated data. Do not claim semantics are unchanged from compilation alone.
