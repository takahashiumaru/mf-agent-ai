---
name: database-schema
description: Manage and align GORM domain model definitions with MySQL table schemas, types, and constraints. Use whenever adding, modifying, or reviewing database tables, columns, or model struct tags.
---

# Database Schema Skill

## Purpose
Ensure precision and consistency between GORM domain models and underlying MySQL database tables.

## When to Use
Use when creating new models, adding columns, modifying constraints, or altering GORM struct tags.

## Workflow
1. **Understand**: Check source of truth schema and model struct tags.
2. **Inspect**: Check foreign key relations, unique composite indexes (`idx_marketing_structure`), and nullable fields.
3. **Plan**: Define explicit GORM tags (`size`, `primaryKey`, `uniqueIndex`, `not null`).
4. **Implement**:
   - Update domain structs in `model/domain/`.
   - Update corresponding request/response DTOs in `model/web/`.
   - Update mapping helpers (`ToResponse`).
5. **Verify**:
   - Run `go test ./...` and `go vet ./...`.

## Hard Rules
- Do not enable automatic `AutoMigrate` at runtime in production.
- Always check zero-value implications for newly added non-pointer fields.

## References
- [.agent/DATABASE.md](../../DATABASE.md)
- [.agent/GORM.md](../../GORM.md)
