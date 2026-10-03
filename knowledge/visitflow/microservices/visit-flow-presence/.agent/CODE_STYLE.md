# Code Style

## Go Version

`go.mod` declares Go 1.23. The Docker image is also `golang:1.23`.

## Package and File Naming

Packages are short singular layer names: `controller`, `service`, `repository`, `domain`, `web`, `helper`, `auth`, `exception`, `route`, `app`.

Files use snake_case and usually include the layer: `office_service.go`, `office_service_impl.go`, `office_repository.go`, `office_repository_impl.go`. Controllers and services split the interface from implementation. Keep the existing misspelling `qouta` where it is part of public/internal identifiers.

## Struct and Interface Naming

- Interfaces: `OfficeController`, `OfficeService`, `OfficeRepository`.
- Implementations: `OfficeControllerImpl`, `OfficeServiceImpl`, `OfficeRepositoryImpl`.
- Constructors: `NewOfficeController`, `NewOfficeService`, `NewOfficeRepository`; constructors return the interface in most modules.
- DTOs: `OfficeCreateRequest`, `OfficeUpdateRequest`, `OfficeResponse`.
- Domain collections: named plural slices such as `type Offices []Office` and response converters such as `ToOfficeResponses`.
- No generics are used.

Interfaces are defined in the same layer package as their implementation, generally in the file without `_impl`.

## Context Handling

Controller and service APIs normally take `*gin.Context`, generally as the last parameter. Services bind GORM using `service.DB.WithContext(c)` or use `goHelper.CreateTransaction`, which uses `c.Request.Context()`. Repository methods generally receive a context-bound `*gorm.DB` instead of a separate `context.Context`.

Notification helpers use standard `context.Context`. `helper.RunAsyncNotification` intentionally creates a detached `context.Background()` child with a 15-second timeout so work can continue after the request returns. Do not introduce `context.Background()` into synchronous request/database flows.

## Pointer and Value Conventions

- Constructors return interface values backed by pointers to implementations.
- Create/update DTOs are passed as pointers.
- Services often return web response values or slices, not pointers.
- Repository creates/updates commonly accept and return pointers to domain models; find methods vary between values and slices.
- Optional database/API fields use pointers (`*time.Time`, `*string`, `*float64`, `*bool`, `*uint`). No `sql.Null*` convention was found.
- IDs are inconsistent by domain: offices use string IDs through `domain.Model`; most other modules use `uint`/GORM IDs. Copy the affected domain.

## Slice Convention

Response conversion methods initialize empty non-nil slices (`responses := []web.XResponse{}`), so list responses normally serialize as `[]` rather than `null`. Preserve this in new converters.

## Error Style

Most synchronous errors are sent to `helper.PanicIfError`, recovered globally, and mapped in `exception/`. Business errors use `*exception.ErrorSendToResponse`. See `ERROR_HANDLING.md`.

## Logging and Concurrency

`helper/logger.go` writes structured JSON entries. Request and explicit log writes use goroutines. Notification side effects use `helper.RunAsyncNotification` in newer leave paths; attendance-correction and meeting code also contain direct `go func` patterns. Async functions recover/log their own errors in the helper; direct goroutines log returned notification errors. Do not let async panics escape silently.

## Constants and Statuses

Constants are plain typed/untyped `const` declarations (`auth.RoleAdministrator`, `helper.PresenceTypeIn/Out`). Many workflow statuses remain string literals in services. When changing status behavior, search all comparisons, filters, external approval calls, and tests; do not introduce a new spelling in isolation.

## Comments

Comments are used for exported DTO/domain descriptions, table-name overrides, and complex workflow sections. Existing comments are uneven; add comments where business/SQL behavior would otherwise be unclear, not to narrate obvious statements.

## Formatting and Static Checks

- Format: `go fmt ./...` through `make fmt`.
- Lint: `golangci-lint run ./...` through `make lint`, configured in `.golangci.yml`.
- Additional Make targets: `staticcheck` and `gocritic`.
- Imports are expected to be gofmt/goimports-compatible, although grouping is not fully consistent in existing files.

## Existing-Code Principle

When implementing new behavior, prefer the nearest established implementation over inventing a new pattern. Confirm a convention in more than one module when it affects shared behavior.
