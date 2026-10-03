# Survey Project

Owner: outlet surveys/questions/customers/product evaluations and distributor/material master data. Runtime entry is `main.go`; `app/` handles DB/router wiring, `route/` constructs dependencies, and controller/service/repository/domain/web layers implement each module.

Read AGENTS/INDEX first. API.md identifies local route sources; public gateway prefixes/hosts must be checked in the gateway configuration. Do not infer gateway mappings from this README or diagrams.

Dependency versions and commands are owned by go.mod/Makefile. TESTING.md describes current test facilities and CI limitations. Current source is not proof of production deployment.
