# Evidence-based brainstorming and decision analysis

## Start from the decision

Restate the business outcome, user/actor, current pain, constraints, and measurable success. Use existing conversation decisions instead of restarting an interview. Ask only for information that would materially change the recommendation; continue independent investigation meanwhile.

## Investigate before proposing

1. Locate the owning repo and at least one concrete request/process flow.
2. Trace actual route imports → controller binding → service rules/transaction → repository query → model/schema → mapping and side effects.
3. For data-dependent claims, retrieve a bounded authorized aggregate. For code-only claims, cite source and distinguish local checkout from deployed/pinned dependency behavior.
4. State observed facts, plausible hypotheses with confidence, and unknowns separately. Rank hypotheses by evidence, impact, and ease of distinguishing them.
5. Check alternate explanations: join fanout, stale ETL, period mismatch, cancelled records, missing mappings, partial retries, and differing report grain before blaming an index or service.

## Compare meaningful options

Usually offer 2–3 distinct approaches when there is a real design choice; do not invent alternatives for a one-line answer. Compare:

| Criterion | What to evaluate |
|---|---|
| Business correctness | Meaning of totals, ownership, scope, historical mappings, closing rules |
| Compatibility | API fields/statuses, existing consumers, filters and ordering |
| Consistency | Transaction boundary, external effects, sync lag, retry/idempotency |
| Cost | Read/write amplification, storage, connection usage, operational maintenance |
| Performance | Measured latency/plan/data distribution; otherwise explicitly a hypothesis |
| Delivery | Affected repos, pinned dependency changes, rollout and observable success |
| Recovery | Rollback feasibility, replay/reconciliation, failure detection |

Recommend one option with reasons and the condition that would make another option preferable. Identify the smallest safe measurement or isolated experiment that resolves the key uncertainty. Do not claim an invented percentage speedup or prescribe a pool size without workload evidence.

## Example: inconsistent sales totals

Investigate the sales source, warehouse processing, period mapping, and exact aggregation grain. Compare base transaction totals versus warehouse totals for the same permitted scope before proposing a rewrite. Possible approaches: fix query grain/filter semantics; correct processing/reconciliation behavior; or introduce a derived reporting table with defined freshness and replay rules. Choose only after evidence shows which cause applies. No sample totals are invented here.

## Example: sync reliability

Inspect the concrete source/destination repositories, SourceAction handling, period formatting, external helper version, and both transaction handles. Separate a visible local finalization defect from the broader design question of retry/reconciliation. A second DB handle alone does not prove both databases are written. Propose an isolated failure experiment before changing commit order or moving network calls.

## Output shape

Lead with the finding or recommendation. Then show evidence, ranked causes/options, tradeoffs, and the next action. Brainstorming should help the user choose, not produce only SQL or a list of generic best practices.

## Required feature verdict

For existence questions, open with **implemented**, **partially implemented**, **not found within the inspected scope**, or **unverified**, followed by concrete source locations. Inspect registration and the complete behavior, not just a named struct. Include supporting schema columns/keys and distinguish local source from deployment evidence.

For proposals, open with feasibility and conditions. Explain the likely performance mechanism and correctness risks using the actual queries, indexes, transaction boundaries and consumers. Offer a practical alternative if the proposed design is blocked. Identify the measurement needed to resolve uncertain latency/load; do not guarantee performance without evidence. See [workspace workflow](../AGENTS.md#required-answer-workflow).
