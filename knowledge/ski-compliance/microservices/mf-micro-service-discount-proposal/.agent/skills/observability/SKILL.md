---
name: observability
description: Configure and monitor OpenTelemetry distributed tracing, GORM slow-query logging, error stack traces, and background job metrics. Use whenever configuring tracing, logging, or debugging production observability.
---

# observability

Guides observability and distributed tracing in `mf-micro-service-discount-proposal`.

## Core References
- [PROJECT.md](../../PROJECT.md) — OpenTelemetry setup and external collectors.
- [ARCHITECTURE.md](../../ARCHITECTURE.md) — Middleware stack and error reporting.
- [ERROR_HANDLING.md](../../ERROR_HANDLING.md) — Panic stack trace capture.

## Standard Workflow
1. **Trace Configuration (`app/router.go`)**:
   - Initialized via `initTracer()` configuring `sdktrace.TracerProvider` with OTLP gRPC exporter.
   - Attached to Gin engine via `router.Use(otelgin.Middleware("GO-MF-MICRO-DISCOUNT-PROPOSAL"))`.
2. **Panic Stack Trace Logging (`app/router.go:ErrorHandler`)**:
   - Stack traces are printed to stdout on panic: `fmt.Println("stacktrace from panic: \n" + string(debug.Stack()))`.
3. **GORM Slow Query Logging (`app/database.go`)**:
   - Configured with `SlowThreshold: time.Second`, `LogLevel: logger.Info`.
   - Logs queries taking longer than 1 second to stdout.
4. **Verify**:
   - Ensure collector gRPC endpoint in `configuration/.env` (`OTEL_EXPORTER_OTLP_ENDPOINT`) is reachable when tracing is enabled.

## Hard Guardrails
- **NEVER** log full request bodies containing credentials or sensitive customer tax data.
- **DO NOT** disable panic recovery middleware in `app/router.go`.
