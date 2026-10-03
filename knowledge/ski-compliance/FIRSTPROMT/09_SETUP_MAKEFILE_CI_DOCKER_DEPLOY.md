# 09 — Set Up Makefile, Coverage Gates, CI, Docker and Deployment

## Objective and authorization

Implement a consistent, reproducible local-to-CI quality workflow and container build for the target Go repository. Adapt its existing deployment configuration so releases are gated by verified checks. Preserve application behavior, endpoint results and operational contracts.

Write documentation and reports in English. This prompt authorizes local build/CI/container configuration edits and their safe verification. It does not authorize executing a deployment, pushing images, modifying CI secrets/settings, committing, resetting checkouts, or changing shared infrastructure/databases. Prepare a reviewable result and report any external prerequisites.

This file works independently. If the prompt pack exists, apply its README; consult prompt 07 for coverage and prompt 08 for security. Read applicable repository instructions and relevant `docker-production`, `ci-quality-gate`, `backend-security` and `go-testing` skills when available.

## Lessons from the reference projects

The source projects use Makefile aliases, Go checks, whole-module coverage profiles, GitLab tag-triggered quality jobs, Docker builds and SSH/Compose deployment. These are patterns to evaluate, not configurations to copy literally.

The inspected gateway/presence files also contained a 70% threshold, disagreement between local `check-all` and CI tool choices, formatting during image builds, credentials passed as Docker build arguments, a printed job token, checkout resets and global image pruning. Do not propagate these weaknesses. Resolve the target repository's actual requirements instead of assuming the reference implementation is a best-practice template.

## Phase 1 — Discover the target

Inspect current files and focused history before editing:

- `go.mod`, `go.work`, module roots, entrypoints, private dependencies and toolchain requirements;
- Makefile, scripts, tests, coverage profiles/configuration and existing quality tools;
- CI configuration, includes, runner capabilities, job rules, environment protection and artifact flow;
- Dockerfile, `.dockerignore`, Compose manifests and deployment scripts;
- runtime config loading, required assets/templates, certificate/timezone data, filesystem paths, mounted volumes, permissions, ports, health checks and shutdown behavior.

Record branch/HEAD and dirty files. Preserve unrelated work. Never read or print secret values to document their existence. Identify the real CI provider; adapt GitLab patterns to an existing provider rather than adding a competing pipeline.

Build a short implementation matrix: current command/configuration, intended change, compatibility impact and verification. Detect whether builds use a package directory or an explicit file; do not accidentally omit sibling Go files. Preserve intended build tags, CGO settings, architecture and linker metadata.

## Phase 2 — Make one command contract

Preserve useful existing aliases and add missing canonical targets. Declare command targets `.PHONY`. Use portable recipes compatible with the chosen shell and fail on any required command failure.

| Target | Expected behavior |
| --- | --- |
| `help` | Explain commands and prerequisites |
| `run` | Run the existing local entrypoint, preserving configuration conventions |
| `build` | Build the correct package into a known local artifact directory |
| `test` | Run the default suite with clear failure output |
| `cover` | Produce a fresh whole-scope profile and human-readable summary |
| `check-cov` | Execute covered tests and enforce exact statement coverage |
| `fmt` | Explicit developer formatting command |
| `fmt-check` | Fail for unformatted maintained Go files without rewriting them |
| `vet` | Run `go vet` on the intended modules/packages |
| `lint` / `critic` | Run configured, compatible tools when adopted by this repository |
| `race` | Run race-enabled tests on a supported platform |
| `mod-verify` | Verify module content without silently rewriting module files |
| `check-all` | Aggregate the actual required gates and report success only after all pass |
| `clean` | Remove only known generated artifacts from validated local paths |

Keep `tidy` separate from non-mutating quality checks. If module-file freshness is checked, detect changes explicitly; never let CI silently repair them. Document optional tools separately from mandatory gates. Do not advertise a lint gate that `check-all` never runs.

Prevent duplicate test/profile runs and concurrent writes to the same profile under `make -j`. Prefer one coverage-producing run used by its summary and threshold checker. Do not hide failures with `|| true`, success echoes, pipelines or permissive missing-tool fallbacks.

