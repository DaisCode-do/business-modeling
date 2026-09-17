-- ---------------------------------------------------------------------------
-- Budgets, versions, additions/change orders, and client approvals
-- ---------------------------------------------------------------------------

create table projects.budget (
    id uuid primary key default gen_random_uuid(),
    project_id uuid not null references projects.project(id),
    code text not null,
    name text not null,
    currency_code char(3) not null default 'DOP',
    unique (project_id, code)
);

create table projects.budget_version (
    id uuid primary key default gen_random_uuid(),
    budget_id uuid not null references projects.budget(id),
    version_number integer not null check (version_number > 0),
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'SUBMITTED', 'APPROVED', 'REJECTED', 'SUPERSEDED')),
    submitted_at timestamptz,
    approved_total core.money_amount,
    created_by_user_id uuid references iam.app_user(id),
    created_at timestamptz not null default now(),
    unique (budget_id, version_number)
);

create table projects.budget_line (
    id uuid primary key default gen_random_uuid(),
    budget_version_id uuid not null references projects.budget_version(id) on delete cascade,
    parent_line_id uuid references projects.budget_line(id),
    work_item_id uuid references projects.work_item(id),
    line_number integer not null check (line_number > 0),
    code text,
    line_type text not null default 'ITEM' check (line_type in ('SECTION', 'ITEM')),
    description text not null,
    quantity core.quantity_value,
    uom_code text references catalog.unit_of_measure(code),
    unit_price core.unit_rate,
    line_total core.money_amount,
    cost_analysis_version_id uuid references catalog.cost_analysis_version(id),
    unique (budget_version_id, line_number),
    check (parent_line_id is null or parent_line_id <> id),
    check (line_type = 'SECTION' or (quantity is not null and uom_code is not null and unit_price is not null))
);

create table projects.budget_approval (
    id uuid primary key default gen_random_uuid(),
    budget_version_id uuid not null references projects.budget_version(id),
    client_party_id uuid not null references core.party(id),
    decision text not null check (decision in ('PENDING', 'APPROVED', 'REJECTED')),
    requested_at timestamptz not null default now(),
    decided_at timestamptz,
    evidence_document_id uuid references files.document(id),
    comments text,
    unique (budget_version_id, client_party_id),
    check ((decision = 'PENDING') = (decided_at is null))
);

create table projects.change_order (
    id uuid primary key default gen_random_uuid(),
    project_id uuid not null references projects.project(id),
    budget_id uuid not null references projects.budget(id),
    code text not null,
    title text not null,
    reason text,
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'SUBMITTED', 'APPROVED', 'REJECTED', 'CANCELLED')),
    cashflow_treatment text not null default 'UNDECIDED'
        check (cashflow_treatment in ('UNDECIDED', 'SEPARATE_PLAN', 'MERGE_ACTIVE_PLAN')),
    submitted_at timestamptz,
    approved_at timestamptz,
    created_at timestamptz not null default now(),
    unique (project_id, code)
);

create table projects.change_order_line (
    id uuid primary key default gen_random_uuid(),
    change_order_id uuid not null references projects.change_order(id) on delete cascade,
    affected_budget_line_id uuid references projects.budget_line(id),
    line_number integer not null check (line_number > 0),
    description text not null,
    quantity_delta core.quantity_value,
    uom_code text references catalog.unit_of_measure(code),
    unit_price core.unit_rate,
    amount_delta core.money_amount not null,
    unique (change_order_id, line_number)
);

create table projects.change_order_approval (
    id uuid primary key default gen_random_uuid(),
    change_order_id uuid not null references projects.change_order(id),
    client_party_id uuid not null references core.party(id),
    decision text not null check (decision in ('PENDING', 'APPROVED', 'REJECTED')),
    requested_at timestamptz not null default now(),
    decided_at timestamptz,
    evidence_document_id uuid references files.document(id),
    comments text,
    unique (change_order_id, client_party_id),
    check ((decision = 'PENDING') = (decided_at is null))
);

