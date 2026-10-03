# ski-api-gateway

HTTP reverse proxy for SKI microservices and external integrations, with public/protected route collections, API-key/JWT middleware and centralized error handling.

## Table of Contents

- [Overview and architecture](#overview-and-architecture)
- [Technology stack](#technology-stack)
- [Directory structure](#directory-structure)
- [Getting started](#getting-started)
- [Complete API endpoint reference](#complete-api-endpoint-reference)
- [Database and integration notes](#database-and-integration-notes)
- [Quality and deployment](#quality-and-deployment)

## Overview and architecture

Requests enter `cmd/main.go` → `pkg/app/router.go` → a `Backend` entry → `helper.ReverseProxy`. Public routes are registered before API-key/JWT middleware; protected routes are registered afterward. CORS and IP/error middleware are installed globally. CORS preflight is handled by middleware. Route registration is local source evidence; external ingress and downstream authorization must be checked separately.

## Technology stack

- Module: `gitlab.com/VNEU/ski-api-gateway`.
- Go language version declared by [go.mod](go.mod): **1.23**.
- Gin: `v1.8.1`.
- Validator: `v10.11.0`.
- Viper: `v1.12.0`.

Internal/private modules are pinned in `go.mod`; access to those module versions is required. A sibling checkout does not automatically replace a pinned dependency.

## Directory structure

| Path | Purpose |
| --- | --- |
| [model/](model/) | Persistence models and API DTOs |
| [helper/](helper/) | Shared utilities and integrations |
| [exception/](exception/) | Error definitions and response handling |
| [cmd/](cmd/) | Gateway entry point |
| [pkg/](pkg/) | Gateway configuration, middleware and route mappings |
| [test/](test/) | Test sources |
| [scripts/](scripts/) | Maintenance and quality scripts |

## Getting started

1. Install the Go version required by `go.mod` and configure access to private module dependencies.
2. Prepare local configuration from the loader below. Obtain secrets through the approved secret-management process; do not copy production credentials into README examples.
3. Use an isolated development database and review bootstrap/integration side effects before starting the application.
4. Run from the repository root:

```sh
go mod download
go run ./cmd/main.go
```

These are documented commands, not commands executed during this README refresh.

### Configuration

Loader: [pkg/config/config.go](pkg/config/config.go).
The loader reads `pkg/config/env/dev.env` and enables Viper automatic environment lookup. `PORT` accepts the form handled in `cmd/main.go`; a bare port is normalized there.

Declared configuration keys (names only):

| Key |
| --- |
| `PORT` |
| `ACCESS_SECRET` |
| `REFRESH_SECRET` |


## Complete API endpoint reference

**604 source declarations** are listed below, including declarations not called by the current router. Paths preserve the source spelling and parameters. This inventory describes the local checkout, not a verified deployed API.

Auth labels describe the route collection in `pkg/app/router.go`: public bypasses the gateway API-key/JWT stage; protected passes through it. Downstream services may impose additional checks. Paths without a leading slash are reproduced literally; confirm their effective Gin registration before relying on them.

### Routes Auth

Source: [pkg/app/routes_auth.go](pkg/app/routes_auth.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `GET` | `/users/login` | Public | `mf-micro-service-ski-auth:8080` | [L7](pkg/app/routes_auth.go#L7) |
| `POST` | `/users/refresh-token` | Public | `mf-micro-service-ski-auth:8080` | [L8](pkg/app/routes_auth.go#L8) |
| `GET` | `/users` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L16](pkg/app/routes_auth.go#L16) |
| `POST` | `/users` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L17](pkg/app/routes_auth.go#L17) |
| `PUT` | `/users/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L18](pkg/app/routes_auth.go#L18) |
| `PUT` | `/users-change-password/:id` | Protected | `mf-micro-service-ski-auth:8080` | [L19](pkg/app/routes_auth.go#L19) |
| `PUT` | `/users-reset-password/:id` | Protected | `mf-micro-service-ski-auth:8080` | [L20](pkg/app/routes_auth.go#L20) |
| `DELETE` | `/users/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L21](pkg/app/routes_auth.go#L21) |
| `GET` | `/menu_sidebars` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L24](pkg/app/routes_auth.go#L24) |
| `GET` | `/menu_sidebars/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L25](pkg/app/routes_auth.go#L25) |
| `POST` | `/menu_sidebars` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L26](pkg/app/routes_auth.go#L26) |
| `PUT` | `/menu_sidebars/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L27](pkg/app/routes_auth.go#L27) |
| `DELETE` | `/menu_sidebars/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L28](pkg/app/routes_auth.go#L28) |
| `GET` | `/menus/authentications` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L31](pkg/app/routes_auth.go#L31) |
| `GET` | `/menus/authentications-csv` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L32](pkg/app/routes_auth.go#L32) |
| `GET` | `/menus/authentications/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L33](pkg/app/routes_auth.go#L33) |
| `POST` | `/menus/authentications` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L34](pkg/app/routes_auth.go#L34) |
| `PUT` | `/menus/authentications/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L35](pkg/app/routes_auth.go#L35) |
| `DELETE` | `/menus/authentications/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L36](pkg/app/routes_auth.go#L36) |
| `GET` | `group/authentications` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L39](pkg/app/routes_auth.go#L39) |
| `GET` | `group/authentications/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L40](pkg/app/routes_auth.go#L40) |
| `POST` | `group/authentications` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L41](pkg/app/routes_auth.go#L41) |
| `PUT` | `group/authentications/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L42](pkg/app/routes_auth.go#L42) |
| `DELETE` | `group/authentications/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L43](pkg/app/routes_auth.go#L43) |
| `GET` | `group/menus/authentications` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L46](pkg/app/routes_auth.go#L46) |
| `GET` | `group/menus/authentications/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L47](pkg/app/routes_auth.go#L47) |
| `POST` | `group/menus/authentications/:menuGroupID` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L48](pkg/app/routes_auth.go#L48) |
| `PUT` | `group/menus/authentications/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L49](pkg/app/routes_auth.go#L49) |
| `DELETE` | `group/menus/authentications/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L50](pkg/app/routes_auth.go#L50) |
| `GET` | `/divisions` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L53](pkg/app/routes_auth.go#L53) |
| `GET` | `/divisions/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L54](pkg/app/routes_auth.go#L54) |
| `POST` | `/divisions` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L55](pkg/app/routes_auth.go#L55) |
| `PUT` | `/divisions/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L56](pkg/app/routes_auth.go#L56) |
| `DELETE` | `/divisions/:id` | Protected | `mf-micro-service-ski-marketing-user:8080` | [L57](pkg/app/routes_auth.go#L57) |


### Routes Bank

Source: [pkg/app/routes_bank.go](pkg/app/routes_bank.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `GET` | `/banks` | Protected | `mf-micro-service-ski-bank:8080` | [L7](pkg/app/routes_bank.go#L7) |
| `GET` | `/banks/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L8](pkg/app/routes_bank.go#L8) |
| `POST` | `/banks` | Protected | `mf-micro-service-ski-bank:8080` | [L9](pkg/app/routes_bank.go#L9) |
| `PUT` | `/banks/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L10](pkg/app/routes_bank.go#L10) |
| `DELETE` | `/banks/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L11](pkg/app/routes_bank.go#L11) |
| `GET` | `/banks/branches` | Protected | `mf-micro-service-ski-bank:8080` | [L14](pkg/app/routes_bank.go#L14) |
| `GET` | `/banks/branches/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L15](pkg/app/routes_bank.go#L15) |
| `POST` | `/banks/branches` | Protected | `mf-micro-service-ski-bank:8080` | [L16](pkg/app/routes_bank.go#L16) |
| `PUT` | `/banks/branches/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L17](pkg/app/routes_bank.go#L17) |
| `DELETE` | `/banks/branches/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L18](pkg/app/routes_bank.go#L18) |
| `GET` | `/banks/transfer-fees` | Protected | `mf-micro-service-ski-bank:8080` | [L21](pkg/app/routes_bank.go#L21) |
| `GET` | `/banks/transfer-fees/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L22](pkg/app/routes_bank.go#L22) |
| `GET` | `banks/:id/transfer-fees/date/:period` | Protected | `mf-micro-service-ski-bank:8080` | [L23](pkg/app/routes_bank.go#L23) |
| `POST` | `/banks/transfer-fees` | Protected | `mf-micro-service-ski-bank:8080` | [L24](pkg/app/routes_bank.go#L24) |
| `PUT` | `/banks/transfer-fees/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L25](pkg/app/routes_bank.go#L25) |
| `DELETE` | `/banks/transfer-fees/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L26](pkg/app/routes_bank.go#L26) |
| `GET` | `/accounts` | Protected | `mf-micro-service-ski-bank:8080` | [L29](pkg/app/routes_bank.go#L29) |
| `GET` | `/accounts/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L30](pkg/app/routes_bank.go#L30) |
| `GET` | `/accounts/verify/:biCode/:account` | Protected | `mf-micro-service-ski-bank:8080` | [L31](pkg/app/routes_bank.go#L31) |
| `POST` | `/accounts` | Protected | `mf-micro-service-ski-bank:8080` | [L32](pkg/app/routes_bank.go#L32) |
| `PUT` | `/accounts/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L33](pkg/app/routes_bank.go#L33) |
| `DELETE` | `/accounts/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L34](pkg/app/routes_bank.go#L34) |
| `GET` | `/discount-proposals/transferred-types` | Protected | `mf-micro-service-ski-bank:8080` | [L37](pkg/app/routes_bank.go#L37) |
| `GET` | `/discount-proposals/transferred-types/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L38](pkg/app/routes_bank.go#L38) |
| `POST` | `/discount-proposals/transferred-types` | Protected | `mf-micro-service-ski-bank:8080` | [L39](pkg/app/routes_bank.go#L39) |
| `PUT` | `/discount-proposals/transferred-types/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L40](pkg/app/routes_bank.go#L40) |
| `DELETE` | `/discount-proposals/transferred-types/:id` | Protected | `mf-micro-service-ski-bank:8080` | [L41](pkg/app/routes_bank.go#L41) |


### Routes City

Source: [pkg/app/routes_city.go](pkg/app/routes_city.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `GET` | `/cities/:isAll` | Protected | `mf-micro-service-ski-city:8080` | [L7](pkg/app/routes_city.go#L7) |
| `GET` | `/cities-csv` | Protected | `mf-micro-service-ski-city:8080` | [L8](pkg/app/routes_city.go#L8) |
| `POST` | `/cities` | Protected | `mf-micro-service-ski-city:8080` | [L9](pkg/app/routes_city.go#L9) |
| `PUT` | `/cities/:id` | Protected | `mf-micro-service-ski-city:8080` | [L10](pkg/app/routes_city.go#L10) |
| `DELETE` | `/cities/:id` | Protected | `mf-micro-service-ski-city:8080` | [L11](pkg/app/routes_city.go#L11) |


### Routes Customer

Source: [pkg/app/routes_customer.go](pkg/app/routes_customer.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `GET` | `/customers/no-auth` | Public | `mf-micro-service-ski-customer:8080` | [L7](pkg/app/routes_customer.go#L7) |
| `GET` | `/customers` | Protected | `mf-micro-service-ski-customer:8080` | [L15](pkg/app/routes_customer.go#L15) |
| `GET` | `/customers/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L16](pkg/app/routes_customer.go#L16) |
| `GET` | `/customers/events/specialists` | Protected | `mf-micro-service-ski-customer:8080` | [L17](pkg/app/routes_customer.go#L17) |
| `POST` | `/customers` | Protected | `mf-micro-service-ski-customer:8080` | [L18](pkg/app/routes_customer.go#L18) |
| `PUT` | `/customers/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L19](pkg/app/routes_customer.go#L19) |
| `DELETE` | `/customers/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L20](pkg/app/routes_customer.go#L20) |
| `GET` | `/customers/inactive-statuses` | Protected | `mf-micro-service-ski-customer:8080` | [L23](pkg/app/routes_customer.go#L23) |
| `GET` | `/customers/inactive-statuses/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L24](pkg/app/routes_customer.go#L24) |
| `POST` | `/customers/inactive-statuses` | Protected | `mf-micro-service-ski-customer:8080` | [L25](pkg/app/routes_customer.go#L25) |
| `PUT` | `/customers/inactive-statuses/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L26](pkg/app/routes_customer.go#L26) |
| `DELETE` | `/customers/inactive-statuses/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L27](pkg/app/routes_customer.go#L27) |
| `GET` | `/customers/positions` | Protected | `mf-micro-service-ski-customer:8080` | [L30](pkg/app/routes_customer.go#L30) |
| `GET` | `/customers/positions/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L31](pkg/app/routes_customer.go#L31) |
| `POST` | `/customers/positions` | Protected | `mf-micro-service-ski-customer:8080` | [L32](pkg/app/routes_customer.go#L32) |
| `PUT` | `/customers/positions/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L33](pkg/app/routes_customer.go#L33) |
| `DELETE` | `/customers/positions/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L34](pkg/app/routes_customer.go#L34) |
| `GET` | `/customers/specialists` | Protected | `mf-micro-service-ski-customer:8080` | [L37](pkg/app/routes_customer.go#L37) |
| `GET` | `/customers/specialists/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L38](pkg/app/routes_customer.go#L38) |
| `POST` | `/customers/specialists` | Protected | `mf-micro-service-ski-customer:8080` | [L39](pkg/app/routes_customer.go#L39) |
| `PUT` | `/customers/specialists/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L40](pkg/app/routes_customer.go#L40) |
| `DELETE` | `/customers/specialists/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L41](pkg/app/routes_customer.go#L41) |
| `GET` | `/customers/group/specialists` | Protected | `mf-micro-service-ski-customer:8080` | [L44](pkg/app/routes_customer.go#L44) |
| `GET` | `/customers/group/specialists/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L45](pkg/app/routes_customer.go#L45) |
| `POST` | `/customers/group/specialists` | Protected | `mf-micro-service-ski-customer:8080` | [L46](pkg/app/routes_customer.go#L46) |
| `PUT` | `/customers/group/specialists/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L47](pkg/app/routes_customer.go#L47) |
| `DELETE` | `/customers/group/specialists/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L48](pkg/app/routes_customer.go#L48) |
| `GET` | `/customers/territories/outlets` | Protected | `mf-micro-service-ski-customer:8080` | [L51](pkg/app/routes_customer.go#L51) |
| `GET` | `/customers/territories/outlets/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L52](pkg/app/routes_customer.go#L52) |
| `GET` | `/customers/territories/outlets/cust` | Protected | `mf-micro-service-ski-customer:8080` | [L53](pkg/app/routes_customer.go#L53) |
| `POST` | `/customers/territories/outlets` | Protected | `mf-micro-service-ski-customer:8080` | [L54](pkg/app/routes_customer.go#L54) |
| `PUT` | `/customers/territories/outlets/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L55](pkg/app/routes_customer.go#L55) |
| `DELETE` | `/customers/territories/outlets/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L56](pkg/app/routes_customer.go#L56) |
| `GET` | `/customers/territories/products` | Protected | `mf-micro-service-ski-customer:8080` | [L59](pkg/app/routes_customer.go#L59) |
| `GET` | `/customers/territories/products/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L60](pkg/app/routes_customer.go#L60) |
| `GET` | `/customers/territories/products/program/:programID/:period` | Protected | `mf-micro-service-ski-customer:8080` | [L61](pkg/app/routes_customer.go#L61) |
| `POST` | `/customers/territories/products` | Protected | `mf-micro-service-ski-customer:8080` | [L62](pkg/app/routes_customer.go#L62) |
| `PUT` | `/customers/territories/products/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L63](pkg/app/routes_customer.go#L63) |
| `DELETE` | `/customers/territories/products/:id` | Protected | `mf-micro-service-ski-customer:8080` | [L64](pkg/app/routes_customer.go#L64) |


### Routes Discount Proposal

Source: [pkg/app/routes_discount_proposal.go](pkg/app/routes_discount_proposal.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `POST` | `/customer-balances/:period` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L7](pkg/app/routes_discount_proposal.go#L7) |
| `GET` | `/discount-proposals/over-budget` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L10](pkg/app/routes_discount_proposal.go#L10) |
| `PUT` | `/discount-proposals/:id/:marketingStructureID/:appeal` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L13](pkg/app/routes_discount_proposal.go#L13) |
| `POST` | `/discount-proposals/limit-discounts/details/analysis/process` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L16](pkg/app/routes_discount_proposal.go#L16) |
| `POST` | `/warehouse/pelunasan/process` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L19](pkg/app/routes_discount_proposal.go#L19) |
| `POST` | `/credit-notes/evaluation/customer/by-email` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L20](pkg/app/routes_discount_proposal.go#L20) |
| `GET` | `/discount-proposals/payments/psi` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L23](pkg/app/routes_discount_proposal.go#L23) |
| `PUT` | `/discount-proposals/payments/psi/:noTransfer` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L24](pkg/app/routes_discount_proposal.go#L24) |
| `POST` | `/discount-proposals/payments/untransferred-memo/by-email` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L25](pkg/app/routes_discount_proposal.go#L25) |
| `POST` | `/discount-proposals/payments/transferred-memo/by-email` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L26](pkg/app/routes_discount_proposal.go#L26) |
| `GET` | `/discount-proposals/payments/calculator/:period/:customerID/:structureID` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L27](pkg/app/routes_discount_proposal.go#L27) |
| `GET` | `/discount-proposals/estimations/credit-notes/percentage/by-customer` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L30](pkg/app/routes_discount_proposal.go#L30) |
| `POST` | `/discount-proposals/pic/process-structure-active/:period` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L33](pkg/app/routes_discount_proposal.go#L33) |
| `POST` | `/incentive/process-sp/:id` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L36](pkg/app/routes_discount_proposal.go#L36) |
| `GET` | `/discount-proposals/calculator-spc/:period/:customerID/:userID` | Public | `mf-micro-service-ski-discount-proposal:8080` | [L39](pkg/app/routes_discount_proposal.go#L39) |
| `GET` | `/configs` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L47](pkg/app/routes_discount_proposal.go#L47) |
| `GET` | `/configs/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L48](pkg/app/routes_discount_proposal.go#L48) |
| `POST` | `/configs` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L49](pkg/app/routes_discount_proposal.go#L49) |
| `PUT` | `/configs/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L50](pkg/app/routes_discount_proposal.go#L50) |
| `DELETE` | `/configs/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L51](pkg/app/routes_discount_proposal.go#L51) |
| `GET` | `/proces-manuals` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L54](pkg/app/routes_discount_proposal.go#L54) |
| `GET` | `/proces-manuals/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L55](pkg/app/routes_discount_proposal.go#L55) |
| `POST` | `/proces-manuals` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L56](pkg/app/routes_discount_proposal.go#L56) |
| `POST` | `/proces-manuals/by-sp/:sp` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L57](pkg/app/routes_discount_proposal.go#L57) |
| `PUT` | `/proces-manuals/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L58](pkg/app/routes_discount_proposal.go#L58) |
| `DELETE` | `/proces-manuals/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L59](pkg/app/routes_discount_proposal.go#L59) |
| `GET` | `/discount-proposals` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L62](pkg/app/routes_discount_proposal.go#L62) |
| `GET` | `/discount-proposals/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L63](pkg/app/routes_discount_proposal.go#L63) |
| `GET` | `/discount-proposals-active` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L64](pkg/app/routes_discount_proposal.go#L64) |
| `GET` | `/discount-proposals/:id/distributor` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L65](pkg/app/routes_discount_proposal.go#L65) |
| `GET` | `/discount-proposals/:id/distributor-active/:distributorID` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L66](pkg/app/routes_discount_proposal.go#L66) |
| `GET` | `/discount-proposals/report/promotion/cpk` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L67](pkg/app/routes_discount_proposal.go#L67) |
| `GET` | `/discount-proposals/report/dldf/cpk` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L68](pkg/app/routes_discount_proposal.go#L68) |
| `GET` | `/discount-proposals/report/dldf/cpk/details` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L69](pkg/app/routes_discount_proposal.go#L69) |
| `GET` | `/discount-proposals/no-bridging-promotion` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L70](pkg/app/routes_discount_proposal.go#L70) |
| `GET` | `/discount-proposals/promotion-details` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L71](pkg/app/routes_discount_proposal.go#L71) |
| `GET` | `/discount-proposals/payments/summary/:period` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L72](pkg/app/routes_discount_proposal.go#L72) |
| `GET` | `/discount-proposals/report/dldf/summary-qty` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L73](pkg/app/routes_discount_proposal.go#L73) |
| `GET` | `/analysis-ski/calculation/:period/:customerID/:structureID` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L74](pkg/app/routes_discount_proposal.go#L74) |
| `GET` | `/analysis-ski/calculator/:period/:customerID` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L75](pkg/app/routes_discount_proposal.go#L75) |
| `GET` | `/analysis-ski/calculator/:period/:customerID/excel` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L76](pkg/app/routes_discount_proposal.go#L76) |
| `POST` | `/discount-proposals` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L77](pkg/app/routes_discount_proposal.go#L77) |
| `POST` | `/discount-proposals/:id/terminated` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L78](pkg/app/routes_discount_proposal.go#L78) |
| `PUT` | `/discount-proposals/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L79](pkg/app/routes_discount_proposal.go#L79) |
| `PUT` | `/discount-proposals/create-rangkuman` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L80](pkg/app/routes_discount_proposal.go#L80) |
| `PUT` | `/discount-proposals/print/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L81](pkg/app/routes_discount_proposal.go#L81) |
| `PUT` | `/discount-proposals/create-memo` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L82](pkg/app/routes_discount_proposal.go#L82) |
| `PUT` | `/discount-proposals/open-rangkuman/:rangkuman_no` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L83](pkg/app/routes_discount_proposal.go#L83) |
| `PUT` | `/discount-proposals/open-memo/:memo_no` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L84](pkg/app/routes_discount_proposal.go#L84) |
| `PUT` | `/discount-proposals/cancel-transfer/:memo_no` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L85](pkg/app/routes_discount_proposal.go#L85) |
| `PUT` | `/discount-proposals/guarantee-by/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L86](pkg/app/routes_discount_proposal.go#L86) |
| `PUT` | `/discount-proposals/transfer-process/:memo_no` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L87](pkg/app/routes_discount_proposal.go#L87) |
| `PUT` | `/discount-proposals/marketing-structure` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L88](pkg/app/routes_discount_proposal.go#L88) |
| `PUT` | `/discount-proposals/reset-distributor-code/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L89](pkg/app/routes_discount_proposal.go#L89) |
| `PUT` | `/discount-proposals/cut-off/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L90](pkg/app/routes_discount_proposal.go#L90) |
| `DELETE` | `/discount-proposals/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L91](pkg/app/routes_discount_proposal.go#L91) |
| `GET` | `/discount-proposals/payments` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L94](pkg/app/routes_discount_proposal.go#L94) |
| `POST` | `/discount-proposals/payments` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L95](pkg/app/routes_discount_proposal.go#L95) |
| `PUT` | `/discount-proposals/payments/update/ps` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L96](pkg/app/routes_discount_proposal.go#L96) |
| `GET` | `/discount-proposals/payments/boss` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L97](pkg/app/routes_discount_proposal.go#L97) |
| `GET` | `/discount-proposals/payments/group-by/:rangkuman` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L98](pkg/app/routes_discount_proposal.go#L98) |
| `GET` | `/discount-proposals/payments/no-transfer/:noTransfer` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L99](pkg/app/routes_discount_proposal.go#L99) |
| `GET` | `/discount-proposals/payments/report-transfer` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L100](pkg/app/routes_discount_proposal.go#L100) |
| `GET` | `/discount-proposals/payments/period-summary/:periodStart/:periodEnd` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L101](pkg/app/routes_discount_proposal.go#L101) |
| `PUT` | `/discount-proposals/payments/update/memo` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L102](pkg/app/routes_discount_proposal.go#L102) |
| `PUT` | `/discount-proposals/payments/update/transfer` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L103](pkg/app/routes_discount_proposal.go#L103) |
| `PUT` | `/discount-proposals/payments/update/transfer-array` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L104](pkg/app/routes_discount_proposal.go#L104) |
| `PUT` | `/discount-proposals/payments/print/rangkuman/:rangkuman` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L105](pkg/app/routes_discount_proposal.go#L105) |
| `PUT` | `/discount-proposals/payments/print/memo/:memo` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L106](pkg/app/routes_discount_proposal.go#L106) |
| `PUT` | `/discount-proposals/payments/print/transfer/:noTransfer` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L107](pkg/app/routes_discount_proposal.go#L107) |
| `PUT` | `/discount-proposals/payments/update/canceled/rangkuman` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L108](pkg/app/routes_discount_proposal.go#L108) |
| `PUT` | `/discount-proposals/payments/update/canceled/memo` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L109](pkg/app/routes_discount_proposal.go#L109) |
| `PUT` | `/discount-proposals/payments/update/canceled/transfer` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L110](pkg/app/routes_discount_proposal.go#L110) |
| `PUT` | `/discount-proposals/payments/receipt/memo` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L111](pkg/app/routes_discount_proposal.go#L111) |
| `PUT` | `/discount-proposals/payments/withholding-tax-proof/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L112](pkg/app/routes_discount_proposal.go#L112) |
| `PUT` | `/discount-proposals/payments/update/transfer-date/:period/:accountID/:memoNo/:customerID` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L113](pkg/app/routes_discount_proposal.go#L113) |
| `PUT` | `/discount-proposals/payments/approve/transfer-date` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L114](pkg/app/routes_discount_proposal.go#L114) |
| `PUT` | `/discount-proposals/payments/update-account-by/:memoNo` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L115](pkg/app/routes_discount_proposal.go#L115) |
| `PUT` | `/discount-proposals/payments/update-bilyet-giro` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L116](pkg/app/routes_discount_proposal.go#L116) |
| `GET` | `/discount-proposals/split/payments` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L119](pkg/app/routes_discount_proposal.go#L119) |
| `GET` | `/discount-proposals/split/payments/bs` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L120](pkg/app/routes_discount_proposal.go#L120) |
| `GET` | `/discount-proposals/confirmations` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L123](pkg/app/routes_discount_proposal.go#L123) |
| `POST` | `/discount-proposals/confirmations/:confirmation` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L124](pkg/app/routes_discount_proposal.go#L124) |
| `POST` | `/discount-proposals/confirmations/:confirmation/approve` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L125](pkg/app/routes_discount_proposal.go#L125) |
| `GET` | `/discount-proposals/confirmation-statuses` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L128](pkg/app/routes_discount_proposal.go#L128) |
| `GET` | `/discount-proposals/confirmation-statuses/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L129](pkg/app/routes_discount_proposal.go#L129) |
| `POST` | `/discount-proposals/confirmation-statuses` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L130](pkg/app/routes_discount_proposal.go#L130) |
| `PUT` | `/discount-proposals/confirmation-statuses/:id/:type` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L131](pkg/app/routes_discount_proposal.go#L131) |
| `DELETE` | `/discount-proposals/confirmation-statuses/:id/:type` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L132](pkg/app/routes_discount_proposal.go#L132) |
| `GET` | `/discount-proposals/estimations` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L135](pkg/app/routes_discount_proposal.go#L135) |
| `GET` | `/discount-proposals/estimations/calculate/:discountProposalID` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L136](pkg/app/routes_discount_proposal.go#L136) |
| `GET` | `/discount-proposals/estimations/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L137](pkg/app/routes_discount_proposal.go#L137) |
| `GET` | `/discount-proposals/estimations/:id/non-terminated/:discountNew` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L138](pkg/app/routes_discount_proposal.go#L138) |
| `POST` | `/discount-proposals/estimations` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L139](pkg/app/routes_discount_proposal.go#L139) |
| `PUT` | `/discount-proposals/estimations/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L140](pkg/app/routes_discount_proposal.go#L140) |
| `PUT` | `/discount-proposals/estimations/active/by-outlet/:discountProposalID/:outletID` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L141](pkg/app/routes_discount_proposal.go#L141) |
| `DELETE` | `/discount-proposals/estimations/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L142](pkg/app/routes_discount_proposal.go#L142) |
| `GET` | `/discount-proposals/on-facturs` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L145](pkg/app/routes_discount_proposal.go#L145) |
| `POST` | `/discount-proposals/on-facturs` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L146](pkg/app/routes_discount_proposal.go#L146) |
| `POST` | `/discount-proposals/on-facturs/:id/:productID` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L147](pkg/app/routes_discount_proposal.go#L147) |
| `DELETE` | `/discount-proposals/on-facturs/:discountProposalID/:outletID/:productID/:productMaxID` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L148](pkg/app/routes_discount_proposal.go#L148) |
| `GET` | `/discount-proposals/events` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L151](pkg/app/routes_discount_proposal.go#L151) |
| `POST` | `/discount-proposals/events` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L152](pkg/app/routes_discount_proposal.go#L152) |
| `DELETE` | `/discount-proposals/events/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L153](pkg/app/routes_discount_proposal.go#L153) |
| `GET` | `/discount-proposals/limit-discounts/customers` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L156](pkg/app/routes_discount_proposal.go#L156) |
| `GET` | `/discount-proposals/limit-discounts/customers/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L157](pkg/app/routes_discount_proposal.go#L157) |
| `GET` | `/discount-proposals/limit-discounts/customers/periods` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L158](pkg/app/routes_discount_proposal.go#L158) |
| `GET` | `/discount-proposals/limit-discounts/customers/confirm` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L159](pkg/app/routes_discount_proposal.go#L159) |
| `DELETE` | `/discount-proposals/limit-discounts/customers/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L160](pkg/app/routes_discount_proposal.go#L160) |
| `GET` | `/discount-proposals/limit-discounts/outlets` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L163](pkg/app/routes_discount_proposal.go#L163) |
| `GET` | `/discount-proposals/limit-discounts/outlets/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L164](pkg/app/routes_discount_proposal.go#L164) |
| `GET` | `/discount-proposals/limit-discounts/outlets/products` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L165](pkg/app/routes_discount_proposal.go#L165) |
| `GET` | `/discount-proposals/limit-discounts/outlets/periods` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L166](pkg/app/routes_discount_proposal.go#L166) |
| `GET` | `/discount-proposals/limit-discounts/outlets/products/confirm` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L167](pkg/app/routes_discount_proposal.go#L167) |
| `DELETE` | `/discount-proposals/limit-discounts/outlets/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L168](pkg/app/routes_discount_proposal.go#L168) |
| `GET` | `/discount-proposals/limit-discounts/gt` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L171](pkg/app/routes_discount_proposal.go#L171) |
| `GET` | `/discount-proposals/limit-discounts/gt/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L172](pkg/app/routes_discount_proposal.go#L172) |
| `GET` | `/discount-proposals/limit-discounts/gt/periods` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L173](pkg/app/routes_discount_proposal.go#L173) |
| `GET` | `/discount-proposals/limit-discounts/gt/confirm` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L174](pkg/app/routes_discount_proposal.go#L174) |
| `GET` | `/discount-proposals/limit-discounts/gt/sales` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L175](pkg/app/routes_discount_proposal.go#L175) |
| `DELETE` | `/discount-proposals/limit-discounts/gt/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L176](pkg/app/routes_discount_proposal.go#L176) |
| `GET` | `/discount-proposals/limit-discounts/details` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L179](pkg/app/routes_discount_proposal.go#L179) |
| `GET` | `/discount-proposals/limit-discounts/details/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L180](pkg/app/routes_discount_proposal.go#L180) |
| `GET` | `/discount-proposals/recipients` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L183](pkg/app/routes_discount_proposal.go#L183) |
| `GET` | `/discount-proposals/recipients/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L184](pkg/app/routes_discount_proposal.go#L184) |
| `PUT` | `/discount-proposals/recipients/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L185](pkg/app/routes_discount_proposal.go#L185) |
| `GET` | `/discount-proposals/recipients/realization` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L186](pkg/app/routes_discount_proposal.go#L186) |
| `POST` | `/discount-proposals/recipients/value-recalculations` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L187](pkg/app/routes_discount_proposal.go#L187) |
| `POST` | `/discount-proposals/recipients` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L188](pkg/app/routes_discount_proposal.go#L188) |
| `POST` | `/discount-proposals/recipients/array` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L189](pkg/app/routes_discount_proposal.go#L189) |
| `POST` | `/discount-proposals/realization-process/:period` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L190](pkg/app/routes_discount_proposal.go#L190) |
| `PUT` | `/discount-proposals/realization/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L191](pkg/app/routes_discount_proposal.go#L191) |
| `PUT` | `/discount-proposals/realization-confirm/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L192](pkg/app/routes_discount_proposal.go#L192) |
| `PUT` | `/discount-proposals/reset/:id/realization/:access/:status` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L193](pkg/app/routes_discount_proposal.go#L193) |
| `DELETE` | `/discount-proposals/recipients/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L194](pkg/app/routes_discount_proposal.go#L194) |
| `DELETE` | `/discount-proposals/recipients/array` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L195](pkg/app/routes_discount_proposal.go#L195) |
| `GET` | `/discount-proposals/pic` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L198](pkg/app/routes_discount_proposal.go#L198) |
| `GET` | `/discount-proposals/pic/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L199](pkg/app/routes_discount_proposal.go#L199) |
| `PUT` | `/discount-proposals/pic/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L200](pkg/app/routes_discount_proposal.go#L200) |
| `POST` | `/discount-proposals/pic` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L201](pkg/app/routes_discount_proposal.go#L201) |
| `DELETE` | `/discount-proposals/pic/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L202](pkg/app/routes_discount_proposal.go#L202) |
| `GET` | `/discount-proposals/returns` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L205](pkg/app/routes_discount_proposal.go#L205) |
| `GET` | `/discount-proposals/returns/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L206](pkg/app/routes_discount_proposal.go#L206) |
| `GET` | `/discount-proposals/returns/find/:discount_proposal_recipient/:customer` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L207](pkg/app/routes_discount_proposal.go#L207) |
| `POST` | `/discount-proposals/returns` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L208](pkg/app/routes_discount_proposal.go#L208) |
| `PUT` | `/discount-proposals/returns/confirm/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L209](pkg/app/routes_discount_proposal.go#L209) |
| `DELETE` | `/discount-proposals/returns/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L210](pkg/app/routes_discount_proposal.go#L210) |
| `GET` | `/proposal-documents/statuses` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L213](pkg/app/routes_discount_proposal.go#L213) |
| `GET` | `/proposal-documents/statuses/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L214](pkg/app/routes_discount_proposal.go#L214) |
| `POST` | `/proposal-documents/statuses/:memoNo` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L215](pkg/app/routes_discount_proposal.go#L215) |
| `PUT` | `/proposal-documents/statuses/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L216](pkg/app/routes_discount_proposal.go#L216) |
| `PUT` | `/proposal-documents/statuses/finish/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L217](pkg/app/routes_discount_proposal.go#L217) |
| `GET` | `/customer-balances` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L220](pkg/app/routes_discount_proposal.go#L220) |
| `GET` | `/customer-balances/calculator/:period/:customer-id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L221](pkg/app/routes_discount_proposal.go#L221) |
| `PUT` | `/customer-balances` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L222](pkg/app/routes_discount_proposal.go#L222) |
| `GET` | `/credit-notes` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L225](pkg/app/routes_discount_proposal.go#L225) |
| `GET` | `/credit-notes-summary-post` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L226](pkg/app/routes_discount_proposal.go#L226) |
| `GET` | `/credit-notes-summary-post/:amount` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L227](pkg/app/routes_discount_proposal.go#L227) |
| `GET` | `/credit-notes/to-sales-ffs` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L228](pkg/app/routes_discount_proposal.go#L228) |
| `GET` | `/credit-notes/report` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L229](pkg/app/routes_discount_proposal.go#L229) |
| `GET` | `/credit-notes/by-structure/:periodStart/:periodEnd/:periodStructure` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L230](pkg/app/routes_discount_proposal.go#L230) |
| `GET` | `/credit-notes/no-match-sales-ffs` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L231](pkg/app/routes_discount_proposal.go#L231) |
| `POST` | `/credit-notes` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L232](pkg/app/routes_discount_proposal.go#L232) |
| `PUT` | `/credit-notes` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L233](pkg/app/routes_discount_proposal.go#L233) |
| `PUT` | `/credit-notes/closed/:period/:marketingStructureID` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L234](pkg/app/routes_discount_proposal.go#L234) |
| `PUT` | `/credit-notes-summary-post/:period/:discountProposalID/:customerID` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L235](pkg/app/routes_discount_proposal.go#L235) |
| `PUT` | `/credit-notes-summary-post/canceled/:period/:discountProposalID/:customerID` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L236](pkg/app/routes_discount_proposal.go#L236) |
| `DELETE` | `/credit-notes/:period/:discountProposalID/:marketingStructureID/:customerID/:outletID/:productID/:invoice/:invoiceDate/:valueBalance` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L237](pkg/app/routes_discount_proposal.go#L237) |
| `GET` | `/credit-notes-amortization` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L240](pkg/app/routes_discount_proposal.go#L240) |
| `GET` | `/credit-notes-amortization/:amount` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L241](pkg/app/routes_discount_proposal.go#L241) |
| `GET` | `/credit-notes-amortization/groupby-period` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L242](pkg/app/routes_discount_proposal.go#L242) |
| `GET` | `/credit-notes-amortization/payment-schedule` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L243](pkg/app/routes_discount_proposal.go#L243) |
| `POST` | `/credit-notes-amortization/:period` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L244](pkg/app/routes_discount_proposal.go#L244) |
| `PUT` | `/credit-notes-amortization/closed/:period` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L245](pkg/app/routes_discount_proposal.go#L245) |
| `PUT` | `/credit-notes-amortization/approve/:period` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L246](pkg/app/routes_discount_proposal.go#L246) |
| `GET` | `/cqrs-credit-notes-summary-post` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L247](pkg/app/routes_discount_proposal.go#L247) |
| `GET` | `/cqrs-credit-notes-summary-post/promotion` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L248](pkg/app/routes_discount_proposal.go#L248) |
| `GET` | `/cqrs-credit-notes-summary-post/customer` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L249](pkg/app/routes_discount_proposal.go#L249) |
| `GET` | `/call` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L252](pkg/app/routes_discount_proposal.go#L252) |
| `GET` | `/call/:id` | Protected | `mf-micro-service-ski-discount-proposal:8080` | [L253](pkg/app/routes_discount_proposal.go#L253) |


### Routes Distributor

Source: [pkg/app/routes_distributor.go](pkg/app/routes_distributor.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `GET` | `/distributors` | Protected | `mf-micro-service-ski-distributor:8080` | [L7](pkg/app/routes_distributor.go#L7) |
| `GET` | `/distributors/:id` | Protected | `mf-micro-service-ski-distributor:8080` | [L8](pkg/app/routes_distributor.go#L8) |
| `POST` | `/distributors` | Protected | `mf-micro-service-ski-distributor:8080` | [L9](pkg/app/routes_distributor.go#L9) |
| `PUT` | `/distributors/:id` | Protected | `mf-micro-service-ski-distributor:8080` | [L10](pkg/app/routes_distributor.go#L10) |
| `DELETE` | `/distributors/:id` | Protected | `mf-micro-service-ski-distributor:8080` | [L11](pkg/app/routes_distributor.go#L11) |


### Routes Event

Source: [pkg/app/routes_event.go](pkg/app/routes_event.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `GET` | `/events/headers` | Protected | `mf-micro-service-ski-event:8080` | [L7](pkg/app/routes_event.go#L7) |
| `GET` | `/events/headers/:id` | Protected | `mf-micro-service-ski-event:8080` | [L8](pkg/app/routes_event.go#L8) |
| `GET` | `/events/headers-to-class` | Protected | `mf-micro-service-ski-event:8080` | [L9](pkg/app/routes_event.go#L9) |
| `POST` | `/events/headers` | Protected | `mf-micro-service-ski-event:8080` | [L10](pkg/app/routes_event.go#L10) |
| `PUT` | `/events/headers/:id/:periodStart/:periodEnd` | Protected | `mf-micro-service-ski-event:8080` | [L11](pkg/app/routes_event.go#L11) |
| `DELETE` | `/events/headers/:id` | Protected | `mf-micro-service-ski-event:8080` | [L12](pkg/app/routes_event.go#L12) |
| `GET` | `/events/details` | Protected | `mf-micro-service-ski-event:8080` | [L15](pkg/app/routes_event.go#L15) |
| `GET` | `/events/details/:id` | Protected | `mf-micro-service-ski-event:8080` | [L16](pkg/app/routes_event.go#L16) |
| `POST` | `/events/details` | Protected | `mf-micro-service-ski-event:8080` | [L17](pkg/app/routes_event.go#L17) |
| `PUT` | `/events/details/:id` | Protected | `mf-micro-service-ski-event:8080` | [L18](pkg/app/routes_event.go#L18) |
| `DELETE` | `/events/details/:id` | Protected | `mf-micro-service-ski-event:8080` | [L19](pkg/app/routes_event.go#L19) |
| `GET` | `/events/classes` | Protected | `mf-micro-service-ski-event:8080` | [L22](pkg/app/routes_event.go#L22) |
| `GET` | `/events/classes/:id` | Protected | `mf-micro-service-ski-event:8080` | [L23](pkg/app/routes_event.go#L23) |
| `POST` | `/events/classes` | Protected | `mf-micro-service-ski-event:8080` | [L24](pkg/app/routes_event.go#L24) |
| `PUT` | `/events/classes/:id` | Protected | `mf-micro-service-ski-event:8080` | [L25](pkg/app/routes_event.go#L25) |
| `DELETE` | `/events/classes/:id` | Protected | `mf-micro-service-ski-event:8080` | [L26](pkg/app/routes_event.go#L26) |
| `GET` | `/events/organizers` | Protected | `mf-micro-service-ski-event:8080` | [L29](pkg/app/routes_event.go#L29) |
| `GET` | `/events/organizers/:id` | Protected | `mf-micro-service-ski-event:8080` | [L30](pkg/app/routes_event.go#L30) |
| `POST` | `/events/organizers` | Protected | `mf-micro-service-ski-event:8080` | [L31](pkg/app/routes_event.go#L31) |
| `PUT` | `/events/organizers/:id` | Protected | `mf-micro-service-ski-event:8080` | [L32](pkg/app/routes_event.go#L32) |
| `DELETE` | `/events/organizers/:id` | Protected | `mf-micro-service-ski-event:8080` | [L33](pkg/app/routes_event.go#L33) |
| `GET` | `/events/specialists` | Protected | `mf-micro-service-ski-event:8080` | [L36](pkg/app/routes_event.go#L36) |
| `GET` | `/events/specialists/:id` | Protected | `mf-micro-service-ski-event:8080` | [L37](pkg/app/routes_event.go#L37) |
| `POST` | `/events/specialists` | Protected | `mf-micro-service-ski-event:8080` | [L38](pkg/app/routes_event.go#L38) |
| `PUT` | `/events/specialists/:id` | Protected | `mf-micro-service-ski-event:8080` | [L39](pkg/app/routes_event.go#L39) |
| `DELETE` | `/events/specialists/:id` | Protected | `mf-micro-service-ski-event:8080` | [L40](pkg/app/routes_event.go#L40) |


### Routes External

Source: [pkg/app/routes_external.go](pkg/app/routes_external.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `GET` | `/potential_customer_products` | Public | `103.245.16.157:3010` | [L7](pkg/app/routes_external.go#L7) |
| `GET` | `/potential_customer_products/:id` | Public | `103.245.16.157:3010` | [L8](pkg/app/routes_external.go#L8) |
| `POST` | `/potential_customer_products` | Public | `103.245.16.157:3010` | [L9](pkg/app/routes_external.go#L9) |
| `PUT` | `/potential_customer_products/:id` | Public | `103.245.16.157:3010` | [L10](pkg/app/routes_external.go#L10) |
| `DELETE` | `/potential_customer_products/:id` | Public | `103.245.16.157:3010` | [L11](pkg/app/routes_external.go#L11) |
| `GET` | `/division_products` | Public | `103.245.16.157:3010` | [L14](pkg/app/routes_external.go#L14) |
| `GET` | `/division_products/:id` | Public | `103.245.16.157:3010` | [L15](pkg/app/routes_external.go#L15) |
| `POST` | `/division_products` | Public | `103.245.16.157:3010` | [L16](pkg/app/routes_external.go#L16) |
| `PUT` | `/division_products/:id` | Public | `103.245.16.157:3010` | [L17](pkg/app/routes_external.go#L17) |
| `DELETE` | `/division_products/:id` | Public | `103.245.16.157:3010` | [L18](pkg/app/routes_external.go#L18) |
| `GET` | `/sync-ski-failed` | Protected | `103.103.192.208:7777` | [L26](pkg/app/routes_external.go#L26) |
| `DELETE` | `/sync-ski-failed-removed` | Protected | `103.103.192.208:7777` | [L27](pkg/app/routes_external.go#L27) |
| `PUT` | `/sync-ski/:file` | Protected | `103.103.192.208:7777` | [L28](pkg/app/routes_external.go#L28) |


### Routes Master Document

Source: [pkg/app/routes_master_document.go](pkg/app/routes_master_document.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `GET` | `/masters/documents` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L7](pkg/app/routes_master_document.go#L7) |
| `GET` | `/masters/documents/:id` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L8](pkg/app/routes_master_document.go#L8) |
| `POST` | `/masters/documents` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L9](pkg/app/routes_master_document.go#L9) |
| `PUT` | `/masters/documents/:id` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L10](pkg/app/routes_master_document.go#L10) |
| `DELETE` | `/masters/documents/:id` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L11](pkg/app/routes_master_document.go#L11) |
| `GET` | `/discount-proposals/category-headers` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L14](pkg/app/routes_master_document.go#L14) |
| `GET` | `/discount-proposals/category-headers/:id` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L15](pkg/app/routes_master_document.go#L15) |
| `POST` | `/discount-proposals/category-headers` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L16](pkg/app/routes_master_document.go#L16) |
| `PUT` | `/discount-proposals/category-headers/:id` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L17](pkg/app/routes_master_document.go#L17) |
| `DELETE` | `/discount-proposals/category-headers/:id` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L18](pkg/app/routes_master_document.go#L18) |
| `GET` | `/discount-proposals/category-details` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L21](pkg/app/routes_master_document.go#L21) |
| `GET` | `/discount-proposals/category-details/:id` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L22](pkg/app/routes_master_document.go#L22) |
| `POST` | `/discount-proposals/category-details` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L23](pkg/app/routes_master_document.go#L23) |
| `PUT` | `/discount-proposals/category-details/:id` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L24](pkg/app/routes_master_document.go#L24) |
| `DELETE` | `/discount-proposals/category-details/:id` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L25](pkg/app/routes_master_document.go#L25) |
| `GET` | `/file/masters-documents/:file` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L28](pkg/app/routes_master_document.go#L28) |
| `GET` | `/file/withholding-tax-proof/:file` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L29](pkg/app/routes_master_document.go#L29) |
| `GET` | `/file/discount-proposal-return/:file` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L30](pkg/app/routes_master_document.go#L30) |
| `GET` | `/file/cancel-transfer-proof/:file` | Protected | `mf-micro-service-ski-master-document-proposal:8080` | [L31](pkg/app/routes_master_document.go#L31) |


### Routes Outlet

Source: [pkg/app/routes_outlet.go](pkg/app/routes_outlet.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `GET` | `/outlets/groups/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L7](pkg/app/routes_outlet.go#L7) |
| `GET` | `/outlets/groups` | Protected | `mf-micro-service-ski-outlet:8080` | [L8](pkg/app/routes_outlet.go#L8) |
| `POST` | `/outlets/groups` | Protected | `mf-micro-service-ski-outlet:8080` | [L9](pkg/app/routes_outlet.go#L9) |
| `PUT` | `/outlets/groups/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L10](pkg/app/routes_outlet.go#L10) |
| `DELETE` | `/outlets/groups/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L11](pkg/app/routes_outlet.go#L11) |
| `GET` | `/outlets/group-mappings/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L14](pkg/app/routes_outlet.go#L14) |
| `GET` | `/outlets/group-mappings` | Protected | `mf-micro-service-ski-outlet:8080` | [L15](pkg/app/routes_outlet.go#L15) |
| `POST` | `/outlets/group-mappings` | Protected | `mf-micro-service-ski-outlet:8080` | [L16](pkg/app/routes_outlet.go#L16) |
| `PUT` | `/outlets/group-mappings/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L17](pkg/app/routes_outlet.go#L17) |
| `DELETE` | `/outlets/group-mappings/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L18](pkg/app/routes_outlet.go#L18) |
| `GET` | `/outlets/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L21](pkg/app/routes_outlet.go#L21) |
| `GET` | `/outlets` | Protected | `mf-micro-service-ski-outlet:8080` | [L22](pkg/app/routes_outlet.go#L22) |
| `GET` | `/outlets/bridging-outlets` | Protected | `mf-micro-service-ski-outlet:8080` | [L23](pkg/app/routes_outlet.go#L23) |
| `GET` | `/outlets/mapping-customers` | Protected | `mf-micro-service-ski-outlet:8080` | [L24](pkg/app/routes_outlet.go#L24) |
| `POST` | `/outlets` | Protected | `mf-micro-service-ski-outlet:8080` | [L25](pkg/app/routes_outlet.go#L25) |
| `PUT` | `/outlets/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L26](pkg/app/routes_outlet.go#L26) |
| `DELETE` | `/outlets/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L27](pkg/app/routes_outlet.go#L27) |
| `PUT` | `/outlets/:id/merge/:idTarget` | Protected | `mf-micro-service-ski-outlet:8080` | [L28](pkg/app/routes_outlet.go#L28) |
| `GET` | `/outlets/shares` | Protected | `mf-micro-service-ski-outlet:8080` | [L31](pkg/app/routes_outlet.go#L31) |
| `GET` | `/outlets/shares/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L32](pkg/app/routes_outlet.go#L32) |
| `POST` | `/outlets/shares` | Protected | `mf-micro-service-ski-outlet:8080` | [L33](pkg/app/routes_outlet.go#L33) |
| `PUT` | `/outlets/shares/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L34](pkg/app/routes_outlet.go#L34) |
| `DELETE` | `/outlets/shares/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L35](pkg/app/routes_outlet.go#L35) |
| `GET` | `/outlets/types` | Protected | `mf-micro-service-ski-outlet:8080` | [L38](pkg/app/routes_outlet.go#L38) |
| `GET` | `/outlets/types/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L39](pkg/app/routes_outlet.go#L39) |
| `POST` | `/outlets/types` | Protected | `mf-micro-service-ski-outlet:8080` | [L40](pkg/app/routes_outlet.go#L40) |
| `PUT` | `/outlets/types/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L41](pkg/app/routes_outlet.go#L41) |
| `DELETE` | `/outlets/types/:id` | Protected | `mf-micro-service-ski-outlet:8080` | [L42](pkg/app/routes_outlet.go#L42) |


### Routes Product

Source: [pkg/app/routes_product.go](pkg/app/routes_product.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `GET` | `/products/no-auth` | Public | `mf-micro-service-ski-product:8080` | [L7](pkg/app/routes_product.go#L7) |
| `GET` | `/products` | Protected | `mf-micro-service-ski-product:8080` | [L15](pkg/app/routes_product.go#L15) |
| `GET` | `/products/:id` | Protected | `mf-micro-service-ski-product:8080` | [L16](pkg/app/routes_product.go#L16) |
| `POST` | `/products` | Protected | `mf-micro-service-ski-product:8080` | [L17](pkg/app/routes_product.go#L17) |
| `PUT` | `/products/:id` | Protected | `mf-micro-service-ski-product:8080` | [L18](pkg/app/routes_product.go#L18) |
| `DELETE` | `/products/:id` | Protected | `mf-micro-service-ski-product:8080` | [L19](pkg/app/routes_product.go#L19) |
| `GET` | `/products/categories` | Protected | `mf-micro-service-ski-product:8080` | [L22](pkg/app/routes_product.go#L22) |
| `GET` | `/products/categories/:id` | Protected | `mf-micro-service-ski-product:8080` | [L23](pkg/app/routes_product.go#L23) |
| `POST` | `/products/categories` | Protected | `mf-micro-service-ski-product:8080` | [L24](pkg/app/routes_product.go#L24) |
| `PUT` | `/products/categories/:id` | Protected | `mf-micro-service-ski-product:8080` | [L25](pkg/app/routes_product.go#L25) |
| `DELETE` | `/products/categories/:id` | Protected | `mf-micro-service-ski-product:8080` | [L26](pkg/app/routes_product.go#L26) |
| `GET` | `/products/max-discounts` | Protected | `mf-micro-service-ski-product:8080` | [L29](pkg/app/routes_product.go#L29) |
| `GET` | `/products/max-discounts/:id` | Protected | `mf-micro-service-ski-product:8080` | [L30](pkg/app/routes_product.go#L30) |
| `POST` | `/products/max-discounts` | Protected | `mf-micro-service-ski-product:8080` | [L31](pkg/app/routes_product.go#L31) |
| `PUT` | `/products/max-discounts/:programID/:maxDiscount/:periodStart/:periodEnd` | Protected | `mf-micro-service-ski-product:8080` | [L32](pkg/app/routes_product.go#L32) |
| `DELETE` | `/products/max-discounts/:id` | Protected | `mf-micro-service-ski-product:8080` | [L33](pkg/app/routes_product.go#L33) |
| `GET` | `/products/packings` | Protected | `mf-micro-service-ski-product:8080` | [L36](pkg/app/routes_product.go#L36) |
| `GET` | `/products/packings/:id` | Protected | `mf-micro-service-ski-product:8080` | [L37](pkg/app/routes_product.go#L37) |
| `POST` | `/products/packings` | Protected | `mf-micro-service-ski-product:8080` | [L38](pkg/app/routes_product.go#L38) |
| `PUT` | `/products/packings/:id` | Protected | `mf-micro-service-ski-product:8080` | [L39](pkg/app/routes_product.go#L39) |
| `DELETE` | `/products/packings/:id` | Protected | `mf-micro-service-ski-product:8080` | [L40](pkg/app/routes_product.go#L40) |
| `GET` | `/products/pictures` | Protected | `mf-micro-service-ski-product:8080` | [L43](pkg/app/routes_product.go#L43) |
| `GET` | `/products/pictures/:id` | Protected | `mf-micro-service-ski-product:8080` | [L44](pkg/app/routes_product.go#L44) |
| `POST` | `/products/pictures` | Protected | `mf-micro-service-ski-product:8080` | [L45](pkg/app/routes_product.go#L45) |
| `PUT` | `/products/pictures/:id` | Protected | `mf-micro-service-ski-product:8080` | [L46](pkg/app/routes_product.go#L46) |
| `DELETE` | `/products/pictures/:id` | Protected | `mf-micro-service-ski-product:8080` | [L47](pkg/app/routes_product.go#L47) |
| `GET` | `/products/prices` | Protected | `mf-micro-service-ski-product:8080` | [L50](pkg/app/routes_product.go#L50) |
| `GET` | `/products/prices/:id` | Protected | `mf-micro-service-ski-product:8080` | [L51](pkg/app/routes_product.go#L51) |
| `PUT` | `/products/prices/:id` | Protected | `mf-micro-service-ski-product:8080` | [L52](pkg/app/routes_product.go#L52) |
| `POST` | `/products/prices` | Protected | `mf-micro-service-ski-product:8080` | [L53](pkg/app/routes_product.go#L53) |
| `DELETE` | `/products/prices/:id` | Protected | `mf-micro-service-ski-product:8080` | [L54](pkg/app/routes_product.go#L54) |
| `GET` | `/products/programs` | Protected | `mf-micro-service-ski-product:8080` | [L57](pkg/app/routes_product.go#L57) |
| `GET` | `/products/programs/:id` | Protected | `mf-micro-service-ski-product:8080` | [L58](pkg/app/routes_product.go#L58) |
| `POST` | `/products/programs` | Protected | `mf-micro-service-ski-product:8080` | [L59](pkg/app/routes_product.go#L59) |
| `PUT` | `/products/programs/:id` | Protected | `mf-micro-service-ski-product:8080` | [L60](pkg/app/routes_product.go#L60) |
| `DELETE` | `/products/programs/:id` | Protected | `mf-micro-service-ski-product:8080` | [L61](pkg/app/routes_product.go#L61) |
| `GET` | `/products/types` | Protected | `mf-micro-service-ski-product:8080` | [L64](pkg/app/routes_product.go#L64) |
| `GET` | `/products/types/:id` | Protected | `mf-micro-service-ski-product:8080` | [L65](pkg/app/routes_product.go#L65) |
| `POST` | `/products/types` | Protected | `mf-micro-service-ski-product:8080` | [L66](pkg/app/routes_product.go#L66) |
| `PUT` | `/products/types/:id` | Protected | `mf-micro-service-ski-product:8080` | [L67](pkg/app/routes_product.go#L67) |
| `DELETE` | `/products/types/:id` | Protected | `mf-micro-service-ski-product:8080` | [L68](pkg/app/routes_product.go#L68) |
| `GET` | `/products/units` | Protected | `mf-micro-service-ski-product:8080` | [L71](pkg/app/routes_product.go#L71) |
| `GET` | `/products/units/:id` | Protected | `mf-micro-service-ski-product:8080` | [L72](pkg/app/routes_product.go#L72) |
| `POST` | `/products/units` | Protected | `mf-micro-service-ski-product:8080` | [L73](pkg/app/routes_product.go#L73) |
| `PUT` | `/products/units/:id` | Protected | `mf-micro-service-ski-product:8080` | [L74](pkg/app/routes_product.go#L74) |
| `DELETE` | `/products/units/:id` | Protected | `mf-micro-service-ski-product:8080` | [L75](pkg/app/routes_product.go#L75) |
| `GET` | `/principals` | Protected | `mf-micro-service-ski-product:8080` | [L78](pkg/app/routes_product.go#L78) |
| `GET` | `/principals/:id` | Protected | `mf-micro-service-ski-product:8080` | [L79](pkg/app/routes_product.go#L79) |
| `POST` | `/principals` | Protected | `mf-micro-service-ski-product:8080` | [L80](pkg/app/routes_product.go#L80) |
| `PUT` | `/principals/:id` | Protected | `mf-micro-service-ski-product:8080` | [L81](pkg/app/routes_product.go#L81) |
| `DELETE` | `/principals/:id` | Protected | `mf-micro-service-ski-product:8080` | [L82](pkg/app/routes_product.go#L82) |


### Routes Sales

Source: [pkg/app/routes_sales.go](pkg/app/routes_sales.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `POST` | `/sales-ffs/:period/:distributorID` | Public | `mf-micro-service-ski-sales:8080` | [L7](pkg/app/routes_sales.go#L7) |
| `GET` | `/sales-ffs/by/product` | Public | `mf-micro-service-ski-sales:8080` | [L8](pkg/app/routes_sales.go#L8) |
| `POST` | `/sales-ffs/otx/by-email` | Public | `mf-micro-service-ski-sales:8080` | [L9](pkg/app/routes_sales.go#L9) |
| `POST` | `/sales-ffs/sales-morses/by-email-asm` | Public | `mf-micro-service-ski-sales:8080` | [L10](pkg/app/routes_sales.go#L10) |
| `POST` | `/import-sales-distributors/process/:period/:distributorID` | Public | `mf-micro-service-ski-sales:8080` | [L13](pkg/app/routes_sales.go#L13) |
| `POST` | `/sales-principals/:period/:distributorID` | Public | `mf-micro-service-ski-sales:8080` | [L16](pkg/app/routes_sales.go#L16) |
| `GET` | `/hello` | Public | `mf-micro-service-ski-sales:8080` | [L17](pkg/app/routes_sales.go#L17) |
| `GET` | `/stock-distributors` | Public | `mf-micro-service-ski-sales:8080` | [L20](pkg/app/routes_sales.go#L20) |
| `POST` | `/stock-distributors/evaluation/by-email` | Public | `mf-micro-service-ski-sales:8080` | [L21](pkg/app/routes_sales.go#L21) |
| `POST` | `/stock-distributors/vs-stock-product/by-email` | Public | `mf-micro-service-ski-sales:8080` | [L22](pkg/app/routes_sales.go#L22) |
| `POST` | `/distributor-extra-discounts/process/:period` | Public | `mf-micro-service-ski-sales:8080` | [L25](pkg/app/routes_sales.go#L25) |
| `GET` | `/sales-ffs` | Protected | `mf-micro-service-ski-sales:8080` | [L33](pkg/app/routes_sales.go#L33) |
| `GET` | `/sales-ffs/report` | Protected | `mf-micro-service-ski-sales:8080` | [L34](pkg/app/routes_sales.go#L34) |
| `GET` | `/sales-ffs/sales-net-by-u` | Protected | `mf-micro-service-ski-sales:8080` | [L35](pkg/app/routes_sales.go#L35) |
| `GET` | `/sales-ffs/sales-by-achievement` | Protected | `mf-micro-service-ski-sales:8080` | [L36](pkg/app/routes_sales.go#L36) |
| `GET` | `/sales-ffs/sales-by-sector` | Protected | `mf-micro-service-ski-sales:8080` | [L37](pkg/app/routes_sales.go#L37) |
| `GET` | `/sales-ffs/by-structure/:periodStart/:periodEnd/:periodStructure` | Protected | `mf-micro-service-ski-sales:8080` | [L38](pkg/app/routes_sales.go#L38) |
| `GET` | `/sales-ffs/:period/outlet-non-bridging` | Protected | `mf-micro-service-ski-sales:8080` | [L39](pkg/app/routes_sales.go#L39) |
| `GET` | `/sales-ffs/sales-vs-cn/:period` | Protected | `mf-micro-service-ski-sales:8080` | [L40](pkg/app/routes_sales.go#L40) |
| `GET` | `/sales-ffs/sales-vs-target/:period` | Protected | `mf-micro-service-ski-sales:8080` | [L41](pkg/app/routes_sales.go#L41) |
| `GET` | `/sales-ffs/summary-by-period/:periodStart/:periodEnd` | Protected | `mf-micro-service-ski-sales:8080` | [L42](pkg/app/routes_sales.go#L42) |
| `PUT` | `/sales-ffs/closed/:period` | Protected | `mf-micro-service-ski-sales:8080` | [L43](pkg/app/routes_sales.go#L43) |
| `POST` | `/sales-ffs/process-warehouse/outlet-non-bridding/:periodStart/:periodEnd` | Protected | `mf-micro-service-ski-sales:8080` | [L44](pkg/app/routes_sales.go#L44) |
| `GET` | `/target-marketings` | Protected | `mf-micro-service-ski-sales:8080` | [L47](pkg/app/routes_sales.go#L47) |
| `GET` | `/target-marketings/headers` | Protected | `mf-micro-service-ski-sales:8080` | [L48](pkg/app/routes_sales.go#L48) |
| `GET` | `/target-marketings/details` | Protected | `mf-micro-service-ski-sales:8080` | [L49](pkg/app/routes_sales.go#L49) |
| `POST` | `/target-marketings/:period` | Protected | `mf-micro-service-ski-sales:8080` | [L50](pkg/app/routes_sales.go#L50) |
| `PUT` | `/target-marketings` | Protected | `mf-micro-service-ski-sales:8080` | [L51](pkg/app/routes_sales.go#L51) |
| `DELETE` | `/target-marketings/:period/:codeMr/:productID` | Protected | `mf-micro-service-ski-sales:8080` | [L52](pkg/app/routes_sales.go#L52) |
| `GET` | `/sales-out/:period/:code/:type/:groupby` | Protected | `mf-micro-service-ski-sales:8080` | [L55](pkg/app/routes_sales.go#L55) |
| `GET` | `/bridgings/outlets` | Protected | `mf-micro-service-ski-sales:8080` | [L58](pkg/app/routes_sales.go#L58) |
| `GET` | `/bridgings/outlets/:id` | Protected | `mf-micro-service-ski-sales:8080` | [L59](pkg/app/routes_sales.go#L59) |
| `POST` | `/bridgings/outlets` | Protected | `mf-micro-service-ski-sales:8080` | [L60](pkg/app/routes_sales.go#L60) |
| `PUT` | `/bridgings/outlets/:id` | Protected | `mf-micro-service-ski-sales:8080` | [L61](pkg/app/routes_sales.go#L61) |
| `DELETE` | `/bridgings/outlets/:id` | Protected | `mf-micro-service-ski-sales:8080` | [L62](pkg/app/routes_sales.go#L62) |
| `GET` | `/bridgings/products` | Protected | `mf-micro-service-ski-sales:8080` | [L65](pkg/app/routes_sales.go#L65) |
| `GET` | `/bridgings/products/:id` | Protected | `mf-micro-service-ski-sales:8080` | [L66](pkg/app/routes_sales.go#L66) |
| `POST` | `/bridgings/products` | Protected | `mf-micro-service-ski-sales:8080` | [L67](pkg/app/routes_sales.go#L67) |
| `PUT` | `/bridgings/products/:id` | Protected | `mf-micro-service-ski-sales:8080` | [L68](pkg/app/routes_sales.go#L68) |
| `DELETE` | `/bridgings/products/:id` | Protected | `mf-micro-service-ski-sales:8080` | [L69](pkg/app/routes_sales.go#L69) |
| `GET` | `/sales-distributors` | Protected | `mf-micro-service-ski-sales:8080` | [L72](pkg/app/routes_sales.go#L72) |
| `GET` | `/sales-distributors/sales-ffs` | Protected | `mf-micro-service-ski-sales:8080` | [L73](pkg/app/routes_sales.go#L73) |
| `GET` | `/report-sales/by/level` | Protected | `mf-micro-service-ski-sales:8080` | [L74](pkg/app/routes_sales.go#L74) |
| `GET` | `/report-sales/no-claim` | Protected | `mf-micro-service-ski-sales:8080` | [L75](pkg/app/routes_sales.go#L75) |
| `GET` | `/distributor-extra-discounts` | Protected | `mf-micro-service-ski-sales:8080` | [L78](pkg/app/routes_sales.go#L78) |
| `GET` | `/distributor-extra-discount-claims` | Protected | `mf-micro-service-ski-sales:8080` | [L81](pkg/app/routes_sales.go#L81) |
| `POST` | `/distributor-extra-discount-claims` | Protected | `mf-micro-service-ski-sales:8080` | [L82](pkg/app/routes_sales.go#L82) |
| `PUT` | `/distributor-extra-discount-claims/:id` | Protected | `mf-micro-service-ski-sales:8080` | [L83](pkg/app/routes_sales.go#L83) |
| `DELETE` | `/distributor-extra-discount-claims/:id` | Protected | `mf-micro-service-ski-sales:8080` | [L84](pkg/app/routes_sales.go#L84) |
| `GET` | `/sales-principals` | Protected | `mf-micro-service-ski-sales:8080` | [L87](pkg/app/routes_sales.go#L87) |
| `GET` | `/sales-principals/:header/distributors` | Protected | `mf-micro-service-ski-sales:8080` | [L88](pkg/app/routes_sales.go#L88) |
| `GET` | `/sales-principals/unregistered-territory-outlets/:period` | Protected | `mf-micro-service-ski-sales:8080` | [L89](pkg/app/routes_sales.go#L89) |
| `PUT` | `/sales-principals/closed/:period` | Protected | `mf-micro-service-ski-sales:8080` | [L90](pkg/app/routes_sales.go#L90) |
| `GET` | `/sales-shares` | Protected | `mf-micro-service-ski-sales:8080` | [L93](pkg/app/routes_sales.go#L93) |
| `POST` | `/sales-shares` | Protected | `mf-micro-service-ski-sales:8080` | [L94](pkg/app/routes_sales.go#L94) |
| `DELETE` | `/sales-shares/:period/:outletHeaderID/:outletSubID/:productID/:dldfID/:marketingStructureID/:invoice/:batch` | Protected | `mf-micro-service-ski-sales:8080` | [L95](pkg/app/routes_sales.go#L95) |
| `GET` | `/work-calendars` | Protected | `mf-micro-service-ski-sales:8080` | [L98](pkg/app/routes_sales.go#L98) |
| `PUT` | `/work-calendars` | Protected | `mf-micro-service-ski-sales:8080` | [L99](pkg/app/routes_sales.go#L99) |
| `DELETE` | `/work-calendars/:period` | Protected | `mf-micro-service-ski-sales:8080` | [L100](pkg/app/routes_sales.go#L100) |


### Routes Structure

Source: [pkg/app/routes_structure.go](pkg/app/routes_structure.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `GET` | `/marketings/structures/:id/user` | Public | `mf-micro-service-ski-structure:8080` | [L7](pkg/app/routes_structure.go#L7) |
| `GET` | `/marketings/structures-all-levels` | Public | `mf-micro-service-ski-structure:8080` | [L8](pkg/app/routes_structure.go#L8) |
| `POST` | `/marketings/structures/process-data/:period` | Public | `mf-micro-service-ski-structure:8080` | [L9](pkg/app/routes_structure.go#L9) |
| `POST` | `/warehouse/structure-ethical/process/:period` | Public | `mf-micro-service-ski-structure:8080` | [L10](pkg/app/routes_structure.go#L10) |
| `POST` | `/ski/marketing-structure-all-levels/process/:period` | Public | `mf-micro-service-ski-structure:8080` | [L11](pkg/app/routes_structure.go#L11) |
| `PUT` | `/marketings/structures/closed_edit_all/:period` | Public | `mf-micro-service-ski-structure:8080` | [L12](pkg/app/routes_structure.go#L12) |
| `GET` | `/marketing-structure-all-levels/subordinates` | Public | `mf-micro-service-ski-structure:8080` | [L13](pkg/app/routes_structure.go#L13) |
| `GET` | `/marketings/structures-subordinates-no-auth` | Public | `mf-micro-service-ski-structure:8080` | [L14](pkg/app/routes_structure.go#L14) |
| `GET` | `/marketings/structures/territories/customers-no-auth` | Public | `mf-micro-service-ski-structure:8080` | [L17](pkg/app/routes_structure.go#L17) |
| `GET` | `/marketings/structures/territories/customers/by-structure-no-auth` | Public | `mf-micro-service-ski-structure:8080` | [L18](pkg/app/routes_structure.go#L18) |
| `GET` | `/marketings/structures/territories/outlets-no-auth` | Public | `mf-micro-service-ski-structure:8080` | [L21](pkg/app/routes_structure.go#L21) |
| `GET` | `/marketings/structures/territories/outlets/by-structure-no-auth` | Public | `mf-micro-service-ski-structure:8080` | [L22](pkg/app/routes_structure.go#L22) |
| `GET` | `/marketings/structures-no-auth` | Public | `mf-micro-service-ski-structure:8080` | [L25](pkg/app/routes_structure.go#L25) |
| `GET` | `/marketings/structures` | Protected | `mf-micro-service-ski-structure:8080` | [L33](pkg/app/routes_structure.go#L33) |
| `GET` | `/marketings/structures/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L34](pkg/app/routes_structure.go#L34) |
| `GET` | `/marketings/structures-get-boss/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L35](pkg/app/routes_structure.go#L35) |
| `GET` | `/marketings/structures-find/:period/:city/:level/:division` | Protected | `mf-micro-service-ski-structure:8080` | [L36](pkg/app/routes_structure.go#L36) |
| `GET` | `/marketings/structures-duplicate` | Protected | `mf-micro-service-ski-structure:8080` | [L37](pkg/app/routes_structure.go#L37) |
| `GET` | `/marketings/structures-filter/:period/:level/:code` | Protected | `mf-micro-service-ski-structure:8080` | [L38](pkg/app/routes_structure.go#L38) |
| `GET` | `/marketings/structures/with-join-date` | Protected | `mf-micro-service-ski-structure:8080` | [L39](pkg/app/routes_structure.go#L39) |
| `POST` | `/marketings/structures` | Protected | `mf-micro-service-ski-structure:8080` | [L40](pkg/app/routes_structure.go#L40) |
| `PUT` | `/marketings/structures/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L41](pkg/app/routes_structure.go#L41) |
| `PUT` | `/marketings/structures/closed_edit_area/:period` | Protected | `mf-micro-service-ski-structure:8080` | [L42](pkg/app/routes_structure.go#L42) |
| `PUT` | `/marketings/structures/:id/merge/:marketingStructureID/:isAll` | Protected | `mf-micro-service-ski-structure:8080` | [L43](pkg/app/routes_structure.go#L43) |
| `DELETE` | `/marketings/structures/:id/:period` | Protected | `mf-micro-service-ski-structure:8080` | [L44](pkg/app/routes_structure.go#L44) |
| `GET` | `/marketings/structures/areas` | Protected | `mf-micro-service-ski-structure:8080` | [L47](pkg/app/routes_structure.go#L47) |
| `GET` | `/marketings/structures/areas/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L48](pkg/app/routes_structure.go#L48) |
| `POST` | `/marketings/structures/areas` | Protected | `mf-micro-service-ski-structure:8080` | [L49](pkg/app/routes_structure.go#L49) |
| `PUT` | `/marketings/structures/areas/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L50](pkg/app/routes_structure.go#L50) |
| `DELETE` | `/marketings/structures/areas/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L51](pkg/app/routes_structure.go#L51) |
| `GET` | `/marketings/structures/territories/customers` | Protected | `mf-micro-service-ski-structure:8080` | [L54](pkg/app/routes_structure.go#L54) |
| `GET` | `/marketings/structures/territories/customers/events` | Protected | `mf-micro-service-ski-structure:8080` | [L55](pkg/app/routes_structure.go#L55) |
| `GET` | `/marketings/structures/territories/customers/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L56](pkg/app/routes_structure.go#L56) |
| `POST` | `/marketings/structures/territories/customers` | Protected | `mf-micro-service-ski-structure:8080` | [L57](pkg/app/routes_structure.go#L57) |
| `DELETE` | `/marketings/structures/territories/customers/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L58](pkg/app/routes_structure.go#L58) |
| `GET` | `/marketings/structures/territories/outlets` | Protected | `mf-micro-service-ski-structure:8080` | [L61](pkg/app/routes_structure.go#L61) |
| `GET` | `/marketings/structures/territories/outlets/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L62](pkg/app/routes_structure.go#L62) |
| `POST` | `/marketings/structures/territories/outlets` | Protected | `mf-micro-service-ski-structure:8080` | [L63](pkg/app/routes_structure.go#L63) |
| `PUT` | `/marketings/structures/territories/outlets/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L64](pkg/app/routes_structure.go#L64) |
| `DELETE` | `/marketings/structures/territories/outlets/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L65](pkg/app/routes_structure.go#L65) |
| `GET` | `/marketings/positions` | Protected | `mf-micro-service-ski-structure:8080` | [L68](pkg/app/routes_structure.go#L68) |
| `GET` | `/marketings/positions/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L69](pkg/app/routes_structure.go#L69) |
| `POST` | `/marketings/positions` | Protected | `mf-micro-service-ski-structure:8080` | [L70](pkg/app/routes_structure.go#L70) |
| `PUT` | `/marketings/positions/:id/:period` | Protected | `mf-micro-service-ski-structure:8080` | [L71](pkg/app/routes_structure.go#L71) |
| `DELETE` | `/marketings/positions/:id/:period` | Protected | `mf-micro-service-ski-structure:8080` | [L72](pkg/app/routes_structure.go#L72) |
| `GET` | `/offices` | Protected | `mf-micro-service-ski-structure:8080` | [L75](pkg/app/routes_structure.go#L75) |
| `GET` | `/offices/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L76](pkg/app/routes_structure.go#L76) |
| `POST` | `/offices` | Protected | `mf-micro-service-ski-structure:8080` | [L77](pkg/app/routes_structure.go#L77) |
| `PUT` | `/offices/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L78](pkg/app/routes_structure.go#L78) |
| `DELETE` | `/offices/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L79](pkg/app/routes_structure.go#L79) |
| `GET` | `/hierarchies` | Protected | `mf-micro-service-ski-structure:8080` | [L82](pkg/app/routes_structure.go#L82) |
| `GET` | `/hierarchies/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L83](pkg/app/routes_structure.go#L83) |
| `GET` | `/hierarchies-csv` | Protected | `mf-micro-service-ski-structure:8080` | [L84](pkg/app/routes_structure.go#L84) |
| `POST` | `/hierarchies` | Protected | `mf-micro-service-ski-structure:8080` | [L85](pkg/app/routes_structure.go#L85) |
| `PUT` | `/hierarchies/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L86](pkg/app/routes_structure.go#L86) |
| `DELETE` | `/hierarchies/:id` | Protected | `mf-micro-service-ski-structure:8080` | [L87](pkg/app/routes_structure.go#L87) |
| `POST` | `/customers/profile` | Protected | `mf-micro-service-ski-structure:8080` | [L90](pkg/app/routes_structure.go#L90) |
| `DELETE` | `/customers/profile/:customerID/:category/:flag/:data/:value` | Protected | `mf-micro-service-ski-structure:8080` | [L91](pkg/app/routes_structure.go#L91) |
| `PUT` | `/customers/profile/:customerID` | Protected | `mf-micro-service-ski-structure:8080` | [L92](pkg/app/routes_structure.go#L92) |


### Routes Warehouse

Source: [pkg/app/routes_warehouse.go](pkg/app/routes_warehouse.go).

| Method | Path | Auth collection | Upstream | Source |
| --- | --- | --- | --- | --- |
| `GET` | `/ski/structure/performance` | Public | `mf-micro-service-ski-warehouse:8080` | [L7](pkg/app/routes_warehouse.go#L7) |
| `POST` | `/ski/structure/performance` | Public | `mf-micro-service-ski-warehouse:8080` | [L8](pkg/app/routes_warehouse.go#L8) |
| `POST` | `/ski/period` | Public | `mf-micro-service-ski-warehouse:8080` | [L11](pkg/app/routes_warehouse.go#L11) |
| `GET` | `/summary_ffs` | Public | `mf-micro-service-summaryff:8080` | [L14](pkg/app/routes_warehouse.go#L14) |
| `POST` | `/summary_ffs` | Public | `mf-micro-service-summaryff:8080` | [L15](pkg/app/routes_warehouse.go#L15) |
| `GET` | `/summary_ffs_year/headers` | Public | `mf-micro-service-summaryff:8080` | [L18](pkg/app/routes_warehouse.go#L18) |
| `GET` | `/summary_ffs_year/details` | Public | `mf-micro-service-summaryff:8080` | [L19](pkg/app/routes_warehouse.go#L19) |
| `POST` | `/credit-note/warehouse/process/:period` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L22](pkg/app/routes_warehouse.go#L22) |
| `POST` | `/credit-note/warehouse/ski-header/process/:no-ski` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L23](pkg/app/routes_warehouse.go#L23) |
| `POST` | `/credit-note/warehouse/ski-payment/process/:no-ski` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L24](pkg/app/routes_warehouse.go#L24) |
| `POST` | `/credit-note/warehouse/ski-credit-note-process/:no-ski` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L25](pkg/app/routes_warehouse.go#L25) |
| `POST` | `/discount/warehouse/process/:period` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L28](pkg/app/routes_warehouse.go#L28) |
| `GET` | `/report/evaluation-ski2/estimation-vs-realization` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L29](pkg/app/routes_warehouse.go#L29) |
| `POST` | `/ski/warehouse/process/:period/:no-ski` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L30](pkg/app/routes_warehouse.go#L30) |
| `POST` | `/ski/warehouse/ski-header/:no-ski` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L31](pkg/app/routes_warehouse.go#L31) |
| `POST` | `/ski/warehouse/ski-payment/:no-ski` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L32](pkg/app/routes_warehouse.go#L32) |
| `POST` | `/ski/warehouse/ski-credit-note/:no-ski` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L33](pkg/app/routes_warehouse.go#L33) |
| `GET` | `/sales-target/achievement/:period/by/:code` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L36](pkg/app/routes_warehouse.go#L36) |
| `POST` | `/warehouse/sales-out/process/:period/:distributorId` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L37](pkg/app/routes_warehouse.go#L37) |
| `POST` | `/warehouse/target-marketing/process/:period` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L40](pkg/app/routes_warehouse.go#L40) |
| `POST` | `/warehouse/sales-stock-principal/process/meta_base/:period` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L43](pkg/app/routes_warehouse.go#L43) |
| `POST` | `/warehouse/sales-stock-distributor/process/meta_base/:period` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L44](pkg/app/routes_warehouse.go#L44) |
| `POST` | `/warehouse/report-bp-teguh/process/:period` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L45](pkg/app/routes_warehouse.go#L45) |
| `POST` | `/warehouse/stock-distributor/process/:period` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L48](pkg/app/routes_warehouse.go#L48) |
| `POST` | `/warehouse/stock/process/:period` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L49](pkg/app/routes_warehouse.go#L49) |
| `GET` | `/stock-distributor/:period/:productID/:distributorID` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L50](pkg/app/routes_warehouse.go#L50) |
| `POST` | `/warehouse/k4/process/:period` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L53](pkg/app/routes_warehouse.go#L53) |
| `POST` | `/warehouse/structure-new/process/:period` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L56](pkg/app/routes_warehouse.go#L56) |
| `POST` | `/warehouse/marketing-absent/process/:period` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L59](pkg/app/routes_warehouse.go#L59) |
| `GET` | `/warehouse/gt-outlet-headers` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L62](pkg/app/routes_warehouse.go#L62) |
| `POST` | `/warehouse/gt-outlet-headers/process/:period` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L63](pkg/app/routes_warehouse.go#L63) |
| `GET` | `/warehouse/gt-customer-headers` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L66](pkg/app/routes_warehouse.go#L66) |
| `GET` | `/warehouse/gt-product-headers/by-product` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L69](pkg/app/routes_warehouse.go#L69) |
| `GET` | `/warehouse/customer-estimation-vs-cn` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L72](pkg/app/routes_warehouse.go#L72) |
| `POST` | `/warehouse/customer-estimation-vs-cn/process/:period` | Public | `mf-micro-service-ski-compliance-warehouse:8080` | [L73](pkg/app/routes_warehouse.go#L73) |
| `GET` | `/discount/warehouse` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L81](pkg/app/routes_warehouse.go#L81) |
| `GET` | `/discount/warehouse/gt/headers` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L84](pkg/app/routes_warehouse.go#L84) |
| `GET` | `/discount/warehouse/gt/details` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L85](pkg/app/routes_warehouse.go#L85) |
| `GET` | `/discount/warehouse/gt/products/headers` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L88](pkg/app/routes_warehouse.go#L88) |
| `GET` | `/discount/warehouse/gt/products/details` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L89](pkg/app/routes_warehouse.go#L89) |
| `GET` | `/discount/warehouse/gt/outlets/headers` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L92](pkg/app/routes_warehouse.go#L92) |
| `GET` | `/discount/warehouse/gt/outlets/details` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L93](pkg/app/routes_warehouse.go#L93) |
| `GET` | `/discount/warehouse/gt/customers/headers` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L96](pkg/app/routes_warehouse.go#L96) |
| `GET` | `/discount/warehouse/gt/customers/details` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L97](pkg/app/routes_warehouse.go#L97) |
| `GET` | `/credit-note/warehouse` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L100](pkg/app/routes_warehouse.go#L100) |
| `GET` | `/credit-note/warehouse/gt/headers` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L103](pkg/app/routes_warehouse.go#L103) |
| `GET` | `/credit-note/warehouse/gt/details` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L104](pkg/app/routes_warehouse.go#L104) |
| `GET` | `/credit-note/warehouse/gt/products/headers` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L107](pkg/app/routes_warehouse.go#L107) |
| `GET` | `/credit-note/warehouse/gt/products/details` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L108](pkg/app/routes_warehouse.go#L108) |
| `GET` | `/credit-note/warehouse/gt/outlets/headers` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L111](pkg/app/routes_warehouse.go#L111) |
| `GET` | `/credit-note/warehouse/gt/outlets/details` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L112](pkg/app/routes_warehouse.go#L112) |
| `GET` | `/credit-note/warehouse/gt/customers/headers` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L115](pkg/app/routes_warehouse.go#L115) |
| `GET` | `/credit-note/warehouse/gt/customers/details` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L116](pkg/app/routes_warehouse.go#L116) |
| `GET` | `/sales/gt/outlet` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L119](pkg/app/routes_warehouse.go#L119) |
| `GET` | `/sales/gt/product` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L122](pkg/app/routes_warehouse.go#L122) |
| `GET` | `/sales/gt` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L125](pkg/app/routes_warehouse.go#L125) |
| `GET` | `/customer-tasks` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L128](pkg/app/routes_warehouse.go#L128) |
| `GET` | `/customer-timelines` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L131](pkg/app/routes_warehouse.go#L131) |
| `GET` | `/customer-notes` | Protected | `mf-micro-service-ski-compliance-warehouse:8080` | [L134](pkg/app/routes_warehouse.go#L134) |


## Database and integration notes

The gateway forwards requests rather than owning these downstream schemas. Review `helper/reverse_proxy.go`, the route target table above, API-key handling and `pkg/auth/` when changing access or proxy behavior. A route in this gateway is not proof the target service implements the same method/path.

## Quality and deployment

Useful checks, to run in an appropriate development environment:

```sh
go build ./...
go test ./...
go vet ./...
```

No application tests, service startup, deployment or database mutations were performed for this README update. Existing coverage files or badges are not a fresh coverage measurement.

Container definition: [Dockerfile](Dockerfile). Base stages: `golang:1.23`.

```sh
docker build -t ski-api-gateway:local .
```

Review [docker-compose.yml](docker-compose.yml) for environment files, mounts, networks and host port mapping before running Compose.

Project-specific commands are defined in [Makefile](Makefile). Inspect prerequisites and side effects before invoking deployment or generation targets.

## Documentation provenance

Updated on 2026-09-27 from the current local source/configuration. The discount-proposal README supplied the section structure; endpoint, version and configuration facts were extracted from this repository. Source declarations and local changes are not deployment verification.

Additional investigation guidance: [AGENTS.md](AGENTS.md).
