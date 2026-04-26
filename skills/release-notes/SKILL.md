---
name: release-notes
description: Use when writing changelog entries, release notes, migration notes, or upgrade guidance from completed changes. Requires evidence from diffs, commits, plans, or user-provided summaries; do not invent shipped behavior.
---

# Release Notes

## Purpose

Turn completed changes into accurate release communication that explains user impact, breaking changes, migrations, and verification gaps without inventing shipped behavior.

## When To Use

- Write changelog entries.
- Draft release notes.
- Prepare migration notes or upgrade guidance.
- Summarize completed changes for users, maintainers, or reviewers.
- Convert a verified diff, commit range, plan, or user-provided summary into release communication.

## When Not To Use

- Final branch verification, commit, PR, or handoff prep: use `finish-work`.
- General documentation review or onboarding docs: use `docs-review`.
- Implementation planning: use `plan-work`.
- Code or diff review for correctness: use `review-work`.
- Speculative roadmap or unreleased feature marketing.

## Hard Rules

- Do not invent shipped behavior.
- Base claims on diffs, commits, plans, verification output, or explicit user-provided summaries.
- If no diff, commit range, plan, verification output, or explicit user summary is available, stop and ask for evidence instead of drafting release notes.
- Separate user-visible changes from internal refactors.
- Call out breaking changes, migration steps, deprecations, and compatibility notes.
- Name verification gaps when evidence is incomplete.
- Keep release notes concise and useful to the intended audience.
- Draft from local diffs, commits, plans, verification output, or user-provided summaries. Do not require network access or release tooling unless the user explicitly asks to publish.

## Workflow

1. Identify the target format: changelog entry, release notes, migration notes, or upgrade guidance.
2. Identify the target audience: end users, developers, maintainers, operators, or reviewers.
3. Gather evidence.
   - Diff.
   - Commit range.
   - Plan or design doc.
   - Verification output.
   - User-provided change summary.
4. Group changes by user impact.
   - Added.
   - Changed.
   - Fixed.
   - Removed.
   - Internal.
5. Identify breaking changes, migrations, deprecations, and upgrade actions.
6. Draft notes in the project's existing voice and format when one exists.
7. Check every claim against evidence.
8. Name verification gaps or unknowns instead of filling them in.

## Output Template

```markdown
## Changelog Entry

### Added
- ...

### Changed
- ...

### Fixed
- ...

### Migration Notes
- ...

Verification: ...
```

```markdown
## Release Notes

Summary: ...
Evidence used: ...
Highlights: ...
Breaking changes: ...
Upgrade guidance: ...
Verification: ...
Known gaps: ...
```

## Evaluation Notes

- Trigger test: "Write release notes from this diff" should invoke `release-notes`.
- Negative trigger test: "Review the README onboarding flow" should invoke `docs-review`, not `release-notes`.
- Workflow test: A fresh agent can map each release note claim back to diff, commit, plan, or user summary evidence.
- Failure-mode test: Hallucinated shipped behavior is rejected or marked unknown.
- Output test: The notes include user impact, breaking changes or none, upgrade guidance when needed, and verification gaps.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "This probably shipped" | Release notes become misinformation | Verify against evidence or omit |
| "Internal changes need hype" | Users need impact, not filler | Separate internal changes clearly |
| "No need to mention migrations" | Upgrade failures cost users time | Call out breaking changes and steps |
