# Security boundaries and controls

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Scope

Focused static review of auth routing and representative persistence at the revision recorded in `AGENTS.md`; this is not a complete security audit and does not establish deployed behavior.

## Local JWT handling and actual route scope

Local `auth/auth.go` contains JWT error/validity handling that needs review: parse errors are discarded; the downstream validity/error behavior differs in the sync service. This is a local source finding, not proof that every endpoint uses that implementation or is exploitable.

For this repository, static route handler imports are: `gitlab.com/VNEU/mf-micro-service-master-document-proposal/auth`: 19 declarations See [EVIDENCE.md](EVIDENCE.md) and the [route index](../../.agent/generated/ROUTE_INDEX.md). Gateway-auth imports must be reviewed at the pinned dependency version. No route-level wrapper is not proof that global/gateway protection is absent. Assess authentication separately from object/role authorization.

For a scoped security fix, verify malformed, expired, tampered, missing and wrong-algorithm token behavior in an isolated environment, along with valid-token controls. No exploit or runtime validation was performed in this documentation task.

## Verified mechanisms and open questions

- Local signing-method/validity checks must be inspected in the actual imported implementation. Do not extrapolate local helper behavior to all deployed services.
- Role checks appear commented out in sampled `Auth` implementations; route-level access may also use CSV permissions or gateway controls. Inspect routes/callers before concluding operation coverage.
- Token issuer, required claims/issuer/audience, revocation, rotation, and production secret source: **Needs investigation**. Do not copy env values.
- Verify tenant/company/structure scope in each query; derive trusted scope from authenticated claims rather than request-controlled IDs.
- Review raw SQL values for placeholders and dynamic identifiers for allowlists. Parameterization alone does not prove safe scope.
- File/SSRF/request-size/rate-limit/TLS/cookie/CSRF/DB least-privilege controls: **Needs investigation** where relevant paths exist.
- Inspect logs and middleware. Never log tokens, secrets, or full sensitive records; verify redaction with synthetic data.

## Control ownership and negative-test checklist

| Control | Evidence and owner | Negative test when applicable |
|---|---|---|
| Authentication | Exact imported auth middleware plus global/gateway wiring; service/security maintainer owns token validation. Issuer, claims policy, and secret rotation need investigation. | Invalid, expired, tampered, missing, and wrong-algorithm tokens are rejected before the handler. |
| Authorization and tenant/object scope | Route middleware and query predicates; route/service owner. Full route coverage needs investigation. | Authenticated actor from another role/company/structure cannot read or mutate an object outside scope. |
| Request/query input | Controller binding, validator, `helper/` filters, and repository SQL; endpoint/repository owner. Field allowlists and maximum sizes need endpoint review. | Unknown writable field is ignored/rejected; malicious sort identifier is rejected; empty filters do not broaden a mutation. |
| Outbound requests and files | Inspect route/service/helper call sites before assigning a control owner; **Needs investigation** when such an operation exists. | Reject disallowed destination/redirect or path traversal; enforce upload size/type/access checks when file endpoints exist. |
| Resource exhaustion | HTTP server/router, query bounds, exports, and background work; service owner. Limits/rate controls need investigation. | Oversized requests and unbounded pagination/batches are rejected or capped without excessive work. |
| Logs, secrets, and dependencies | `configuration/`, router/logger setup, Docker/CI and `go.mod`; service/platform owner. Redaction and least privilege need deployment evidence. | Synthetic secret/token never appears in captured logs/errors; dependency findings receive compatibility review before upgrades. |

For controls marked **Needs investigation**, identify the owning team and test boundary before claiming protection. Use synthetic data and isolated environments.

## Security workflow

Trace untrusted input through route, handler, service, repository, and external/file operation. Test allowed and denied cases, including object-level access. Report evidence, preconditions, confidence, impact, smallest fix, and verification gap. Do not probe production or expose secrets.
