-- ---------------------------------------------------------------------------
-- Products/resources, supplier prices, and analysis of unit prices (APU)
-- ---------------------------------------------------------------------------

create table catalog.resource (
    id uuid primary key default gen_random_uuid(),
    code text not null unique,
    resource_type text not null check (resource_type in (
        'MATERIAL', 'LABOR', 'EQUIPMENT', 'SUBCONTRACT', 'SERVICE', 'OTHER'
    )),
    name text not null,
    description text,
    default_uom_code text not null references catalog.unit_of_measure(code),
    manufacturer text,
    model text,
    active boolean not null default true,
    created_at timestamptz not null default now()
);

create table catalog.resource_alias (
    id uuid primary key default gen_random_uuid(),
    resource_id uuid not null references catalog.resource(id),
    alias_text text not null,
    normalized_alias text not null,
    approved boolean not null default false,
    source_record_id uuid references staging.source_record(id),
    unique (resource_id, normalized_alias)
);

create table catalog.specialty (
    code text primary key,
    name text not null unique,
    active boolean not null default true
);

create table catalog.party_specialty (
    party_id uuid not null references core.party(id),
    specialty_code text not null references catalog.specialty(code),
    proficiency_note text,
    primary key (party_id, specialty_code)
);

create table catalog.supplier_price (
    id uuid primary key default gen_random_uuid(),
    supplier_party_id uuid not null references core.party(id),
    supplier_site_id uuid references core.site(id),
    resource_id uuid not null references catalog.resource(id),
    supplier_sku text,
    supplier_description text,
    uom_code text not null references catalog.unit_of_measure(code),
    unit_price core.unit_rate not null check (unit_price >= 0),
    currency_code char(3) not null default 'DOP',
    quoted_at timestamptz not null,
    valid_from date,
    valid_to date,
    source_document_id uuid references files.document(id),
    source_record_id uuid references staging.source_record(id),
    check (valid_to is null or valid_from is null or valid_to >= valid_from)
);

create table catalog.cost_analysis (
    id uuid primary key default gen_random_uuid(),
    code text not null unique,
    name text not null,
    output_uom_code text not null references catalog.unit_of_measure(code),
    origin_project_id uuid references projects.project(id),
    active boolean not null default true,
    created_at timestamptz not null default now()
);

create table catalog.cost_analysis_version (
    id uuid primary key default gen_random_uuid(),
    cost_analysis_id uuid not null references catalog.cost_analysis(id),
    version_number integer not null check (version_number > 0),
    effective_on date not null,
    status text not null default 'DRAFT'
        check (status in ('DRAFT', 'ACTIVE', 'SUPERSEDED', 'ARCHIVED')),
    total_unit_cost core.unit_rate,
    assumptions text,
    unique (cost_analysis_id, version_number)
);

create table catalog.cost_analysis_component (
    id uuid primary key default gen_random_uuid(),
    cost_analysis_version_id uuid not null references catalog.cost_analysis_version(id) on delete cascade,
    line_number integer not null check (line_number > 0),
    resource_id uuid not null references catalog.resource(id),
    quantity core.quantity_value not null,
    uom_code text not null references catalog.unit_of_measure(code),
    waste_factor numeric(9, 6) not null default 0 check (waste_factor >= 0),
    unit_cost_snapshot core.unit_rate not null,
    component_total core.money_amount,
    unique (cost_analysis_version_id, line_number)
);

