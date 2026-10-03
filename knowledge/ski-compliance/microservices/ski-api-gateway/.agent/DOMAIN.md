# .agent/DOMAIN.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Domain Overview: SKI Compliance Ecosystem

The SKI (Surat Keputusan Insentif) Compliance ecosystem is an enterprise pharma and marketing compliance platform. `ski-api-gateway` routes and governs requests across all domain modules.

---

## Core Domain Modules Routed by Gateway

### 1. Authentication & Identity (`mf-micro-service-ski-auth`, `mf-micro-service-ski-marketing-user`)
- **Login & Token Refresh**: Public entrypoints (`/users/login`, `/users/refresh-token`) returning JWT access and refresh tokens.
- **User Management**: Protected user CRUD (`/users`, `/users/:id`, `/users-change-password/:id`, `/users-reset-password/:id`).
- **Role Constants**: Administrator, Marketing roles, Field Force (FF).

### 2. Discount Proposal & Approvals (`mf-micro-service-ski-discount-proposal`)
- **Proposal Lifecycle**: Creation, verification, limit discount calculations, confirmations, and termination (`/discount-proposals/*`).
- **Payment & Realization**: Payment memo creation, transfer printouts, PSI payments, and disbursement calculations (`/discount-proposals/payments/*`).
- **Credit Notes**: Evaluation, realization, closed periods, and summary posting (`/credit-notes/*`).

### 3. Compliance Warehouse & Reporting (`mf-micro-service-ski-compliance-warehouse`, `mf-micro-service-summaryff`)
- **Warehouse ETL & Process**: Period batching, target marketing, sales-out processing, and K4 evaluations (`/warehouse/*`, `/credit-note/warehouse/*`).
- **Summary FF**: Field Force performance summaries and yearly breakdowns (`/summary_ffs`, `/summary_ffs_year/*`).
- **Metabase & Reporting**: Sales-stock principal and distributor syncs.

### 4. Marketing Structure & Hierarchy (`mf-micro-service-ski-structure`)
- **Structure Levels**: All-level hierarchy definitions and period processing (`/marketings/structures*`).
- **Territory Mapping**: Customer and outlet territory assignments (`/marketings/structures/territories/*`).

### 5. Products & Pricing (`mf-micro-service-ski-product`)
- **Master Data**: Products, categories, packaging, pricing, pictures, units, and types (`/products/*`).
- **Discount Ceilings**: Maximum discount rules and program ceilings (`/products/max-discounts/*`).

### 6. Customer & Outlet Masters (`mf-micro-service-ski-customer`, `mf-micro-service-ski-outlet`)
- **Customers**: Specialist classifications, inactive statuses, position mappings, and territory linkages (`/customers/*`).
- **Outlets**: Outlet groups, bridging outlets, shares, and outlet types (`/outlets/*`).

### 7. Banking & Finance (`mf-micro-service-ski-bank`, `mf-micro-service-ski-city`)
- **Bank Master**: Banks, branch offices, transfer fees, and account verifications (`/banks/*`, `/accounts/*`).
- **Geographic Data**: Cities and regions (`/cities/*`).
