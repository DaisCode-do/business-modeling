-- ---------------------------------------------------------------------------
-- Projects, stakeholders, cost centers, work breakdown, and progress
-- ---------------------------------------------------------------------------

create table projects.project (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    code text not null,
    name text not null,
    description text,
    status text not null default 'PROPOSED'
        check (status in ('PROPOSED', 'ACTIVE', 'ON_HOLD', 'COMPLETED', 'CANCELLED')),
    planned_start_date date,
    planned_end_date date,
    actual_start_date date,
    actual_end_date date,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    unique (legal_entity_id, code),
    check (planned_end_date is null or planned_start_date is null or planned_end_date >= planned_start_date),
    check (actual_end_date is null or actual_start_date is null or actual_end_date >= actual_start_date)
);

alter table iam.app_user_role
    add constraint app_user_role_project_fk
    foreign key (project_id) references projects.project(id);

create table projects.project_alias (
    id uuid primary key default gen_random_uuid(),
    project_id uuid not null references projects.project(id),
    raw_alias text not null,
    normalized_alias text not null,
    source_context text,
    approved boolean not null default false,
    created_at timestamptz not null default now(),
    unique (project_id, normalized_alias)
);

create table projects.project_site (
    project_id uuid not null references projects.project(id) on delete cascade,
    site_id uuid not null references core.site(id),
    site_role text not null default 'PRIMARY'
        check (site_role in ('PRIMARY', 'STAGING', 'STORAGE', 'OTHER')),
    primary key (project_id, site_id, site_role)
);

create table projects.project_party (
    project_id uuid not null references projects.project(id) on delete cascade,
    party_id uuid not null references core.party(id),
    project_role text not null check (project_role in (
        'CLIENT', 'OWNER', 'CONTACT', 'PARTNER', 'PROJECT_MANAGER', 'SUPERVISOR'
    )),
    is_primary boolean not null default false,
    valid_from date,
    valid_to date,
    notes text,
    primary key (project_id, party_id, project_role),
    check (valid_to is null or valid_from is null or valid_to >= valid_from)
);

create table projects.cost_center (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    project_id uuid references projects.project(id),
    code text not null,
    name text not null,
    cost_center_type text not null check (cost_center_type in (
        'PROJECT', 'GENERAL_OVERHEAD', 'WORKSHOP', 'FLEET', 'UNALLOCATED'
    )),
    active boolean not null default true,
    unique (legal_entity_id, code),
    check ((cost_center_type = 'PROJECT') = (project_id is not null))
);

create table catalog.unit_of_measure (
    code text primary key,
    name text not null,
    dimension text not null check (dimension in (
        'COUNT', 'LENGTH', 'AREA', 'VOLUME', 'MASS', 'TIME', 'CURRENCY', 'OTHER'
    )),
    decimal_scale smallint not null default 2 check (decimal_scale between 0 and 6),
    active boolean not null default true
);

insert into catalog.unit_of_measure (code, name, dimension, decimal_scale) values
    ('UND', 'Unit', 'COUNT', 2),
    ('DIA', 'Day', 'TIME', 2),
    ('HORA', 'Hour', 'TIME', 2),
    ('M', 'Meter', 'LENGTH', 3),
    ('M2', 'Square meter', 'AREA', 3),
    ('M3', 'Cubic meter', 'VOLUME', 3),
    ('KG', 'Kilogram', 'MASS', 3),
    ('PA', 'Lump sum', 'OTHER', 2);

create table projects.work_item (
    id uuid primary key default gen_random_uuid(),
    project_id uuid not null references projects.project(id) on delete cascade,
    parent_work_item_id uuid references projects.work_item(id),
    code text not null,
    name text not null,
    description text,
    default_uom_code text references catalog.unit_of_measure(code),
    planned_quantity core.quantity_value,
    status text not null default 'PLANNED'
        check (status in ('PLANNED', 'READY', 'IN_PROGRESS', 'BLOCKED', 'DONE', 'CANCELLED')),
    unique (project_id, code),
    check (parent_work_item_id is null or parent_work_item_id <> id)
);

create table projects.schedule_activity (
    id uuid primary key default gen_random_uuid(),
    project_id uuid not null references projects.project(id) on delete cascade,
    work_item_id uuid references projects.work_item(id),
    code text not null,
    name text not null,
    planned_start_date date,
    planned_end_date date,
    actual_start_date date,
    actual_end_date date,
    percent_complete numeric(7, 4) not null default 0 check (percent_complete between 0 and 100),
    status text not null default 'PLANNED'
        check (status in ('PLANNED', 'IN_PROGRESS', 'BLOCKED', 'DONE', 'CANCELLED')),
    unique (project_id, code),
    check (planned_end_date is null or planned_start_date is null or planned_end_date >= planned_start_date),
    check (actual_end_date is null or actual_start_date is null or actual_end_date >= actual_start_date)
);

create table projects.activity_dependency (
    predecessor_activity_id uuid not null references projects.schedule_activity(id),
    successor_activity_id uuid not null references projects.schedule_activity(id),
    dependency_type text not null default 'FINISH_TO_START'
        check (dependency_type in ('FINISH_TO_START', 'START_TO_START', 'FINISH_TO_FINISH', 'START_TO_FINISH')),
    lag_days integer not null default 0,
    primary key (predecessor_activity_id, successor_activity_id),
    check (predecessor_activity_id <> successor_activity_id)
);

create table projects.progress_measurement (
    id uuid primary key default gen_random_uuid(),
    project_id uuid not null references projects.project(id),
    report_number text,
    period_start date,
    period_end date,
    measured_on date not null,
    measured_by_party_id uuid references core.party(id),
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'SUBMITTED', 'APPROVED', 'REJECTED', 'SUPERSEDED')),
    notes text,
    source_document_id uuid references files.document(id),
    created_at timestamptz not null default now(),
    check (period_end is null or period_start is null or period_end >= period_start)
);

create table projects.progress_measurement_line (
    id uuid primary key default gen_random_uuid(),
    progress_measurement_id uuid not null references projects.progress_measurement(id) on delete cascade,
    work_item_id uuid not null references projects.work_item(id),
    previous_quantity core.quantity_value not null default 0,
    current_quantity core.quantity_value not null default 0,
    cumulative_quantity core.quantity_value not null default 0,
    percent_complete numeric(7, 4) check (percent_complete between 0 and 100),
    accepted_amount core.money_amount,
    notes text,
    unique (progress_measurement_id, work_item_id)
);

create table files.project_document (
    project_id uuid not null references projects.project(id),
    document_id uuid not null references files.document(id),
    purpose text,
    primary key (project_id, document_id)
);

