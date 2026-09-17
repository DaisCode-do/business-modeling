# Migration decisions

This document maps the supplied extraction outputs to the canonical prototype.
All inputs first enter `staging`; “destination” means the eventual reviewed
destination, not a direct CSV import.

## Supplier catalog — `proveedores.csv`

**Destination:** party, organization/person profile, identifier, supplier role,
and approved aliases.

**Disposition:** stage every row. Review identifier/name conflicts before any
canonical creation or merge.

## Supplier contact sheet

**Destination:** supplier sites, contact parties, contact points, and party
relationships.

**Disposition:** treat it as a hierarchical draft. Free-form continuation rows
cannot be loaded as independent flat suppliers.

## Contractor catalog — `contratistas_maestros.csv`

**Destination:** party, contractor role, aliases, and specialties.

**Disposition:** stage it and resolve probable duplicate people before creating
verified master records.

## Worker outputs — `empleados.csv` and `OBREROS.csv`

**Destination:** person party, worker/employee role, position, and engagement.

**Disposition:** ignore the mislabeled contractor copy. Quarantine placeholders.
Merge spelling variants only after review.

## Alleged clients — `Clientes.csv`

**Destination:** none yet.

**Disposition:** do not import it as clients; its contents are a contractor copy,
not client evidence. Build the first client register through interviews and
contract/project evidence.

## Alleged projects — `proyectos.csv`

**Destination:** project-alias candidates and review issues.

**Disposition:** do not treat all 39 rows as projects. Create the authoritative
registry with code, name, site, status, clients/owners, and dates. Explicitly
resolve combined projects, people, locations, placeholders, and `MISC`.

## Purchases — `gastos_606.csv`

**Destination:** purchase invoice, tax rows, and cost allocations.

**Disposition:** use a pinned batch, remove the copied December ingestion through
review, and investigate all reused NCF/identity groups. Do not create a payment
from `forma_pago`.

## Fifty item fields embedded in the purchase output

**Destination:** staging resource or supplier-price candidates only.

**Disposition:** do not attach them to invoices. First locate and understand the
independent lookup table and its broken formulas.

## Contractor claims — `cubicaciones.csv`

**Destination:** contractor claim.

**Disposition:** consider only the latest output, retain date precision, attach
provenance, and never infer “paid” from presence in the sheet.

## Claim details — `cubicacion_partidas.csv`

**Destination:** contractor claim lines.

**Disposition:** preserve snapshot description, unit, quantity, rate, and source
even without catalog links. Reconcile line totals and quarantine ambiguous
headers.

## Payroll — `nomina_detalle.csv`

**Destination:** payroll run, payroll entry, and typed deduction.

**Disposition:** establish the exact period and a reviewed worker identity first.
Do not infer payment or an employment relationship from a normalized name.

## Quarantine outputs

**Destination:** source record and review issue.

**Disposition:** preserve the entire raw payload and reason. A quarantine is a
workflow item, not discarded data.

## Filename, sheet, and row references

**Destination:** stored file, source file, and source record.

**Disposition:** augment them with the full relative path, content hash, sheet,
row/cell range, import batch, and pipeline version. Basename alone is not safe.

## Conditions before a real-data cutover

A production migration specification should wait until the following are
approved:

1. the company's legal identity;
2. the canonical project and alias register;
3. party identity and merge decisions;
4. the authoritative input copy and batch;
5. NCF duplicate/correction policy;
6. contractor and payroll deduction policy;
7. payment evidence and settlement semantics;
8. payroll periods and worker relationships;
9. the accounting/posting policy;
10. the actual product/resource and APU sources.

Until then, dashboards must say **provisional source data** and must not present
combined extracted totals as certified company figures.
