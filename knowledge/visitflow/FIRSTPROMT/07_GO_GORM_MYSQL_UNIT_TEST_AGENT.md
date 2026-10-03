# 07 — Go, GORM, and MySQL Tests: At Least 90% Coverage

## Execution contract

Add meaningful tests until the agreed application scope reaches at least **90% statement coverage**. Preserve business flows and endpoint results. This prompt can run independently: inspect existing instructions and code first; generating prompts 01–05 is not a prerequisite.

Write documentation, new comments, and reports in English. Preserve public strings in their original language. Do not stage, commit, push, or access shared production/staging databases.

Default scope is tests, fixtures, and necessary test dependencies. Reuse installed tooling. Do not upgrade runtime dependencies, change CI, optimize queries, export private functions, or fix unrelated defects to reach coverage. A small behavior-preserving dependency seam is permissible when necessary and compatible with user scope; explain it and add regression protection. Report discovered defects separately unless fixing them is already authorized.

Continue through coverage gaps; an intermediate percentage is not completion. If an external prerequisite blocks progress, record it and finish independent work. Never fabricate a passing result.

## Compatibility gate

Trace route, middleware, handler, service, repository, and mapper. Characterize current behavior before a permitted production edit.

| Contract | Preserve and verify |
| --- | --- |
| Input | Binding, validation order, required/optional fields, defaults, parsing and timezone |
| Access | Authentication, authorization, ownership, tenant/company/structure/period scope |
| Business | State transitions, approvals, duplicate rules, audit records, notifications and order |
| Persistence | Row set, duplicates, nulls, ordering, soft delete, atomicity, read-after-write |
| Success | HTTP status, headers, JSON envelope, names/types/values, pagination and total |
| Failure | Trigger conditions, error identity/mapping, status, code, message and envelope |

Use structural JSON assertions that distinguish missing fields from null, zero from omitted, and empty arrays from null. Preserve numeric precision for identifiers and contractual array order. Normalize only explicitly nondeterministic fields, then assert their format and relationships separately. Never change expectations simply to accept new output.

Current behavior is evidence, not proof of correctness. Report suspicious business/security rules; do not silently rewrite them during coverage work.

## Discovery and baseline

1. Read applicable instructions, module files, test commands, CI and relevant documentation.
2. Record branch/HEAD and dirty files. Preserve all user changes.
3. Detect toolchain, GORM/driver versions, module roots, build tags, generated files and integration dependencies.
4. Inspect transaction helpers, resolver setup, error middleware and mappers before mocking behavior.
5. Run existing tests and measure baseline. Separate pre-existing failures from introduced failures.
6. Prioritize uncovered statements by business risk and package/function coverage.

Keep new black-box tests in root `test/` with `*_test.go`, importing actual application packages. Preserve existing test locations. Legitimate tests of package-private behavior may live beside source; explain this exception rather than exporting internals or using unsafe/reflection tricks.

## Honest coverage measurement

For one module, run from its root:

```bash
coverage_dir=$(mktemp -d)
go test ./... -count=1 -covermode=atomic -coverpkg=./... -coverprofile="$coverage_dir/baseline.out"
go tool cover -func="$coverage_dir/baseline.out"
```

Only use a profile as successful evidence after the test command exits successfully. Preserve baseline and final profiles separately. Temporary output avoids overwriting user artifacts.

`-coverpkg=./...` instruments selected module packages exercised by tests in `test/`. Inspect `go list ./...` and the profile to confirm expected production packages are represented, including packages without tests. Document toolchain/build constraints instead of silently omitting packages.

For multiple modules, run per module under the same rules and report each result. Never average percentages. A combined result must weight covered statements by total statements, distinguish module-qualified blocks, and avoid double-counting. Root `go test ./...` does not automatically cover nested modules.

Do not exclude packages/files, change build tags, filter profiles, or reclassify code as generated to improve the number. Document any pre-existing approved scope and excluded paths. Entrypoints are not automatically exempt. Label integration-only coverage separately from the default unit-suite result.

The displayed `total:` is rounded. Enforce the exact threshold from statement counts, so 89.96% does not pass as 90.0%. This check for a single successful Go profile rejects empty/malformed input and deduplicates repeated blocks:

```bash
awk '
NR == 1 {
    if ($0 !~ /^mode: (set|count|atomic)$/) bad = 1
    next
}
NF != 3 || $2 !~ /^[0-9]+$/ || $3 !~ /^[0-9]+$/ { bad = 1; next }
{
    key = $1
    if (key in statements && statements[key] != $2) bad = 1
    statements[key] = $2
    if ($3 > 0) covered[key] = 1
}
END {
    for (key in statements) {
        total += statements[key]
        if (covered[key]) hit += statements[key]
    }
    if (bad || total <= 0) {
        print "FAIL: malformed or empty coverage profile"
        exit 1
    }
    printf "Statements: %d/%d (%.4f%%)\n", hit, total, 100 * hit / total
    if (100 * hit < 90 * total) exit 1
}' "$coverage_dir/final.out"
```

Do not concatenate profiles from separate runs/modules. A deliberate merger must validate matching source revisions, instrumentation modes, scopes and block identities.

## Test design by boundary

### Helpers, validation and mapping

Use table-driven cases for valid/invalid inputs, boundaries, nil, zero, false, empty collections, malformed values, date transitions and precision. Assert output and error behavior. Constructor tests should verify relevant wiring/defaults, not merely non-nil values.

