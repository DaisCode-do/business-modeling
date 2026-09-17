-- ---------------------------------------------------------------------------
-- DGII reporting snapshots. The operational purchase invoice is not itself a
-- 606 row; an accepted submission preserves exactly what was reported.
-- ---------------------------------------------------------------------------

create table tax.dgii_submission (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    form_type text not null check (form_type in ('606', '607', '608', '609')),
    reporting_period date not null,
    revision_number integer not null default 1 check (revision_number > 0),
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'VALIDATED', 'SUBMITTED', 'ACCEPTED', 'REJECTED', 'SUPERSEDED')),
    record_count integer check (record_count is null or record_count >= 0),
    submitted_at timestamptz,
    response_document_id uuid references files.document(id),
    created_at timestamptz not null default now(),
    unique (legal_entity_id, form_type, reporting_period, revision_number),
    check (reporting_period = date_trunc('month', reporting_period)::date)
);

create table tax.dgii_606_record (
    id uuid primary key default gen_random_uuid(),
    submission_id uuid not null references tax.dgii_submission(id) on delete cascade,
    purchase_invoice_id uuid not null references procurement.purchase_invoice(id),
    supplier_identifier text not null,
    supplier_identifier_type text not null check (supplier_identifier_type in ('RNC', 'CEDULA')),
    cost_expense_type_code text not null,
    ncf text not null,
    modified_ncf text,
    invoice_date date not null,
    payment_date date,
    services_amount core.money_amount not null default 0,
    goods_amount core.money_amount not null default 0,
    invoiced_amount core.money_amount not null,
    invoiced_itbis core.money_amount not null default 0,
    withheld_itbis core.money_amount not null default 0,
    proportional_itbis core.money_amount not null default 0,
    itbis_carried_to_cost core.money_amount not null default 0,
    deductible_itbis core.money_amount not null default 0,
    perceived_itbis core.money_amount not null default 0,
    income_withholding_type_code text,
    withheld_isr core.money_amount not null default 0,
    perceived_isr core.money_amount not null default 0,
    selective_consumption_tax core.money_amount not null default 0,
    other_taxes_fees core.money_amount not null default 0,
    legal_tip core.money_amount not null default 0,
    payment_method_code text not null,
    record_status text not null default 'PENDING'
        check (record_status in ('PENDING', 'VALID', 'ERROR', 'ACCEPTED')),
    validation_errors jsonb not null default '[]'::jsonb,
    unique (submission_id, purchase_invoice_id)
);

