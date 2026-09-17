-- ---------------------------------------------------------------------------
-- Money movement. A payment receipt is evidence attached to a payment. Payment
-- applications permit one payment to settle or split across multiple concerns.
-- ---------------------------------------------------------------------------

create table finance.financial_account (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    account_type text not null check (account_type in ('CASH', 'BANK', 'CARD', 'OTHER')),
    code text not null,
    name text not null,
    currency_code char(3) not null default 'DOP',
    masked_account_number text,
    active boolean not null default true,
    unique (legal_entity_id, code)
);

create table finance.payment (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    direction text not null check (direction in ('INCOMING', 'OUTGOING')),
    payer_party_id uuid not null references core.party(id),
    payee_party_id uuid not null references core.party(id),
    financial_account_id uuid references finance.financial_account(id),
    payment_date date not null,
    payment_method text not null check (payment_method in (
        'CASH', 'CHECK', 'TRANSFER', 'DEPOSIT', 'CARD', 'SWAP', 'OTHER'
    )),
    reference text,
    receipt_number text,
    receipt_document_id uuid references files.document(id),
    currency_code char(3) not null default 'DOP',
    amount core.money_amount not null check (amount > 0),
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'CONFIRMED', 'RECONCILED', 'VOID')),
    source_record_id uuid references staging.source_record(id),
    created_at timestamptz not null default now(),
    check (payer_party_id <> payee_party_id)
);

create table finance.purchase_invoice_payment (
    payment_id uuid not null references finance.payment(id),
    purchase_invoice_id uuid not null references procurement.purchase_invoice(id),
    applied_amount core.money_amount not null check (applied_amount > 0),
    primary key (payment_id, purchase_invoice_id)
);

create table finance.contractor_claim_payment (
    payment_id uuid not null references finance.payment(id),
    contractor_claim_id uuid not null references procurement.contractor_claim(id),
    applied_amount core.money_amount not null check (applied_amount > 0),
    primary key (payment_id, contractor_claim_id)
);

create table finance.payroll_entry_payment (
    payment_id uuid not null references finance.payment(id),
    payroll_entry_id uuid not null references workforce.payroll_entry(id),
    applied_amount core.money_amount not null check (applied_amount > 0),
    primary key (payment_id, payroll_entry_id)
);

create table finance.sales_invoice_payment (
    payment_id uuid not null references finance.payment(id),
    sales_invoice_id uuid not null references billing.sales_invoice(id),
    applied_amount core.money_amount not null check (applied_amount > 0),
    primary key (payment_id, sales_invoice_id)
);

