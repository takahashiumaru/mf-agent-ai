# Authorized read-only database access

## Authorization

On 2026-09-27 the user explicitly allowed `SKI_MF_PROD` reads and identified the discount-proposal `.env` as the connection source. Production reads remain authorized. A later instruction routes proposed mutations to SKI_MF_DEV and requires explicit confirmation before each concrete operation; it does not preapprove writes. The excluded discount-proposal repository is not edited. Only the connection settings needed by the runner are read in memory.

Source path: `mf-micro-service-discount-proposal/configuration/.env`, relative to workspace root. Needed key names: `HOST_DB`, `PORT_DB`, `USER_DB`, `PASSWORD_DB`, `DATABASE_DB`. Never show values. Do not source this file in a shell, log it, or include it in commits.

## Supported workflow

From workspace root:

```sh
python3 .agent/tools/db_readonly.py --probe
python3 .agent/tools/db_readonly.py <<'SQL'
SELECT TABLE_TYPE, COUNT(*) AS object_count
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
GROUP BY TABLE_TYPE
ORDER BY TABLE_TYPE;
SQL
```

For business questions, first confirm columns, filters, and grain, then supply a single reviewed SELECT through stdin in the same way. Record the query's execution time and result separately from the schema snapshot's timestamp. `--check` validates SQL without connecting. The normal output is tab-separated, without column headings; label results using the SELECT projections.

The runner uses a temporary MySQL option file with mode 0600, removes it afterward, avoids credentials in process arguments, and redacts client errors. It sets session transaction mode READ ONLY and starts a READ ONLY transaction, ending with ROLLBACK. These session settings do not change database tables or data. MySQL `MAX_EXECUTION_TIME=5000`, client/process timeouts, and a 200-row result cap limit supported queries. A LIMIT may still scan many rows; start with selective predicates.

The schema exporter uses fixed metadata statements with no 200-row cap so a large schema is not silently truncated. It retrieves column/index/FK/routine names and table DDL; it does not fetch business rows, view definitions, routine bodies, or trigger bodies.

## Limits and failure handling

- Account privileges are **not audited**. Session restrictions are defense in depth, not proof that the account is inherently read-only.
- The SELECT validator is a deliberately conservative filter, not a complete SQL parser or an independent access-control boundary. The caller must review scope and semantics.
- Unsupported constructs include comments, CTEs, multiple statements, variables, arbitrary functions, routines, file operations, locks, and detail LIMIT above 200. Simplify the query or report the limitation; do not bypass the guard.
- Plain `EXPLAIN SELECT ...` is supported through the same guard and read-only session. `EXPLAIN ANALYZE`, EXPLAIN of mutations, and other EXPLAIN forms are unsupported; do not bypass the guard.
- This read runner covers SKI_MF_PROD and its metadata only. Do not use metadata access to enumerate unrelated schemas.
- A timeout/error is not an empty dataset. State which result could not be verified and provide only clearly labeled unexecuted SQL if useful.
- Multiple retrievals can observe different committed data. For a single total-and-breakdown reconciliation, prefer one SELECT when possible; disclose timing differences otherwise.

## Mutations and environment selection

Follow [environment routing and confirmation](../AGENTS.md#database-environment-routing-and-confirmation). DEV is the default for proposed mutations, with explicit approval required after SQL and impact are shown. Production mutations default to a clearly labeled unexecuted SQL proposal. This runner remains production read-only; no write connection or mutation was executed while adding this policy.
