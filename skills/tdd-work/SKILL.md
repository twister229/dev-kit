---
name: tdd-work
description: Use when implementing new behavior, fixing bugs, or refactoring behavior. Requires a failing test before production code and red-green-refactor verification.
---

# TDD Work

## Purpose

Use tests to define behavior before implementation. The test is the spec. If it never failed, it did not prove anything.

## When To Use

- New behavior
- Bug fixes
- Behavior-changing refactors
- Planned implementation tasks with acceptance criteria
- Regression coverage for a root-cause fix

## When Not To Use

- Documentation-only changes, unless docs examples are executable behavior.
- Pure formatting or mechanical renames with no behavior change.
- Exploratory shaping or planning before behavior is defined.
- Broken behavior without a known root cause: use `debug-root-cause` first.

## Exceptions

Ask before skipping TDD for:

- Throwaway prototypes
- Generated code
- Pure configuration changes
- Documentation-only changes

## Iron Law

No production code without a failing test first.

If production code was written before its test, delete it and start over from the failing test. Keeping it as reference is still test-after.

## Hard Rules

- Test behavior, not internals.
- Name the test after what the system should do.
- One behavior per test.
- The failure must be meaningful: missing behavior, wrong return value, unmet condition.
- If the test passes immediately, it is not testing new behavior.
- If the test fails because of syntax or setup, fix setup and rerun until it fails for the intended reason.
- Convert imperative requests into a behavior statement and failing signal before production code.

## Workflow

1. Pick one unit of behavior and state it as an observable behavior statement.
2. Write the smallest test or reproducible failing signal that describes that behavior.
3. Run the test and confirm it fails for the right reason.
4. Write the minimum production code to pass.
5. Run the test and confirm it passes.
6. Refactor only after green.
7. Run the test again after refactor.
8. Repeat for the next behavior.
9. Use `verify-work` before making any completion claim.

## Red Rules

- Red means the test fails for the intended behavior reason.
- Setup or syntax failures are not a valid red state.
- Passing immediately means the test does not prove new behavior.

## Green Rules

- Write the simplest code that passes.
- Do not add untested branches, options, or abstractions.
- Do not refactor during green.
- If another test breaks, fix it before continuing.

## Refactor Rules

- Refactor only after tests pass.
- Remove real duplication, not predicted duplication.
- Improve names and structure without changing behavior.
- Run tests after each meaningful refactor move.

## Offline Verification

Use the project’s existing test command. If unknown, inspect project files and docs. If still unknown, ask for the correct command before claiming success.

Do not use `npm`, `npx`, or any network command unless the project already requires it and the user approves. This dev-kit itself must remain offline-installable.

## Output Template

```markdown
## TDD Result

Behavior: ...
Red command: `...`
Red result: failed because ...
Green command: `...`
Green result: passed, exit ...
Refactor verification: ...
Remaining behavior: ...
```

## Evaluation Notes

- Trigger test: "Implement this new behavior" should invoke `tdd-work`.
- Negative trigger test: "Review this implementation" should invoke `review-work`, not `tdd-work`.
- Workflow test: A fresh agent can show red, green, and post-refactor verification commands.
- Failure-mode test: A test that passes immediately is rejected as not proving new behavior.
- Output test: The result includes red command/result, green command/result, and remaining behavior.

## Anti-Patterns

| Pattern | Problem | Fix |
|---|---|---|
| Test-after | Code shapes the test | Delete code and write test first |
| Testing internals | Refactors break tests even when behavior works | Test public behavior |
| Giant red step | Multiple behaviors hide the failure cause | Split tests |
| Gold-plating green | Untested code becomes dead weight | Remove code no test requires |
| Mock-heavy tests | Tests pass while real integration fails | Prefer real dependencies, mock boundaries only |

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "This is too simple" | Simple behavior still needs a spec | Write the small test |
| "I'll test right after" | The implementation biases the test | Test first |
| "I need to see the design" | The test designs the interface | Write the wished-for API |
| "Mocking is too hard" | The code is probably too coupled | Simplify the design |
