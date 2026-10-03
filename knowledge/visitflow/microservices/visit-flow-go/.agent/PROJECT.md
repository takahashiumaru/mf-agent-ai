# Project

## Project Purpose

Visit Flow is an HTTP backend for planning, executing, approving, and reporting field visits. Its data model connects users' organizational structures to customers, locations/outlets, products, visit plans, visit realization evidence, and approval records.

The generic GitLab template in `README.md` does not describe the application; the purpose above is derived from routes, services, models, and tests.

## Main Responsibilities

- Maintain companies, areas, organizational structures/positions/bosses/cities, and structure-location assignments.
- Maintain customers, customer drafts/categories/hobbies, locations/categories/groups/sub-locations, and customer-location mappings.
- Create and manage visit plans, joint-visit members, products discussed during visits, check-in/check-out coordinates, photos/signatures, and status transitions.
- Drive approval sequences using database-backed confirmation statuses and approval records.
- Maintain master customer lists (`visit_customers`), recommendation estimations, call targets, clusters, and promotional/reporting data.
- Produce visit reports and execute stored-procedure-backed processing flows.
- Proxy Google Maps and social-account checks and send Firebase notifications.

## Main Modules

Modules are horizontal packages rather than isolated feature directories. Match files by prefix across `route/`, `controller/`, `service/`, `repository/`, `model/domain/`, and `model/web/`.

High-impact domains include:

- `visit*`: plan and realization lifecycle, members, products, API logs, reports.
- `visit_customer*`: master customer list, coverage, recommendations, clustering.
- `customer*` and `location*`: customer/outlet master data and their mapping.
- `structure*`, `area*`, `company*`: organization and territorial ownership.
- `approval*`, `confirmation_status*`, `config*`: workflow and configurable rules.
- `product*`: product master and recommendation estimation.

## External Systems

- MySQL primary and replica DSNs through `go-helper` and GORM `dbresolver` (`app/database.go`).
- A second database handle returned as `skiDatabase` and passed around as `dbSki` for selected structure/product/process routes (`app/router.go`). `main.go` clones the Visit Flow configuration and assigns the same `DB_DSN_SOURCE_1`/`DB_DSN_REPLICATION_1` environment keys before constructing both handles; a distinct second DSN is not established by this entrypoint.
- `gitlab.com/VNEU/visit-flow-api-gateway` models/repositories for user data.
- `gitlab.com/VNEU/visit-flow-survey-location-go` repository calls from visit logic.
- Firebase Cloud Messaging using `helper/send_message.go` and `helper/service-account.json`.
- Google Maps HTTP APIs in `service/google_maps_service_impl.go`.
- External social sites through `service/social_service_impl.go`.
- OpenTelemetry exporter configuration and Gin/GORM instrumentation.

No Redis, Kafka, RabbitMQ, object-storage client, or email client was found.

## Entrypoints

- `main.go`: executable entrypoint.
- `app.ConnectDatabase`: builds the two GORM handles.
- `app.NewRouter`: initializes tracing/middleware and registers every route.
- `route/*_route.go`: constructs repositories/services/controllers manually.

## Configuration

`goHelper.LoadConfig()` loads `configuration/.env` through `godotenv` and Viper. `main.go` then also calls `godotenv.Load()` for a root `.env` if present and explicitly overwrites the primary/replica DSNs from process environment variables.

Observed keys are `PORT`, `DEBUG`, `DB_DSN_SOURCE_1`, `DB_DSN_REPLICATION_1`, JWT secrets, OpenTelemetry endpoint, and visit-related flags/radius. Treat all values as secrets or deployment configuration; document names only, never values.

The application requires reachable database connections at startup. Missing DSNs are fatal in the external `go-helper` connector.
