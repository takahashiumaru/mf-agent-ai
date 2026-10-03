# Domain Model & Business Logic — Marketing Structure Service

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

This document describes the business entities, lifecycle states, hierarchies, and rules governing marketing structures.

## Organizational Hierarchy Levels (Levels 1 to 6)

The core domain model represents a 6-tier marketing personnel hierarchy:
- **Level 1 (Top Level / Director / Head Office)**: Highest management tier in a division.
- **Level 2 (National / General Manager / NSM)**: Manages regional managers.
- **Level 3 (Regional / RSM)**: Manages area managers.
- **Level 4 (Area / AM / Supervisor)**: Manages field managers.
- **Level 5 (District / DM / Field Supervisor)**: Manages sales/medical representatives.
- **Level 6 (Field Representative / MR / Sales Rep)**: Ground-level sales and medical representatives assigned to territory customers and outlets.

Every `MarketingStructure` record contains:
- `Period`: Active period formatted as `YYYYMM` (e.g. `202609`).
- `Code`: Unique structure code for the position in that period.
- `MarketingPositionID`: Position definition linked to `MarketingPosition` (`level` 1..6).
- `UserID`: Assigned employee ID from `users` table.
- `MarketingStructureBossID`: Reference to direct reporting supervisor's structure ID in the same period.
- `DivisionID`: Operating division (e.g. ethical pharmaceuticals, consumer health).
- `OfficeID`: Assigned branch or regional office.
- `AreaDescription`: Description of geographical coverage.
- `IsDummy`: Flag indicating placeholder/unfilled structure slots.
- `IsBigCity`: Flag indicating major urban territory tier.

## Key Master Entities

1. **`MarketingPosition` (`model/domain/marketing_position.go`)**:
   - Stores position metadata, hierarchy `Level` (1–6), name, and period validity.
2. **`MarketingStructureArea` (`model/domain/marketing_structure_area.go`)**:
   - Maps marketing structures to city master records (`cities`).
   - Governed by `IsClosedEditArea` state.
3. **`MarketingStructureTerritoryCustomer` (`model/domain/marketing_structure_territory_customer.go`)**:
   - Maps marketing structures to customer accounts (`customers`).
4. **`MarketingStructureTerritoryOutlet` (`model/domain/marketing_structure_territory_outlet.go`)**:
   - Maps marketing structures to pharmacy/hospital retail outlets (`outlets`).
5. **`Office` (`model/domain/office.go`)**:
   - Represents physical company branch offices and operational hubs.
6. **`Hierarchy` (`model/domain/hierarchy.go`)**:
   - Represents organizational branches and hierarchical divisional groupings.

## Period Closing & Locking Rules

Operations are partitioned by calendar monthly periods (`period` string, e.g. `202401`):
- **Area Edit Closure (`ClosedEditArea` / `IsClosedEditArea`)**: When locked, area mappings for that period cannot be edited.
- **Full Structure Edit Closure (`ClosedEditAll` / `IsClosedEditAll`)**: When locked, no structural changes, merges, or reassignments are permitted for that period.
- **Closing Validation**: Handled via `helper.ValidateClosing(tx, period)` to prevent modifications to closed or locked historical periods.

## Period Duplication & Data Processing

- **Duplicate Period (`CreateDuplicate`)**: Copies full organizational structures, positions, area allocations, and territory assignments from a source period (`sourcePeriod`) to a target period (`destinationPeriod`), resetting approval states and updating timestamps.
- **Merge Structure (`MergeStructure`)**: Transfers territory outlets, customers, and subordinate nodes from one marketing structure node to another within an active period.
- **Structure WH Processing (`structure_wh_process`)**: Tracks batch ETL and data-warehouse sync status per period.
