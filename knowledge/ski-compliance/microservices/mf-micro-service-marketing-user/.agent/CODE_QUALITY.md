# Code quality review

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Checklist

- Requested behavior, callers, routes, API status/payload/order, and auth compatibility.
- Correct layer ownership and focused scope; no unrelated cleanup.
- Error paths, nil handling, recovery boundary, and duplicate logging.
- GORM predicate, zero-value updates, affected rows, transaction handle, association, delete scope, and audit effects.
- SQL parameterization, dynamic identifier allowlists, authorization, and tenant/company scope.
- Bounded queries and stable pagination; evidence for performance claims.
- Deterministic tests for success, error, denied access, and side effects; race checks when concurrency changes.
- Logs/traces avoid credentials and sensitive data.
- Documentation changes and changelog entries only when guidance/contracts materially change.

## Definition of done

A reviewer can trace request to persistence/side effect, see relevant fresh verification evidence, and confirm the diff has no unrelated behavior changes. Report unavailable test/database gates. Compilation alone is not behavioral verification.
