# Validation Plan

This plan turns the blueprint into reviewed business documentation without
requiring a large requirements-engineering exercise.

## Recommended review sequence

### Session 1 — business map and first workflow

Use the [Business Context](../foundation/BUSINESS-CONTEXT.md) and
[Domain Map](../foundation/DOMAIN-MAP.md) as correction surfaces, not as facts to
approve wholesale.

Expected outputs:

- corrected business areas and primary value streams;
- named explainer and decision owner for each major area;
- one selected end-to-end workflow;
- one normal real example and one material exception for that workflow; and
- exact evidence to prepare for the next session.

See the [meeting plan](<../../Example DB Schema/docs/jira/08-client-meeting-2026-09-18.md>).

### Session 2 — project and commercial foundation

Walk through how one actual project began, including the client, site,
agreement, scope, project name/code, responsibility, and initial budget.

Expected outputs:

- project definition and lifecycle proposal;
- client/contract/site/project distinctions;
- authoritative project register and alias-review route; and
- terminology and decision ownership corrections.

### Session 3 — first operational workflow

Recommended starting candidate: purchase to project cost and payment, because
direct accountant evidence exists. If Session 1 selects another workflow, use
the same method there.

Expected outputs:

- trigger and completion condition;
- participants and decision authority;
- normal flow and one material exception;
- records and evidence created or changed;
- external-system boundaries; and
- resolved questions plus newly discovered questions.

### Later sessions — adjacent workflow slices

Review contractor work and claims, workforce/payroll, client progress and
billing, budgets/APU/changes, accounting/tax, and closeout in an order determined
by dependencies and risk—not by the table order of the prototype schema.

## Session method

For each review:

1. Begin with one real completed case and show the actual documents available.
2. Ask what triggered the work and what made it finished.
3. Identify each participant, decision, handoff, and external system.
4. Replay the normal path in plain language.
5. Test one exception likely to change the model.
6. Separate present practice, desired improvement, and mandatory policy.
7. Record questions and agreement in Jira.
8. Incorporate the agreed result into the workflow, glossary, relationships,
   lifecycle, assumptions, and decision log as applicable.

Do not ask the client to approve the ERD or write requirements during these
sessions. Requirements are derived after the workflow slice is coherent.

## Completion signal

This initial discovery phase is complete when the primary workflows can be
followed end to end, the major concepts have agreed meanings and relationships,
and the high-impact questions no longer prevent consistent examples. Software
requirements can then be derived in a separate documentation set.
