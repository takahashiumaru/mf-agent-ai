# .agent/CODE_QUALITY.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Code Quality & Review Checklist

---

## 1. Pre-Merge Review Checklist

- [ ] **Functional Correctness**: Does the change accomplish the objective without regressions on existing routes?
- [ ] **Security**: Are all protected routes secured by JWT / API key middleware? Are secrets excluded from code and logs?
- [ ] **Error Handling**: Are all error paths properly routed to `exception.ErrorHandler` or handled with appropriate HTTP status codes?
- [ ] **Concurrency**: Are all shared variables guarded by mutexes? Does `go test -race ./...` pass with 0 warnings?
- [ ] **Coverage**: Does statement coverage meet or exceed the **90%** threshold?
- [ ] **Formatting & Linting**: Are `go fmt` and `go vet` clean?

---

## 2. Definition of Done (DoD)

A task in `ski-api-gateway` is considered complete only when:
1. Code compiles without errors or warnings.
2. All unit tests pass with `>= 90.0%` statement coverage.
3. No secrets or credentials are introduced.
4. `.agent/CHANGELOG.md` is updated if engineering standards evolved.
