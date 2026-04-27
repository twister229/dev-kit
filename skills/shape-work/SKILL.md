---
name: shape-work
description: Use when a product or technical request is vague, exploratory, or not ready for implementation planning. Do not use for bugs, ready plans, or tiny obvious edits.
---

# Shape Work

## Purpose

Turn an idea into implementable requirements without coding. Shape the smallest coherent slice before `plan-work` turns it into tasks, using collaborative clarification only when repo evidence cannot answer the question.

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
- Ask at most one clarifying question at a time, and prefer multiple choice when it reduces user effort.
- Prefer the smallest coherent product slice over a broad speculative system.
- Do not silently choose when multiple interpretations are plausible. Present the options and recommend one.
- If the request spans multiple independent subsystems, decompose it before shaping the first slice.
- Present the recommended shape and get user approval before handing off to `plan-work`.
- Write a design doc only for feature-sized or risky work, or when the user asks for one.
- Keep dev-kit workflows offline-safe. Do not require package managers, network calls, or external CLIs.

## Workflow

1. Read the start brief, user request, relevant docs, and current code patterns.
2. Check scope size.
   - If the request contains independent subsystems, list them, describe dependencies, and recommend the first slice to shape.
   - Do not refine details for a project that first needs decomposition.
3. Identify the user, job-to-be-done, current pain, and success criteria.
4. Ask only missing questions.
   - Ask one question per message.
   - Prefer multiple choice when the decision space is bounded.
   - Stop asking when assumptions are safe, explicit, and reversible.
5. Capture constraints.
   - User instructions.
   - Repo architecture.
   - Offline requirements.
   - Risk level.
   - Compatibility or migration boundaries.
6. Compare 2-3 viable approaches when there is a meaningful decision.
   - Name the tradeoff for each.
   - Lead with the recommended option and explain why.
   - Reject approaches that are too broad or risky.
   - If ambiguity is about meaning rather than implementation, compare 2-3 plausible interpretations before approaches.
7. Pick the smallest valuable slice.
8. Define acceptance signals.
   - Observable behavior.
   - Verification command or manual check.
   - Out-of-scope boundaries.
9. Decide whether to write a design doc.
   - Skip docs for small or obvious work.
   - For feature-sized or risky work, write `docs/ai/design/feature-<name>.md` unless the project uses another convention.
10. Present the shaping brief and ask for approval before `plan-work`.

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
Design doc: not needed | `path/to/design.md`
Risks: ...
Approval needed: yes/no
Next skill after approval: `plan-work` | `start-work` | `debug-root-cause`
```

## Evaluation Notes

- Trigger test: "Help me think through how this AI dev workflow should work" should invoke `shape-work`.
- Trigger test: "Brainstorm 2-3 ways to add X before planning" should invoke `shape-work`.
- Negative trigger test: "Implement this approved plan" should invoke `execute-work`, not `shape-work`.
- Workflow test: A fresh agent can decompose oversized scope, ask one missing question at a time, and produce a shaping brief without editing code.
- Failure-mode test: Missing requirements become explicit questions or assumptions, not invented scope.
- Failure-mode test: Feature-sized or risky work gets an explicit design-doc decision instead of accidental undocumented planning.
- Output test: The brief is concrete enough for `plan-work` and records whether approval is needed.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "I know what they mean" | Guessing turns ambiguity into rework | State assumptions and shape the smallest slice |
| "Let's just plan everything" | Planning broad unknowns creates fake certainty | Compare approaches before planning tasks |
| "This is basically coding" | Shaping decides what to build, not how to edit files | Stop before implementation details dominate |
| "Ask all questions at once" | Question dumps create low-quality answers | Ask the next most important question only |
| "One big spec is fine" | Multi-subsystem plans hide dependencies | Decompose first, then shape one slice |
