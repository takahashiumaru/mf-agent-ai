# Engineering workflows

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Add or change an endpoint

1. Find the route file and registration in `app/router.go`.
2. Trace controller → service → repository and model/DTO mapping.
3. Preserve binding, validation, auth, status, and response shape; inspect callers.
4. Add focused tests using the existing package conventions.

## Change business logic

1. Identify service implementation and all callers.
2. Record invariants from source/tests; clarify anything not established.
3. Trace transaction scope and external side effects before editing.
4. Add regression coverage for the changed branch and edge cases.

## Change a query

1. Inspect repository interface and implementation, model tags, and indexes/schema evidence.
2. Preserve predicates, ordering, pagination, associations, and not-found semantics.
3. Check generated SQL or query behavior when needed using a safe test setup.
4. Verify focused tests; do not run against production data.

## Fix a bug

1. Reproduce and trace the full request/data path.
2. Add a regression test where practical.
3. Make the smallest behavior-preserving correction and check adjacent flows.

## Change schema

1. Establish the authoritative schema/migration process first; it is not clearly established by this guide.
2. Review compatibility, existing rows, keys, and deployment ordering.
3. Do not execute DDL or data migrations as part of local analysis without explicit authorization.
