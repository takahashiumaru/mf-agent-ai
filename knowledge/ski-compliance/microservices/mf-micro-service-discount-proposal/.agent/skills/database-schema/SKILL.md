---
name: database-schema
description: Model database entities, define GORM struct tags, align Go models with existing MySQL schema, and manage data contracts. Use whenever adding or modifying domain entities in model/domain/.
---

# database-schema

Guides domain entity modeling and GORM schema mapping in `mf-micro-service-discount-proposal`.

## Core References
- [DATABASE.md](../../DATABASE.md) — Key tables, primary key schemes, foreign key constraints.
- [GORM.md](../../GORM.md) — GORM struct tags, sizing, soft deletes.
- [DOMAIN.md](../../DOMAIN.md) — Business models, terminology, state invariants.

## Standard Workflow
1. **Understand**: Identify the target database table and entity attributes.
2. **Inspect Existing Schema**: Verify column names, types, nullability, and indexes in MySQL.
3. **Define Domain Struct (`model/domain/<entity>.go`)**:
   - Add standard audit fields (`CreatedAt`, `UpdatedAt`, `CreatedByID`, `UpdatedByID`, `DeletedByID`).
   - Use `gorm.DeletedAt` for soft-delete support.
   - Use pointers (`*float64`, `*bool`, `*string`) for nullable columns.
   - Declare slice alias (`type <Entity>s []<Entity>`).
   - Implement mapper methods (`To<Entity>Response()` and `To<Entity>Responses()`).
4. **Define DTO Structs (`model/web/<entity>_*.go`)**:
   - Add JSON tags and validator tags (`validate:"required,period_month"`).
5. **Verify**:
   - `go vet ./...`
   - `go build -o /dev/null .`

## Hard Guardrails
- **NEVER** rely on GORM `AutoMigrate` at application startup.
- **ALWAYS** declare typed slice aliases in the domain file.
- **DO NOT** change existing JSON tag names in response structs to preserve client backward compatibility.
