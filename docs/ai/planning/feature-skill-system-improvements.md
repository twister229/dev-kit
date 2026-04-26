# Skill System Improvements Implementation Plan

Goal: Improve the local agentic developer skill set by adding missing daily-work workflows and tightening routing boundaries across existing skills.
User outcome: Developers get a clearer skill system for daily Agentic AI work, with explicit routing for handoff, dependency changes, release notes, and skill lifecycle decisions.
Architecture: Keep the existing lifecycle-first structure. Add three focused skills for gaps that should not be folded into durable memory, finish prep, or generic review. Update registry and trigger language so `start-work` remains the primary entrypoint and `writing-skills` governs all skill creation/editing.
Risk: Feature
Execution: Use `execute-work` for task-by-task implementation. For every new or modified skill task, use `writing-skills` as the quality standard before editing and during review.
Verification: Use `verify-work` before any completion claim.

## Context

The local skill set already curates upstream `superpowers` and `ai-devkit` into a coherent lifecycle:

`start-work -> shape-work -> plan-work -> execute-work -> review-work -> verify-work -> capture-learning -> finish-work`

Specialized branches currently include `debug-root-cause`, `tdd-work`, `simplify-work`, `review-feedback`, `docs-review`, `worktree-work`, `orchestrate-agents`, `writing-skills`, and `auto-dev-loop`.

This plan preserves that structure and adds only three missing daily-developer workflows:

- `context-handoff`: one-off resumable session state, separate from durable project learning.
- `dependency-work`: safe dependency add/update/remove/diagnosis workflow.
- `release-notes`: changelog, release notes, migration notes, and upgrade guidance.

## Task 1: Add Skill System Design Doc

Files:
- Create: `docs/skill-system-shape.md`

Acceptance:
- [ ] Documents the target skill taxonomy: core workflow, quality gates, maintenance/knowledge, coordination/isolation.
- [ ] Lists skills to keep and explains why no existing local skill is removed in this slice.
- [ ] Lists the three new skills and why each is separate from existing skills.
- [ ] Includes the routing table from user intent to skill.
- [ ] Names out-of-scope skill categories for this slice.

Steps:
- [ ] Create `docs/skill-system-shape.md` with the approved shape from the shaping brief.
- [ ] Include these sections exactly: `# Skill System Shape`, `## Goals`, `## Current Skill Set`, `## Target Categories`, `## New Skills`, `## Skills Not Added`, `## Routing Table`, `## Acceptance Signals`.
- [ ] Keep the doc concise and implementation-neutral. It should explain decisions, not duplicate every `SKILL.md` workflow.
- [ ] Run verification.

Command: `test -f docs/skill-system-shape.md && grep -n "## Routing Table" docs/skill-system-shape.md`
Expected: exits 0 and prints the routing table heading line.

## Task 2: Create `context-handoff` Skill

Files:
- Create: `skills/context-handoff/SKILL.md`
- Modify: `skills/registry.json`

Acceptance:
- [ ] Uses `writing-skills` requirements: frontmatter, purpose, triggers, non-use cases, hard rules, workflow, output template, evaluation notes, red flag table.
- [ ] Clearly separates one-off session handoff from durable project knowledge in `capture-learning`.
- [ ] Clearly separates paused/in-progress handoff from final branch readiness in `finish-work`.
- [ ] Requires factual current-state evidence: branch/worktree, goal, completed work, pending work, files touched, commands run, blockers, next skill.
- [ ] Forbids storing secrets, transcripts, credentials, or unverified claims.
- [ ] Updates `skills/registry.json` with a concrete description.

Steps:
- [ ] Invoke `writing-skills` before drafting this skill.
- [ ] Create `skills/context-handoff/SKILL.md` using the default skill structure.
- [ ] Use this description in frontmatter unless implementation reveals a better concise version:

```yaml
description: Use when saving or restoring one-off working context for a paused task, long session, context-limit handoff, or another agent taking over. Do not use for durable project knowledge; use `capture-learning` instead.
```

- [ ] Add hard rules covering secrets, stale state, current git state, and distinction from `capture-learning` and `finish-work`.
- [ ] Add workflow steps to inspect current state, summarize completed/pending work, list touched files, list verification evidence, identify blockers, and recommend the next skill.
- [ ] Add evaluation notes for trigger, negative trigger, workflow, failure mode, and output tests.
- [ ] Add `context-handoff` to `skills/registry.json` in a logical position near `capture-learning` or `finish-work`.
- [ ] Run verification.

Command: `test -f skills/context-handoff/SKILL.md && grep -n "name: context-handoff" skills/context-handoff/SKILL.md && grep -n '"name": "context-handoff"' skills/registry.json`
Expected: exits 0 and prints matching lines from the skill and registry.

## Task 3: Create `dependency-work` Skill

Files:
- Create: `skills/dependency-work/SKILL.md`
- Modify: `skills/registry.json`

