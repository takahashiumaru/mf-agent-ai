---
name: docker-production
description: Use when inspecting Docker build configurations, multi-stage builds, deployment scripts, and container resource limits.
---

# Docker Production Skill

## Guidelines
1. **Container Build**: Configured in [Dockerfile](../../../Dockerfile) using `golang:1.23`.
2. **Build Flags**: `go build -race -ldflags "-extldflags '-static'" -o /app/main`.
3. **Deployment**: [deploy.sh](../../../deploy.sh) orchestrates container replacement with zero-downtime volume mounts.
4. **Resource Constraints**: Defined in [docker-compose.yml](../../../docker-compose.yml) (`cpus: 2.0`, `mem_limit: 3g`).

See [Dockerfile](../../../Dockerfile) and [docker-compose.yml](../../../docker-compose.yml).
