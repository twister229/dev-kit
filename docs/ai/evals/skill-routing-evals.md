# Skill Routing Eval Prompts

Use these prompts to evaluate whether new and updated skills route correctly and produce useful behavior. Each eval is intentionally lightweight so it can be run by a fresh agent without external tools.

Scoring per skill:
- Trigger specificity: 1-5
- Behavioral clarity: 1-5
- Failure-mode coverage: 1-5
- Verification gates: 1-5
- Output usefulness: 1-5
- Length discipline: 1-5

Passing bar: all dimensions 4 or higher, with no critical routing failure.

## `context-handoff`

Trigger prompt:

```text
Save state so another agent can continue this task later. Include what changed, what is pending, commands run, and the next recommended workflow.
```

Expected route: `context-handoff`

Negative trigger prompt:

```text
Remember that this repo stores durable agent memory under docs/ai/memory and future agents should search there first.
```

Expected route: `capture-learning`

Workflow eval:
- The agent inspects current branch/worktree state before writing the handoff.
- The handoff separates completed work, pending work, files touched, commands run, blockers, and next skill.
- The agent does not claim completion without `verify-work` evidence.

Failure-mode eval:
- If the context includes raw logs, secrets, credentials, or a transcript, the agent refuses to store those details and summarizes safely.

Output eval:
- Output includes `Goal`, `Current state`, `Completed`, `Pending`, `Files touched`, `Commands run`, `Blockers/questions`, `Next skill`, and `Saved to`.

## `dependency-work`

Trigger prompt:

```text
Update the testing library to the latest safe patch version and keep the lockfile clean.
```

Expected route: `dependency-work`

Negative trigger prompt:

```text
Implement a settings page using the dependencies already in this project.
```

Expected route: `start-work` or `tdd-work`

Workflow eval:
- The agent detects package manager, lockfile, and workspace conventions before running dependency commands.
- The agent chooses the smallest dependency change and inspects manifest and lockfile diffs.
- The agent runs targeted verification and uses `verify-work` for completion claims.

Failure-mode eval:
- If the requested update is a major version upgrade, private registry access, credential-dependent install, or destructive lockfile rewrite, the agent stops for explicit approval.

Output eval:
- Output includes `Goal`, `Package manager`, `Changed dependencies`, `Manifest/lockfile changes`, `Risk checks`, `Verification`, and `Status`.

## `release-notes`

Trigger prompt:

```text
Write release notes from this diff and call out breaking changes or migration steps if any.
```

Expected route: `release-notes`

Negative trigger prompt:

```text
Review the README onboarding flow and suggest concrete copy improvements.
```

Expected route: `docs-review`

Workflow eval:
- The agent gathers evidence from diff, commits, plans, verification output, or user-provided summaries.
- The agent groups changes by user impact and separates internal refactors.
- Every release-note claim maps back to evidence.

Failure-mode eval:
- If evidence is missing, the agent marks the item as unknown or a verification gap instead of inventing shipped behavior.

Output eval:
- Output includes summary or changelog sections, breaking changes, upgrade guidance when relevant, verification, and known gaps.

## `start-work`

Trigger prompt:

```text
Build a non-trivial import workflow and keep the implementation scoped.
```

Expected route: `start-work`

Negative trigger prompt:

```text
Review this diff for correctness before merge.
```

Expected route: `review-work`

Workflow eval:
- `Save state so I can resume later` routes to `context-handoff`.
- `Add or update dependencies` routes to `dependency-work`.
- `Write release notes from completed changes` routes to `release-notes`.

Failure-mode eval:
- The agent does not use `start-work` for tiny obvious edits, bug root-cause diagnosis, or already-written plans.

Output eval:
- Output includes goal, user outcome, scope, risk, evidence checked, memory applied, isolation, baseline, recommended workflow, and next skill.

## `capture-learning`

Trigger prompt:

```text
Document this module's entry points and conventions so future agents can reuse the knowledge.
```

Expected route: `capture-learning`

Negative trigger prompt:

```text
Save progress from this paused task so another agent can continue tomorrow.
```

Expected route: `context-handoff`

Workflow eval:
- The agent searches existing memory before storing.
- The agent records only verified reusable knowledge.

Failure-mode eval:
- The agent refuses one-off task progress, raw logs, transcripts, secrets, or speculation.

Output eval:
- Output includes type, scope, evidence, location, and future use.

## `finish-work`

Trigger prompt:

```text
Finish this branch and prepare it for handoff. Run final checks and summarize risks.
```

Expected route: `finish-work`

Negative trigger prompt:

```text
Work is not done yet. Save enough context so another agent can resume later.
```

Expected route: `context-handoff`

Workflow eval:
- `Write changelog entries for completed changes` routes to `release-notes` when no final branch-readiness work is requested.

Failure-mode eval:
- The agent does not commit, push, create a PR, or claim readiness without explicit request and `verify-work` evidence.

Output eval:
- Output includes changed work, verification, review findings, implementation check, risks, learning captured, and next action.

## `docs-review`

Trigger prompt:

```text
Review the installation docs as a new user and suggest concrete wording improvements.
```

Expected route: `docs-review`

Negative trigger prompt:

```text
Write release notes from these completed commits and call out migration notes.
```

Expected route: `release-notes`

Workflow eval:
- The agent reviews docs from the least experienced plausible user's perspective.
- The agent rates clarity, completeness, actionability, and structure.
- The agent provides concrete suggested text.

Failure-mode eval:
- Vague advice without replacement wording fails the eval.

Output eval:
- Output includes ratings, prioritized issues, and suggested fixes.
