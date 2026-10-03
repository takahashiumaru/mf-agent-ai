---
name: observability
description: Change or review logs, metrics, traces, correlation, slow-query instrumentation, or background-job signals. Use whenever observability behavior is in scope.
---

# Observability

Use this skill when its trigger above matches the task. Start with the relevant repository guidance at `../../ARCHITECTURE.md` and `.agent/INDEX.md`.

## Workflow

1. UNDERSTAND the operation and signals needed by its owner.
2. INSPECT router middleware, tracer/provider setup, GORM plugins, logs, and error mapping.
3. PLAN signal ownership, cardinality, status, and redaction.
4. IMPLEMENT using existing instrumentation dependencies.
5. TEST emitted success/error/cancel signals with synthetic data.
6. REVIEW sampling, shutdown, duplicate logging, and sensitive attributes.

## Hard rules

Preserve existing tracing/logger ownership. Do not add high-cardinality IDs as metric labels or emit tokens, secrets, SQL credentials, or sensitive payloads. Confirm exporter and collector settings without printing environment values. Do not infer observability coverage from a dependency alone.

## Verification and stop conditions

- Use fresh output from relevant tests, builds, static checks, query plans, or security-negative tests; do not claim checks passed when they were not run.
- Preserve current API, authorization, data-integrity, and side-effect contracts unless a behavior change is explicitly requested.
- Stop and ask for the missing owner/input when target schema, production access, migration policy, or required behavior is unclear. Continue independent read-only analysis.
- Keep changes scoped; inspect `git status` and review the diff before reporting completion.
