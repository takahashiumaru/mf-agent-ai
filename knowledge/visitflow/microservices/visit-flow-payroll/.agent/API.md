# Payroll API Navigation

Local route authority: `route/payroll_route.go`.

| Method/path | Flow | Current wrapper |
| --- | --- | --- |
| GET `/payrolls` | PDF bytes via FindFile | auth.Auth |
| GET `/payrolls-by-nip/:nip` | JSON file list | auth.Auth |
| GET `/payroll-count-file` | JSON count/list | auth.Auth |
| POST `/payroll-by-emails` | IMAP ingestion | No auth.Auth wrapper |
| GET `/payroll-token` | OTP issuance | No auth.Auth wrapper |
| POST `/payroll-token-validate` | OTP validation | No auth.Auth wrapper |

These are local source observations, not proof of public deployment or acceptable policy. Trace gateway mappings separately. The token controller reads a request body even on the GET issuance route; do not normalize method/body behavior without reviewing clients.

FindFile does not call OTP validation. Do not claim an OTP request protects downloading. Preserve byte versus JSON response, headers/status, period/default behavior and error mapping in scoped fixes; security-policy changes require explicit requirements.
