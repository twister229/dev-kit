---
name: review-feedback
description: Use when receiving code review feedback, PR comments, outside model suggestions, or user critique. Evaluates feedback technically before implementing.
---

# Review Feedback

## Purpose

Handle review feedback with technical rigor. Feedback is input to evaluate, not an order to blindly follow.

## When To Use

- PR review comments
- User asks to address review feedback
- Outside model suggests changes
- Reviewer reports bugs or missing tests
- Feedback seems unclear, broad, or technically questionable

## When Not To Use

- The user asks for an initial code review: use `review-work`.
- The user reports a bug without reviewer feedback: use `debug-root-cause`.
- The user asks to finish a branch after feedback is resolved: use `finish-work`.
- The feedback is purely documentation review with no implementation impact: use `docs-review`.

## Hard Rules

- Read all feedback before implementing anything.
- Clarify unclear feedback before partial implementation.
- Verify external feedback against the current codebase.
- Push back when feedback is technically wrong, breaks existing behavior, violates YAGNI, or conflicts with prior decisions.
- Implement one feedback item at a time.
- Run verification after each item or small related group.
- Do not use performative agreement such as "absolutely right" or "great point".

## Workflow

1. List every feedback item.
2. Restate each item as a concrete technical requirement.
3. Identify unclear items and ask before implementing if ambiguity changes the solution.
4. Check the codebase for each external suggestion.
5. Classify each item:
   - Accept
   - Reject with technical reason
   - Needs clarification
   - Defer because out of scope
6. Implement accepted items in priority order:
   - Blocking correctness or security issues
   - Simple local fixes
   - Larger refactors
7. Use `tdd-work` for behavior changes.
8. Use `verify-work` before reporting completion.
9. Summarize what changed and what was not changed.

## Pushback Triggers

- Suggestion breaks existing tests or shipped behavior.
- Suggestion adds unused functionality.
- Suggestion assumes a different stack or platform.
- Suggestion conflicts with explicit user direction.
- Suggestion cannot be verified from available code or docs.
- Suggestion expands scope without clear user benefit.

## Output Template

```markdown
## Review Feedback Plan

Feedback items:
- ...

Accepted:
- ...

Needs clarification:
- ...

Pushing back:
- ...

Implementation order:
1. ...

Verification:
- ...
```

## Evaluation Notes

- Trigger test: "Address these PR comments" should invoke `review-feedback`.
- Negative trigger test: "Review my diff" should invoke `review-work`, not `review-feedback`.
- Workflow test: A fresh agent can classify each feedback item before implementing.
- Failure-mode test: Technically wrong or scope-expanding feedback is pushed back with evidence.
- Output test: The plan lists accepted, clarification, pushback, implementation order, and verification.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Reviewer said it, so do it" | Reviewers miss context | Verify in codebase |
| "I'll fix the clear ones first" | Unclear items may affect the clear ones | Clarify first when related |
| "This sounds more professional" | Professional can mean overbuilt | Check actual usage |
| "No need to test a review fix" | Review fixes break things too | Verify each change |
