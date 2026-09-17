# Client meeting plan — 2026-09-18

## Meeting outcome

The meeting succeeds if the client helps correct the proposed business map,
corrects the high-level value streams, selects one workflow for detailed review,
and identifies the people and real examples needed next.

It is **not** necessary to approve a complete ERP specification, database schema,
or delivery plan.

## What to prepare before the meeting

1. Create or update only the three Wave 1 Jira items from
   [the first batch](04-first-jira-batch.md).
2. Present the proposed
   [Business Context](<../../../ERP Domain Blueprint/foundation/BUSINESS-CONTEXT.md>)
   and [Domain Map](<../../../ERP Domain Blueprint/foundation/DOMAIN-MAP.md>).
3. Have the proposed workflow options visible, but do not create detailed cards
   for every process.
4. Prepare a place to record names and responsibilities without exposing private
   evidence on screen.
5. Keep the ERD closed initially. Use it only as an appendix if the client asks
   what has already been prototyped.

## Opening explanation

Use language close to this:

> We already have evidence, an initial database hypothesis, and many possible
> ERP concepts. Before treating those as requirements, we want to describe how
> your company actually works. Today we are not asking you to review tables or
> write specifications. We will show a proposed business map, you will correct
> it using one real project, and together we will choose the first workflow to
> document properly.

Explain the artifact roles briefly:

- source files show historical evidence;
- Jira holds questions, comments, files, and agreement;
- the business blueprint holds the accepted company model;
- requirements and software models are derived later;
- architecture remains the developer's responsibility.

## Suggested 60-minute agenda

### 0–5 minutes — frame the decision

- Confirm who is present and their business role.
- State the meeting outcome and non-goals.
- Confirm that corrections are more valuable than polite agreement.

### 5–20 minutes — correct the domain map

Show the eight proposed areas from `DISC-01`.

Ask:

- Which area is named incorrectly?
- What important responsibility has no home?
- Which two areas are actually one in current practice?
- Who best explains each corrected area?

Do not debate software modules. Record proposed corrections and the appropriate
decision owner.

### 20–38 minutes — walk one real project across the value streams

Use `DISC-02`. Ask the participant to name a recent representative project and
move through the proposed chain.

Ask only:

- What first caused the company to treat this as real work?
- What authorized the project or commitment?
- What was planned before execution?
- How were goods, contractors, and workers engaged?
- What proved work was done?
- What caused client billing and cost obligations?
- What made the project financially and operationally complete?

Capture the first meaningful exception. Avoid collecting every edge case.

### 38–50 minutes — choose the first detailed workflow

Use `DISC-03`.

Recommendation:

1. Start with **project establishment and commercial basis** if a recent example
   and responsible participant are available.
2. Otherwise start with **purchase to project cost and payment**, where the
   existing evidence is strongest.
3. Use **contractor work to claim and payment** early when the ambiguity around
   `cubicacion` and deductions is causing immediate operational risk.

For the selected workflow, name:

- one person who performs it;
- one person authorized to decide its policy;
- one normal completed case;
- one exception or correction; and
- where the related documents can be accessed safely.

### 50–60 minutes — close with concrete commitments

Replay what was learned in plain language. Confirm:

- corrected domain-map statements;
- selected workflow;
- participants for the next walkthrough;
- evidence provider and safe delivery route;
- unresolved disagreement, if any; and
- tentative next review—not an implementation deadline.

## Questions to avoid

- “What features do you want in the ERP?”
- “Is this 85-table schema correct?”
- “Can you document your complete process?”
- “Which system should we build first?”
- “Can you approve all these requirements?”

Replace them with one concrete scenario, one correction, and one exception.

## Notes to record during the meeting

For each important statement, mark it as:

- **Observed practice** — what currently happens;
- **Desired improvement** — what participants want to change;
- **Mandatory policy** — what must happen because of authority, law, contract,
  accounting, or company decision;
- **Open** — disagreement or insufficient evidence; or
- **Developer decision** — implementation or architecture outside client
  approval.

Also record who said it and whether they are the process participant, evidence
holder, or actual decision owner.

## Immediately after the meeting

1. Add a concise outcome comment to each active Jira item.
2. Move unanswered evidence requests to `Evidence Needed` with one named provider.
3. Update the Business Context and Domain Map with agreed corrections.
4. Record material business choices in the blueprint Decision Log.
5. Create the selected workflow from `workflows/TEMPLATE.md` on a short-lived Git
   branch.
6. Link the Jira keys in the affected blueprint sections.
7. Mark an item `Incorporated` only after its accepted result is represented in
   the blueprint.
8. Prepare no more than three connected cards for the next review.

## Meeting guardrails

- Do not promise an implementation schedule from this session.
- Do not let current spreadsheet columns define the workflow.
- Do not present an AI inference as client-confirmed policy.
- Do not upload sensitive files to Jira until access is verified.
- Do not leave agreement only in spoken meeting memory.
- Do not expand into frontend or architecture unless a business constraint needs
  to be captured.
