---
name: auto-dev-loop
description: Use when the user wants an autonomous end-to-end development loop that starts from an intent, plans as needed, implements, reviews, fixes, and repeats verification until the work is complete or blocked. Do not use for simple questions, one-off reviews, or when the user asked only for a plan.
---

# Auto Dev Loop

## Purpose

Run the agentic development lifecycle without waiting for phase-by-phase prompts. Keep looping through scope, plan, implementation, review, fixes, verification, learning capture, and finish prep until there is fresh evidence that the work is complete or a real blocker requires the user.

## When To Use

- The user says `auto-dev-loop`, `autonomous loop`, `loop until complete`, `do everything`, or `run the full lifecycle`.
- The user wants a feature, fix, refactor, or docs update completed end-to-end without approving each phase.
- Requirements are clear enough to start, and remaining ambiguity can be resolved from repo evidence or safe defaults.

## When Not To Use

- The user asks only for brainstorming, a plan, a review, or an explanation.
- The next action is destructive, production-affecting, security-sensitive, or requires external credentials.
- The work involves irreversible data changes, billing, auth policy, migrations, or live deploys without explicit approval.
- The user has requested interactive checkpoints.

## Hard Rules

- Do not claim success without `verify-work` evidence from this session.
- Do not implement behavior changes without `tdd-work` unless the user explicitly approved skipping tests.
- Do not skip root cause analysis for bugs. Use `debug-root-cause` first.
- Do not continue after two failed fix attempts for the same underlying issue. Stop with evidence and options.
- Do not dispatch overlapping agents to edit the same files.
- Do not commit, push, deploy, or run destructive commands unless the user explicitly asked for that action.
- Prefer the smallest correct change. Do not expand scope just because the loop is autonomous.
- Stay offline and local by default. Do not use network access, credentials, package-manager installs, deploys, commits, or pushes without explicit user approval.
- Autonomy does not permit silently choosing when there is meaningful ambiguity. Stop for a decision or make a safe, explicit, reversible assumption.

## Workflow

1. Start with `start-work`.
   - Classify scope and risk.
   - Search memory and repo context before asking questions.
   - Convert weak goals like "make it work" into verifiable outcomes before implementation cycles.
   - Establish baseline checks when feasible.
2. Route to the lightest next workflow.
   - Vague direction: run `shape-work`, then continue.
   - Clear multi-step requirements: run `plan-work`.
   - Written plan already exists: run `execute-work`.
   - Bug, regression, failing test, or unexpected behavior: run `debug-root-cause`.
   - Behavior change or bug fix: run `tdd-work` inside implementation.
   - Tiny low-risk edit: implement directly, then jump to verification.
3. Implement in bounded cycles.
   - Pick the next incomplete task.
   - Make the minimal code or docs change.
   - Run the smallest useful task-level check.
   - Inspect the diff before moving on.
4. Review every completed implementation slice.
   - Run `review-work` for spec compliance first.
   - Then review code quality, maintainability, edge cases, and tests.
   - Convert findings into concrete fixes and loop back to step 3.
5. Verify before any completion claim.
   - Run `verify-work` for the exact claim.
   - If verification fails, identify whether the failure is baseline, implementation, test environment, or unclear requirements.
   - Fix implementation failures and rerun verification.
   - Stop after two failed attempts with the same root cause.
6. Capture durable lessons when useful.
   - Run `capture-learning` only for reusable project knowledge, root causes, entry points, or conventions.
   - Do not store transcripts, secrets, or one-off progress.
7. Finish cleanly.
   - Run `finish-work` when the branch/task is ready for handoff, commit, or PR prep.
   - Report changed files, verification commands, evidence, unresolved risks, and whether a commit/PR was intentionally not created.

## Loop Stop Conditions

Stop only when one of these is true:

- `verify-work` proves the requested outcome and no blocking review findings remain.
- A user decision is required for scope, product behavior, destructive actions, credentials, or external systems.
- Meaningful ambiguity cannot be resolved with safe, explicit, reversible assumptions.
- The same blocker remains after two focused fix attempts.
- Baseline checks are failing for reasons unrelated to this work and the user needs to choose whether to investigate or proceed.

## Output Template

```markdown
## Auto Dev Loop Result

Status: COMPLETE | BLOCKED | NEEDS_DECISION
Request: ...
Changed files: ...
Verification: command, exit code, key output
Review: findings fixed or no findings
Learning captured: yes/no, path if yes
Commit/PR: not created unless explicitly requested
Remaining risks: ...
Next action: ...
```

## Evaluation Notes

- Trigger test: `auto-dev-loop add support for X and keep going until verified` should invoke this skill.
- Trigger test: `run the full lifecycle for this bug until it passes` should invoke this skill and route through `debug-root-cause` plus `tdd-work`.
- Negative trigger test: `write a plan for X but do not implement` should use `plan-work`, not this skill.
- Negative trigger test: `review this diff` should use `review-work`, not this skill.
- Workflow test: A fresh agent can route vague, clear, bug, and tiny requests through the correct lifecycle skill, loop through review and verification, and stop at the defined stop conditions.
- Failure-mode test: if verification fails twice for the same cause, the skill must stop instead of thrashing.
- Output test: final response must include fresh verification evidence and must not say complete without it.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Autonomous means no questions ever" | Some decisions are product or safety calls | Stop only for explicit decision gates |
| "One big pass is faster" | Large unreviewed diffs hide bugs | Work in slices and review each slice |
| "Verification failed, but it is probably fine" | Failed evidence disproves completion | Fix, rerun, or report blocked |
| "The loop should also ship it" | Commit, push, and deploy are separate user-controlled actions | Prepare handoff unless explicitly asked |
