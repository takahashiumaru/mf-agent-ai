---
name: docker-production
description: Build, maintain, and verify Docker images and container runtime environments for production and development. Use whenever modifying Dockerfile or docker-compose.yml.
---

# Docker Production Skill

## Purpose
Ensure secure, efficient, and reproducible container images for `mf-micro-service-structure`.

## When to Use
Use when updating Go base image versions, adjusting build flags, or updating container orchestration files.

## Workflow
1. **Understand**: Check target Go version (`1.23`) and dependencies in `go.mod`.
2. **Inspect**: Check `Dockerfile` and `docker-compose.yml`.
3. **Plan**: Maintain static compilation flags (`-ldflags "-extldflags '-static'"`).
4. **Implement**:
   - Ensure build arguments (`ACCESS_TOKEN`, `CI_SERVER_HOST`) are handled properly for private GitLab modules.
5. **Verify**:
   - Run `docker build -t mf-micro-service-structure:test .` locally where Docker is available.

## Hard Rules
- Never bake hardcoded private tokens or credentials into final container layers.

## References
- `Dockerfile`
- `docker-compose.yml`
