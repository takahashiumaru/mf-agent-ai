---
name: observability
description: Use when managing OpenTelemetry tracing, gRPC trace exporters, OTLP configuration, and slow query logging.
---

# Observability Skill

## Guidelines
1. **OpenTelemetry Bootstrap**: Tracer is initialized via `initTracer()` in [app/router.go](../../../app/router.go) using `otelgin.Middleware("GO-MF-MICRO-SALES")`.
2. **GORM Logging**: Database logger logs queries exceeding 1 second (`SlowThreshold: 1 * time.Second`).
3. **Panic Traces**: Unhandled panics print debug stack traces to stdout before returning HTTP 500.

See [app/router.go](../../../app/router.go) and [app/database.go](../../../app/database.go).
