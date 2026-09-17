# Business Context

## Organization

**Proposed; legal and operating identity still require confirmation.**

Constructora Angote operates in construction and related services. The supplied
material shows work involving construction projects, clients, suppliers,
contractors, workers, purchases, contractor claims or `cubicaciones`, payroll,
payments, tax reporting, budgets, unit-price analysis, changes/additions, and
project cost reporting.

The evidence is strongest around accounting workbooks and extracted operational
files. It is weaker around the complete commercial and project-delivery process.
This blueprint must therefore begin with client walkthroughs rather than treating
the extracted data or prototype schema as a complete description of the company.

## Purpose of the ERP domain

The business domain should explain how the company:

- establishes clients, suppliers, contractors, workers, and their changing roles;
- creates and governs construction projects and their contractual context;
- estimates, budgets, plans, changes, executes, measures, and closes work;
- obtains resources and services and assigns their cost to the proper purpose;
- approves contractor work and workforce obligations;
- bills clients and records collections;
- records payments, tax consequences, and accounting evidence; and
- preserves approvals, documents, corrections, and decision history.

The ERP is intended to connect those areas without collapsing them into a single
generic transaction or replacing every specialized tool by default.

## Domain areas

The initial review will test the following proposed areas:

- **Business Relationships** — people, organizations, roles, contacts, and
  responsibility.
- **Projects and Contracts** — project identity, sites, participants, agreements,
  lifecycle, and contractual scope.
- **Planning and Cost Control** — estimates, budgets, APU, schedules, cost
  structures, progress, and approved changes.
- **Procurement and Supplier Obligations** — quotations, purchasing, receipt of
  goods/services, supplier invoices, cost allocation, and payables.
- **Work Delivery and Capacity** — contractors, crews, workers, assignments,
  measured work, contractor claims, and payroll-related operational records.
- **Client Commercial and Billing** — client approvals, progress certification,
  invoicing, receipts, retainage, and outstanding balances.
- **Finance, Accounting, and Tax** — payments, allocation, reconciliation,
  accounting events, controls, DGII reporting, and period close.
- **Governance and Records** — evidence, documents, approvals, exceptions,
  corrections, access responsibility, and audit history.

Fleet and equipment remain a candidate extension rather than an assumed first
delivery area.

## Primary business chain

Construction work is unlikely to be one simple linear process. The proposed
model uses two connected value streams supported by a shared control spine:

```text
Client/commercial stream
Need or opportunity -> estimate/proposal -> agreement -> authorized change or
certified progress -> client invoice -> collection

Delivery/cost stream
Project established -> plan/budget -> procure/assign -> execute/measure ->
approve supplier, contractor, or workforce obligation -> payment

Control spine
Parties and roles + project identity + documents and approvals + accounting/tax
```

The client should correct this chain before detailed workflow modeling begins.

## Boundary of this documentation

Included:

- business terminology and policy;
- business roles and responsibilities;
- concept relationships and lifecycle meanings;
- current and target workflows;
- existing-system responsibilities;
- assumptions, decisions, and unresolved domain questions.

Excluded:

- software requirements and prioritization;
- interface and interaction design;
- technical data models;
- APIs and synchronization mechanisms;
- infrastructure and deployment;
- implementation estimates.

## Starting assumptions

- A project is a central business context, but not every company cost is a
  project cost.
- One person or organization may participate in more than one business role.
- Purchases, contractor claims, payroll, and client billing have distinct causes
  and lifecycles even when they contribute to the same project report.
- An obligation, a money movement, and the application of that money are
  different business facts.
- Approved baselines and posted history should be corrected through traceable
  change rather than silent replacement.
- The current files, ETL outputs, ERD, and schema contain useful hypotheses but
  can neither define policy nor certify historical totals without review.
