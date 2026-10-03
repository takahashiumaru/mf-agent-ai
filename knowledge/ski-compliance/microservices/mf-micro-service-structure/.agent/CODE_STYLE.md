# Go Code Style Guide — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document defines the established coding conventions observed across `mf-micro-service-structure`.

## Package & File Organization

- **Package Naming**: Single, lowercase words matching directory names (`controller`, `service`, `repository`, `model`, `domain`, `web`, `route`, `helper`, `auth`, `exception`, `app`, `configuration`).
- **File Naming**: Snake_case with explicit architectural role suffixes:
  - Interface definition: `<entity>_controller.go`, `<entity>_service.go`, `<entity>_repository.go`
  - Implementation: `<entity>_controller_impl.go`, `<entity>_service_impl.go`, `<entity>_repository_impl.go`
  - Request/Response models: `<entity>_create_request.go`, `<entity>_update_request.go`, `<entity>_response.go`
  - Domain entities: `<entity>.go`
  - Routes: `<entity>_route.go`

## Interface and Struct Conventions

- **Separation of Interface and Implementation**:
  ```go
  // repository/office_repository.go
  type OfficeRepository interface {
      FindAll(db *gorm.DB, filters *map[string]string) domain.Offices
      FindByID(db *gorm.DB, id *string) domain.Office
      Create(db *gorm.DB, office *domain.Office) *domain.Office
      Update(db *gorm.DB, office *domain.Office) *domain.Office
      Delete(db *gorm.DB, id *string, deletedByID *uint)
  }

  // repository/office_repository_impl.go
  type OfficeRepositoryImpl struct {}
  func NewOfficeRepository() OfficeRepository {
      return &OfficeRepositoryImpl{}
  }
  ```
- **Constructor Injection**: Use `New<Entity><Role>(...)` constructor functions returning the interface type.
- **Plural Types for Slices**: Domain models define slice type aliases for clean method attachments:
  ```go
  type Offices []Office
  func (offices Offices) ToOfficeResponses() []web.OfficeResponse { ... }
  ```

## Error Handling & Panic Convention

- **Control Flow by Panic**: In services and repositories, errors are not propagated as returned `error` values in method signatures; instead, they call `helper.PanicIfError(err)`.
- **Custom Error Types**:
  - `exception.ErrUnauthorized` (`"Unauthorized"`)
  - `exception.ErrPermissionDenied` (`"Permission Denied"`)
  - `exception.ErrRefreshTokenExpired` (`"Refresh token is expired"`)
  - `exception.ErrorSendToResponse` (custom user-facing error message returning HTTP 400)
- **Zero In-Layer Logging**: Do not pollute repository or service methods with ad-hoc `fmt.Println` or duplicate log statements. Errors are caught and logged at the router recovery boundary.

## DTO & Model Mapping

- **Explicit Mapping Methods**: Domain models implement value receiver methods `To<Entity>Response()` and slice helpers `To<Entity>Responses()`.
- **Null Value Fallback**: Use `IfNullString(str)` helper to guarantee empty strings become `"-"` or valid defaults where required by client contracts.

## Struct Tags & Formats

- **GORM Tags**: Explicit size, primary key, indexes, and constraints:
  ```go
  ID     string `gorm:"size:20;primaryKey;not null"`
  Period string `gorm:"size:6;not null;primaryKey;uniqueIndex:idx_marketing_structure"`
  ```
- **JSON Tags**: CamelCase in `model/web` structs:
  ```go
  type WebResponse struct {
      Success bool        `json:"success"`
      Message string      `json:"message"`
      Data    interface{} `json:"data,omitempty"`
  }
  ```
- **Validation Tags**: Go Playground validation annotations (`validate:"required,max=50,period_month"`).
