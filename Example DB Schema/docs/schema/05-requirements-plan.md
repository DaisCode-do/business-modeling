# Requirements extraction and prototype plan

The ERD is now concrete enough to anchor customer interviews. The next phase
should validate workflows and rules in small slices instead of asking the
customer to approve all 85 tables at once.

The sequence below fits roughly two focused weeks of discovery and prototype
work, but its gates matter more than the calendar. A gate closes only when the
responsible customer participant approves the written outcome or records a
specific disagreement.

## Working method

For each subject:

1. show a familiar source document or current task;
2. ask the participant to narrate a real case and one exception;
3. replay the proposed workflow in plain language;
4. expose only the relevant ERD domains and fields;
5. record examples, decisions, unknowns, owners, and evidence;
6. prototype the smallest screen or report that can disprove the interpretation;
7. obtain approval or a precise correction.

Do not ask “is this schema correct?” Ask scenario questions such as “what must
happen when one bank transfer pays three invoices?” or “who can approve a new
spelling as the same project?”

## Preparation — before the first interview

### Create four living registers

- **Requirement register:** a stable ID, statement, source, affected domain,
  priority, status, and acceptance example.
- **Decision register:** the choice, alternatives, owner, date, rationale, and
  consequences.
- **Business-rule register:** rule, trigger, inputs, validation, exception,
  authorized override, and audit evidence.
- **Terminology register:** the customer's term, intended meaning, synonyms,
  and concepts it must not be confused with.

Seed these registers from [the initial business rules](03-business-rules.md),
but mark unapproved statements as hypotheses.

### Prepare evidence packets

Choose a small real example for each critical flow: one clean purchase, one
duplicate or corrected NCF, one contractor claim with a deduction, one payroll
period, one ambiguous project alias, and one client change/addition if evidence
exists. Keep source paths and hashes with every example.

### Identify decision owners

At minimum, identify who can decide accounting/tax policy, project identity,
commercial/client workflow, purchasing/payment workflow, payroll relationships,
and system access. A frequent user may explain a process without being
authorized to set the policy.

## Interview block 1 — identity, projects, and access

Participants should include the administrator/owner, a project lead, and the
accountant where tax identity is involved.

### Questions to settle

- What is the operating company's exact legal identity?
- What qualifies as one project, and who creates/closes it?
- Can one project have several clients, owners, contacts, or sites?
- Which historical strings are aliases, cost centers, people, or mistakes?
- When can a supplier also be a contractor or client?
- What proof is needed to verify or merge an RNC/Cédula?
- Which records may clients, field staff, project managers, and accountants see
  or change?

### Approval artifact

Produce the first authoritative project register, a party merge/alias decision
set, and a role/access outline. Update the ERD only when these decisions change
the conceptual model.

### Prototype 1 — master-data review desk

Build a narrow prototype that shows a proposed party or project beside its
source evidence, conflicts, alias candidates, and approve/reject/merge actions.
Its purpose is to validate identity governance, not visual styling.

## Interview block 2 — purchase, payment, and DGII 606

The accountant should lead this block. Include whoever records purchases and
whoever controls bank/cash evidence.

### Questions to settle

- What event creates the supplier obligation?
- What does each source `forma_pago` value actually mean?
- Which evidence proves settlement, and when may an invoice be marked paid?
- How are credit, partial payments, grouped transfers, advances, refunds, voids,
  and modified NCFs handled?
- Which invoice amount is allocated to projects: base, gross, recoverable tax,
  or another accounting basis?
- How are all 606 fields obtained, reviewed, corrected, submitted, and frozen?
- Who resolves duplicate NCF and supplier-identity conflicts?

### Approval artifact

Produce a purchase-to-payment state model, an approved 606 field mapping, a
duplicate/correction policy, and example postings for common cases.

### Prototype 2 — invoice review and settlement

