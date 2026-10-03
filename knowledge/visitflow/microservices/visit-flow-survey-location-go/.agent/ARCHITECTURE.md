# Survey Architecture

The local request path is `route → auth wrapper → controller → service → repository → GORM → domain mapper → web response`.

## Package and dependency design

- Keep the current layer packages. Each package groups cohesive responsibilities across the survey domain; do not split `service` into subpackages unless a real caller or independent implementation needs that seam.
- `route` is the composition root: it constructs concrete repository and service implementations. Controllers depend on service interfaces; services depend on repository interfaces and own validation, business orchestration, and transaction selection; repositories own GORM queries.
- Keep dependencies flowing inward through these layers. Do not add service-to-service calls or make repositories depend on controllers/routes. Domain and web product types currently import the corresponding types from `visit-flow-go`; preserve that shared contract unless a concrete versioning or ownership problem requires a migration.
- Keep pure survey ID/key formatting in the focused `helper/survey_id.go`; services still choose the date and business inputs. Keep request-to-domain mapping with the owning service because it depends on domain-specific DTO and audit rules.
- Existing interfaces are useful at the controller/service and service/repository seams used by consumers and tests. Do not add a new interface for a single implementation or narrow an existing contract without confirming every caller and test.
- Keep Gin/auth and GORM wiring compatible with the current public service constructors. Decouple HTTP concerns only when a real non-HTTP caller needs the seam and the behavior can be characterized end to end.

- `route/outlet_survey_route.go` manually constructs repository/service/controller. Local CRUD/nested submission routes use `/outlet-surveys`; the report path is `/outlet_surveys/all`. Do not invent `/v1` prefixes; public mappings must be traced separately in the gateway.
- Services own business validation and choose `tx.Read` or `tx.Write` from the resolver. Repository methods accept **`*gorm.DB`**. They do not receive a DatabaseResolver.
- Current outlet-survey services call `goHelper.CreateTransaction(service.DB, c)` and defer completion of `tx.Write`. Separate read-handle finalization is a legacy concern, not an endorsed new template.
- New atomic flows must keep writes/dependent reads on one writer transaction. Preserve existing interfaces/error contracts and verify lifecycle changes.
- Domain structs are GORM models plus response mappers; do not introduce a separate persistence model layer for a focused fix.

See PREFERRED_PATTERNS for decisions and TESTING for real examples. This is a source navigation map, not proof of deployment.
