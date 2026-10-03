---
name: go-testing
description: Use when writing, updating, or executing unit tests with Go standard testing and testify in this repository.
---

# Go Testing Skill

## Guidelines
1. **Framework**: Use `testing` package with `github.com/stretchr/testify/assert`.
2. **Table-Driven Tests**: Follow the table-driven test pattern demonstrated in [helper/operator_test.go](file:///Users/takahashiumaru/Documents/company-projects/ski-compliance/mf-micro-service-sales/helper/operator_test.go).
3. **Execution Commands**:
   - `go test ./...`
   - `go test -v ./helper -run TestOperatorQuery`
   - `go test -race ./...`

See [.agent/TESTING.md](../../TESTING.md).
