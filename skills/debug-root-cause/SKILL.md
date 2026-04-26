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

## Hard Rules

- Do not modify code during investigation.
- Do not propose a fix before reproducing or gathering evidence.
- Test one hypothesis at a time.
- If three fix attempts fail, stop and question the architecture.

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
   - For multi-component systems, instrument each boundary.

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

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "I know the cause" | Confidence is not evidence | Reproduce and prove it |
| "Quick fix first" | Symptom patches create new bugs | Trace root cause |
| "Try a few things" | Multiple variables hide truth | Test one hypothesis |
