---
name: backend-security
description: Trace untrusted input through authentication, authorization, SQL, files, outbound requests, logs, and dependencies. Use for security-sensitive changes or reviews.
---

# Backend Security

Use this skill when its trigger above matches the task. Start with the relevant repository guidance at `../../SECURITY.md` and `.agent/INDEX.md`.

## Workflow

1. UNDERSTAND trust boundaries and requested security scope.
2. INSPECT route protection, token validation, claim use, object scope, query inputs, file/network sinks, and logs.
3. PLAN negative tests and smallest compatible remediation.
4. IMPLEMENT only when a security fix is explicitly in scope.
5. TEST denied/malformed/tampered/expired credentials and object/action boundaries.
6. REVIEW severity, confidence, preconditions, response compatibility, and residual risk.

## Hard rules

Local auth handling and route-specific reachability are documented in `SECURITY.md` and `EVIDENCE.md`; imported gateway auth may differ. Do not repeat its fail-open pattern. Never probe production, expose secrets, or trust request-supplied tenant/owner IDs. Security discovery alone is not permission to alter runtime behavior; report evidence and stop for a separately scoped fix.

## Verification and stop conditions

- Use fresh output from relevant tests, builds, static checks, query plans, or security-negative tests; do not claim checks passed when they were not run.
- Preserve current API, authorization, data-integrity, and side-effect contracts unless a behavior change is explicitly requested.
- Stop and ask for the missing owner/input when target schema, production access, migration policy, or required behavior is unclear. Continue independent read-only analysis.
- Keep changes scoped; inspect `git status` and review the diff before reporting completion.
