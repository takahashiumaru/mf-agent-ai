# Payroll Domain

- PDF retrieval: controller builds a period directory with `helper.BuildPayrollPath`; service FindFile appends the user ID and PDF extension and reads bytes. Missing/read-error paths currently return nil, not a typed not-found error.
- NIP search: FindByNip walks the configured payroll tree and matches a filename substring. Do not describe this as strict identity/ownership validation.
- CountFile: lists non-directory entries for a period; this is not automatically a count of validated PDFs or employees.
- Period formatting: `helper/path_payroll.go` supports current-month defaults and explicit formats. Verify business timezone and parsing branches before modifying dates.
- ProcessByEmail: IMAP/attachment ingestion with filesystem effects. Inspect only necessary code and synthetic fixtures; real mailbox/payslip records are sensitive.
- OTP issuance/validation: email/Telegram token logic in the service. Trace storage/expiry/consumption/concurrency and caller ownership; endpoint presence does not prove download enforcement.
