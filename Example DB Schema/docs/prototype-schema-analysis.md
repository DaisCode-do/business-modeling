# Constructora ERP — prototype schema review

Date: 2026-09-09  
Status: prototype v0, suitable for requirements review  
Database target: PostgreSQL 16+

The first canonical model is ready to use as an interview and explanation aid.
It is a proposed design, not a certification that the imported historical data
is correct.

## Start here

- [Open the interactive ERD](erd/index.html) for a guided, bilingual view of all
  14 domains, 85 tables, one reporting view, and their relationships.
- [Read the schema guide](schema/README.md) for the analysis in short,
  table-free chapters.
- [Open the SQL entry point](../database/prototype-v0.sql) to execute the
  modular PostgreSQL prototype.

## Executive conclusion

It is reasonable to proceed with this schema as the first standardization
prototype. It is not safe to load the supplied CSVs directly as master or
accounting truth.

The evidence is strong enough to establish domain boundaries, document shapes,
relationships, recurring validations, and a review workflow. It is not yet
strong enough to settle canonical identities, authoritative project codes,
actual payment status, or final accounting and tax policy.

The design therefore keeps three things separate:

1. immutable source files and extracted rows;
2. review issues and explicit identity or alias decisions; and
3. canonical master and transaction records.

This is a reimagined base rather than a translation of the fragile ETL layouts.

## Review sequence

1. Use the ERD's **Overview** during the first customer conversation.
2. Follow its **Guided walkthrough** to explain the important distinctions.
3. Open **Entities** only when fields or exact dependencies matter.
4. Record corrections as requirements or decisions; do not edit imported data
   to make it appear consistent.
5. Use the [requirements and prototype plan](schema/05-requirements-plan.md) to
   turn those conversations into approved rules and focused UI prototypes.
