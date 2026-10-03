# Answer with data first

## Standard response

1. **Result:** a direct Indonesian answer, small table when useful, actual retrieved numbers/records only.
2. **Scope:** source schema/object, reporting period, entity grain, filters, timezone, units, observation time, and whether output is capped.
3. **Interpretation:** what the result supports; distinguish facts from hypotheses. Mention material exclusions or reconciliation gaps.
4. **Executed SQL:** the exact SELECT used, with no credentials. If several queries were needed, label each result and query.
5. **Next analysis:** only when useful; propose the next discriminating comparison, not a generic checklist.

If the user requests SQL only, provide SQL after checking schema and business semantics; execution is not required. If a critical scope cannot be inferred (for example, gross versus net sales), ask one focused question while inspecting schema/code. Do not repeatedly ask for database permission already granted.

## Worked factual example

Question: “Berapa tabel dan view yang ada?”

Answer from the captured metadata: “Pada snapshot 27 September 2026 pukul 08:34:40 WIB, terlihat **183 tabel dan 78 view** di SKI_MF_PROD.” This is a dated metadata result, not a current business metric. Rerun the metadata SELECT in [DATA_ACCESS.md](DATA_ACCESS.md) when the user asks for the latest state and report its actual execution time.

## Accuracy before formatting

- Define what one row represents. `COUNT(*)` after a one-to-many join counts joined rows, not necessarily customers/outlets/proposals.
- Check denominator and units for percentages/achievement; use a safe zero-denominator policy and explain it.
- Check cancellation/closing/active flags in the actual domain flow. Do not invent a universal `status='ACTIVE'` rule.
- Confirm period type and cutoff; defaulting to the current month can misrepresent a historical or closed-period question.
- Reconcile aggregation with base rows and investigate null/missing mappings. `DISTINCT` is not a universal remedy for duplicated sums.
- Read only needed fields. Aggregated bank/account metrics rarely require exposing account numbers or personal records.
- Return zero only when a successful query establishes zero; keep NULL/unknown separate.
- Never treat `information_schema.TABLES.TABLE_ROWS` as an exact count or snapshot DDL as data.

## When access fails

Say: “Data aktual belum berhasil saya verifikasi: [specific sanitized reason].” State what was verified from schema/source and what remains unknown. Show SQL only as **belum dijalankan**. Do not pretend a query suggestion fulfills an actual-data request.

## “Total call hari ini berapa?” acceptance case

Resolve today's date in Asia/Jakarta at execution. Trace the call source and its business-date fields; check live/local schema freshness, keys and deletion/status semantics. Execute the aggregate through the read-only runner. Respond: “Total call [date] adalah **[actual returned total]** [scope].” Then give the observation time and exact SQL under “Query validasi”. Bracketed text here is a template, never an actual result. Do not assume created_at is the call date. If call data belongs to an unavailable external source, explain the verified mapping and access limitation instead of inventing a total.

The answer is incomplete if it only supplies COUNT SQL, asks again for already-authorized access, or claims MCP is required despite the local runner. A query rejected or failed after execution must be labeled failed, not “never executed”.
