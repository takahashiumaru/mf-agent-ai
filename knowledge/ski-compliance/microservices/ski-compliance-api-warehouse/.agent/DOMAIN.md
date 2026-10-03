# Domain context

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Areas visible in route registration

The service covers warehouse, sales, stock, discount, credit note, customer, and marketing reporting/process endpoints. Route-level entities observed in `route/`: `call pareto`, `credit note`, `credit note gt`, `credit note gt customer`, `credit note gt outlet`, `credit note gt product`, `customer estimasi vs cn`, `customer family`, `customer hobby`, `customer media social`, `customer note`, `customer task`, `customer timeline`, `customer work practice`, `data bp teguh process`, `discount`, `discount gt`, `discount gt customer`, `discount gt outlet`, `discount gt product`, `distributor product`, `gt customer header`, `gt outlet header`, `gt product header`, `k4 wh`, `marketing absent`, `sales gt outlet wh`, `sales gt product wh`, `sales gt wh`, `sales out wh process`, `sales stock distributor`, `sales stock principal`, `ski`, `sp warehouse`, `stock distributor`, `stock header`, `target marketing`, `update structure new`.

These names identify API/resource areas, not complete business rules. State transitions, ownership rules, period/closing behavior, uniqueness requirements, and cross-module invariants: Not clearly established in the current repository. Find evidence in service implementations, model validation, and tests before changing them.

## Flow investigation

For any domain change, trace the route/controller/service/repository chain and inspect all writes and external calls. Do not infer that similarly named resources share lifecycle or authorization rules.

## Current evidence and shared guidance

See [EVIDENCE.md](EVIDENCE.md) for the concrete source trace, auth import scope and schema/data routing. For business-data questions, follow the workspace [data-first answer contract](../../.agent/DATA_ANSWERS.md).
