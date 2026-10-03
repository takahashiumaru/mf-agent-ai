# Flow Map — Optional Navigation

Open this only when the affected implementation path is unclear. These are source entry points, not proof of complete feature coverage, authorization or deployment. Follow callers and the exact method under investigation; test links indicate relevant suites, not verified coverage of every branch.

| Flow | Route | Controller | Service | Repository | Model | Tests |
| --- | --- | --- | --- | --- | --- | --- |
| Survey/nested submission | [outlet_survey_route.go](../route/outlet_survey_route.go) | [outlet_survey_controller_impl.go](../controller/outlet_survey_controller_impl.go) | [outlet_survey_service_impl.go](../service/outlet_survey_service_impl.go) | [outlet_survey_repository_impl.go](../repository/outlet_survey_repository_impl.go) | [outlet_survey.go](../model/domain/outlet_survey.go) | [service_test.go](../test/service_test.go) |
| Customer product | [outlet_survey_customer_product_route.go](../route/outlet_survey_customer_product_route.go) | [outlet_survey_customer_product_controller_impl.go](../controller/outlet_survey_customer_product_controller_impl.go) | [outlet_survey_customer_product_service_impl.go](../service/outlet_survey_customer_product_service_impl.go) | [outlet_survey_customer_product_repository_impl.go](../repository/outlet_survey_customer_product_repository_impl.go) | [outlet_survey_customer_product.go](../model/domain/outlet_survey_customer_product.go) | [repository_test.go](../test/repository_test.go) |
| Distributor wiring | [distributor_route.go](../route/distributor_route.go) | [distributor_controller_impl.go](../controller/distributor_controller_impl.go) | [distributor_service_impl.go](../service/distributor_service_impl.go) | [distributor_repository_impl.go](../repository/distributor_repository_impl.go) | [distributor.go](../model/domain/distributor.go) | [controller_test.go](../test/controller_test.go) |

After route/service/repository/model or test moves, run the workspace guidance validator with `--repo visit-flow-survey-location-go --drift`; review suggested topics and the actual diff. It detects selected structural drift, not semantic correctness.
