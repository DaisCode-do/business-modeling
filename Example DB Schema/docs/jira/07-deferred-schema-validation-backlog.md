# Deferred schema-validation backlog

These nine items were derived from the earlier source assessment and prototype
rules. They remain valuable, but they are **not the first Jira batch anymore**.
Activate them only after the relevant business workflow and vocabulary have been
modeled in the ERP Domain Blueprint.

Do not create all nine merely because they already have copy-ready text. Select
an item when it validates a question discovered in the current workflow slice,
then link its accepted outcome to the blueprint section it changes.

The IDs below are planning labels, not assumed Jira keys. Jira will assign the
actual keys.

Before copying an item into Jira, replace repository-relative source links with
a reachable link, Insight, or small attached evidence packet.

## Wave 1 — establish identity and project meaning

### DET-01 — Confirm the operating company's legal identity

**Recommended setup**

- Item kind: Evidence question
- Statement class: Uncertainty
- Business area: Business relationships; Finance, accounting, and tax; Data
  migration and evidence
- Initial status: Evidence Needed
- Decision owner: Administrator/owner, confirmed with accountant
- Evidence confidence: Indirect extraction

**Copy-ready description**

```markdown
## Why this matters
The company identity controls tax reporting, invoice ownership, and every
accounting transaction in the ERP.

## Current understanding
- The RNC `132621468` appears in workbook headers as the reporting company.
- Three expense rows associate the same number with “La Casa de la Estufa,” so
  the extracted names cannot safely settle the identity.

## What we need from you
Please attach or link one current official document showing the company's legal
name and RNC, or tell us who holds it. Also comment whether `132621468` is the
correct company RNC.

That is all required; the developer will record the canonical result.

## Recorded outcome — maintained by developer
Pending evidence.
```

**Repository provenance:** RF-05 in
[source assessment](../schema/01-source-assessment.md) and D-01 in
[business rules](../schema/03-business-rules.md).

### DET-02 — Approve the first project and alias register

**Recommended setup**

- Item kind: Business decision
- Statement class: Uncertainty
- Business area: Projects and contracts; Data migration and evidence
- Initial status: Evidence Needed
- Decision owner: Administrator/owner or project authority
- Evidence confidence: Direct source documents plus indirect extraction

**Preparation before client review**

Attach a short, pre-filled register containing the proposed project, code,
aliases, site, status, and unresolved values. Highlight only the ambiguous rows.
Include `MISC`, `EUSEBIO`, `???`, `PROYECTOS`, `L`, `LA ESTANCIA`, the combined
project value, and the documented alias groups. Do not send a blank form.

**Copy-ready description**

```markdown
## Why this matters
Purchases, claims, payroll, budgets, and client billing all depend on knowing
which records refer to the same project.

## Current understanding
- The extracted list mixes projects, aliases, people, locations, placeholders,
  and combined project names.
- Similar spelling may suggest a match, but it cannot approve one.
- `MISC` is proposed as overhead or temporarily unallocated cost, not a project.

## What we need from you
Review the attached proposed register and comment only on incorrect or unknown
rows. Please also confirm who is allowed to approve future project aliases.

## Recorded outcome — maintained by developer
Pending reviewed register.
```

**Repository provenance:** RF-07 in
[source assessment](../schema/01-source-assessment.md), BR-005/BR-006 and D-02
in [business rules](../schema/03-business-rules.md).

### DET-03 — Confirm that one person or company may have several roles

**Recommended setup**

- Item kind: Relationship and policy review
- Statement class: Proposed behavior
- Business area: Business relationships
- Initial status: Discuss
- Decision owner: Administrator/owner
- Evidence confidence: Prototype inference supported by source conflicts

**Copy-ready description**

```markdown
## Why this matters
Separate copies of the same person or company create conflicting balances,
documents, contact details, and tax identities.

## Current understanding
- One real person or company has one master identity.
- That identity may be a supplier, contractor, client, employee, owner, or
  contact at the same time.
- Roles and their dates are recorded without duplicating the identity.

## What we need from you
Comment **Agree**, or give one case where the same person/company must remain as
separate identities rather than one identity with several roles.

## Evidence considered
The alleged client and employee files contain copied contractor data, so their
labels cannot be trusted as separate master lists.

## Recorded outcome — maintained by developer
Pending.
```