### Services

Execute the real service with focused dependency fakes/mocks. Cover success, validation failure, not-found, dependency failure, authorization, relevant state transitions and cancellation. Verify arguments and meaningful call order. Assert no forbidden writes/notifications after failures. Unexpected calls must fail; broad mocks with embedded nil interfaces are not reliable expectation checks.

### HTTP and middleware

Use `httptest` with actual handlers and relevant router/middleware composition. Cover malformed input, missing/invalid auth, forbidden ownership, success and mapped errors. Assert status, headers, payload and dependency arguments. A mocked service response alone does not verify business behavior or auth/recovery.

### GORM repositories

Use the installed MySQL dialect with `go-sqlmock` or the established alternative. Execute real repository methods. Verify significant SQL predicates and bound arguments, mappings, empty results, not-found behavior, DB errors, rows affected where relevant, soft deletes, updates, batching and conflict handling.

Register expectation verification and cleanup even when assertions terminate early. If asserting sqlmock connection closure, register its close expectation. Test begin/commit/rollback failures according to actual ownership. Do not disable GORM transactions or hooks to simplify tests.

Avoid fragile whitespace matching and overly permissive SQL regex/arguments that accept missing tenant predicates. `DryRun` only validates generated SQL. Use distinct read/write handles when routing matters: one mock connection cannot prove primary/replica consistency. Inspect external transaction helpers rather than assuming their lifecycle.

### MySQL integration

Mocks do not prove SQL validity, constraints, collation, stored procedures, timezone conversion, locks or plans. When these properties are in scope, use a disposable MySQL instance with relevant matching capabilities and isolated fixtures. SQLite is not a substitute for MySQL semantics.

Use the established integration tag/opt-in mechanism when needed and report which suite actually ran. Missing infrastructure is an unverified gate, not a passing result. Do not introduce substantial new infrastructure without task authority.

## History-informed regression cases

Apply these only when the target contains the pattern:

- Preserve not-found and middleware behavior around `Find`, `First` and error wrapping.
- Verify zero/false/null updates and omitted fields; `Save` and `Updates(struct)` are not interchangeable.
- Exercise join aggregates with filtered children, duplicate children and no children.
- For batching, test duplicates, missing keys, composite tenant keys, empty input, chunk boundaries and stable output order.
- Exercise date filters at midnight, month/year boundaries, fractional seconds and configured timezones.
- Test delimiter-containing composite public IDs; naive splitting may change scope.
- Test malformed auth claims without adding fallback secrets or weakening auth.
- Account for every opened transaction and dependent read connection.

## Determinism and assertion quality

Include applicable security regression cases: unauthenticated and forbidden requests, cross-tenant read/write/export access, forged ownership fields, invalid/expired tokens, rejected SQL identifier/sort inputs, over-posted privileged fields, empty filters and oversized inputs. Test legitimate allowed requests alongside denials to detect feature regressions. Assert no write or external side effect after access denial. Use synthetic credentials and payloads; never run attack tests against shared environments. A 90% coverage result is not a security certification.

Control clocks, randomness, environment, HTTP clients and external I/O through existing seams. Use `t.Cleanup` and isolated fixtures. Avoid parallel tests that mutate environment, working directory, globals or shared resources. Use channels/deadlines rather than arbitrary sleeps. Race detection does not prove absence of leaks or deadlocks.

Do not swallow errors/panics, skip valid failures, weaken assertions, or retry until green. Assert expected legacy panics precisely. Covered statements do not prove every branch is tested; inspect both outcomes of critical conditions.

## Execution loop and final gates

Maintain a package/behavior backlog and continue until the target is met. Run focused tests while editing and full coverage at meaningful checkpoints. Avoid redundant full-suite runs after sufficient successful evidence.

Format only changed Go files, then run the repository-supported equivalent:

```bash
go test ./... -count=1 -covermode=atomic -coverpkg=./... -coverprofile="$coverage_dir/final.out"
go tool cover -func="$coverage_dir/final.out"
go vet ./...
go test -race ./... -count=1
git diff --check
git status --short
```

Apply the exact threshold check above. Run configured lint with a compatible version. An existing CI threshold below 90% does not satisfy this task; report the mismatch without editing CI unless authorized. Use targeted shuffled/repeated runs where state leakage risk justifies them.

If race/tooling gates cannot run, report them as unverified and completion as qualified/incomplete. Preserve pre-existing dirty files; clean up only artifacts created by this task.

## Completion report

Report baseline/final covered and total statements, percentages, scope/modules/toolchain/build tags, important behavior protected, production edits and reasons (or none), commands and actual results, integration/performance gaps, blockers, and confirmation that no commit was made.

Completion requires at least 90% exact statement coverage, passing required gates, meaningful critical-behavior protection and no unauthorized business/API changes. Coverage and green unit tests alone do not certify every endpoint or production performance.

## Copy-and-run prompt

> Read `07_GO_GORM_MYSQL_UNIT_TEST_AGENT.md` fully and execute it for this repository. Reach at least 90% exact statement coverage across the agreed application scope with meaningful tests primarily in `test/`. Preserve business flows and endpoint results. Continue until completion gates pass or a demonstrated external blocker prevents further progress. Keep all work uncommitted and report evidence in English.
