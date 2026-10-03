# .agent/GORM.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## GORM & ORM Standards for the Ecosystem

While `ski-api-gateway` does not directly execute GORM queries, it serves as the API gateway routing to GORM-based Go microservices across the SKI platform. This document establishes the GORM rules and expectations that govern the platform.

---

## 1. GORM Initialization & Context

- Always pass context: `db.WithContext(ctx)`.
- Use explicit connection pooling (`SetMaxIdleConns`, `SetMaxOpenConns`, `SetConnMaxLifetime`).
- Avoid global mutable `*gorm.DB` instances; pass the configured database handle via dependency injection.

---

## 2. Reads, Associations & Performance

- **Avoid N+1 Queries**: Use `.Preload()` or explicit `.Joins()` for required associations.
- **Select Only Needed Columns**: For large tables or list endpoints, specify `.Select("id", "name", ...)` instead of `SELECT *`.
- **Bounded Pagination**: Always enforce `.Limit()` and `.Offset()` on list queries.
- **Raw SQL**: When raw SQL is necessary (`db.Raw()`, `db.Exec()`), always use `?` placeholders for parameterization; never concatenate untrusted inputs.

---

## 3. Mutations, Updates & Zero Values

- **Zero-Value Updates**: Remember that `db.Updates(modelStruct)` skips zero-value fields (`0`, `false`, `""`). Use `db.Model(&model).Select("field1", "field2").Updates(...)` or `map[string]any` when zero values must be persisted.
- **Avoid `Save` for Partial Updates**: `db.Save()` updates all fields and risks overwriting concurrent changes or zeroing unpopulated fields.
- **Soft Deletes**: Respect GORM's `gorm.DeletedAt` tag. Avoid `Unscoped()` unless explicit administrative hard deletion is authorized.

---

## 4. Transactions

- Transactions must be managed at the use case / service layer.
- Ensure the transaction `*gorm.DB` instance is passed through to all repository operations within the transaction scope.
- Avoid making external HTTP or slow network calls while holding database transaction locks.
