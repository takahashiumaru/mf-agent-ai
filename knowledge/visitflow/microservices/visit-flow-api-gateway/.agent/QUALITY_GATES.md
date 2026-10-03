# Quality Gates

This file owns completion checks. Apply them to the affected behavior; docs-only edits use the documentation gate.

## Code and contract

- Trace actual route/job → handler/service → persistence/external I/O → response and callers/tests.
- Preserve JSON/PDF/status/error contracts unless intentionally changed; verify null, zero, empty, ordering and validation cases.
- Keep scope and layer ownership clear; update all affected interfaces/mocks.
- Handle errors/context cancellation. Preserve legacy panic boundaries while returning expected errors from new internals where compatible.

## Data and external effects

- Preserve company/owner/period/status scope and verified business keys; role declarations alone are not proof of access control.
- For DB work, use the caller's transaction; dependent reads use the writer; test failure/rollback and zero values. Review query cardinality, bounds, indexes and N+1.
- For file/IMAP/OTP/email work, verify path containment, expiry/retry/concurrency and partial-failure behavior as relevant. SQL rollback cannot undo these effects.
- Success notifications must represent committed success. Bound background work and avoid retaining request Gin context.
- No secrets, real payroll/customer rows, generated test artifacts or unrelated source edits in the diff.

## Verification

- Add meaningful regression tests for changed behavior, including relevant failure paths; run targeted tests then broaden by risk.
- Use TESTING.md for actual commands. Report skipped/unavailable checks; never infer current coverage or passing tests from a badge.
- Run gofmt on changed Go files, appropriate build/vet/test checks, and race checks for concurrency where available. Do not weaken security/assertions to obtain green output.
- SQL mocks do not prove live MySQL locking/replication. External fakes do not prove delivered email or real mailbox behavior. Identify these gaps explicitly.
- Transaction helper/resolver changes need dedicated review and MySQL integration verification; missing verification remains a disclosed gap, never production proof.

## Documentation gate

- Canonical rules, topic ownership and task routing agree; examples exist in this repository.
- Relative links, anchors, skill references and stated commands resolve.
- Tool/dependency/CI/schema claims are grounded in current relevant files; snapshots remain labeled historical.
- For changed agent instructions, test task-selection/application scenarios, including side-effect authorization.
- `git diff --check` passes; preserve existing user changes. Documentation-only work does not establish fresh application test results.

## Completion report

State what changed, why, exact checks/results, intentional contract changes, and material unverified behavior. Cite relevant paths/lines. Do not claim deployment, database safety or performance beyond the evidence.
