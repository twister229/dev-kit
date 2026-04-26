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

## When To Use

- Before saying work is done, fixed, passing, ready, complete, reviewed, or deployed.
- After implementing a task or resolving review feedback.
- Before handing off work, opening a PR, or claiming a bug is fixed.
- When another agent or tool reports success and you need local evidence.

## When Not To Use

- To choose what to build or how to fix something.
- As a substitute for `debug-root-cause` when a failure has not been diagnosed.
- As a substitute for `review-work` when correctness needs human-style inspection.

## Hard Rules

- Verification evidence must be fresh from the current session.
- The command or manual check must prove the exact claim, not a nearby claim.
- If verification is inconclusive, report `INCONCLUSIVE` and do not claim success.
- Do not hide failures inside summaries.
- Use existing local project commands and manual checks by default. Do not require external services, network access, or remote CI unless the exact claim depends on them and the user authorizes it.

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

## Workflow

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

## Evaluation Notes

- Trigger test: "Can I say this is ready?" should invoke `verify-work`.
- Negative trigger test: "Why is this test failing?" should invoke `debug-root-cause`, not `verify-work` alone.
- Workflow test: A fresh agent can identify a claim, run the proving command, and report exit code.
- Failure-mode test: A failed command blocks completion language.
- Output test: The report includes claim, command, exit code, key output, result, and next action.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "I ran it earlier" | Code may have changed | Run it again |
| "CI will catch it" | CI is backup, not substitute | Verify locally first |
| "This is trivial" | Trivial changes break things | Run the smallest useful check |
| "I saw enough output" | Truncated output may hide failures | Read the complete output and exit code |
