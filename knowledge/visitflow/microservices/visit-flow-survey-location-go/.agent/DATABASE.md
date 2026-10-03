# Survey Database Navigation

Models and repository SQL are local evidence; target schema metadata is deployment evidence. Read relevant workspace DATABASE_SCHEMA_CATALOG.md / DATABASE_SCHEMA.md as dated indexes, then verify live metadata when necessary using workspace authorization. Never print dump INSERT data.

## Relevant model families

- `model/domain/outlet_survey.go`: survey ID, company, period, outlet, distributor list and visit reference; customer/question associations.
- `model/domain/outlet_survey_question.go`: survey/question/company key fields and value.
- `model/domain/outlet_survey_customer.go`: surveyed customer identity and survey/company relationship.
- `model/domain/outlet_survey_customer_product.go`: customer/product/question/company key fields and value.
- `model/domain/distributor.go`, `model/domain/material.go`: master data.

Resolve table names from models and repository `Table`/raw SQL, not the service name. Survey model names use OutletSurvey; older docs called them location_surveys, which must not be assumed current. Model key/index tags are not proof of deployed keys. Compare types/nullability, key order, FK/unique constraints, tenant joins, deletion and date storage for the affected change.

There is no established local migration command. Do not enable startup migration merely because a model changes. Prepare a reviewed rollout and follow workspace DEV-only confirmation for concrete mutations. File/API implementation authorization is not DB mutation approval.
