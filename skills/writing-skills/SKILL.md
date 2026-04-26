---
name: writing-skills
description: Use when creating, editing, reviewing, or improving skills. Retained from Superpowers as a first-class workflow for skill authoring.
---

# Writing Skills

## Purpose

Write skills that reliably change agent behavior. A skill is not a blog post. It is an operating procedure with triggers, rules, workflows, red flags, and evidence gates.

## Source

Retained from `obra/superpowers` and adapted for this combined skillset.

## When To Use

- Create a new skill.
- Improve an existing skill.
- Merge multiple skills.
- Review skill quality.
- Add routing rules.
- Convert a repeated workflow into reusable instructions.

## Hard Rules

- A skill must have a clear trigger.
- A skill must say when not to use it.
- A skill must include hard rules for common failure modes.
- A skill must include an explicit workflow.
- A skill must include output expectations.
- A new or changed skill must include lightweight evaluation notes or tests.
- A skill must be short enough that an agent will follow it.
- Do not write generic advice. Write executable behavior.
- Keep dev-kit skills offline-safe. Do not require package managers, network calls, or external CLIs unless the skill explicitly targets that tool.

## Skill Structure

Use this structure by default:

```markdown
---
name: <skill-name>
description: <when to use this skill>
---

# <Skill Title>

## Purpose

## When To Use

## When Not To Use

## Hard Rules

## Workflow

## Output Template

## Evaluation Notes

## Red Flags
```

## Description Rules

The description is the routing surface. Make it concrete.

Also write negative triggers when confusion is likely. State when the skill must not run.

Good:

```yaml
description: Use when debugging bugs, failing tests, regressions, build failures, or unexpected behavior. Finds root cause before any fix.
```

Bad:

```yaml
description: Helps with debugging.
```

## Workflow Rules

- Use numbered steps for ordered operations.
- Put gates before risky actions.
- Name exact commands when the skill depends on commands.
- Include stop conditions.
- Include escalation conditions.
- Include verification requirements.

## Skill Evaluation

Test each skill before treating it as ready:

- Trigger test: provide a prompt that should invoke the skill.
- Negative trigger test: provide a similar prompt that should not invoke the skill.
- Workflow test: verify a fresh agent can follow the steps without hidden context.
- Failure-mode test: verify red flags stop common bad behavior.
- Output test: verify the final response shape is useful.

Score each dimension 1-5:

- Trigger specificity.
- Behavioral clarity.
- Failure-mode coverage.
- Verification gates.
- Output usefulness.
- Length discipline.

## Red Flag Table

Every skill should include a red flag table:

```markdown
| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "..." | ... | ... |
```

## Quality Checklist

- [ ] Trigger is specific.
- [ ] Non-use cases are clear when needed.
- [ ] Workflow is ordered.
- [ ] Hard rules prevent known mistakes.
- [ ] Output format is defined.
- [ ] Verification or evidence requirements are present when useful.
- [ ] Skill is not a generic essay.
- [ ] Skill composes with `verify-work` when completion claims are involved.
- [ ] Positive and negative trigger tests are documented.
- [ ] Workflow, failure-mode, and output tests are documented or intentionally not needed.
- [ ] Offline assumptions are explicit.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "The agent will infer it" | Agents skip implicit rules | Write the rule explicitly |
| "More detail is always better" | Long skills get ignored | Keep only behavior-changing detail |
| "This is obvious" | Obvious failures repeat | Encode the guardrail |
