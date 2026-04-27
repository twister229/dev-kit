---
name: review-work
description: Use for code review, diff review, implementation review, or checking work against a plan before finishing. Findings first. Do not use for root-cause debugging or vague product shaping.
---

# Review Work

## Purpose

Find real implementation risks before handoff. Review is a gate for correctness, not a summary exercise.

## Combines

- Superpowers `requesting-code-review`
- AI DevKit `code-review`
- Spec-before-quality review discipline from `execute-work`

## When To Use

- User asks for a review, code review, diff review, or implementation check.
- After an implementation task before marking it complete.
- Before `finish-work` when no review evidence exists.
- Reviewing a diff against a plan, requirements, or acceptance criteria.
- Checking agent-produced work before trusting completion claims.

## When Not To Use

- Bug diagnosis or root-cause analysis: use `debug-root-cause`.
- Product or technical shaping: use `shape-work`.
- Implementation planning: use `plan-work`.
- Review feedback from another reviewer: use `review-feedback`.
- Documentation-only review: use `docs-review` unless the docs are part of an implementation diff.

## Hard Rules

- Findings come first, ordered by severity.
- Do not lead with praise or summaries before findings.
- Verify claims against the diff, plan, tests, and current code.
- Run spec compliance review before code quality review.
- Critical correctness, security, data-loss, or test-gap findings block completion.
- Use file and line references for findings when possible.
- Base reviews on local diffs, files, plans, and verification output. Do not require external services or network tools unless they are explicitly part of the review target.
- Flag unrelated edits, hidden assumptions, speculative features, and unnecessary abstractions as review findings.

## Workflow

1. Identify the review target.
   - Diff.
   - Files.
   - Plan task.
   - Branch.
2. Read relevant plan, requirements, or acceptance criteria when present.
3. Inspect changed files and tests.
4. Pass 1: spec compliance.
   - Requested behavior exists.
   - No unrequested scope expansion.
   - Acceptance criteria are covered.
5. Pass 2: code quality and risk.
   - Correctness.
   - Edge cases.
   - Security and data safety.
   - Maintainability and consistency.
   - Test quality and meaningful failures.
   - Unrelated edits, assumption leaks, speculative features, and avoidable abstraction.
6. Report findings with severity and file/line references.
7. If no findings, state that explicitly and name residual risks or verification gaps.

## Severity

- Critical: likely broken behavior, security issue, data loss, or invalid completion claim.
- High: important missed requirement, serious edge case, or missing test for risky behavior.
- Medium: maintainability or consistency issue that should be fixed before broadening scope.
- Low: polish or clarity issue that does not block completion.

## Output Template

```markdown
## Review Findings

Findings:
- Critical|High|Medium|Low: `file:line` ...

Open questions: ...
Residual risks: ...
Verification gaps: ...
Recommendation: BLOCK | FIX_THEN_CONTINUE | PASS_WITH_RISKS | PASS
```

## Evaluation Notes

- Trigger test: "Review this diff before I merge" should invoke `review-work`.
- Negative trigger test: "Why is this failing?" should invoke `debug-root-cause`, not `review-work`.
- Workflow test: A fresh agent can review against a plan without implementation context.
- Failure-mode test: Reviewer does not accept agent claims without checking diff and tests.
- Output test: Findings appear before summary and include severity.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Looks good overall" | Summaries hide blocking defects | List findings first |
| "The implementer said tests pass" | Agent reports are not evidence | Inspect diff and verification output |
| "Spec is close enough" | Wrong behavior is still wrong | Block on spec gaps before quality polish |
| "No tests because it is small" | Small risky changes still regress | Require meaningful evidence for the claim |
| "While I was here" | Drive-by edits hide risk and break ownership | Limit changes to the review target |
