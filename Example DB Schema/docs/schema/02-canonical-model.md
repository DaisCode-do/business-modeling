# Canonical model

The schema uses a shared **party plus roles** model. A person or organization can
be a supplier, contractor, client, owner, worker, or contact without creating
several contradictory master records.

This does not introduce multi-tenancy. `core.legal_entity` is the minimum
accounting boundary for the one operating company. One row is sufficient today,
while avoiding an expensive retrofit if another legal entity is introduced.

Use the [interactive ERD](../erd/index.html) to explore fields and direct
relationships. The sections below explain the intent rather than repeating the
DDL.

## People and organizations — `core`

`party` is the canonical actor. `person_profile` and `organization_profile`
provide attributes that apply only to one kind of actor.

`party_identifier` holds an RNC, Cédula, passport, or other identity with an
explicit verification state. `party_alias` preserves approved spellings,
nicknames, trade names, and legacy codes. `party_role` says what that actor does
for the company. `party_relationship` connects contacts, representatives,
employees, and related organizations without duplicating either party.

`site` represents a project site, supplier branch, office, warehouse, or
workshop. `contact_point` holds phone, WhatsApp, email, web, and extension data.
`legal_entity` is the owning accounting company.

## Access and audit — `iam`

`app_user` is a login, optionally linked to a real person. `access_role` defines
permission bundles such as administrator, accountant, project manager, client
viewer, and field worker. `app_user_role` grants a role globally, for the legal
entity, or for one project.

`audit_event` is an append-only trace of important user and data changes.

Administrator and accountant are therefore permissions, not employee types.

## Documents — `files`

`stored_file` records the physical object's hash, location, media type, size,
and original name. `document` adds business meaning and verification status.

`party_document` and `project_document` attach that evidence to actors or
projects. The same design allows an invoice image, receipt, contract, identity
document, photo, or plan to remain evidence rather than becoming the business
event itself.

## Imports and review — `staging`

`import_batch` identifies a reproducible ingestion run and pipeline version.
`source_file` records the full path and extraction outcome for each input.
`source_record` keeps the immutable raw payload and its exact sheet, row, or cell
locator.

`review_issue` represents quarantines, duplicate candidates, identity conflicts,
arithmetic failures, and mapping decisions. A person resolves these issues
before canonical data is created or changed.

## Projects and planning — `projects`

### Project identity and participation

`project` comes from an approved project register. `project_alias` maps
historical source text to that project. `project_site` connects one or more
physical locations. `project_party` assigns clients, owners, contacts, partners,
managers, and supervisors.

`cost_center` receives project and non-project cost. It permits explicit
overhead, workshop, fleet, and unallocated cost without inventing fake projects.

### Work, schedule, and progress

`work_item` is the hierarchical work-breakdown item shared by budget, schedule,
progress, and measured claims. `schedule_activity` adds planned and actual time;
`activity_dependency` relates predecessors and successors.

`progress_measurement` is a dated physical-progress report.
`progress_measurement_line` holds previous, current, and cumulative measurements
for each work item.

### Budgets and changes

`budget` gives a project budget a stable identity. `budget_version` makes draft,
submitted, approved, and superseded snapshots explicit. `budget_line` is the
hierarchical priced content. `budget_approval` records a client's decision and
its evidence.

`change_order`, `change_order_line`, and `change_order_approval` keep additions
or scope changes distinct from the original approved baseline.

## Resources and APU — `catalog`

`unit_of_measure` provides controlled units across resources, invoices, work,
and analysis. `resource` is the reusable catalog for material, labor, equipment,
subcontract, and service items. `resource_alias` maps reviewed source wording.

`specialty` is a controlled trade or discipline. `party_specialty` assigns one
or more specialties to workers or contractors.

`supplier_price` is specific to supplier, branch, unit, effective date, and
source evidence. `cost_analysis` is a reusable APU identity;
`cost_analysis_version` provides dated snapshots; and
`cost_analysis_component` records resource quantity, waste, and assumed cost.

## Purchases and contractor claims — `procurement`

`purchase_invoice` is the supplier obligation and NCF-bearing document.
`purchase_invoice_line` preserves the supplier's wording and price snapshot,
with an optional link to a resource. `purchase_invoice_tax` holds typed tax or
fee amounts. `purchase_cost_allocation` distributes cost across approved cost
centers.

