# .agent/CODE_STYLE.md — Go Idioms, Conventions & Code Style

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

This document establishes the verified code style, naming patterns, and Go idioms used throughout `mf-micro-service-discount-proposal`.

---

## 1. Package & File Conventions

- **Package Names**: Short, lower-case, single-word names matching the directory:
  - `controller`, `service`, `repository`, `domain`, `web`, `helper`, `auth`, `exception`, `configuration`, `app`, `route`.
- **File Names**: `snake_case.go`.
  - Interfaces: `<entity>_repository.go`, `<entity>_service.go`, `<entity>_controller.go`.
  - Implementations: `<entity>_repository_impl.go`, `<entity>_service_impl.go`, `<entity>_controller_impl.go`.
  - Routes: `<entity>_route.go` or `<entity>.go`.
  - DTOs: `<entity>_create_request.go`, `<entity>_update_request.go`, `<entity>_response.go`.

---

## 2. Naming & Struct Patterns

### Interfaces & Structs
- Interfaces use PascalCase without Hungarian prefixes:
  - `DiscountProposalRepository` (`repository/discount_proposal_repository.go`)
  - `DiscountProposalService` (`service/discount_proposal_service.go`)
  - `DiscountProposalController` (`controller/discount_proposal_controller.go`)
- Concrete implementation structs append `Impl`:
  - `DiscountProposalRepositoryImpl` (`repository/discount_proposal_repository_impl.go`)
  - `DiscountProposalServiceImpl` (`service/discount_proposal_service_impl.go`)
  - `DiscountProposalControllerImpl` (`controller/discount_proposal_controller_impl.go`)

### Constructors
- Standard constructor functions returning the interface type:
  - `func NewDiscountProposalRepository() DiscountProposalRepository`
  - `func NewDiscountProposalService(...) DiscountProposalService`
  - `func NewDiscountProposalController(...) DiscountProposalController`

### Slice Aliases
- Domain entities declare typed slice aliases in the domain file:
  - `type DiscountProposals []DiscountProposal` (`model/domain/discount_proposal.go`)
  - `type CreditNotes []CreditNote` (`model/domain/credit_note.go`)
  - `type CustomerBalances []CustomerBalance` (`model/domain/customer_balance.go`)

### Response Mappers
- Domain entities implement instance and slice conversion methods to map domain models to web response DTOs:
  ```go
  // Single instance mapper
  func (discountProposal *DiscountProposal) ToDiscountProposalResponse() web.DiscountProposalResponse {
      return web.DiscountProposalResponse{
          ID:        discountProposal.ID,
          Period:    IfNullString(discountProposal.Period),
          CreatedAt: discountProposal.CreatedAt,
          // ...
      }
  }

  // Slice mapper
  func (discountProposals DiscountProposals) ToDiscountProposalResponses() []web.DiscountProposalResponse {
      discountProposalResponses := []web.DiscountProposalResponse{}
      for _, discountProposal := range discountProposals {
          discountProposalResponses = append(discountProposalResponses, discountProposal.ToDiscountProposalResponse())
      }
      return discountProposalResponses
  }
  ```

---

## 3. Pointer & Slice Semantics

- **Entity & DTO Pointers**:
  - Request DTOs and entity parameters are passed by pointer: `*web.DiscountProposalCreateRequest`, `*domain.DiscountProposal`.
  - Slices of entities are passed by value: `domain.DiscountProposals`, `[]web.DiscountProposalResponse`.
- **Nullable / Optional Fields**:
  - Pointer types are used for nullable DB columns: `*float64`, `*bool`, `*string`, `*uint`, `*time.Time`.
  - Example in `model/domain/discount_proposal.go`:
    ```go
    AmountActual     *float64   `gorm:""`
    AmountEstimation *float64   `gorm:"default:0"`
    PrintDiscountProposal *bool `gorm:""`
    DistributorID    *string    `gorm:"size:10"`
    ```

---

## 4. Error Handling Style

- **Panic-Based Flow Control**:
  The codebase uses standard panics caught at the Gin middleware boundary.
  - Check error immediately: `helper.PanicIfError(err)` (`helper/error.go`).
  - Return business validation error: `panic(&exception.ErrorSendToResponse{Err: "message"})`.
  - Sentinel errors: `exception.ErrUnauthorized`, `exception.ErrPermissionDenied`, `exception.ErrRecordNotFound`.
- **Transaction Rollback on Error**:
  `defer helper.CommitOrRollback(tx)` catches the panic, calls `tx.Rollback()`, and re-panics so the Gin `app.ErrorHandler()` can format the HTTP response.

---

## 5. Context & User Authorization

- Gin's `*gin.Context` is used only in the `controller/` and `app/` layers.
- In `service/` and `repository/`, the user context is passed explicitly as `auth *auth.AccessDetails`:
  ```go
  type AccessDetails struct {
      UserID   uint
      Role     string
      Level    string
      Nip      string
      Name     string
      MainID   uint
      MainRole string
  }
  ```
- Do not pass `*gin.Context` into services or repositories.

---

## 6. Formatting & Tooling Rules

- Always format code using `go fmt ./...`.
- Ensure `go vet ./...` passes cleanly without warnings.
- Tag formats:
  - JSON tags: `json:"field_name"`
  - GORM tags: `gorm:"size:20;primarykey;column:id"`
  - Validator tags: `validate:"required,period_month"`
