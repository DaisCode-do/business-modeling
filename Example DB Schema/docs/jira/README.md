# Jira discovery playbook

This directory turns the existing evidence and prototype into a lightweight,
traceable client-validation process in **Jira Product Discovery (JPD)**.

The guiding rule is simple:

> The client supplies corrections, choices, examples, and evidence. The
> developer converts those inputs into durable requirements and models.

The client should not be asked to write specifications or complete long forms.
A normal review item should take two to five minutes to understand and answer.
When a subject is too complex for that, use a short conversation and let the
developer record the result.

## Decisions already made

- The PostgreSQL prototype and ERD are hypotheses backed by evidence, not
  approved requirements.
- JPD records business concepts, questions, requirements, and decisions. It
  does not mirror every database table or field.
- **Client Review** is the only main interaction surface for discovery
  participants.
- The **Architecture** view is maintained by the developer and is read-only for
  the client. Client requirements can constrain architecture, but clients are
  not asked to approve implementation mechanics.
- `frappe_docker` is excluded as an application or data-model candidate. It may
  later be inspected only for selected UI/UX references.
- Comments, evidence links, attachments, and Insights should remain attached to
  the smallest relevant Jira item so the path to agreement is visible.
- Only three items should normally require client attention at once.

## First recommended Jira moves

Perform these in order. They are setup actions, not new ERP requirements.

1. **Name the participants and decision owners.** Start with the
   administrator/owner, accountant, project or operations representative, and
   the developer. A process expert may explain a workflow without owning its
   policy decision.
2. **Configure the five review statuses.** Use `Draft`, `Discuss`, `Evidence
   Needed`, `Agreed`, and `Ready` with the gates in
   [workflow, fields, and views](01-workflow-fields-and-views.md).
3. **Create only the minimal fields.** Add `Item kind`, `Statement class`,
   `Business area`, `Decision owner`, `Evidence confidence`, and `Review
   response`. Do not expose all of them in the client board.
4. **Create the views.** Build `Client Review`, `Requirements Catalogue`, and
   the developer-managed `Architecture` view. Leave prioritization and timeline
   views lightly configured until requirements are understood.
5. **Install the concise description templates.** Use the templates in
   [item templates](03-item-templates.md); do not give the client a blank essay
   prompt.
6. **Create the first nine discovery items.** Copy them from
   [the first Jira batch](04-first-jira-batch.md), but expose only the first
   three in `Discuss` or `Evidence Needed`. Leave the remaining six in `Draft`.
7. **Prepare evidence before inviting answers.** Attach or link the smallest
   safe excerpt, example, or proposed mapping needed for each active item. Do
   not ask the client to search through the repository.
8. **Run a short orientation.** Explain the board in ten minutes, then review
   one real card together. The acceptable client responses are: agree, choose
   an option, correct a statement, provide an example, attach a file, or name
   the right person.
9. **Consolidate the outcome.** Before the next review, update the description,
   record the decision and source, preserve exceptions, and move the card only
   when its status gate is satisfied.

## Recommended operating limit

Use a small review window:

- **Active:** no more than three items awaiting client action.
- **Prepared queue:** no more than six additional `Draft` items.
- **Catalogue:** everything else stays captured but does not demand attention.

This limit protects the client from questionnaire fatigue and protects a solo
developer from having dozens of partially resolved conversations at once.

## Documents in this directory

1. [Workflow, fields, and views](01-workflow-fields-and-views.md) — the minimum
   JPD configuration and ownership model.
2. [Client review method](02-client-review-method.md) — how to make validation
   easy for non-technical participants.
3. [Item templates](03-item-templates.md) — copy-ready structures for questions,
   decisions, requirements, terminology, and architecture notes.
4. [First Jira batch](04-first-jira-batch.md) — nine high-value items derived
   from current evidence, sequenced in three waves.
5. [Evidence, agreement, and versioning](05-evidence-agreement-and-versioning.md)
   — how comments, files, Insights, and decision records form traceability.
6. [Cadence and change control](06-cadence-and-change-control.md) — how reviews,
   schema changes, and future prototypes should proceed.

## Inputs this playbook relies on

- [Source assessment](../schema/01-source-assessment.md)
- [Canonical model](../schema/02-canonical-model.md)
- [Initial business rules](../schema/03-business-rules.md)
- [Migration decisions](../schema/04-migration-decisions.md)
- [Requirements and prototype plan](../schema/05-requirements-plan.md)
- [Interactive ERD](../erd/index.html)

## What success looks like

The first cycle is successful when the company has supplied enough evidence and
decisions to make a small part of the prototype safer—not when every Jira field
is populated. The desired chain is:

**Evidence → current interpretation → focused client response → recorded
agreement → revised requirement/rule → justified schema or prototype change**

