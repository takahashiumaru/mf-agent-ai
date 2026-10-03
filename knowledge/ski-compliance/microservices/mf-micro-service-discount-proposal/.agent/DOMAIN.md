# .agent/DOMAIN.md — Domain Models, Terminology & Business Rules

> Read [current evidence and exceptions](EVIDENCE.md) and [repository rules](../AGENTS.md) before applying this topic. Prescriptive patterns below are design guidance; they do not prove every existing path follows them. Preserve documented exceptions, API exports and actual transaction ownership. Commands are not current execution evidence; application tests run only when requested.

## 1. Domain Overview & Business Context

In the pharmaceutical compliance and sales management domain (Metiska Farma / SKI), sales representatives, distributors, and outlets operate under structured discount programs. The system manages the approval, budget allocation, estimation, payout, and ledger reconciliation of these promotional discounts.

---

## 2. Core Terminology & Ubiquitous Language

| Term | Domain Meaning | Code Representation / Model |
| :--- | :--- | :--- |
| **Discount Proposal (Usulan Diskon)** | Formal proposal submitted by marketing personnel requesting approval for promotional discounts. | `domain.DiscountProposal` (`model/domain/discount_proposal.go`) |
| **Proposal Types** | Classification of proposal: `SKI1`, `SKI2`, `DPL` (Discount Price List), `DPF` (Discount Price Factur), `DPL2`. | Field `Type` validated by `discount_proposal_type` |
| **Credit Note (CN)** | Official credit deduction given to an outlet/customer for approved promotional claims against sales invoices. | `domain.CreditNote` (`model/domain/credit_note.go`) |
| **Customer Balance** | Running balance statement per customer per period tracking initial balance, SKI amounts, CN amounts, returns, and end balances. | `domain.CustomerBalance` (`model/domain/customer_balance.go`) |
| **Estimation** | Projected sales quantity, product pricing, and discount breakdown (Principal vs Distributor). | `domain.DiscountProposalEstimation` (`model/domain/discount_proposal_estimation.go`) |
| **Recipient (Penerima)** | Doctor, medical personnel, or entity receiving direct promotional disbursement, including bank details and tax calculations. | `domain.DiscountProposalRecipient` (`model/domain/discount_proposal_recipient.go`) |
| **Payment (Pencairan)** | Realization and disbursement status (transfer date, bank fee, cancellation status) of approved discount proposals. | `domain.DiscountProposalPayment` (`model/domain/discount_proposal_payment.go`) |
| **Confirmation** | Verification and approval status tracking for proposal documents. | `domain.DiscountProposalConfirmation`, `domain.DiscountProposalConfirmationStatus` |
| **Amortization** | Accounting amortization distributing promotional costs over future periods. | `domain.CreditNoteAmortization`, field `Amortization *bool` |
| **Organizational Roles** | Hierarchy levels: `MR` (Medical Rep), `SPV` (Supervisor), `ASM` (Area Sales Manager), `FSM` (Field Sales Manager), `KPST`, `Principal`. | `auth.AccessDetails`, `structure.MarketingStructure` |
| **Period** | Accounting period format: `YYYYMM` (e.g. `202403`) for monthly periods, `YYYYMMDD` for daily date strings. | Tag `validate:"period_month"`, `validate:"period_day"` |

---

## 3. Proposal Types & Specific Characteristics

1. **`SKI1` & `SKI2`**:
   - Focus on promotional agreements with medical professionals and healthcare facilities.
   - Require estimation details per customer and product.
   - For `SKI2`, `PeriodStart` cannot be older than the current active period (`request.Period > request.PeriodStart[0:6]` is prohibited).
2. **`DPL` (Discount Price List)**:
   - Price-list based discounts tied to distributor catalogs.
   - Support amortization (`Amortization = true`).
3. **`DPF` (Discount Price Factur)**:
   - Invoice-based (on-factur) discounts calculated directly from distributor sales invoices.
4. **`DPL2`**:
   - Secondary price-list discount scheme subject to start-period validation.

---

## 4. Proposal State Machine & Invariants

### Proposal Statuses
- `TEMPORARY`: Draft state, editable by creator.
- `INPUT`: Submitted for review/approval.
- `APPROVE`: Approved by designated authority (e.g. FSM, ASM, KPST, Principal).
- `REJECT`: Rejected with a mandatory note (`NoteReject`).
- `CANCEL`: Cancelled proposal.

```text
               ┌───────────────┐
               │   TEMPORARY   │
               └───────┬───────┘
                       │ submit
                       ▼
               ┌───────────────┐
         ┌────►│     INPUT     ├────┐
         │     └───────┬───────┘    │
         │             │ approve    │ reject
         │ edit/resub  ▼            ▼
         │     ┌───────────────┐ ┌───────────────┐
         └─────┤    REJECT     │ │    APPROVE    │
               └───────────────┘ └───────┬───────┘
                                         │ cancel/terminate
                                         ▼
                                 ┌───────────────┐
                                 │CANCEL / TERMIN│
                                 └───────────────┘
```

### Business Invariants
1. **Period Consistency**:
   - `PeriodEnd` MUST be greater than or equal to `PeriodStart` (`request.PeriodEnd >= request.PeriodStart`).
2. **Update Restrictions**:
   - Updates to proposals are ONLY allowed when status is in `["TEMPORARY", "INPUT", "REJECT"]` (`controller/discount_proposal_controller_impl.go:Update`).
   - Approved or locked proposals cannot be modified directly.
3. **Period Locking (Closing)**:
   - When a period is closed in the accounting system (`helper.ValidateClosing`), no transactions or proposals can be created, updated, or deleted for that period.
4. **Budget Checks**:
   - Proposals exceeding the allocated marketing structure budget trigger an over-budget status (`StatusOverBudget`) and require escalation approval.

---

## 5. Tax & Recipient Rules

In `model/domain/discount_proposal_recipient.go` and `helper/custom_validator.go`:
- **Tax Types (`tax_type`)**: `GROSS UP`, `TAX`, `NON TAX`.
- **NPWP Validation (`npwp`)**: 20-digit formatted pattern (`XX.XXX.XXX.X-XXX.XXX`).
- **KTP Validation (`ktp`)**: 16-digit Indonesian national identity number.
- **Transfer Types (`transferred_type`)**: `BO` (Bank Outlet), `504`.
- **Category User (`discount_proposal_category_user`)**: `Tenaga Medis`, `Dokter`, `Non Dokter`.
