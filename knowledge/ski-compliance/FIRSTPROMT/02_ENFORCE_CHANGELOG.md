# 02 — Define and Enforce the Engineering Changelog

## Purpose

Maintain one concise history of how the repository's AI engineering guidance evolves.

Run this prompt after `01_BUILD_REPOSITORY_CONTEXT.md`, before other prompts make repository changes.

Create or update `.agent/CHANGELOG.md` and add routing only where needed in `AGENTS.md` or `.agent/INDEX.md`. Write in English. This task does not authorize staging, committing, or pushing. The Git workflow below applies only when the user separately requests that operation; otherwise leave the guidance changes unstaged.

## Changelog scope

`.agent/CHANGELOG.md` is for the AI engineering system itself. It is **not** the backend application's release changelog and must not be updated for every ordinary source-code commit.

Update it only when a change materially affects:

- `AGENTS.md` or `.agent/INDEX.md` routing;
- engineering standards or preferred/deprecated patterns;
- architecture or GORM guidance;
- database/query-performance rules;
- testing, migration, security, observability, CI, or refactoring rules;
- quality gates or skill behavior.

Do **not** update it for ordinary features, application bug fixes, routine refactors, or application releases unless that work also changes the engineering guidance. Follow a separate application changelog/release-note convention if the repository defines one.

## Required workflow

### When an engineering-guidance change is committed

1. Read repository instructions and the current changelog format.
2. Inspect the documentation/skill diff and identify the material rule change.
3. Add one concise entry explaining what changed and, when useful, why.
4. When a pattern becomes legacy or deprecated, name the preferred replacement.
5. Do not copy the full contents of `AGENTS.md` or a `SKILL.md` into the changelog.
6. Stage `.agent/CHANGELOG.md` with the related engineering-guidance files.
7. Recheck the staged diff before committing.

### Before pushing engineering-guidance changes

1. Confirm every material engineering-rule change is represented.
2. Confirm ordinary application changes were not added merely to satisfy a per-commit ritual.
3. Never rewrite shared or already-pushed history without explicit user authorization.
4. Push only after documentation validation succeeds.

## Entry format

Use sections `Added`, `Changed`, `Deprecated`, `Removed`, and `Fixed` as applicable. Add the newest entry at the top of the change entries, below the introduction:

```markdown
## YYYY-MM-DD — Short engineering-guidance title

### Changed
- Query optimization guidance now requires execution-plan evidence for high-impact queries.
- Reason: Prevent speculative indexes and unverifiable performance claims.
```

Omit empty sections. Keep entries short and record rationale only when it helps explain the evolution of a rule.

## Example

```markdown
## 2026-09-20 — Strengthen GORM partial-update guidance

### Changed
- Prefer explicit field selection or map updates when zero values must be persisted.
- Reason: `Updates(struct)` normally omits zero-value fields.

### Deprecated
- Using `Save` for partial updates.
```

## Hard gates

- Do not use this file as the application release changelog.
- Do not add entries for routine feature or bug-fix commits that leave engineering guidance unchanged.
- Do not require future agents to read the changelog during normal coding tasks.
- Do not combine unrelated guidance changes into one vague entry.
- Do not delete, rewrite, or reorder historical entries without explicit instruction.
- Do not expose secrets, tokens, credentials, customer data, or sensitive infrastructure details.

## Active source of truth

Future coding agents should normally read, in this order:

1. `AGENTS.md`;
2. `.agent/INDEX.md`;
3. relevant `.agent/` topic documentation;
4. relevant `SKILL.md` files.

Read `.agent/CHANGELOG.md` only when historical context is needed—for example, to understand why a pattern became legacy or why a quality rule changed.

## Final checklist

- [ ] The change materially affects engineering guidance.
- [ ] The entry states the rule change concisely.
- [ ] Deprecations name the preferred replacement when applicable.
- [ ] The entry does not duplicate full instruction documents.
- [ ] If a commit was requested, `.agent/CHANGELOG.md` is included with the related guidance changes; otherwise files remain unstaged.
- [ ] Active instructions remain in `AGENTS.md`, `.agent/`, or relevant skills—not only in the changelog.

If any item fails, stop the commit/push workflow and correct it first.

## Next step

After enforcing this policy, run `03_ASSESS_LEGACY_QUALITY.md`.
