# Evidence, agreement, and versioning

Jira should make it possible to answer three questions later:

1. What evidence or conversation produced this understanding?
2. Who confirmed the business decision, and what exactly was confirmed?
3. Which blueprint statement, requirement, model, or prototype changed because
   of it?

The process must provide that traceability without making the client maintain a
formal audit system.

## Give each Jira feature one job

### Description — maintained review proposition

The developer keeps the Jira description concise and current while review is
active. It states the proposition, question, evidence, and client request. After
agreement, the domain blueprint—not the Jira description—owns the durable
business definition. The item retains a summary and link to the incorporated
result.

### Comments — conversation and explicit responses

Use comments for answers, corrections, questions, meeting outcomes, and named
agreement. Preserve the original words when they affect meaning. Add a concise
developer summary after a long or verbal discussion.

JPD supports comment threads, replies, reactions, and pinned comments. Pin only
the most useful current decision, evidence, or open question.

### Insights — evidence excerpts and source links

Use an Insight for the exact part of an interview, document, support message,
or linked source that supports or challenges the item. An Insight should say
what the source demonstrates; a bare link is not enough.

Suggested Insight labels:

- `direct-document`
- `interview`
- `historical-example`
- `etl-output`
- `contradiction`
- `exception`

### Attachments — working evidence

Attach small source examples, screenshots, proposed mappings, and review files
when the Jira permissions and data sensitivity are appropriate. Add a comment
stating why the attachment matters and its source.

Direct Jira attachments provide context and chronology, but this process does
not assume that they provide semantic document version control. If a file is
revised, retain the earlier file and explicitly say which attachment supersedes
it.

### Blueprint, Confluence, or repository links — controlled documents

Use the Git-versioned blueprint for the accepted business model. Use a Confluence
page/attachment or another controlled repository when comparison, restoration,
authorship, or formal document revision history matters. Link the controlled
source from Jira instead of maintaining independent editable specifications.

## Lightweight file convention

For attachments that will have more than one iteration, use:

`YYYY-MM-DD_subject_vNN_status.ext`

Examples:

- `2026-09-18_project-aliases_v01_for-review.xlsx`
- `2026-09-23_project-aliases_v02_agreed.xlsx`

When adding a replacement, comment:

```markdown
Supersedes: [previous attachment or link]
Reason: [short correction or decision]
Current review file: [new attachment or link]
```

Do not delete older evidence just to make the card look tidy. Restrict deletion
permissions if practical, and keep sensitive files only in an approved storage
location.

## Source locator for imported evidence

When an item relies on historical files or ETL output, the developer records as
much of the following as exists:

- full relative source path;
- content hash;
- workbook sheet and row/cell range;
- import batch and pipeline version;
- whether the original document is available;
- whether the value is direct, derived, normalized, or inferred; and
- any quarantine or conflict identifier.

A basename such as `nomina.xlsx` is not sufficient. The current evidence set
contains duplicate basenames and stale derived outputs.

## Agreement protocol

The client may answer with only `Agree`, an option letter, a correction, or a
file. The developer writes the durable outcome using the outcome-comment
template in [item templates](03-item-templates.md).

An item may be `Agreed` only when:

- the named owner explicitly confirmed it;
- the exact accepted statement or selected option is recorded;
- material exceptions are recorded;
- relied-on evidence is linked or identified; and
- disagreement among owners is either resolved or clearly scoped.

An `Agreed` item becomes `Incorporated` only when:

- its outcome is applied to the affected blueprint sections;
- related assumptions, open questions, and decisions are reconciled;
- the Jira key is recorded in the resulting workflow or decision where useful;
- the Jira item links to the incorporated version; and
- the changed blueprint remains internally consistent.

Do not treat any of these as approval:

- no response;
- a view or reaction without a confirming statement;
- meeting attendance;
- an AI summary;
- a prototype field that nobody challenged; or
- an ETL output labeled “final” or “database-ready.”

## Handling disagreement

If participants disagree:

1. keep the item out of `Agreed`;
2. summarize each interpretation neutrally;
3. add one real example that distinguishes them;
4. identify the actual policy owner; and
5. record separate scope rules if both behaviors are valid in different cases.

Do not resolve a business disagreement through schema design.

## Blueprint, requirement, and schema traceability

When an agreed item changes the business model, record the Jira key in the
relevant workflow or decision and incorporate the result on a coherent Git
branch. Software requirements are then derived from that blueprint slice. When a
later requirement changes the prototype, carry the Jira and blueprint references
into the schema change notes or commit.

Use this chain:

**Source file / interview → Insight or attachment → Jira item → outcome comment
→ domain decision → blueprint revision → software requirement →
schema/prototype revision → verification**

An implementation may combine several incorporated items, and one business
decision may affect several requirements or tables. This is why Jira tracks
review and the blueprint tracks coherent business meaning rather than either one
mirroring the database structure.

## Sensitive and regulated evidence

Before uploading identity, payroll, banking, tax, or client documents:

- confirm that every Jira/Confluence participant is allowed to see them;
- prefer a redacted excerpt when the full document adds no value;
- avoid putting secrets or credentials in comments;
- retain the authoritative original in the approved company location; and
- record a locator rather than duplicating the file when policy requires it.

This playbook organizes discovery evidence; it is not by itself a records
retention, tax compliance, or legal archiving policy.

## Atlassian references

- [Create comments inside ideas](https://support.atlassian.com/jira-product-discovery/docs/create-comments-inside-ideas/)
- [Create insights in an idea](https://support.atlassian.com/jira-product-discovery/docs/create-insights-in-your-idea/)
- [Add an attachment to a Jira work item](https://support.atlassian.com/jira-software-cloud/docs/add-an-attachment-to-an-issue/)
- [Create, update, and manage Confluence content](https://support.atlassian.com/confluence-cloud/docs/create-edit-and-publish-a-page/)
- [Upload a file and manage attachment versions in Confluence](https://support.atlassian.com/confluence-cloud/docs/upload-a-file/)
