---
name: observability
description: Maintain and configure OpenTelemetry distributed tracing and structured logging. Use whenever modifying telemetry middleware, trace exporters, or logging configuration.
---

# Observability Skill

## Purpose
Ensure transparent distributed tracing, error tracking, and structured observability across the service.

## When to Use
Use when configuring OpenTelemetry exporters, adding custom span attributes, or updating log levels.

## Workflow
1. **Understand**: Check current OTLP gRPC telemetry setup in `app/router.go`.
2. **Inspect**: Verify `otelgin` middleware and `service.name` attribute configuration (`GO-MF-MICRO-STRUCTURE`).
3. **Plan**: Add trace attributes or metrics without introducing high cardinality.
4. **Implement**:
   - Ensure OTLP endpoint is configured via `OTEL_EXPORTER_OTLP_ENDPOINT`.
   - Maintain clean panic trace logging in `app.ErrorHandler()`.
5. **Verify**:
   - Verify service initializes cleanly and connects to OTLP collector.

## Hard Rules
- Never attach passwords, JWT secrets, or sensitive PII to trace attributes.

## References
- [.agent/ARCHITECTURE.md](../../ARCHITECTURE.md)
- [.agent/PROJECT.md](../../PROJECT.md)
