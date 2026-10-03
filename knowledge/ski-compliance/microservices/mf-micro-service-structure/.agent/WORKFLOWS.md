# Engineering Workflows & Checklists — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document provides step-by-step checklists for recurring engineering tasks.

---

## 1. Adding a New HTTP Endpoint

1. **Define DTOs (`model/web/`)**:
   - Create `<entity>_<action>_request.go` and/or `<entity>_response.go`.
   - Add struct tags for JSON mapping and Go-Playground validation.
2. **Define Repository Contract (`repository/`)**:
   - Add method to `<entity>_repository.go` interface.
   - Implement in `<entity>_repository_impl.go` using parameterized GORM queries and `helper.PanicIfError(err)`.
3. **Define Service Contract (`service/`)**:
   - Add method to `<entity>_service.go` interface.
   - Implement in `<entity>_service_impl.go`:
     - Validate input: `err := service.Validate.Struct(request); helper.PanicIfError(err)`
     - Open transaction: `tx := service.DB.Begin(); defer helper.CommitOrRollback(tx)`
     - Execute business rules and repository calls.
     - Map domain models to DTO responses (`model.ToResponse()`).
4. **Implement Controller (`controller/`)**:
   - Add handler method to `<entity>_controller.go` and `<entity>_controller_impl.go`.
   - Parse query filters or unmarshal request body.
   - Return standard response: `c.JSON(http.StatusOK, web.WebResponse{Success: true, Message: "...", Data: response})`.
5. **Register Route (`route/`)**:
   - Add route definition to `route/<entity>_route.go` with `auth.Auth(...)` if authentication is required.
6. **Verify**:
   - Run `go vet ./...` and `go test ./...`.

---

## 2. Modifying Business Logic or Closing Rules

1. Locate affected service method in `service/<entity>_service_impl.go`.
2. Verify existing period validation (`helper.ValidateClosing(tx, period)` or `helper.ValidationPeriodeUpdate(...)`).
3. If mutating records, ensure `helper.CreateHistory(tx, &entity, action, auth.UserID)` is called.
4. If downstream sync is required, check whether `helper.EtlToMssql(...)` or `helper.SyncVisitflow(...)` should be triggered.
5. Verify transaction safety (`helper.CommitOrRollback(tx)`).

---

## 3. Optimizing or Changing a Database Query

1. Inspect generated SQL query via GORM debug logger (`app/database.go`).
2. Identify filters in `repository/<entity>_repository_impl.go`.
3. Check table indexes in `model/domain/<entity>.go` and existing database schema.
4. Replace N+1 query loops with batch queries (`Where("code IN ?", codes)`) or preloads.
5. Parameterize all dynamic values; never concatenate raw strings into SQL.
6. Run `go test ./...` and `go vet ./...`.

---

## 4. Fixing a Bug

1. Reproduce the bug with a focused test case or input scenario.
2. Trace request from `route/` → `controller/` → `service/` → `repository/`.
3. Check panic-recovery mapping in `exception/error_handler.go`.
4. Apply the minimal safe fix without altering public API response structures or status codes.
5. Run `go test ./...` and `go vet ./...` to ensure no regressions.
