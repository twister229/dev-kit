---
name: capture-learning
description: Use to document code entry points, store durable project knowledge, capture root causes, preserve conventions, or map unfamiliar modules.
---

# Capture Learning

## Purpose

Make knowledge compound. Capture what future sessions will reuse, and skip what they will not.

## Combines

- AI DevKit `memory`
- AI DevKit `capture-knowledge`
- Superpowers branch-finishing learning habits

## When To Use

- User asks to document or understand code.
- You discovered a durable project convention.
- After a non-obvious bug is fixed and verified, capture the reusable root cause or failure pattern.
- You found a setup gotcha.
- A module is important enough to map for future work.
- Finishing a feature revealed reusable decisions.

## When Not To Use

- Capturing one-off task progress, resumable handoff, or a session transcript: use `context-handoff` for paused work.
- Reviewing README, install docs, user guides, API docs, or public-facing docs: use `docs-review` unless the goal is durable internal implementation knowledge.
- Diagnosing an active bug or failing test: use `debug-root-cause` first.
- Storing unverified guesses, raw logs, or sensitive data.
- The user only needs implementation, review, or verification.
- Existing memory already covers the same knowledge.

## Hard Rules

- Do not store secrets, credentials, customer data, private data, raw logs, or transcripts.
- Do not store speculation.
- Do not store one-off task progress.
- Do not store entries like "I changed file X today" or "task 2 is done"; that is handoff/progress, not learning.
- Search before storing to avoid duplicates.
- Store only verified reusable knowledge.
- If evidence is only memory, assumption, or prior conversation, do not write the entry until current repo evidence confirms it.
- Use local Markdown files only. Do not require `npm`, `npx`, network calls, or a memory database.

## Offline Memory Locations

Prefer project-local memory under `docs/ai/memory/`:

- `docs/ai/memory/decisions.md`
- `docs/ai/memory/failure-patterns.md`
- `docs/ai/memory/project-conventions.md`
- `docs/ai/memory/setup-gotchas.md`

If the project does not use `docs/ai/`, use `.agentic-dev-system/memory/`.

## Memory Quality Gate

All must be true:

- Future sessions are likely to reuse it.
- It is verified by code, docs, tests, command output, or explicit user instruction.
- It is narrowly scoped.
- Existing memory does not already cover it.
- It contains no sensitive data.

## Workflow: Store Memory

1. Search existing local memory files for the same knowledge.
2. Choose narrowest useful scope.
   - Repo-specific.
   - Project-specific.
   - Global only if truly general.
3. Create the memory directory if needed.
4. Append an entry with this shape:

```markdown
## YYYY-MM-DD - <Title>

Scope: ...
Type: decision | failure-pattern | convention | setup-gotcha
Evidence: ...
Guidance: ...
Exceptions: ...
```

## Workflow: Capture Code Knowledge

1. Confirm entry point.
   - File.
   - Folder.
   - Function.
   - API.
2. Verify it exists.
3. Search existing docs and memory.
4. Analyze source context.
   - Purpose.
   - Exports.
   - Key flows.
   - Dependencies up to depth 3.
   - Error handling.
   - Performance and security considerations.
5. Write `docs/ai/implementation/knowledge-<name>.md` unless the project uses another docs convention.
6. Include mermaid diagrams when they clarify behavior.

## Output Template

```markdown
## Learning Captured

Type: Memory | Knowledge doc | Both
Scope: ...
Evidence: ...
Location: ...
Future use: ...
```

## Evaluation Notes

- Trigger test: "Document how this module works for future agents" should invoke `capture-learning`.
- Negative trigger test: "Save that I finished task 2" should not store memory.
- Workflow test: A fresh agent can search existing memory, verify evidence, and write a narrow Markdown entry.
- Failure-mode test: Secrets, raw logs, transcripts, and speculation are rejected.
- Output test: The result includes type, scope, evidence, location, and future use.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Save everything" | Noise makes memory useless | Store only reusable knowledge |
| "The code is self-documenting" | Future agents lack context | Capture why and flow |
| "This error might matter" | Raw errors are not learning | Store diagnosis after verification |
| "Use the memory CLI" | V2 must work offline | Write local Markdown memory |
