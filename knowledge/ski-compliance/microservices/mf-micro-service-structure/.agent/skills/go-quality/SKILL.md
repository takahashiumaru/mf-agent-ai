---
name: go-quality
description: Review and implement Go code adhering to repository-specific panic-recovery architecture, clean layering, and coding standards. Use whenever writing, modifying, or reviewing Go source code in this service.
---

# Go Quality Skill

## Purpose
Ensure all Go code in `mf-micro-service-structure` conforms to repository-specific layering, panic-recovery error flow, and idiom rules.

## When to Use
Use whenever adding new functions, modifying services/controllers/repositories, or reviewing Go code.

## Workflow
1. **Understand**: Check affected layers (`controller`, `service`, `repository`, `helper`).
2. **Inspect**: Review existing patterns in neighboring files.
3. **Plan**: Identify inputs, validation rules, transaction requirements, and DTO mappings.
4. **Implement**:
   - Write clean, explicit control flow with early returns.
   - Use constructor injection (`New<Entity><Role>(...)`).
   - Use `helper.PanicIfError(err)` for unexpected failures.
   - Use `*exception.ErrorSendToResponse` for business validation errors.
5. **Verify**:
   - Run `go fmt ./...`
   - Run `go vet ./...`
   - Run `go test ./...`

## Hard Rules
- Never convert errors to silent returns.
- Never log duplicate errors across layers.
- Never hardcode secrets.

## References
- [.agent/GO_BEST_PRACTICES.md](../../GO_BEST_PRACTICES.md)
- [.agent/CODE_STYLE.md](../../CODE_STYLE.md)
- [.agent/ERROR_HANDLING.md](../../ERROR_HANDLING.md)
