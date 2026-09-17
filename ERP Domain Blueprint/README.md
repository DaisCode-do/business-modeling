# ERP Business Domain Blueprint

**Status:** Working foundation  
**Subject:** Constructora Angote business operations  
**Audience:** Business owners, domain contributors, analysts, and future product teams

This directory is the working foundation for a durable description of Constructora Angote
business domain. Its intended destination is an ERP: an internal operational system that
connects the companies's domains.

The documentation defines the business before anyone defines software. It describes:

- the language used by the company;
- the concepts the business needs to remember;
- the relationships among those concepts;
- the workflows through which work is completed;
- the boundaries between the company and its existing systems; and
- the decisions and open questions that affect the model.

It deliberately does **not** define screens, APIs, database tables, technical architecture,
user stories, acceptance criteria, or a delivery backlog. Those artifacts can later be
derived from a stable domain description.

## Reading order

These are to be populated as the information is extracted from the clients.

1. [Design Strategy](foundation/DESIGN-STRATEGY.md)
2. [Business Context](foundation/BUSINESS-CONTEXT.md)
3. [Current Systems](foundation/CURRENT-SYSTEMS.md)
4. [Domain Map](foundation/DOMAIN-MAP.md)
5. [Glossary](language/GLOSSARY.md)
6. [Conceptual Relationships](model/RELATIONSHIPS.md)
7. [Workflow Index](workflows/README.md)
8. [Open Questions](discovery/OPEN-QUESTIONS.md)
9. [Git Workflow](GIT-WORKFLOW.md)

## Directory structure

```text
foundation/   intention, business boundary, current systems, and domain map
language/     common vocabulary and business roles
domains/      concepts and responsibilities grouped by business area
model/        cross-domain relationships and lifecycles
workflows/    end-to-end descriptions of business activity
discovery/    decisions, sources, assumptions, and questions still to validate
```

The structure is intentionally small. A new directory should be introduced only when it gives a genuinely different view of the business.

## Documentation states

Statements can use the following labels when their certainty matters:

- **Observed** — supported by present practice or supplied evidence.
- **Adopted** — accepted as part of the documentation strategy or business model.
- **Proposed** — a coherent starting definition that still needs business review.
- **Open** — a question or choice that has not been resolved.
- **Retired** — retained for historical context but no longer applicable.

Unlabeled definitions in this initial set are proposed unless a source or an adopted decision says otherwise.

## How this set should evolve

Work from workflows toward detail:

1. Review an end-to-end workflow with the people who perform it.
2. Correct its participants, decisions, exceptions, and outcomes.
3. Update the glossary and relationship model with any newly agreed concept.
4. Record important policy choices in the decision log.
5. Link supporting operational evidence without copying sensitive content into the domain definition.

Repository changes should follow the [Git Workflow](GIT-WORKFLOW.md), which keeps accepted documentation on `main`,
uses short-lived branches for semantic changes, and keeps raw operational evidence outside version control.
