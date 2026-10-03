# Go Code Style

## Go Version

`go.mod` declares Go 1.23. `Dockerfile` also uses `golang:1.23`.

## Package Naming

Packages are short lowercase nouns matching directories: `auth`, `config`, `configuration`, `controller`, `exception`, `helper`, `repository`, `route`, and `service`. Model packages are `domain` and `web`.

The private helper module is commonly imported as `goHelper` to distinguish it from the repository-local `helper` package.

## File Naming

- Interfaces: `<subject>_controller.go`, `<subject>_service.go`, `<subject>_repository.go`.
- Implementations: the same name with `_impl.go`.
- Routes: `<subject>_route.go`, except `route/file.go`.
- Domain and DTO files use snake_case subjects such as `role_menu_permission.go` and `users_update_request.go`.

## Struct Naming

- Implementations use `RoleControllerImpl`, `UserServiceImpl`, and `UserRepositoryImpl`.
- Request/response DTOs use `RoleCreateRequest`, `UserUpdateRequest`, `UserResponse`, and `TokenResponse`.
- Persistence/domain structs use `User`, `Role`, `UserRole`, `RoleMenuPermission`, and `Session`.
- Collection aliases use plural names such as `Users`, `Roles`, and `UserRoles`.
- Shared JSON output uses `web.WebResponse`.

## Interfaces

Interfaces live beside their concrete implementations, grouped by layer:

- `controller/*_controller.go`
- `service/*_service.go`
- `repository/*_repository.go`

Services depend on repository interfaces and controllers depend on service interfaces. Test mocks manually implement these interfaces with `testify/mock`.

## Constructors

Constructors use `New<Type>` and usually return the layer interface:

```go
func NewRoleRepository() RoleRepository
func NewRoleService(repo repository.RoleRepository, db *gorm.DB, validate *validator.Validate) RoleService
func NewRoleController(service service.RoleService) RoleController
```

Wiring belongs in `route/`.

## `context.Context`

The repository does not use explicit `context.Context` parameters. Request-aware services accept `*gin.Context` in some interfaces. The go-helper resolver calls `db.WithContext(c.Request.Context())`; plain user/session transactions generally do not.

Background contexts are used only for asynchronous Firebase initialization/sends in `helper/notification_helper.go`, with a 10-second timeout on sends. Do not replace a request context with `context.Background()` in a request-bound flow.

## Pointer vs Value Convention

- Services and repositories are normally pointer receivers.
- Request DTOs are passed as pointers.
- IDs and filter maps are frequently passed as pointers.
- Repository create/update methods generally accept and return pointers to domain structs.
- Lookup methods inconsistently return values (`domain.User`, `domain.Role`) or pointers (`FindByDeviceIDAndUserID`). Follow the interface being changed.
- Optional database fields use pointers in several structs (`TokenFirebase`, `Nip`, audit actor IDs); timestamps use both `gorm.DeletedAt` and `*time.Time` depending on the model.

## Slice Convention

Conversion methods initialize empty response slices (`[]web.X{}`), so successful empty collection responses normally serialize as `[]`, not `null`. Some repository local variables are declared nil before `Find`; do not infer a universal nil-slice rule beyond response mapping.

## Error Style

Most controller/service/repository flows panic through `helper.PanicIfError`, and middleware recovers the panic. A small number of repository and JWT functions return errors for branching. See `ERROR_HANDLING.md`.

## Logging

Logging is not unified:

- `log` is used at startup and for notification/device events.
- GORM has an Info-level logger configured in `config/db.go` with a one-second slow threshold.
- KrakenD uses its own logger.
- Some implementations contain `fmt.Println` diagnostics.

Follow the nearest code, avoid logging credentials/tokens/passwords, and avoid adding duplicate logs for errors that middleware will handle.

## Constants and Enums

- The only role constant is `auth.RoleAdministrator`.
- No general enum/status pattern is established in local models.
- Gateway endpoint methods and paths are data in `configuration.json`.

## Comments

Comments are mainly used for high-level operation phases, security/token behavior, and non-obvious SQL. Exported identifiers are not consistently documented. Add comments where behavior, transaction boundaries, or security effects are non-obvious; do not add boilerplate comments that merely repeat names.

## Formatting and Static Analysis

- `make fmt` runs `go fmt ./...`.
- `make lint` runs `golangci-lint run ./...` using `.golangci.yml`.
- `make static` runs `staticcheck ./...`.
- `make critic` runs `gocritic check ./...`.

The Makefile expects these tools to be installed externally. No `goimports` command or tool bootstrap script is defined, although golangci-lint enables its `goimports` linter.

## Existing-Code Principle

When implementing new behavior, prefer the nearest sound/PREFERRED implementation over inventing a new pattern. Classify nearby code before copying it: preserve public compatibility for focused work, but do not reproduce a documented LEGACY or DANGEROUS mechanism in new code. Load `skills/go-quality/SKILL.md` for the decision rules.
