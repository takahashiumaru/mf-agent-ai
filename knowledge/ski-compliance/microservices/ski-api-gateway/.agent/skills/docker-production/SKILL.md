---
name: docker-production
description: Build, configure, and harden Docker container images for ski-api-gateway. Use when modifying Dockerfile or docker-compose configurations.
---

# Docker Production Skill

## Purpose & Trigger
Maintain clean, secure, multi-stage, and reproducible container images for `ski-api-gateway`.

## Workflow
1. **Understand**: Identify build dependencies and runtime requirements (Go 1.23, binary execution).
2. **Inspect**: Review `Dockerfile` and `docker-compose.yml`.
3. **Plan**: Structure efficient build caching, non-root execution, and minimal runtime layers.
4. **Implement**: Compile static Go binary (`CGO_ENABLED=0 go build`) and package with ca-certificates.
5. **Verify**: Test container startup and verify health endpoint responses.

## Hard Rules
- Do not store plaintext credentials inside container layers.
- Ensure proper UNIX signal propagation (SIGTERM/SIGINT) for graceful shutdown.
