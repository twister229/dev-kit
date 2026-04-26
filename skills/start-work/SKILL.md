---
name: start-work
description: Use when starting a new feature, unclear request, or multi-step task. Converts intent into scoped work, searches memory, sets up safe context, and decides whether the full lifecycle is needed.
---

# Start Work

## Purpose

Start work without guessing. Understand the user goal, classify risk and size, search durable memory, and choose the lightest workflow that will still produce correct software.

## Combines

- Superpowers brainstorming and worktree-first habits
- AI DevKit `dev-lifecycle` phase 1 and memory search

## When To Use

- New feature request
- Vague product or technical request
- Multi-step implementation
- Existing feature needs extension
- User says "start", "build", "add", "implement", or "create" and scope is not trivial

## When Not To Use

- User asks only for an explanation, review, or brainstorming with no intent to implement.
- A written implementation plan is already ready: use `execute-work`.
- A bug, regression, failing test, or unexpected behavior is the core request: use `debug-root-cause`.
- User asks to save paused progress, resume context, or hand off incomplete work: use `context-handoff`.
- User asks to add, remove, update, audit, or diagnose dependencies: use `dependency-work`.
- The task is a tiny obvious edit with a clear check: make the change directly and use `verify-work`.

## Routing Table

| User Intent | Skill |
|---|---|
| Build, add, implement, or create non-trivial work | `start-work` |
| Think through an unclear idea | `shape-work` |
| Write an implementation plan | `plan-work` |
| Execute an existing plan | `execute-work` |
| Debug a bug, failing test, regression, or error | `debug-root-cause` |
| Add or change behavior safely | `tdd-work` |
| Review a diff, PR, or implementation | `review-work` |
| Evaluate received review comments | `review-feedback` |
| Prove work is done, fixed, or passing | `verify-work` |
| Simplify or refactor for maintainability | `simplify-work` |
| Review or improve documentation | `docs-review` |
| Store verified reusable project knowledge | `capture-learning` |
| Save or restore paused session context | `context-handoff` |
| Add, remove, update, audit, or diagnose dependencies | `dependency-work` |
| Write changelog, release notes, migration notes, or upgrade guidance | `release-notes` |
| Finish branch, final review, commit, PR, or handoff prep | `finish-work` |
| Create or improve skills | `writing-skills` |
| Run the lifecycle autonomously until verified or blocked | `auto-dev-loop` |

## Hard Rules

- Do not code during this skill.
- Do not create heavy lifecycle docs for tiny tasks.
- Do not ask questions already answered by repo docs, memory, or code.
- If a worktree is available and the change is non-trivial, prefer an isolated worktree or branch.
- Do not rely on `npm`, `npx`, network fetches, or external CLIs for dev-kit behavior. This kit must remain offline-installable.

## Workflow

1. Classify the request.
   - Tiny: one file, low risk, obvious verification.
   - Small: 1-3 files, moderate clarity.
   - Feature: multiple files or user-visible behavior.
   - Risky: auth, payments, data loss, security, migrations, production systems.

2. Search memory before asking.
   - Search local memory files if present: `docs/ai/memory/*.md` and `.agentic-dev-system/memory/*.md`.
   - Search by feature name, subsystem, error text, framework, and task intent.
   - Use memory only as context. Fresh repo evidence and user instructions win.

3. Inspect project context.
   - Read `AGENTS.md`, `README.md`, and relevant docs if present.
   - Identify existing patterns before proposing new structure.

4. Decide the workflow.
   - Tiny: direct change plus `verify-work`.
   - If a tiny task does not need scoping, exit this skill immediately, make the direct change, then use `verify-work`.
   - Vague product or technical direction: `shape-work` before planning.
   - Small: lightweight `plan-work` checklist, then execute inline.
   - Feature: `plan-work` with exact tasks.
   - Risky: full lifecycle docs and explicit approval before implementation.
   - Clear behavior changes with known scope may route directly to `tdd-work`; use `start-work` when scope, risk, workflow, or decomposition must be decided first.

5. For non-trivial work, prepare isolation.
   - Prefer an existing `.worktrees/` directory, then `worktrees/`.
   - If project instructions name a worktree location, follow that.
   - If using a project-local worktree directory, verify it is ignored with `git check-ignore`.
   - If it is not ignored, ask before modifying `.gitignore`.
   - If no worktree is used, state why.

6. Establish a clean baseline.
   - Identify the project’s existing verification commands from docs or config.
   - Run the smallest useful baseline check before implementation when feasible.
   - If baseline fails, stop and ask whether to investigate or proceed with known failures.

7. Produce the start brief.
   - Goal.
   - User-visible outcome.
   - Scope boundaries.
   - Known constraints.
   - Recommended next skill.

## Output Template

```markdown
## Start Brief

Goal: ...
User outcome: ...
Scope: ...
Risk level: Tiny | Small | Feature | Risky
Evidence checked: ...
Memory applied: ...
Isolation: worktree | branch | current workspace, reason ...
Baseline: command/result or not run because ...
Recommended workflow: ...
Next skill: `shape-work` | `plan-work` | `debug-root-cause` | `verify-work` | direct execution
```

## Evaluation Notes

- Trigger test: "Start building a user settings page" should invoke `start-work`.
- Negative trigger test: "Review this diff" should invoke `review-work`, not `start-work`.
- Workflow test: A fresh agent can produce a start brief without editing code.
- Failure-mode test: Baseline failures stop the workflow instead of being ignored.
- Output test: The brief names risk, evidence checked, isolation, baseline, and next skill.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Just start coding" | Ambiguity becomes rework | Classify scope first |
| "Everything needs full docs" | Process becomes theater | Use full lifecycle only when risk justifies it |
| "Memory says X" | Memory can be stale | Verify against current repo |
