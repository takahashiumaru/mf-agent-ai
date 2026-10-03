# Safe Refactoring Guidelines — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

Rules and boundaries for performing safe, incremental code improvements in this repository.

---

## 1. Golden Rules of Refactoring in this Codebase
1. **Never Combine Refactoring with Unrelated Feature Changes**: Keep refactoring commits strictly separated from new feature or bugfix implementations.
2. **Preserve External API & Database Contracts**:
   - Do not alter JSON response field names or structure.
   - Do not change HTTP status codes (e.g. `gorm.ErrRecordNotFound` returning 200 OK).
   - Do not rename existing database table columns without dedicated migration plans.
3. **Always Add Unit Tests Before Touching Complex Logic**:
   - Write tests capturing current behavior prior to modifying calculation-heavy methods (e.g. `sales_ff`, `stock_distributor`).
4. **Prefer Incremental In-Place Improvements**:
   - Avoid massive rewrites or introducing new global abstractions (e.g., generic repository interfaces or DDD layer overhauls).

---

## 2. Safe "Migrate-When-Touched" Opportunities
When actively modifying an existing file:
- **Add Query Limits**: If a `FindAll` query lacks `.Limit(500)`, add it.
- **Replace N+1 Loops with Joins**: If a loop issues individual queries per item, refactor to batch lookup with `Joins` or `IN (...)`.
- **Ensure Proper History Logging**: If a mutation method lacks `helper.CreateHistory(...)`, add change tracking.
- **Fix Zero-Value Update Hazards**: Convert ambiguous boolean/numeric update fields to pointers (`*bool`) or use targeted `.Updates(map[string]interface{})`.
