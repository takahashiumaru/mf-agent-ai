# .agent/PROJECT.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Service Purpose & Responsibilities

`ski-api-gateway` acts as the primary ingress point and API gateway for the SKI (Surat Keputusan Insentif) Compliance microservice platform. It intercepts all incoming client HTTP traffic, applies security and routing policies, and delegates backend execution to dedicated domain microservices.

### Primary Responsibilities

1. **Routing & Ingress**: Maps incoming API paths to appropriate downstream microservice containers (e.g., `mf-micro-service-ski-auth`, `mf-micro-service-ski-discount-proposal`, `mf-micro-service-ski-warehouse`, etc.).
2. **Authentication**:
   - **JWT Validation**: Inspects incoming `Bearer <token>` headers, verifies HMAC-SHA256 signatures against `ACCESS_SECRET`, and parses claims.
   - **API Key Management**: Checks `X-API-Key` headers, query parameters, or `ApiKey` authorization headers against cached entries in `api_keys.json`, generating internal JWT claims on match.
3. **CORS Enforcement**: Handles preflight `OPTIONS` requests and sets permissive cross-origin headers for frontend clients.
4. **Traffic & IP Filtering**:
   - Tracks client IP addresses generating 404 (Not Found) errors, blocking abusive clients after 5 failed attempts for a duration of 30 minutes.
   - Provides optional IP whitelisting via `AccessByIPMiddleware`.
5. **Centralized Error Handling**: Captures panics and domain exceptions, transforming them into uniform JSON response envelopes.

---

## Technology Stack

- **Go**: `1.23`
- **Gin**: `v1.8.1`
- **Viper**: `v1.12.0`
- **JWT (dgrijalva)**: `v3.2.0`
- **Validator**: `v10.11.0`
- **GoCSV**: `v0.0.0-20230616125104-99d496ca653d`

---

## Configuration Architecture

Configuration is managed via `pkg/config/config.go` using Viper:
- Configuration search path: `./pkg/config/env`
- Config file name: `dev.env`
- Struct:
  ```go
  type Config struct {
      Port          string `mapstructure:"PORT"`
      AccessSecret  string `mapstructure:"ACCESS_SECRET"`
      RefreshSecret string `mapstructure:"REFRESH_SECRET"`
  }
  ```
- Supports environment variable overrides via `viper.AutomaticEnv()`.

---

## Downstream Microservices

The gateway proxies requests to the following key internal services:
- `mf-micro-service-ski-auth:8080`: Authentication, user logins, token refreshes.
- `mf-micro-service-ski-marketing-user:8080`: User management and marketing profiles.
- `mf-micro-service-ski-discount-proposal:8080`: Discount proposals, confirmations, credit notes, payments, and realizations.
- `mf-micro-service-ski-compliance-warehouse:8080`: Warehouse compliance, targets, sales out, GT headers, metabase ETL.
- `mf-micro-service-ski-sales:8080`: Sales FF, principal sales, stock distributors, extra discounts.
- `mf-micro-service-ski-structure:8080`: Marketing structure hierarchies, ethical structures, customer territories.
- `mf-micro-service-ski-product:8080`: Products, packings, pictures, prices, programs, types, units, and max discounts.
- `mf-micro-service-ski-customer:8080`: Customers, inactive statuses, positions, specialists, territories.
- `mf-micro-service-ski-outlet:8080`: Outlets, outlet groups, mappings, shares, and outlet types.
- `mf-micro-service-ski-bank:8080`: Banks, branches, transfer fees, bank accounts, and transfer types.
- `mf-micro-service-ski-city:8080`: City lookups and CSV data.
- `mf-micro-service-summaryff:8080`: FF summaries and details.
