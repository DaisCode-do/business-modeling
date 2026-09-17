# Business Blueprint Method Assessment

- **Assessment date:** 2026-09-17
- **Scope:** EduGuiders worked example, Constructora template, prior
  evidence/schema, and Jira discovery process

## Conclusion

The business-domain blueprint is the right intermediate artifact between raw
evidence and software requirements. It corrects the largest risk in the earlier
approach: allowing an evidence-derived database model to decide what the business
must mean before end-to-end workflows and decision authority are understood.

The approach needs one important boundary:

> Reuse the method and validated conceptual patterns. Do not reuse another
> company's policy, workflow detail, terminology, or system boundary.

EduGuiders is a strong worked example because the owner can inspect every part of
the operation, decide policy, and revise the model rapidly. That reduces
coordination cost; it does not remove the intellectual work of separating
identity, relationships, workflow, history, policy, evidence, and external
systems.

Constructora has a different risk profile: evidence is fragmented, ETL is
fragile, several participants own different knowledge, and the person describing
a process may not have authority to set policy. Jira remains useful there as a
coordination and agreement layer.

## What transfers from EduGuiders

- workflow-first discovery;
- one shared business language;
- domain boundaries that do not predetermine software services;
- dated relationships instead of overwritten identity attributes;
- explicit planned-versus-actual distinctions;
- explicit external-system authority and evidence boundaries;
- separate assumptions, open questions, and decisions;
- normal examples plus meaningful exceptions; and
- Git-versioned accepted documentation.

## What must not transfer automatically

- academic domain names and concepts;
- EduGuiders participant roles or authority;
- enrollment, attendance, scheduling, billing, or compensation policy;
- its four-domain decomposition;
- decisions made possible by one owner having comprehensive information; or
- the absence of a collaboration tool.

The Constructora domain map may ultimately contain analogous patterns, but each
analogy must survive a real construction workflow.

## EduGuiders worked-example review

The EduGuiders blueprint is a strong foundation, not yet a stable requirements
source for every domain. Its clearest strengths are the workflow form, explicit
external-system boundaries, planned-versus-actual scheduling, role assignments,
and separation of charge, invoice, payment, allocation, bank transaction, and
reconciliation.

Before calling the EduGuiders model stable, review these points inside that
project:

- `PersonOrOrganization` appears in finance and governance relationships, while
  the people model defines `Person` but does not yet establish an Organization or
  shared Party concept.
- Billing responsibility is better treated as an effective relationship with
  scope and dates than as a direct permanent person-to-account cardinality.
- Course Offering and Program are proposed kinds of Learning Offering; confirm
  that this classification covers assessments, trials, workshops, and technical
  training without forcing unlike services into one lifecycle.
- Attendance amendments are described behaviorally but need a clear record and
  authority relationship if earlier submitted values must remain explainable.
- A general Case is useful, but its threshold must stay narrow enough that it
  does not become a universal container for ordinary workflow state.
- The boundary among operational staff compensation, legal worker
  classification, payroll calculation, and the accountant remains deliberately
  open and blocks detailed compensation requirements.
