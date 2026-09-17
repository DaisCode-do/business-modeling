-- ---------------------------------------------------------------------------
-- Application identities. Administrator and accountant are permissions, not
-- separate business parties. An account may optionally link to an employee.
-- ---------------------------------------------------------------------------

create table iam.app_user (
    id uuid primary key default gen_random_uuid(),
    party_id uuid references core.party(id),
    email text not null,
    display_name text not null,
    status text not null default 'INVITED'
        check (status in ('INVITED', 'ACTIVE', 'SUSPENDED', 'DISABLED')),
    last_login_at timestamptz,
    created_at timestamptz not null default now()
);

create unique index app_user_email_uidx on iam.app_user (lower(email));

create table iam.access_role (
    code text primary key,
    name text not null,
    description text
);

insert into iam.access_role (code, name) values
    ('ADMINISTRATOR', 'Administrator'),
    ('ACCOUNTANT', 'Accountant'),
    ('PROJECT_MANAGER', 'Project manager'),
    ('CLIENT_VIEWER', 'Client viewer'),
    ('FIELD_WORKER', 'Field worker');

create table iam.app_user_role (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references iam.app_user(id) on delete cascade,
    role_code text not null references iam.access_role(code),
    legal_entity_id uuid references core.legal_entity(id),
    project_id uuid,
    granted_by_user_id uuid references iam.app_user(id),
    granted_at timestamptz not null default now(),
    revoked_at timestamptz,
    unique nulls not distinct (user_id, role_code, legal_entity_id, project_id),
    check (revoked_at is null or revoked_at >= granted_at)
);

-- project_id receives its FK after projects.project exists.

