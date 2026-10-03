---
name: database-schema
description: Design, modify, and align relational schemas, columns, constraints, and data types. Use when altering table structures or model fields.
---

# Database Schema Skill

## Purpose & Trigger
Ensure schema-model alignment, appropriate data types, and primary/foreign key constraints across downstream services.

## Workflow
1. **Understand**: Identify required domain attributes and relationships.
2. **Inspect**: Compare current table schema (`SHOW CREATE TABLE`) against Go struct tags.
3. **Plan**: Define non-destructive additive schema modifications.
4. **Implement**: Create versioned DDL migration scripts and update Go model structs.
5. **Verify**: Test serialization, constraint enforcement, and query compatibility.

## Hard Rules
- Maintain UTF-8 multi-byte collation (`utf8mb4_unicode_ci`).
- Never drop columns or tables in production without an expand-contract deprecation period.