Acceptance:
- [ ] Uses `writing-skills` requirements.
- [ ] Covers adding, removing, updating, auditing, and diagnosing dependencies.
- [ ] Requires package manager/project convention detection before dependency commands.
- [ ] Requires minimal changes, lockfile awareness, and no silent major upgrades.
- [ ] Requires user approval before network-dependent installs when the environment does not already allow them.
- [ ] Requires supply-chain risk checks such as install scripts, unexpected package changes, or secret-bearing config files.
- [ ] Routes failing installs or regressions to `debug-root-cause` when root cause is not known.
- [ ] Routes final proof through `verify-work`.
- [ ] Updates `skills/registry.json` with a concrete description.

Steps:
- [ ] Invoke `writing-skills` before drafting this skill.
- [ ] Create `skills/dependency-work/SKILL.md` using the default skill structure.
- [ ] Use this description in frontmatter unless implementation reveals a better concise version:

```yaml
description: Use when adding, removing, updating, auditing, or diagnosing project dependencies and lockfiles. Detect project conventions first, avoid silent major upgrades, and verify resulting behavior.
```

- [ ] Include `When Not To Use` entries for ordinary implementation, bugs unrelated to dependencies, deploys, and broad security audits.
- [ ] Include workflow steps for detecting package manager, checking current state, choosing minimal change, planning verification, applying the dependency change, inspecting lockfile/config diffs, running checks, and handing off to `verify-work`.
- [ ] Include stop conditions for credentials, private registries, destructive lockfile rewrites, major version changes, and repeated install failures.
- [ ] Add evaluation notes for dependency update, negative trigger for normal feature work, and failure mode for silent major upgrade.
- [ ] Add `dependency-work` to `skills/registry.json`.
- [ ] Run verification.

Command: `test -f skills/dependency-work/SKILL.md && grep -n "major" skills/dependency-work/SKILL.md && grep -n '"name": "dependency-work"' skills/registry.json`
Expected: exits 0 and prints matching lines proving the skill exists, includes major-upgrade guardrails, and is registered.

## Task 4: Create `release-notes` Skill

Files:
- Create: `skills/release-notes/SKILL.md`
- Modify: `skills/registry.json`

Acceptance:
- [ ] Uses `writing-skills` requirements.
- [ ] Covers changelog entries, release notes, migration notes, and upgrade guidance.
- [ ] Clearly separates release communication from `finish-work`, `docs-review`, and implementation review.
- [ ] Requires evidence from diffs, commit history, plan files, or user-provided change summaries instead of invented claims.
- [ ] Requires user-impact framing and breaking-change callouts.
- [ ] Updates `skills/registry.json` with a concrete description.

Steps:
- [ ] Invoke `writing-skills` before drafting this skill.
- [ ] Create `skills/release-notes/SKILL.md` using the default skill structure.
- [ ] Use this description in frontmatter unless implementation reveals a better concise version:

```yaml
description: Use when writing changelog entries, release notes, migration notes, or upgrade guidance from completed changes. Requires evidence from diffs, commits, plans, or user-provided summaries; do not invent shipped behavior.
```

- [ ] Include `When Not To Use` entries for final branch verification, general docs review, implementation planning, and code review.
- [ ] Include workflow steps for gathering evidence, grouping changes by user impact, identifying breaking changes/migrations, drafting concise notes, checking against actual diffs, and naming verification gaps.
- [ ] Add output templates for changelog entry and release notes.
- [ ] Add evaluation notes for release note generation, negative trigger for docs review, and failure mode for hallucinated behavior.
- [ ] Add `release-notes` to `skills/registry.json`.
- [ ] Run verification.

Command: `test -f skills/release-notes/SKILL.md && grep -n "do not invent" skills/release-notes/SKILL.md && grep -n '"name": "release-notes"' skills/registry.json`
Expected: exits 0 and prints matching lines proving the skill exists, includes anti-hallucination guardrails, and is registered.

## Task 5: Tighten `start-work` Routing Boundaries

Files:
- Modify: `skills/start-work/SKILL.md`

Acceptance:
- [ ] Uses `writing-skills` before editing because this updates skill behavior.
- [ ] Adds a concise routing table mapping common daily developer intents to skills.
- [ ] Adds explicit routes for `context-handoff`, `dependency-work`, and `release-notes`.
- [ ] Reinforces that `start-work` is the default entrypoint for non-trivial feature or multi-step work.
- [ ] Does not make `start-work` longer than necessary or duplicate full workflows from other skills.

Steps:
- [ ] Invoke `writing-skills` before editing.
- [ ] In `skills/start-work/SKILL.md`, add a short `## Routing Table` section after `## When Not To Use` or after `## Workflow`.
- [ ] Include rows for: build/add/implement, think through idea, write plan, execute plan, bug/failing test/error, behavior change, review diff, review comments, prove done, simplify/refactor, docs review, remember reusable fact, save/resume context, dependencies, release notes, finish branch, create/improve skill, autonomous end-to-end.
- [ ] Keep each route one line and avoid duplicating workflow details.
- [ ] Run verification.

Command: `grep -n "context-handoff\|dependency-work\|release-notes" skills/start-work/SKILL.md`
Expected: exits 0 and prints all three new skill routes.

## Task 6: Tighten Existing Skill Boundaries For New Skills

