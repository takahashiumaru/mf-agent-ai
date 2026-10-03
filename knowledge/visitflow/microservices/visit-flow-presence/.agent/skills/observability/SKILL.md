---
name: observability
description: Use when changing request lifecycle, error handling, important business operations, external calls, database-heavy paths, logging, metrics, tracing, or background work.
---

# Observability

## Core Principle

Preserve enough structured context to diagnose failures and latency without duplicating events, leaking sensitive data, or adding high-volume noise.

## Required Workflow

`UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW`

Inspect the request middleware, error boundary, current logger, GORM instrumentation, external-call helper, and async lifecycle before changing signals.

## Repository Pattern Classification

- **PREFERRED:** centralized panic/error conversion in `app/router.go` and `exception/error_handler.go` prevents every layer from writing an HTTP error.
- **PREFERRED:** request-context propagation into external HTTP calls in `helper/send_message.go`.
- **ACCEPTABLE:** OpenTelemetry's GORM plugin is registered by database initialization; preserve trace context through request-bound DB operations.
- **MIGRATE-WHEN-TOUCHED:** `helper.RunAsyncNotification` bounds notification execution with a timeout and panic recovery, but callers must schedule it after successful commit when messages describe committed state.
- **DANGEROUS:** asynchronous writes to shared logger state/file in `helper/logger.go` have unclear synchronization and can race.
- **LEGACY:** raw goroutines in service methods can lose request trace/context and outlive their owning operation.

## Logging

- Reuse the established request/error boundary for ordinary events. Do not add new hot-path calls that copy `helper/logger.go`'s detached shared-file pattern until its synchronization/lifecycle risk is resolved in an authorized code task.
- If a task explicitly requires a new log before that repair, keep it at one operation boundary, document the logger risk, and do not create another goroutine/file handle.
- Include stable context when available: operation, request/trace ID, company/user/resource identifiers, outcome, dependency, and duration.
- Never log passwords, tokens, cookies, authorization headers, service-account data, DSNs, private keys, or full sensitive request bodies.
- Do not add per-row or per-loop logs to high-volume paths.
- Preserve the original error identity/message needed by error mapping while avoiding raw database internals in public responses.

## Metrics and Tracing

- The repository does not clearly establish application metrics. Add metrics only when the existing deployment can collect them and the signal has an owner/use.
- Avoid high-cardinality labels such as arbitrary user IDs, raw paths, SQL, or error strings.
- Preserve trace context across Gin, GORM, and outbound HTTP. Detached background work needs an explicit lifecycle/context decision.
- For DB-heavy paths, prefer aggregate latency/query-count signals over noisy row-level instrumentation.

## Async and Transaction Boundaries

- Do not emit a success notification/audit event before the transaction commits unless the event explicitly represents an attempt.
- Background work must define timeout/cancellation, panic/error handling, ownership, and shutdown behavior.
- Avoid capturing `*gin.Context` in goroutines; copy only immutable values that are safe after the handler returns.

## Completion Gate

Review signal usefulness, duplication, cardinality, secret/PII exposure, trace continuity, and async lifecycle. Observability changes must not alter business behavior or mask failures.

Read `.agent/ARCHITECTURE.md` and `.agent/ERROR_HANDLING.md` for current request/error flow.
