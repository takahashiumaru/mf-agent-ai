# Architecture Guide — Marketing Structure Microservice

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Layered System Architecture

The service follows a layered architecture with explicit boundaries:

```text
HTTP Request
     │
     ▼
[Gin Router & Middleware] (app/router.go)
  ├─ OpenTelemetry (otelgin)
  ├─ Global Error Recovery (ErrorHandler / exception.ErrorHandler)
  └─ JWT Authentication & Claims Extraction (auth/auth.go)
     │
     ▼
[Controller Layer] (controller/*_controller_impl.go)
  ├─ Query string extraction (helper.FilterFromQueryString)
  ├─ JSON body unmarshaling (helper.ReadFromRequestBody)
  ├─ Invokes Service methods
  └─ Writes standard JSON response (model/web.WebResponse)
     │
     ▼
[Service Layer] (service/*_service_impl.go)
  ├─ DTO validation via go-playground/validator
  ├─ Transaction boundary management (tx := db.Begin(); defer helper.CommitOrRollback(tx))
  ├─ Business logic & authorization/closing validation (helper.ValidateClosing)
  ├─ Cross-domain repository coordination
  └─ DTO mapping (model.ToResponse)
     │
     ▼
[Repository Layer] (repository/*_repository_impl.go)
  ├─ GORM query construction & filter application (helper.ApplyFilter)
  ├─ CRUD database operations
  ├─ Audit history capture (helper.CreateHistory)
  └─ Panic on error (helper.PanicIfError(err))
     │
     ▼
[MySQL Database] (Tables & Views)
```

## Dependency Injection & Wiring

- Dependencies are instantiated manually in route initializers (`route/*_route.go`) without reflection-based DI containers.
- The entrypoint `main.go` initializes:
  1. Viper configuration (`configuration.LoadConfig()`).
  2. Database handle (`app.ConnectDatabase()`).
  3. Go-Playground validator with custom rules (`helper.RegisterValidation()`).
  4. Gin Engine with routes (`app.NewRouter(db, validate)`).
- Each route function initializes repositories, services, and controllers explicitly:
  ```go
  // Example from route/marketing_structure_route.go
  marketingStructureService := service.NewMarketingStructureService(
      repository.NewMarketingStructureRepository(),
      repository.NewMarketingPositionRepository(),
      repository.NewHierarchyRepository(),
      repository.NewMarketingStructureAreaRepository(),
      repository.NewMarketingStructureTerritoryOutletRepository(),
      repository.NewMarketingStructureTerritoryCustomerRepository(),
      repository.NewStructureWhProcessRepository(),
      // ... external repositories
      db, validate,
  )
  ```

## Request Lifecycle & Panic-Recovery Flow

1. **Incoming Request**: Handled by Gin. `otelgin` starts or propagates the tracing span.
2. **Panic Recovery Guard**: `app.ErrorHandler()` wraps the handler in a `defer recover()` block.
3. **Auth Guard**: `auth.Auth(...)` extracts JWT from `Authorization: Bearer <token>`, verifies signature with `ACCESS_SECRET`, and constructs `*auth.AccessDetails`.
4. **Service Transaction**:
   - Both read and write operations in services begin a transaction: `tx := service.DB.Begin()`.
   - `defer helper.CommitOrRollback(tx)` is registered.
   - If an error occurs anywhere in service or repository, `helper.PanicIfError(err)` triggers a panic.
   - `CommitOrRollback` intercepts the panic, calls `tx.Rollback()`, and re-panics with the original error.
   - `app.ErrorHandler()` catches the final panic, prints stack trace, and invokes `exception.ErrorHandler(c, err)` to write the appropriate HTTP response.
   - If no error occurs, `CommitOrRollback` commits `tx.Commit()`.

## Side Effects & External Integrations

- **Audit Trails**: Mutations automatically write serialized change records to the `histories` table using `helper.CreateHistory(db, model, action, userID)`.
- **ETL Sync**: Changes in specific marketing entities trigger asynchronous or synchronous HTTP notifications via `helper.EtlToMssql(...)` to the MSSQL bridge.
- **VisitFlow Sync**: Bulk structure duplications and closures notify the VisitFlow planning service via `helper.SyncVisitflow(...)`.
