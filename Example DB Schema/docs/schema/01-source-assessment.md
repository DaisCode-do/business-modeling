# Source assessment

## How the evidence was weighted

### Direct accounting workbooks — strongest available evidence

These show the accountant's working purchase register and are the best evidence
for its current columns and workflow. They still do not prove payment, identity,
or complete DGII semantics by themselves.

### Raw extraction outputs and audit logs — useful but indirect

These expose payroll, contractor-claim, project, and identity patterns. Where
the original workbook is absent, an extracted value cannot be verified against
its source cell.

### Curated “database-ready” CSVs — samples, not truth

They help explain the intended mappings, but several are stale, copied,
mislabeled, or more confident than the evidence permits.

### Meeting summaries — candidate requirements

They justify extension points for budgets, APU, client billing, documents,
approvals, and fleet. They do not prove final business rules or existing data.

## Observed coverage

### Accounting material

- Three purchase-register workbooks cover March 2024 through July 2026.
- Thirty operational worksheets were extracted, representing 29 distinct
  reported months because December 2025 appears in both the 2025 and 2026 books.
- The latest audit extracted 1,760 rows: 1,757 valid and three quarantined.
- The usual fields are project, invoice date, supplier, RNC/Cédula, NCF, base
  amount, ITBIS, gross total, and acquisition/payment mode.
- The workbook is an internal expense-invoice distribution register, not a
  complete DGII 606 row.

