# .agent/DATABASE.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Database & Persistence Architecture

### Gateway Persistence Scope

`ski-api-gateway` operates primarily as a **stateless HTTP reverse proxy and ingress gateway**. 

- **Local Persistence in Gateway**:
  - `api_keys.json`: Local JSON file storing active service account API keys with memory cache and auto-reload on modification time change (`helper/api_key.go`).
  - `file/user_access/`: Local CSV files storing user route and action permissions parsed via `gocarina/gocsv` (`pkg/auth/access_auth.go`).
  - In-memory state: IP access tracking maps and blocklists (`helper/block_acces.go`).

- **Relational Databases (Downstream Microservices)**:
  - Downstream microservices (such as `mf-micro-service-ski-discount-proposal`, `mf-micro-service-ski-compliance-warehouse`, `mf-micro-service-ski-auth`, etc.) connect to MySQL databases.
  - Configuration sample strings in `dev.env` (`DB_DSN_SOURCE_1`, `DB_DSN_Replication_1`) reference `chiron_product_stock_db` with `utf8mb4` charset and `parseTime=True`.
  - Database schema migrations, table creation, and primary/replica replication are managed by the individual microservice codebases.

---

## Downstream Database Invariants

When interacting with downstream services or troubleshooting errors passed through the gateway:

1. **MySQL Engine & Collation**: MySQL 8.x with `utf8mb4` / `utf8mb4_unicode_ci`.
2. **Error Translation at Gateway**:
   - `exception/error_handler.go` intercepts MySQL error strings passed in panics or responses:
     - `Error 1062: Duplicate entry` -> Mapped to HTTP 400 Bad Request via `helper.ErrorDuplicateMessage(err)`.
     - `Error 1452: Cannot add or update a child row` -> Mapped to HTTP 400 Bad Request with message `"A foreign key constraint fails"`.
     - `"record not found"` -> Mapped to HTTP 200 OK with `{ "success": true, "message": "Record not found" }` for legacy client compatibility.