`contractor_claim` is an outgoing contractor cubicación. It owns its date
certainty, amounts, and review state. `contractor_claim_line` records measured
work. `contractor_claim_deduction` represents positive, typed withholding,
retainage, recovery, penalty, or another deduction.

Purchases and contractor claims remain separate source domains even though both
can become project cost.

## Workforce and payroll — `workforce`

`position` provides controlled jobs or payroll positions. `engagement` explains
whether a person is staff, day labor, workshop staff, or a member of a
contractor-led crew.

`payroll_run` defines an approved pay period and its date precision.
`payroll_entry` records a worker's earnings and net amount by project or cost
center. `payroll_deduction` provides typed, positive deductions.

## Client contracts and billing — `billing`

`client_contract` represents the project's commercial agreement and whether it
uses cash-flow, progress, or mixed billing.

`payment_plan` is a versioned plan for the base contract or for a separate
change. `payment_plan_installment` defines expected charges by date or milestone.

`client_progress_certificate` is the incoming, approved basis for billing from
physical progress. `sales_invoice` creates the receivable and provides the
electronic fiscal-document lifecycle. `sales_invoice_line` records the work or
addition billed.

## Payments and receipts — `finance`

`financial_account` is the company's cash, bank, card, or clearing account.
`payment` is an actual incoming or outgoing money movement. Any receipt is
evidence attached to this event.

Four application entities allocate money without losing its original event:

- `purchase_invoice_payment` applies outgoing money to a supplier invoice.
- `contractor_claim_payment` applies outgoing money to a contractor claim.
- `payroll_entry_payment` applies outgoing money to one worker obligation.
- `sales_invoice_payment` applies incoming money to a client invoice.

This supports partial settlement, one payment across several obligations, and
several payments against one obligation.

## DGII reporting — `tax`

`dgii_submission` is a versioned reporting envelope and response state for
formats such as 606, 607, 608, and 609. `dgii_606_record` is the exact immutable
tax-field snapshot reported for one purchase invoice.

Reporting corrections create a new snapshot or submission; they do not rewrite
the operational invoice's history.

## General ledger — `accounting`

`accounting_period` defines open and closed posting intervals. `gl_account` is a
hierarchical chart-of-accounts entry. `journal_entry` and `journal_line` provide
the minimum double-entry spine, including optional analysis by party, project,
and cost center.

This structure is a prototype boundary. The accountant must still approve the
chart, posting events, tax accounts, reversals, and rounding policy.

## Fleet extension — `fleet`

This optional module is isolated because its evidence currently comes only from
meeting notes.

`asset` covers vehicles, heavy equipment, tools, and other operational assets.
`vehicle_profile` adds vehicle-specific facts. `asset_document` links
registration, insurance, inspection, title, or license evidence.

`driver_assignment` relates a driver and asset over time. `maintenance_order`
and `maintenance_line` record service and parts. `telemetry_position` stores
timestamped location and movement observations.

## Reporting — `reporting`

`project_cost_event` is a read-only view that aligns gross purchases,
contractor claims, and payroll for analysis. It never merges or replaces their
operational source tables.

## Distinctions to preserve in interviews

### Product, expense wording, APU component, and work item

- A **resource/product** is a reusable catalog item with a controlled unit.
- An **invoice line** preserves a supplier's description and historical price.
- An **APU component** is a versioned cost assumption for a resource.
- A **work item or budget line** describes work promised or delivered.

The current files do not provide a reliable product master, and these four
concepts must not be collapsed because their names happen to resemble each
other.

### Invoice, payment, and receipt

- An invoice creates an amount due.
- A payment moves money between parties and financial accounts.
- A payment application says which obligations that money settles.
- A receipt is attached evidence of the money movement.

The source `forma_pago` field is retained as a reported mode, but it does not
prove that money moved or that a credit invoice was later paid.

### Two meanings of “cubicación”

The existing files mostly show an outgoing contractor claim and project cost.
Meeting notes describe an incoming client progress certification and billing
basis. They may share work and physical-progress measurements, but have
different counterparties, approvals, taxes, payable/receivable behavior, and
settlement lifecycles.
