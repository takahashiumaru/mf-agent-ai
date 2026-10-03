# Payroll Workflows

1. Select the concrete route and controller/service method; distinguish PDF bytes, JSON metadata, ingestion and OTP.
2. State current/desired behavior and owner/period/path/response invariants. Trace external effects before executing anything.
3. Inspect helper/auth/DTO callers; introduce only the dependency seams needed for deterministic tests.
4. Add a focused failing regression using synthetic files in temporary directories or fake mailbox/notification transports.
5. Implement the smallest change, checking error/context/resource lifecycle and partial external effects.
6. Run targeted tests, build/vet and broader checks as appropriate; disclose missing service/integration coverage.

Analysis-only questions stop after evidence/recommendations. Implementation does not authorize sending OTP messages or modifying a real mailbox/payroll tree. See SECURITY_AND_IO and workspace rules.
