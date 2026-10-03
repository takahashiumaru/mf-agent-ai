# Flow Map — Optional Navigation

Open this only when the affected implementation path is unclear. These are source entry points, not proof of complete feature coverage, authorization or deployment. Follow callers and the exact method under investigation; test links indicate relevant suites, not verified coverage of every branch.

| Flow | Route | Controller | Service | Repository | Model | Tests |
| --- | --- | --- | --- | --- | --- | --- |
| Identity/session | [users_route.go](../route/users_route.go) | [users_controller_impl.go](../controller/users_controller_impl.go) | [user_service_impl.go](../service/user_service_impl.go) | [users_repository_impl.go](../repository/users_repository_impl.go) | [users.go](../model/domain/users.go) | [session_refresh_coverage_test.go](../test/session_refresh_coverage_test.go) |
| Role | [role_route.go](../route/role_route.go) | [role_controller_impl.go](../controller/role_controller_impl.go) | [role_service_impl.go](../service/role_service_impl.go) | [role_repository_impl.go](../repository/role_repository_impl.go) | [role.go](../model/domain/role.go) | [role_service_test.go](../test/role_service_test.go) |

For a proxied URL, start at the relevant entry in `configuration.json`, identify its owning upstream, then read that service’s route. The local Gin server is wired separately in `main.go`; downstream business logic belongs in the owning service.

After route/service/repository/model or test moves, run the workspace guidance validator with `--repo visit-flow-api-gateway --drift`; review suggested topics and the actual diff. It detects selected structural drift, not semantic correctness.
