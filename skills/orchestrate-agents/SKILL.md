---
name: orchestrate-agents
description: Use when coordinating multiple agents or parallel workstreams across research, implementation, review, QA, or documentation. Do not use for single-agent work, vague shaping, or overlapping edits to the same files.
---

# Orchestrate Agents

## Purpose

Coordinate multiple agents without collisions, duplicated work, or unverified claims. Decide whether parallelism is safe, assign bounded scopes, reconcile outputs, and route final work through review and verification.

## When To Use

- User asks to use multiple agents, subagents, parallel agents, or concurrent workstreams.
- Independent research, implementation, review, or QA streams can proceed without touching the same files.
- `execute-work` has independent plan tasks that could safely run in parallel.
- You need to reconcile outputs from agents before claiming completion.

## When Not To Use

- A single focused agent or direct edit is simpler.
- Workstreams may edit the same files or shared state without sequencing.
- Requirements are vague: use `shape-work` first.
- A bug lacks root cause: use `debug-root-cause` first.
- The user asked only for final review: use `review-work`.

## Hard Rules

- Do not dispatch overlapping agents to edit the same files.
- Every agent instruction must be self-contained.
- Track each agent's scope, files, expected output, and verification command.
- Agent success reports are not evidence. Inspect diffs and run verification.
- Stop and reconcile if two agents touch the same file unexpectedly.
- Use `worktree-work` first when parallel implementation needs separate filesystem contexts.
- Do not claim completion until `review-work` and `verify-work` evidence exists.
- Use local repository context and available agent mechanisms only. Do not require network or remote coordination unless the user explicitly requested it.
- If subagent tooling is unavailable or unsupported, fall back to serial execution instead of inventing orchestration.

## Workflow

1. Decide if orchestration is warranted.
   - Compare serial execution versus parallel dispatch.
   - Prefer serial work when file ownership is unclear.
2. Partition the work.
   - By file.
   - By subsystem.
   - By test target.
   - By research question.
   - By review domain.
3. Define agent contracts.
   - Scope.
   - Files allowed.
   - Files forbidden.
   - Expected output.
   - Verification command.
   - Stop conditions.
4. Dispatch only independent workstreams.
5. Collect outputs.
   - Status.
   - Files changed.
   - Tests or checks run.
   - Concerns.
   - Follow-ups.
6. Reconcile.
   - Inspect diffs.
   - Detect overlapping edits.
   - Resolve sequencing issues.
   - Convert concerns into concrete next actions.
7. Review and verify.
   - Use `review-work` for spec and quality review.
   - Use `verify-work` for the exact completion claim.
8. Hand off.
   - `execute-work` for remaining planned tasks.
   - `finish-work` when the branch is ready.

## Output Template

```markdown
## Agent Orchestration Plan

Mode: SERIAL | PARALLEL | MIXED
Reason: ...
Workstreams:
- Scope: ...
  Files allowed: ...
  Files forbidden: ...
  Expected output: ...
  Verification: ...
Reconciliation: ...
Next workflow: `execute-work` | `review-work` | `verify-work` | `finish-work`
```

## Evaluation Notes

- Trigger test: "Dispatch agents in parallel for these independent tasks" should invoke `orchestrate-agents`.
- Negative trigger test: "Implement this one function" should not invoke `orchestrate-agents`.
- Workflow test: A fresh agent can partition work into non-overlapping scopes with verification commands.
- Failure-mode test: Shared-file edits force serial execution or stop for reconciliation.
- Output test: The plan includes mode, reason, workstreams, file boundaries, verification, and next workflow.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Parallel is always faster" | Conflicts and duplicated work erase speed gains | Parallelize only independent scopes |
| "Agents can figure out boundaries" | Ambiguous ownership creates collisions | Assign exact files and stop conditions |
| "They said it passed" | Agent reports are not proof | Inspect diffs and verify locally |
| "We can reconcile later" | Late conflicts are expensive | Reconcile immediately after outputs return |
