# Project Context — Marketing Structure Microservice

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Purpose & Scope

`mf-micro-service-structure` is a backend Go microservice within the VNEU pharmaceutical/distribution ecosystem (specifically the SKI compliance and sales architecture). It provides centralized management for marketing organizational structures, hierarchy relationships (Levels 1 through 6), territory outlet assignments, customer assignments, office locations, and periodic closing locks.

## Core Modules & Responsibilities

1. **Marketing Structure (`controller/marketing_structure_*`, `service/marketing_structure_*`, `repository/marketing_structure_*`)**:
   - Manages marketing personnel positions, employee assignments (`UserID`), manager links (`MarketingStructureBossID`), division assignments (`DivisionID`), and office codes (`OfficeID`).
   - Supports period-based hierarchy tracking (`YYYYMM`), duplication across periods (`CreateDuplicate`), and structure merging (`MergeStructure`).
   - Provides all-level hierarchical views (`FindMarketingStructureAllLevel`, `FindMarketingStructureAllLevelSubordinates`) and join date reports.
2. **Hierarchy (`controller/hierarchy_*`, `service/hierarchy_*`, `repository/hierarchy_*`)**:
   - Manages geographical and divisional hierarchy nodes, parent-child marketing relations, and city linkages.
3. **Marketing Position (`controller/marketing_position_*`, `service/marketing_position_*`, `repository/marketing_position_*`)**:
   - Defines position titles, organizational levels (1 to 6), and period validity.
4. **Marketing Structure Area (`controller/marketing_structure_area_*`, `service/marketing_structure_area_*`, `repository/marketing_structure_area_*`)**:
   - Maps marketing structures to geographical cities and sales areas with closing status (`IsClosedEditArea`).
5. **Territory Outlet & Customer (`controller/marketing_structure_territory_*`, `service/marketing_structure_territory_*`)**:
   - Assigns customer master IDs and physical outlet IDs to specific marketing structures per period.
6. **Office (`controller/office_*`, `service/office_*`, `repository/office_*`)**:
   - Manages physical office locations and headquarters.
7. **Structure WH Process (`controller/structure_wh_process_*`, `service/structure_wh_process_*`)**:
   - Handles batch warehouse and period processing states.

## External Systems & Dependencies

- **MySQL Database**: Primary relational data store for structures, positions, territories, and audit histories.
- **External Microservices (via Go packages)**:
  - `gitlab.com/VNEU/mf-micro-service-city`: City and regional geographical data.
  - `gitlab.com/VNEU/mf-micro-service-customer`: Customer domain models and validation.
  - `gitlab.com/VNEU/mf-micro-service-discount-proposal`: Discount proposal limit details, credit notes, and proposal PIC relations.
  - `gitlab.com/VNEU/mf-micro-service-marketing-user`: User accounts, employee divisions, and roles.
  - `gitlab.com/VNEU/mf-micro-service-outlet-2`: Outlet domain models.
  - `gitlab.com/VNEU/mf-micro-service-sales`: Sales share and FF repository interactions.
- **MSSQL ETL Sync Service (`helper/etl_to_mssql.go`)**:
  - Outbound HTTP JSON push to `SYNC_URL/sync-ski` and `SYNC_URL/find-data` for synchronization with legacy MSSQL systems.
- **VisitFlow Integration (`helper/sync_visitflow.go`)**:
  - Outbound HTTP JSON sync to `VISIT_URL` for field marketing visit plans.
- **OpenTelemetry Collector (`app/router.go`)**:
  - OTLP gRPC telemetry endpoint configured via `OTEL_EXPORTER_OTLP_ENDPOINT`.

## Runtime Configuration (`configuration/configuration.go`)

Loaded from `./configuration/.env` via Viper:
- `PORT`: HTTP server listening port (default standard e.g. 8080 or service port).
- `HOST_DB`, `PORT_DB`, `USER_DB`, `PASSWORD_DB`, `DATABASE_DB`: MySQL connection credentials.
- `ACCESS_SECRET`, `REFRESH_SECRET`: JWT signing keys.
- `SYNC_URL`, `VISIT_URL`, `NOCODE_URL`: External integration API endpoints.
- `OTEL_EXPORTER_OTLP_ENDPOINT`, `INSECURE_MODE`: Tracing exporter settings.
