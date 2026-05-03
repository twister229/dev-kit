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

- Do not write placeholders: no "TBD", "TODO", "add validation", "handle edge cases", "similar to Task N", or any step that describes what to do without showing how.
- Do not write "add tests" without providing actual test code or an exact test command.
- Do not plan broad independent systems in one plan. Split them.
- Do not touch implementation code during this skill.
- Use repo-local evidence and existing project commands. Do not require package-manager installs, network access, or external CLIs unless already part of the project and explicitly approved.
- If exact files, commands, or requirements cannot be determined from repo evidence, ask instead of producing a speculative plan.
- Every task must state success criteria and the verification signal that proves them.
- If the spec covers multiple independent subsystems, suggest splitting into separate plans before writing tasks. Each plan should produce working, testable software on its own.

## Plan Location

Default: `docs/ai/planning/feature-<name>.md`

If the project already uses `docs/superpowers/plans/`, follow that existing convention instead.

## Workflow

1. Re-read the start brief, `shape-work` brief if present, requirements, design, and relevant docs.
2. Scope check.
   - If the spec covers multiple independent subsystems, list them and recommend the first to plan. Do not write cross-subsystem tasks in a single plan.
3. Map files before tasks.
   - Create.
   - Modify.
   - Test.
   - Documentation.
   - Design units with clear boundaries. Each file should have one clear responsibility.
4. Check design fit.
   - Does the design satisfy the requirement?
   - Are edge cases named?
   - Are rollback or migration concerns named?
5. Write bite-sized tasks.
   - One task should be independently reviewable.
   - Each task should include failing test, implementation, verification, and commit guidance when applicable.
   - Each task should transform the request into observable success criteria, not just implementation steps.
   - Repeat necessary context per task — agents read tasks independently.
6. Add acceptance checklist.
7. Self-review the plan.
   - Requirement coverage: can every requirement be traced to a task?
   - Placeholder scan: no TBD, "add validation", "similar to Task N", or steps missing code.
   - Type/name consistency: function names and signatures match across tasks.
   - Verification commands exist and are executable.
   - After writing, offer execution choice: subagent-per-task via `execute-work` or inline execution.

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
