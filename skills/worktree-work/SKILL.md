---
name: worktree-work
description: Use when creating, selecting, verifying, or cleaning up an isolated git worktree or branch for development work. Do not use for implementation itself, code review, or destructive git cleanup without explicit approval.
---

# Worktree Work

## Purpose

Keep non-trivial work isolated from the main workspace. Choose a safe branch or worktree context, verify it, and hand back to the normal development workflow before implementation begins.

## When To Use

- User asks for a worktree, isolated branch, safe workspace, or separate development context.
- `start-work` recommends isolation for feature, risky, or multi-step work.
- Multiple agents or parallel workstreams need separate filesystem contexts.
- You need to resume work in an existing worktree and verify the active context.

## When Not To Use

- Tiny edits with no isolation value.
- Implementing the feature itself: use `tdd-work`, `execute-work`, or direct edit plus `verify-work`.
- Reviewing code: use `review-work`.
- Debugging root cause: use `debug-root-cause`.
- Deleting branches or worktrees unless the user explicitly approves cleanup.

## Hard Rules

- Never run destructive git cleanup without explicit user approval.
- Do not switch branches or create a worktree until the target branch/path is clear.
- Verify the current branch and worktree list before changing context.
- If using a project-local worktree directory, verify it is ignored before creating files there.
- Do not overwrite an existing worktree path.
- After setup, report the exact path and branch that future commands should use.
- If the worktree is dirty or the target branch/path is ambiguous, ask before changing context.

## Workflow

1. Identify the isolation need.
   - Feature work.
   - Risky change.
   - Parallel agent work.
   - Resume existing isolated context.
2. Inspect current context.
   - Current branch with `git status --short --branch`.
   - Existing worktrees with `git worktree list`.
   - Worktree parent directory convention.
   - Dirty worktree status.
3. Choose target.
   - Prefer existing matching worktree when present.
   - Otherwise prefer `.worktrees/<branch-name>` if `.worktrees/` is ignored.
   - Fall back to a normal branch only when worktrees are unnecessary or unavailable.
4. Safety check before creation.
   - Confirm parent path exists or create only the intended parent.
   - Confirm the destination path does not exist.
   - Confirm ignored status for project-local worktree directories with `git check-ignore <path>` or repository ignore rules.
5. Create or select the context.
   - Use non-interactive git commands only.
   - Do not modify unrelated dirty files.
6. Run project setup in the new context.
   - Auto-detect from project files: `package.json` → `npm install`; `Cargo.toml` → `cargo build`; `requirements.txt` → `pip install -r requirements.txt`; `pyproject.toml` → `poetry install`; `go.mod` → `go mod download`.
   - Skip if no matching project file is found.
7. Verify clean baseline.
   - Run the project's test command.
   - If tests fail: report failures and ask whether to proceed or investigate before continuing.
   - If tests pass: report ready.
8. Verify context.
   - Branch name.
   - Worktree path.
   - `git status --short --branch` in the target context.
9. Hand off to the next workflow.
   - `start-work` for scoping.
   - `plan-work` for sequencing.
   - `execute-work` or `tdd-work` for implementation.

## Output Template

```markdown
## Worktree Context

Status: CREATED | SELECTED | BLOCKED
Branch: ...
Path: ...
Current status: ...
Safety checks: ...
Next workflow: `start-work` | `plan-work` | `execute-work` | `tdd-work`
```

## Evaluation Notes

- Trigger test: "Create an isolated worktree for this feature" should invoke `worktree-work`.
- Negative trigger test: "Implement task 1" should invoke `execute-work` or `tdd-work`, not `worktree-work`.
- Workflow test: A fresh agent can inspect existing worktrees, choose a path, create/select it, and report context.
- Failure-mode test: Existing destination paths and non-ignored `.worktrees/` directories stop before creation.
- Output test: The result includes branch, path, status, safety checks, and next workflow.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "I can just switch branches" | Dirty worktrees and other agents may be active | Inspect status and worktrees first |
| "The path probably does not exist" | Overwriting work loses work | Verify destination before creation |
| "Cleanup is obvious" | Deleting worktrees or branches can destroy work | Ask before destructive cleanup |
| "Isolation means implementation" | Context setup and code changes are separate | Hand off after verifying context |
