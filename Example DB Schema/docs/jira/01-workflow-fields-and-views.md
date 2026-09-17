# Workflow, fields, and views

This is the minimum useful JPD configuration for requirements discovery. Keep
the shared client surface sparse; additional internal detail belongs in hidden
fields, comments, linked evidence, or the repository documentation.

JPD terminology varies slightly across Atlassian interfaces. An “idea” or “work
item” in the product is called an **item** in these documents.

## Client Review workflow

### Draft

The developer is preparing the item. It is not yet asking the client for work.

An item may leave `Draft` when:

- it concerns one understandable business concept or decision;
- the relevant current understanding and source are present;
- it contains one clear request to the client;
- a decision owner or evidence provider is named; and
- the answer would change or validate a requirement.

### Discuss

The item is ready for a correction, choice, example, or short conversation.

Use `Discuss` when the client can answer from experience or authority without
having to find another document first.

### Evidence Needed

A specific file, real example, record, or different participant is required.
The description must say exactly what is needed and who is expected to provide
it. “More information needed” is not sufficient.

### Agreed

The responsible business owner has explicitly confirmed the current statement
or decision. The item records:

- who agreed and when;
- the agreed outcome in plain language;
- the evidence or example considered;
- any material exception or scope limit; and
- any prior understanding it supersedes.

Agreement is current and revisable; it is not a claim that the requirement can
never change.

### Ready

The developer considers the agreed outcome safe to use as an implementation or
prototype input. It has an acceptance example, resolved dependencies relevant
to the slice, and no unanswered question likely to reverse its boundary.

`Ready` does not mean scheduled, estimated, or promised for a release.

## Minimal fields

Use the built-in title, description, status, comments, assignee/owner, and
attachments where available. Add only these discovery fields initially.

### Item kind

Single select:

- Requirement
- Question
- Business decision
- Terminology
- Technical decision

If custom JPD idea types are available on the current plan, these values can
later become types. A select field is enough to begin and avoids making the
process depend on a premium feature.

### Statement class

Single select:

- Observed behavior
- Proposed behavior
- Uncertainty
- Business decision
- Technical decision

This prevents an inference from looking like a confirmed fact.

### Business area

Multi-select:

- Identity and access
- Projects
- Purchases, payments, and tax
- Contractors and payroll
- Budgets and APU
- Client contracts and billing
- Data migration and evidence
- Architecture
- Website

Start with this list. Add an area only when several real items cannot be
classified without it.

### Decision owner

People field when possible. This is the person authorized to confirm policy,
not necessarily the participant who first described the process.

### Evidence confidence

Single select maintained by the developer:

- Direct source document
- Corroborated examples
- Indirect extraction
- Meeting statement
- Prototype inference
- No evidence yet

### Review response

Single select maintained by the developer after reading comments:

- Awaiting response
- Agrees
- Correction supplied
- Evidence or example supplied
- Needs conversation
- Not the right owner
- Not applicable

Clients should not be required to maintain this field themselves.

## Field visibility

The default `Client Review` card should show only:

- status;
- item kind;
- business area;
- decision owner; and
- review response.

Keep evidence confidence, technical labels, dependencies, internal notes, and
effort hidden from the client board unless they help answer the current
question. The description should contain the human-readable context.

## Views

### Client Review

Use a board grouped by the five workflow statuses. Filter out `Technical
decision`, `Architecture`, and `Website` unless a specific presentation needs
them. Order active items manually so the three requiring attention appear
first.

This is the primary client interaction surface. Comments are the preferred
asynchronous response channel.

### Requirements Catalogue

Use a list over the same items; do not duplicate them. Show item kind,
statement class, business area, owner, status, evidence confidence, and last
update. Group first by business area and then filter as needed.

This view answers “what do we currently know?” rather than “what must I answer
today?”

### Architecture

Filter to `Business area = Architecture` or `Item kind = Technical decision`.
The developer creates and edits these records. Client participants receive
view-only access wherever the current Jira plan and permission model allow it.

Architecture items may link to a business requirement that constrains them,
but they do not enter the client agreement workflow. Use technical states such
as `Proposed`, `Accepted`, `Superseded`, and `Rejected` if this view needs its
own workflow.

The current architectural constraint is that the custom PostgreSQL model
remains the source-of-truth candidate and `frappe_docker` is only a possible
future UI/UX reference.

### Impact vs Effort

Leave this view empty or hidden during the first cycle. Use it only after an
item is at least `Agreed` and its boundary is understood. Early numerical
estimates would create false confidence.

### Timeline

Show discovery and prototype phases at month or quarter resolution. Do not put
precise delivery dates on unresolved requirements. A timeline is a direction
and dependency view, not a solo-developer delivery guarantee.

### Website

Keep public-site changes separate from the ERP discovery flow. A simple
`Now / Next / Later` view is enough.

## Ownership and permissions

- **Developer:** owns configuration, descriptions, synthesis, technical
  decisions, traceability, and movement to `Ready`.
- **Business decision owner:** confirms or rejects policy for their domain.
- **Process participant:** supplies actual examples, exceptions, corrections,
  and evidence.
- **Viewer:** can follow progress without being asked to approve anything.

Do not infer approval from silence, attendance, a reaction emoji, or an item
having been viewed. Record an explicit response from the named owner.

## Configuration restraint

Run one complete review cycle before adding more fields, automation, custom
types, or hierarchy. If information is not used to filter, decide, trace, or
communicate, it probably does not deserve a field.

## Atlassian references

- [Create a Jira Product Discovery space](https://support.atlassian.com/jira-product-discovery/docs/create-a-jira-product-discovery-space/)
- [Jira Product Discovery fields reference](https://support.atlassian.com/jira-product-discovery/docs/jira-product-discovery-fields-reference/)
- [Create and manage custom fields](https://support.atlassian.com/jira-product-discovery/docs/create-and-manage-custom-fields/)
- [Create and configure idea types](https://support.atlassian.com/jira-product-discovery/docs/create-and-configure-idea-types/)
- [Create a timeline view](https://support.atlassian.com/jira-product-discovery/docs/create-a-timeline-view/)

