# Project map and edit scope

Responsibilities below summarize source/resource areas, not complete business ownership or production deployment. Use the [repository inventory](generated/REPOSITORY_INDEX.md) for current captured versions and pinned dependencies.

| Repository | Responsibility / navigation | Documentation scope |
|---|---|---|
| [flexurio-nocode-api-config-mf-marketing](../flexurio-nocode-api-config-mf-marketing) | No-code API configuration repository; reference only. | reference only |
| [flexurio-nocode-web-config-mf-marketing](../flexurio-nocode-web-config-mf-marketing) | No-code web configuration repository; reference only. | reference only |
| [mf-micro-service-bank](../mf-micro-service-bank) | Banks, branches, customer accounts, transfer fees, transferred types. | documentation |
| [mf-micro-service-customer](../mf-micro-service-customer) | Customers and customer territory/product/outlet mappings. | documentation |
| [mf-micro-service-discount-proposal](../mf-micro-service-discount-proposal) | Discount proposal workflows; authorized dotenv connection source. | reference only |
| [mf-micro-service-event](../mf-micro-service-event) | Event classes and associated event/detail rules. | documentation |
| [mf-micro-service-marketing-user](../mf-micro-service-marketing-user) | Users, divisions, sessions, menu/group authentication configuration. | documentation |
| [mf-micro-service-master-document-proposal](../mf-micro-service-master-document-proposal) | Master documents, proposal categories, and file retrieval. | documentation |
| [mf-micro-service-outlet-2](../mf-micro-service-outlet-2) | Outlets and outlet group mappings. | documentation |
| [mf-micro-service-product](../mf-micro-service-product) | Products, programs, pricing and discount-related configuration. | documentation |
| [mf-micro-service-sales](../mf-micro-service-sales) | Sales-related source and processing; inspect exact route/service for ownership. | reference only |
| [mf-micro-service-structure](../mf-micro-service-structure) | Marketing structure and territory assignment workflows. | reference only |
| [rest-api-pondasi-mftl](../rest-api-pondasi-mftl) | Foundation API integration; determine exact request ownership from its source. | reference only |
| [ski-api-gateway](../ski-api-gateway) | Gateway implementation; local checkout is not proof of pinned dependency behavior. | reference only |
| [ski-compliance-api-warehouse](../ski-compliance-api-warehouse) | Warehouse processing and sales target/achievement reporting. | documentation |
| [visit-flow-api-synchronize-ski-compliance](../visit-flow-api-synchronize-ski-compliance) | SKI-to-VisitFlow synchronization orchestration. | documentation |

## Boundary rules

The seven reference-only repositories above are excluded from edits in this task. Their source can be read to trace dependencies; the user explicitly authorized reading the discount-proposal dotenv for SKI_MF_PROD access. No excluded repo receives AGENTS, CLAUDE, skill, or source edits. VisitFlow outside this workspace is a reference, not an edit target.

The nine documentation repositories retain their local engineering guides and gain shared data/analysis routing. Cross-repository SQL belongs to this workspace guide; model ownership is not inferred from table name alone.
