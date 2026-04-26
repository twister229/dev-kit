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

## Hard Rules

- Do not code during this skill.
- Do not create heavy lifecycle docs for tiny tasks.
- Do not ask questions already answered by repo docs, memory, or code.
- If a worktree is available and the change is non-trivial, prefer an isolated worktree or branch.

## Workflow

1. Classify the request.
   - Tiny: one file, low risk, obvious verification.
   - Small: 1-3 files, moderate clarity.
   - Feature: multiple files or user-visible behavior.
   - Risky: auth, payments, data loss, security, migrations, production systems.

2. Search memory before asking.
   - Search by feature name, subsystem, error text, framework, and task intent.
   - Use memory only as context. Fresh repo evidence and user instructions win.

3. Inspect project context.
   - Read `AGENTS.md`, `README.md`, and relevant docs if present.
   - Identify existing patterns before proposing new structure.

4. Decide the workflow.
   - Tiny: direct change plus `verify-work`.
   - Small: lightweight `plan-work` checklist, then execute inline.
   - Feature: `plan-work` with exact tasks.
   - Risky: full lifecycle docs and explicit approval before implementation.

5. Produce the start brief.
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
Recommended workflow: ...
Next skill: `plan-work` | `debug-root-cause` | `verify-work` | direct execution
```

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Just start coding" | Ambiguity becomes rework | Classify scope first |
| "Everything needs full docs" | Process becomes theater | Use full lifecycle only when risk justifies it |
| "Memory says X" | Memory can be stale | Verify against current repo |
