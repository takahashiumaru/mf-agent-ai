---
name: safe-refactoring
description: Execute behavior-preserving refactoring with automated regression tests. Use when restructuring handlers, helpers, or packages without changing external behavior.
---

# Safe Refactoring Skill

## Purpose & Trigger
Guide safe, incremental refactoring of legacy code without breaking existing API contracts or introducing regressions.

## Workflow
1. **Understand**: Characterize existing behavior, inputs, outputs, and side effects.
2. **Inspect**: Check caller dependencies and verify existing unit tests.
3. **Plan**: Write additional characterization tests if test coverage is below 90%.
4. **Implement**: Apply single focused change; keep legacy compatibility shims if necessary.
5. **Verify**: Run full test suite (`go test ./...`) and inspect `git diff` for unintended changes.

## Hard Rules
- Never change external HTTP API behavior, status codes, or response envelopes during a refactoring task.
