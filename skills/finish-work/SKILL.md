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
- Work is completed or believed complete and being prepared for final handoff.
- User asks to finish, commit, prepare PR, or review branch.
- Before handing off to another developer.
- Before opening a PR.

## When Not To Use

- Implementation is still actively in progress and the user is asking to pause or resume later: use `context-handoff`.
- Work is paused or in progress and needs resumable context: use `context-handoff`.
- The user asks only for a code review: use `review-work`.
- The user asks only to verify one claim: use `verify-work`.
- The user asks only for changelog, release notes, migration notes, or upgrade guidance: use `release-notes`.
- The user asks to plan or shape future work rather than finish current work.

## Hard Rules

- Do not commit unless the user explicitly asked for a commit.
- Do not push unless the user explicitly asked to push.
- Do not create a PR unless the user explicitly asked for a PR.
- Do not claim readiness without `verify-work` evidence.
- Do not ignore unrelated dirty worktree changes. Identify and avoid touching them.
- If no implementation review evidence exists, use `review-work` before finishing.
- If unresolved review feedback exists, use `review-feedback` before finishing.
- Use repository-local verification commands from project docs or config. Do not require network access, external services, commits, pushes, or PR creation unless the user explicitly requested that finish action.

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
   - If verification fails, report the failure and do not claim readiness.
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
   - If release communication is requested, use `release-notes`.
7. If user requested commit or PR, perform only the requested action.

## Output Template

```markdown
## Finish Summary

Changed: ...
Status: ready | blocked | needs fixes, with reason
Verification: ...
Review findings: ...
Implementation check: ...
Risks: ...
Learning captured: ...
Next action: ...
```

## Evaluation Notes

- Trigger test: "Finish this branch and prepare a handoff" should invoke `finish-work`.
- Negative trigger test: "Implement task 3" should invoke `execute-work` or `tdd-work`, not `finish-work`.
- Workflow test: A fresh agent can inspect worktree, review diff, verify, and produce handoff notes.
- Failure-mode test: Commit, push, and PR creation do not happen without explicit user request.
- Output test: The summary includes changed work, verification, review, risks, learning, and next action.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Tests passed before" | Fresh evidence is required | Run current checks |
| "Just commit everything" | May include user or secret files | Inspect diff and stage intentionally |
| "PR summary can be vague" | Reviewers need context | Name behavior and evidence |
