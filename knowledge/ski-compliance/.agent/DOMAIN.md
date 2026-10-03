# Domain reference and boundaries

This is a source-backed vocabulary and navigation guide. Complete commercial policy, deployment ownership, and all state transitions are not established by the sampled source.

| Term/area | Meaning supported by current evidence | Source to inspect |
|---|---|---|
| Customer account | Customer-related banking record, joined with bank/branch and audit information | Bank `repository/account_repository_impl.go` |
| Customer territory/product mapping | Association involving customer, product, and reporting period | Customer `service/customer_territory_product_service_impl.go` |
| Outlet group mapping | Batch-created/updated outlet grouping associations | Outlet `service/outlet_group_mapping_service_impl.go` |
| Event class period | Start/end period range validated in event-class creation | Event `service/event_class_service_impl.go` |
| Product program ACTIVE query mode | Query-specific filtering involving product max discounts and current date | Product `repository/product_program_repository_impl.go` |
| Marketing user | User identity with menu/group authentication configuration and sync side effects | Marketing-user `route/user_route.go`, `service/user_service_impl.go` |
| Master document file | File retrieval through controller path construction and OpenFile | Master-document `controller/file_controller_impl.go`, `service/file_service_impl.go` |
| Warehouse process | Multi-step sales-out processing with period selection and recovery handling | Warehouse `service/sales_out_wh_process_service_impl.go` |
| Sync SourceAction | Source change action used while mapping SKI records into VisitFlow operations | Sync `service/customer_service_impl.go` |

Full repository names and links: [PROJECT_MAP.md](PROJECT_MAP.md). Concrete traced flows: each included repository's `.agent/EVIDENCE.md`.

## Period and status semantics

`customer_territory_outlets.period`, `marketing_structures.period`, and `sales_ffs.period` are varchar(6) in the captured schema. `event_classes.period_start/end` and `status_closings.period` are varchar(8). Sync code formats source lookups as YYYY-MM. These formats are not interchangeable. Inspect the source predicate, representative values if needed, and intended reporting period before comparison.

Active status is entity-specific: customers has status and deleted_at; outlets has is_active and deleted_at; sales_ffs has no deleted_at in the snapshot. Do not turn one endpoint's filter into a workspace-wide rule. Closing/cancellation/net-sales policy must come from the owning flow and actual requested metric.

## Cross-system consistency

Gateway dependency versions and local gateway source may differ. Shared transaction helpers may receive Gin context and internally bind a DB context. VisitFlow models/repositories may be imported from a pinned external module. Warehouse tables and synchronization destinations are derived representations with potentially different freshness and grain. Investigate reconciliation and retry semantics before interpreting different totals as corruption.
