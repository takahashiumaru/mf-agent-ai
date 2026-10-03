---
name: safe-refactoring
description: Execute disciplined, incremental refactoring without altering business behavior or breaking public contracts. Use whenever modernizing legacy code or cleaning technical debt.
---

# Safe Refactoring Skill

## Purpose
Guide risk-free, migrate-when-touched refactoring that preserves existing business logic, error propagation, and response contracts.

## When to Use
Use when improving readability, removing dead code, extracting helpers, or eliminating N+1 queries during feature or bugfix tasks.

## Workflow
1. **Characterize**: Identify existing behavior, callers, and error outputs.
2. **Protect**: Add characterization unit tests for the current code paths.
3. **Isolate**: Apply one small, focused change following preferred patterns.
4. **Verify**:
   - Run `go test ./...` and `go vet ./...`.
   - Compare API response JSON before and after.
5. **Review Diff**: Ensure no unrelated files or unintended side effects were introduced.

## Hard Rules
- Never perform wholesale architectural rewrites (such as removing panic-recovery across the service) as part of routine tasks.
- Never alter API response envelopes or HTTP status codes without explicit coordination.

## References
- [.agent/REFACTORING.md](../../REFACTORING.md)
- [.agent/TECH_DEBT.md](../../TECH_DEBT.md)
- [.agent/PREFERRED_PATTERNS.md](../../PREFERRED_PATTERNS.md)
