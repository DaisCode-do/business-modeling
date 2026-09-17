-- ---------------------------------------------------------------------------
-- Workforce engagements and payroll
-- ---------------------------------------------------------------------------

create table workforce.position (
    code text primary key,
    name text not null unique,
    active boolean not null default true
);

create table workforce.engagement (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    worker_party_id uuid not null references core.party(id),
    engagement_type text not null check (engagement_type in (
        'ADMIN_EMPLOYEE', 'WORKSHOP_EMPLOYEE', 'PROJECT_DAY_LABOR', 'CONTRACTOR_CREW'
    )),
    contractor_supervisor_party_id uuid references core.party(id),
    default_position_code text references workforce.position(code),
    start_date date,
    end_date date,
    default_day_rate core.unit_rate,
    status text not null default 'ACTIVE'
        check (status in ('ACTIVE', 'INACTIVE', 'PENDING_REVIEW')),
    unique (legal_entity_id, worker_party_id, engagement_type, start_date),
    check (end_date is null or start_date is null or end_date >= start_date)
);

create table workforce.payroll_run (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    run_code text not null,
    period_start date not null,
    period_end date not null,
    date_precision text not null default 'EXACT'
        check (date_precision in ('EXACT', 'MONTH_ONLY')),
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'CALCULATED', 'APPROVED', 'POSTED', 'VOID')),
    source_document_id uuid references files.document(id),
    created_at timestamptz not null default now(),
    unique (legal_entity_id, run_code),
    check (period_end >= period_start)
);

create table workforce.payroll_entry (
    id uuid primary key default gen_random_uuid(),
    payroll_run_id uuid not null references workforce.payroll_run(id) on delete cascade,
    engagement_id uuid references workforce.engagement(id),
    worker_party_id uuid not null references core.party(id),
    contractor_supervisor_party_id uuid references core.party(id),
    project_id uuid references projects.project(id),
    cost_center_id uuid not null references projects.cost_center(id),
    position_code text references workforce.position(code),
    days_worked core.quantity_value,
    day_rate core.unit_rate,
    gross_amount core.money_amount,
    deductions_total core.money_amount not null default 0,
    net_amount core.money_amount,
    review_status text not null default 'PROVISIONAL'
        check (review_status in ('PROVISIONAL', 'VERIFIED', 'EXCEPTION_ACCEPTED')),
    source_record_id uuid references staging.source_record(id),
    created_at timestamptz not null default now()
);

create table workforce.payroll_deduction (
    id uuid primary key default gen_random_uuid(),
    payroll_entry_id uuid not null references workforce.payroll_entry(id) on delete cascade,
    deduction_type text not null check (deduction_type in (
        'ISR_WITHHOLDING', 'SOCIAL_SECURITY', 'ADVANCE_RECOVERY', 'LOAN', 'OTHER'
    )),
    rate numeric(9, 6),
    amount core.money_amount not null check (amount >= 0),
    notes text
);

