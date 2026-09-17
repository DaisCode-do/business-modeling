-- ---------------------------------------------------------------------------
-- Fleet extension identified in meeting notes. Kept small and independent.
-- ---------------------------------------------------------------------------

create table fleet.asset (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    cost_center_id uuid references projects.cost_center(id),
    asset_type text not null check (asset_type in ('VEHICLE', 'HEAVY_EQUIPMENT', 'TOOL', 'OTHER')),
    code text not null,
    name text not null,
    acquired_on date,
    acquisition_cost core.money_amount,
    useful_life_months integer check (useful_life_months is null or useful_life_months > 0),
    status text not null default 'ACTIVE'
        check (status in ('ACTIVE', 'MAINTENANCE', 'INACTIVE', 'DISPOSED')),
    unique (legal_entity_id, code)
);

create table fleet.vehicle_profile (
    asset_id uuid primary key references fleet.asset(id) on delete cascade,
    plate_number text,
    vin text,
    make text,
    model text,
    model_year integer,
    odometer_unit text default 'KM' check (odometer_unit in ('KM', 'MI')),
    unique (plate_number),
    unique (vin)
);

create table fleet.asset_document (
    asset_id uuid not null references fleet.asset(id),
    document_id uuid not null references files.document(id),
    document_role text not null check (document_role in (
        'REGISTRATION', 'INSURANCE', 'INSPECTION', 'TITLE', 'LICENSE_COPY', 'OTHER'
    )),
    primary key (asset_id, document_id)
);

create table fleet.driver_assignment (
    id uuid primary key default gen_random_uuid(),
    asset_id uuid not null references fleet.asset(id),
    driver_party_id uuid not null references core.party(id),
    starts_at timestamptz not null,
    ends_at timestamptz,
    check (ends_at is null or ends_at >= starts_at)
);

create table fleet.maintenance_order (
    id uuid primary key default gen_random_uuid(),
    asset_id uuid not null references fleet.asset(id),
    supplier_party_id uuid references core.party(id),
    opened_on date not null,
    completed_on date,
    odometer numeric(18, 2),
    description text not null,
    status text not null default 'OPEN'
        check (status in ('OPEN', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    total_cost core.money_amount,
    source_document_id uuid references files.document(id),
    check (completed_on is null or completed_on >= opened_on)
);

create table fleet.maintenance_line (
    id uuid primary key default gen_random_uuid(),
    maintenance_order_id uuid not null references fleet.maintenance_order(id) on delete cascade,
    line_number integer not null,
    resource_id uuid references catalog.resource(id),
    description text not null,
    quantity core.quantity_value,
    unit_cost core.unit_rate,
    line_total core.money_amount,
    replaced_component_note text,
    unique (maintenance_order_id, line_number)
);

create table fleet.telemetry_position (
    asset_id uuid not null references fleet.asset(id),
    observed_at timestamptz not null,
    latitude numeric(10, 7) not null check (latitude between -90 and 90),
    longitude numeric(10, 7) not null check (longitude between -180 and 180),
    speed_kph numeric(10, 3),
    heading_degrees numeric(6, 3),
    provider_payload jsonb,
    primary key (asset_id, observed_at)
);

