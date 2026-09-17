-- ---------------------------------------------------------------------------
-- Minimal double-entry accounting spine. Source modules remain authoritative;
-- posting rules and the chart of accounts require accountant approval.
-- ---------------------------------------------------------------------------

create table accounting.accounting_period (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    starts_on date not null,
    ends_on date not null,
    status text not null default 'OPEN' check (status in ('OPEN', 'SOFT_CLOSED', 'CLOSED')),
    unique (legal_entity_id, starts_on, ends_on),
    check (ends_on >= starts_on)
);

create table accounting.gl_account (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    parent_account_id uuid references accounting.gl_account(id),
    code text not null,
    name text not null,
    account_type text not null check (account_type in (
        'ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE', 'COST'
    )),
    allows_posting boolean not null default true,
    active boolean not null default true,
    unique (legal_entity_id, code),
    check (parent_account_id is null or parent_account_id <> id)
);

create table accounting.journal_entry (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    accounting_period_id uuid not null references accounting.accounting_period(id),
    entry_number text not null,
    entry_date date not null,
    description text not null,
    source_type text,
    source_id uuid,
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'POSTED', 'REVERSED')),
    posted_at timestamptz,
    created_by_user_id uuid references iam.app_user(id),
    created_at timestamptz not null default now(),
    unique (legal_entity_id, entry_number),
    check ((status = 'POSTED') = (posted_at is not null) or status = 'REVERSED')
);

create table accounting.journal_line (
    id uuid primary key default gen_random_uuid(),
    journal_entry_id uuid not null references accounting.journal_entry(id) on delete cascade,
    line_number integer not null check (line_number > 0),
    gl_account_id uuid not null references accounting.gl_account(id),
    party_id uuid references core.party(id),
    project_id uuid references projects.project(id),
    cost_center_id uuid references projects.cost_center(id),
    description text,
    debit core.money_amount not null default 0 check (debit >= 0),
    credit core.money_amount not null default 0 check (credit >= 0),
    unique (journal_entry_id, line_number),
    check ((debit > 0 and credit = 0) or (credit > 0 and debit = 0))
);

