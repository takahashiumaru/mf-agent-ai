---
name: observability
description: Use when changing request lifecycle, error handling, important business operations, external calls, database-heavy paths, background work, logging, metrics, or tracing.
---

# Observability

## Outcome

Preserve trace continuity and add actionable, safe signals without duplicate or high-cardinality noise.

## Repository Context

Read `../../../AGENTS.md`, `../../ARCHITECTURE.md`, `../../ERROR_HANDLING.md`, and the relevant middleware/service. The repository uses OpenTelemetry Gin/GORM instrumentation and `goHelper.SignozSpan`; it does not establish a full structured-logging or metrics convention.

## Logging

- Prefer the repository's established logger when one exists; do not introduce a second logging stack for a local change.
- Log once at the layer that can act on or own the failure. Avoid repeating the same error in repository, service, controller, and recovery middleware.
- Include safe context when useful: operation, request/trace ID, resource ID, company/structure/period, outcome, and duration.
- Never log credentials, authorization headers, JWTs, API keys, service-account data, or full sensitive request/response payloads.
- Avoid noisy per-row and per-loop logs.
- If structured logging is unavailable, keep additions minimal and explicitly identify the limitation rather than inventing an ad hoc field format.

## Metrics

When an established metrics sink exists, consider request count/latency/errors, dependency latency/errors, database latency/query count, or queue depth for important operations. Do not create labels from user/resource IDs or other high-cardinality values.

Do not add a new metrics platform as incidental scope.

## Tracing

- Preserve the incoming `*gin.Context` through service, GORM, and external requests.
- Keep HTTP, DB, and external operations connected to the request trace.
- Name spans by stable operation, not raw URLs or unique resource identifiers.
- Record useful failure status without attaching secrets or large payloads.

## Background and External Work

Define context lifetime, timeout/cancellation, error ownership, retry policy, and correlation. Do not let detached goroutines silently discard errors or outlive required resources.

## Repository Examples

- ACCEPTABLE: `../../../service/company_service_impl.go` uses `goHelper.SignozSpan` and propagates request context into transactions.
- ACCEPTABLE: OpenTelemetry middleware in application bootstrap instruments HTTP/GORM flows.
- LEGACY — DO NOT COPY FOR NEW CODE: scattered `fmt.Println`/`log.Printf` calls and FCM error logs lack a consistent structured schema and may be detached from request traces.

## Completion Gate

- Context propagation remains intact.
- New signals answer a concrete operational question.
- Logging is non-duplicative and redacted.
- Cardinality and noise are bounded.
- Missing logger/metrics standards are called out instead of guessed.