- [Publicly registered EduGuiders activity](https://www.onapi.gov.do/transparencia/index.php/institucional/publicaciones/3516-boletines-de-registros-publicados-del-2020-al-2026/3380-pub-2025/3558-septiembre?download=18400%3Ainternet-onapi-15-09-2025)
  is broader than English instruction, so the intended product boundary should
  explicitly include or exclude technology, software-engineering, and other
  academic/technical offerings.

These are normal validation issues, not reasons to reject the model. They show
why a blueprint should mature workflow slice by workflow slice rather than be
declared complete because its structure is coherent.

## Why specificity is not the problem

A product that fits one company must contain company-specific vocabulary,
workflow, authority, calculations, exceptions, and documents. Removing those
details produces a generic interface that may be reusable but does not meet the
client's expectations.

The design goal is therefore not “keep the business model generic.” It is:

- keep stable concepts small and explicit;
- isolate changeable policy from identity and historical fact;
- give each workflow and domain a clear boundary;
- make external authorities and integrations replaceable;
- version baselines, agreements, classifications, and rules that change over
  time; and
- derive technical extension points from observed variation rather than
  speculative configurability.

Some future requirements should cause code or schema changes. Quality means
those changes are localized, explainable, testable, and migratable—not that they
never occur.

## Correct artifact responsibilities

### Evidence

Preserves source material and provenance. Evidence can be incomplete,
contradictory, obsolete, or misunderstood.

### Jira

Coordinates small review units, comments, evidence requests, ownership, and
agreement among participants. Jira should not become a second copy of every
workflow document.

### ERP Domain Blueprint

Owns the coherent current business model. Git provides reviewable changes,
history, and tagged maturity baselines.

### Software requirements

Translate a sufficiently mature blueprint slice into observable system behavior,
quality constraints, acceptance cases, access expectations, integrations, and
migration needs.

### Architecture and prototypes

Implement or test requirements. They may reveal a missing business question but
must not silently redefine policy.

## Risks to control

### Blueprint as a polished guess

A complete-looking document can create the same false confidence as a detailed
schema. Keep certainty labels and evidence links visible. An empty validated
section is safer than a convincing invented workflow.

### Duplicate truth between Jira and Git

Jira owns the review thread; the blueprint owns the incorporated result. Link
them. Do not maintain two independently editable final definitions.

### Excessive abstraction

Words such as “Party,” “Case,” or “Business Record” are useful only when they
preserve distinctions in real examples. Do not build a universal meta-model to
avoid naming construction concepts.

### Premature configuration

Do not turn every unknown rule into a configuration table. First determine who
owns the rule, how often it changes, whether history matters, and which variation
actually occurs.

### Owner availability mistaken for universal certainty

EduGuiders can resolve many questions through one owner. Constructora decisions
need the right operational, accounting, commercial, and project authorities.
Silence or meeting attendance is not agreement.

## Recommended maturity baselines

- **`domain-v0`:** seeded method, hypotheses, and prior evidence retained; not a
  reviewed business model.
- **`domain-v0.1`:** domain map corrected and one primary workflow reviewed using
  a normal case and meaningful exception.
- **`domain-v0.2`:** project foundation and first connected cost/revenue
  workflows reviewed; core vocabulary and authority boundaries coherent.
- **`domain-v0.3`:** major workflows and system boundaries reviewed; high-impact
  open questions no longer reverse domain boundaries.
- **`domain-v1.0`:** accepted basis for systematic software requirements, while
  remaining open to controlled future change.

Tags measure business-documentation maturity, not software releases or the end
of all discovery.

## Recommendation for the next step

Use the upcoming client meeting to validate the map and select one workflow, not
to approve the ERP. Then model that workflow completely enough to expose terms,
relationships, records, authority, exceptions, and system boundaries. Only after
the resulting blueprint slice is incorporated should the detailed schema-derived
Jira questions be activated and software requirements derived.

## Repository health observations

The private remote, coherent initial commit, and annotated `domain-v0` tag are a
good baseline. The tag accurately represents a seeded starting point rather than
a finished specification.

One repository issue should be resolved before relying on fresh clones:

- `Example DB Schema/docs/erd` is recorded in the root index as a Git link
  (`160000`) at commit `dfbbd74...`.
- The root repository has no `.gitmodules` entry, and the directory no longer has
  its own `.git` metadata.
- A new clone therefore has neither a configured submodule source nor ordinary
  tracked ERD files.
- The ERD's regeneration notes also retain paths from its former standalone
  layout.

Choose one explicit repair:

1. **Recommended:** convert the ERD directory into normal files tracked by this
   repository because it is now an example artifact inside the project; or
2. restore it as a real submodule with a deliberate remote and `.gitmodules`
   entry if independent deployment/versioning is still required.

Do not attempt both. This documentation change does not alter the Git index
boundary because the correct choice depends on the intended deployment model.
