# Safe Refactoring

Refactoring must preserve observable behavior unless the task explicitly changes it. Prefer characterization tests and small reversible steps over cross-repository rewrites.

## Entry Criteria

Before refactoring:

- state the concrete problem: correctness risk, duplication, testability, or measured performance;
- identify affected endpoints, interfaces, constructors, mocks, models, queries, transactions, and external side effects;
- record current response/error/status/tenant behavior;
- add or identify tests that fail if behavior drifts;
- separate required cleanup from optional architecture work.

Do not refactor only because a function is long or code is old.

## Change Classification

### Safe migrate-when-touched

Usually suitable inside a feature/bug fix when scoped and tested:

- check a previously ignored error;
- replace a partial `Updates(struct)` with an explicit update map;
- add tenant/ownership predicates that are proven required;
- replace per-item reads with an equivalent batch read/map;
- extract a pure validation/calculation/mapping helper;
- inject one dependency currently constructed inside the touched service;
- bound a new list endpoint or remove an accidental unbounded query without breaking its contract;
- move avoidable file/network work outside a transaction;
- add `RowsAffected` validation where “no row changed” is an error.

### Dedicated refactor task required

- transaction/resolver redesign;
- replacing panic/recovery across a public call chain;
- global HTTP error/status normalization;
- role/authorization redesign;
- splitting GORM persistence models from domain/web mapping;
- changing pagination contracts to cursors;
- introducing durable jobs/queues for notifications;
- moving horizontal layer packages into feature packages;
- replacing handwritten mocks or broad interfaces repository-wide;
- changing migration tooling or schema ownership;
- renaming widely used legacy symbols/files.

## Incremental Refactoring Sequence

1. **Characterize:** add tests around existing behavior, including odd legacy behavior clients may depend on.
2. **Create a seam:** extract a pure helper or introduce one injected dependency without changing output.
3. **Move one responsibility:** validation, mapping, query, or side effect—not several at once.
4. **Verify:** run focused tests and compare SQL/response behavior where applicable.
5. **Remove duplication only after equivalence is proven.**
6. **Stop:** do not continue into neighboring modules without a new scoped reason.

Small commits are recommended when version-control workflow is in scope: test/characterization, mechanical seam, behavior-preserving move, then behavior change.

## Error-Handling Migration

The panic flow is tied to middleware and rollback. Safe migration requires:

1. define the target typed/sentinel error and HTTP mapping;
2. change repository interface and implementation to return it;
3. preserve identity with `%w`;
4. update service propagation and transaction rollback;
5. update controller/global mapping;
6. update route callers and handwritten mocks;
7. test validation, not-found, duplicate/FK, rollback, and internal failure;
8. remove `PanicIfError` only after no caller relies on it.

Do not catch a panic and convert it locally while continuing a transaction.

## Context Migration

Existing service interfaces accept `*gin.Context`. When introducing a lower-level helper or new repository API:

- prefer `context.Context` as its first argument if compatible;
- pass `c.Request.Context()` from the service/controller boundary;
- keep Gin-specific parsing/response behavior out of lower layers;
- update mocks/tests with cancellation cases when meaningful;
- do not convert all interfaces repository-wide during one endpoint change.

## Dependency Injection Migration

When touching a service that constructs `repository.XImpl{}`:

1. add the smallest required interface field;
2. add it to the constructor;
3. update the route composition root;
4. update tests/mocks;
5. replace only the touched hidden construction;
6. avoid injecting every possible repository preemptively.

Constructor growth may reveal an oversized service, but splitting it is a separate decision.

## Function Decomposition

Extract in this order:

1. pure validation and state-transition decisions;
2. pure calculations and transformations;
3. DTO/domain mapping;
4. grouped persistence operations with a narrow interface;
5. external side effects.

Keep business transaction orchestration readable in the service method. Do not hide sequence or commit boundaries behind a generic “workflow engine.”

For repeated customer/location/approval helpers, first write tests documenting differences in status, audit IDs, tenant scope, and notifications. Extract only common mechanics; leave different policies separate.

## Safe GORM Refactors

### Partial update

1. list fields the endpoint may change;
2. distinguish omitted from zero/false/empty/null in the DTO;
3. build an explicit update map or `Select` list;
4. retain tenant/current-status predicates;
5. check `Error` and, when required, `RowsAffected`;
6. reload through `tx.Write` if the response must see the uncommitted update;
7. test each zero-value case.

### `Save` replacement

Before replacing `Save`, identify every field intentionally persisted. Use an allowlisted map and tests to prove omitted fields remain unchanged. Do not mechanically replace full-row save semantics with struct `Updates`.

### Not-found behavior

Changing `Find` to `First` can introduce an error where absence was previously silent. Characterize the endpoint contract first. If changing behavior, update error mapping and client-facing tests explicitly.

### Soft/hard delete

Verify the model's deleted-at type, GORM scope, uniqueness behavior, audit fields, child relationships, and rebuild/restore semantics. Never remove `Unscoped` or add it without understanding why the flow rebuilds data.

### Relations and N+1

- capture the current query count/result cardinality;
- collect unique keys;
- introduce one batch query/targeted preload/join;
- map results without changing order or duplicate semantics;
- compare output and query count;
- inspect indexes and `EXPLAIN` for a significant query.

## Transaction Refactoring

- Do not combine manual commit cleanup with unrelated business changes.
- All atomic writes and dependent reads use the same `tx.Write` transaction.
- Move slow side effects outside the transaction only after deciding whether they occur before or after commit and what failure means.
- Preserve the original error when rollback fails.
- Test failure at each write boundary and ensure no partial committed state.
- Because the read transaction lifecycle is unclear, changing `go-helper.CreateTransaction` usage across modules requires a dedicated task and MySQL integration tests.

## Raw SQL Refactoring

- Keep values parameterized before and after.
- Preserve null, collation, timezone, grouping, and duplicate semantics.
- Introduce projection structs for explicit result columns.
- Compare generated/result SQL on representative data.
- For performance changes, store sanitized before/after plans; do not claim improvement from aesthetics.
- Do not translate a complex stored procedure to GORM chains without a clear operational reason.

## Package Boundary Refactoring

Current models combine persistence and response mapping, and repositories sometimes return web projections. Do not create a second architecture alongside one endpoint. A boundary migration needs:

- a defined target dependency direction;
- incremental adapters;
- no import cycle;
- compatibility for routes/services/tests;
- a module-by-module rollout plan.

Prefer preventing new violations over fixing all historical ones.

## Verification Matrix

Choose checks proportional to the refactor:

| Change | Minimum verification |
| --- | --- |
| Pure helper extraction | Existing + focused unit tests |
| Dependency injection seam | Constructor/mocks + service tests |
| GORM update | Zero values, scope, `RowsAffected`, reload behavior |
| Query batching/join | Same rows/order + query count/plan review |
| Transaction change | Integration rollback and read-your-writes tests |
| Error contract | Repository/service/controller mapping tests |
| Delete lifecycle | Soft/hard visibility, audit, related rows |
| Raw SQL | Representative MySQL result and plan |

## Stop Conditions

Stop and create a separate task when:

- the public API/error/status contract must change;
- production schema/migration ownership is needed;
- more than one major domain becomes involved;
- reliable verification requires unavailable external systems;
- the change requires altering the shared transaction helper;
- authorization policy is ambiguous;
- a “cleanup” starts changing business behavior.
