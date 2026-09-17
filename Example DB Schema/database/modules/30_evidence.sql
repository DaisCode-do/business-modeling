-- ---------------------------------------------------------------------------
-- Files, documents, imports, and review workflow
-- ---------------------------------------------------------------------------

create table files.stored_file (
    id uuid primary key default gen_random_uuid(),
    storage_provider text not null,
    bucket_name text,
    object_key text not null,
    original_filename text not null,
    media_type text,
    size_bytes bigint check (size_bytes is null or size_bytes >= 0),
    sha256 char(64),
    captured_at timestamptz not null default now(),
    unique (storage_provider, bucket_name, object_key)
);

create unique index stored_file_sha256_uidx
    on files.stored_file (sha256) where sha256 is not null;

create table files.document (
    id uuid primary key default gen_random_uuid(),
    stored_file_id uuid not null references files.stored_file(id),
    document_type text not null,
    title text,
    document_number text,
    issued_on date,
    expires_on date,
    verification_status text not null default 'UNVERIFIED'
        check (verification_status in ('UNVERIFIED', 'VERIFIED', 'REJECTED')),
    metadata jsonb not null default '{}'::jsonb,
    created_at timestamptz not null default now(),
    check (expires_on is null or issued_on is null or expires_on >= issued_on)
);

create table files.party_document (
    party_id uuid not null references core.party(id),
    document_id uuid not null references files.document(id),
    purpose text,
    primary key (party_id, document_id)
);

create table staging.import_batch (
    id uuid primary key default gen_random_uuid(),
    legal_entity_id uuid references core.legal_entity(id),
    source_domain text not null check (source_domain in (
        'PURCHASE_606', 'CONTRACTOR_CLAIM', 'PAYROLL', 'CONTACT_CATALOG',
        'BUDGET', 'SCHEDULE', 'OTHER'
    )),
    pipeline_version text,
    status text not null default 'RECEIVED'
        check (status in ('RECEIVED', 'EXTRACTED', 'REVIEWING', 'ACCEPTED', 'REJECTED')),
    started_at timestamptz,
    completed_at timestamptz,
    created_by_user_id uuid references iam.app_user(id),
    notes text,
    created_at timestamptz not null default now()
);

create table staging.source_file (
    id uuid primary key default gen_random_uuid(),
    import_batch_id uuid not null references staging.import_batch(id),
    stored_file_id uuid not null references files.stored_file(id),
    source_path text,
    workbook_metadata jsonb not null default '{}'::jsonb,
    extraction_status text not null default 'PENDING'
        check (extraction_status in ('PENDING', 'EXTRACTED', 'PARTIAL', 'FAILED', 'SKIPPED')),
    error_message text,
    unique (import_batch_id, stored_file_id, source_path)
);

create table staging.source_record (
    id uuid primary key default gen_random_uuid(),
    source_file_id uuid not null references staging.source_file(id),
    record_kind text not null,
    locator_key text not null,
    sheet_name text,
    row_number integer check (row_number is null or row_number > 0),
    raw_payload jsonb not null,
    raw_fingerprint char(64),
    review_status text not null default 'PENDING'
        check (review_status in ('PENDING', 'ACCEPTED', 'QUARANTINED', 'REJECTED', 'DUPLICATE')),
    canonical_table text,
    canonical_id uuid,
    created_at timestamptz not null default now(),
    unique (source_file_id, locator_key)
);

create table staging.review_issue (
    id uuid primary key default gen_random_uuid(),
    source_record_id uuid references staging.source_record(id),
    issue_code text not null,
    entity_kind text,
    raw_value text,
    proposed_resolution jsonb,
    severity text not null default 'ERROR'
        check (severity in ('INFO', 'WARNING', 'ERROR', 'BLOCKING')),
    status text not null default 'OPEN'
        check (status in ('OPEN', 'RESOLVED', 'ACCEPTED_EXCEPTION', 'REJECTED')),
    resolution_note text,
    resolved_by_user_id uuid references iam.app_user(id),
    resolved_at timestamptz,
    created_at timestamptz not null default now(),
    check ((status = 'OPEN') = (resolved_at is null))
);

