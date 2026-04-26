---
name: verify-work
description: Use before claiming work is done, fixed, passing, ready, reviewed, deployed, or complete. Requires fresh evidence from this session.
---

# Verify Work

## Purpose

Prove the exact claim before making it. This skill protects trust.

## Combines

- Superpowers `verification-before-completion`
- AI DevKit `verify`

## Iron Law

No completion claims without fresh verification evidence.

## Forbidden Completion Words Without Evidence

- should
- probably
- seems to
- likely
- I think it works
- I believe
- done
- fixed
- passing
- ready

## Gate Function

Run all five steps in order:

1. Identify the exact claim.
2. Identify the command or manual check that proves it.
3. Run the full command now.
4. Read the complete output and exit code.
5. Report the result with command, exit code, and key output.

If any step fails, do not claim success. State the actual status.

## Required Evidence By Claim

| Claim | Required Evidence |
|---|---|
| Tests pass | Test command output, zero failures, exit 0 |
| Build succeeds | Build command, exit 0 |
| Linter clean | Linter command, zero errors, exit 0 |
| Bug fixed | Original symptom now passes, ideally regression test |
| Feature works | Automated test or manual walkthrough evidence |
| Agent completed | Diff inspection plus verification command |
| Requirements met | Checklist mapped to evidence |

## Regression Verification For Bug Fixes

Best form:

1. Add test covering bug.
2. Run with fix, confirm pass.
3. Revert fix, confirm test fails.
4. Restore fix, confirm test passes.

If the test passes without the fix, the test does not prove the bug.

## Output Template

```markdown
## Verification

Claim: ...
Command: `...`
Exit code: ...
Key output: ...
Result: PASS | FAIL | INCONCLUSIVE
Next action: ...
```

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "I ran it earlier" | Code may have changed | Run it again |
| "CI will catch it" | CI is backup, not substitute | Verify locally first |
| "This is trivial" | Trivial changes break things | Run the smallest useful check |
