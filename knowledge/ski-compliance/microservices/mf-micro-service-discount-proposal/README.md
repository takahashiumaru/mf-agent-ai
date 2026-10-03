# MF Micro Service — Discount Proposal (Usulan Diskon)

[![Go Version](https://img.shields.io/badge/Go-1.23-00ADD8?style=flat&logo=go)](https://go.dev/)
[![Framework](https://img.shields.io/badge/Framework-Gin-008ECF?style=flat&logo=gin)](https://gin-gonic.com/)
[![ORM](https://img.shields.io/badge/ORM-GORM-7952B3?style=flat)](https://gorm.io/)
[![Database](https://img.shields.io/badge/Database-MySQL%205.7%2F8.0-4479A1?style=flat&logo=mysql)](https://www.mysql.com/)
[![Coverage](https://img.shields.io/badge/Coverage-93.2%25-brightgreen?style=flat&logo=go)](coverage.out)
[![Observability](https://img.shields.io/badge/Tracing-OpenTelemetry-F5A800?style=flat&logo=opentelemetry)](https://opentelemetry.io/)
[![Deployment](https://img.shields.io/badge/Deployment-Docker-2496ED?style=flat&logo=docker)](https://www.docker.com/)

`mf-micro-service-discount-proposal` is a mission-critical Golang backend microservice within the **SKI Compliance (Metiska Farma)** pharmaceutical distribution and commercial operations ecosystem. It governs the complete lifecycle of discount proposals (*usulan diskon*), multi-tiered approval hierarchies, promotional budget estimations, credit notes, payment disbursements to recipients, customer ledger balances, multi-period amortizations, and integration pipelines.

---

## Table of Contents

- [Overview & Core Capabilities](#overview--core-capabilities)
- [Architecture & Tech Stack](#architecture--tech-stack)
- [Directory Structure](#directory-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Configuration (`.env`)](#configuration-env)
  - [Running the Service](#running-the-service)
- [Test Coverage & Quality Gates](#test-coverage--quality-gates)
- [Complete API Endpoints Reference](#complete-api-endpoints-reference)
  - [1. Discount Proposal (Core CRUD, Reports & Calculator)](#1-discount-proposal-core-crud-reports--calculator)
  - [2. Multi-Level Approval & Confirmations](#2-multi-level-approval--confirmations)
  - [3. Confirmation Status Master](#3-confirmation-status-master)
  - [4. Estimations & Product Discount Allocations](#4-estimations--product-discount-allocations)
  - [5. On-Factur Discount Estimations](#5-on-factur-discount-estimations)
  - [6. Payment, Disbursement & Transfer Proofs](#6-payment-disbursement--transfer-proofs)
  - [7. Split Payment Management](#7-split-payment-management)
  - [8. Proposal Recipients & Realization](#8-proposal-recipients--realization)
  - [9. Returns & Return Confirmations](#9-returns--return-confirmations)
  - [10. Credit Notes & Sales Matching](#10-credit-notes--sales-matching)
  - [11. Credit Note Amortization](#11-credit-note-amortization)
  - [12. CQRS Credit Note Summary Post](#12-cqrs-credit-note-summary-post)
  - [13. Customer Balance & Running Ledger](#13-customer-balance--running-ledger)
  - [14. Discount Limits by Customer](#14-discount-limits-by-customer)
  - [15. Discount Limits by General Trade (GT)](#15-discount-limits-by-general-trade-gt)
  - [16. Discount Limits by Outlet & Product](#16-discount-limits-by-outlet--product)
  - [17. Discount Limit Details & Automated Analysis](#17-discount-limit-details--automated-analysis)
  - [18. Proposal Document Status Tracking](#18-proposal-document-status-tracking)
  - [19. Proposal PIC Management](#19-proposal-pic-management)
  - [20. Promotional Events](#20-promotional-events)
  - [21. Microservice Configuration](#21-microservice-configuration)
  - [22. Manual Processing & Stored Procedures](#22-manual-processing--stored-procedures)
  - [23. Call Logging](#23-call-logging)
  - [24. Warehouse Pelunasan Integration](#24-warehouse-pelunasan-integration)
  - [25. Warehouse SKI Integration](#25-warehouse-ski-integration)
- [Docker & Deployment](#docker--deployment)
- [Core Engineering Rules](#core-engineering-rules)

---

## Overview & Core Capabilities

1. **Discount Proposal Lifecycle**:
   - End-to-end proposal creation, validation, budget checking, and tracking across promotional schemes (`SKI1`, `SKI2`, `DPL`, `DPF`, `DPL2`).
   - Deep integration with marketing territory structures, area branches, and marketing positions.
2. **Hierarchical Multi-Level Approval**:
   - Configurable 6-level approval workflow with escalation and appeal routing.
   - Comprehensive audit trails tracking each status transition and reviewer note.
3. **Budget Estimation & Dynamic Matrix**:
   - Product allocations, discount percentage matrix (Principal vs. Distributor, On-Invoice vs. Off-Invoice).
   - Validation against customer, general trade (GT), and outlet-level discount limits.
   - Integrated SPC calculation engine for discount and sales estimations (`kalkulator_spc.xlsx`).
4. **Disbursement, Recipients & Tax Deductions**:
   - Recipient bank account routing, disbursement verification, and multi-file transfer proof uploads.
   - Automated computation of withholding tax deductions (NPWP, PPN/PPH) and company subsidy flags.
5. **Credit Notes & CQRS Summaries**:
   - Promotional deductions and invoice credits per customer, outlet, product, and period (`credit_notes`, `cqrs_credit_notes`).
6. **Customer Balance Ledger & Amortization**:
   - Monthly beginning and ending balance tracking, return confirmations, and balance mutations.
   - Multi-period promotional amortization tracking (`credit_note_amortizations`).
7. **Legacy Integration & ETL Pipeline**:
   - Asynchronous data synchronization (`helper.EtlToMssql`) to legacy MSSQL and FoxPro systems for backwards compatibility.

---

## Architecture & Tech Stack

- **Language**: Go 1.23
- **Web Framework**: [Gin Web Framework](https://github.com/gin-gonic/gin) v1.9.1
- **ORM**: [GORM](https://gorm.io/) v1.25.2 with MySQL Driver v1.5.1
- **Database Engine**: MySQL 5.7+ / 8.0
- **Validation**: [Go Playground Validator](https://github.com/go-playground/validator) v10.14.1
- **Configuration**: [Viper](https://github.com/spf13/viper) v1.16.0
- **Authentication**: JWT (`jwt-go` v3.2.0)
- **Observability**: OpenTelemetry Go SDK v1.18.0 with OTLP gRPC trace exporter
- **Excel Processing**: [excelize](https://github.com/xuri/excelize) v2.7.1

### Request Flow
```text
HTTP Request
  └─► Gin Engine (`app/router.go`)
        ├─► Middleware: OpenTelemetry Tracing (`otelgin.Middleware`)
        ├─► Middleware: Central Panic Error Handler (`app.ErrorHandler()`)
        └─► Route Layer (`route/*.go`)
              └─► Auth Middleware (`auth.Auth`) -> injects `*auth.AccessDetails`
                    └─► Controller Layer (`controller/*_controller_impl.go`)
                          └─► Service Layer (`service/*_service_impl.go`)
                                ├─► Transaction: `tx := DB.Begin()` -> `defer helper.CommitOrRollback(tx)`
                                ├─► Validation: `Validate.Struct()` & Domain Business Rules
                                └─► Repository Layer (`repository/*_repository_impl.go`)
                                      ├─► GORM / Raw SQL Queries
                                      ├─► Audit Trail: `helper.CreateHistory()`
                                      └─► Async ETL: `go helper.EtlToMssql()`
```

---

## Directory Structure

```text
.
├── main.go                     # Application entry point & dependency wiring
├── app/                        # Database bootstrap & Gin router configuration
│   ├── database.go             # GORM connection, connection pool, and logger
│   ├── router.go               # Gin engine, OpenTelemetry, and route registration
│   └── database/               # SQL migration scripts
├── auth/                       # JWT token extraction, verification, & context models
├── configuration/              # Viper configuration loader & .env schema
├── controller/                 # HTTP handlers (Gin parameter extraction & response mapping)
├── exception/                  # Error types & centralized panic-recovery error handler
├── helper/                     # Shared utilities (transactions, audit history, ETL, filters, custom validators)
├── model/
│   ├── domain/                 # GORM persistence entities & response mappers
│   └── web/                    # Request/Response DTOs & WebResponse envelope
├── repository/                 # Data access layer (GORM queries & raw SQL)
├── route/                      # Route registration & manual dependency injection
├── service/                    # Business logic, validations, & transaction management
└── test/                       # Unit tests & isolated test fixtures
```

---

## Getting Started

### Prerequisites

- **Go**: 1.23 or higher
- **MySQL**: 5.7 or 8.0
- **Make**: (Optional, for Makefile shortcuts)
- **Docker & Docker Compose**: (Optional, for containerized execution)

### Configuration (`.env`)

Create `./configuration/.env` (or configure corresponding environment variables):

```env
# Application Server
PORT=8089

# MySQL Database
HOST_DB=127.0.0.1
PORT_DB=3306
USER_DB=root
PASSWORD_DB=secret
DATABASE_DB=ski_discount_proposal

# Authentication Secrets
ACCESS_SECRET=your_jwt_access_secret_key_here
REFRESH_SECRET=your_jwt_refresh_secret_key_here

# External Integrations
SYNC_URL=http://localhost:8080/sync
NOCODE_URL=http://localhost:8081/nocode
API_HOST=http://localhost:8082
EMAIL_MPI=mpi@metiska.co.id
PASSWORD_MPI=secret

# Observability (OpenTelemetry)
OTEL_EXPORTER_OTLP_ENDPOINT=localhost:4317
INSECURE_MODE=true
```

### Running the Service

```bash
# Run directly with Go
go run main.go

# Or using Makefile
make run
```

---

## Test Coverage & Quality Gates

Total Statement Coverage: **93.2%**

The project enforces automated test coverage gates. Tests run in an isolated environment using in-memory mocks without modifying or deleting project files.

```bash
# Run all unit tests
make test

# Generate coverage report (automatically synchronizes README badge)
make cover

# Enforce statement coverage threshold (>= 70%)
make check-cov

# Run full CI quality check (staticcheck, gocritic, and coverage gate)
make check-all

# Run static analysis
make st

# Run gocritic analysis
make cr

# Run golangci-lint
make lint

# Run code formatting
make fmt
```

---

## Complete API Endpoints Reference

All endpoints return JSON responses wrapped in the standard response envelope:
```json
{
  "success": true,
  "message": "Record found",
  "data": { ... }
}
```

Below is the complete, exhaustive catalog of all **167 endpoints** registered in this microservice across all 25 route modules.

### 1. Discount Proposal (Core CRUD, Reports & Calculator)
*Defined in `route/discount_proposal_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals` | JWT Required | List all discount proposals with query filters and pagination |
| `GET` | `/discount-proposals-active` | JWT Required | List active discount proposals within active periods |
| `GET` | `/discount-proposals/:id` | JWT Required | Retrieve discount proposal details by ID |
| `GET` | `/discount-proposals/:id/distributor` | JWT Required | Get distributor data for a discount proposal |
| `GET` | `/discount-proposals/:id/distributor-active/:distributorID` | JWT Required | Get active distributor details for a discount proposal |
| `GET` | `/discount-proposals/report/promotion/cpk` | JWT Required | Generate CPK promotional proposal report |
| `GET` | `/discount-proposals/report/dldf/cpk/details` | JWT Required | Generate DLDF CPK promotion detail report |
| `GET` | `/discount-proposals/no-bridging-promotion` | JWT Required | List non-bridging promotional proposals |
| `GET` | `/discount-proposals/report/dldf/cpk` | JWT Required | Generate DLDF CPK report summary |
| `GET` | `/discount-proposals/report/dldf/summary-qty` | JWT Required | Generate DLDF quantity summary report |
| `GET` | `/discount-proposals/over-budget` | Public | Check proposals exceeding allocated budget threshold |
| `GET` | `/discount-proposals/calculator-spc/:period/:customerID/:userID` | Public | Run SPC calculation engine for customer and period |
| `GET` | `/discount-proposals/promotion-details` | JWT Required | Retrieve promotion line item details |
| `POST` | `/discount-proposals` | JWT Required | Create a new discount proposal |
| `POST` | `/discount-proposals/:id/terminated` | JWT Required | Terminate an active discount proposal |
| `PUT` | `/discount-proposals/:id` | JWT Required | Update discount proposal header information |
| `DELETE` | `/discount-proposals/:id` | JWT Required | Soft delete a discount proposal |
| `PUT` | `/discount-proposals/print/:id` | JWT Required | Mark proposal document as printed / update print count |
| `PUT` | `/discount-proposals/guarantee-by/:id` | JWT Required | Update guarantee approval flags for a proposal |
| `PUT` | `/discount-proposals/marketing-structure` | JWT Required | Update marketing structure assignments on proposals |
| `PUT` | `/discount-proposals/reset-distributor-code/:id` | JWT Required | Reset distributor code association for a proposal |
| `PUT` | `/discount-proposals/cut-off/:id` | JWT Required | Apply cut-off status to a discount proposal |
| `POST` | `/incentive/process-sp/:id` | Public | Trigger incentive calculation process |
| `GET` | `/analysis-ski/calculation/:period/:customerID/:structureID` | JWT Required | Calculate SKI analysis numbers |
| `GET` | `/analysis-ski/calculator/:period/:customerID` | JWT Required | Get SKI calculator analysis results (JSON) |
| `GET` | `/analysis-ski/calculator/:period/:customerID/excel` | JWT Required | Export SKI analysis calculation as Excel workbook |

---

### 2. Multi-Level Approval & Confirmations
*Defined in `route/discount_proposal_confirmation_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/confirmations` | JWT Required | List proposals awaiting confirmation/approval |
| `POST` | `/discount-proposals/confirmations/:confirmation` | JWT Required | Create/process confirmation approval step |
| `PUT` | `/discount-proposals/:id/:marketingStructureID/:appeal` | Public | Update escalation approval / appeal state |
| `POST` | `/discount-proposals/confirmations/:confirmation/approve` | JWT Required | Batch approve confirmation steps |

---

### 3. Confirmation Status Master
*Defined in `route/discount_proposal_confirmation_status_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/confirmation-statuses` | JWT Required | List all confirmation status master records |
| `GET` | `/discount-proposals/confirmation-statuses/:id` | JWT Required | Get confirmation status by ID |
| `POST` | `/discount-proposals/confirmation-statuses` | JWT Required | Create a new confirmation status record |
| `PUT` | `/discount-proposals/confirmation-statuses/:id/:type` | JWT Required | Update confirmation status record |
| `DELETE` | `/discount-proposals/confirmation-statuses/:id/:type` | JWT Required | Delete confirmation status record |

---

### 4. Estimations & Product Discount Allocations
*Defined in `route/discount_proposal_estimation_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/estimations` | JWT Required | List product estimation line items |
| `GET` | `/discount-proposals/estimations/:id` | JWT Required | Get estimation detail by ID |
| `GET` | `/discount-proposals/estimations/calculate/:discountProposalID` | JWT Required | Calculate proposal discount estimation values |
| `GET` | `/discount-proposals/estimations/:id/non-terminated/:discountNew` | JWT Required | Calculate non-terminated estimation differences |
| `GET` | `/discount-proposals/estimations/credit-notes/percentage/by-customer` | Public | Calculate estimation credit note percentage by customer |
| `POST` | `/discount-proposals/estimations` | JWT Required | Create product estimation line item |
| `PUT` | `/discount-proposals/estimations/:id` | JWT Required | Update product estimation line item |
| `PUT` | `/discount-proposals/estimations/active/by-outlet/:discountProposalID/:outletID` | JWT Required | Update estimation active state by outlet |
| `DELETE` | `/discount-proposals/estimations/:id` | JWT Required | Delete product estimation line item |

---

### 5. On-Factur Discount Estimations
*Defined in `route/discount_proposal_on_factur_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/on-facturs` | JWT Required | List on-factur discount estimation records |
| `POST` | `/discount-proposals/on-facturs` | JWT Required | Create on-factur discount estimation record |
| `DELETE` | `/discount-proposals/on-facturs/:discountProposalID/:outletID/:productID/:productMaxID` | JWT Required | Delete on-factur discount estimation record |

---

### 6. Payment, Disbursement & Transfer Proofs
*Defined in `route/discount_proposal_payment_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/payments` | JWT Required | List payment disbursement records |
| `GET` | `/discount-proposals/payments/summary/:period` | JWT Required | Get monthly payment summary by period |
| `GET` | `/discount-proposals/payments/period-summary/:periodStart/:periodEnd` | JWT Required | Get payment summary across period range |
| `GET` | `/discount-proposals/payments/boss` | JWT Required | Retrieve boss authorization payment details |
| `GET` | `/discount-proposals/payments/no-transfer/:noTransfer` | JWT Required | Find payment record by transfer number |
| `GET` | `/discount-proposals/payments/report-transfer` | JWT Required | Generate disbursement transfer report |
| `GET` | `/discount-proposals/payments/calculator/:period/:customerID/:structureID` | Public | Calculate customer payment balance |
| `GET` | `/discount-proposals/payments/group-by/:rangkuman` | JWT Required | Group payments by summary (rangkuman) ID |
| `GET` | `/discount-proposals/payments/psi` | Public | List PSI payment integration records |
| `POST` | `/discount-proposals/payments` | JWT Required | Create payment disbursement record |
| `POST` | `/discount-proposals/payments/untransferred-memo/by-email` | Public | Send untransferred memo notification email |
| `POST` | `/discount-proposals/payments/transferred-memo/by-email` | Public | Send transferred memo notification email |
| `PUT` | `/discount-proposals/payments/psi/:noTransfer` | Public | Update PSI transfer status |
| `PUT` | `/discount-proposals/payments/print/rangkuman/:rangkuman` | JWT Required | Update print state for payment summary |
| `PUT` | `/discount-proposals/payments/print/memo/:memo` | JWT Required | Update print state for payment memo |
| `PUT` | `/discount-proposals/payments/print/transfer/:noTransfer` | JWT Required | Update print state for transfer voucher |
| `PUT` | `/discount-proposals/payments/update/memo` | JWT Required | Update payment memo details |
| `PUT` | `/discount-proposals/payments/update/ps` | JWT Required | Update payment schedule (PS) |
| `PUT` | `/discount-proposals/payments/update/transfer` | JWT Required | Update transfer execution status |
| `PUT` | `/discount-proposals/payments/update/transfer-array` | JWT Required | Batch update transfer execution statuses |
| `PUT` | `/discount-proposals/payments/update/canceled/rangkuman` | JWT Required | Cancel payment summary (rangkuman) |
| `PUT` | `/discount-proposals/payments/update/canceled/memo` | JWT Required | Cancel payment memo |
| `PUT` | `/discount-proposals/payments/update/canceled/transfer` | JWT Required | Cancel transfer record |
| `PUT` | `/discount-proposals/payments/withholding-tax-proof/:id` | JWT Required | Update withholding tax proof (bukti potong pajak) |
| `PUT` | `/discount-proposals/payments/update/transfer-date/:period/:accountID/:memoNo/:customerID` | JWT Required | Update disbursement transfer date |
| `PUT` | `/discount-proposals/payments/receipt/memo` | JWT Required | Record memo receipt confirmation |
| `PUT` | `/discount-proposals/payments/approve/transfer-date` | JWT Required | Approve transfer date adjustment |
| `PUT` | `/discount-proposals/payments/update-account-by/:memoNo` | JWT Required | Update recipient bank account for memo |
| `PUT` | `/discount-proposals/payments/update-bilyet-giro` | JWT Required | Update bilyet giro disbursement data |

---

### 7. Split Payment Management
*Defined in `route/discount_proposal_split_payment_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/split/payments` | JWT Required | List split payment distribution records |
| `GET` | `/discount-proposals/split/payments/bs` | JWT Required | List split payment bank statement (BS) allocations |

---

### 8. Proposal Recipients & Realization
*Defined in `route/discount_proposal_recipient_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/recipients` | JWT Required | List proposal recipients and disbursement details |
| `GET` | `/discount-proposals/recipients/:id` | JWT Required | Get recipient detail by ID |
| `GET` | `/discount-proposals/recipients/payments` | JWT Required | List payment recipient allocations |
| `GET` | `/discount-proposals/recipients/realization` | JWT Required | List realization records for recipients |
| `GET` | `/discount-proposals/recipients/realization/completion` | Public | Check realization completion status |
| `POST` | `/discount-proposals/recipients` | JWT Required | Add recipient to discount proposal |
| `POST` | `/discount-proposals/recipients/array` | JWT Required | Batch add recipients to discount proposal |
| `POST` | `/discount-proposals/recipients/value-recalculations` | JWT Required | Recalculate recipient net amounts and tax deductions |
| `POST` | `/discount-proposals/realization-process/:period` | JWT Required | Trigger monthly realization batch process |
| `PUT` | `/discount-proposals/recipients/:id` | JWT Required | Update recipient information |
| `PUT` | `/discount-proposals/realization/:id` | JWT Required | Update recipient realization amount |
| `PUT` | `/discount-proposals/reset/:id/realization/:access/:status` | JWT Required | Reset realization state |
| `PUT` | `/discount-proposals/realization-confirm/:id` | JWT Required | Confirm realization disbursement |
| `PUT` | `/discount-proposals/realization-statuses/:id` | JWT Required | Update realization status |
| `DELETE` | `/discount-proposals/recipients/:id` | JWT Required | Delete recipient record |
| `DELETE` | `/discount-proposals/recipients/array` | JWT Required | Batch delete recipient records |

---

### 9. Returns & Return Confirmations
*Defined in `route/discount_proposal_return_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/returns` | JWT Required | List discount proposal return records |
| `GET` | `/discount-proposals/returns/:id` | JWT Required | Get return record by ID |
| `GET` | `/discount-proposals/returns/find/:discount_proposal_recipient/:customer` | JWT Required | Find return by recipient ID and customer ID |
| `POST` | `/discount-proposals/returns` | JWT Required | Create return record with transfer proof upload |
| `PUT` | `/discount-proposals/returns/confirm/:id` | JWT Required | Confirm return and adjust customer balance |
| `DELETE` | `/discount-proposals/returns/:id` | JWT Required | Delete return record |

---

### 10. Credit Notes & Sales Matching
*Defined in `route/credit_note_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/credit-notes` | JWT Required | List credit note records with query filters |
| `GET` | `/credit-notes-summary-post` | JWT Required | List all credit note summary post records |
| `GET` | `/credit-notes-summary-post/:amount` | JWT Required | Calculate credit note summary post by amount |
| `GET` | `/credit-notes/to-sales-ffs` | JWT Required | List credit notes ready for Sales FF export |
| `GET` | `/credit-notes/report` | JWT Required | Generate credit note report |
| `GET` | `/credit-notes/no-match-sales-ffs` | JWT Required | List credit notes not matching sales FF records |
| `GET` | `/credit-notes/by-structure/:periodStart/:periodEnd/:periodStructure` | JWT Required | List credit notes grouped by marketing structure |
| `POST` | `/credit-notes` | JWT Required | Create credit note record |
| `POST` | `/credit-notes/evaluation/customer/by-email` | Public | Send customer credit note evaluation report via email |
| `PUT` | `/credit-notes` | JWT Required | Update credit note record |
| `PUT` | `/credit-notes-summary-post/:period/:discountProposalID/:customerID` | JWT Required | Update credit note summary post |
| `PUT` | `/credit-notes-summary-post/canceled/:period/:discountProposalID/:customerID` | JWT Required | Cancel credit note summary post |
| `PUT` | `/credit-notes/closed/:period/:marketingStructureID` | JWT Required | Close credit note period for marketing structure |
| `DELETE` | `/credit-notes/:period/:discountProposalID/:marketingStructureID/:customerID/:outletID/:productID/:invoice/:invoiceDate/:valueBalance` | JWT Required | Delete credit note line item |

---

### 11. Credit Note Amortization
*Defined in `route/credit_note_amortization_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/credit-notes-amortization` | JWT Required | List promotional amortizations |
| `GET` | `/credit-notes-amortization/:amount` | JWT Required | Calculate amortization schedule by amount |
| `GET` | `/credit-notes-amortization/groupby-period` | JWT Required | Group amortizations by monthly period |
| `GET` | `/credit-notes-amortization/payment-schedule` | JWT Required | Get amortization payment schedule |
| `POST` | `/credit-notes-amortization/:period` | JWT Required | Run amortization calculation for period |
| `PUT` | `/credit-notes-amortization/closed/:period` | JWT Required | Close / reopen amortization period |
| `PUT` | `/credit-notes-amortization/approve/:period` | JWT Required | Approve period amortization |

---

### 12. CQRS Credit Note Summary Post
*Defined in `route/cqrs_credit_note_summary_post_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/cqrs-credit-notes-summary-post` | JWT Required | List CQRS credit note summary post records |
| `GET` | `/cqrs-credit-notes-summary-post/promotion` | JWT Required | Filter CQRS credit note summaries by promotion |
| `GET` | `/cqrs-credit-notes-summary-post/customer` | JWT Required | Filter CQRS credit note summaries by customer |

---

### 13. Customer Balance & Running Ledger
*Defined in `route/customer_balance_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/customer-balances` | JWT Required | List customer balances across periods and structures |
| `GET` | `/customer-balances/calculator/:period/:customer-id` | JWT Required | Calculate customer running ledger balance |
| `POST` | `/customer-balances/:period` | Public | Execute period customer balance rollover |
| `PUT` | `/customer-balances` | JWT Required | Update customer balance / close status |

---

### 14. Discount Limits by Customer
*Defined in `route/discount_proposal_limit_by_customer_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/limit-discounts/customers` | JWT Required | List customer discount limit rules |
| `GET` | `/discount-proposals/limit-discounts/customers/:id` | JWT Required | Get customer discount limit by ID |
| `GET` | `/discount-proposals/limit-discounts/customers/periods` | JWT Required | Query customer limits across period range |
| `GET` | `/discount-proposals/limit-discounts/customers/confirm` | JWT Required | Check confirmation status for customer limits |
| `DELETE` | `/discount-proposals/limit-discounts/customers/:id` | JWT Required | Delete customer discount limit rule |

---

### 15. Discount Limits by General Trade (GT)
*Defined in `route/discount_proposal_limit_by_gt_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/limit-discounts/gt` | JWT Required | List GT discount limit rules |
| `GET` | `/discount-proposals/limit-discounts/gt/:id` | JWT Required | Get GT discount limit by ID |
| `GET` | `/discount-proposals/limit-discounts/gt/periods` | JWT Required | Query GT limits across period range |
| `GET` | `/discount-proposals/limit-discounts/gt/confirm` | JWT Required | Check confirmation status for GT limits |
| `GET` | `/discount-proposals/limit-discounts/gt/sales` | JWT Required | Get GT sales estimation limits |
| `DELETE` | `/discount-proposals/limit-discounts/gt/:id` | JWT Required | Delete GT limit rule |

---

### 16. Discount Limits by Outlet & Product
*Defined in `route/discount_proposal_limit_by_outlet_product_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/limit-discounts/outlets` | JWT Required | List outlet-product discount limit rules |
| `GET` | `/discount-proposals/limit-discounts/outlets/:id` | JWT Required | Get outlet-product discount limit by ID |
| `GET` | `/discount-proposals/limit-discounts/outlets/products` | JWT Required | Query multi-outlet product limit matrix |
| `GET` | `/discount-proposals/limit-discounts/outlets/periods` | JWT Required | Query outlet-product limits across period range |
| `GET` | `/discount-proposals/limit-discounts/outlets/products/confirm` | JWT Required | Confirm outlet-product discount limits |
| `DELETE` | `/discount-proposals/limit-discounts/outlets/:id` | JWT Required | Delete outlet-product discount limit rule |

---

### 17. Discount Limit Details & Automated Analysis
*Defined in `route/discount_proposal_limit_detail_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/limit-discounts/details` | JWT Required | List discount limit detail records |
| `GET` | `/discount-proposals/limit-discounts/details/:id` | JWT Required | Get discount limit detail by ID |
| `POST` | `/discount-proposals/limit-discounts/details/analysis/process` | Public | Execute automated limit analysis process |

---

### 18. Proposal Document Status Tracking
*Defined in `route/proposal_document_status_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/proposal-documents/statuses` | JWT Required | List document tracking status entries |
| `GET` | `/proposal-documents/statuses/:id` | JWT Required | Get document tracking status by ID |
| `POST` | `/proposal-documents/statuses/:memoNo` | JWT Required | Create document tracking record for memo |
| `PUT` | `/proposal-documents/statuses/:id` | JWT Required | Update document tracking status |
| `PUT` | `/proposal-documents/statuses/finish/:id` | JWT Required | Mark document workflow as finished |

---

### 19. Proposal PIC Management
*Defined in `route/discount_proposal_pic_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/pic` | JWT Required | List proposal PIC assignments |
| `GET` | `/discount-proposals/pic/:id` | JWT Required | Get proposal PIC assignment by ID |
| `POST` | `/discount-proposals/pic` | JWT Required | Create proposal PIC assignment |
| `POST` | `/discount-proposals/pic/process-structure-active/:period` | Public | Process active marketing structures for PIC |
| `PUT` | `/discount-proposals/pic/:id` | JWT Required | Update proposal PIC assignment |
| `DELETE` | `/discount-proposals/pic/:id` | JWT Required | Delete proposal PIC assignment |

---

### 20. Promotional Events
*Defined in `route/discount_proposal_event_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/discount-proposals/events` | JWT Required | List promotional events |
| `POST` | `/discount-proposals/events` | JWT Required | Create promotional event |
| `DELETE` | `/discount-proposals/events/:id` | JWT Required | Delete promotional event |

---

### 21. Microservice Configuration
*Defined in `route/config_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/configs` | Role: Administrator | List microservice configuration keys |
| `GET` | `/configs/:id` | Role: Administrator | Get configuration key by ID |
| `POST` | `/configs` | Role: Administrator | Create configuration key |
| `PUT` | `/configs/:id` | Role: Administrator | Update configuration key |
| `DELETE` | `/configs/:id` | Role: Administrator | Delete configuration key |

---

### 22. Manual Processing & Stored Procedures
*Defined in `route/proces_manual_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/proces-manuals` | Role: Administrator | List manual processing tasks |
| `GET` | `/proces-manuals/:id` | Role: Administrator | Get manual processing task by ID |
| `POST` | `/proces-manuals` | Role: Administrator | Register manual processing task |
| `POST` | `/proces-manuals/by-sp/:sp` | Role: Administrator | Trigger stored procedure manual execution |
| `PUT` | `/proces-manuals/:id` | Role: Administrator | Update manual processing task |
| `DELETE` | `/proces-manuals/:id` | Role: Administrator | Delete manual processing task |

---

### 23. Call Logging
*Defined in `route/call.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/call` | JWT Required | List service call log records |
| `GET` | `/call/:id` | JWT Required | Get call log record by ID |

---

### 24. Warehouse Pelunasan Integration
*Defined in `route/pelunasan_wh_process_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `POST` | `/warehouse/pelunasan/process` | Public | Synchronize settlement (*pelunasan*) data with warehouse |

---

### 25. Warehouse SKI Integration
*Defined in `route/ski_wh_process_route.go`*

| Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- |
| `POST` | `/warehouse/ski/process` | Public | Synchronize SKI compliance data with warehouse |

---

## Docker & Deployment

### Build Docker Image
```bash
docker build -t discount-proposal:latest .
```

### Docker Compose
```bash
docker-compose up -d
```

---

## Core Engineering Rules

When contributing or extending this codebase, adhere to the following architecture guardrails:

1. **Transaction Lifecycle**: Transactions MUST begin in the Service layer (`tx := service.DB.Begin()`) with immediate `defer helper.CommitOrRollback(tx)`. Repositories receive `*gorm.DB` and must never commit/rollback themselves.
2. **Panic-Recovery Flow**: Errors are propagated via panics (`helper.PanicIfError(err)` or `panic(&exception.ErrorSendToResponse{Err: "..."})`) and caught cleanly by `app.ErrorHandler()`.
3. **GORM Zero-Value Updates**: GORM struct updates omit zero values. Use `map[string]interface{}` or explicit column updates when updating nullable or zero fields (`status_over_budget`, `event_header_id`, etc.).
4. **No AutoMigrate**: Schema migrations are strictly managed via SQL scripts in `app/database/` and must never run through GORM `AutoMigrate` at runtime.
5. **Standard Web Envelope**: All API endpoints must return `model/web.WebResponse`. Successful responses and "Record not found" responses both return HTTP 200 with descriptive messages.
