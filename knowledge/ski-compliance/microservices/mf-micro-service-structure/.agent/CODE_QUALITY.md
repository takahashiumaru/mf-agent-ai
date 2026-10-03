# Code Quality Checklist & Review Guide — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

Use this checklist to review code changes before submission or merge.

---

## 1. Correctness & Error Flow

- [ ] Does the change preserve the panic-recovery error model (`helper.PanicIfError`)?
- [ ] Are all errors handled rather than ignored?
- [ ] Are custom business validation rejections mapped to `*exception.ErrorSendToResponse`?
- [ ] Does error propagation ensure automatic transaction rollback in `helper.CommitOrRollback`?

---

## 2. GORM & Database Safety

- [ ] Are all database mutations executed within a transaction `tx *gorm.DB`?
- [ ] Are zero-value updates explicitly handled with `.Select(...)` or `map[string]any`?
- [ ] Is `db.Save()` avoided for partial updates?
- [ ] Are dynamic filter values parameterized using placeholders?
- [ ] Is `helper.CreateHistory` called for audit logging on all created, updated, or deleted master entities?

---

## 3. API & Business Invariants

- [ ] Does the response match the `web.WebResponse{Success, Message, Data}` envelope?
- [ ] Is the 6-digit `YYYYMM` period format enforced?
- [ ] Are period closing checks (`ValidateClosing`, `IsClosedEditArea`, `IsClosedEditAll`) respected?
- [ ] Are user IDs for auditing derived from authenticated token claims (`auth.UserID`)?

---

## 4. Verification Evidence

- [ ] `go fmt ./...` produces no diff.
- [ ] `go vet ./...` succeeds with exit code 0.
- [ ] `go test ./...` passes without errors.
- [ ] If guidance changed, `.agent/CHANGELOG.md` is updated.