Use repository-pinned tool versions compatible with its Go version. Do not copy an old Staticcheck/GoCritic version solely because it appears in a reference project. Record tool installation instructions; avoid installing tools on every `make` invocation.

## Phase 3 — Implement a trustworthy coverage gate

Default threshold is **90%**, or the existing stricter requirement. Declare it once as the canonical policy and use the same scope/threshold locally and in CI. Do not permit a lower threshold through deployment job overrides or missing environment variables.

Use a fresh successful `go test` run with `-count=1 -covermode=atomic -coverpkg=./... -coverprofile=...` for a single module. Resolve multi-module scope explicitly. Report covered and total statements; do not average package percentages.

Enforce the exact ratio rather than the rounded `go tool cover -func` display. Implement a maintained script/helper, reusing prompt 07's profile-counting approach if present. Reject missing/empty/malformed profiles, inconsistent duplicate blocks, invalid thresholds and zero-statement input. A failed test run must fail the gate even if a profile was emitted. Never reuse an old successful profile after a failed run.

Verify the checker using synthetic fixtures: exact 90% passes, below 90% fails, 89.96% fails despite display rounding, malformed/missing/empty files fail, and duplicate blocks are handled consistently without inflating totals. Verify command failure propagation as well as arithmetic.

Do not lower the gate to make CI green. If existing coverage is below the target, report the measured gap and leave the gate failing honestly. This configuration task does not automatically authorize a repository-wide test expansion; use prompt 07 when that work is requested.

## Phase 4 — Align CI with local checks

Have the quality job call the same Makefile contract rather than maintaining a divergent command list. Install its required tools explicitly and ensure the image contains Make, Git, certificates and any verified native build prerequisites.

Preserve existing branch/tag/environment behavior. Add quality checks for relevant merge requests/branches where supported, without creating unintended deployments or duplicate pipelines. Explain any rule changes. Use the configured server/provider version's syntax.

Every deployment candidate must have a mandatory successful quality gate for the same revision. Check `rules`/`only`, stage ordering, `needs`, manual jobs and `allow_failure`: deployment must not bypass checks because the quality job was excluded or marked optional. Preserve protected environment and approval requirements.

Publish coverage summaries and appropriately bounded artifacts; do not include secrets or private fixtures. Diagnostic artifacts may be retained after failure, but a failed run is never a passing coverage result. Cache dependencies/build outputs using keys compatible with toolchain/module inputs. Do not cache credentials or use a cache as the authoritative release artifact.

Separate race verification from the production binary. Make it a mandatory supported CI gate or report the missing runner capability explicitly. If additional security/lint tooling is required by existing policy, preserve it and pin compatible versions.

## Phase 5 — Build a secure, compatible image

Use multi-stage builds where compatible, separating build tools/source from runtime artifacts. Preserve the application's runtime contract before choosing the smallest image.

- Copy module manifests before source where appropriate to improve cache reuse; use approved private-module access.
- Use BuildKit secret or SSH mounts for private credentials. Never pass tokens via `ARG`/`ENV`, bake authenticated Git config into layers, or print tokens. Secret mounts do not protect secrets that commands copy into persistent files.
- Set non-secret build configuration in the scope where it is needed. A shell-local export in one `RUN` is not configuration for future layers.
- Build the intended package with verified flags. Do not claim static linking from linker flags alone or force `CGO_ENABLED=0` without checking dependencies.
- Run formatting verification, not automatic source rewriting, in CI. Quality checks belong in an explicit job/target; avoid inconsistent duplicates inside the image build.
- Keep race instrumentation in test/diagnostic builds by default. If a target intentionally ships it, document the requirement before changing that policy.
- Preserve required assets, working directory, timezone behavior, certificates, configuration mounts, dynamic libraries, writable paths and signal handling.
- Use a non-root runtime user when permissions and volume ownership are validated. Do not blindly switch to scratch/distroless if the application needs shell commands or native libraries.
- Exclude secrets, `.env` files, private keys, `.git`, debug binaries and irrelevant artifacts from build context. Preserve non-secret templates and runtime assets; do not break them with broad ignore patterns.
- Pin appropriate base-image versions/digests according to the repository's maintenance policy; document how security updates are adopted.

