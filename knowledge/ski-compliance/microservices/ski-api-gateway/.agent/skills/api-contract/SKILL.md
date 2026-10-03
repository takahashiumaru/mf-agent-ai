---
name: api-contract
description: Manage and verify API routing, reverse-proxying, CORS, and response structures in ski-api-gateway. Use when adding or modifying HTTP routes or API contracts.
---

# API Contract Skill

## Purpose & Trigger
Ensure all routes in `ski-api-gateway` adhere to consistent HTTP contracts, CORS policies, response envelopes, and routing paths.

## Workflow
1. **Understand**: Identify upstream path, HTTP method, and target downstream microservice.
2. **Inspect**: Determine whether the endpoint is public or protected by JWT / API Key.
3. **Plan**: Add route definition to `pkg/app/router.go`.
4. **Implement**: Register endpoint using `addRoute` with `helper.ReverseProxy(host)`.
5. **Verify**: Test routing, method matching, and error handling with `httptest.ResponseRecorder`.

## Hard Rules
- Maintain backward compatibility for existing client consumers.
- Use the standard `model/web/web_response.go` envelope for all gateway-originated error responses.
