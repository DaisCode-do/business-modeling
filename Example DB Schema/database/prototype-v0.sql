-- Constructora ERP canonical database prototype v0
-- Target: PostgreSQL 16+
-- Run with: psql -v ON_ERROR_STOP=1 -f database/prototype-v0.sql
-- Module order is intentional because later domains reference earlier ones.

\set ON_ERROR_STOP on

begin;

\ir modules/00_foundation.sql
\ir modules/10_identity.sql
\ir modules/20_access.sql
\ir modules/30_evidence.sql
\ir modules/40_projects.sql
\ir modules/50_catalog_apu.sql
\ir modules/60_budgets_changes.sql
\ir modules/70_purchases_claims.sql
\ir modules/80_workforce.sql
\ir modules/90_client_billing.sql
\ir modules/100_payments.sql
\ir modules/110_tax.sql
\ir modules/120_accounting.sql
\ir modules/130_fleet.sql
\ir modules/140_reporting.sql

commit;
