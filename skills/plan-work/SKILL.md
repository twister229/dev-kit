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
- A `shape-work` brief is ready to convert into tasks
- User asks for a plan
- Work should be delegated to agents

## When Not To Use

- Requirements are still vague or exploratory: use `shape-work` first.
- A written implementation plan is already ready: use `execute-work`.
- The user asked to implement immediately and the change is tiny: execute directly and use `verify-work`.
- The request is a bug report without root cause: use `debug-root-cause`.

## Hard Rules

- Do not write placeholders.
- Do not write "add tests" without actual test cases or commands.
- Do not plan broad independent systems in one plan. Split them.
- Do not touch implementation code during this skill.
- Use repo-local evidence and existing project commands. Do not require package-manager installs, network access, or external CLIs unless already part of the project and explicitly approved.
- If exact files, commands, or requirements cannot be determined from repo evidence, ask instead of producing a speculative plan.
- Every task must state success criteria and the verification signal that proves them.

## Plan Location

Default: `docs/ai/planning/feature-<name>.md`

If the project already uses `docs/superpowers/plans/`, follow that existing convention instead.

## Workflow

1. Re-read the start brief, `shape-work` brief if present, requirements, design, and relevant docs.
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
   - Each task should transform the request into observable success criteria, not just implementation steps.
5. Add acceptance checklist.
6. Self-review the plan.
   - Requirement coverage.
   - Placeholder scan.
   - Type/name consistency.
   - Verification commands exist.

## Output Template

Use this header and task template for implementation plans.

### Required Plan Header

```markdown
# <Feature Name> Implementation Plan

Goal: <one sentence>
User outcome: <what changes for the user>
Architecture: <2-3 sentences>
Risk: Tiny | Small | Feature | Risky
Execution: Use `execute-work` for task-by-task implementation.
Verification: Use `verify-work` before any completion claim.
```

### Task Template

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

## Evaluation Notes

- Trigger test: "Plan how to add X using these requirements" should invoke `plan-work`.
- Negative trigger test: "Implement this plan" should invoke `execute-work`, not `plan-work`.
- Workflow test: A fresh agent can execute each task from the plan without hidden context.
- Failure-mode test: Placeholder tasks like "add tests" are rejected.
- Output test: The plan names files, acceptance criteria, commands, and expected results.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Implementation details can be figured out later" | That moves planning risk into execution | Name files and commands now |
| "Similar to previous task" | Agents read tasks independently | Repeat necessary details |
| "Tests are obvious" | Obvious tests get skipped | Write exact test command |
