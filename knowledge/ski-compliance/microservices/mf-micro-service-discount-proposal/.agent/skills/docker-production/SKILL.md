---
name: docker-production
description: Build, configure, and verify production Docker containers and Compose environments for the Go microservice. Use whenever modifying Dockerfile, docker-compose.yml, or container deployment scripts.
---

# docker-production

Guides Docker containerization and build pipelines for `mf-micro-service-discount-proposal`.

## Core References
- [PROJECT.md](../../PROJECT.md) — Service overview, ports, and configuration.
- `Dockerfile` — Production container build specification.
- `docker-compose.yml` — Container runtime and volume mounts.
- `deploy.sh` — Deployment automation script.

## Standard Workflow
1. **Understand Container Architecture (`Dockerfile`)**:
   - Base image: `golang:1.23`.
   - Compiles static binary: `go build -race -ldflags "-extldflags '-static'" -o /app/main`.
   - Entrypoint: `CMD ["/app/main"]`.
2. **Review Volume & Network Layout (`docker-compose.yml`)**:
   - Volumes mapped for `/app/file` and `/app/file-web`.
   - Network: external `api-ski` bridge network.
   - Resource limits: `cpus: 2.0`, `mem_limit: 3g`.
3. **Build & Verify Container Locally**:
   ```bash
   docker build -t discount-proposal-test .
   ```

## Hard Guardrails
- **NEVER** embed sensitive credentials or `.env` files into Docker image layers.
- **ALWAYS** pass build arguments (`CI_SERVER_HOST`, `ACCESS_TOKEN`) securely via `ARG`.
- **DO NOT** remove `-static` linking flags if deploying to minimal environments.
