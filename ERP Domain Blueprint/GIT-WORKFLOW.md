# Git Workflow for Domain Documentation

## Purpose

Git preserves the accepted documentation, its change history, and the reasoning that led to each stable version. Branches provide a temporary place to review one coherent subject before it becomes part of the accepted model.

Git is the only workflow tool required while one person owns discovery and documentation. The Markdown files, not branches or commit messages, remain the authoritative description of the business.

## Repository boundary

- Raw evidence should not be committed by default.
- The remote repository should be private. Access to the Git repository does not automatically grant access to the external evidence repository.

## Permanent and temporary branches

### `main`

`main` represents the current coherent documentation baseline. A statement on
`main` may still be `Proposed` or `Open` when labeled accordingly; inclusion does
not falsely convert it into client-approved policy. The branch should remain
readable, internally consistent, and free of unfinished editing experiments.

### Short-lived working branches

Create one branch for one coherent review or change. Recommended prefixes:

- `review/` — reviewing a workflow against real practice;
- `domain/` — introducing or changing a concept or relationship;
- `decision/` — resolving a recorded open question;
- `maintenance/` — formatting, navigation, or non-semantic cleanup.

Do not maintain a permanent `develop` branch. It adds no useful distinction for a single-author documentation repository.

## Normal change cycle

Start from the latest accepted baseline:

```bash
git switch main
git pull --ff-only
git switch -c review/enrollment
```

Then:

1. Select one workflow, concept group, or decision.
2. Review the relevant real examples and evidence.
3. Edit the smallest coherent set of documents.
4. Check whether the glossary, relationships, lifecycle, open questions, or decision log must change with it.
5. Review the diff before committing.
6. Commit one coherent conclusion at a time.
7. Merge only when the branch tells a consistent business story.

Useful review commands:

```bash
git status --short
git diff --stat
git diff --word-diff
git diff --check
```

When the branch is ready:

```bash
git switch main
git merge --no-ff review/enrollment
git branch -d review/enrollment
git push origin main
```

`--no-ff` retains the boundary of the review in history. If a branch contains noisy experimental commits, clean or squash them before merging rather than preserving every typing step.

Small spelling, broken-link, or formatting corrections may be committed directly to `main` when they do not change business meaning. Any semantic change should use a branch.

## Commit messages

Use the form:

```text
<kind>(<area>): <business change>
```

Recommended kinds:

- `workflow` — changes how business activity is described;
- `domain` — changes a concept or relationship;
- `decision` — records or applies a resolved question;
- `discovery` — adds assumptions, sources, or open questions;
- `docs` — improves navigation or explanatory material;
- `maintenance` — formatting or non-semantic cleanup.

A commit body is useful when the reason is not obvious.

## Applying a business decision

A decision branch should normally update all affected views in the same change:

1. Add or update the entry in `discovery/DECISION-LOG.md`.
2. Mark the corresponding question in `discovery/OPEN-QUESTIONS.md` as resolved or remove it after the decision ID preserves traceability.
3. Update the relevant workflow.
4. Update the domain definition, glossary, relationships, or lifecycle only where the decision changes them.
5. Update assumptions that the decision confirms or disproves.
6. Record the Jira key or review link where it materially improves traceability.

Do not create a decision record for spelling corrections or ordinary elaboration. Use it for choices that constrain future interpretation of the domain.

## Documentation review checklist

Before merging a semantic change, confirm:

- The same term has the same meaning everywhere it appears.
- The workflow still has a clear trigger and completion condition.
- Relationships and lifecycle history remain explainable.
- Proposed policy has not been presented as observed fact.
- A resolved question has a corresponding decision where appropriate.
- External systems and source authority are represented accurately.
- No personal, financial, legal, or authentication secret was added accidentally.
- Local Markdown links still resolve.
- Markdown formatting remains consistent.

For the current blueprint, formatting can be checked with:

```bash
find "ERP Domain Blueprint" -type f -name '*.md' -print0 \
  | xargs -0 prettier --check
```

## Evidence and session records

Evidence should remain in its controlled source. Domain documents should refer to an evidence identifier, date, description, and authoritative location when that reference is needed.

Create a session record only when a review produces information worth preserving, such as a decision, a meaningful example, or unresolved questions. Git history is not improved by logging routine reading or every work session.

Never commit:

- credentials, tokens, or `.env` files;
- unrestricted student or staff personal data;
- raw bank exports;
- executed legal documents without an explicit repository policy;
- meeting recordings or transcripts merely for convenience; or
- generated copies of documents already controlled elsewhere.

## Milestones and versions

Use annotated tags for meaningful domain baselines rather than every merge:

```bash
git tag -a domain-v0.1 -m "Initial domain blueprint"
git push origin domain-v0.1
```

The existing `domain-v0` tag identifies the seeded, unreviewed starting point.
Suggested progression from it:

- `domain-v0.1` — domain map and first primary workflow reviewed;
- `domain-v0.2` — project foundation and first connected workflows reviewed;
- `domain-v0.3` — major ownership, system, and finance boundaries reviewed;
- `domain-v1.0` — business model accepted as the basis for software requirements.

These versions measure documentation maturity, not software releases.

## History and recovery

- Git history replaces a manually maintained change log.
- The decision log records business reasoning that a textual diff cannot explain.
- Use a private remote as the off-device copy of the repository.
- Avoid force-pushing `main` and deleting remote history.
- Prefer a correcting commit over rewriting an already shared decision.
- Tag reviewed baselines so later changes can be compared with an accepted point.
