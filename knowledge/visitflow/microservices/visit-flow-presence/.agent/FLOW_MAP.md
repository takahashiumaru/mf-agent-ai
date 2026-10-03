# Flow Map — Optional Navigation

Open this only when the affected implementation path is unclear. These are source entry points, not proof of complete feature coverage, authorization or deployment. Follow callers and the exact method under investigation; test links indicate relevant suites, not verified coverage of every branch.

| Flow | Route | Controller | Service | Repository | Model | Tests |
| --- | --- | --- | --- | --- | --- | --- |
| Check-in/out and Pondasi | [presence_route.go](../route/presence_route.go) | [presence_controller_impl.go](../controller/presence_controller_impl.go) | [presence_service_impl.go](../service/presence_service_impl.go) | [presence_repository_impl.go](../repository/presence_repository_impl.go) | [presence.go](../model/domain/presence.go) | [presence_workflow_test.go](../test/presence_workflow_test.go) |
| Leave approval | [leave_route.go](../route/leave_route.go) | [leave_controller_impl.go](../controller/leave_controller_impl.go) | [leave_service_impl.go](../service/leave_service_impl.go) | [leave_repository_impl.go](../repository/leave_repository_impl.go) | [leave.go](../model/domain/leave.go) | [leave_hrd_integrity_test.go](../test/leave_hrd_integrity_test.go) |
| Office wiring | [office_route.go](../route/office_route.go) | [office_controller_impl.go](../controller/office_controller_impl.go) | [office_service_impl.go](../service/office_service_impl.go) | [office_repository_impl.go](../repository/office_repository_impl.go) | [office.go](../model/domain/office.go) | [office_controller_coverage_test.go](../test/office_controller_coverage_test.go) |

Leave HRD delegates to [leave_hrd.go](../service/leave_hrd.go) and [leave_quota_allocation.go](../service/leave_quota_allocation.go). Inspect those helpers for writer locks, quota period and notification order.

After route/service/repository/model or test moves, run the workspace guidance validator with `--repo visit-flow-presence --drift`; review suggested topics and the actual diff. It detects selected structural drift, not semantic correctness.
