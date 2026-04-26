---
name: context-handoff
description: Use when saving or restoring one-off working context for a paused task, long session, context-limit handoff, or another agent taking over. Do not use for durable project knowledge; use `capture-learning` instead.
---

# Context Handoff

## Purpose

Preserve enough current working context for a future agent or developer to resume safely without turning one-off progress into permanent memory.

## When To Use

- User asks to save state, create a handoff, pause work, resume later, or prepare another agent to take over.
- Context is getting long and a fresh session may need to continue.
- Work is in progress and not ready for `finish-work`.
- A blocker or decision pause needs a factual current-state summary.

## When Not To Use

- Capturing durable project conventions, root causes, setup gotchas, or code maps: use `capture-learning`.
- Final branch readiness, commit, PR, or completed-work handoff: use `finish-work`.
- Code review, verification, or planning as the primary request.
- Storing secrets, credentials, transcripts, raw logs, or private data.

## Hard Rules

- Do not store secrets, credentials, tokens, private data, transcripts, or raw logs.
- If raw logs, transcripts, secrets, credentials, or private data are present, record only a safe summary and omit the sensitive details.
- Do not record guesses as facts. Mark uncertain items as unknown or needing verification.
- Inspect current git/worktree state before writing a handoff.
- Separate completed work, pending work, blockers, and next recommended skill.
- Do not use this as durable memory. If knowledge will matter across future work, use `capture-learning` separately.
- Do not claim work is done unless `verify-work` evidence exists.
- Do not run `verify-work` just to create a handoff unless the user requested a readiness claim; otherwise list prior evidence or mark verification as not run.

## Workflow

1. Identify whether the user wants to save context, restore context, or both.
2. Inspect current state.
   - Branch or worktree.
   - Staged, unstaged, and untracked files.
   - Relevant plan or task file.
3. Summarize the active goal and scope boundaries.
4. List completed work with evidence.
5. List pending work as concrete next actions.
6. List touched files and why each matters.
7. List commands run, exit status, and important output.
8. Name blockers, open questions, and decisions needed.
9. Recommend the next skill: `execute-work`, `debug-root-cause`, `review-work`, `verify-work`, `finish-work`, or another specific skill.
10. If saving to disk, use a local Markdown handoff path such as `docs/ai/handoffs/YYYY-MM-DD-<topic>.md` unless the project has another convention.
11. If restoring from an existing handoff, read the handoff, inspect current state, summarize mismatches, and recommend the next safe action before continuing.

## Output Template

```markdown
## Context Handoff

Goal: ...
Current state: branch/worktree, dirty files, plan path
Completed: ...
Pending: ...
Files touched: ...
Commands run: command, exit code, key output
Blockers/questions: ...
Next skill: ...
Saved to: path or not saved
```

## Evaluation Notes

- Trigger test: "Save state so another agent can continue later" should invoke `context-handoff`.
- Negative trigger test: "Remember this project convention for future sessions" should invoke `capture-learning`, not `context-handoff`.
- Workflow test: A fresh agent can resume from the handoff without needing the transcript.
- Failure-mode test: Secrets, raw logs, transcripts, and unverified success claims are rejected.
- Output test: The handoff names current state, completed work, pending work, files, commands, blockers, and next skill.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Save everything" | Transcripts and noise make handoff unsafe | Save only resumable working context |
| "This belongs in memory" | One-off progress pollutes durable knowledge | Use `capture-learning` only for reusable facts |
| "It is probably done" | Future agents need evidence, not optimism | Include verification output or mark unverified |
