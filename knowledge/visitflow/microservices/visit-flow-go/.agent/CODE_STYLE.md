# Code Style

## Go Version

The module and build image use Go 1.23.

## Packages and Files

Package names are short singular layer names: `controller`, `service`, `repository`, `domain`, `web`, `helper`, `route`, `auth`, `app`.

Feature files use snake case and repeat the layer suffix, for example:

- `company_controller.go` and `company_controller_impl.go`
- `company_service.go` and `company_service_impl.go`
- `company_repository.go` and `company_repository_impl.go`
- `company_route.go`
- `company_create_request.go`, `company_update_request.go`, `company_response.go`

Some names contain historical spelling/casing inconsistencies (`recomendation`, `Bos`, `Id`). Preserve public names unless a task explicitly includes compatibility changes.

## Struct and Type Naming

- Interfaces: `CompanyController`, `CompanyService`, `CompanyRepository`.
- Implementations: `CompanyControllerImpl`, `CompanyServiceImpl`, `CompanyRepositoryImpl`.
- Constructors: `NewCompanyController`, `NewCompanyService`, `NewCompanyRepository`; they return the interface type.
- Requests/responses: `CompanyCreateRequest`, `CompanyUpdateRequest`, `CompanyResponse`.
- Domain collections often use named slices such as `type Companys []Company`; pluralization is inconsistent and should not be normalized incidentally.
- Query projection variants often use `Temp`, `Join`, or report-specific names and may override `TableName()`.

## Interfaces

Layer interfaces live beside their implementation in the same package, usually in the file without `_impl`. Services depend on repository interfaces and controllers depend on service interfaces. Handwritten mocks in `test/mocks_test.go` embed repository interfaces and override methods needed by tests.

Before changing an interface, search all constructors, implementations, route wiring, and mocks.

## Constructors

Constructors use explicit dependency parameters and struct literals. Repository implementations are usually stateless. Services commonly store repository interfaces, a `*gorm.DB`, and a `*validator.Validate`.

## Context Handling

The repository does not use `context.Context` as the first parameter throughout. Its established request-path convention is `*gin.Context`, generally as the last service parameter. Services pass it to `DB.WithContext(c)` and `goHelper.CreateTransaction`; the helper derives `c.Request.Context()`.

Repositories usually receive a resolver whose handles already carry context. Do not introduce `context.Background()` inside a request path. Existing background contexts in `service/visit_customer_service_impl.go` are for asynchronous Firebase sends; follow that only for detached work that cannot safely retain the request context.

## Pointer and Value Conventions

- Controllers commonly allocate request DTO pointers; a few use values and pass their address.
- Service interfaces return response DTOs by value and response slices by value.
- Repositories commonly accept pointers for models and scalar IDs, returning model pointers for mutations and values for lookups.
- Optional columns use pointers (`*uint`, `*string`, `*float64`, `*bool`, `*time.Time`) in many models and DTOs.
- Other models use `gorm.DeletedAt`, `sql.NullTime`, or plain `time.Time`; nullable handling is not uniform. Match the target model.

## Slices

Response mappers normally initialize empty slices (`[]web.XResponse{}`), so empty collections serialize as `[]`. Some query helpers return nil slices implicitly. Preserve the local API behavior.

## Errors

The dominant style is `helper.PanicIfError(err)`, recovered by global middleware. Business failures use `*exception.ErrorSendToResponse`. See `ERROR_HANDLING.md`; do not silently replace this with a new result/error architecture in one feature.

## Logging and Concurrency

- Startup uses the standard `log` package.
- Global request/error logging comes from `gitlab.com/VNEU/logger` middleware.
- Several services use `log.Printf` for failed asynchronous Firebase sends.
- Notification goroutines are fire-and-forget and log errors. They do not return errors to the request. Carefully copy captured values and do not retain request-scoped data longer than necessary.
- No `errgroup`, channels, or shared synchronization convention was found.

## Constants and Statuses

Shared visit status strings are in `helper/constant.go`, but many services also use string literals. Prefer an existing constant when it exactly matches established behavior. Configuration-driven approval transitions come from `confirmation_statuses`, not a complete in-code enum.

## Comments

Comments are mainly used to label sections, explain business checks, and mark disabled legacy code. Exported types/functions are not consistently documented. Add comments where business intent or a non-obvious query needs explanation; avoid filler comments that restate code.

## Formatting and Static Checks

- `make fmt` runs `go fmt ./...`.
- `make lint` runs `golangci-lint run ./...` using `.golangci.yml`.
- `make static` and `make critic` require separately installed tools.
- The Docker build also runs `go fmt`, `go vet`, and a race-enabled build.

When implementing new behavior, prefer the nearest established implementation over inventing a new pattern.
