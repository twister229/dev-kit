---
name: plan-work
description: Use when requirements exist and a multi-step implementation needs sequencing. Produces exact, executable tasks with files, tests, commands, and expected output.
---

# Plan Work

## Purpose

Create an implementation plan that an agent or developer can execute without hidden context. The plan must name exact files, exact tests, exact commands, and expected results.

## Combines

- Superpowers `writing-plans`
- AI DevKit requirement/design review from `dev-lifecycle`

## When To Use

- Multi-file feature
- Risky change
- Existing requirements or design need implementation tasks
- User asks for a plan
- Work should be delegated to agents

## Hard Rules

- Do not write placeholders.
- Do not write "add tests" without actual test cases or commands.
- Do not plan broad independent systems in one plan. Split them.
- Do not touch implementation code during this skill.

## Plan Location

Default: `docs/ai/planning/feature-<name>.md`

If the project already uses `docs/superpowers/plans/`, follow that existing convention instead.

## Workflow

1. Re-read the start brief, requirements, design, and relevant docs.
2. Map files before tasks.
   - Create.
   - Modify.
   - Test.
   - Documentation.
3. Check design fit.
   - Does the design satisfy the requirement?
   - Are edge cases named?
   - Are rollback or migration concerns named?
4. Write bite-sized tasks.
   - One task should be independently reviewable.
   - Each task should include failing test, implementation, verification, and commit guidance when applicable.
5. Add acceptance checklist.
6. Self-review the plan.
   - Requirement coverage.
   - Placeholder scan.
   - Type/name consistency.
   - Verification commands exist.

## Required Plan Header

```markdown
# <Feature Name> Implementation Plan

Goal: <one sentence>
User outcome: <what changes for the user>
Architecture: <2-3 sentences>
Risk: Tiny | Small | Feature | Risky
Execution: Use `execute-work` for task-by-task implementation.
Verification: Use `verify-work` before any completion claim.
```

## Task Template

````markdown
## Task N: <Name>

Files:
- Create: `path/to/file`
- Modify: `path/to/file`
- Test: `path/to/test`

Acceptance:
- [ ] <specific observable behavior>

Steps:
- [ ] Write failing test

```<language>
<test code or exact test shape>
```

- [ ] Run test and confirm failure

Command: `<command>`
Expected: fails because `<reason>`

- [ ] Implement minimal change

```<language>
<implementation sketch or exact code when useful>
```

- [ ] Run verification

Command: `<command>`
Expected: pass, exit 0
````

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Implementation details can be figured out later" | That moves planning risk into execution | Name files and commands now |
| "Similar to previous task" | Agents read tasks independently | Repeat necessary details |
| "Tests are obvious" | Obvious tests get skipped | Write exact test command |
