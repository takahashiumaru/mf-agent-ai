# Survey Helper Placement Implementation Plan

> Execution record: followed the repository's `safe-refactoring` and `go-testing` guidance. Changes were left uncommitted during implementation and published only after the user later authorized a branch and push.

**Goal:** Put reusable, pure survey key formatting in `helper` while leaving business orchestration, typed request mapping, and persistence in their current owning packages.

**Architecture:** `service` still chooses the clock value, period, tenant, repository call, and transaction handle. A focused `helper/survey_id.go` formats only the three existing survey-related keys. The helper accepts values as arguments and has no dependency on Gin, auth, GORM, domain models, or web DTOs.

**Tech Stack:** Go 1.23, Gin, GORM, testify, and the existing `test/` package.

## Current ownership and decision

| Function or responsibility | Current location | Decision | Reason |
| --- | --- | --- | --- |
| `surveyCustomerID` | `service/outlet_survey_customer_service_impl.go:163` | Move to `helper/survey_id.go` as `SurveyCustomerID` | Pure date/key formatting, used by two create paths. |
| `surveyCustomerProductKey` | `service/outlet_survey_customer_product_service_impl.go:155` | Move to `helper/survey_id.go` as `SurveyCustomerProductKey` | Pure composite key formatting, used by read and upsert paths. |
| Survey ID formatting | `service/outlet_survey_service_impl.go:61,133` | Move formatting to `helper/survey_id.go` as `OutletSurveyID` | Same ID rule appears in two paths; service retains period calculation. |
| `outletSurveyForUpsert` | `service/outlet_survey_mapping.go:11` | Keep in `service` | Maps a specific request and actor ID into a domain model, including audit and request fields. Exporting it from the shared `helper` package would broaden its interface and add domain/web dependencies to a package also used by auth and repositories. |
| `newDistributorForCreate`, `distributorForUpdate` | `service/distributor_service_impl.go:94,113` | Keep in `service` | These are single-domain input mappers with different create/update audit and company semantics. No other package reuses them. |
| `strings.Join(request.DistributorID, ",")` and `strconv.Itoa(int(auth.UserID))` | Survey and distributor service paths | Keep the standard library calls at their current sites | A helper would only wrap one standard library expression while hiding the existing ordering and conversion behavior. |
| Validation, transaction selection, lookup/update decisions | Service methods | Keep in `service` | Moving these into `helper` would hide business order and error behavior. |
| GORM queries and HTTP parsing | `repository`, `controller` | Keep in the existing owners | No dependency or behavior change is needed for this extraction. |

The current import graph allows `service → helper` without a cycle. Keep `helper/survey_id.go` independent of `model/domain` and `model/web` so existing auth/controller/repository imports of `helper` do not gain a new domain dependency. Do not introduce a generic variadic key builder: the date-prefixed customer ID and non-prefixed product lookup key have different contracts.

## Behavior that must remain exact

- Survey ID: `YYYYMMDD` from the current local `time.Now()` formatting, followed by `-` and the selected body or path outlet ID. New survey `Period` remains that date; update retains request `Period`.
- Customer ID: `YYYYMMDD-<outletSurveyID>-<customerID>` using the service's current `time.Now()` call.
- Product lookup key: `<outletSurveyID>-<customerID>` using the supplied survey ID, with no extra date prefix.
- Preserve empty strings, existing hyphens, ordering, duplicate distributor IDs, actor audit fields, company fields, validation, ignored lookup errors, repository calls, transaction selection, and response/error behavior. The already identified JWT, tenant-scope, lookup-error, and transaction-lifecycle defects require separate behavior-changing fixes.
- Keep public service/repository interfaces, route wiring, schema, and SQL unchanged.

## Task 1: Extract survey key formatting

**Files:**

- Create: `helper/survey_id.go`
- Create: `helper/survey_id_test.go`
- Modify: `service/outlet_survey_service_impl.go`
- Modify: `service/outlet_survey_customer_service_impl.go`
- Modify: `service/outlet_survey_customer_product_service_impl.go`

**Interfaces:**

```go
func OutletSurveyID(period, outletID string) string
func SurveyCustomerID(now time.Time, outletSurveyID, customerID string) string
func SurveyCustomerProductKey(outletSurveyID, customerID string) string
```

