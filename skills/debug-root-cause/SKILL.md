---
name: debug-root-cause
description: Use for bugs, regressions, failing tests, build failures, production issues, or unexpected behavior. Finds root cause before any fix and stores reusable incident knowledge after verification.
---

# Debug Root Cause

## Purpose

Fix bugs by proving what broke and why. No guessing. No symptom patches. No code changes until the root cause is understood.

## Combines

- Superpowers `systematic-debugging`
- AI DevKit `debug`
- AI DevKit `memory`
- `verify-work`

## Iron Law

No fixes without root cause investigation first.

## When To Use

- Bug report
- Failing test
- Build failure
- Performance problem
- Production incident
- Unexpected behavior
- Previous fix did not work

## When Not To Use

- The request is a planned new feature with no failing behavior: use `start-work` or `plan-work`.
- The user asks only for code review: use `review-work`.
- The root cause is already proven and a plan exists: use `tdd-work` or `execute-work`.
- The issue is vague product direction rather than broken behavior: use `shape-work`.

## Hard Rules

- Do not modify code during investigation.
- Do not propose a fix before reproducing or gathering evidence.
- Test one hypothesis at a time.
- If three fix attempts fail, stop and question the architecture.
- Use repo-local commands and evidence by default. Do not require network access, package-manager installs, or external systems unless the issue explicitly involves them and the user authorizes it.

## Workflow

1. Observed vs expected.
   - State the difference in one concise paragraph.
   - Define success criteria.

2. Search memory.
   - Search symptoms, subsystem, error text, and recent failure patterns.

3. Reproduce.
   - Capture exact command or user steps.
   - Capture environment details that matter.
   - If not reproducible, gather more data. Do not guess.

4. Read errors completely.
   - Stack traces.
   - Warnings.
   - Line numbers.
   - Exit codes.

5. Check recent changes.
   - Diff.
   - Recent commits.
   - Dependency or config changes.

6. Trace data flow.
   - Find where the bad value, state, or behavior first appears.
   - For multi-component systems (e.g., CI → build → signing, API → service → database), add diagnostic instrumentation before proposing fixes: log what enters and exits each component boundary, verify config and env propagation at each layer, run once to collect evidence, then identify the failing component.
   - Fix at the source, not at the symptom.

7. Compare with working examples.
   - Find similar working code.
   - List differences.

8. Form one hypothesis.
   - "I think X is root cause because Y."
   - Name predicted evidence and disconfirming evidence.

9. Test minimally.
   - One variable at a time.

10. Fix with regression coverage.
   - Write or identify failing signal.
   - Implement one root-cause fix.
   - Run `verify-work`.
   - If the fix does not work: stop. Return to step 8 with new information.
   - If three or more fix attempts have failed: stop and question the architecture. Ask whether the pattern is fundamentally sound or whether the system needs to be restructured rather than patched.

11. Store reusable learning.
   - Store root cause and fix only after verification.

## Output Template

```markdown
## Debug Report

Observed vs expected: ...
Reproduction: ...
Evidence: ...
Root cause: ...
Fix: ...
Verification: ...
Memory stored: yes/no
Remaining risks: ...
```

## Evaluation Notes

- Trigger test: "This test started failing" should invoke `debug-root-cause`.
- Negative trigger test: "Add a new export for X" should use `start-work` or `tdd-work`, not `debug-root-cause`.
- Workflow test: A fresh agent can reproduce, inspect evidence, form one hypothesis, and test it.
- Failure-mode test: The skill prevents code edits before root cause evidence exists.
- Output test: The debug report includes reproduction, evidence, root cause, fix, verification, and memory status.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "I know the cause" | Confidence is not evidence | Reproduce and prove it |
| "Quick fix first" | Symptom patches create new bugs | Trace root cause |
| "Try a few things" | Multiple variables hide truth | Test one hypothesis |
| "Emergency, no time for process" | Systematic is faster than guess-and-check thrashing | Follow the workflow |
| "Multiple fixes at once saves time" | Cannot isolate what worked; causes new bugs | One change at a time |
| "I'll write the test after the fix works" | Untested fixes do not stick | Write failing test first |
| "One more attempt" (after 2+ failures) | Three or more failures signals an architectural problem | Stop and question the pattern |
