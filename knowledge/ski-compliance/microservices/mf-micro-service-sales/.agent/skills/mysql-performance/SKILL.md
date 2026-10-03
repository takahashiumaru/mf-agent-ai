---
name: mysql-performance
description: Use when analyzing slow MySQL queries, optimizing indexes, reviewing execution plans, and reducing database load on high-volume tables.
---

# MySQL Performance Skill

## Guidelines
1. **Index Coverage**: Match `WHERE` conditions to existing composite indexes (e.g. `period`, `outlet_id`, `product_id`).
2. **Eliminate N+1**: Never query the database inside a `for` loop. Fetch in batches with `IN (...)` or JOINs.
3. **Bounded Lists**: Always enforce `.Limit(500)` or pagination on list endpoints.
4. **Parameter Binding**: Always use parameterized queries; never concatenate strings into SQL.

See [.agent/DATABASE_PERFORMANCE.md](../../DATABASE_PERFORMANCE.md) and [.agent/DATABASE.md](../../DATABASE.md).
