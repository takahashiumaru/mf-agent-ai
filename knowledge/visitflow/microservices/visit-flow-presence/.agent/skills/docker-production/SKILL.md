---
name: docker-production
description: Use when modifying Dockerfile, Docker Compose, image builds, container runtime settings, health checks, shutdown, or container deployment behavior.
---

# Docker Production

## Core Principle

Produce a reproducible, minimal, non-secret-bearing runtime image without changing runtime assumptions blindly.

## Required Workflow

`UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW`

Inspect `Dockerfile`, `docker-compose.yml`, `.dockerignore`, `main.go`, CI/deploy scripts, private-module authentication, mounted paths, and production runtime constraints.

## Repository Pattern Classification

- **ACCEPTABLE:** copying `go.mod`/`go.sum` before source can support dependency cache reuse.
- **LEGACY:** the current `Dockerfile` uses one `golang:1.23` stage, retains compiler/source/tooling, and runs as root.
- **LEGACY:** formatting/static checks occur while building the image; quality gates belong in reproducible CI before image publication.
- **DANGEROUS:** broad `COPY . .` combined with incomplete `.dockerignore` can include `configuration/.env`, `helper/service-account.json`, repository metadata, tests, and local artifacts.
- **DANGEROUS:** secret/token handling in image or deploy commands must not persist in layers or logs.
- **NOT CLEARLY ESTABLISHED:** health endpoint, graceful shutdown, production need for a race-enabled binary, and minimal runtime OS/certificate/timezone requirements.

## Build Rules

- Prefer a multi-stage build: pinned Go builder, deterministic dependency download, compiled binary, then a compatible minimal runtime.
- Copy only runtime artifacts. Confirm CA certificates, timezone data, templates/static files, and writable `file/` paths before selecting a base image.
- Keep dependency layers cacheable around `go.mod`, `go.sum`, and module download.
- Do not mutate source with `go fmt` inside the image build; CI should reject formatting differences.
- Avoid floating critical base/tool versions without a deliberate update policy.

## Runtime Rules

- Prefer a non-root user and explicitly owned writable directories/mounts.
- Preserve signal delivery and add graceful HTTP/DB shutdown before claiming graceful container termination.
- Add a health check only when a meaningful readiness/liveness endpoint exists; do not invent a superficial check.
- Keep configuration outside the image and never bake credentials, tokens, private keys, or service accounts into layers.

## Verification

- Confirm build context contents and secret exclusions.
- Build the image using the repository's real private-module auth mechanism without printing credentials.
- Run/smoke test required routes, mounts, timezone, CA trust, and shutdown.
- Scan image history/content where tooling exists and compare runtime size/user/artifacts.

The supported private-module credential mechanism is not established; investigate CI capabilities rather than embedding a guessed token flow.

Do not arbitrarily replace deployment topology or base images during an unrelated feature. Coordinate broad container hardening as focused work.
