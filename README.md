# Jira Product Discovery — Requirements Engineering Context

A Jira Product Discovery space called **Constructora Angote ERP** has been created to turn the existing discovery material into a controlled requirements-engineering process.

The existing PostgreSQL prototype, interactive schema map, historical company files, accountant workflow material, meeting information, and previous analyses should be treated as **discovery evidence and proposed models**, not automatically as confirmed requirements.

The operating playbook and copy-ready first items are in
[the Jira discovery documentation](docs/jira/README.md).

The immediate objective is **not to exhaustively specify the ERP**. Instead, use the accumulated evidence to identify a sensible first set of business concepts, requirements, uncertainties, and decisions that should enter Jira for structured client validation.

Client participation must remain lightweight. The developer prepares the
interpretation and maintains the formal requirement; the client is normally
asked only to agree, choose, correct, provide one example, attach evidence, or
identify the proper decision owner. Keep no more than three items awaiting
client action at once.

### Main workflow: Client Review

The central view is a board organized around:

**Draft → Discuss → Evidence Needed → Agreed → Ready**

Which will be used to progressively transform what is currently known or inferred into validated business requirements and decisions.

Good initial candidates should come from areas where the existing material already provides substantial evidence, particularly concepts represented in the prototype schema and actual accountant/company workflows. Foundational ERP concepts that are relatively independent of company-specific rules may also be useful starting points.

For each candidate, distinguish between:

- **Observed behavior** — directly supported by files, workflows, historical records, videos, etc.
- **Proposed behavior** — inferred from the prototype/schema or recommended as part of the new ERP.
- **Uncertainty** — something that appears necessary but cannot yet be established reliably.
- **Business decision** — something for which multiple valid approaches exist and the client must choose.
- **Technical decision** — implementation detail that belongs primarily to the developer rather than requiring client approval.

Avoid creating Jira items for every table, field, or database relationship. Jira should primarily represent **business concepts and decisions**. The schema can then evolve from those validated requirements.

For example, rather than reviewing `PaymentAllocation` as a database entity, review the business concept:

> **Allocation of payments across obligations/projects**

That discussion can establish whether allocation exists, what can be allocated, whether partial payments are permitted, who performs the allocation, what historical information must remain visible, and exceptional cases. The eventual relational representation remains an engineering concern.

### Initial paths through the ERP

Do not attempt to populate all ~85 prototype entities immediately. Start with a few **vertical business flows** where existing evidence is strongest.

A useful first path is likely:

**People/organizations → roles/relationships → projects/contracts → documents**

This crosses several proposed modules and should expose important dependencies early. Other strong paths can be selected from the source material if the evidence indicates that they are more fundamental.

A second foundational path is likely:

**Projects → purchasing / contractor work → invoices or claims → payments → accounting consequences**

This helps establish the actors and business objects referenced throughout the rest of the ERP.

You should use its existing document analysis to determine the exact starting concepts rather than assuming the prototype schema is correct.

### Relationship with the Jira views

**Client Review** is the primary requirements-validation workspace. Put business concepts, unresolved behavior, proposed rules, important questions, and decisions here and move them through the validation workflow.

**Requirements Catalogue** should provide the more systematic inventory of established/proposed requirements. Client Review represents the _process of reaching agreement_; the catalogue represents the _organized body of requirements_ resulting from that process.

**Impact vs Effort** can later help prioritize sufficiently understood items. Do not assign precise implementation effort to poorly defined requirements merely to fill the matrix.

**Timeline** communicates major phases, dependencies, short/long-term direction, and planned areas of work. It should not imply precision that the current discovery stage cannot support.

**Architecture** documents technical structure and architectural decisions: backend/frontend boundaries, infrastructure, integrations, services, deployment, security approaches, database architecture, etc. It is maintained by the developer and provided to the client for viewing. Business requirements may constrain architecture, but architectural implementation choices do not normally require client approval.

The provided `frappe_docker` repository is not an application-platform or
source-of-truth candidate. It may later be consulted only as a UI/UX reference
for selected frontend interactions.

**Website** is a separate product/work stream for the company's existing public website, using prioritization such as Now / Next / Later rather than mixing those changes into core ERP requirements.

### Traceability

Whenever possible, Jira items should retain provenance back to the material already analyzed:

**Source evidence → interpretation/proposal → Jira requirement or decision → agreement → implementation**

Do not convert uncertain AI-derived conclusions into facts. When source materials conflict, are incomplete, or only weakly imply a behavior, create an explicit question or **Evidence Needed** item instead.

Likewise, preserve meaningful changes in understanding. `Agreed` means **currently accepted and safe to use as an implementation input**, not permanently immutable.

### What to produce initially

Use the existing analysis to propose a **small, high-value first batch** for Jira rather than a comprehensive ERP specification.

For each proposed Jira item, provide enough information to make creation/review practical: a concise title, appropriate type/category, the business concept or requirement being established, relevant evidence/source, current understanding, unresolved questions or assumptions, affected business/module areas, and a recommended initial Client Review state.

Prioritize items that either:

1. establish foundational concepts used throughout the ERP,
2. represent important end-to-end workflows,
3. expose assumptions currently embedded in the prototype schema,
4. contain contradictions or insufficient evidence,
5. require an explicit client/accountant decision before implementation, or
6. would cause substantial redesign if misunderstood.

The goal of the first pass is therefore **not “document everything we know.”** It is to identify the smallest useful set of questions and requirements that begins converting the existing prototype from an evidence-based hypothesis into an agreed system specification.

### Jira operating documents

- [Entry point and first recommended moves](docs/jira/README.md)
- [Workflow, fields, and views](docs/jira/01-workflow-fields-and-views.md)
- [Client review method](docs/jira/02-client-review-method.md)
- [Copy-ready item templates](docs/jira/03-item-templates.md)
- [First Jira batch](docs/jira/04-first-jira-batch.md)
- [Evidence, agreement, and versioning](docs/jira/05-evidence-agreement-and-versioning.md)
- [Cadence and change control](docs/jira/06-cadence-and-change-control.md)
