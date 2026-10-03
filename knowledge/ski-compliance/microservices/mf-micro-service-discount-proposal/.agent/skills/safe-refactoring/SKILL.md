---
name: safe-refactoring
description: Execute safe, incremental refactoring on legacy Go, GORM, and repository code without behavioral regressions or unintended side effects. Use whenever improving code design, reducing technical debt, or migrating legacy patterns.
---

# safe-refactoring

Guides safe, incremental refactoring in `mf-micro-service-discount-proposal`.

## Core References
- [REFACTORING.md](../../REFACTORING.md) — 6-step migrate-when-touched workflow, dedicated task criteria.
- [TECH_DEBT.md](../../TECH_DEBT.md) — Known technical debt items (`TD-001` through `TD-010`).
- [PREFERRED_PATTERNS.md](../../PREFERRED_PATTERNS.md) — Preferred engineering targets.

## Standard Workflow
1. **Characterize**: Understand existing logic, edge cases, and zero-value update behaviors.
2. **Trace**: Identify all callers in controllers and side effects (`helper.CreateHistory`, `helper.EtlToMssql`).
3. **Add Protection**: Write regression/characterization tests covering current behavior.
4. **Make Focused Change**: Apply ONE localized improvement (e.g. parameterize SQL query, fix map update).
5. **Verify**:
   - `go vet ./...`
   - `go test ./...`
   - `go build -o /dev/null .`
6. **Review Diff**: Inspect `git diff` to ensure zero unintended changes.

## Hard Guardrails
- **DO NOT** perform broad, drive-by refactoring on untouched files.
- **DO NOT** perform schema changes or public API changes as part of an ordinary refactor.
- **NEVER** break transaction boundaries or bypass `helper.CommitOrRollback(tx)`.
