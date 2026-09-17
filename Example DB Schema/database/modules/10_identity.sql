-- ---------------------------------------------------------------------------
-- Parties and the single operating legal-entity boundary
-- ---------------------------------------------------------------------------

create table core.party (
    id uuid primary key default gen_random_uuid(),
    party_type text not null check (party_type in ('PERSON', 'ORGANIZATION')),
    display_name text not null check (btrim(display_name) <> ''),
    status text not null default 'ACTIVE'
        check (status in ('ACTIVE', 'INACTIVE', 'PENDING_REVIEW', 'MERGED')),
    merged_into_party_id uuid references core.party(id),
    notes text,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    check ((status = 'MERGED') = (merged_into_party_id is not null)),
    check (merged_into_party_id is null or merged_into_party_id <> id)
);

create table core.person_profile (
    party_id uuid primary key references core.party(id) on delete cascade,
    given_names text,
    family_names text,
    nickname text,
    nationality_code char(2),
    birth_date date
);

create table core.organization_profile (
    party_id uuid primary key references core.party(id) on delete cascade,
    legal_name text,
    trade_name text,
    organization_kind text
        check (organization_kind in ('COMPANY', 'SOLE_PROPRIETOR', 'GOVERNMENT', 'NONPROFIT', 'OTHER'))
);

create table core.party_identifier (
    id uuid primary key default gen_random_uuid(),
    party_id uuid not null references core.party(id),
    identifier_type text not null
        check (identifier_type in ('RNC', 'CEDULA', 'PASSPORT', 'OTHER')),
    country_code char(2) not null default 'DO',
    raw_value text not null,
    normalized_value text not null check (btrim(normalized_value) <> ''),
    verification_status text not null default 'UNVERIFIED'
        check (verification_status in ('UNVERIFIED', 'VERIFIED', 'REJECTED')),
    verified_at timestamptz,
    is_primary boolean not null default false,
    created_at timestamptz not null default now(),
    unique (party_id, identifier_type, country_code, normalized_value),
    check ((verification_status = 'VERIFIED') = (verified_at is not null))
);

-- Identity numbers become globally unique only after review. This permits dirty
-- imports to coexist without silently merging incompatible people/organizations.
create unique index party_identifier_verified_uidx
    on core.party_identifier (identifier_type, country_code, normalized_value)
    where verification_status = 'VERIFIED';

create table core.legal_entity (
    id uuid primary key default gen_random_uuid(),
    party_id uuid not null unique references core.party(id),
    code text not null unique,
    base_currency char(3) not null default 'DOP',
    timezone text not null default 'America/Santo_Domingo',
    active boolean not null default true,
    created_at timestamptz not null default now()
);

create table core.party_role (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid not null references core.legal_entity(id),
    party_id uuid not null references core.party(id),
    role_type text not null check (role_type in (
        'CLIENT', 'PROJECT_OWNER', 'SUPPLIER', 'CONTRACTOR', 'EMPLOYEE',
        'PROJECT_WORKER', 'DRIVER', 'CONTACT'
    )),
    valid_from date,
    valid_to date,
    status text not null default 'ACTIVE'
        check (status in ('ACTIVE', 'INACTIVE', 'PENDING_REVIEW')),
    unique (legal_entity_id, party_id, role_type),
    check (valid_to is null or valid_from is null or valid_to >= valid_from)
);

create table core.party_alias (
    id uuid primary key default gen_random_uuid(),
    party_id uuid not null references core.party(id),
    alias_text text not null,
    normalized_alias text not null,
    alias_kind text not null default 'SOURCE_NAME'
        check (alias_kind in ('SOURCE_NAME', 'TRADE_NAME', 'NICKNAME', 'MISSPELLING', 'LEGACY_CODE')),
    approved boolean not null default false,
    source_note text,
    created_at timestamptz not null default now(),
    unique (party_id, normalized_alias)
);

create table core.site (
    id uuid primary key default gen_random_uuid(),
    owner_party_id uuid references core.party(id),
    site_type text not null check (site_type in (
        'SUPPLIER_BRANCH', 'PROJECT_SITE', 'OFFICE', 'WAREHOUSE', 'WORKSHOP', 'OTHER'
    )),
    code text,
    name text not null,
    address_line_1 text,
    address_line_2 text,
    sector text,
    municipality text,
    province text,
    country_code char(2) not null default 'DO',
    latitude numeric(10, 7),
    longitude numeric(10, 7),
    boundary_geojson jsonb,
    active boolean not null default true,
    created_at timestamptz not null default now(),
    check (latitude is null or latitude between -90 and 90),
    check (longitude is null or longitude between -180 and 180)
);

create unique index site_owner_code_uidx
    on core.site (owner_party_id, lower(code)) where code is not null;

create table core.contact_point (
    id uuid primary key default gen_random_uuid(),
    party_id uuid not null references core.party(id),
    site_id uuid references core.site(id),
    contact_type text not null
        check (contact_type in ('PHONE', 'WHATSAPP', 'EMAIL', 'WEB', 'OTHER')),
    label text,
    value text not null check (btrim(value) <> ''),
    extension text,
    is_primary boolean not null default false,
    verified_at timestamptz,
    active boolean not null default true,
    created_at timestamptz not null default now()
);

create table core.party_relationship (
    id uuid primary key default gen_random_uuid(),
    from_party_id uuid not null references core.party(id),
    to_party_id uuid not null references core.party(id),
    site_id uuid references core.site(id),
    relationship_type text not null check (relationship_type in (
        'CONTACT_FOR', 'REPRESENTATIVE_OF', 'EMPLOYEE_OF', 'RELATED_ORGANIZATION'
    )),
    title text,
    valid_from date,
    valid_to date,
    unique nulls not distinct (from_party_id, to_party_id, site_id, relationship_type),
    check (from_party_id <> to_party_id),
    check (valid_to is null or valid_from is null or valid_to >= valid_from)
);

