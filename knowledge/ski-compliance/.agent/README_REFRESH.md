# README and Obsidian refresh — 2026-09-27

## Completed scope

- Updated/created root README.md in 13 child Git repositories using English prose and source-backed architecture, stack, configuration, setup, endpoint inventories, persistence notes and operational limits.
- Used discount-proposal README as the structural reference. Discount-proposal, structure and sales README files remain byte-for-byte unchanged.
- Updated the workspace README with the new task scope and links.
- Created SKI Compliance Backend in the Obsidian vault: 340 notes comprising 21 overview/reference pages, 16 service pages, 16 API pages, 261 database object pages and 26 source snapshots. Linked it from the existing project map, memory and database notes. VisitFlow Backend was only read as a structural reference.

## Endpoint inventory

- 1,241 Go route declarations across the included Go repositories, extracted with Go AST parsing without importing or starting application packages.
- 288 no-code method definitions, retaining enable flags and explicit endpoint overrides. Missing runtime-derived paths are not guessed.
- 144 frontend URL-bearing request objects; these are outgoing templates, not backend routes owned by the static website.
- Gateway Backend literals and legacy CustomMux registrations were inventoried separately from Gin route files. Uncalled route functions are labeled declaration-only; legacy method constraints require the individual handler.

## Verification performed

- All expected extracted Go paths are represented in their README.
- Relative README file links resolve; git diff --check passes for the edited README files.
- Existing child repository changes were preserved: compared current porcelain status excluding README.md with the pre-task baseline across all 16 repos. Three excluded repos have identical status and README hashes.
- Obsidian internal wikilinks resolve and code fences balance across all 340 new notes.
- Scanned new notes and included READMEs against authorized connection host/user/password values in memory: zero matches; secret values were never printed.
- Workspace checker: 368 Markdown files, 2118 links, 60 skill links, zero issues. README and vault links also received separate checks because the workspace checker has its own selected document scope.

## Limits

No application tests, deployment, service startup, database writes or business-data retrieval occurred in this documentation task. Schema object notes use metadata observed on 2026-09-27 01:57:48 UTC, not current row data. Runtime-generated Flexurio endpoints and compiled Flutter runtime requests require runtime source/trace to enumerate beyond editable configuration. Obsidian source copies are dated snapshots, not automatic synchronization.
