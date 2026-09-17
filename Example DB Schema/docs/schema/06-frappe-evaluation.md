# Frappe boundary — recorded decision

- **Status:** Decided for the current discovery and prototype phase
- **Owner:** Developer / architecture
- **Decision date:** 2026-09-14

The supplied `frappe_docker` repository is disregarded as an ERP application
platform, canonical data model, backend, or integration target. The custom
PostgreSQL model remains the source-of-truth candidate, and architecture is
managed by the developer.

## Permitted future use

When frontend work begins, selected Frappe screens may be inspected only as
UI/UX references, for example:

- dense business forms and field grouping;
- navigation and workspace organization;
- workflow/status presentation;
- attachments and activity history;
- role/permission affordances; and
- list, filter, and reporting interactions.

Adopting an interaction does not adopt its DocType, persistence model,
framework, terminology, or workflow rule. Every interaction must be justified
against an agreed ERP requirement.

## Work explicitly avoided

- mapping the canonical schema to Frappe DocTypes;
- testing Frappe as the system of record;
- adapting business rules to fit stock Frappe behavior;
- maintaining two writable sources for the same fact;
- investing discovery time in Frappe deployment or upgrade strategy; and
- asking the client to choose between technical platform options.

## Reopening condition

Reconsidering Frappe as a platform would require a new, explicit architecture
decision initiated by the developer and supported by materially new evidence.
It is not part of the Client Review workflow.
