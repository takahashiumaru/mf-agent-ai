# .agent/REFACTORING.md — Safe Refactoring & Migrate-When-Touched Strategy

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

This document defines the rules and multi-step workflow for improving legacy code safely in `mf-micro-service-discount-proposal` without introducing regressions.

---

## 1. The Migrate-When-Touched Principle

Do not perform broad, speculative refactoring across untouched modules. Instead, apply the **Migrate-When-Touched** principle:
- When a task requires modifying or extending a specific module, upgrade legacy patterns in that touched file to the **PREFERRED** pattern.
- If a file is not directly related to the user's task, leave it untouched to minimize change blast radius.

---

## 2. Standard Safe Refactoring Workflow

Follow this 6-step loop for all refactoring activities:

```text
┌────────────────────────┐
│ 1. Characterize        │ Understand existing behavior, quirks, and implicit constraints
└───────────┬────────────┘
            ▼
┌────────────────────────┐
│ 2. Trace Callers       │ Identify all callers, database side effects, and ETL triggers
└───────────┬────────────┘
            ▼
┌────────────────────────┐
│ 3. Add Protection      │ Add unit/characterization tests before altering code
└───────────┬────────────┘
            ▼
┌────────────────────────┐
│ 4. Focused Change      │ Apply ONE localized improvement at a time
└───────────┬────────────┘
            ▼
┌────────────────────────┐
│ 5. Verify              │ Run tests, static analysis (`go vet`), and build checks
└───────────┬────────────┘
            ▼
┌────────────────────────┐
│ 6. Review Diff         │ Inspect `git diff` to ensure zero unintended changes
└────────────────────────┘
```

---

## 3. High-Risk Changes Requiring Dedicated Tasks

The following refactorings MUST NOT be performed as opportunistic drive-by changes during feature or bug-fix tasks. They require explicitly scoped, dedicated tasks:

| Refactoring Type | Risk Factors | Dedicated Task Requirements |
| :--- | :--- | :--- |
| **Database Schema Redesign / Table Renaming** | Production downtime, lock contention, external ETL breakage. | Requires schema migration script, DBA alignment, and sync update. |
| **Public API / DTO Schema Changes** | Breaking mobile app and web frontend clients. | Requires API versioning and coordination with client teams. |
| **Cross-Module Architecture Rewrites** | Introducing new frameworks, DI containers, or ORM replacements. | Requires architectural RFC and comprehensive regression testing. |
| **Global `context.Context` Introduction** | Modifying all controller, service, and repository method signatures. | Requires repository-wide signature migration in staged PRs. |
| **Replacing Goroutine ETL with Redis/Outbox** | Upstream synchronization failure. | Requires queue infrastructure validation and consumer verification. |
| **Re-enabling Role Authorization** | Blocking existing users whose roles were previously unenforced. | Requires role mapping audit and staging verification. |

---

## 4. Safe Opportunistic Refactoring Checklist

When touching a legacy file during a feature or bug-fix task, you MAY safely perform these localized improvements:

- [ ] **Parameterize Raw SQL**: Replace `fmt.Sprintf` query fragments with `?` bindings (e.g. `TD-001`).
- [ ] **Fix Zero-Value Updates**: Replace `Updates(&struct)` with `Updates(map[string]interface{}{...})` when setting nullable fields (e.g. `TD-005`).
- [ ] **Correct Soft-Delete Filters**: Add `deleted_at IS NULL` to joins on `CreditNote` or `CustomerBalance` (e.g. `TD-004`).
- [ ] **Clean Up Double Pointers**: Fix `Where(&where)` to `Where(where)` in repositories (e.g. `TD-002`).
- [ ] **Add Missing Unit Tests**: Add test cases for the specific function being modified.
