---
name: docker-production
description: "Modify or review the Dockerfile, Docker Compose, container runtime, image build, deployment settings, health checks, shutdown behavior, or container secret handling."
---

# Docker Production

Use `ci-quality-gate` when build/deployment pipelines also change and `backend-security` for credentials/secrets.

Follow `UNDERSTAND -> INSPECT -> PLAN -> IMPLEMENT -> TEST -> REVIEW`.

## Inspect Compatibility First

Review `Dockerfile`, `docker-compose.yml`, `deploy.sh`, `.gitlab-ci.yml`, runtime ports, mounted files, private module access, CGO/race needs, configuration paths, and upstream network DNS before changing images or entrypoints.

Do not arbitrarily change base images or static/CGO settings without building and exercising the actual binary.

## Current Repository Risks

- Single-stage `golang:1.23` image includes the compiler/toolchain at runtime.
- `COPY . .` occurs before dependency download/build; cache reuse is poor.
- No `.dockerignore`; build context can include binaries, coverage, local configuration, VCS data, and credential files.
- `ACCESS_TOKEN` is used in a `RUN git config` command and can persist in image history/layers.
- Container runs as root.
- Build uses `-race`, which increases runtime dependencies/overhead and is unusual for production.
- No `HEALTHCHECK` is defined.
- `main.go` lacks graceful signal-driven shutdown for its two HTTP servers.
- Compose maps the local identity and gateway ports, mounts `/app/file`, uses an external network, and configures bounded JSON logs.

These are evidence-backed risks, not permission for a blind Docker rewrite.

## Preferred Image Shape

When compatibility is proven:

- Use separate build and minimal runtime stages.
- Copy `go.mod`/`go.sum`, download modules with an appropriate private-module secret mechanism, then copy source to improve caching.
- Copy only the binary and required runtime configuration/assets.
- Run as a non-root user with writable access only to required mounted paths.
- Pin critical base versions/digests according to the team's update policy.
- Add a `.dockerignore` excluding `.git`, local env/credentials, binaries, coverage, editor files, and other unnecessary content.

Never bake DB credentials, API/JWT tokens, private keys, or service-account files into an image. Use BuildKit secrets/CI credential mechanisms when available; do not pass durable secrets through `ARG` plus `RUN`.

## Runtime Reliability

- Preserve both listener ports and required file/config paths.
- Add health/readiness checks only against a stable endpoint whose semantics match orchestration needs.
- Implement graceful shutdown in application code before relying on container stop signals; do not modify production code unless explicitly scoped.
- Set resource limits/restart behavior at the deployment layer with operational input.
- Keep logs on stdout/stderr; preserve rotation settings.

## Validation Gate

- Image builds from a clean context.
- Binary starts and both listeners/config paths work.
- Private dependencies resolve without secrets remaining in layers/context.
- Runtime user can access only required files/mounts.
- Image contents/size and base compatibility reviewed.
- Compose/deployment config validates and health/shutdown behavior is honest.

No current Docker implementation is PREFERRED as a whole. The Compose log rotation and explicit port/volume/network configuration are ACCEPTABLE compatibility anchors.