The 606 design was compared with the
[official DGII field description](https://ayuda.dgii.gov.do/conversations/formatos-de-envo-de-datos/ca3839-cmo-est-compuesto-el-formato-de-compras-de-bienes-y-servicios-606/5f3c17978cd858ce87a1b13d)
and the [DGII format resources](https://dgii.gov.do/publicacionesOficiales/bibliotecaVirtual/contribuyentes/formatoEnvioDatos/Paginas/default.aspx).
The official record additionally needs concepts such as cost/expense
classification, modified NCF, payment date, goods/services split, ITBIS and ISR
details, other taxes, and legal tip. The schema therefore stores an immutable
reporting snapshot separately from the operational invoice.

### Client-findings package

- 347 unique source paths are represented by 730 sheet entries.
- Classification found 382 contractor-claim sheets, 239 payroll sheets, 35
  purchase/606 sheets, 51 other sheets, 17 non-Excel files, and six PDFs beyond
  the ETL scope.
- Original payroll and contractor-claim workbooks are not present in the
  workspace. Only inventory, extracted rows, and audits can be checked.
- Alleged catalogs contain 39 projects, 132 suppliers, 68 contractors, 155
  employees/workers, and four locations.
- Transaction outputs contain 1,757 purchases, a latest set of 243 contractor
  claims with 771 lines, and 1,035 payroll lines.

### Requirements mentioned in meetings

- Multiple projects, project clients/owners/contacts, geospatial sites, and
  client read access.
- Hierarchical budgets, versioned APU, supplier price history, additions,
  explicit client approvals, schedules, physical progress, and S-curves.
- Client billing through a cash-flow plan, certified progress, or a mixture.
- Separate purchases, payroll, and contractor claims with consolidated cost
  reporting.
- Payables, receivables, and partial or full money applications.
- Invoice and receipt images with mandatory review when OCR is uncertain.
- Electronic invoicing and DGII reporting.
- Fleet, driver documents, maintenance, telemetry, and expiry alerts as a
  possible independent extension.

## Reliability findings

### RF-01 — The “database-ready” package is stale

Its README and copied output contain 220 claims, 694 lines, and 67 quarantined
records. The latest output contains 243 claims, 771 lines, and 44 quarantined
records.

**Model consequence:** every migration identifies an immutable import batch and
pipeline version. A folder name cannot act as version control.

### RF-02 — The dashboard and generated report use the stale snapshot

Their KPIs still use 220 claims and RD$7.32M, whereas the later finalization
audit uses 243 claims and RD$8.08M. The report also describes 612 quarantined
payroll rows where the later output has 77.

**Model consequence:** derived analytics are regenerated only from an accepted
import batch. Existing totals, trends, rankings, and project counts remain
provisional.

### RF-03 — December 2025 purchases were ingested twice

Thirty-seven exact semantic duplicates appear across the 2025 and 2026 books,
adding RD$241,777.38. One more copied row becomes a `#VALUE!` quarantine in the
2026 copy.

**Model consequence:** file hashes and business-key duplicate detection are
required before canonical insertion.

### RF-04 — NCF reuse extends beyond that copied sheet

There are 52 repeated supplier-identifier and NCF groups. Some disagree on
dates, values, or project assignment.

**Model consequence:** a canonical, non-void invoice NCF is unique for its legal
entity and supplier. Conflicts stay in review rather than being overwritten.

### RF-05 — Imported RNC identity is unsafe without review

Forty-three identifiers have multiple names and eight have atypical lengths.
Some map to incompatible businesses. RNC `132621468` appears in every workbook
header as the reporting company, but three expense rows assign it to “La Casa
de la Estufa.”

**Model consequence:** identifiers enter as unverified. Global uniqueness only
applies after a person confirms the identity. The company's RNC must be
confirmed before supplier consolidation.

### RF-06 — The 50 alleged invoice items are a separate lookup table

They came from a right-side table on two sheets. Only one price matches the
adjacent invoice gross amount, none matches its base amount, and broken lookup
formulas are visible.

**Model consequence:** do not create invoice lines from these values. Keep them
as quarantined resource or supplier-price candidates until their purpose is
verified.

### RF-07 — The project catalog contains non-projects and aliases

Examples include `MISC`, `EUSEBIO`, `???`, `PROYECTOS`, `L`, a location-like
`LA ESTANCIA`, and a combined `APART. LOS ALTO 2103 & LAS CAÑAS 43`. Probable
aliases remain split, including `LC43`/`#43`, `BOSQ40`/`B#40`/`EB#40`, and
`GC`/`G`/`GCT`.

Only 985 of 1,757 purchases have a resolved project code; 334 of those use
synthetic `MISC`, and ten raw strings remain unresolved. Twelve aliases are
explicitly unapproved.

**Model consequence:** projects come from a human-owned registry. `MISC`
becomes an overhead or unallocated cost center. Similarity may suggest an alias,
but cannot approve one or create a project.

### RF-08 — The alleged client and employee masters are mislabeled

`Clientes.csv` repeats contractor codes `MAE-001..068`, with its populated names
matching the last 25 contractor rows. `Empleados.csv` contains the same copy.

**Model consequence:** neither file creates client or administrative-employee
masters.

### RF-09 — Worker identity was inferred from normalized names

The result includes placeholders such as `PERSONAL`, `PISERO`, `AYUDANTE`, and
`AYUDANTE 1/2`, as well as likely spelling variants.

**Model consequence:** placeholders remain source descriptions, not verified
people. Person creation and merges require review.

### RF-10 — Contractor claims need typed deductions and reconciliation

Twenty-three latest records have three populated totals that differ by more
than RD$1. Most two-percent values use negative signs. Seventy-five headers do
not reconcile to extracted lines, and eleven have no numeric line total.

**Model consequence:** deductions are positive, typed rows. Gross, deductions,
and net are calculated or validated under an approved rule; source signs remain
only in staging.

### RF-11 — Dates have different certainty

Of 243 valid claims, 103 use a month-estimated date. Payroll has only a derived
`YYYY-MM` even when filenames imply a narrower interval.

**Model consequence:** a date or interval always carries precision and
provenance so an estimate cannot masquerade as an exact date.

### RF-12 — Provenance is incomplete in final CSVs

Transaction outputs retain filename, sheet, and row but drop the full relative
path and hash. Four basenames occur in more than one folder.

**Model consequence:** source records point to a hashed stored file plus a full
sheet/row/cell locator. A filename is never an identifier.

### RF-13 — Money contains binary-float artifacts

The results include values such as `6329.0`, long fractional artifacts, and
four-decimal claim calculations.

**Model consequence:** source payloads remain untouched in staging; canonical
money uses decimal types and rounds only under approved document and tax rules.
