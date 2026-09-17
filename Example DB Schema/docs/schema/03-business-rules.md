# Business rules

This is the initial rule register. “Encoded” means the DDL already represents
the rule through structure, a constraint, or a status field. It does not mean
the customer has approved the underlying policy.

## Rules encoded in prototype v0

### BR-001 — Imports cannot silently become verified identity

Source rows remain immutable in staging. A review decision is required before
they create or overwrite a verified party or identifier.

### BR-002 — Verified national identifiers are unique

A verified RNC or Cédula is globally unique by identifier type and country.
Unverified conflicts may coexist while being investigated.

### BR-003 — One actor may hold several roles

A person or organization may simultaneously be a supplier, contractor, client,
employee, worker, owner, or contact. Those roles do not create duplicate master
records.

### BR-004 — Every transaction has an accounting owner

Each business transaction belongs to `core.legal_entity`, even when the first
deployment operates only one company.

### BR-005 — Project aliases require approval

A raw project string maps only through an approved alias. Fuzzy matching may
propose a candidate, but it cannot approve the alias or create the project.

### BR-006 — “MISC” is not a construction project

General, uncertain, or unallocated cost goes to an explicit `UNALLOCATED` or
`GENERAL_OVERHEAD` cost center until a user distributes it.

### BR-007 — Cost domains remain distinct

Purchases, payroll, and contractor claims keep their own source tables and
lifecycles. The read-only `reporting.project_cost_event` view aligns them for
analysis.

### BR-008 — Deductions are typed positive amounts

Withholdings, retainage, recovery, penalties, and other deductions are stored as
positive rows. A source's negative sign is normalized only after its meaning is
confirmed.

### BR-009 — Date uncertainty is explicit

Exact, range-derived, month-estimated, and unknown dates remain analytically
distinguishable through date precision and provenance.

### BR-010 — Canonical supplier NCF reuse is prevented

A non-void purchase NCF is unique per legal entity and supplier. Imported
conflicts remain review issues rather than overwriting one another.

### BR-011 — Payment is independent from obligation

Invoices, contractor claims, and payroll create obligations. A payment records
money movement. Typed application rows support partial and many-to-many
settlement.

### BR-012 — Approved budget versions are immutable

Edits produce a new version. Approved scope changes use a change order with its
own lines and evidence rather than mutating the original baseline.

### BR-013 — Each change decides its cash-flow treatment

An addition must explicitly remain separate or modify the active plan.
`UNDECIDED` cannot advance to implementation.

### BR-014 — APU and supplier prices are historical facts

APU assumptions and supplier prices are time-versioned. Supplier branch, unit,
and source evidence are retained.

### BR-015 — Financial precision is decimal

Money uses `numeric(18,2)`. Quantities and rates use four decimal places. Source
values remain unchanged in staging, while business rounding happens under an
approved policy.

### BR-016 — Administrator and accountant are permissions

These are access roles, not separate actor or employee entity types. A login may
link to a real employee party when appropriate.

### BR-017 — Posted history is reversed, not erased

Canonical financial records should not be physically deleted after posting.
Statuses, reversals, and audit events preserve what happened.

## Cross-row validations designed but not yet implemented

These need deferred database triggers or transactional service validation after
policy confirmation:

- journal debits equal journal credits before posting;
- payment applications do not exceed the payment amount;
- applications do not over-settle an obligation without an approved exception;
- purchase cost allocations reconcile to the chosen invoice basis;
- contractor claim gross minus typed deductions equals net;
- payroll gross minus typed deductions equals net;
- claim and payroll headers reconcile to their detailed lines;
- approved budget totals reconcile to their line hierarchy;
- progress percentages and cumulative quantities cannot move beyond approved
  bounds without an explicit correction workflow;
- accounting entries cannot post into a closed period.

## Policy questions that block stronger enforcement

### D-01 — Legal identity

Confirm the company's legal name and RNC, especially the `132621468` conflict.

### D-02 — Project authority

Confirm the canonical project code, name, site, status, clients/owners, and
dates, then decide every probable alias and combined-project value.

### D-03 — Duplicate NCF exception policy

Determine whether legitimate reuse or correction scenarios exist, how voided or
modified NCFs behave, and who may approve a conflict.

### D-04 — Two-percent deduction

Identify its tax/legal type, base, eligible worker or contractor relationships,
rounding, exception cases, reporting, and posting treatment.

### D-05 — Meaning of `forma_pago`

Decide whether it represents an intended method, DGII acquisition/payment code,
actual settlement, or a mixture. Identify the evidence required to mark an
obligation as paid.

### D-06 — Payroll relationship and period rules

Define pay cutoffs and how staff, casual/day labor, workshop staff, and members
of contractor crews are distinguished.

### D-07 — Client commercial lifecycle

Define contract acceptance, budget approval, change approval, progress
certification, invoicing, receipt, retainage, and cancellation/reversal steps.

### D-08 — Accounting policy

The accountant must approve the chart of accounts, posting dates and events,
tax codes/accounts, cost basis, retainage, rounding, close, and reversal rules.

### D-09 — Resource and APU governance

Decide who creates catalog resources, how duplicates and units are controlled,
how supplier quotes become prices, and when an APU version is frozen.

### D-10 — Fleet scope

Decide whether fleet belongs in the first delivery, a later release, or outside
this ERP altogether.
