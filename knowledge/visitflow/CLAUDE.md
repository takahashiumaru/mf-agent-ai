@AGENTS.md

The VisitFlow skills are stored once in `.agents/skills/` and linked from `.claude/skills/`. If a skill is not listed in this Claude Code version, open the relevant `.agents/skills/<name>/SKILL.md` directly.

Follow the answer contract in `AGENTS.md`: return executed data results first, verify feature claims through implementation and schema, and support feasibility/performance advice with evidence. Reuse the chosen database and scope; report missing access explicitly. SQL-only requests remain unexecuted. Child `.agent/` documents supplement this shared contract.

For `SELECT`, plain `EXPLAIN SELECT`, and schema reads, use the default production login profile documented in `AGENTS.md` directly, without reconfirming the target or permission. Follow its read-only transaction and scope requirements.

For database mutations (`UPDATE`, `DELETE`, `DROP`, and other writes), follow the root DEV-only rule: explicitly target `VISITFLOW_MF_DEV`, prepare and explain the concrete impact, tell the user it is DEV only, and ask whether they are sure before execution. Wait for explicit confirmation; this default is not execution approval. Preparation reads for a DEV mutation must also target DEV.
