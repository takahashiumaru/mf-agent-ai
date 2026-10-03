# Domain context

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Areas visible in route registration

The service covers synchronization endpoints for structure, location, customer, user, position, and specialist data across VisitFlow/SKI/ERP connections. Route-level entities observed in `route/`: `customer`, `customer location`, `customer postion`, `customer specialist`, `location`, `structure`, `structure location`, `user`, `user erp`.

These names identify API/resource areas, not complete business rules. State transitions, ownership rules, period/closing behavior, uniqueness requirements, and cross-module invariants: Not clearly established in the current repository. Find evidence in service implementations, model validation, and tests before changing them.

## Flow investigation

For any domain change, trace the route/controller/service/repository chain and inspect all writes and external calls. Do not infer that similarly named resources share lifecycle or authorization rules.

## Current evidence and shared guidance

See [EVIDENCE.md](EVIDENCE.md) for the concrete source trace, auth import scope and schema/data routing. For business-data questions, follow the workspace [data-first answer contract](../../.agent/DATA_ANSWERS.md).