- [x] Add a focused test in `helper/survey_id_test.go` and first confirm it fails because the helper functions are absent:

```go
package helper_test

import (
    "testing"
    "time"

    "github.com/stretchr/testify/require"
    "gitlab.com/VNEU/visit-flow-survey-location-go/helper"
)

func TestSurveyIDHelpers(t *testing.T) {
    now := time.Date(2026, time.September, 27, 0, 30, 0, 0, time.FixedZone("WIB", 7*60*60))
    require.Equal(t, "20260927-outlet-1", helper.OutletSurveyID(now.Format("20060102"), "outlet-1"))
    require.Equal(t, "20260927-survey-1-customer-1", helper.SurveyCustomerID(now, "survey-1", "customer-1"))
    require.Equal(t, "survey-1-customer-1", helper.SurveyCustomerProductKey("survey-1", "customer-1"))
    require.Equal(t, "survey-", helper.SurveyCustomerProductKey("survey", ""))
}
```

Run: `go test ./test -run '^TestSurveyIDHelpers$' -count=1`. Expected before implementation: compile failure for the three missing helper symbols.

- [x] Implement only the existing formatting in `helper/survey_id.go`:

```go
package helper

import (
    "fmt"
    "time"
)

func OutletSurveyID(period, outletID string) string {
    return fmt.Sprintf("%s-%s", period, outletID)
}

func SurveyCustomerID(now time.Time, outletSurveyID, customerID string) string {
    return fmt.Sprintf("%s-%s-%s", now.Format("20060102"), outletSurveyID, customerID)
}

func SurveyCustomerProductKey(outletSurveyID, customerID string) string {
    return fmt.Sprintf("%s-%s", outletSurveyID, customerID)
}
```

- [x] Import `gitlab.com/VNEU/visit-flow-survey-location-go/helper` as `surveyHelper` in the three affected service implementation files. Replace the call sites exactly as follows, then remove the two old package-local functions and now-unused `fmt` imports:

```go
// service/outlet_survey_service_impl.go: Create and CreateSurveyOutlet
id := surveyHelper.OutletSurveyID(period, request.OutletID)
id := surveyHelper.OutletSurveyID(period, outletSurveyID)

// service/outlet_survey_customer_service_impl.go: Create and CreateOutletSurveyCustomer
id := surveyHelper.SurveyCustomerID(time.Now(), request.OutletSurveyID, request.CustomerID)
id := surveyHelper.SurveyCustomerID(time.Now(), outletSurveyID, request.CustomerID)

// service/outlet_survey_customer_product_service_impl.go: FindByOutletSurveyCustomerID and CreateOutletCustomerProduct
outletSurveyCustomerID := surveyHelper.SurveyCustomerProductKey(*outletSurveyID, *customerID)
```
- [x] Format changed Go files with `gofmt`; rerun `go test ./test -run '^TestSurveyIDHelpers$' -count=1`. Result: pass.
- [x] Run `go test ./test -run 'TestOutletSurveyServiceCharacterization|TestChildren(Customer|Product)UpsertContract' -count=1`. Result: pass with the same IDs, call order, actor/company fields, response data, and insert/update selection. Review confirmed no transaction or repository call changed.

## Task 2: Document ownership and verify the whole change

**Files:**

- Modify: `service/doc.go`
- Modify: `.agent/ARCHITECTURE.md`

- [x] State in package documentation that `service` owns business decisions and typed request mapping while `helper/survey_id.go` formats the three survey keys. Keep the description short and consistent with `ARCHITECTURE.md`.
- [x] Run `go test ./... -count=1`, `go vet ./...`, `go build ./...`, and `git diff --check`. Result: all pass. Review confirmed routes, public interfaces, SQL, schema, auth, and transaction code are untouched.
- [x] Verify the `test/` directory owns the added test. During implementation, leave the plan and source changes uncommitted until the user authorizes publication.

## Scope decision

Do not move `outletSurveyForUpsert` or the distributor mapping functions into shared `helper` in this pass. They are request-to-domain adapters used only by their owning service; exposing them from `helper` would increase coupling without reuse. If a second package needs the same mapping contract, revisit the interface and place a focused adapter where both callers can use it without a dependency cycle.
