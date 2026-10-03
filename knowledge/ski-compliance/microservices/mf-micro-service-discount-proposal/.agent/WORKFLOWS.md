# .agent/WORKFLOWS.md — Engineering Workflows & Checklists

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

This document provides step-by-step, evidence-based checklists for the most common engineering tasks in `mf-micro-service-discount-proposal`.

---

## Workflow 1: Adding a New API Endpoint

1. **Define DTOs in `model/web/`**:
   - Create request struct (e.g. `model/web/<feature>_create_request.go`) with JSON and validator tags (`validate:"required,period_month"`).
   - Create response struct (e.g. `model/web/<feature>_response.go`) with JSON tags.
2. **Define/Update Domain Model in `model/domain/`**:
   - If a new entity is introduced, create `model/domain/<feature>.go` with GORM tags.
   - Implement `To<Feature>Response()` and `To<Feature>Responses()` conversion methods.
3. **Declare & Implement Repository Method**:
   - Add method signature to interface in `repository/<feature>_repository.go`:
     ```go
     FindByCriteria(db *gorm.DB, criteria string) domain.<Feature>
     ```
   - Implement method in `repository/<feature>_repository_impl.go`.
   - If performing mutations, include audit history (`helper.CreateHistory`) and return any needed ETL side-effect callback (`func()`).
4. **Declare & Implement Service Method**:
   - Add method signature to interface in `service/<feature>_service.go`:
     ```go
     FindByCriteria(auth *auth.AccessDetails, criteria string) web.<Feature>Response
     ```
   - Implement method in `service/<feature>_service_impl.go`.
   - If performing mutations:
     - Begin transaction: `tx := service.DB.Begin()`.
     - Register `defer helper.CommitOrRollback(tx)`.
     - Validate input: `err := service.Validate.Struct(request); helper.PanicIfError(err)`.
     - Check period closing status if applicable (`helper.ValidateClosing`).
     - Pass `tx` to repository calls.
5. **Declare & Implement Controller Method**:
   - Add method signature to interface in `controller/<feature>_controller.go`:
     ```go
     FindByCriteria(c *gin.Context, auth *auth.AccessDetails)
     ```
   - Implement method in `controller/<feature>_controller_impl.go`:
     - Extract inputs (`helper.ReadFromRequestBody` or `c.Param` / `c.Query`).
     - Call service.
     - Build `web.WebResponse` and return `c.JSON(http.StatusOK, webResponse)`.
6. **Register Route in `route/<feature>_route.go`**:
   - Bind HTTP path and method:
     ```go
     router.GET("/features/:id", auth.Auth(featureController.FindByCriteria, []string{}))
     ```
   - If a new route file was created, register it in `app/router.go:NewRouter`.
7. **Verification**:
   - Run `go fmt ./...` and `go vet ./...`.
   - Run `go build -o /dev/null .`.
   - Run `go test ./...`.

---

## Workflow 2: Modifying Business Logic or Calculations

1. **Locate Target Logic in `service/`**:
   - Identify the relevant service file (e.g. `service/discount_proposal_service_impl.go` or `service/credit_note_service_impl.go`).
2. **Review Invariants & Period Rules**:
   - Consult `.agent/DOMAIN.md` and `.agent/CONSTRAINTS.md`.
   - Verify date constraints (`PeriodEnd >= PeriodStart`), status checks, and budget checks.
3. **Maintain Transaction Boundaries**:
   - Ensure all write operations remain inside `tx := service.DB.Begin()` with `defer helper.CommitOrRollback(tx)`.
4. **Raise Safe Business Errors**:
   - Use `panic(&exception.ErrorSendToResponse{Err: "Penjelasan error yang jelas"})` to abort and return a 400 Bad Request to the client.
5. **Execute Side Effect Closures**:
   - If repository returns an ETL closure, trigger it only after the main transaction logic succeeds.
6. **Verification**:
   - Run `go vet ./...` and `go test ./...`.

---

## Workflow 3: Changing a Database Query

1. **Locate Target Repository in `repository/`**:
   - Open `<feature>_repository_impl.go`.
2. **Review Query & Soft Delete Semantics**:
   - If targeting models using `*time.Time` for `DeletedAt` (e.g. `credit_notes`), ensure `deleted_at IS NULL` is included in WHERE clauses or JOIN conditions.
   - If updating nullable or zero fields, use `db.Updates(map[string]interface{}{"field": nil})` instead of `db.Updates(&struct)`.
3. **Optimize Index & Join Usage**:
   - Use indexed columns in WHERE filters (`period`, `discount_proposal_id`, `outlet_id`, `customer_id`, `product_id`).
   - Use GORM `.Select(...)` to retrieve only required columns when scanning large datasets.
4. **Preserve Audit Trail**:
   - Ensure `helper.CreateHistory(db, entity, action, userId)` is called on entity mutations.
5. **Verification**:
   - Run `go build -o /dev/null .` and `go vet ./...`.

---

## Workflow 4: Fixing a Bug

1. **Reproduce & Trace**:
   - Trace the request flow: `route -> controller -> service -> repository -> database`.
   - Inspect error handling or panic triggers.
2. **Identify Layer Responsibility**:
   - Validation bug -> Update struct tags in `model/web` or custom validator in `helper/custom_validator.go`.
   - Business rule bug -> Update logic in `service/<feature>_service_impl.go`.
   - Query / Data persistence bug -> Update repository query in `repository/<feature>_repository_impl.go`.
3. **Preserve Existing Behavior**:
   - Ensure existing endpoint payload formats, response message keys, and status codes are not broken.
4. **Verification**:
   - Run `go vet ./...`.
   - Run `go test ./...`.
   - Run `go build -o /dev/null .`.

---

## Workflow 5: Changing Database Schema / Domain Entities

1. **Update Domain Model in `model/domain/<feature>.go`**:
   - Add or modify fields with appropriate GORM tags (`gorm:"column:name;size:20"`).
   - Update mapper methods `To<Feature>Response()` and slice mappers.
2. **Update Web DTO in `model/web/<feature>_*.go`**:
   - Update request/response structs and JSON tags.
3. **Prepare Migration SQL Script**:
   - Do NOT rely on GORM `AutoMigrate`.
   - Add SQL DDL statements to `app/database/before_auto_migrate.sql` or maintain a dedicated migration script.
4. **Update Repository Queries**:
   - Update any manual `.Select()` or raw SQL queries in `repository/` that reference renamed or added columns.
5. **Verification**:
   - Run `go vet ./...` and `go build -o /dev/null .`.
