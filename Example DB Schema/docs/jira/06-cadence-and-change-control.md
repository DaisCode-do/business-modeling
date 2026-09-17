# Cadence and change control

This process is designed for a solo developer with other responsibilities and
for participants who should not be burdened with long questionnaires. Progress
is limited by evidence and decision availability, not by how many Jira items
can be created.

## Suggested discovery rhythm

Use a repeatable cycle rather than a rigid delivery calendar:

### Prepare

The developer selects up to three connected items, reduces the evidence to a
small review packet, and writes a proposed interpretation.

### Review

Participants answer asynchronously in comments or attend one 30–45 minute
session. Ask for a normal case and one material exception.

### Synthesize

The developer records outcomes, updates the relevant blueprint views, and
identifies contradictions or missing evidence.

### Validate

The named owner confirms the summary. The developer incorporates it into the
blueprint. A small prototype or targeted ERD view is used only when it can expose
a misunderstanding that prose and examples cannot settle.

### Change

The developer derives software requirements from the incorporated workflow slice.
The schema or prototype changes only after those requirements and their impact
are documented.

Then begin the next wave. There is no benefit in accumulating a large parallel
queue of half-reviewed requirements.

## Meeting and presentation roles

- The **client board** presents the current business questions and agreed
  outcomes.
- The **ERP Domain Blueprint** presents the current coherent business model and
  becomes the source for later software requirements.
- The **interactive ERD** explains the current model and consequences; it is
  not an approval form.
- The **Architecture view** communicates technical direction selected and
  maintained by the developer. Clients can observe it and raise business
  constraints, but they are not assigned technical approval work.
- A **screen prototype** is built when seeing or using a workflow will answer a
  question more reliably than discussion alone.

## Requirements and schema change gate

A Jira response does not automatically become a software requirement or authorize
an immediate DDL edit. First incorporate the result into the blueprint. Before
changing the prototype schema, record:

- the agreed business statement and Jira key;
- the affected blueprint workflow, decision, business rules, and domains;
- the derived software requirement and acceptance examples;
- whether the change is conceptual, data-migration, API, UI, or accounting
  behavior;
- backward/migration consequences;
- representative acceptance cases; and
- any still-unconfirmed policy that must remain configurable or unenforced.

Then update the DDL, schema documentation, and ERD together and run the existing
validation checks. Compare the result against the blueprint rather than against
the earlier schema merely for internal consistency.

## Change states for the fragile prototype

Use these labels in change notes or Architecture items:

- **Hypothesis:** represented so it can be discussed, not client-approved.
- **Agreed concept:** business meaning is accepted; implementation may still be
  provisional.
- **Prototype rule:** intentionally enforced to test the agreed behavior.
- **Production candidate:** requirements, migration, security, audit, and
  failure behavior have sufficient validation.
- **Superseded:** retained for history but no longer current.

The current schema remains a fragile prototype even when individual concepts
become agreed.

## When to create another prototype

Build or revise a prototype when it can test a risky interpretation such as:

- approving project aliases and distinguishing overhead;
- matching invoice evidence, tax fields, allocation, and payment applications;
- reconciling contractor claim lines and typed deductions;
- separating contractor, payroll, and client `cubicacion` workflows; or
- comparing a budget baseline with an approved change.

Do not prototype a broad module merely because its menu and forms are easy to
imagine. Every prototype should name the requirement it tests, the participant
who will evaluate it, and what result would disprove the current model.

## Handling new findings

When evidence contradicts an `Agreed` or `Incorporated` item:

1. do not silently rewrite history;
2. return the item to `Discuss` or create a linked decision if the new scope is
   distinct;
3. add the contradictory evidence as an Insight or attachment;
4. record what prior outcome may be superseded;
5. obtain the appropriate owner's response; and
6. revise and reincorporate the blueprint result; and
7. assess requirements, schema, and migration impact before changing
   implementation.

Changes are expected during discovery. The discipline is to make their reason
and consequence visible.

## Frappe boundary

`frappe_docker` is no longer an architecture candidate for this ERP. Do not
spend discovery time mapping the custom schema into Frappe DocTypes or testing
Frappe as the source of truth.

When frontend implementation begins, selected Frappe screens may be reviewed as
UI/UX references for forms, navigation, permissions presentation, attachments,
or workflow affordances. Any adopted interaction must still be justified
against an agreed requirement and implemented on the chosen custom
architecture.

Reopening Frappe as an application platform requires an explicit developer
architecture decision with new evidence; it is not a Client Review question.

## Periodic health check

At the end of each review wave, ask:

- Did every active item receive a useful answer or a named blocker?
- Did we ask anyone to write information we could have prepared ourselves?
- Is each agreement attributable to an authorized owner?
- Can each changed blueprint statement be traced to evidence and a Jira key?
- Did the model change only where the evidence required it?
- Are fewer than four items now awaiting client action?
- Is the next activity improving the blueprint, deriving a requirement, or
  testing a known uncertainty rather than expanding the prototype by habit?

If the answer is no, simplify the next wave before creating more items.
