# Verification by task

## Documentation-only work

Check local links, source examples, entry-point navigation and Git diff scope. Preserve application/configuration files. Do not start services or run database operations to validate documentation.

## Code work

Review affected callers, API/file contracts, transaction handles, query scope, zero/null behavior, schema compatibility and sync/history effects. Format changed Go files only. Run application tests only when requested, consistent with the workspace instructions.

Commands available when appropriate (not a claim of execution):

```sh
go build ./...
go vet ./...
go test ./...
```

Before executing tests inspect fixtures/configuration for external dependencies. Use isolated test data; never use production mutation as a test. If a check is blocked by dependency access or configuration, report that precise limitation rather than mark it passed.

## Evidence required before claiming completion

Record changed files, checks actually executed, exit status, date/revision, unresolved findings and behavior not verified. Performance claims require comparable measurements and business-result equivalence, not just a changed query/index. Historical coverage artifacts need their scope, command and revision before being treated as current.
