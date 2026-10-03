# Changelog & AI Engineering Guidance History

All notable changes and commit history are documented in this file.

## Riwayat Commit

## 2026-09-22 — `merge: resolve conflicts and integrate latest upstream subordinate & sales routes`

- Resolved merge conflicts with `origin/add-endpoint-structure-subordinates-no-auth` (releases up to `v0.2.92-release`).
- Integrated new subordinate and territory no-auth routes into `pkg/app/routes_structure.go` (`/marketing-structure-all-levels/subordinates`, `/marketings/structures-subordinates-no-auth`, `/marketings/structures/territories/customers/by-structure-no-auth`, `/marketings/structures/territories/outlets/by-structure-no-auth`).
- Integrated new sales analysis and ASM email endpoints into `pkg/app/routes_sales.go` (`/sales-ffs/sales-morses/by-email-asm`, `/sales-ffs/sales-net-by-u`, `/sales-ffs/sales-by-achievement`, `/sales-ffs/sales-by-sector`, `/sales-ffs/sales-vs-cn/:period`, `/sales-ffs/sales-vs-target/:period`, `/sales-ffs/summary-by-period/:periodStart/:periodEnd`).
- Integrated new proposal payment summary, calculator, and transfer-array endpoints into `pkg/app/routes_discount_proposal.go` (`/discount-proposals/payments/summary/:period`, `/discount-proposals/report/dldf/summary-qty`, `/analysis-ski/calculation/:period/:customerID/:structureID`, `/analysis-ski/calculator/:period/:customerID`, `/analysis-ski/calculator/:period/:customerID/excel`, `/discount-proposals/payments/period-summary/:periodStart/:periodEnd`, `/discount-proposals/payments/update/transfer-array`, `/customer-balances/calculator/:period/:customer-id`).
- Verified zero route regressions, test suites passing across all packages with >=90.0% statement coverage.

## 2026-09-22 — `refactor(router): modularize route registration by domain and auth scope`

- Refactored monolithic `pkg/app/router.go` into 14 domain-specific route modules separated by authentication requirement (`publicRoutes` vs `protectedRoutes`).
- Added modular route files in `pkg/app/`:
  - `routes_auth.go`: `ski-auth` & `ski-marketing-user` endpoints (login, refresh-token, users, menus, divisions, group authentications).
  - `routes_warehouse.go`: `ski-warehouse`, `summaryff`, and `ski-compliance-warehouse` data aggregation endpoints.
  - `routes_discount_proposal.go`: `ski-discount-proposal` endpoints for proposals, calculations, limits, payments, memo, and realization.
  - `routes_sales.go`: `ski-sales` endpoints for sales FF, distributors, principals, bridgings, targets, and calendars.
  - `routes_structure.go`: `ski-structure` endpoints for structures, areas, customer/outlet territories, positions, offices, and hierarchies.
  - `routes_customer.go`: `ski-customer` endpoints for customer master, inactive statuses, positions, specialists, and territory mappings.
  - `routes_product.go`: `ski-product` endpoints for product catalog, categories, pricing, programs, max discounts, and principals.
  - `routes_outlet.go`: `ski-outlet` endpoints for outlets, groups, group mappings, shares, and outlet types.
  - `routes_bank.go`: `ski-bank` endpoints for banks, branches, transfer fees, accounts, and transfer types.
  - `routes_city.go`: `ski-city` endpoints for city master records and CSV exports.
  - `routes_distributor.go`: `ski-distributor` endpoints for distributor master records.
  - `routes_event.go`: `ski-event` endpoints for event headers, details, classes, organizers, and specialists.
  - `routes_master_document.go`: `ski-master-document-proposal` endpoints for proposal document templates, category headers/details, and file downloads.
  - `routes_external.go`: Integration endpoints for Nocode visitflow/division products (`103.245.16.157:3010`) and Sync SKI service (`103.103.192.208:7777`).
- Fixed port parsing in `cmd/main.go` to automatically prepend leading colon when listening on numeric port addresses (resolving `missing port in address` panic on `make server`).
- Masked sensitive JWT secret keys in `README.md` with `***` to ensure credentials protection.
- Integrated automated statement test coverage calculation script (`scripts/update_coverage.py`), achieving 91.4% statement coverage across all packages.
- Added comprehensive unit and integration test suites in `test/` for all router domains, middleware, and security components.
- Established foundational AI engineering guidance, repository documentation, and task-specific skills in `AGENTS.md` and `.agent/`.

## 2026-09-27 — Evidence-first guidance rollout

- Unified selective entry points and CLAUDE imports; linked workspace data-first and environment/confirmation rules.
- Added maintenance guidance, current source/test inventory and explicit evidence limits.
- Clarified compatibility exceptions and requested-test policy over inherited blanket rules; retained detailed historical topics.
- Documentation only: no application source, dependency, runtime or database changes; no tests/build/startup performed.

## 2026-09-27 — `docs: improve AI agent guidance`

- Added selective task entry points, shared workspace data-first and database environment rules, and Claude Code guidance.
- Recorded repository-specific evidence/limits and current testing inventory; clarified that historical assertions are not current verification.
- Preserved existing source and user changes; documentation only.
