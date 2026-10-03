# Survey API Contracts

Local route files are the authority for method/path/wiring. Public gateway URLs require separate gateway mapping inspection.

## Outlet survey entry points

Observed in `route/outlet_survey_route.go`:

- GET/POST `/outlet-surveys`.
- GET/PUT/DELETE `/outlet-surveys/:id`.
- POST `/outlet-surveys/:outlet-survey-id` for nested submission.
- GET `/outlet_surveys/all` for report data.

Other modules: inspect `route/distributor_route.go`, `route/material_route.go`, and `route/outlet_survey_customer_route.go`, `route/outlet_survey_question_route.go`, `route/outlet_survey_customer_product_route.go`. Do not derive their paths from filenames.

Trace the matching controller, service, request DTO and domain mapper before claiming validation, pagination, tenancy, authorization or relation loading. Auth wrappers/role slices alone do not prove role enforcement.

Preserve keys/types, IDs, company/period fields, null versus zero, empty arrays, ordering, totals and error/status mapping. Test using `test/controller_test.go` and `test/router_test.go`; these do not establish deployed gateway behavior.
