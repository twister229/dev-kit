---
name: docs-review
description: Use when reviewing or improving README files, install docs, skill docs, guides, API docs, or agent-facing documentation.
---

# Docs Review

## Purpose

Review documentation as a new user would experience it. Good docs let someone succeed without guessing.

## When To Use

- README review
- Install instruction review
- Skill documentation review
- API or guide review
- User asks to improve technical writing
- A feature changed behavior and docs may be stale

## Hard Rules

- Do not rewrite docs until the user approves, unless they explicitly asked for edits.
- Suggest concrete replacement text, not vague advice.
- Review for the least experienced plausible user.
- Commands must be copy-pasteable and offline-safe when the project promises offline support.

## Review Dimensions

Rate each dimension 1-5:

- Clarity: can a new user understand it without outside help?
- Completeness: are prerequisites, examples, edge cases, and failure modes covered?
- Actionability: can users copy-paste commands and follow along?
- Structure: does it flow from simple to advanced?

## Workflow

1. Identify the target docs and intended reader.
2. Read the docs in order as a new user.
3. Check commands, paths, prerequisites, and claims.
4. Look for missing offline or platform notes.
5. Rate the four dimensions.
6. List issues by priority:
   - High: blocks success
   - Medium: causes confusion
   - Low: polish
7. Provide concrete suggested text.
8. If asked to edit, make the smallest doc change that fixes the issue.
9. Use `verify-work` for command or install claims.

## Output Template

```markdown
## Docs Review

| Aspect | Rating | Notes |
|---|---|---|
| Clarity | X/5 | ... |
| Completeness | X/5 | ... |
| Actionability | X/5 | ... |
| Structure | X/5 | ... |

Issues:
1. [High] ...
2. [Medium] ...

Suggested fixes:
- ...
```

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Developers will figure it out" | Many users will quit first | Write the missing step |
| "The command speaks for itself" | Users need context and expected output | Add what it does |
| "Too much detail clutters docs" | Missing prerequisites block users | Put details where they are needed |
