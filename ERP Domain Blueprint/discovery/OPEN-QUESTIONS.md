# Open Domain Questions

These are the questions with the greatest effect on the business model. They are
grouped for focused review rather than treated as a general list of defects.

## Foundation

- **FND-001 — Business boundary:** Which legal entities, operating units,
  locations, and related organizations are included in this ERP?
- **FND-002 — Primary value stream:** What is the company's normal chain from a
  client need through delivery, collection, cost settlement, and closeout?
- **FND-003 — Decision ownership:** Who may define policy for projects,
  purchasing, contractor work, payroll, client billing, accounting/tax, and
  system access?
- **FND-004 — Existing authorities:** Which current file, person, or system is
  authoritative for each major business record during discovery and transition?

## Business relationships and projects

- **PRJ-001 — Project identity:** What makes two records part of the same project,
  and who may create, merge, rename, close, or reopen a project?
- **PRJ-002 — Project context:** How do client, owner, contact, contract, site,
  cost center, phase, and project relate?
- **PRJ-003 — Project lifecycle:** Which stages are meaningful to the business,
  and what evidence or decision permits each transition?
- **PTY-001 — Party roles:** When may one person or organization hold several
  roles, and are any roles legally or operationally required to stay separate?

## Planning and delivery

- **PLN-001 — Baseline:** What establishes the approved scope, budget, APU,
  schedule, and cash-flow baseline?
- **PLN-002 — Change:** How is an addition or change requested, priced, approved,
  incorporated, rejected, and preserved historically?
- **WRK-001 — Measured work:** Which distinct records are currently called
  `cubicacion`, and who prepares, reviews, approves, bills, or pays each kind?
- **WRK-002 — Workforce relationship:** How are employees, day laborers,
  contractor crews, and independent contractors distinguished over time?

## Purchasing, payment, accounting, and tax

- **FIN-001 — Supplier obligation:** What event and evidence make a supplier
  invoice payable?
- **FIN-002 — Settlement:** What proves payment, and how are partial, grouped,
  advance, refund, and correction cases handled?
- **FIN-003 — Cost allocation:** Which amount is assigned to project cost and how
  may overhead or unallocated amounts be resolved?
- **FIN-004 — NCF correction:** What policies govern duplicates, modifications,
  voids, and corrections?
- **FIN-005 — Contractor deductions:** What does the observed two-percent amount
  mean, how is it calculated, and when does it apply?
- **FIN-006 — Accounting boundary:** Which operational facts become accounting
  entries, who approves them, and which work remains with the accountant or
  another system?

## Client commercial and records

- **CLI-001 — Client lifecycle:** What accepts the commercial relationship and
  authorizes progress certification, invoicing, collection, retainage, and
  cancellation or reversal?
- **GOV-001 — Evidence and documents:** Which documents must be retained, where
  are authoritative versions held, and who may see or approve them?
- **GOV-002 — Exceptions:** Which deviations remain an ordinary workflow
  variation and which require a controlled issue, decision, or approval record?

## Resolution rule

When a question is answered:

1. record the decision in [Decision Log](DECISION-LOG.md);
2. update the relevant workflow and domain page;
3. update the glossary only if the meaning of a term changed; and
4. remove or mark the question resolved without deleting its identifier from the
   decision history.
