# .agent/WORKFLOWS.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Developer & Agent Workflows

Evidence-based workflows for common engineering tasks in `ski-api-gateway`.

---

## 1. Workflow: Adding a New Route

When exposing a new endpoint through the gateway:

1. **Determine Route Scope**:
   - If the endpoint requires authentication, add it to the protected `routes` slice in `pkg/app/router.go` (after line 229).
   - If public (no auth required), add it to the public `routes` slice in `pkg/app/router.go` (before line 226).
2. **Define Backend Definition**:
   ```go
   {Host: "target-microservice-host:8080", Method: "GET", Api: "/your/new/endpoint"},
   ```
3. **Verify Reverse Proxy Route**:
   - Run `go test ./test -run TestRouter` to ensure router compiles and registers the route properly.
4. **Update Documentation**:
   - Mention the new route in relevant domain docs if it introduces a new microservice.

---

## 2. Workflow: Adding or Rotating an API Key

1. **Locate `api_keys.json`**:
   - Add new entry with unique UUID and metadata:
     ```json
     "NEW-SERVICE-API-KEY": {
       "access_uuid": "...",
       "authorized": true,
       "exp": 2095900800,
       "id": 999993,
       "level": "NON MKT",
       "main_id": 2201003,
       "main_role": "Administrator",
       "name": "New Service Account",
       "nip": "999993",
       "role": "PROGRAMMER"
     }
     ```
2. **Hot-Reload Verification**:
   - The `ApiKeyManager` checks file modification time automatically on each lookup and reloads without needing service restart.
3. **Test Ingress**:
   - Send request with header `X-API-Key: NEW-SERVICE-API-KEY` to verify JWT translation.

---

## 3. Workflow: Updating Error Response Mapping

1. **Add Custom Error in `exception/error.go`**:
   - Define sentinel `var ErrNewCondition = errors.New("...")` or custom struct implementing `error`.
2. **Update `exception/error_handler.go`**:
   - Add condition in `ErrorHandler` function, setting status code and JSON payload.
3. **Add Regression Unit Test**:
   - Create a test case in `test/exception_test.go` exercising the error branch and asserting HTTP status code and response envelope.
