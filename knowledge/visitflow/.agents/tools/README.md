# Guidance Maintenance Tools — On Demand

These tools support the five Go-service guides. They are not startup reading and do not replace current code/schema/test evidence. Shared skills remain in `.agents/skills/`; tooling lives here once rather than being copied into each repository.

## Run from the workspace

```sh
python3 -B .agents/tools/validate_guidance.py
python3 -B .agents/tools/validate_guidance.py --repo visit-flow-presence --drift
python3 -B .agents/tools/validate_guidance.py --repo visit-flow-go --drift --since HEAD
python3 -B -m unittest discover -s .agents/tools/tests -v
```

Repeat `--repo` to select multiple repositories. Default output is bounded per repo; `--json` provides all findings. Exit 1 means structural errors; advisory word-budget/drift warnings alone do not fail. Invalid git revisions fail the selected drift check. No dependency installation is required.

## What is checked

- Local inline Markdown links and heading fragments in active agent documents.
- Explicit backtick Go paths and relative Markdown/Go references.
- Skill frontmatter presence of name/description.
- Commands declared in TESTING.md tables against actual Makefile targets.
- AGENTS + INDEX word count; over 2,000 words prompts review, not automatic deletion of rules. This is a word metric, **not measured model token usage**, and excludes parent guidance/selected skills/code.
- Optional git changed-file categories suggest affected topic documents. Uncommitted tracked/untracked filenames are included by default; `--since` compares a revision to the working tree. Suggestions do not establish that docs are stale or already reviewed.

The tool reads documentation/Makefiles and git filenames only. It does not run Go tests, Make targets, database queries, HTTP calls, deployment, external messaging, or modify files. Links outside the workspace are rejected; external web links are not fetched. Credential values, SQL dumps and source bodies are not read by the validator.

## Limits and human/agent review

This lightweight parser handles conventional inline links/headings used here, not every CommonMark construct (reference-style links, embedded HTML anchors, complex nested link destinations). Fenced examples are skipped. Historical CHANGELOG and DATABASE_SCHEMA snapshots are excluded. Only selected explicit code-reference formats are checked, not arbitrary prose/globs or line/symbol validity. Frontmatter checks presence, not the entire YAML specification.

Passing checks does not prove truthful business statements, correct SQL/auth, actual coverage percentage, CI execution, live schema or deployment. Review examples against current code; schema snapshots remain dated evidence. Application changes still need their own regression/integration checks.

## Short scenario review after meaningful instruction changes

Ask a fresh reviewer to use only relevant guides, then compare its answer with current code/tooling:

1. Where is a response-preserving repository fix implemented/tested? Does its final read use the correct transaction?
2. What tests and coverage gate actually exist? Which commands alter README/module/source files?
3. Does code-edit authorization permit production writes, real OTP delivery or mailbox ingestion? It does not.
4. Can it distinguish proxy versus local routes, payroll file I/O versus DB persistence, and survey’s actual repository signature?
5. Can it find the path without loading every skill, schema snapshot or historical report?

Preserve the failing assumption, correct the smallest guidance gap, then repeat the relevant scenario. Do not expand documentation merely to hit a length/coverage target.
