# Model alignment — 2026-09-27

## Scope and evidence

Local source changes in bank, customer, event, marketing-user, outlet-2 and product. Based on SKI_MF_PROD metadata captured at 2026-09-27 01:57:48 UTC. No database writes, migrations, service startup or deployment were performed.

## Changes

| Repository | Correction |
|---|---|
| bank | Account.VerifyByID and matching request/response use int64 for signed bigint; request rejects negative IDs. Existing zero/null API representation remains unchanged. |
| customer | Customer.Status maps nullable customers.status as a read-only field. |
| event | EventClass and EventHeader primary-key tags now identify only ID; Fee and matching DTOs use float64 for double; History.Data size is 8000. |
| marketing-user | Removed Nip primary-key tag; embedded gorm.Model.ID remains the primary key. |
| outlet-2 | Outlet.IsActive permits null; removed invalid bare index tag; History.Data size is 8000. |
| product | ProductProgram ID and ProductMaxDiscount.ProductProgramID sizes are 8; removed non-ID primary-key tags from ProductProgram; mapped 17 additional product and 10 product-price columns. |

Additional database fields have `gorm:"->;-:migration"` permissions plus explicit column/type tags and `json:"-"`. They can be read by GORM, are excluded from GORM writes/migration, and do not extend existing response/history JSON. The existing product Division association is preserved; LegacyDivision maps the scalar division column. Nullable additional columns use pointers. Existing ProductPrice composite key and API write fields are retained.

## Unresolved database targets

- Bank DiscountProposalTransferredType CRUD targets discount_proposal_transferred_types, absent from captured metadata. Its Accounts association also names DiscountProposalTransferredTypeID, absent from Account. An intended relationship/table must be established before changing these flows.
- CustomerProfile Create/Update/Delete explicitly target summary_customers, absent from captured metadata. No supported replacement was found in the inspected repository mappings.

Neither endpoint was removed or redirected to a guessed table. Resolving these requires the intended schema/object mapping or a separately authorized schema deployment. Production remains read-only.

## Verification and limits

- gofmt applied to 17 changed Go files.
- Offline AST/schema comparison: 53 domain structs, 44 matched table models, zero missing declared columns, zero modeled type/tag warning groups, two unresolved persistence targets. All previously unmapped columns in the compared models are now mapped.
- `GOPROXY=off GOSUMDB=off GOFLAGS=-mod=readonly go build ./...` succeeds for bank and customer.
- The same build is blocked for event, marketing-user, outlet-2 and product by missing cached module versions, including private GitLab modules. Dependencies were not substituted or upgraded. Full compilation of those four repositories is unverified.
- Comparison is static and uses conventional table naming; it is not exhaustive proof of association correctness, null semantics, indexes, write behavior, or runtime compatibility. No application test suite or production mutation was run.
- Cross-service consumers use pinned module versions; local fixes do not automatically update other services or deployed binaries.
