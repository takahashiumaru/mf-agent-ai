# Survey Workflows

Use AGENTS for mandatory rules, INDEX for routing, QUALITY_GATES for completion.

## Feature or bug fix

1. Trace the actual module route/controller/service/repository/model/mapper and callers.
2. State request/JSON/status, tenant/company and business-key invariants.
3. Read relevant model/schema metadata; verify transaction handles, errors, deletion and association effects.
4. Add a meaningful regression test using existing `test/` helpers/mocks.
5. Implement the smallest coherent change; update every affected interface/mock.
6. Run focused tests then broader checks by risk; disclose live DB/API gaps.

## Nested survey changes

Inspect CreateSurveyOutlet and the related customer/question/product persistence methods before editing. Verify complete graph ownership, composite keys, duplicate submission behavior, company scope, and rollback at each failing write. Do not infer idempotency from a generated ID or a Create call.

## Queries and schema

Repository methods accept `*gorm.DB`. Service-selected writer handles must cover mutations and dependent reads. Check zero-value patches and query cardinality. No migration mechanism is established locally; follow workspace metadata and DEV-confirmation rules for concrete DB mutations.

## Refactor

Use characterization tests for DB/JSON/error compatibility and retain public interfaces unless the task includes changing them. Examples in PREFERRED_PATTERNS are navigation aids, not proof every existing implementation is safe.
