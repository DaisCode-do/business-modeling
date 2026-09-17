# Domain Decision Log

This log records decisions that shape the business documentation. It is not a
software architecture decision record.

## Documentation and discovery decisions

### D-001 — Blueprint owns the accepted business model

- **Date:** 2026-09-17
- **Status:** Proposed for repository-owner confirmation
- **Decision:** The Git-versioned ERP Domain Blueprint is the durable source of
  the currently accepted business model.
- **Reason:** Evidence, review coordination, business meaning, and technical
  implementation have different responsibilities and should not compete as one
  source of truth.

### D-002 — Jira coordinates multi-party validation

- **Date:** 2026-09-17
- **Status:** Proposed for repository-owner confirmation
- **Decision:** Jira Product Discovery owns review status, discussion, evidence
  requests, and named agreement. An item is not complete until its accepted
  result is incorporated into the blueprint.
- **Reason:** Constructora requires coordination among participants, while the
  final business model must remain coherent and versioned outside individual
  discussion cards.

### D-003 — Earlier schema remains downstream evidence

- **Date:** 2026-09-17
- **Status:** Adopted by the developer
- **Decision:** The PostgreSQL prototype, ERD, and schema analysis are retained
  as hypotheses, question sources, and later validation tools. They do not define
  the business model.
- **Reason:** Much of the model was inferred from fragile ETL and incomplete
  sources before the workflows and policies were reviewed.

### D-004 — Frappe is a UI/UX reference only

- **Date:** 2026-09-17
- **Status:** Adopted by the developer
- **Decision:** Frappe is excluded as the ERP platform and canonical data model.
  Selected interactions may be consulted later as frontend references.
- **Reason:** The implementation will be derived from the custom business model
  and architecture rather than adapting the business to an existing framework.

### D-005 — Reuse method and stable patterns, not company policy

- **Date:** 2026-09-17
- **Status:** Proposed for repository-owner confirmation
- **Decision:** EduGuiders contributes a worked documentation method and candidate
  conceptual patterns. Constructora terminology, workflows, rules, and boundaries
  must come from Constructora validation.
- **Reason:** Company-specific detail is necessary for product fit but becomes
  dangerous when transferred between organizations as if it were generic.

## Adding a decision

A material decision should include:

- a stable identifier;
- the date and responsible decision owner;
- the selected option;
- the alternatives considered;
- the business reason;
- affected concepts and workflows; and
- any condition under which the decision should be revisited.

When a proposed decision is validated, update its status instead of creating a
duplicate definition elsewhere.
