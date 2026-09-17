# Current Systems and Operational Boundaries

**Status:** Proposed landscape derived from supplied evidence and earlier
analysis. Client validation is required.

## Landscape

### Accounting workbooks

Present use includes an expense-invoice distribution register and information
used around DGII 606 preparation. These are strong evidence of current columns
and accountant activity, but not proof of settlement, complete tax semantics, or
canonical identity.

**Proposed relationship:** working tool and transition/evidence source. The
authoritative future boundary remains open.

### Local spreadsheets and documents

Files held on personal computers appear to contain payroll, contractor claims,
project labels, suppliers, workers, and other operational material. Many
originals are missing from the analyzed package, and generated CSVs sometimes
contradict later extracts.

**Proposed relationship:** evidence source until the original, responsible
owner, and business purpose are confirmed. Selected controlled records may later
be transition sources.

### External banking and payment evidence

Bank transfers, cash evidence, receipts, and other settlement records are needed
to explain money movement. Their exact storage and access process is not yet
documented.

**Proposed relationship:** external authority for observed money movement;
business purpose and allocation remain internal decisions.

### DGII systems and formats

DGII rules constrain tax reporting and electronic invoicing. Operational source
records must remain distinguishable from the reporting snapshot submitted under
the applicable format.

**Proposed relationship:** external regulatory authority and submission target.

### Jira Product Discovery

Jira coordinates questions, evidence requests, discussion, named agreement, and
review status with client participants.

**Adopted relationship:** discovery working tool. It is not the durable business
model or production system.

### Git business blueprint

This directory records the accepted business language, workflows, relationships,
policies, boundaries, and decisions.

**Proposed relationship:** authority for the current reviewed business model.

### Example database schema and interactive ERD

The earlier PostgreSQL schema consolidates many evidence-derived ideas and is
useful for finding questions and testing later requirements.

**Adopted relationship:** reference and prototype evidence, never automatic
business authority.

### Frappe Docker example

The supplied repository is not an application or data-model candidate.

**Adopted relationship:** optional future UI/UX reference only.

## Types of system relationship

Every external-system relationship should eventually be classified as one of:

- **Authority** — the external system owns the accepted record.
- **Working tool** — work happens there, while the authoritative business record is maintained elsewhere.
- **Reference** — the ERP retains an identifier or link but not the full external record.
- **Evidence source** — information may support verification but is not accepted without review.
- **Transition source** — current information is expected to migrate and the old source will stop being authoritative.

## Initial boundary decisions

- **Proposed:** the Git blueprint owns the reviewed business model.
- **Proposed:** Jira owns review coordination, not the final specification.
- **Adopted:** the example schema and ERD are downstream hypotheses.
- **Adopted:** Frappe is outside the application architecture.
- **Proposed:** current workbooks remain working tools until each future
  authority and migration boundary is explicitly decided.
- **Open:** which system or controlled register owns projects, parties,
  contracts, budgets, purchasing, contractor work, payroll, billing, and
  accounting during transition.

## Available operational evidence

- Private source material under `EVIDENCE/`.
- [Source assessment](<../../Example DB Schema/docs/schema/01-source-assessment.md>).
- [Migration decisions](<../../Example DB Schema/docs/schema/04-migration-decisions.md>).
- [Interactive ERD](<../../Example DB Schema/docs/erd/index.html>).

Evidence should be linked selectively. Sensitive source documents should not be copied into ordinary domain pages.
