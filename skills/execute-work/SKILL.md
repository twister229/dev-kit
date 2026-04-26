---
name: execute-work
description: Use when a written implementation plan is ready. Executes task-by-task with fresh implementation context, orchestration, spec review, code quality review, and verification gates.
---

# Execute Work

## Purpose

Turn a plan into working code without context pollution. Each non-trivial task gets fresh implementation context and review before moving on.

## Combines

- Superpowers `subagent-driven-development`
- Superpowers `executing-plans`
- AI DevKit `agent-orchestration`
- AI DevKit `verify`

## When To Use

- A plan file exists.
- Tasks are ready to implement.
- Multiple agents are running or useful.
- Work is too large for one uninterrupted inline edit.

## Hard Rules

- Do not start on `main` or `master` without explicit user approval.
- Do not dispatch overlapping agents to edit the same files.
- Do not let implementer self-review replace independent review.
- Do not run code quality review before spec compliance review passes.
- Do not move to the next task while review issues remain open.
- Verify actual diff and commands. Agent success reports are not evidence.

## Workflow

1. Read the full plan once.
2. Extract tasks into a local checklist.
3. For each task:
   - Provide the implementer with only the task, relevant plan context, file constraints, and verification command.
   - Implementer writes tests first when applicable.
   - Implementer runs task-level checks.
   - Spec reviewer checks plan compliance.
   - If spec review fails, return to implementer with exact gaps.
   - Code quality reviewer checks maintainability, simplicity, edge cases, and consistency.
   - If quality review fails, return to implementer with exact fixes.
   - Run `verify-work` evidence gate.
   - Mark task complete only after evidence exists.
4. After all tasks, run final integration verification.
5. Hand off to `finish-work`.

## Agent Orchestration Rules

- Always list current agents before sending instructions.
- Every instruction must be self-contained.
- Track sent instructions. Do not duplicate prompts.
- Keep agents on non-overlapping files unless sequenced.
- Escalate only for product judgment, architecture decisions, destructive actions, security-sensitive changes, or unresolved agent failure after two corrective attempts.

## Status Values

Implementers and reviewers must report one of:

- `DONE`
- `DONE_WITH_CONCERNS`
- `NEEDS_CONTEXT`
- `BLOCKED`

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "The agent says it passed" | Agent claims are not proof | Inspect diff and run commands |
| "Spec is close enough" | Wrong feature is still wrong | Fix spec gaps first |
| "Parallel is faster" | File conflicts waste more time | Parallelize only independent scopes |
