# Preferred patterns

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

These are defaults for new or touched code; they do not authorize unrelated refactoring. Existing code in `repository/account_repository_impl.go` and `service/account_service_impl.go` is evidence of current patterns, not automatic endorsement.

## Layer boundaries

- Classification: PREFERRED
- Applies when: Adding or changing an HTTP operation.
- Rule: Keep route registration, HTTP binding/response, business orchestration, and persistence responsibilities in the existing `route/`, `controller/`, `service/`, and `repository/` packages.
- Why: This matches the repository's directory structure and supports focused review.
- Repository evidence: `app/router.go`, `repository/account_repository_impl.go`, `service/account_service_impl.go`.
- Verification: Trace route → controller → service → repository for the changed operation.
- Legacy alternative: Avoid placing persistence or business workflows in new route declarations.

## Dependency injection

- Classification: ACCEPTABLE
- Applies when: Wiring a route or service.
- Rule: Follow the local constructors and explicit dependencies; add an interface only at a real substitution or consumer boundary.
- Why: Existing files use concrete implementations and interface/implementation pairs; blanket abstractions add indirection.
- Repository evidence: `route/`, `service/`, `repository/account_repository_impl.go`.
- Verification: Check callers and test seams.

## Authentication and errors

- Classification: MIGRATE-WHEN-TOUCHED
- Applies when: Protected endpoint or token processing changes.
- Rule: Reject token parse/validation errors before reading claims or calling handlers; keep public unauthorized mapping stable. The current auth path has a high-priority finding in [SECURITY.md](SECURITY.md).
- Why: Security decisions must fail closed.
- Repository evidence: `auth/auth.go`.
- Verification: Negative tests must prove invalid/missing credentials cannot invoke the handler.
- Legacy alternative: Do not copy `VerifyToken`'s discarded parse error.

## Transactions and side effects

- Classification: ACCEPTABLE
- Applies when: A flow updates multiple rows or databases.
- Rule: Preserve the current service-owned transaction/helper and pass the same transaction handle to every participating repository call. Do not add external calls inside a transaction without tracing lock duration and consistency.
- Why: Services commonly call `Begin`/resolver write handles and `helper/tx.go` supplies commit/rollback behavior.
- Repository evidence: `service/account_service_impl.go`, `helper/tx.go`.
- Verification: Test rollback and every affected store/ETL/audit effect using isolated fixtures.

## GORM writes and deletes

- Classification: PREFERRED
- Applies when: Changing writable fields or deletion.
- Rule: Use a bounded predicate, explicit writable columns, and check `Error`/`RowsAffected` where the contract needs them. Use a map or `Select` for intentional zero values. Require policy evidence for `Unscoped`.
- Why: Prevent silent omitted updates, mass assignment, and unintended physical deletion.
- Repository evidence: `repository/account_repository_impl.go`.
- Verification: Cover zero values, no-match cases, soft/hard delete behavior, audit, and transaction rollback.
- Legacy alternative: Do not assume a struct update writes `false`, `0`, or empty string.

## Reads and response mapping

- Classification: PREFERRED
- Applies when: Listing or expanding related data.
- Rule: Keep filters and ordering explicit, bound result size where contract allows, load associations intentionally, and map API DTOs at the existing web/model boundary.
- Why: Sample repository reads use helper filters and GORM joins; joins/preloads have endpoint-specific semantics.
- Repository evidence: `repository/account_repository_impl.go`, `model/`.
- Verification: Check result cardinality, ordering, query count where relevant, and response equivalence.

## Tests and observability

- Classification: PREFERRED
- Applies when: Changing behavior or telemetry.
- Rule: Add a deterministic regression at the narrowest useful level and preserve existing logger/tracing ownership. Never log tokens or sensitive payloads.
- Why: Existing test inventory is limited (helper/operator_test.go); the router and dependencies configure telemetry.
- Repository evidence: `app/router.go`, `helper/operator_test.go `.
- Verification: Run focused tests and the verified CI command when environment permits.
