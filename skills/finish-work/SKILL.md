---
name: finish-work
description: Use when a branch or task is ready for final review, commit, PR, or handoff. Runs final verification, reviews the diff, captures lessons, and prepares a clean summary.
---

# Finish Work

## Purpose

Finish like a professional. Verify, review, document what changed, capture durable lessons, and prepare the branch for handoff.

## Combines

- Superpowers `finishing-a-development-branch`
- Superpowers requesting/receiving code review
- AI DevKit code review and verify habits
- `capture-learning`

## When To Use

- Implementation tasks are complete.
- User asks to finish, commit, prepare PR, or review branch.
- Before handing off to another developer.
- Before opening a PR.

## Hard Rules

- Do not commit unless the user explicitly asked for a commit.
- Do not push unless the user explicitly asked to push.
- Do not create a PR unless the user explicitly asked for a PR.
- Do not claim readiness without `verify-work` evidence.
- Do not ignore unrelated dirty worktree changes. Identify and avoid touching them.
- If no implementation review evidence exists, use `review-work` before finishing.
- If unresolved review feedback exists, use `review-feedback` before finishing.

## Workflow

1. Inspect worktree.
   - Current branch.
   - Staged changes.
   - Unstaged changes.
   - Untracked files.
2. Review diff with `review-work` if no current review evidence exists.
   - User-visible behavior.
   - Requirements coverage.
   - Edge cases.
   - Test coverage.
   - Security or data risks.
   - Docs impact.
3. Run the check-implementation gate.
   - Compare the diff against the plan.
   - Compare implementation against design docs if present.
   - Check incomplete plan tasks.
   - Check scope expansion.
   - Check docs impact.
   - Check tests map to acceptance criteria.
4. Run final verification.
   - Tests.
   - Lint.
   - Build.
   - Any feature-specific checks.
5. Capture durable learning.
   - Root causes.
   - Project conventions.
   - Setup gotchas.
   - Non-obvious architecture constraints.
6. Prepare handoff.
   - Summary.
   - Verification evidence.
   - Risks.
   - Follow-ups.
7. If user requested commit or PR, perform only the requested action.

## Final Summary Template

```markdown
## Finish Summary

Changed: ...
Verification: ...
Review findings: ...
Implementation check: ...
Risks: ...
Learning captured: ...
Next action: ...
```

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Tests passed before" | Fresh evidence is required | Run current checks |
| "Just commit everything" | May include user or secret files | Inspect diff and stage intentionally |
| "PR summary can be vague" | Reviewers need context | Name behavior and evidence |
