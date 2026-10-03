# Payroll Agent Documentation Index

Use the [workspace answer contract](../../AGENTS.md#answer-contract-result-evidence-implications) and shared skills in `../../.agents/skills/`. They apply even when opening this repository directly.

## Choose a task

Start with [AGENTS.md](../AGENTS.md). Combine only skills needed for the affected concerns and deduplicate reading. Shared skills stay in the workspace; service-specific skills, when present, live under `.agent/skills/`.

| Task | Skill selection | First reference |
| --- | --- | --- |
| Existing behavior/feature feasibility | Workspace `visitflow-code-investigation`; design/performance discussion adds `visitflow-query-brainstorm` | Affected route → handler/service → persistence or external I/O → model/response/tests |
| Actual MySQL count/validation | Workspace `visitflow-database-qa` | Workspace authorization, metric definition and relevant schema |
| Go implementation | Workspace `visitflow-go-backend` | PREFERRED_PATTERNS, TESTING and affected code |
| PDF/path/period/NIP behavior | Workspace `visitflow-code-investigation` for analysis; backend skill for edits | DOMAIN, API, SECURITY_AND_IO |
| IMAP ingestion or OTP/email/Telegram | Backend skill for edits | SECURITY_AND_IO, WORKFLOWS, TESTING |
| A proposed DB-backed feature | Workspace `visitflow-gorm-mysql` only when persistence is actually involved | Inspect intended schema/transaction design; do not assume existing DB storage |
| Docker/CI/runtime | Inspect actual configuration | TESTING and deployment files; no live smoke tests |
| Documentation maintenance | Relevant topic; skill edits include retrieval/application scenarios | Check references, current commands and contradictions |

For a response-preserving repository fix in the DB services, start with Go/testing/GORM/API guidance. For payroll, select file/external-I/O guidance instead of assuming a repository. All code changes finish with [QUALITY_GATES](QUALITY_GATES.md).

## Document ownership

- [AGENTS](../AGENTS.md): mandatory local rules and work sequence.
- This index: task routing; not another checklist.
- [PREFERRED_PATTERNS](PREFERRED_PATTERNS.md): implementation decisions and example boundaries.
- [TESTING](TESTING.md): commands, facilities, side effects and evidence limits.
- [QUALITY_GATES](QUALITY_GATES.md): final verification.
- [WORKFLOWS](WORKFLOWS.md): task recipes.
- [CHANGELOG](CHANGELOG.md): history only, read when needed.

## Local source entry points

- Startup/wiring: `main.go`, `app/router.go`, `route/payroll_route.go`.
- Requests/output: `controller/payroll_controller_impl.go`, `model/web/`.
- PDF/search/count/ingest/OTP: `service/payroll_service_impl.go`; path/period construction: `helper/path_payroll.go`.
- Auth: `auth/auth.go`; distinguish wrapped routes from unwrapped ingest/OTP routes.
- Existing tests: `helper/operator_test.go`, `helper/model_test.go`; no service/controller test harness was identified.

## Topic library

- [API](API.md)
- [ARCHITECTURE](ARCHITECTURE.md)
- [DATABASE_SCHEMA](DATABASE_SCHEMA.md)
- [DOMAIN](DOMAIN.md)
- [SECURITY_AND_IO](SECURITY_AND_IO.md)

Descriptions reflect inspected local code, not deployed security or delivered external effects.

## Optional maintenance tools

- [FLOW_MAP](FLOW_MAP.md): locate a critical path only when needed.
- [Workspace validator](../../.agents/tools/README.md): check guidance after documentation/source moves or tooling changes. Do not run it for every routine question.

Read each selected document once per unchanged session. A link is a reference, not an instruction to recursively load the entire library. Apply all relevant safety rules while limiting code/schema inspection to the affected flow.
