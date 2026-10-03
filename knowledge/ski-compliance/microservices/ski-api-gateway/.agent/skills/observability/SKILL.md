---
name: observability
description: Manage logging, tracing, metrics, and error diagnostics across ski-api-gateway. Use when configuring telemetry or logging.
---

# Observability Skill

## Purpose & Trigger
Provide structured visibility into request routing, gateway latency, error rates, and security events without leaking sensitive data.

## Workflow
1. **Understand**: Identify telemetry requirements (request rate, error counts, proxy durations).
2. **Inspect**: Check current logging points in `cmd/main.go`, `helper/debug_http_request.go`, and `pkg/app/router.go`.
3. **Plan**: Add structured logs and OpenTelemetry exporter configuration (`OTEL_EXPORTER_OTLP_ENDPOINT` in `dev.env`).
4. **Implement**: Format logs with timestamps, status codes, request paths, and execution latencies.
5. **Verify**: Ensure logs omit credentials and JWT tokens.

## Hard Rules
- Redact `Authorization`, `X-API-Key`, and password fields from all application logs.
