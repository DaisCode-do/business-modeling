# Prototype v0 — schema guide

This guide separates the analysis by the question a reviewer is trying to
answer. It intentionally avoids wide Markdown tables.

## Suggested reading order

1. [Source assessment](01-source-assessment.md) — what was supplied, what is
   reliable, and where the ETL is fragile.
2. [Canonical model](02-canonical-model.md) — which entities exist and why the
   domain boundaries matter.
3. [Business rules](03-business-rules.md) — rules already represented in v0 and
   rules awaiting confirmation.
4. [Migration decisions](04-migration-decisions.md) — how each supplied output
   should be staged, reviewed, or rejected.
5. [Requirements and prototype plan](05-requirements-plan.md) — a practical
   interview, approval, and prototyping sequence.
6. [Frappe boundary](06-frappe-evaluation.md) — the recorded decision to keep
   Frappe outside the architecture and use it only as a possible UI/UX reference.

## Companion artifacts

- [Interactive ERD](../erd/index.html)
- [ERD usage and regeneration notes](../erd/README.md)
- [PostgreSQL schema entry point](../../database/prototype-v0.sql)
- [SQL module guide](../../database/README.md)
- [Jira discovery playbook](../jira/README.md)

## Current decision

Use v0 as a conversation model and prototype baseline. Do not treat it as a
cutover-ready production schema until the open identity, project, payment,
deduction, and accounting decisions are resolved.
