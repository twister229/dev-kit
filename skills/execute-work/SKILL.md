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

## When Not To Use

- Requirements are unclear or still being shaped: use `shape-work` or `plan-work` first.
- The request is a bug report without a proven root cause: use `debug-root-cause`.
- The task is tiny and safer inline: execute directly and use `verify-work`.
- The user asked only for review, planning, or explanation.

## Hard Rules

- Do not start on `main` or `master` without explicit user approval.
- Do not dispatch overlapping agents to edit the same files.
- Do not let implementer self-review replace independent review.
- Do not run code quality review before spec compliance review passes.
- Do not move to the next task while review issues remain open.
- Verify actual diff and commands. Agent success reports are not evidence.
- Use `tdd-work` for behavior changes unless the user explicitly approves an exception.
- Do not use `npm`, `npx`, or network tools for this dev-kit workflow. Use project-local commands only.

## Execution Modes

Sequential plan execution is the default. Use it when tasks touch shared files, depend on earlier tasks, or require one design thread.

Parallel independent-domain dispatch is allowed only when tasks are independent by file, subsystem, test file, or failure domain. Never parallelize agents that may edit the same files or shared state.

## Workflow

1. Read the full plan once.
2. Extract tasks into a local checklist.
3. For each task:
   - Provide the implementer with only the task, relevant plan context, file constraints, and verification command.
   - Implementer uses `tdd-work` for behavior changes.
   - Implementer runs task-level checks.
   - Spec reviewer checks plan compliance.
   - If spec review fails, return to implementer with exact gaps.
   - Code quality reviewer checks maintainability, simplicity, edge cases, and consistency.
   - If quality review fails, return to implementer with exact fixes.
   - Use `review-work` for the review gate when no specialized reviewer subagent is used.
   - Run `verify-work` evidence gate.
   - Update the plan with completion status, verification command/result, deviations, and concerns.
   - Mark task complete only after evidence exists.
4. After all tasks, run final integration verification.
5. Hand off to `finish-work`.

## Parallel Dispatch Rules

- Group work by independent domain.
- Give each agent one clear scope, exact constraints, and expected output.
- Include relevant errors, test names, and file paths in the prompt.
- Require each agent to report root cause, files changed, tests run, and concerns.
- After agents return, inspect diffs for conflicts before running integration checks.
- If two agents touched the same file unexpectedly, stop and reconcile before continuing.

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

## Output Template

```markdown
## Execution Report

Plan: ...
Tasks completed: ...
Review gates: spec compliance, code quality
Verification: command, exit code, key output
Plan updates: ...
Status: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
Next skill: `finish-work` | `debug-root-cause` | `review-feedback`
```

## Evaluation Notes

- Trigger test: "Execute this implementation plan" should invoke `execute-work`.
- Negative trigger test: "Write a plan for this" should invoke `plan-work`, not `execute-work`.
- Workflow test: A fresh agent can complete one plan task, run review gates, and update status.
- Failure-mode test: Spec review failures loop back before code quality review.
- Output test: The report includes task status, review gates, verification evidence, and next skill.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "The agent says it passed" | Agent claims are not proof | Inspect diff and run commands |
| "Spec is close enough" | Wrong feature is still wrong | Fix spec gaps first |
| "Parallel is faster" | File conflicts waste more time | Parallelize only independent scopes |
| "Plan updates can wait" | Stale plans break handoff | Update after each task |
