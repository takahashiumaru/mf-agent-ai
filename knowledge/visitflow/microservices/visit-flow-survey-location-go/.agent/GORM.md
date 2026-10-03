# Survey GORM and Transactions

## Observed shape

Dependencies come from `go.mod`; startup DB wiring is in `app/database.go`. Services select a handle; repository methods accept `*gorm.DB`. Domain models are in `model/domain/` and map into `model/web/`.

Survey models use explicit fields and string business/company keys. `OutletSurvey` has ID and CompanyID model primary-key tags. Questions and customer-product rows have composite model keys. Inspect the actual struct and target metadata rather than assuming an ID-only key or deployed uniqueness.

Some models use plain `time.Time` deletion fields rather than `gorm.DeletedAt`. Automatic soft deletion must not be assumed. Repository SQL and SQL-mock expectations distinguish physical DELETE from logical deletion; preserve the intended contract.

## Reads, writes and errors

- Existing services commonly create a resolver and pass `tx.Read`/`tx.Write`; dependent reads must use the same writer as the mutation.
- `repository/outlet_survey_repository_impl.go` FindByID returns an error; other methods often panic through the helper. Preserve method-local behavior and propagate errors to the existing rollback/HTTP boundary.
- CRUD commonly uses `Updates(struct)`, which omits zero values. Intentional zero/false/empty/null patches need explicit fields/maps/pointers and regression tests.
- Scope writes by the actual business key and company; a scoped read alone does not make an ID-only update tenant-safe.
- Association Create/Save can write related rows. Review graph ownership, keys, company consistency and partial failure before extending nested submission.
- Relation joins and report projections must avoid duplicate root rows/counts and unbounded payloads.

See TESTING for sqlmock limits. No local index/schema claim proves live deployment; consult workspace schema rules before migration work.
