# Knowledge maintenance

## Ownership

- Workspace AGENTS.md: shared answer contract and database authorization.
- Repository AGENTS.md: concise entry point and compatibility rules.
- INDEX.md: task routing; read only the relevant topics.
- EVIDENCE.md: current facts, exceptions, unresolved differences and their dates.
- Topic documents: detailed explanation and preferred patterns.
- TESTING.md: source inventory and execution evidence, never assumed coverage.
- CHANGELOG.md: why guidance changed.

## Refresh procedure

After relevant source/schema changes, inspect affected callers, update the relevant topic and EVIDENCE.md, then verify links and command claims. Mark metadata by observation date and distinguish local model tags from physical schema. Preserve historical changelog entries; do not present historical verification as current.

The shared SKI skills remain canonical in the workspace. Claude skill links point to the same local/shared sources. If this repository is opened outside the parent workspace, restore access to the parent guidance before claiming database access; do not copy credentials into the repository.
