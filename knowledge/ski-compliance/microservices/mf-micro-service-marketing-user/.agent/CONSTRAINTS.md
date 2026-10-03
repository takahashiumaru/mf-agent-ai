# Constraints and compatibility

Read [AGENTS.md](../AGENTS.md) and [current exceptions](EVIDENCE.md) first.

## Required for changes

- Preserve the exact endpoint contract: JSON or file body, status, headers, field semantics and filters.
- Identify the transaction owner/callers and ensure related writes use the intended handle. Follow existing safe ownership; propose repairs separately when the current implementation is inconsistent.
- Check zero/null writes, soft-delete behavior, business period/closing rules, hierarchy scopes and audit/sync effects against actual source and schema.
- Parameterize values; allowlist dynamic identifiers/sort expressions. Parameterization alone does not validate business authorization.
- Do not log secrets, start migrations, or write to any database without the workspace environment/confirmation workflow.
- Preserve user edits; keep changes scoped and cite implementation evidence.

## Preferred design, not proof of current implementation

Service-owned transactions, transport-independent domain logic, bounded queries and explicit dependency interfaces are useful design goals. Existing code has exceptions. Do not impose a new transaction/context/interface pattern across the repository merely because an older guide uses MUST. Inspect callers and explain compatibility implications first.

## Documentation

Use relative links. Separate observed facts, recommended patterns and unresolved issues. Record dates/revisions for measurements and evidence; follow [MAINTENANCE.md](MAINTENANCE.md).
