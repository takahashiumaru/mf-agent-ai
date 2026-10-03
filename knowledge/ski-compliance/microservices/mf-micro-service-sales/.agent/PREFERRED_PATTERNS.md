# Preferred Engineering Patterns — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document establishes the gold standard patterns that future AI coding agents must follow when creating new modules or modifying existing ones.

---

## 1. Preferred Layered Structure

Each business module consists of 5 tightly integrated layers:
1. **Route** (`route/<entity>_route.go`): Registers endpoints on `gin.Engine` with `auth.Auth` middleware.
2. **Controller** (`controller/<entity>_controller_impl.go`): Parses request bodies, query filters, and builds `web.WebResponse`.
3. **Service** (`service/<entity>_service_impl.go`): Validates input with `Validate.Struct`, opens `service.DB.Begin()`, manages `defer helper.CommitOrRollback(tx)`, and calls repository.
4. **Repository** (`repository/<entity>_repository_impl.go`): Executes queries on passed `*gorm.DB`, calls `helper.CreateHistory`, and returns ETL callback.
5. **Model** (`model/domain/<entity>.go` & `model/web/<entity>_*.go`): Defines GORM entity with `To<Entity>Response()` receiver method and request/response DTOs.

---

## 2. Preferred Repository Implementation Example

```go
package repository

import (
    "gitlab.com/VNEU/mf-micro-service-sales/helper"
    "gitlab.com/VNEU/mf-micro-service-sales/model/domain"
    "gorm.io/gorm"
)

type ExampleRepositoryImpl struct{}

func NewExampleRepository() ExampleRepository {
    return &ExampleRepositoryImpl{}
}

func (r *ExampleRepositoryImpl) FindAll(db *gorm.DB, filters *map[string]string) domain.Examples {
    var records domain.Examples
    tx := db.Model(&domain.Example{}).Limit(500)

    err := helper.ApplyFilter(tx, filters)
    helper.PanicIfError(err)

    err = tx.Joins("Relation").Find(&records).Error
    helper.PanicIfError(err)

    return records
}

func (r *ExampleRepositoryImpl) Create(db *gorm.DB, record *domain.Example) (*domain.Example, func()) {
    err := db.Create(&record).Joins("Relation").First(&record).Error
    helper.PanicIfError(err)

    return record, func() {
        // Asynchronous ETL or background task closure
        go helper.EtlToMssql("table_name", record.IDString(), "INSERT", ...)
    }
}
```

---

## 3. Preferred Service Implementation Example

```go
package service

import (
    "gitlab.com/VNEU/mf-micro-service-sales/auth"
    "gitlab.com/VNEU/mf-micro-service-sales/helper"
    "gitlab.com/VNEU/mf-micro-service-sales/model/domain"
    "gitlab.com/VNEU/mf-micro-service-sales/model/web"
    "gitlab.com/VNEU/mf-micro-service-sales/repository"
    "github.com/go-playground/validator/v10"
    "gorm.io/gorm"
)

type ExampleServiceImpl struct {
    ExampleRepository repository.ExampleRepository
    DB                *gorm.DB
    Validate          *validator.Validate
}

func NewExampleService(repo repository.ExampleRepository, db *gorm.DB, val *validator.Validate) ExampleService {
    return &ExampleServiceImpl{
        ExampleRepository: repo,
        DB:                db,
        Validate:          val,
    }
}

func (s *ExampleServiceImpl) Create(auth *auth.AccessDetails, request *web.ExampleCreateRequest) web.ExampleResponse {
    // 1. Validate DTO
    err := s.Validate.Struct(request)
    helper.PanicIfError(err)

    // 2. Open DB Transaction
    tx := s.DB.Begin()
    err = tx.Error
    helper.PanicIfError(err)
    defer helper.CommitOrRollback(tx)

    // 3. Map to Domain Entity
    entity := &domain.Example{
        CreatedByID: auth.UserID,
        UpdatedByID: auth.UserID,
        Name:        request.Name,
    }

    // 4. Invoke Repository
    created, updateEtl := s.ExampleRepository.Create(tx, entity)

    // 5. Trigger Callback
    if updateEtl != nil {
        updateEtl()
    }

    // 6. Return Response DTO
    return created.ToExampleResponse()
}
```
