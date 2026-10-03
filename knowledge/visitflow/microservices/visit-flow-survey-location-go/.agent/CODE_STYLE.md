# Survey Code Style

Follow existing module interface/implementation files and constructor wiring. Concrete local names include DistributorService/DistributorServiceImpl and OutletSurveyService/OutletSurveyServiceImpl. Preserve exported names and JSON terminology, including customer_product versus customer_material filenames.

Use gofmt, descriptive names, early returns and focused functions. Keep HTTP parsing in controllers, business/transaction decisions in services and SQL in repositories. New abstractions need a concrete seam; do not create a framework for one workflow.

Repository signatures accept `*gorm.DB`. Services select `tx.Read` or `tx.Write`; use the writer for dependent reads. Pass standard request context to new lower-level I/O APIs while preserving affected public interfaces.

Domain models use explicit audit fields and string/company/composite keys. Match local nullable field types; plain time.Time deletion fields are not proof of soft deletion. Use GORM.md for persistence choices.

Preserve returned errors versus panic compatibility per method. Document non-obvious business invariants and external effects rather than narrating each statement. Use TESTING.md for local regression patterns and QUALITY_GATES.md for completion.
