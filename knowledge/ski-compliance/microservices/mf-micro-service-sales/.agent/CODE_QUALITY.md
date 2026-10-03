# Code Quality & Maintainability — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

Standards and review criteria for maintaining clean, robust, and maintainable Go code across the repository.

---

## 1. Quality Standards
- **Maintain Architectural Purity**:
  - Keep controllers thin (I/O, status codes, payload mapping).
  - Keep business logic and validation in services.
  - Keep persistence and auditing in repositories.
- **Do Not Over-Engineer**:
  - Avoid creating complex generic repository frameworks or unnecessary reflection helpers.
  - Implement concrete methods tailored to domain requirements.

---

## 2. Code Review Checklist for Agents
Before concluding any task:
1. **Formatting & Linting**: Run `go fmt ./...`, `go vet ./...`, and `golangci-lint run`.
2. **Error Safety**: Ensure no errors are ignored. Propagate via `helper.PanicIfError(err)` or return explicitly.
3. **Transaction Safety**: Verify `tx.Begin()` is paired with `defer helper.CommitOrRollback(tx)` in services.
4. **Audit History**: Ensure all mutation methods trigger `helper.CreateHistory(...)`.
5. **No Regressions**: Run `go test ./...` to verify existing tests pass.
