# Sources and Design References

These references support discovery and comparison. They are not imported as
Constructora Angote policy. Every external pattern must be validated against the
company's actual work before adoption.

## Constructora source material

- Private operational material under `EVIDENCE/`.
- [Evidence source assessment](<../../Example DB Schema/docs/schema/01-source-assessment.md>).
- [Earlier canonical-model hypothesis](<../../Example DB Schema/docs/schema/02-canonical-model.md>).
- [Earlier business-rule hypotheses](<../../Example DB Schema/docs/schema/03-business-rules.md>).
- [Migration findings](<../../Example DB Schema/docs/schema/04-migration-decisions.md>).
- [Interactive database prototype](<../../Example DB Schema/docs/erd/index.html>).

## ERPNext

- [ERPNext Payment Entry](https://docs.frappe.io/erpnext/payment-entry) — distinguishes a payment from the invoice or other obligation to which it is allocated and supports advances and later reconciliation.

### Odoo

- [Accounting and Invoicing](https://www.odoo.com/documentation/19.0/applications/finance/accounting.html) — demonstrates separate but connected invoicing, payments, bank accounts, reconciliation, and reporting areas.
- [Payments](https://www.odoo.com/documentation/19.0/applications/finance/accounting/payments/online.html) — demonstrates linked and stand-alone payments, partial settlement, and outstanding credit.
- [Bank Reconciliation](https://www.odoo.com/documentation/19.0/applications/finance/accounting/bank/reconciliation.html) — demonstrates matching bank transactions to invoices, bills, payments, or adjustments.
- [Employees](https://www.odoo.com/documentation/19.0/applications/hr/employees.html) — demonstrates a dedicated personnel area that cooperates with attendance and planning.
- [Documents](https://www.odoo.com/documentation/19.0/applications/productivity/documents.html) — demonstrates managed document organization and access while associating files with accounting and employee work.
- [Users and access rights](https://www.odoo.com/documentation/19.0/applications/general/users.html) — demonstrates that application access is distinct from the business identity represented by other records.

These references influenced the modular domain map and financial distinctions.
They do not imply that Constructora Angote should adopt Odoo terminology, workflows, or
software.

## Reference-use policy

- Prefer operational evidence from the company when defining its actual business.
- Use existing products to discover distinctions and questions, not to settle
  policy automatically.
- Record an adopted choice in the decision log before presenting a borrowed
  pattern as part of the final domain.
- Link external documentation rather than reproducing vendor content.
