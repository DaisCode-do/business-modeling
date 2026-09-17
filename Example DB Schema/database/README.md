# PostgreSQL prototype v0

The executable entry point is [prototype-v0.sql](prototype-v0.sql). It opens one
transaction and includes 15 domain files in dependency order.

Run it from any working directory with:

```sh
psql -v ON_ERROR_STOP=1 -f /absolute/path/to/database/prototype-v0.sql
```

The entry point uses psql's `\ir` command, which resolves each module relative
to the including file.

## Module order

1. `00_foundation.sql` — extensions, schemas, and numeric domains.
2. `10_identity.sql` — people, organizations, identifiers, roles, sites, and
   contacts.
3. `20_access.sql` — application users and permission assignments.
4. `30_evidence.sql` — stored files, documents, imports, and human review.
5. `40_projects.sql` — projects, stakeholders, WBS, schedule, and progress.
6. `50_catalog_apu.sql` — resources, units, prices, specialties, and APU.
7. `60_budgets_changes.sql` — budget versions, approvals, and additions.
8. `70_purchases_claims.sql` — supplier invoices and contractor cubicaciones.
9. `80_workforce.sql` — engagements, payroll, and deductions.
10. `90_client_billing.sql` — contracts, cash-flow plans, client progress, and
    sales invoices.
11. `100_payments.sql` — financial accounts, money movement, and applications.
12. `110_tax.sql` — DGII submission and 606 reporting snapshots.
13. `120_accounting.sql` — periods, chart of accounts, and journals.
14. `130_fleet.sql` — optional asset, driver, maintenance, and telemetry model.
15. `140_reporting.sql` — audit history, cross-domain view, and indexes.

The order is intentional. Later modules may reference entities created earlier.

## Design status

This is a requirements prototype, not a production migration. Cross-row rules
such as balanced journals, allocation totals, overpayment prevention, and
document reconciliation still need confirmed policies and transactional
validation.

See the [schema guide](../docs/schema/README.md) and
[interactive ERD](../docs/erd/index.html) before changing domain boundaries.
