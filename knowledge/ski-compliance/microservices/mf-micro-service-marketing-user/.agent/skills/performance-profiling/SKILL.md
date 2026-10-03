---
name: performance-profiling
description: Profile application or database performance for a stated bottleneck and compare before/after evidence. Use when runtime performance is an explicit goal.
---

# Performance Profiling

Use this skill when its trigger above matches the task. Start with the relevant repository guidance at `../../DATABASE_PERFORMANCE.md` and `.agent/INDEX.md`.

## Workflow

1. UNDERSTAND the target workload and success metric.
2. INSPECT current traces/logs, query counts, data distribution, and bottleneck evidence.
3. PLAN a reproducible baseline and representative load.
4. IMPLEMENT one focused change.
5. TEST correctness and compare latency, allocations/CPU, DB calls, rows, locks, or pool pressure separately.
6. REVIEW reproducibility and limitations before making a performance claim.

## Hard rules

Do not optimize from intuition when measurement is available. Keep query-count and latency claims separate. Use synthetic or approved environments, not production experiments without explicit authorization. Stop if workload, baseline, or safe environment cannot be established.

## Verification and stop conditions

- Use fresh output from relevant tests, builds, static checks, query plans, or security-negative tests; do not claim checks passed when they were not run.
- Preserve current API, authorization, data-integrity, and side-effect contracts unless a behavior change is explicitly requested.
- Stop and ask for the missing owner/input when target schema, production access, migration policy, or required behavior is unclear. Continue independent read-only analysis.
- Keep changes scoped; inspect `git status` and review the diff before reporting completion.
