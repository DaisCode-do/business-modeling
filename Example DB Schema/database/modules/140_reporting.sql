-- ---------------------------------------------------------------------------
-- Cross-module audit and reporting
-- ---------------------------------------------------------------------------

create table iam.audit_event (
    id bigint generated always as identity primary key,
    occurred_at timestamptz not null default now(),
    user_id uuid references iam.app_user(id),
    action text not null,
    entity_type text not null,
    entity_id uuid,
    before_data jsonb,
    after_data jsonb,
    request_id uuid,
    ip_address inet
);

create view reporting.project_cost_event as
select
    'PURCHASE_INVOICE'::text as cost_source,
    pi.id as source_id,
    pi.issued_on as event_date,
    cc.project_id,
    pca.cost_center_id,
    pi.supplier_party_id as counterparty_party_id,
    pca.amount as gross_cost,
    pi.currency_code,
    pi.review_status
from procurement.purchase_cost_allocation pca
join procurement.purchase_invoice pi on pi.id = pca.purchase_invoice_id
join projects.cost_center cc on cc.id = pca.cost_center_id
union all
select
    'CONTRACTOR_CLAIM',
    c.id,
    c.claim_date,
    c.project_id,
    null::uuid,
    c.contractor_party_id,
    c.gross_amount,
    c.currency_code,
    c.review_status
from procurement.contractor_claim c
union all
select
    'PAYROLL_ENTRY',
    pe.id,
    pr.period_end,
    pe.project_id,
    pe.cost_center_id,
    pe.worker_party_id,
    pe.gross_amount,
    le.base_currency,
    pe.review_status
from workforce.payroll_entry pe
join workforce.payroll_run pr on pr.id = pe.payroll_run_id
join core.legal_entity le on le.id = pr.legal_entity_id;

create index party_display_name_idx on core.party (lower(display_name));
create index party_alias_normalized_idx on core.party_alias (normalized_alias);
create index project_alias_normalized_idx on projects.project_alias (normalized_alias);
create index source_record_fingerprint_idx on staging.source_record (raw_fingerprint);
create index purchase_invoice_issued_on_idx on procurement.purchase_invoice (legal_entity_id, issued_on);
create index contractor_claim_project_date_idx on procurement.contractor_claim (project_id, claim_date);
create index payroll_entry_project_idx on workforce.payroll_entry (project_id, payroll_run_id);
create index payment_date_idx on finance.payment (legal_entity_id, payment_date);
create index telemetry_position_time_idx on fleet.telemetry_position (observed_at);

