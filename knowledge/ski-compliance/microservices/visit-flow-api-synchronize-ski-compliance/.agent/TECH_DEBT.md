# Technical debt and risks

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

Reviewed revision: `42d46c3`. Static source assessment only; no tests, live database, or runtime validation was performed. Findings are scoped to named examples and should be rechecked against current callers.

## TD-001 — Review JWT handling at actual middleware call sites

- Classification: INVESTIGATE REACHABILITY
- Evidence: local `auth/auth.go`, actual route imports in [EVIDENCE.md](EVIDENCE.md), and pinned `go.mod` dependencies.
- Observation: local parse-error/validity handling warrants review. Handler imports here: No imported auth wrapper found in the scanned handler expressions.
- Impact: depends on the middleware actually used, global routing, handler assumptions, and deployment. A local helper alone does not establish a production vulnerability.
- Next action: trace the named endpoint, then verify token rejection and authorization boundaries in an isolated, explicitly scoped security task.
- Priority: assess after establishing reachability; no blanket critical rating across repositories.

## TD-002 — Sync transaction handle finalization needs review

- Classification: LOCAL HANDLE MISMATCH
- Evidence: `service/customer_position_service_impl.go`, `SyncCustomerPosition`, defers `CommitOrRollback(tx.Write)` twice after creating both tx and txSki. No txSki.Write finalizer appears in that method.
- Impact: the intended source handle may not be finalized here while the other handle is finalized twice; exact behavior depends on the pinned helper. This is not proof that both databases receive writes or that distributed atomicity is required for this method.
- Related scope: `SyncCustomer` creates independent handles and destination writes; trace source/destination reads and writes before assigning consistency guarantees.
- Next action: review helper semantics and use isolated failure/retry checks in a separately scoped implementation task. No source fix was made in this documentation task.

## TD-003 — Gin context is coupled into sync orchestration

- Classification: MIGRATE-WHEN-TOUCHED
- Evidence: `service/customer_service_impl.go` (`SyncCustomer` accepts `*gin.Context` for tracing and transaction helpers).
- Impact: Orchestration is coupled to the HTTP framework, limiting isolated tests and clear cancellation semantics.
- Scope: Sampled synchronization service only.
- Recommended action: Consider a narrow context/dependency seam only when changing this flow and after checking shared-helper signatures.
- Verification: Deterministic service tests and a cancellation-aware operation.
- Priority: Low

## TD-004 — Verify cancellation through the actual helper and DB handle

- Classification: NEEDS INVESTIGATION
- Evidence: sampled service/repository interfaces, their imported transaction helper, and DB context binding.
- Observation: absence of an explicit context parameter on a repository method does not prove cancellation is lost; the supplied DB handle or shared helper may already carry it. Some services pass Gin context into CreateTransaction.
- Next action: inspect the pinned helper and exact request path before proposing an interface change. Runtime cancellation behavior remains unverified.
- Verification for a future implementation task: isolated cancellation-aware driver/database behavior, with current API compatibility preserved.

## TD-005 — Automated regression coverage is narrow

- Classification: MIGRATE-WHEN-TOUCHED
- Evidence: Existing test files: helper/model_test.go; helper/operator_test.go.
- Impact: Authentication, transaction, API, and database behavior may lack local regression protection; uncovered behavior is not proof of a defect.
- Scope: Current test inventory at revision `42d46c3`.
- Recommended action: Add focused tests when changing the affected behavior; do not add unrelated coverage as a prerequisite to documentation work.
- Verification: Run focused and module-level tests in an isolated environment.
- Priority: Medium

## Needs investigation

- Use the workspace live schema snapshot for observed MySQL/structure facts. Confirm migration ownership, retention policy, exact auth reachability and issuer compatibility separately.
- Trace full cross-database and ETL effects before changing transaction boundaries.
