# Working Assumptions

Assumptions permit the model to progress before every policy is known. They are
not business rules and should be replaced by evidence or decisions.

## Current assumptions

### A-001 — Project as central context

- **Assumption:** A project is the central context for construction delivery,
  contracts, planning, cost, progress, and client billing, while overhead can
  exist outside any project.
- **Affected areas:** Projects, Planning, Procurement, Work Delivery, Client
  Billing, Finance.
- **Validation route:** Walk through one active project and one overhead expense.

### A-002 — One identity, several roles

- **Assumption:** One person or organization may be a supplier, contractor,
  client, worker, owner, or contact without becoming duplicate identities.
- **Affected areas:** Business Relationships and every participant-dependent
  workflow.
- **Validation route:** Review real examples of role overlap and exceptions.

### A-003 — Cost workflows remain distinguishable

- **Assumption:** Purchases, contractor claims, and payroll have separate causes,
  approvals, and histories even when consolidated into project cost reporting.
- **Affected areas:** Procurement, Work Delivery, Finance.
- **Validation route:** Compare one example from each cost source.

### A-004 — Obligation and payment are different facts

- **Assumption:** An invoice, claim, payroll amount, or client receivable explains
  an obligation; payment records money movement; allocation explains settlement.
- **Affected areas:** Procurement, Contractors, Payroll, Client Billing, Finance.
- **Validation route:** Review a partial payment and one grouped payment if they
  occur.

### A-005 — Accepted history is corrected, not silently overwritten

- **Assumption:** Approved baselines, issued documents, posted financial history,
  and submitted tax reports require traceable correction or supersession.
- **Affected areas:** All controlled records.
- **Validation route:** Review one corrected invoice, budget/change, claim, or tax
  submission.

### A-006 — Current extracted data is not authoritative by itself

- **Assumption:** ETL outputs and “database-ready” files are discovery evidence
  whose identity, provenance, and meaning require human review.
- **Affected areas:** Migration and every domain populated from historical data.
- **Validation route:** Compare selected output rows to originals and their
  responsible owner.

If an assumption is disproved, update the affected workflow and concept model and
record the resulting decision in [Decision Log](DECISION-LOG.md).
