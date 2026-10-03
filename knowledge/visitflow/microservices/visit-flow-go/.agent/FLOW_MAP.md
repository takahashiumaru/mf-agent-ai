# Flow Map — Optional Navigation

Open this only when the affected implementation path is unclear. These are source entry points, not proof of complete feature coverage, authorization or deployment. Follow callers and the exact method under investigation; test links indicate relevant suites, not verified coverage of every branch.

| Flow | Route | Controller | Service | Repository | Model | Tests |
| --- | --- | --- | --- | --- | --- | --- |
| Visit lifecycle | [visit_route.go](../route/visit_route.go) | [visit_controller_impl.go](../controller/visit_controller_impl.go) | [visit_service_impl.go](../service/visit_service_impl.go) | [visit_repository_impl.go](../repository/visit_repository_impl.go) | [visit.go](../model/domain/visit.go) | [repository_visit_test.go](../test/repository_visit_test.go) |
| Customer list | [visit_customer_route.go](../route/visit_customer_route.go) | [visit_customer_controller_impl.go](../controller/visit_customer_controller_impl.go) | [visit_customer_service_impl.go](../service/visit_customer_service_impl.go) | [visit_customer_repository_impl.go](../repository/visit_customer_repository_impl.go) | [visit_customer.go](../model/domain/visit_customer.go) | [repository_visit_test.go](../test/repository_visit_test.go) |
| Company wiring only | [company_route.go](../route/company_route.go) | [company_controller_impl.go](../controller/company_controller_impl.go) | [company_service_impl.go](../service/company_service_impl.go) | [company_repository_impl.go](../repository/company_repository_impl.go) | [company.go](../model/domain/company.go) | [repository_crud_test.go](../test/repository_crud_test.go) |

After route/service/repository/model or test moves, run the workspace guidance validator with `--repo visit-flow-go --drift`; review suggested topics and the actual diff. It detects selected structural drift, not semantic correctness.
