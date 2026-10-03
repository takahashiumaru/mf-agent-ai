# Go Code Style & Conventions — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document outlines the Go coding standards, struct conventions, naming patterns, and repository idioms observed across this codebase.

## 1. Go Version & Toolchain
- **Go Version**: `1.23` (from [go.mod](../go.mod) and [Dockerfile](../Dockerfile)).
- **Linter & Formatting**: Code must conform to `gofmt`, `go vet`, and `.golangci.yml` rules.

## 2. Package & Directory Organization
- Packages use short, lowercase names matching their directory: `controller`, `service`, `repository`, `domain`, `web`, `route`, `auth`, `helper`, `exception`, `configuration`, `app`.
- Interface files and implementation files are kept side-by-side in the same package:
  - Interface: `<entity>_<layer>.go` (e.g., [controller/bridging_outlet_controller.go](../controller/bridging_outlet_controller.go))
  - Implementation: `<entity>_<layer>_impl.go` (e.g., [controller/bridging_outlet_controller_impl.go](../controller/bridging_outlet_controller_impl.go))

## 3. Naming Conventions

### A. Structs
- **Domain Models**: Singular PascalCase (e.g., `BridgingOutlet`, `SalesDistributor`, `SalesFf`, `StockDistributor`).
- **Domain Slices (Type Aliases)**: Plural PascalCase (e.g., `type BridgingOutlets []BridgingOutlet`, `type SalesDistributors []SalesDistributor`).
- **Implementations**: Suffix with `Impl` (e.g., `BridgingOutletServiceImpl`, `BridgingOutletRepositoryImpl`, `BridgingOutletControllerImpl`).
- **Request DTOs**: `<Entity><Action>Request` (e.g., `BridgingOutletCreateRequest`, `BridgingOutletUpdateStatusRequest`, `SalesShareCreateRequest`).
- **Response DTOs**: `<Entity>Response` (e.g., `BridgingOutletResponse`, `SalesDistributorResponse`, `SalesFfResponse`).

### B. Functions & Methods
- **Constructors**: Prefixed with `New` returning the interface:
  ```go
  func NewBridgingOutletRepository() BridgingOutletRepository
  func NewBridgingOutletService(repo repository.BridgingOutletRepository, db *gorm.DB, validate *validator.Validate) BridgingOutletService
  func NewBridgingOutletController(service service.BridgingOutletService) BridgingOutletController
  ```
- **CRUD Operations**: Standard method names:
  - `FindAll(db *gorm.DB, filters *map[string]string)`
  - `FindByID(db *gorm.DB, id *int)`
  - `Create(db *gorm.DB, model *domain.Entity)`
  - `Update(db *gorm.DB, id *int, model *domain.Entity)`
  - `Delete(db *gorm.DB, id *int, deletedByID *uint)`

### C. DTO Mapping Methods
Domain entities and slices implement mapper methods directly:
```go
func (bridgingOutlet *BridgingOutlet) ToBridgingOutletResponse() web.BridgingOutletResponse
func (cities BridgingOutlets) ToBridgingOutletResponses() []web.BridgingOutletResponse
```

## 4. Interfaces
- Interfaces are defined alongside their layer in the same package:
  - Controller interfaces in `controller/`
  - Service interfaces in `service/`
  - Repository interfaces in `repository/`
- Interfaces specify the exact contract expected by caller layers.

## 5. Structs, Pointers, and Values
- **DTOs**: Passed as pointers to methods (`request *web.BridgingOutletCreateRequest`) to avoid value duplication.
- **Domain Structs**: Instantiated as pointers (`&domain.BridgingOutlet{...}`) and returned as pointers or values matching repository contracts.
- **Optional / Nullable Fields**:
  - Nullable database columns use pointers (e.g. `DeletedByID *uint`, `OutletUpdated *bool`, `DeletedAt *time.Time`).
  - Required fields use primitive types (`string`, `float32`, `uint`).

## 6. Context & Panic Handling
- **Panic on Error Convention**: The codebase widely utilizes `helper.PanicIfError(err)` for error propagation. Errors are caught by `defer helper.CommitOrRollback(tx)` (for transactions) and `app.ErrorHandler()` (for HTTP responses).
- **Gin Context**: Received at the Controller layer (`c *gin.Context`), used for input binding and JSON rendering, but not forwarded to Services or Repositories in the current architecture.

## 7. Logging & Observability
- OpenTelemetry spans are automatically created via `otelgin.Middleware("GO-MF-MICRO-SALES")`.
- Database query logging is configured in [app/database.go](../app/database.go) with a 1-second `SlowThreshold` and `logger.Info` level.
- Standard Go `log` package is used for server startup and fatal errors.

## 8. Existing-Code Principle
When adding new functionality or modifying existing modules:
> **Follow the nearest established implementation pattern (e.g., `bridging_outlet` or `target_marketing`) rather than introducing new structural patterns or third-party abstractions.**
