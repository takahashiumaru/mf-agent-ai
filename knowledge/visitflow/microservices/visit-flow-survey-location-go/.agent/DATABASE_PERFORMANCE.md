# Survey Database Performance

Trace the affected repository query and service call count before optimizing. Actual local anchors are `repository/outlet_survey_repository_impl.go` (list/report/aggregate persistence) and `repository/outlet_survey_customer_product_repository_impl.go` (customer-product joins/lookups).

Do not assume pagination, batching, upserts or stored procedures exist because another VisitFlow service uses them. Inspect Limit/Offset, loops and generated statements. A Limit(1) query does not establish bounded pagination for other endpoints.

Review company/business-key selectivity, relation multiplication, payload width, query count, sorting, optional fields and transaction duration. For composite keys, compare actual query predicates with verified target constraints/indexes. Index tags do not prove deployed indexes.

Use representative SQL/arguments and permitted EXPLAIN reads for significant queries. Label unmeasured costs as risks. Batch only where semantics, error behavior, ordering and atomicity remain correct. Cache or concurrency requires an explicit invalidation/lifecycle policy and measured value.

SQL mocks can protect predicates, arguments and query count; they do not prove execution plans or latency. Follow workspace database authorization for live reads/mutations and shared query-performance/query-brainstorm skills as appropriate.