**Repository provenance:** RF-08 in
[source assessment](../schema/01-source-assessment.md) and BR-003 in
[business rules](../schema/03-business-rules.md).

## Wave 2 — separate purchases from settlement

Move this wave out of `Draft` only after Wave 1 has a recorded result or a
specific external blocker.

### DET-04 — Decide what `forma_pago` means in the purchase register

**Recommended setup**

- Item kind: Business decision
- Statement class: Uncertainty
- Business area: Procurement and supplier obligations; Finance, accounting, and
  tax
- Initial status: Draft, then Discuss
- Decision owner: Accountant
- Evidence confidence: Direct source document, ambiguous semantics

**Copy-ready description**

```markdown
## Decision needed
The purchase sheets contain `forma_pago`, but its value does not by itself prove
that money moved or an invoice was settled.

## Possible meanings
- **A — Intended payment method:** how the invoice is expected to be paid.
- **B — Tax/acquisition classification:** a reporting code rather than payment.
- **C — Actual settlement:** evidence that payment already happened.
- **D — Mixed use:** the meaning depends on the workbook or value.

## What we need from you
Comment **A**, **B**, **C**, or **D**. Please attach one invoice that is paid and
one that is still owed, with their matching register rows if available.

## Recorded decision — maintained by developer
Pending accountant confirmation.
```

**Repository provenance:** D-05 in
[business rules](../schema/03-business-rules.md) and the purchase migration
decision in [migration decisions](../schema/04-migration-decisions.md).

### DET-05 — Confirm partial and grouped payment behavior

**Recommended setup**

- Item kind: Relationship and policy review
- Statement class: Proposed behavior
- Business area: Finance, accounting, and tax
- Initial status: Draft, then Discuss
- Decision owner: Accountant and payment controller
- Evidence confidence: Meeting statement plus prototype inference

**Copy-ready description**

```markdown
## Why this matters
The ERP must keep the money movement separate from the invoices or other
obligations it settles.

## Current understanding
- One invoice may be settled by several partial payments.
- One bank transfer or cash movement may settle several invoices or obligations.
- Each application records its amount and leaves the remaining balance visible.
- Payment proof belongs to the money movement, not merely to `forma_pago`.

## What we need from you
Comment **Agree**, or correct the bullets. Please give one recent example of a
partial payment or one transfer covering several obligations; if this never
happens, comment **Does not occur**.

## Recorded outcome — maintained by developer
Pending.
```

**Repository provenance:** BR-011 in
[business rules](../schema/03-business-rules.md) and the payment requirements in
[source assessment](../schema/01-source-assessment.md).

### DET-06 — Decide how a purchase is allocated to project cost

**Recommended setup**

- Item kind: Business decision
- Statement class: Uncertainty
- Business area: Projects and contracts; Procurement and supplier obligations;
  Finance, accounting, and tax
- Initial status: Draft, then Discuss
- Decision owner: Accountant with project-cost owner
- Evidence confidence: Direct source structure, policy unknown

**Copy-ready description**

```markdown
## Decision needed
When an invoice belongs to one or more projects, the ERP needs an approved basis
for the amount distributed to project cost.

## Options to discuss
- **A — Taxable/base amount**
- **B — Gross invoice total**
- **C — Another accounting amount**, such as base plus only non-recoverable tax

The final rule may vary by tax treatment, but it must reconcile to a clearly
defined invoice amount.

## What we need from you
Choose **A**, **B**, or **C**, or ask for a short accountant review. Also confirm
whether an unassigned amount may stay in overhead temporarily and who must later
allocate it.

## Recorded decision — maintained by developer
Pending accounting policy.
```

**Repository provenance:** cross-row validations and D-08 in
[business rules](../schema/03-business-rules.md), plus RF-07 in
[source assessment](../schema/01-source-assessment.md).

