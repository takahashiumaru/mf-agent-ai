---
name: api-contract
description: Review or change routes, controllers, request binding, validation, auth, or HTTP responses. Use whenever a public endpoint contract is touched.
---

# Api Contract

Use this skill when its trigger above matches the task. Start with the relevant repository guidance at `../../API.md` and `.agent/INDEX.md`.

## Workflow

1. UNDERSTAND route method/path, callers, status, payload, filtering, ordering, and auth.
2. INSPECT route registration, middleware, controller, service, DTOs, and tests.
3. PLAN compatibility and denied/error behavior.
4. IMPLEMENT only the requested contract change.
5. TEST success and failure responses plus authorization.
6. REVIEW generated examples/callers and response equivalence.

## Hard rules

Preserve status codes, JSON fields, pagination defaults, sort/filter semantics, and error envelopes unless explicitly changed. Verify authorization at object and action level. Do not assume a gateway replaces service checks. Document uncertain behavior as Needs investigation.

## Verification and stop conditions

- Use fresh output from relevant tests, builds, static checks, query plans, or security-negative tests; do not claim checks passed when they were not run.
- Preserve current API, authorization, data-integrity, and side-effect contracts unless a behavior change is explicitly requested.
- Stop and ask for the missing owner/input when target schema, production access, migration policy, or required behavior is unclear. Continue independent read-only analysis.
- Keep changes scoped; inspect `git status` and review the diff before reporting completion.
