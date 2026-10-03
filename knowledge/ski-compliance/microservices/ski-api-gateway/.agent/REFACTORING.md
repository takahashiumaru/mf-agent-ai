# .agent/REFACTORING.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Safe Refactoring Guidelines

When modifying existing code in `ski-api-gateway`, follow the **Protect-First Migrate-When-Touched** methodology.

---

## 1. The 6-Step Safe Refactoring Loop

```text
1. CHARACTERIZE BEHAVIOR  -> Trace existing routes, middleware chains, and inputs/outputs.
2. IDENTIFY CALLERS       -> Find all frontend callers, upstream proxies, and downstream microservices.
3. ADD REGRESSION TESTS   -> Ensure >=90% test coverage protects the current behavior before changes.
4. MAKE FOCUSED CHANGE    -> Apply the minimal isolated edit without unrelated restructuring.
5. VERIFY AUTOMATICALLY   -> Run test suite, race checks, and static analysis.
6. REVIEW DIFF            -> Inspect `git diff` to ensure zero unexpected contract changes.
```

---

## 2. Refactoring Scope Boundaries

- **Allowed in Normal Tasks**:
  - Adding unit tests and mocks.
  - Adding thread-safety locks to unsynchronized state.
  - Updating error message handling without changing external status codes.
  - Refactoring internal helper functions into cohesive structs.
- **Requires Dedicated Task & Explicit Approval**:
  - Changing public route paths or URL parameters.
  - Modifying the JWT algorithm or secret key configuration.
  - Changing HTTP status codes on existing API contracts.
  - Introducing external infrastructure (e.g., Redis, Kafka).
