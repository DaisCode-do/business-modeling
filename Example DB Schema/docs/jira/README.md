# Jira discovery playbook

Jira Product Discovery coordinates client review while the
[ERP Domain Blueprint](<../../../ERP Domain Blueprint/README.md>) becomes the
versioned source of the accepted business model.

The operating rule is:

> The client corrects, chooses, demonstrates, or supplies evidence. The
> developer prepares the model, records the result, and incorporates it into the
> blueprint.

The client is not expected to write requirements, review database tables, or
complete long questionnaires. A normal Jira item asks for one correction,
choice, example, file, or decision owner.

## Artifact responsibilities

- **Evidence:** preserves what was supplied, observed, or recorded.
- **Jira:** manages questions, discussion, evidence requests, ownership, and
  agreement across participants.
- **ERP Domain Blueprint:** holds the coherent current business model in Git.
- **Software requirements:** are derived from sufficiently mature blueprint
  slices.
- **Example schema and ERD:** test later requirements and expose technical
  consequences; they do not drive discovery order.
- **Architecture:** is maintained by the developer and shown to the client for
  context.

The traceability chain is:

**Evidence → Jira review → domain decision → blueprint revision → software
requirement → architecture/schema/prototype → verification**

## First moves for the 2026-09-18 meeting

1. Confirm the participants and distinguish process experts, evidence holders,
   and actual decision owners.
2. Change the last discovery status from `Ready` to `Incorporated`, or redefine
   `Ready` as “incorporated and ready for requirements derivation” if the board
   cannot be changed before the meeting.
3. Add `Blueprint target` as a link or short-text field.
4. Update `Item kind` and `Business area` using
   [the workflow and field guide](01-workflow-fields-and-views.md).
5. Create only the first three items from
   [the blueprint-centered first batch](04-first-jira-batch.md).
6. Attach or link the proposed Business Context and Domain Map; do not ask the
   client to search the repository.
7. Follow the [meeting plan](08-client-meeting-2026-09-18.md).
8. After the meeting, incorporate accepted corrections into the blueprint before
   closing the Jira items.

## Discovery workflow

Use:

**Draft → Discuss ↔ Evidence Needed → Agreed → Incorporated**

`Agreed` means the responsible business owner explicitly confirmed the outcome.
`Incorporated` means the accepted result is represented in the blueprint and
linked back to the Jira item. It does not mean implemented, estimated, or
scheduled.

## Operating limit

- **Active:** no more than three items awaiting client action.
- **Prepared queue:** no more than six connected `Draft` items.
- **Catalogue:** everything else remains visible without demanding attention.

This prevents questionnaire fatigue and keeps the solo-developer workload
coherent.

## Documents

1. [Workflow, fields, and views](01-workflow-fields-and-views.md) — minimal JPD
   configuration aligned with the blueprint.
2. [Client review method](02-client-review-method.md) — low-effort participation
   and short review sessions.
3. [Item templates](03-item-templates.md) — concise questions, decisions,
   evidence requests, and outcome records.
4. [First Jira batch](04-first-jira-batch.md) — the blueprint foundation and
   first workflow selection.
5. [Evidence, agreement, and versioning](05-evidence-agreement-and-versioning.md)
   — traceability across evidence, Jira, Git, and downstream artifacts.
6. [Cadence and change control](06-cadence-and-change-control.md) — how reviewed
   business meaning becomes requirements and prototypes.
7. [Deferred schema-validation backlog](07-deferred-schema-validation-backlog.md)
   — valuable detailed questions activated only when their workflow reaches them.
8. [Client meeting plan — 2026-09-18](08-client-meeting-2026-09-18.md) — agenda,
   script, outputs, and post-meeting actions.

## Current boundaries

- The example PostgreSQL schema remains a fragile technical hypothesis.
- `frappe_docker` is excluded as a platform and canonical model; selected UI/UX
  interactions may be consulted later.
- The Architecture view is developer-managed and client-viewable.
- EduGuiders demonstrates the documentation method, but its terminology,
  workflows, policies, and conclusions are not Constructora requirements.

## Success signal

The first cycle succeeds when the company has corrected its high-level business
map, selected one real workflow, supplied a normal example and an exception, and
helped produce the first reviewed workflow document. Jira completeness and the
number of captured fields are not success measures.
