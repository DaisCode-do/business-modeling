# First Jira batch — business blueprint foundation

This batch realigns discovery around the ERP Domain Blueprint. Jira coordinates
review; the accepted result is incorporated into the Git-versioned blueprint.
The example database schema is consulted later to test coverage and expose
conflicts.

Create the first three items before the client meeting. Keep the second wave in
`Draft` until the meeting produces the right owners and evidence.

Planning IDs are shown below; Jira assigns the actual keys.

## Wave 1 — active for the first client meeting

### DISC-01 — Correct the proposed business-area map

**Recommended setup**

- Item kind: Domain map review
- Statement class: Proposed behavior
- Business area: Foundation
- Initial status: Discuss
- Decision owner: Company owner/administrator
- Blueprint target: `foundation/DOMAIN-MAP.md`

**Preparation**

Attach or present the proposed domain map. Use the
[repository version](<../../../ERP Domain Blueprint/foundation/DOMAIN-MAP.md>)
as the maintained draft.

**Copy-ready description**

```markdown
## Why this matters

We need a shared map of the business before we divide it into workflows,
requirements, screens, or database areas.

## Proposed areas

- Business Relationships
- Projects and Contracts
- Planning and Cost Control
- Procurement and Supplier Obligations
- Work Delivery and Capacity
- Client Commercial and Billing
- Finance, Accounting, and Tax
- Governance and Records

Fleet/equipment is currently treated as a possible later area.

## What we need from you

Please identify only:

1. an area whose name or boundary is wrong;
2. an important area that is missing; and
3. the person who best explains each corrected area.

The developer will update the map; no written specification is required.

## Recorded outcome — maintained by developer

Pending review.
```

**Completion effect:** Correct the domain map and record any material boundary
choice in the blueprint decision log.

### DISC-02 — Correct the proposed project value streams

**Recommended setup**

- Item kind: Workflow review
- Statement class: Proposed behavior
- Business area: Foundation; Projects and Contracts
- Initial status: Discuss
- Decision owner: Company owner/administrator with project operations input
- Blueprint target: `foundation/BUSINESS-CONTEXT.md`

**Copy-ready description**

```markdown
## Why this matters

The ERP must follow how the company creates value and incurs cost, not the order
of modules in a generic ERP.

## Proposed commercial stream

Client need/opportunity -> estimate/proposal -> agreement -> progress or approved
change -> client invoice -> collection

## Proposed delivery and cost stream

Project established -> plan/budget -> procure/assign -> execute/measure ->
approve supplier, contractor, or workforce obligation -> payment

Parties, project identity, documents/approvals, and accounting/tax support both
streams.

## What we need from you

Using one real project, tell us the first point where this order becomes wrong or
incomplete. The developer will record the corrected chain. One exception is
enough for this meeting.

## Recorded outcome — maintained by developer

Pending walkthrough.
```

**Completion effect:** Update the primary business chain and identify the first
workflow boundaries.

### DISC-03 — Select the first workflow and its evidence

**Recommended setup**

- Item kind: Business decision
- Statement class: Business decision
- Business area: Foundation
- Initial status: Discuss; use Evidence Needed when the example is named
- Decision owner: Company owner/administrator
- Blueprint target: `workflows/`

**Copy-ready description**

```markdown
## Decision needed

We will model one real workflow end to end before expanding the ERP business
model. The review needs one normal completed case and one meaningful exception.

## Options

- **A — Establish a project and its commercial basis:** most foundational;
  recommended when a recent project can be explained from its beginning.
- **B — Purchase to project cost and payment:** strongest current documentary
  evidence and direct accountant involvement.
- **C — Contractor work to claim and payment:** high risk because `cubicacion`,
  deductions, approval, and settlement are still ambiguous.
- **Another workflow:** acceptable if it is more central and a real example is
  available.

## What we need from you

Choose the workflow, name the people who perform and approve it, and identify one
normal example plus one exception. You may simply tell us where the documents
are; the developer will prepare the evidence packet.

## Recorded decision — maintained by developer

Pending.
```

**Completion effect:** Create the first workflow file from the
[workflow template](<../../../ERP Domain Blueprint/workflows/TEMPLATE.md>) and
schedule the responsible participants.

## Wave 2 — prepare after the meeting

### DISC-04 — Define what makes one project

**Recommended setup**

- Item kind: Concept and lifecycle review
- Statement class: Uncertainty
- Business area: Projects and Contracts
- Initial status: Draft
- Decision owner: Project authority
- Blueprint target: glossary, relationships, project workflow, lifecycle

**Client request:** Walk through one project from initial request to closeout and
correct the distinctions among client, contract, project, site, phase, cost
center, and raw project code. Name who may create, merge, rename, close, or reopen
the project.

**Evidence to prepare:** one project contract or acceptance record, project
register entry, budget, source alias examples, and one closed or cancelled case.

### DISC-05 — Identify the authority for each current business record

**Recommended setup**

- Item kind: System boundary
- Statement class: Uncertainty
- Business area: Foundation; Governance and Records
- Initial status: Draft
- Decision owner: Owner for each affected area
- Blueprint target: `foundation/CURRENT-SYSTEMS.md`

**Client request:** For the selected workflow only, identify where each important
fact currently lives, who can correct it, and whether that source is an authority,
working tool, reference, evidence source, or transition source.

Do not attempt to inventory every spreadsheet or application in one meeting.

### DISC-06 — Confirm decision authority for the selected workflow

**Recommended setup**

- Item kind: Relationship and policy review
- Statement class: Uncertainty
- Business area: Governance and Records
- Initial status: Draft
- Decision owner: Company owner/administrator
- Blueprint target: `language/ROLES.md` and the selected workflow

**Client request:** For each material decision in the selected workflow, name who
performs the work, who may approve it, who handles an exception, and who only
needs to be informed.

Do not translate these roles directly into software permissions yet.

## Deferred schema-derived questions

The previous nine-card batch has been preserved in
[the deferred schema-validation backlog](07-deferred-schema-validation-backlog.md).
Items such as legal identity, project aliases, `forma_pago`, partial payments,
NCF correction, `cubicacion`, and the two-percent deduction remain important.
They should enter active review when the chosen workflow reaches them, rather
than dictate the discovery order from the database outward.
