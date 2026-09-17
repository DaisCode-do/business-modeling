-- ---------------------------------------------------------------------------
-- Client contracts, cash-flow plans, progress certificates, and sales invoices
-- ---------------------------------------------------------------------------

create table billing.client_contract (
    id uuid primary key default gen_random_uuid(),
    project_id uuid not null references projects.project(id),
    client_party_id uuid not null references core.party(id),
    contract_number text,
    billing_method text not null check (billing_method in (
        'CASH_FLOW', 'PHYSICAL_PROGRESS', 'MIXED'
    )),
    currency_code char(3) not null default 'DOP',
    original_amount core.money_amount,
    signed_on date,
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'ACTIVE', 'SUSPENDED', 'COMPLETED', 'TERMINATED')),
    contract_document_id uuid references files.document(id),
    unique nulls not distinct (project_id, client_party_id, contract_number)
);

create table billing.payment_plan (
    id uuid primary key default gen_random_uuid(),
    client_contract_id uuid not null references billing.client_contract(id),
    change_order_id uuid references projects.change_order(id),
    version_number integer not null check (version_number > 0),
    plan_type text not null check (plan_type in ('CASH_FLOW', 'PROGRESS_BASED')),
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'ACTIVE', 'SUPERSEDED', 'COMPLETED')),
    created_at timestamptz not null default now(),
    unique nulls not distinct (client_contract_id, change_order_id, version_number)
);

create table billing.payment_plan_installment (
    id uuid primary key default gen_random_uuid(),
    payment_plan_id uuid not null references billing.payment_plan(id) on delete cascade,
    sequence_number integer not null check (sequence_number > 0),
    due_on date,
    trigger_description text,
    percent_of_basis numeric(9, 6) check (percent_of_basis is null or percent_of_basis between 0 and 100),
    amount core.money_amount,
    status text not null default 'PLANNED'
        check (status in ('PLANNED', 'DUE', 'PARTIALLY_INVOICED', 'INVOICED', 'CANCELLED')),
    unique (payment_plan_id, sequence_number),
    check (due_on is not null or trigger_description is not null),
    check (percent_of_basis is not null or amount is not null)
);

create table billing.client_progress_certificate (
    id uuid primary key default gen_random_uuid(),
    client_contract_id uuid not null references billing.client_contract(id),
    progress_measurement_id uuid not null references projects.progress_measurement(id),
    certificate_number text,
    certified_on date not null,
    gross_amount core.money_amount not null,
    deductions_total core.money_amount not null default 0,
    net_billable core.money_amount not null,
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'SUBMITTED', 'APPROVED', 'REJECTED', 'INVOICED')),
    unique nulls not distinct (client_contract_id, certificate_number)
);

create table billing.sales_invoice (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    project_id uuid references projects.project(id),
    client_party_id uuid not null references core.party(id),
    client_contract_id uuid references billing.client_contract(id),
    client_progress_certificate_id uuid references billing.client_progress_certificate(id),
    invoice_number text not null,
    ncf text,
    ecf_track_id text,
    issued_on date not null,
    due_on date,
    currency_code char(3) not null default 'DOP',
    subtotal core.money_amount not null,
    tax_total core.money_amount not null default 0,
    gross_total core.money_amount not null,
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'ISSUED', 'ACCEPTED_DGII', 'REJECTED_DGII', 'PARTIALLY_PAID', 'PAID', 'VOID')),
    source_document_id uuid references files.document(id),
    created_at timestamptz not null default now(),
    unique (legal_entity_id, invoice_number),
    check (due_on is null or due_on >= issued_on)
);

create unique index sales_invoice_ncf_uidx
    on billing.sales_invoice (legal_entity_id, upper(ncf))
    where ncf is not null and status <> 'VOID';

create table billing.sales_invoice_line (
    id uuid primary key default gen_random_uuid(),
    sales_invoice_id uuid not null references billing.sales_invoice(id) on delete cascade,
    line_number integer not null check (line_number > 0),
    work_item_id uuid references projects.work_item(id),
    change_order_line_id uuid references projects.change_order_line(id),
    description_snapshot text not null,
    quantity core.quantity_value,
    uom_code text references catalog.unit_of_measure(code),
    unit_price core.unit_rate,
    line_total core.money_amount not null,
    unique (sales_invoice_id, line_number)
);

