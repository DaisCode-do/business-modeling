# Constructora Angote ERP — Business Modeling and Discovery

This repository is the controlled workspace for understanding Constructora
Angote's business before deriving software requirements or committing to an ERP
implementation model.

The immediate objective is a reviewed **business domain blueprint**: shared
language, domain boundaries, workflows, relationships, lifecycles, policies,
system boundaries, evidence, decisions, and unresolved questions. Software
requirements, prototypes, data models, and architecture are downstream outputs.

## Authority by concern

There is no single artifact that should own every kind of truth.

1. **`EVIDENCE/`** preserves supplied operational material and source provenance.
   Evidence shows what was recorded or said; it does not automatically establish
   current policy.
2. **`ERP Domain Blueprint/`** is the versioned source of the currently accepted
   business model. Proposed statements remain visibly proposed until reviewed.
3. **Jira Product Discovery** coordinates questions, evidence requests,
   discussions, decision ownership, and client agreement. Jira is a review
   workflow, not the permanent business specification.
4. **`Example DB Schema/`** contains the earlier PostgreSQL prototype, ERD,
   analysis, and Jira working documents. It is evidence of prior reasoning and a
   future test instrument—not a constraint on the business model.
5. **Software requirements and architecture** will be derived after the relevant
   blueprint slice is mature enough. The developer owns architectural decisions;
   the client supplies business constraints and validates business meaning.

The intended traceability chain is:

**Evidence → Jira review → domain decision → blueprint revision → software
requirement → architecture/schema/prototype → verification**

## Repository map

- [ERP Domain Blueprint](<ERP Domain Blueprint/README.md>) — active business
  modeling structure and accepted domain documentation.
- `EVIDENCE/` — private, gitignored source material.
- [Example DB Schema](<Example DB Schema/docs/prototype-schema-analysis.md>) —
  fragile initial schema and analysis retained as a reference.
- [Jira discovery playbook](<Example DB Schema/docs/jira/README.md>) — client
  review workflow, templates, first items, and meeting preparation.
- [Meeting plan for 2026-09-18](<Example DB Schema/docs/jira/08-client-meeting-2026-09-18.md>)
  — the next client conversation and its expected outputs.

## Working principles

- Model real end-to-end work before screens, features, or tables.
- Begin with a concrete normal example and one meaningful exception.
- Separate observed practice, adopted policy, proposed improvement, and open
  questions.
- Give the same business term one meaning; introduce a different term when the
  business genuinely has two concepts.
- Preserve changing relationships and history instead of reducing everything to
  mutable attributes.
- Treat specialized external systems as explicit boundaries rather than assuming
  that the ERP must replace them.
- Put company-specific policy in the company model. Reuse the modeling method and
  stable conceptual patterns, not another company's detailed workflow.
- Expect some software changes as understanding improves. The goal is controlled,
  traceable change—not a false promise that a correct system will never evolve.

## Jira's role

The client should not be asked to write specifications. A normal Jira item asks
for one correction, choice, example, document, or decision owner. The developer
prepares the interpretation and incorporates the confirmed outcome into the
blueprint.

Use no more than three active client-review items at once. The recommended
discovery states are:

**Draft → Discuss ↔ Evidence Needed → Agreed → Incorporated**

`Incorporated` means the accepted result is reflected in the domain blueprint;
it does not mean implemented or scheduled.

## Current technical boundary

The PostgreSQL model remains a technical hypothesis until derived from reviewed
business documentation. The supplied `frappe_docker` material is excluded as an
application platform and canonical data model; selected interactions may later
serve only as UI/UX references.

The Architecture Jira view is maintained by the developer and exposed to the
client for context, not technical approval.
