---
name: safe-refactoring
description: Use when performing incremental refactoring, cleaning legacy code, eliminating technical debt, or optimizing existing implementations safely.
---

# Safe Refactoring Skill

## Guidelines
1. **Separate Commits**: Never mix refactoring with feature modifications.
2. **Preserve Contracts**: Keep JSON structures, status codes, and database column semantics identical.
3. **Incremental Migration**: Improve code in-place during active edits (e.g. adding query limits, fixing zero-value updates, adding history logs).
4. **Test Before and After**: Run package unit tests before and after making any change.

See [.agent/REFACTORING.md](../../REFACTORING.md) and [.agent/TECH_DEBT.md](../../TECH_DEBT.md).
