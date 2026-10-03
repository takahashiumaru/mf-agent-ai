# Survey Domain

This service owns outlet survey assessments, their answers, surveyed customers and product/material evaluations, plus distributor/material master data.

| Concept | Source of local behavior |
| --- | --- |
| Survey header and nested submission | `service/outlet_survey_service_impl.go`, `model/domain/outlet_survey.go` |
| Survey questions | `service/outlet_survey_question_service_impl.go`, `model/domain/outlet_survey_question.go` |
| Surveyed customers | `service/outlet_survey_customer_service_impl.go`, `model/domain/outlet_survey_customer.go` |
| Customer product answers | `service/outlet_survey_customer_product_service_impl.go`, `model/domain/outlet_survey_customer_product.go` |
| Master distributor/material | Corresponding service/repository/model files |

Header Create currently derives a date-based ID using a hyphen and outlet ID, converts auth company/user IDs to strings, and joins distributor IDs into a comma-separated string. Update/nested submission have their own branches; inspect them before generalizing period, uniqueness or idempotency.

Product terminology is deliberately mixed with material in repository filenames; follow existing exported interfaces and JSON fields. Keys/relationships come from actual structs and schema, not this glossary. A declared association does not prove tenant-safe joins or complete loaded response data.