Inspect image metadata and runtime contents without exposing credentials. Verify a disposable local startup with synthetic configuration when possible. Do not connect the test container to production services.

## Phase 6 — Prepare deployment safely

Prefer building once and promoting the tested immutable image/digest when the target already supports that flow. Introducing a registry-based architecture where none exists needs a concrete proposal; do not invent registry hosts or credentials.

For existing SSH/Compose deployment:

- Preserve service names, ports, volumes, networks, environment selection and tag conventions.
- Validate required variables and quote shell expansions. Do not interpolate arbitrary values into remote shell source or log credential-bearing commands.
- Match the script interpreter and invocation. A Bash script must not be launched as `sh` while using Bash-only syntax. Probe `docker compose version` for the plugin or the actual legacy executable rather than treating two words as one executable.
- Use trusted host-key verification. A newly observed `ssh-keyscan` result alone does not authenticate the server; provision verified known-host entries through existing mechanisms.
- Transfer secrets via the established protected channel/file mechanism with restricted permissions. Do not put them in build arguments or artifacts.
- Do not use `git reset --hard` or overwrite a shared checkout. Prefer an isolated release directory or verified immutable artifact within the existing deployment architecture.
- Do not run global `docker image prune -af` on shared hosts. Retain the current and previous release for recovery and scope any cleanup explicitly.
- Serialize deployments per environment, verify health/readiness after replacement, and define recovery to the previous image/configuration. Do not claim zero downtime without an architecture and test that establish it.
- Preserve database migration behavior. Do not add automatic migrations or assume an image rollback reverses schema changes.

Prepare scripts and the rollout/recovery instructions locally. Executing SSH, Compose updates, registry pushes or deployments requires separate user authorization.

## Phase 7 — Verify and report

Use checks proportional to actual edits:

1. Review Makefile targets and execute safe quality/build targets. Remember `make -n` is not proof of runtime correctness and can evaluate Make expressions; inspect recipes before invoking it.
2. Test the coverage checker and negative failure paths.
3. Parse CI YAML and validate pipeline semantics with provider tooling when available. Use synthetic variables to check relevant tag/branch rule outcomes; syntax parsing alone cannot prove deployment gating.
4. Check shell syntax using the declared interpreter and run configured ShellCheck when available. Do not execute a real deployment as a test.
5. Validate Compose with synthetic configuration and avoid printing expanded secrets. Build the image and perform isolated smoke checks if local tooling/private dependencies are available.
6. Confirm commands do not mutate source unexpectedly and review the final diff for runtime/API changes, secret exposure and unrelated edits.

Report files changed, the local/CI command mapping, coverage threshold and actual result, tool versions, image/runtime compatibility checks, deployment trigger/gate behavior, prerequisites, commands that passed/failed/could not run and rollback limitations. Distinguish configured behavior from execution evidence. No Docker daemon, credential or runner means the corresponding check is unverified, not passed.

Update relevant build/deployment documentation and `.agent/` routing if present. Update the engineering changelog only when guidance changes. Do not commit or deploy.

## Official references

- [Docker build secrets](https://docs.docker.com/build/building/secrets/): credential delivery during builds.
- [Docker multi-stage builds](https://docs.docker.com/build/building/multi-stage/): separation of builder and runtime artifacts.
- [GitLab CI YAML reference](https://docs.gitlab.com/ci/yaml/): validate rules, dependencies and gates against the installed version.

## Copy-and-run prompt

> Execute `FIRSTPROMT/09_SETUP_MAKEFILE_CI_DOCKER_DEPLOY.md` in this repository. Implement compatible Makefile targets, a consistent local/CI quality gate, exact coverage enforcement of at least 90%, and secure Docker/deployment configuration. Preserve business behavior, endpoint results and runtime contracts. Verify locally where possible and report missing external prerequisites honestly. Do not commit, push images or execute deployment.
