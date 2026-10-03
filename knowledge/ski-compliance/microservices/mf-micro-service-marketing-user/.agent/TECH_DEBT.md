# Technical debt and risks

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

Reviewed revision: `f8e5345`. Static source assessment only; no tests, live database, or runtime validation was performed. Findings are scoped to named examples and should be rechecked against current callers.

## TD-001 — Review JWT handling at actual middleware call sites

- Classification: INVESTIGATE REACHABILITY
- Evidence: local `auth/auth.go`, actual route imports in [EVIDENCE.md](EVIDENCE.md), and pinned `go.mod` dependencies.
- Observation: local parse-error/validity handling warrants review. Handler imports here: `gitlab.com/VNEU/mf-micro-service-marketing-user/auth`: 33 declarations
- Impact: depends on the middleware actually used, global routing, handler assumptions, and deployment. A local helper alone does not establish a production vulnerability.
- Next action: trace the named endpoint, then verify token rejection and authorization boundaries in an isolated, explicitly scoped security task.
- Priority: assess after establishing reachability; no blanket critical rating across repositories.

## TD-002 — Hard-delete operations require explicit retention review

- Classification: RETENTION REVIEW
- Evidence: `repository/group_menu_authentication_repository_impl.go` (`Delete` uses `Unscoped().Delete` in the sampled implementation).
- Impact: `Unscoped` bypasses GORM's normal soft-delete scope where model support applies; the row may be physically removed after history side effects.
- Scope: The sampled Delete operation only.
- Recommended action: Preserve current behavior until retention and API compatibility are confirmed; require explicit policy for new hard deletes.
- Verification: Isolated regression tests for visibility, history, and rollback; never use production data.
- Priority: High

## TD-003 — Struct-based updates can omit intentional zero values

- Classification: MIGRATE-WHEN-TOUCHED
- Evidence: `repository/user_repository_impl.go` (`Update`/`Delete` chains call `Updates` with a struct); check additional update methods individually.
- Impact: GORM's traditional `Updates(struct)` skips zero-valued fields by default, so clearing strings or persisting `false`/`0` may not produce the intended write.
- Scope: The sampled method and any analogous callers, subject to actual GORM model/type behavior.
- Recommended action: When a requested zero value must persist, use an explicit writable-field map or selected fields and preserve the endpoint's field allowlist.
- Verification: Test zero and non-zero values, `RowsAffected`, not-found behavior, and audit effects.
- Priority: Medium

## TD-004 — Verify cancellation through the actual helper and DB handle

- Classification: NEEDS INVESTIGATION
- Evidence: sampled service/repository interfaces, their imported transaction helper, and DB context binding.
- Observation: absence of an explicit context parameter on a repository method does not prove cancellation is lost; the supplied DB handle or shared helper may already carry it. Some services pass Gin context into CreateTransaction.
- Next action: inspect the pinned helper and exact request path before proposing an interface change. Runtime cancellation behavior remains unverified.
- Verification for a future implementation task: isolated cancellation-aware driver/database behavior, with current API compatibility preserved.

## TD-005 — Automated regression coverage is narrow

- Classification: MIGRATE-WHEN-TOUCHED
- Evidence: Existing test files: helper/operator_test.go.
- Impact: Authentication, transaction, API, and database behavior may lack local regression protection; uncovered behavior is not proof of a defect.
- Scope: Current test inventory at revision `f8e5345`.
- Recommended action: Add focused tests when changing the affected behavior; do not add unrelated coverage as a prerequisite to documentation work.
- Verification: Run focused and module-level tests in an isolated environment.
- Priority: Medium

## Needs investigation

- Use the workspace live schema snapshot for observed MySQL/structure facts. Confirm migration ownership, retention policy, exact auth reachability and issuer compatibility separately.
- Trace full cross-database and ETL effects before changing transaction boundaries.
