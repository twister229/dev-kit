---
name: simplify-work
description: Use to simplify implementation, reduce complexity, refactor for readability, clean technical debt, or make code easier to maintain.
---

# Simplify Work

## Purpose

Make code easier to understand and safer to change. Optimize for readability, not cleverness.

## Combines

- AI DevKit `simplify-implementation`
- Superpowers DRY, YAGNI, TDD, and verification discipline

## When To Use

- Refactor request
- Reduce complexity
- Clean up implementation
- Improve maintainability
- Remove over-engineering
- Make code easier to understand

## When Not To Use

- Behavior is broken or tests are failing for unknown reasons: use `debug-root-cause`.
- The user asks for a new feature: use `start-work` or `tdd-work`.
- The user asks only for review: use `review-work`.
- The desired simplification would change public behavior without explicit approval.

## Hard Rules

- Do not modify code until the simplification target and plan are clear.
- Do not refactor unrelated code.
- Do not invent abstractions for hypothetical reuse.
- Some duplication beats the wrong abstraction.
- Preserve behavior unless the user explicitly asks to change it.
- Use local repository context and existing project-local verification commands. Do not require network access or external tooling.

## Workflow

1. Gather context.
   - Target files or modules.
   - Pain points.
   - Compatibility constraints.
   - Existing tests.

2. Search memory.
   - Look for prior simplification decisions or constraints.

3. Analyze complexity.
   - Nesting.
   - Coupling.
   - Duplication.
   - Dead code.
   - Excess abstraction.
   - Magic values.
   - Hard-to-test paths.

4. Apply simplification patterns.
   - Extract long functions.
   - Flatten nested conditionals.
   - Consolidate real duplication.
   - Remove unused paths.
   - Replace custom logic with standard library behavior.
   - Defer premature optimization.

5. Propose prioritized plan.
   - Before/after shape.
   - Risk.
   - Test impact.

6. Implement only approved scope.

7. Run `verify-work`.

8. Store reusable simplification learning when it prevents future mistakes.

## Output Template

```markdown
## Simplification Plan

Target: ...
Current complexity: ...
Recommended changes: ...
Not changing: ...
Risk: ...
Verification: ...
```

## Evaluation Notes

- Trigger test: "Simplify this module without changing behavior" should invoke `simplify-work`.
- Negative trigger test: "Why is this module failing?" should invoke `debug-root-cause`, not `simplify-work`.
- Workflow test: A fresh agent can name target complexity, proposed changes, and verification.
- Failure-mode test: Scope creep into unrelated cleanup is rejected.
- Output test: The plan states target, current complexity, recommended changes, non-changes, risk, and verification.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "While I'm here" | Scope creep causes regressions | Stay on target |
| "Shorter is simpler" | Dense code can be worse | Optimize for reading |
| "This abstraction may help later" | Future reuse is usually fictional | Wait for real duplication |
