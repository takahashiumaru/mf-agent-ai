# Survey Technical Debt — Investigation Leads

These are scoped source observations, not a production incident inventory or permission to refactor unrelated code.

- Existing resolver services finalize the writer while a separate read transaction is opened: inspect the pinned helper lifecycle before extending it.
- `Updates(struct)` omits zero values; compare each patch DTO's intent with its repository update.
- Some update/delete predicates use IDs without a matching company predicate. Trace ownership and actual uniqueness before changing scope.
- Explicit `DeletedAt time.Time` fields do not establish GORM soft deletion. Confirm SQL and caller expectations.
- Nested association writes need key/company/duplicate/failure tests; relationship declarations alone do not prove correct graph persistence.
- SQL-mock coverage does not establish live MySQL concurrency/schema/replica behavior.

Start at `service/outlet_survey_service_impl.go`, `repository/outlet_survey_repository_impl.go`, the affected model and `test/repository_test.go`. Record confirmed impact/evidence before assigning severity. CODE_QUALITY supplies classification vocabulary; QUALITY_GATES owns completion.
