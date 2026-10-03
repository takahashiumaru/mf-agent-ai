---
name: backend-security
description: Audit and harden authentication, authorization, token verification, IP filtering, and secret management in ski-api-gateway. Use when reviewing or modifying security-critical code.
---

# Backend Security Skill

## Purpose & Trigger
Harden gateway security, prevent token tampering, defend against unauthorized access, and protect against DoS attacks.

## Workflow
1. **Understand**: Trace ingress trust boundary from client request to reverse proxy dispatch.
2. **Inspect**: Verify HMAC-SHA256 signature validation in `pkg/auth/auth.go` and API key matching in `helper/api_key.go`.
3. **Plan**: Add strict input validation and defense-in-depth protections.
4. **Implement**: Reject untrusted or malformed tokens; sanitize debug logs; enforce IP blocking on malicious 404 scanning.
5. **Verify**: Test rejected requests (missing tokens, forged signatures, expired tokens, blocked IPs).

## Hard Rules
- Never use unverified token parsers for authentication or access control decisions.
- Never commit real secret keys into repository code or documentation.
- Never leak sensitive Authorization headers or passwords in debug logs.