## Wave 3 — resolve high-risk document rules

### DET-07 — Decide how duplicate, corrected, and void NCFs are handled

**Recommended setup**

- Item kind: Business decision
- Statement class: Uncertainty
- Business area: Procurement and supplier obligations; Finance, accounting, and
  tax; Data migration and evidence
- Initial status: Draft, then Evidence Needed
- Decision owner: Accountant
- Evidence confidence: Direct workbooks and extraction audit

**Copy-ready description**

```markdown
## Why this matters
The source contains repeated supplier-and-NCF combinations, including copies and
records that disagree on dates, amounts, or projects. Automatically choosing one
could corrupt tax and accounting history.

## Current proposal
- A non-void supplier NCF is normally unique for the operating company.
- Conflicts stay in review; no row silently overwrites another.
- Corrections, modified NCFs, and voids preserve their relationship and history.

## What we need from you
Please attach or identify one real corrected/voided purchase example and confirm
who may resolve an NCF conflict. Comment **No known example** if necessary.

## Recorded outcome — maintained by developer
Pending evidence and accountant policy.
```

**Repository provenance:** RF-03/RF-04 in
[source assessment](../schema/01-source-assessment.md), BR-010 and D-03 in
[business rules](../schema/03-business-rules.md).

### DET-08 — Clarify what a `cubicacion` represents and how it is approved

**Recommended setup**

- Item kind: Terminology
- Statement class: Uncertainty
- Business area: Work delivery and capacity; Client commercial and billing
- Initial status: Draft, then Discuss
- Decision owner: Project/operations owner with accountant
- Evidence confidence: Indirect extraction plus meeting statements

**Preparation before client review**

Attach one sanitized contractor example and, if available, one client progress
certification. Do not ask the client to interpret the entire extracted dataset.

**Copy-ready description**

```markdown
## Term to clarify
**Cubicacion**

## Current interpretations
- **A — Contractor claim:** work performed by a contractor that may become
  payable after review and approval.
- **B — Client progress certification:** work certified for client billing.
- **C — Payroll support:** measured work used to calculate worker pay.

These may be separate documents even when the company uses the same word.

## What we need from you
Label each attached example **A**, **B**, or **C**, and name who prepares,
reviews, approves, and authorizes payment or billing for it.

## Recorded vocabulary — maintained by developer
Pending.
```

**Repository provenance:** contractor/client distinction in
[requirements plan](../schema/05-requirements-plan.md) and extracted claim
coverage in [source assessment](../schema/01-source-assessment.md).

### DET-09 — Clarify the two-percent contractor deduction

**Recommended setup**

- Item kind: Business decision
- Statement class: Uncertainty
- Business area: Work delivery and capacity; Finance, accounting, and tax
- Initial status: Draft, then Evidence Needed
- Decision owner: Accountant
- Evidence confidence: Indirect extraction with reconciliation conflicts

**Copy-ready description**

```markdown
## What is uncertain
The extracted claims often contain a two-percent amount, usually written with a
negative sign. The source does not establish its legal meaning, calculation
base, eligible parties, rounding, reporting, or exceptions.

## What we need from you
Please attach one approved claim where the two-percent amount applies and one
where it does not, if both exist. The accountant should identify the deduction
type and calculation base.

That is all required; the developer will replay the proposed formula with the
examples before recording a rule.

## Recorded result — maintained by developer
Pending evidence and accountant confirmation.
```

**Repository provenance:** RF-10 in
[source assessment](../schema/01-source-assessment.md), BR-008 and D-04 in
[business rules](../schema/03-business-rules.md).

## Next batch candidates—not active yet

Do not create these merely to make the backlog look complete. Promote them when
an owner and a focused question are ready:

- decide worker/employee/contractor-crew relationships and payroll periods;
- establish role-based access, especially client read access;
- define the client contract-to-approval-to-billing lifecycle;
- approve the 606 field mapping and freeze/correction process;
- define budget/APU ownership, units, and version approval;
- define accounting posting, closing, and reversal policy; and
- decide whether fleet is first release, later, or outside this ERP.
