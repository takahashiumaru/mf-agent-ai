# Payroll Security and External I/O

Auth and ownership are separate. Inspect auth.Auth, gateway and route wrappers; role slices are not proof of enforcement. Allowlisted client IPs bypass JWT and receive empty access details in the current wrapper. Thus wrapping a route does not guarantee a verified user identity for every request; IP checks are not a substitute for user/resource ownership. Treat current unwrapped ingest/OTP routes and missing OTP enforcement on FindFile as limitations to review, not patterns to spread.

For changes, trace path containment/traversal, period and NIP matching, caller ownership, file permissions, overwrite/retry and partial writes. Separate validation from side effects and prefer atomic file replacement only when its compatibility is established.

For ingestion, inspect IMAP selection/fetch/attachment filtering, duplicate handling, resource closure, timeouts/cancellation and partial failures. For OTP, inspect generation, shared state, expiry, retry/consumption and delivery failures. Never log tokens or personal/payroll content.

Use temporary synthetic fixtures and fake transports. Do not invoke live mailbox, email/Telegram delivery or file ingestion as a smoke test. Existing credentials in source/configuration are sensitive: do not copy their values into docs, prompts or test fixtures. Database mutations, if introduced, still follow the parent workspace DEV confirmation rules.
