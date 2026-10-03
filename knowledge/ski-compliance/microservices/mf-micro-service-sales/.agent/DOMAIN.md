# Domain Rules & Business Logic — MF Micro Service Sales

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document explains the business domains, core entities, business invariants, and workflows managed by `mf-micro-service-sales`.

---

## 1. Major Domains

### A. Bridging (Outlet & Product)
- **Problem**: Distributors use proprietary naming and internal IDs for hospital/pharmacy outlets and pharmaceutical products. The microservice standardizes these into canonical SKI entities.
- **Entities**:
  - `BridgingOutlet`: Maps `OutletDistributorID` + `DistributorID` + `BranchDistributorID` -> `OutletID` ([model/domain/bridging_outlet.go](../model/domain/bridging_outlet.go)).
  - `BridgingProduct`: Maps `ProductDistributorID` + `DistributorID` -> `ProductID` ([model/domain/bridging_product.go](../model/domain/bridging_product.go)).
- **Key Fields**:
  - `OutletUpdated` (boolean pointer): Tracks whether bridging information has been updated for downstream sync.
  - Unique composite index: `idx_bridging_outlet` on (`DistributorID`, `OutletID`, `OutletDistributorID`).

### B. Sales Field Force (`SalesFf`)
- **Entities**: `SalesFf`, `SalesFfView`, `ReportSalesFf`, `SalesFfTargetByAsm` ([model/domain/sales_ff.go](../model/domain/sales_ff.go)).
- **Primary Key**: Composite (`Period`, `OutletID`, `ProductID`, `Invoice`, `DiscountOnPrincipal`, `MarketingStructureID`).
- **Hierarchy of Field Force Roles**:
  - **MR**: Medical Representative
  - **SPV**: Supervisor (`SPVCode`, `SPVName`)
  - **ASM**: Area Sales Manager (`ASMCode`, `ASMName`)
  - **FSM**: Field Sales Manager (`FSMCode`, `FSMName`)
- **Key Metrics**:
  - `Qty` & `ValueSales`: Gross sales quantity and monetary amount.
  - `QtyClaim` & `TotalClaim`: Discount claim quantities and amounts.
  - `QtyFinal` & `ValueSalesFinal`: Net final sales figures after claims and adjustments.

### C. Sales Distributor (`SalesDistributor`)
- **Entities**: `SalesDistributor`, `SalesLevel`, `SalesNotCovered` ([model/domain/sales_distributor.go](../model/domain/sales_distributor.go)).
- **Primary Key**: Composite (`Period`, `OutletID`, `ProductID`, `DistributorID`, `Invoice`, `InvoiceDate`, `Batch`).
- **Discounts**:
  - `DiscountOnDistributor` / `ValueDiscountOnDistributor`
  - `DiscountOnPrincipal` / `ValueDiscountOnPrincipal`
  - `DiscountOffDistributor`
  - `TotalDiscountOn`

### D. Stock Distributor (`StockDistributor`)
- **Entities**: `StockDistributor` ([model/domain/stock_distributor.go](../model/domain/stock_distributor.go)).
- **Stock Movement Calculation**:
  - `BeginningStock`: Starting inventory for the period.
  - `IncomingStock`: Purchases/deliveries received from principal.
  - `SalesOut`: Products sold out to outlets.
  - `EndingStock`: Computed balance (`BeginningStock + IncomingStock - SalesOut`).
  - `CoverStock`: Month/day coverage ratio calculated from current sales velocity.

### E. Target Marketing (`TargetMarketing`)
- **Entities**: `TargetMarketing`, `TargetMarketingView` ([model/domain/target_marketing.go](../model/domain/target_marketing.go)).
- **Purpose**: Defines sales targets per marketing structure, period (YYYYMM), and product division.

### F. Distributor Extra Discount & Claims
- **Entities**: `DistributorExtraDiscount`, `DistributorExtraDiscountClaim` ([model/domain/distributor_extra_discount.go](../model/domain/distributor_extra_discount.go)).
- **Purpose**: Manages extra discount agreements by distributor, validity periods, and associated claims.

---

## 2. Business Invariants & Rules

1. **Period Format**: All periods are standardized 6-character strings representing year and month: `YYYYMM` (e.g. `"202609"`).
2. **Period Closing Lock**:
   - Before performing write operations on historical sales or stock data, the service checks whether the period is closed via `helper.ValidateClosing(tableName, period)`.
   - Closed records (`ClosedYN = "Y"` or `Closed = true`) cannot be edited or recalculated without formal unlock.
3. **Auditing (`History`)**:
   - All update and delete actions on bridging tables and key entities create a serialized JSON snapshot in the `histories` table (`helper.CreateHistory`).
4. **ETL Synchronization**:
   - Changes made to bridging data (`bridging_outlets`, `bridging_products`) must be synchronized to the legacy MSSQL tables (`T_BridgingOutlet`, `T_BridgingProduct`) via `helper.EtlToMssql`.

---

## 3. Domain Terminology
- **FF**: Field Force (medical sales representatives working in the field).
- **DF / DL**: Doctor Focus / Doctor List (targeted medical professionals).
- **NR**: Non-Reguler (sales flag / transaction category).
- **OTX**: Over-The-Counter / Out-of-territory extended sales.
- **ASM / SPV / FSM**: Area Sales Manager, Supervisor, Field Sales Manager.
- **CN**: Credit Note (accounting document issued for discount adjustments/claims).
- **Nip**: Nomor Induk Pegawai (employee identifier for internal staff).
