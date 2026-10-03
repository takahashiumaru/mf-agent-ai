# Domain

## Major Domains

### Visits

`model/domain/visit.go`, `service/visit_service_impl.go`, and `repository/visit_repository_impl.go` implement planned calls/meetings and their realization. A visit records structure, period, customer/location, schedule, check-in/out, coordinates/radii, approval metadata, evidence files, survey flags, tenant company, and cached display data.

Related records include `VisitMember`, `VisitProduct`, `VisitApiLog`, approvals, and reporting projections.

### Master Customer List

`VisitCustomer` in `model/domain/visit_customer.go` represents period/structure/customer planning, including status, category, location, recommendation/cluster/amortization data. `service/visit_customer_service_impl.go` contains approval, deletion, recommendation, and notification rules. `repository/visit_customer_repository_impl.go` contains batch upsert, raw cross-schema queries, coverage reporting, and stored-procedure usage.

### Customers and Locations

Customers and outlets/locations have master records, categories, draft/approval states, and a many-to-many-like `CustomerLocation` mapping. Structures are assigned locations by period through `StructureLocation`. Services enforce company and organizational ownership.

### Organization and Configuration

Companies contain areas, structures, positions, bosses, cities, and location assignments. `Config` rows provide rule values keyed by names such as call-plan and approval regulations. `ConfirmationStatus` rows define ordered status progressions by menu.

### Products and Reporting

Products can be attached to visits and participate in recommendation estimations. Reporting modules build daily calls, call details, master customer lists, completeness, incentives, call targets, and dashboard promotion data, often through stored procedures or large SQL queries.

## Domain Entities and IDs

- `Visit`, `Company`, `Area`, many mapping entities: numeric `gorm.Model.ID` plus business/composite fields.
- `Customer`, `Location`, `Product`, `Structure`: string/business IDs are prominent; some combine them with period/company fields marked as keys/indexes.
- `Approval`, `ConfirmationStatus`, `Config`: numeric IDs with business fields that control workflows.
- Query/report structs may map views or stored-procedure results and are not always mutable tables.

Inspect the exact model and repository before assuming an ID is a single integer primary key; several structs declare multiple `primarykey` tags in addition to embedded `gorm.Model`.

## Proven Business Rules

The following are directly enforced in source:

- Visit creation starts at `draft`, or `plan-approved` when configured approval rules allow skipping approval (`service/visit_service_impl.go`).
- Visit count limits and per-customer/per-location same-day rules are read from `Config` and enforced during creation.
- A nonstandard location ID `NON` allows request-supplied location coordinates/address and may create a structure-location mapping.
- A visit cannot check in more than seven days after its scheduled datetime (`UpdateCheckIn`).
- Check-in validates GPS accuracy and distance/radius through configurable rules and Haversine calculation.
- KPDM visits can be required to include survey data before approval, controlled by configuration.
- Approval actions require checkpoint flags from JWT `AccessDetails` in relevant paths.
- Master customer list deletion rejects backdated and recommendation-derived records in specified cases (`service/visit_customer_service_impl.go`).
- Customer category validation rejects simultaneous incompatible `USER` and `KPDM` category use (`service/customer_service_impl.go`).
- Product image uploads enforce a 1 MB maximum (`service/product_service_impl.go`).

Many numeric thresholds come from database `configs`; do not hard-code replacement values.

## Statuses and Transitions

Shared constants in `helper/constant.go` include:

- `draft`
- `confirm`
- `plan-approved`, `plan-rejected`
- `check-in`, `check-out`
- `realization-approved`, `realization-rejected`
- `approve`

A common visit path visible in services is:

```text
draft -> plan-approved -> check-in -> check-out -> realization-approved
          \-> plan-rejected             \-> realization-rejected
```

This is not a complete hard-coded state machine. `service.Approval` calls `ConfirmationStatusRepository.FindNextStatus`, joining adjacent `step` rows for a `menu`. Therefore, actual intermediate approval states may be database-configured. Inspect `confirmation_statuses` use and the exact service action before changing transitions.

Other modules use `approved`, `rejected`, `non-active`, and draft states with module-specific meaning.

## Invariants and Sensitive Logic

- Company/structure/period scoping is part of data correctness and access control.
- Approval records, visit status, and notification recipient data are updated together in service transactions.
- Check-in/out coordinates, radii, timestamps, evidence files, and member updates form one realization flow.
- Period processing methods may hard-delete and rebuild batches; partial execution can affect reports and master lists.
- Recommendation, cluster, coverage, target, and amortization calculations use raw SQL/cross-schema data and require extra caution.
- Several workflows use a fixed UTC+7 conversion. Preserve current semantics unless a timezone change is explicitly required.

## Terminology

- MCL: Master Customer List, represented chiefly by `visit_customers` and report projections.
- KPDM / USER: customer-category labels used in call-plan and survey rules.
- Structure: a period-based organizational/user placement with boss hierarchy and territory.
- Structure boss (`Bos` in filenames/types): hierarchical approver/superior mapping.
- Period: commonly a `YYYYMM` six-character business period.
- Plan approval: approval before a scheduled visit.
- Realization approval: approval after check-out/visit execution.
- Out of city: a structure-location/visit flag influencing location and radius logic.

Meanings beyond these source-backed uses are not clearly established in the current repository.
