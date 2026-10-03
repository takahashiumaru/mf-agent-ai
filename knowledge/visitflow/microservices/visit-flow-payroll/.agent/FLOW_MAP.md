# Payroll Flow Map — Optional Navigation

Use this only when the affected path is unclear. Read exact methods; source navigation does not prove deployment or full test coverage.

| Flow | Entry and implementation | Important boundary |
| --- | --- | --- |
| PDF retrieval | [route](../route/payroll_route.go) → [controller FindFile](../controller/payroll_controller_impl.go) → [service FindFile](../service/payroll_service_impl.go) | Binary response; no OTP check in FindFile |
| NIP search / count | Same controller/service: FindByNip / CountFile; [period helper](../helper/path_payroll.go) | Filename matching/counting is not verified ownership or PDF validation |
| IMAP ingestion | ProcessByEmail in the same route/controller/service | Mailbox reads and file writes; use synthetic/fake I/O |
| OTP | PayrollToken / PayrollTokenValidate; [request DTO](../model/web/telegram_request.go) | Email/Telegram delivery and token lifecycle; not automatically download authorization |

[Auth wrapper](../auth/auth.go) includes an IP-based JWT bypass; check the actual wrapper on each route. No local repository layer backs these flows. Existing [helper tests](../helper/model_test.go) do not prove PDF/IMAP/OTP behavior; TESTING.md describes the gap.

After changing these paths, use the workspace guidance validator with `--repo visit-flow-payroll --drift`, then inspect affected contracts and external effects directly.
