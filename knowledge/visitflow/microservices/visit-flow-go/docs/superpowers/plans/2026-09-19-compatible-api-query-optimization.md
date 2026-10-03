# Compatible API Query Optimization

## Objective

Reduce avoidable database work without changing endpoint routes, HTTP status
handling, JSON field names, response data, or established business rules.

## Compatibility boundary

- Legacy public identifiers remain accepted exactly as currently emitted.
- Authorization/tenant scope, pagination metadata, and report visibility are
  excluded because their intended policy is not defined in the repository and
  changing them can change response data.
- No DDL, migrations, indexes, or database mutations are performed.
- Query rewrites are accepted only when a regression test or direct predicate
  equivalence demonstrates identical results.

## Planned changes

1. Restore compatibility for customer/structure-location mutations that use
   dash-delimited composite public IDs. Components may themselves contain a
   dash, so splitting the identifier is ambiguous and can target a different
   row. Keep the existing public-ID comparison until the API contract can be
   versioned to use an unambiguous identifier.
2. Keep the safe, already-present sargable same-day range in `CountMcl` and
   remove only duplicate repository reads where the returned data is unchanged.
3. Characterize the visit-achievement query before removing any remaining
   redundant grouping or joins; do not make a cardinality-changing join rewrite
   without a focused test.
4. Add focused regression tests for ID parsing/mutation predicates and execute
   formatting, targeted tests, build, and the widest feasible test command.

## Verification

- `go test` tests introduced for this change must pass before implementation is
  considered complete.
- `go build ./...` must pass.
- `go test ./...` will be run and any pre-existing failures reported separately
  with their exact source, without modifying unrelated user-owned tests.
