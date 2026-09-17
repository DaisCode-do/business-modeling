# Jira item templates

These templates are intentionally short. Copy the relevant template into a JPD
description, remove sections that do not help the current review, and replace
bracketed text.

The developer fills the source, current understanding, and recorded outcome.
The client normally contributes only a comment, choice, example, or file.

## Requirement confirmation

Use when evidence already suggests a behavior and the responsible owner can
confirm or correct it.

```markdown
## Why this matters

[One sentence describing the consequence of getting this wrong.]

## Current understanding

- [Plain-language behavior.]
- [One important boundary or exception already known.]

## What we need from you

Please comment **Agree**, or correct the bullet that is wrong. If possible, add
one real exception.

## Evidence considered

- [Small attachment, Insight, source path, or reachable link.]

## Recorded outcome — maintained by developer

Pending.
```

## Business decision

Use only when multiple approaches are genuinely valid and a named business
owner must select the policy.

```markdown
## Decision needed

[One sentence stating the choice and why it blocks later work.]

## Options

- **A — [short name]:** [business consequence].
- **B — [short name]:** [business consequence].
- **C — [short name]:** [include only when genuinely needed].

## What we need from you

Comment **A**, **B**, or **C**, plus any exception that the choice must support.
If you are not the decision owner, comment **Ask [name/role]**.

## Current evidence

- [Example, source, or known limitation.]

## Recorded decision — maintained by developer

Pending owner confirmation.
```

Do not disguise a technical preference as a client choice. If only one option
preserves correctness, document it as a technical decision and explain the
business consequence.

## Evidence request

Use when a conclusion cannot be trusted until a specific real source is seen.

```markdown
## What is uncertain

[One or two sentences.]

## What we need from you

Please attach or link **[one exact file/example]**, or tell us who has it.

That is all required for this item. The developer will extract the relevant
details and return a proposed rule for confirmation.

## Evidence already available

- [What exists and why it is insufficient.]

## Recorded result — maintained by developer

Pending evidence.
```

## Terminology clarification

Use when the same word appears to represent different business concepts.

```markdown
## Term to clarify

**[customer term]**

## Current interpretations

- **A — [meaning]:** [example].
- **B — [meaning]:** [example].

## What we need from you

For each example attached below, comment **A**, **B**, or the correct term.

## Recorded vocabulary — maintained by developer

Pending.
```

## Architecture decision record

Use only in the developer-managed Architecture view. It is presented to the
client for transparency, not business approval.

```markdown
## Status

Proposed

## Technical context

[Problem, constraints, and linked business requirements.]

## Decision

[Chosen technical direction.]

## Alternatives considered

- [Alternative and why it was not selected.]

## Consequences

- [Positive consequence.]
- [Cost, risk, or limitation.]

## Evidence and validation

- [Prototype, benchmark, source document, or test.]

## Revisit when

- [Concrete condition that should reopen the decision.]
```

## Outcome comment

After a review, add this short developer comment. The client does not complete
it.

```markdown
**Outcome recorded — [YYYY-MM-DD]**

- Confirmed by: [person and business role]
- Result: [one plain-language statement]
- Evidence considered: [attachment, Insight, comment, or link]
- Exceptions: [none, or concise list]
- Supersedes: [prior item/comment/version, or none]
- Next effect: [requirement, business rule, schema, prototype, or no change]
```

## Title rules

Prefer titles that describe the business question or outcome:

- `Confirm what identifies one construction project`
- `Decide what proves a supplier invoice was paid`
- `Clarify the two-percent deduction on contractor claims`

Avoid implementation-shaped titles:

- `Review project table`
- `Add payment_allocation_id`
- `Fix database relation`

## Splitting rule

Split an item when different people own the decisions or when one answer can be
agreed without the other. Keep examples and exceptions together when they test
the same business rule. The goal is one meaningful decision per item, not one
item per database field.
