# Client review method

The review process should feel like confirming how the company works, not like
outsourcing requirements writing to the client.

## The interaction contract

Every client-facing item should make one primary request:

- **Agree or correct:** “Is this how it works today?”
- **Choose:** “Which of these two or three real alternatives should apply?”
- **Give one example:** “What happened in the most recent case?”
- **Attach evidence:** “Please attach one paid invoice and its payment proof.”
- **Name the owner:** “Who is authorized to decide this?”
- **Identify an exception:** “When would this rule be wrong?”

Do not ask “describe the complete process,” “list all requirements,” or “review
the database.” If none of the requests above fits, the item is not ready for
client review.

## The two-to-five-minute card

A normal card contains only:

1. a plain title;
2. one sentence explaining why the answer matters;
3. the current understanding in two to four bullets;
4. one highlighted request;
5. options only when there is a genuine choice; and
6. one small evidence excerpt, image, or link when needed.

The deeper source analysis remains in the repository or a linked document.
Avoid pasting raw ETL reports, SQL, or complete meeting summaries into the
client-facing description.

## Easy ways to answer

Put this legend in the Client Review view description and repeat it during the
orientation:

- `Agree` — the current understanding is correct.
- `Option A`, `B`, or `C` — choose the listed behavior.
- `Correction: ...` — change one fact in the summary.
- `Example: ...` — describe or attach one real case.
- `Ask [name/role]` — this needs another owner.
- `Not applicable` — the process does not exist or is outside scope.

A short comment, a photo, an uploaded workbook, or a verbal answer recorded by
the developer is valid input. Grammar and formatting are irrelevant.

## Using comments well

- Keep each conversation on the smallest relevant item.
- Ask one follow-up question per comment.
- Mention the specific person only when action is needed.
- Reply with a brief acknowledgement and state what will happen next.
- When a thread becomes long, summarize it in a new developer comment and
  update the description; do not make future readers reconstruct the result.
- Pin the current decision, the key evidence, and the remaining question when
  pinning is available.

Comments are evidence of the conversation. The description is the maintained
current understanding. Neither replaces the other.

## Using attachments and links well

Ask for the smallest useful evidence:

- one official company identity document, not “all legal files”;
- one invoice plus its payment proof, not an entire accounting archive;
- one contractor claim with an exception, not every claim ever issued;
- a pre-filled proposed project mapping for correction, not a blank project
  inventory form.

The developer should attach a sanitized excerpt when a full file contains
irrelevant or sensitive information. Never require the client to rediscover a
source already present in the repository.

## A short review session

A useful session is 30–45 minutes:

1. Spend five minutes confirming the goal and current active cards.
2. Review no more than three connected items.
3. For each item, ask for one real case and one meaningful exception.
4. Replay the understanding in plain language.
5. End by naming missing evidence, its provider, and the next decision owner.

Do not edit the ERD live as if the client were approving table design. Show the
relevant domain only after the business explanation is understood.

## After the session

The developer should:

1. add or link any evidence received;
2. write a concise outcome comment;
3. update the maintained current understanding;
4. record exceptions and unresolved questions;
5. identify which business rule or model concept is affected; and
6. move the item only if its workflow gate is satisfied.

Do this before the next review, but do not impose a fragile response-time
promise on a solo-developer workflow.

## Signs the process is becoming unfriendly

Pause and simplify when:

- more than three cards await one person;
- cards contain several unrelated questions;
- the client must read technical documentation before answering;
- the same information is requested twice;
- every answer creates several more forms;
- silence is treated as agreement; or
- Jira administration takes more effort than the discovery conversation.

The remedy is usually to prepare a proposed answer, ask for corrections, and
reduce the active set—not to create another field.

## Atlassian references

- [Create comments inside ideas](https://support.atlassian.com/jira-product-discovery/docs/create-comments-inside-ideas/)
- [Comment on views](https://support.atlassian.com/jira-product-discovery/docs/comment-views/)
- [Create insights in an idea](https://support.atlassian.com/jira-product-discovery/docs/create-insights-in-your-idea/)

