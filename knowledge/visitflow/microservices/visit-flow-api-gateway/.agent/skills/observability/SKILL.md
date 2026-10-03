---
name: observability
description: "Preserve or improve logging, tracing, metrics, slow-query visibility, and diagnostic context when changing request flows, errors, business operations, external calls, database-heavy work, or background tasks."
---

# Observability

Follow `UNDERSTAND -> INSPECT -> PLAN -> IMPLEMENT -> TEST -> REVIEW`.

## Current Stack

- KrakenD uses its logger in `main.go`.
- GORM logs at Info level with a one-second slow threshold in `config/db.go`.
- Role-related services call `goHelper.SignozSpan` using the Gin request context.
- Standard `log` and some `fmt.Println` diagnostics coexist.
- `service/file_service_impl.go` parses `slow_endpoints.md`; the producer is not present in current code.
- No application metrics registry/exporter or request-ID convention is clearly established.

Do not invent a second observability stack for a focused change.

PREFERRED within the current stack — request-context trace annotation through `goHelper.SignozSpan`, GORM's explicit slow threshold in `config/db.go`, and truncated Firebase-token previews rather than full-token logs.

## Context and Tracing

- Preserve `c.Request.Context()` through services, DB calls, and external requests.
- Keep HTTP, DB, and external work on the same trace when tracing exists.
- Do not replace request context with background context inside request flows.
- Add spans/events only for meaningful operations; avoid per-row span noise and sensitive attributes.

MIGRATE-WHEN-TOUCHED — plain user/session GORM flows without `WithContext` and service interfaces coupled to Gin rather than `context.Context`.

## Logging

- Log at the boundary that can respond or operate on the failure.
- Include safe operation/resource IDs, route, dependency, and duration when useful.
- Avoid duplicate repository/service/controller/middleware logs for one error.
- Never log passwords, JWTs, refresh tokens, DSNs, private keys, SMTP secrets, or full device tokens.
- Do not log full request/response bodies by default.
- Do not add `fmt.Println` production diagnostics; use the established logger available in the flow.

LEGACY — mixed logging styles and panic recovery printing full stack traces to stdout.

## Metrics

Add metrics only when the repository already has an appropriate exporter or the task explicitly includes observability infrastructure. Useful measures include request/error count, latency, dependency/DB latency, transaction failure, and background-task failure.

- Keep labels bounded; never use raw user IDs, paths with arbitrary IDs, tokens, or error messages as labels.
- Measure at stable boundaries rather than each row/item.
- Define what operational decision a metric supports.

## Slow Queries and External Calls

- Use GORM slow-query output as a signal, then inspect generated SQL, query count, indexes, cardinality, and execution plan.
- Do not add noisy per-query/per-row custom logs.
- Record dependency duration/result without sensitive payloads.
- Detached notification errors currently log asynchronously; any replacement must retain failure visibility and define lifecycle/retry semantics.

## Review Gate

- Request context and trace continuity preserved.
- Failures remain diagnosable without duplicate/noisy logs.
- No sensitive or high-cardinality data emitted.
- Performance claims backed by measurement, not log appearance.
- New background work has observable success/failure and ownership.

Read `../../ARCHITECTURE.md`, `../../CODE_STYLE.md`, and `../../ERROR_HANDLING.md` for current behavior.
