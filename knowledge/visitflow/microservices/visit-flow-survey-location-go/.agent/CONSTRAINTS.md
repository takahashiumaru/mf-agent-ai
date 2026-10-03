# Survey Constraints

Mandatory rules are in ../AGENTS.md. This reference highlights local compatibility risks.

- Repositories accept service-selected `*gorm.DB`; writes and dependent reads use the same writer transaction. Do not assume a repository receives a resolver.
- Preserve composite business/company keys, DTO/JSON field types, periods and audit fields. Verify actual tenant predicates rather than inferring them from auth wrappers.
- Preserve method-local returned-error versus panic behavior and middleware mapping. Do not swallow failures or partially migrate error architecture.
- Explicit deletion fields do not imply GORM soft deletion; inspect SQL and caller intent. Destructive live operations require workspace approval.
- Bind SQL values and allowlist filter/sort identifiers. Check query cardinality and bounds before optimizing.
- Keep secrets/config values and raw customer rows out of docs/logs/tests. Treat source/schema artifacts as sensitive where appropriate.
- No automatic startup migration, broad architecture rewrite or unrelated auth-policy change in a local fix.
- Source examples are scoped; read PREFERRED_PATTERNS and TESTING before copying them. QUALITY_GATES owns completion.
