# Domain

## Major Domains

### Gateway routing

`configuration.json` defines the public proxy surface and maps it to downstream Visit Flow services. The many visits, customers, structures, locations, surveys, presence, payroll, and synchronization endpoints are not implemented locally. Their business rules cannot be determined from this repository.

### Identity and users

Local behavior is implemented in `service/user_service_impl.go`, backed by `model/domain/users.go` and `repository/users_repository_impl.go`.

### Authentication and sessions

JWT creation/parsing is in `auth/auth.go`. Refresh-session storage and consumption use `model/domain/session.go` and `repository/session_repository_impl.go`.

### Roles and permissions

Roles, user-role assignments, and role-menu-permission assignments are represented by the corresponding files under `model/domain`, with route/controller/service/repository layers.

## Domain Entities

- `domain.User`: GORM user row, credentials, company/department information, device/token fields, notification token, employment dates, phone, and Telegram ID.
- `domain.Department`: a limited department projection/model used to return distinct user departments.
- `domain.Session`: refresh UUID, user ID, request metadata, expiry, and two checkpoint flags.
- `domain.Role`: named role with audit fields and GORM associations to user roles and permissions.
- `domain.UserRole`: composite `RoleID`/`UserID` assignment plus audit fields.
- `domain.RoleMenuPermission`: composite string `RoleID`/`PermissionID` assignment plus audit and soft-delete fields.

The structs are both domain and persistence models; they contain GORM tags. They map to web DTOs through methods such as `User.ToUserResponse` and `Role.ToRoleResponse`.

## Proven Business Rules

### User creation and update

- `UserCreateRequest` requires username, password, email, and name. Username/password/email/name lengths and gender values are validator-tagged in `model/web/users_create_request.go`.
- Creation additionally accepts only an alphanumeric username through a regular expression in `UserServiceImpl.Create`.
- New passwords are bcrypt-hashed with `bcrypt.DefaultCost`.
- `JoinDate` is set to the current timestamp string on normal user creation.
- At most the first uploaded user image is saved; the filename uses the requested name plus a Unix timestamp.
- Normal user update derives `CompanyID` from authenticated access details rather than trusting form input.
- `UpdateNoAuth` updates phone/Telegram for an existing row or creates a default Administrator/company-1 user when the ID does not exist. This behavior is security-sensitive and should not be altered incidentally.
- Password change requires the old bcrypt password to match and requires new/retype values to be equal.
- Reset password writes a fixed precomputed bcrypt hash and clears the device ID. The plaintext represented by that hash is not established in repository evidence.

### Login, tokens, and sessions

- Login uses HTTP Basic Auth values as the structure/user identifier and password (`controller/users_controller_impl.go`).
- User/structure lookup and MR structure lookup run concurrently; either error makes login fail without a token.
- Employment lookup excludes users whose non-empty resignation date is not in the future (`repository/users_repository_impl.go`).
- Access tokens expire after 10 days and refresh tokens after 11 days (`auth.CreateToken`).
- Signing uses HMAC secrets from `ACCESS_SECRET` and `REFRESH_SECRET`.
- On login, existing sessions for the user are hard-deleted, one new session is created, and the new access/refresh/device data is stored atomically.
- A stored access token must exactly match the presented token and the user must not be soft-deleted. This is how replacement login/logout revokes old access tokens.
- Refresh rotation consumes the presented session row with a hard delete. Exactly one affected row is required; replayed/missing sessions are unauthorized.
- Refresh consumption, replacement session creation, and user token update occur in one `DB.Transaction`.
- Refresh is allowed only when the current `YYYYMM` equals the resolved user's structure period.
- `UpdateAccessToken` deletes all sessions and replaces access token, refresh token, and device ID with `"-"` in one transaction.

### Device security notification

When a login supplies a non-empty/non-`-` device ID different from the stored device, and the prior Firebase token is usable and differs from the new one, the service asynchronously sends a security alert to the prior device. Notification failure is logged and does not fail login.

### Roles and permissions

- Only one explicit role constant exists: `Administrator` (`auth/role.go`).
- Role, user-role, and role-menu-permission routes pass `Administrator` to `auth.Auth`.
- The actual role membership check is commented out in `auth.Auth`; therefore repository evidence does not establish effective role-based authorization.
- User-role identity is the composite `(user_id, role_id)` pair.
- Role-menu-permission identity is the composite `(role_id, permission_id)` pair.

## Statuses and State Transitions

No general local status enum or state machine was found.

The observable token/session transition is:

`credentials verified -> old sessions deleted -> new session/token stored -> refresh session consumed -> replacement session/token stored -> logout/revocation deletes sessions and invalidates stored tokens`

The visit/customer approval statuses visible in `configuration.json` belong to downstream services; their rules are not established here.

## Invariants

- Persisted passwords created or changed through the normal services are bcrypt hashes.
- A refresh UUID is unique (`domain.Session` tag) and intended for one-time consumption.
- The current access token is bound to the user row for revocation checks.
- A multi-write login/refresh/logout operation must remain atomic.
- Soft-deleted users must not pass explicit authentication queries.
- Composite role assignment keys must remain consistent with repository predicates.

## Domain Terminology

- `Nip`: employee/personnel identifier used in user/department reporting.
- `MR`: a structure hierarchy variant used by `JoinUserAndStructureMR`; its full business expansion is not clearly established in the current repository.
- `MKT` / `MARKETING ETHICAL`: departments that set the `is_mkt` JWT claim.
- `structure_id`, `boss_code`, `period`, `level`: hierarchy fields read from downstream-owned database tables to build JWT claims.
- `permission_id`: stored menu/permission string and emitted as `menu` in access reports.

## Sensitive Logic

Inspect callers and tests before changing:

- `service/user_service_impl.go`: credentials, concurrency, token rotation, sessions, password changes, and notification triggers.
- `auth/auth.go`: signing, claims, global DB revocation check, and route auth behavior.
- `repository/users_repository_impl.go`: employment eligibility and recursive hierarchy SQL.
- `repository/session_repository_impl.go`: hard deletion and single-use refresh semantics.
- Unauthenticated routes in `route/users_route.go`.
