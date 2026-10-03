---
description: How to run the Discount Proposal microservice.
---

# Running the Discount Proposal Service

To run `mf-micro-service-discount-proposal`, follow these steps:

1. Startup is not a read-only inspection step. Confirm an isolated development target and review bootstrap/integration side effects first. Ensure the MySQL database is reachable and credentials in `./configuration/.env` are configured (`HOST_DB`, `PORT_DB`, `USER_DB`, `PASSWORD_DB`, `DATABASE_DB`).
2. Run the main Go entrypoint:
   ```bash
   go run main.go
   ```
3. The server will start and listen on the port specified in `configuration/.env` (read the actual configured value; no default is established here).
4. To verify compilation without running:
   ```bash
   go build -o /dev/null .
   ```
