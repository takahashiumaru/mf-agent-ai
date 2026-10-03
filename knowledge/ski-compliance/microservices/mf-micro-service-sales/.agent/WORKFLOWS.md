# Implementation Workflows — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document provides step-by-step implementation workflows for common tasks in this repository.

---

## 1. Workflow: Adding a New API Endpoint

When implementing a new feature or endpoint, follow this layered sequence:

```
Step 1: Request DTO in model/web/<entity>_<action>_request.go
  ↓
Step 2: Response DTO & Mapper in model/domain/<entity>.go & model/web/
  ↓
Step 3: Repository method & GORM query in repository/<entity>_repository*.go
  ↓
Step 4: Service method & validation/tx in service/<entity>_service*.go
  ↓
Step 5: Controller method & JSON wrapping in controller/<entity>_controller*.go
  ↓
Step 6: Route registration & middleware in route/<entity>_route.go
  ↓
Step 7: Verification via go test ./... and go vet ./...
  ↓
Step 8: Record changes in .agent/CHANGELOG.md before commit/push!
```

### Reference Implementation
Study the complete flow implemented for `BridgingOutlet`:
- Route: [route/bridging_outlet_route.go](../route/bridging_outlet_route.go)
- Controller: [controller/bridging_outlet_controller_impl.go](../controller/bridging_outlet_controller_impl.go)
- Service: [service/bridging_outlet_service_impl.go](../service/bridging_outlet_service_impl.go)
- Repository: [repository/bridging_outlet_repository_impl.go](../repository/bridging_outlet_repository_impl.go)
- Domain: [model/domain/bridging_outlet.go](../model/domain/bridging_outlet.go)

---

## 2. Workflow: Modifying Database Entities & Models

When adding or updating fields in an existing table:
1. **Update Domain Model**: Add the field with proper GORM tags in `model/domain/<entity>.go`.
   - If the field can be null or zero, use a pointer (e.g. `*bool`, `*time.Time`, `*uint`).
2. **Update DTOs**:
   - Add field with `validate:"..."` tags in `model/web/<entity>_create_request.go` and `_update_request.go`.
   - Add field in `model/web/<entity>_response.go`.
3. **Update Domain Mapper**: Update `To<Entity>Response()` receiver method in `model/domain/<entity>.go`.
4. **Update Repository / Queries**: Ensure `Joins` or `Select` clauses include necessary columns.
5. **Update History & ETL**: If the field affects MSSQL sync, verify `helper.EtlToMssql` mapping parameters.
6. **Record in Changelog**: Add summary to [.agent/CHANGELOG.md](CHANGELOG.md).

---

## 3. Workflow: Performing Partial Updates Safely

To avoid unintentionally overwriting zero values (`false`, `0`, `""`):
1. Use pointer types on the struct fields that may receive zero values (e.g. `OutletUpdated *bool`).
2. Construct the update payload explicitly in the service layer:
   ```go
   entity := &domain.BridgingOutlet{
       UpdatedByID:           auth.UserID,
       BranchDistributorID:   request.BranchDistributorID,
       BranchDistributorName: request.BranchDistributorName,
       OutletUpdated:         request.OutletUpdated,
   }
   ```
3. In repository, update specific model fields:
   ```go
   err := db.Updates(&entity).Error
   helper.PanicIfError(err)
   ```

---

## 4. Workflow: Fixing a Bug

1. **Identify Flow**: Trace the failing endpoint from `route/` to `controller/`, `service/`, and `repository/`.
2. **Inspect Error Handler**: Check if the issue is a validation failure (HTTP 400), unhandled MySQL error code, or domain rule violation.
3. **Reproduce with Test**: Add or inspect a unit test in the affected package.
4. **Apply Minimal Fix**: Make targeted changes strictly in the responsible layer without broad refactoring.
5. **Verify**: Run `go test ./...` and `go vet ./...`.
6. **Record in Changelog**: Document bug fix in [.agent/CHANGELOG.md](CHANGELOG.md).
