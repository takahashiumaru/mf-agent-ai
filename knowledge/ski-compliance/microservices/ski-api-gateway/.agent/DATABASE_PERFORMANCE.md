# .agent/DATABASE_PERFORMANCE.md

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

## Database Performance & Ingress Optimization

---

## 1. API Gateway Proxy Latency Optimization

- **Connection Reuse**: `http.Transport` in `httputil.ReverseProxy` should maintain keep-alive connections to downstream microservices.
- **Header Trimming**: Strip unneeded debugging headers to reduce transport overhead.
- **In-Memory Caching**: Cache static configurations (such as API keys in `helper/api_key.go`) to eliminate disk I/O per request.

---

## 2. Downstream Database Query Guidelines

- **Composite Index Left-Prefix Rule**: Order composite index columns by equality predicates first, then range predicates, then sort orders.
- **Avoid Leading Wildcard Searches**: Do not execute `LIKE '%keyword%'` queries on unindexed columns.
- **Avoid Large Offset Pagination**: For deep datasets, prefer keyset pagination (`WHERE id > last_id LIMIT N`) over large `OFFSET` values.
