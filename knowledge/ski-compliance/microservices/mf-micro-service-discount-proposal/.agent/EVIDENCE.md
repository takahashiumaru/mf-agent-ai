# Current evidence and exceptions

Reviewed: 2026-09-27. Local HEAD: `5dde98ade3b1136eb6750c3c2bf225417f60259c`. This is a source/documentation review, not deployment verification or a fresh test run.

## Evidence priority

Use direct user instructions and workspace authorization, then this repository AGENTS.md. This page resolves factual conflicts in older topic documents. Exact current code and dated live metadata establish observed behavior; preferred patterns describe desired changes, not facts about all existing paths.

| Topic | Observed evidence | Required interpretation |
| --- | --- | --- |
| Transactions | [CustomerBalanceRepositoryImpl.CreateMany](../repository/customer_balance_repository_impl.go) starts/finalizes a transaction but executes shown writes through the incoming db handle | A repository-owned transaction exists. Audit caller/handle behavior before changing it; do not assume the new tx owns those writes. No fix performed here. |
| File responses | [DiscountProposal controller](../controller/discount_proposal_controller_impl.go) uses c.Data for an Excel response | Preserve download content type/body; the JSON envelope rule applies to JSON endpoints. |
| History model | [History](../model/domain/history.go): TableID size 50, Data size 8000, Type size 10, embedded gorm.Model | Older illustrative text/size declarations were inaccurate. Workspace metadata at 2026-09-27 01:57:48 UTC recorded histories.data varchar(8000). |
| Proposal keys | [DiscountProposal](../model/domain/discount_proposal.go) tags ID, DivisionID and MarketingStructureID as primary keys | Workspace snapshot recorded discount_proposals PK as id only. Model tags and physical constraints must be compared; no migration is authorized by this finding. |
| Startup | [Database bootstrap](../app/database.go) has commented migration/script examples | Comments are not an executable migration workflow. Inspect current source before startup. |
| Tests | See [TESTING.md](TESTING.md) | Source presence and historical coverage badges do not establish current passing results or coverage. |
| Auth | Inspect exact route imports and wrapper, then the referenced implementation | Local auth documentation alone cannot establish gateway/dependency authorization or deployment exposure. |

## Boundaries

No application test, build, service startup, migration or database query was run for this documentation improvement. Schema facts above use the explicitly dated existing workspace snapshot. Existing source defects are recorded for investigation, not silently repaired by documentation work.
