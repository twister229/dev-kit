---
name: shape-work
description: Use when a product or technical request is vague, exploratory, or not ready for implementation planning. Do not use for bugs, ready plans, or tiny obvious edits.
---

# Shape Work

## Purpose

Turn an idea into implementable requirements without coding. Shape the smallest coherent slice before `plan-work` turns it into tasks.

## Combines

- Superpowers `brainstorming`
- AI DevKit requirement and design review habits

## When To Use

- Vague product idea.
- Competing implementation or product approaches.
- User asks to brainstorm, shape, explore, or decide what to build.
- `start-work` finds requirements are not concrete enough for `plan-work`.
- Existing feature direction needs clarification before implementation planning.

## When Not To Use

- Bug reports, regressions, or failing tests: use `debug-root-cause`.
- Written requirements already exist: use `plan-work`.
- A written implementation plan is ready: use `execute-work`.
- Tiny mechanical edits with obvious verification: execute directly and use `verify-work`.

## Hard Rules

- Do not write implementation code during this skill.
- Do not invent user requirements when evidence is missing.
- Do not ask questions already answered by repo docs, memory, or code.
- Prefer the smallest coherent product slice over a broad speculative system.
- Keep dev-kit workflows offline-safe. Do not require package managers, network calls, or external CLIs.

## Workflow

1. Read the start brief, user request, and relevant docs.
2. Identify the user, job-to-be-done, and current pain.
3. Capture constraints.
   - User instructions.
   - Repo architecture.
   - Offline requirements.
   - Risk level.
4. Compare 2-3 viable approaches.
   - Name the tradeoff for each.
   - Reject approaches that are too broad or risky.
5. Pick the smallest valuable slice.
6. Define acceptance signals.
   - Observable behavior.
   - Verification command or manual check.
   - Out-of-scope boundaries.
7. Produce a shaping brief and recommend `plan-work` when requirements are ready.

## Output Template

```markdown
## Shaping Brief

Problem: ...
User: ...
Outcome: ...
Constraints: ...
Approaches considered: ...
Recommended slice: ...
Out of scope: ...
Acceptance signals: ...
Risks: ...
Next skill: `plan-work` | `start-work` | `debug-root-cause`
```

## Evaluation Notes

- Trigger test: "Help me think through how this AI dev workflow should work" should invoke `shape-work`.
- Negative trigger test: "Implement this approved plan" should invoke `execute-work`, not `shape-work`.
- Workflow test: A fresh agent can produce a shaping brief without editing code.
- Failure-mode test: Missing requirements become explicit questions or assumptions, not invented scope.
- Output test: The brief is concrete enough for `plan-work`.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "I know what they mean" | Guessing turns ambiguity into rework | State assumptions and shape the smallest slice |
| "Let's just plan everything" | Planning broad unknowns creates fake certainty | Compare approaches before planning tasks |
| "This is basically coding" | Shaping decides what to build, not how to edit files | Stop before implementation details dominate |