Files:
- Modify: `skills/capture-learning/SKILL.md`
- Modify: `skills/finish-work/SKILL.md`
- Modify: `skills/docs-review/SKILL.md`

Acceptance:
- [ ] Uses `writing-skills` before editing because this updates skill behavior.
- [ ] `capture-learning` explicitly says not to use it for one-off session progress or resumable handoff; use `context-handoff` instead.
- [ ] `finish-work` explicitly says not to use it for paused/in-progress handoff; use `context-handoff` instead.
- [ ] `finish-work` optionally routes changelog/release communication to `release-notes` when requested.
- [ ] `docs-review` explicitly says not to use it for release notes/changelog drafting from completed diffs; use `release-notes` instead.
- [ ] Edits are minimal and preserve existing skill style.

Steps:
- [ ] Invoke `writing-skills` before editing.
- [ ] Patch only the `When Not To Use`, `Workflow`, or routing-related sections needed.
- [ ] Avoid rewriting unrelated content.
- [ ] Run verification.

Command: `grep -n "context-handoff" skills/capture-learning/SKILL.md skills/finish-work/SKILL.md && grep -n "release-notes" skills/finish-work/SKILL.md skills/docs-review/SKILL.md`
Expected: exits 0 and prints the new boundary references.

## Task 7: Registry And Skill Quality Review

Files:
- Modify: `skills/registry.json` if ordering or JSON formatting needs cleanup.
- Review: `skills/context-handoff/SKILL.md`
- Review: `skills/dependency-work/SKILL.md`
- Review: `skills/release-notes/SKILL.md`
- Review: `skills/start-work/SKILL.md`
- Review: `skills/capture-learning/SKILL.md`
- Review: `skills/finish-work/SKILL.md`
- Review: `skills/docs-review/SKILL.md`

Acceptance:
- [ ] `skills/registry.json` is valid JSON.
- [ ] Registry contains all existing skills plus exactly the three new skills.
- [ ] New skill descriptions are specific and trigger-oriented.
- [ ] Each new skill includes `When To Use`, `When Not To Use`, `Hard Rules`, `Workflow`, `Output Template`, `Evaluation Notes`, and `Red Flags`.
- [ ] Existing skill boundary edits do not introduce contradictory routing.

Steps:
- [ ] Use `writing-skills` to review the new and changed skills against its quality checklist.
- [ ] Parse `skills/registry.json` with Python's built-in JSON parser.
- [ ] Search the three new skills for required section headings.
- [ ] Fix any missing section, vague trigger, or invalid JSON.
- [ ] Run verification.

Command: `python3 -m json.tool skills/registry.json >/dev/null`
Expected: exits 0 with no output.

Command: `grep -n "^## When To Use\|^## When Not To Use\|^## Hard Rules\|^## Workflow\|^## Output Template\|^## Evaluation Notes\|^## Red Flags" skills/context-handoff/SKILL.md skills/dependency-work/SKILL.md skills/release-notes/SKILL.md`
Expected: exits 0 and prints all required headings for all three new skills.

## Task 8: Final Review And Verification

Files:
- Review: full diff for this plan's changes.

Acceptance:
- [ ] Uses `review-work` to review the final diff against this plan.
- [ ] Uses `verify-work` before claiming completion.
- [ ] Reports changed files, verification commands, review findings, and remaining risks.
- [ ] Does not commit, push, or create a PR unless explicitly requested.

Steps:
- [ ] Run `git status --short` to identify changed files and unrelated worktree changes.
- [ ] Run `git diff -- docs/skill-system-shape.md skills/context-handoff/SKILL.md skills/dependency-work/SKILL.md skills/release-notes/SKILL.md skills/start-work/SKILL.md skills/capture-learning/SKILL.md skills/finish-work/SKILL.md skills/docs-review/SKILL.md skills/registry.json`.
- [ ] Review the diff against each task acceptance criterion using `review-work`.
- [ ] Run final verification commands from Tasks 1-7.
- [ ] Use `verify-work` for the final completion claim.

Command: `python3 -m json.tool skills/registry.json >/dev/null && test -f docs/skill-system-shape.md && test -f skills/context-handoff/SKILL.md && test -f skills/dependency-work/SKILL.md && test -f skills/release-notes/SKILL.md`
Expected: exits 0.

## Acceptance Checklist

- [ ] `docs/skill-system-shape.md` exists and captures the skill system shape.
- [ ] `skills/context-handoff/SKILL.md` exists, follows `writing-skills`, and is registered.
- [ ] `skills/dependency-work/SKILL.md` exists, follows `writing-skills`, and is registered.
- [ ] `skills/release-notes/SKILL.md` exists, follows `writing-skills`, and is registered.
- [ ] `skills/start-work/SKILL.md` routes to the three new skills.
- [ ] `skills/capture-learning/SKILL.md`, `skills/finish-work/SKILL.md`, and `skills/docs-review/SKILL.md` contain clear non-overlap boundaries.
- [ ] `skills/registry.json` is valid JSON.
- [ ] Final review finds no blocking issues.
- [ ] Final verification has fresh command evidence.
