# Prompt Pack Review

## Scope and evidence

This review updates reusable instructions, not application code. Evidence includes the original seven prompts, current engineering guidance, and focused history in the Visit Flow workspace. Historical examples inform regression checks; they must be revalidated in each target repository.

- `visit-flow-go`, commit `fcb5c1a`: date-range rewrites, join simplification, write-handle reloads, delimiter-aware identifiers and duplicate-query removal. These changes motivate semantic-equivalence checks; this review does not certify that commit's application behavior.
- `visit-flow-go`, commit `14551bb`; presence and gateway Makefiles/CI: coverage and static-analysis gates exist, but inspected Makefile thresholds are 70%. Existing CI success therefore cannot establish a new 90% requirement.
- `visit-flow-go/.agent/TECH_DEBT.md`: transaction lifecycle, replica consistency, error mapping, zero-value updates and N+1 risks. Treat this document as historical guidance requiring source verification, not an up-to-date inventory of remaining defects.
- Presence history includes lint-tool compatibility changes; prompts should detect toolchain compatibility rather than blindly install the latest linter.

These paths describe the source workspace and need not exist after this pack is copied elsewhere. They are evidence references, not required inputs for execution.

## Improvements applied

1. Added a README defining task modes, permitted effects and copy-and-run invocations.
2. Translated the testing prompt completely into English and corrected its filename references.
3. Made staging/committing conditional on explicit user requests.
4. Added focused Git-history inspection, current-revision evidence and stale-document checks.
5. Removed automatic approval pauses within an already authorized documentation sequence.
6. Made skill topics evidence-driven and clarified that `.agent/skills/` is not universally auto-discovered.
7. Kept local optimization work independent of production deployment/DDL authorization.
8. Added regression requirements for filtered join counts, batch ordering/missing keys, timezone boundaries, GORM statement reuse, model write effects and read/write resolver behavior.
9. Replaced rounded coverage gating with exact covered/total statement counting and malformed/empty-profile rejection.
10. Added module-scope checks, integration/unit coverage distinctions and explicit missing-tool limitations.
11. Clarified that lower query count, green unit tests and absence of explicit locking do not prove lower latency, complete compatibility or zero database waits.

## Remaining limits

Security/performance follow-up: added prompt 08, required `.agent/SECURITY.md` from prompt 04, strengthened existing security/MySQL skill contracts and added negative security tests to prompt 07. Query guidance now explicitly covers access predicates, realistic workload variation, latency distributions, resource budgets and cache compatibility. Official Go, GORM, MySQL and OWASP references are linked in the relevant prompts. This is a documentation improvement, not a completed security audit or performance certification of an application.

The pack improves execution discipline; it cannot guarantee that every agent follows it or that every repository reaches 90% without additional infrastructure. Real MySQL semantics and performance require appropriate integration data and measurements. A target repository's explicit business contracts remain authoritative.
