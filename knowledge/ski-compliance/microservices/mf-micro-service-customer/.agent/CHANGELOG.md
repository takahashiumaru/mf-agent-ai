# Engineering guidance changelog

This file records material changes to the repository's AI engineering guidance. It is not an application release changelog. Read it only when historical guidance context is needed.

## 2026-09-27 — Connect live schema context and data-first analysis

- Added workspace data/brainstorming routing, CLAUDE entrypoint, shared skill links, and repository-specific EVIDENCE.md.
- Replaced unavailable-schema claims with the dated workspace metadata catalog.
- Scoped auth findings to actual imported middleware; corrected unsupported cancellation conclusions and transaction assumptions.
- Preserved existing application code and dirty files; no database writes, migration, service startup or application tests.

## 2026-09-27 — Add repository-specific agent skills

### Added
- Added task-oriented skill guidance and routing from `AGENTS.md` and `.agent/INDEX.md`.
- Reason: Load only the engineering guidance relevant to the task.

## 2026-09-27 — Define Go, GORM, database, and security standards

### Added
- Added repository-specific Go, GORM, MySQL performance, code quality, and security standards.
- Reason: Make correctness, data integrity, security, and compatibility checks explicit.

## 2026-09-27 — Assess legacy patterns and safe refactoring

### Added
- Added evidence-based technical debt, preferred-pattern, refactoring, and quality-gate guidance.
- Reason: Keep future maintenance incremental and behavior-preserving.

## 2026-09-27 — Establish repository context routing

### Added
- Added repository architecture, API, persistence, domain, error, testing, and workflow context.
- Reason: Let agents start from verified repository evidence rather than assumptions.

## 2026-09-27 — Evidence-first guidance rollout

- Unified selective entry points and CLAUDE imports; linked workspace data-first and environment/confirmation rules.
- Added maintenance guidance, current source/test inventory and explicit evidence limits.
- Clarified compatibility exceptions and requested-test policy over inherited blanket rules; retained detailed historical topics.
- Documentation only: no application source, dependency, runtime or database changes; no tests/build/startup performed.
