-- ---------------------------------------------------------------------------
-- Supplier invoices and contractor progress claims remain separate source
-- domains. They are unified only in reporting and accounting views.
-- ---------------------------------------------------------------------------

create table procurement.purchase_invoice (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    supplier_party_id uuid not null references core.party(id),
    supplier_site_id uuid references core.site(id),
    supplier_invoice_number text,
    ncf text,
    modified_ncf text,
    issued_on date not null,
    due_on date,
    reported_payment_method text check (reported_payment_method in (
        'CASH', 'CHECK_TRANSFER_DEPOSIT', 'CARD', 'CREDIT', 'SWAP', 'CREDIT_NOTE', 'MIXED', 'OTHER'
    )),
    currency_code char(3) not null default 'DOP',
    goods_subtotal core.money_amount,
    services_subtotal core.money_amount,
    subtotal core.money_amount not null,
    tax_total core.money_amount not null default 0,
    other_charges_total core.money_amount not null default 0,
    gross_total core.money_amount not null,
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'VALIDATED', 'POSTED', 'PARTIALLY_PAID', 'PAID', 'VOID', 'DISPUTED')),
    review_status text not null default 'PROVISIONAL'
        check (review_status in ('PROVISIONAL', 'VERIFIED', 'EXCEPTION_ACCEPTED')),
    source_document_id uuid references files.document(id),
    source_record_id uuid references staging.source_record(id),
    created_at timestamptz not null default now(),
    check (due_on is null or due_on >= issued_on)
);

create unique index purchase_invoice_ncf_uidx
    on procurement.purchase_invoice (legal_entity_id, supplier_party_id, upper(ncf))
    where ncf is not null and status <> 'VOID';

create table procurement.purchase_invoice_line (
    id uuid primary key default gen_random_uuid(),
    purchase_invoice_id uuid not null references procurement.purchase_invoice(id) on delete cascade,
    line_number integer not null check (line_number > 0),
    resource_id uuid references catalog.resource(id),
    description_snapshot text not null,
    quantity core.quantity_value,
    uom_code text references catalog.unit_of_measure(code),
    unit_price core.unit_rate,
    line_subtotal core.money_amount not null,
    source_record_id uuid references staging.source_record(id),
    unique (purchase_invoice_id, line_number),
    unique (id, purchase_invoice_id)
);

create table procurement.purchase_invoice_tax (
    id uuid primary key default gen_random_uuid(),
    purchase_invoice_id uuid not null references procurement.purchase_invoice(id) on delete cascade,
    tax_type text not null check (tax_type in (
        'ITBIS_INVOICED', 'ITBIS_WITHHELD', 'ISR_WITHHELD', 'ISC',
        'LEGAL_TIP', 'OTHER_TAX', 'OTHER_FEE'
    )),
    rate numeric(9, 6),
    taxable_base core.money_amount,
    amount core.money_amount not null,
    unique (purchase_invoice_id, tax_type, rate)
);

create table procurement.purchase_cost_allocation (
    id uuid primary key default gen_random_uuid(),
    purchase_invoice_id uuid not null references procurement.purchase_invoice(id) on delete cascade,
    purchase_invoice_line_id uuid,
    cost_center_id uuid not null references projects.cost_center(id),
    amount core.money_amount not null check (amount > 0),
    notes text,
    foreign key (purchase_invoice_line_id, purchase_invoice_id)
        references procurement.purchase_invoice_line(id, purchase_invoice_id),
    unique nulls not distinct (purchase_invoice_id, purchase_invoice_line_id, cost_center_id)
);

create table procurement.contractor_claim (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    project_id uuid not null references projects.project(id),
    contractor_party_id uuid not null references core.party(id),
    progress_measurement_id uuid references projects.progress_measurement(id),
    claim_number text,
    claim_date date not null,
    date_precision text not null default 'EXACT'
        check (date_precision in ('EXACT', 'MONTH_ESTIMATE', 'YEAR_ESTIMATE')),
    period_start date,
    period_end date,
    currency_code char(3) not null default 'DOP',
    gross_amount core.money_amount,
    deductions_total core.money_amount not null default 0,
    net_due core.money_amount,
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'SUBMITTED', 'APPROVED', 'PARTIALLY_PAID', 'PAID', 'REJECTED', 'VOID')),
    review_status text not null default 'PROVISIONAL'
        check (review_status in ('PROVISIONAL', 'VERIFIED', 'EXCEPTION_ACCEPTED')),
    source_document_id uuid references files.document(id),
    source_record_id uuid references staging.source_record(id),
    created_at timestamptz not null default now(),
    check (period_end is null or period_start is null or period_end >= period_start)
);

create table procurement.contractor_claim_line (
    id uuid primary key default gen_random_uuid(),
    contractor_claim_id uuid not null references procurement.contractor_claim(id) on delete cascade,
    line_number integer not null check (line_number > 0),
    item_code_snapshot text,
    section_snapshot text,
    work_item_id uuid references projects.work_item(id),
    description_snapshot text not null,
    quantity core.quantity_value,
    uom_code text references catalog.unit_of_measure(code),
    unit_rate core.unit_rate,
    line_total core.money_amount,
    source_record_id uuid references staging.source_record(id),
    unique (contractor_claim_id, line_number)
);

create table procurement.contractor_claim_deduction (
    id uuid primary key default gen_random_uuid(),
    contractor_claim_id uuid not null references procurement.contractor_claim(id) on delete cascade,
    deduction_type text not null check (deduction_type in (
        'ISR_WITHHOLDING', 'ITBIS_WITHHOLDING', 'RETAINAGE',
        'ADVANCE_RECOVERY', 'PENALTY', 'OTHER'
    )),
    rate numeric(9, 6),
    amount core.money_amount not null check (amount >= 0),
    notes text
);