Show document evidence, extracted values, canonical supplier/project choices,
tax fields, cost allocation, review issues, outstanding balance, and payment
applications. Include one duplicate and one partial-payment scenario.

## Interview block 3 — contractor claims and payroll

Include the person who prepares cubicaciones, a project lead, the payroll
operator, and the accountant.

### Questions to settle

- When is a cubicación a contractor claim, payroll support, or client
  certification?
- Who owns a crew, and when is a worker an employee, day laborer, or contractor
  member?
- What are the exact pay/claim periods and approval stages?
- What does the two-percent amount represent, on which base is it calculated,
  and where does it apply?
- How are advances, retainage, recoveries, corrections, and rejected work
  represented?
- Must claim lines correspond to budget/work items, and at what granularity?
- What evidence authorizes payment?

### Approval artifact

Produce lifecycle diagrams for contractor claims and payroll, a worker
relationship policy, period rules, deduction formulas, reconciliation tolerance,
and example accounting events.

### Prototype 3 — claim and payroll approval

Show source evidence, measured lines, calculated totals, typed deductions,
date certainty, approval history, and eventual payment applications. The UI
should make unreconciled totals impossible to miss.

## Interview block 4 — budgets, APU, changes, and client billing

Include project estimation, project management, the commercial decision owner,
and the accountant.

### Questions to settle

- What is the approved budget hierarchy and version lifecycle?
- Which resources and units are centrally reusable?
- When does a supplier quote become price history, and when does an APU freeze?
- How are additions/change orders requested, priced, approved, rejected, and
  attached to evidence?
- Does each addition have its own cash-flow plan or modify the current one?
- Is the client billed by date, milestone, certified progress, or a mixture?
- How do retainage, advances, taxes, electronic invoicing, cancellations, and
  receipts affect the client balance?

### Approval artifact

Produce the budget/APU version rules, change-order state model, client approval
evidence requirements, and contract-to-cash lifecycle.

### Prototype 4 — budget and client change review

Show a baseline version beside a proposed change, affected work/APU, commercial
impact, evidence, approval, and chosen cash-flow treatment. Then demonstrate how
approved progress becomes a client invoice without confusing it with a
contractor claim.

## Technical boundary — architecture and frontend references

The custom PostgreSQL model remains the source-of-truth candidate, with
technical decisions managed by the developer. The supplied `frappe_docker`
repository is not part of the ERP architecture evaluation and should not be
mapped into the canonical model.

When frontend implementation begins, selected Frappe interactions may be
reviewed as UI/UX references. This review must stay narrow and must not turn
Frappe conventions into business requirements. See the
[recorded Frappe boundary](06-frappe-evaluation.md).

## Consolidation and approval gate

At the end of the cycle:

1. reconcile interview notes with the requirement, decision, rule, and
   terminology registers;
2. annotate every rule as approved, rejected, superseded, or still open;
3. update the conceptual ERD and DDL only for approved or deliberately
   prototype-level decisions;
4. document any schema change with its business reason and migration impact;
5. rerun SQL validation and regenerate the ERD from the DDL;
6. ask each decision owner to approve only their domain;
7. hold a short cross-domain review for shared concepts such as party, project,
   document, cost center, payment, and audit history.

## Definition of ready for the next prototype

A domain is ready to move beyond discovery when it has:

- named actors and permissions;
- a happy path plus at least two material exception examples;
- explicit states and allowed transitions;
- field provenance and ownership;
- calculation, rounding, uniqueness, and reconciliation rules;
- attachment and approval evidence requirements;
- audit and reversal expectations;
- representative acceptance cases approved by the responsible participant;
- no unresolved question that would reverse the domain boundary.

## What should remain out of scope for now

- certifying historical financial totals;
- bulk canonical import before identity/project policy exists;
- implementing all ledger automation before accountant approval;
- fleet implementation unless the customer promotes it into the first release;
- adopting Frappe as the application platform or canonical data model;
- polishing a broad ERP interface before the four critical workflows are
  validated.
