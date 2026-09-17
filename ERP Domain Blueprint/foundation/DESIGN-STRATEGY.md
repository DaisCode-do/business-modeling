# Design Strategy

## Intention

This blueprint is designed to become a stable business reference for an
ERP.

## Core approach

### 1. Model workflows before features

A business workflow explains why work begins, who participates, what decisions
are made, what records are produced, and when the work is complete. It remains
useful even when the eventual software changes.

Features, screens, and automation are intentionally deferred. A workflow can be
manual, partially supported, or automated without changing its business purpose.

### 2. Use one shared business language

Terms are defined once in the glossary and reused throughout the documents. A
term should not acquire a second meaning merely because another department uses
it. When the business genuinely has two meanings, the model gives them different
names.

### 3. Separate domain areas without isolating them

Each domain is documented separately because each has its own language and responsibilities.
End-to-end workflows cross those boundaries and show how the institution works as one operation.

These areas are documentation boundaries, not predetermined software services or
databases.

### 4. Preserve history through relationships

Important business facts belong to dated relationships rather than being reduced
to mutable attributes on a person. This allows the documentation to explain change
over time without overwriting the past.

### 5. Keep policy distinguishable from vocabulary

A definition explains what something is. A policy explains what is allowed or
required. A workflow explains what happens. Keeping these separate makes it
possible to change a policy without redefining the underlying concept.

## Influence from established systems

This structure borrows useful patterns from real products without treating any
of them as the model:

- Odoo separates accounting, employees, planning, documents, and access control
  into cooperating application areas. This supports a modular business map rather
  than one undifferentiated “management” domain.
- Odoo and ERPNext distinguish invoices, payments, allocation, and bank
  reconciliation. This supports modeling the obligation to pay separately from
  the movement and confirmation of money.

The corresponding official sources and the limited lessons taken from them are
listed in [References](../discovery/REFERENCES.md).

## What this strategy excludes

This blueprint does not decide:

- what the application interface looks like;
- which technical architecture or database is used;
- which workflows are automated first;
- how integrations are implemented;
- the exact authorization mechanism; or
- the product release plan.

It may identify business access responsibilities or external-system boundaries
where those are intrinsic to the domain. Their software implementation belongs
elsewhere.

## Quality standard for a mature section

A domain section is mature enough to support later requirements work when:

- its important terms have one agreed meaning;
- its concepts have identifiers, relationships, and lifecycles where relevant;
- its normal workflows and meaningful exceptions are described;
- its business decisions and unresolved questions are visible;
- its dependence on external systems is explicit; and
- a reader can follow the work without relying on undocumented institutional
  knowledge.
