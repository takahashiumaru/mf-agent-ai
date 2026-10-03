# Architecture

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Verified structure

`main.go` loads configuration, initializes database handle(s), creates a validator, obtains the router from `app.NewRouter`, and serves HTTP. `app/router.go` installs middleware and registers route constructors: `AccountRoute`, `BankBranchRoute`, `BankRoute`, `BankTransferFeeRoute`, `DiscountProposalTransferredTypeRoute`. The usual file/package split is route → controller → service → repository; confirm each flow because repository conventions can differ.

## Dependency direction and wiring

Database handles and validator are passed into route setup. Constructors/wiring are visible in `route/*`; inspect the target route for the concrete dependencies. There is no evidence here for a separate dependency-injection container.

## Request lifecycle and side effects

Trace `route → controller → service → repository → database/external side effect`. Validation and response mapping may reside in controller or helper code; establish ownership from the specific endpoint. Transaction ownership: Not clearly established in the current repository globally; inspect `helper/tx.go` and the complete service/repository call path. External side effects must be traced at their call sites.

## Current evidence and shared guidance

See [EVIDENCE.md](EVIDENCE.md) for the concrete source trace, auth import scope and schema/data routing. For business-data questions, follow the workspace [data-first answer contract](../../.agent/DATA_ANSWERS.md).
