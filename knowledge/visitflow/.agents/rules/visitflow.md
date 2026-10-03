---
trigger: always_on
description: Load shared VisitFlow workspace routing, Q&A, and sensitive-data guidance.
---

# VisitFlow workspace context

The canonical project guide is `../../AGENTS.md` (relative to this rule file). Read and follow it for VisitFlow questions. Shared task skills live in `../../.agents/skills/` and should be selected by the question's topic.

This root is an umbrella workspace. Route visits/customers to `visit-flow-go`, attendance/leave to `visit-flow-presence`, surveys to `visit-flow-survey-location-go`, identity and proxy routes to `visit-flow-api-gateway`, and payroll to `visit-flow-payroll`. Use source code for current behavior and a dedicated read-only account for live database questions. Keep `.env`, tokens, SQL dumps, and payroll/customer data out of answers.

@../../AGENTS.md

Apply its answer contract: actual data results first when the chosen read-only connection is available; SQL-only requests stay unexecuted. Verify feature availability in code and relevant schema, and assess feature feasibility, integrity, and performance with stated evidence and uncertainty. A missing connection is a specific blocker, never a reason to fabricate a total.

For `SELECT`, plain `EXPLAIN SELECT`, and schema reads, directly use the default production login profile in root `AGENTS.md` without requesting connection approval again. Its explicit user-selected account exception takes precedence over the generic dedicated-account prerequisite; enforce the documented read-only transaction and scope.

Database mutations (`UPDATE`, `DELETE`, `DROP`, and other writes) must follow root `AGENTS.md`: use `VISITFLOW_MF_DEV`, explicitly tell the user this is DEV only, present the concrete change and impact, ask whether they are sure, and wait for confirmation before execution. Preparation reads must target DEV too. Never promote a DEV mutation to production automatically.
