---
name: safe-refactoring
description: Use when asked to clean up, improve, modernize, optimize, or refactor legacy code while preserving behavior and limiting scope.
---

# Safe Refactoring

## Core Principle

Leave affected code slightly better without turning a focused task into a repository rewrite.

## Entry Conditions

Read `../../../AGENTS.md`, `../../REFACTORING.md`, `../../TECH_DEBT.md`, and `../../PREFERRED_PATTERNS.md`. Apply `../go-testing/SKILL.md`. Then:

1. characterize current observable behavior;
2. inspect tests and add characterization coverage where needed;
3. inspect callers, interfaces, wiring, database effects, and consumers;
4. identify the repository-preferred pattern;
5. define behavior that must remain unchanged;
6. separate behavior changes from mechanical refactoring.

If the user explicitly asks for a plan or review first, stop after that deliverable and wait for approval.

## Safe Local Improvements

When directly relevant, low-risk, behavior-preserving, and testable, consider:

- handling ignored errors;
- preserving request context;
- simplifying control flow and naming;
- reducing directly relevant duplication;
- making zero-value GORM updates explicit;
- replacing proven N+1 calls with safe batching;
- removing relevant dead code;
- adding regression/characterization tests;
- introducing one useful dependency seam;
- removing unnecessary local abstraction.

Classify legacy code as MIGRATE-WHEN-TOUCHED when local improvement is safe.

## Scope Boundaries

Do not casually introduce architecture rewrites, framework/GORM replacement, package-wide moves, generic repositories, `BaseRepository`, `BaseService`, DI frameworks, CQRS, event sourcing, microservice splitting, repository-wide interface redesign, or unrelated schema redesign.

If improvement requires broad API changes, architecture changes, large migrations, many unrelated call sites, or business behavior changes, document it as technical debt instead of silently expanding scope.

## Repository Examples

- LEGACY — DO NOT COPY FOR NEW CODE: concrete repository construction inside service methods, broad services with mixed responsibilities, and inconsistent panic/status behavior.

## Review Loop

Refactor one seam, run focused tests, review diff and behavior, then stop or repeat only while the next change remains in scope. Use relevant domain skills for Go, GORM, API, security, or performance concerns.

## Completion Gate

- Behavior-preserving claims are backed by tests or explicit characterization.
- Diff contains no unrelated cleanup.
- Dependency direction, API contract, authorization, transactions, and query behavior remain correct.
- Remaining broad debt is recorded, not half-implemented.

## Local navigation and limits

Use `../../PREFERRED_PATTERNS.md` for scoped examples and `../../TESTING.md` for facilities. Survey route/service/repository anchors are outlet_survey or distributor; product repositories use customer_material filenames. Repositories take `*gorm.DB`; services select the read/write handle. SQL mocks check generated statements and calls, not live isolation or replication.
