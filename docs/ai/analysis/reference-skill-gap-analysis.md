# Reference Skill Gap Analysis

Purpose: map every upstream reference workflow to the current dev-kit skill surface and decide whether to cover, merge, create, or exclude it.

Decision values:
- `covered`: current skills already cover the behavior.
- `merge`: useful behavior should be folded into an existing skill.
- `create`: a distinct portable workflow is missing and should become a new skill.
- `exclude`: intentionally not imported because it conflicts with this dev-kit's goals.

## Skills

| Source | Reference | Current coverage | Decision | Missing behavior | Smallest useful change |
|---|---|---|---|---|---|
| superpowers | `brainstorming` | `shape-work` | merge | One-question clarification, oversized-scope decomposition, explicit approval before planning | Already merged into `shape-work`; keep no browser companion and no mandatory spec commits |
| superpowers | `writing-plans` | `plan-work` | covered | None blocking | No change |
| superpowers | `executing-plans` | `execute-work` | covered | None blocking | No change |
| superpowers | `subagent-driven-development` | `execute-work` | covered | Fresh context and review gates are covered | No change |
| superpowers | `dispatching-parallel-agents` | `execute-work` | create | No general skill for safe multi-agent dispatch outside plan execution | Create `orchestrate-agents` for parallel/serial agent coordination |
| superpowers | `using-git-worktrees` | `start-work` partially | create | No dedicated workflow for creating, using, and cleaning isolated worktrees | Create `worktree-work` for branch/worktree isolation |
| superpowers | `systematic-debugging` | `debug-root-cause` | covered | None blocking | No change |
| superpowers | `test-driven-development` | `tdd-work` | covered | None blocking | No change |
| superpowers | `verification-before-completion` | `verify-work` | covered | None blocking | No change |
| superpowers | `requesting-code-review` | `review-work` | covered | None blocking | No change |
| superpowers | `receiving-code-review` | `review-feedback` | covered | None blocking | No change |
| superpowers | `finishing-a-development-branch` | `finish-work` | covered | None blocking | No change |
| superpowers | `writing-skills` | `writing-skills` | covered | None blocking | No change |
| superpowers | `using-superpowers` | README, `start-work`, `auto-dev-loop` | merge | No single skill-specific change needed, but daily workflow docs should explain practical use | Keep README daily workflow current |
| ai-devkit | `dev-lifecycle` | `start-work`, `plan-work`, `execute-work`, `review-work`, `verify-work`, `finish-work`, `auto-dev-loop` | covered | Heavy `npx` lifecycle intentionally adapted away | No change |
| ai-devkit | `agent-orchestration` | `execute-work` partially | create | No standalone orchestration workflow outside plan execution | Create `orchestrate-agents` |
| ai-devkit | `debug` | `debug-root-cause` | covered | None blocking | No change |
| ai-devkit | `tdd` | `tdd-work` | covered | None blocking | No change |
| ai-devkit | `verify` | `verify-work` | covered | None blocking | No change |
| ai-devkit | `memory` | `capture-learning` | covered | External memory CLI excluded | No change |
| ai-devkit | `capture-knowledge` | `capture-learning` | covered | None blocking | No change |
| ai-devkit | `simplify-implementation` | `simplify-work` | covered | None blocking | No change |
| ai-devkit | `technical-writer` | `docs-review` | covered | None blocking | No change |

## Commands

| Source | Reference | Current coverage | Decision | Missing behavior | Smallest useful change |
|---|---|---|---|---|---|
| superpowers | `brainstorm` | `shape-work` | covered | None blocking | No change |
| superpowers | `write-plan` | `plan-work` | covered | None blocking | No change |
| superpowers | `execute-plan` | `execute-work` | covered | None blocking | No change |
| ai-devkit | `new-requirement` | `start-work`, `shape-work` | covered | None blocking | No change |
| ai-devkit | `review-requirements` | `shape-work`, `plan-work` | covered | None blocking | No change |
| ai-devkit | `review-design` | `shape-work`, `review-work` | covered | None blocking | No change |
| ai-devkit | `execute-plan` | `execute-work` | covered | None blocking | No change |
| ai-devkit | `update-planning` | `execute-work` | covered | Plan updates are inside task loop | No change |
| ai-devkit | `check-implementation` | `review-work`, `finish-work` | covered | No separate skill needed yet | No change |
| ai-devkit | `writing-test` | `tdd-work` | covered | None blocking | No change |
| ai-devkit | `code-review` | `review-work` | covered | None blocking | No change |
| ai-devkit | `remember` | `capture-learning` | covered | External memory CLI excluded | No change |

## Proposed New Skills

### `worktree-work`

Reason: Worktree isolation is useful across all development projects and is distinct from `start-work`. `start-work` can recommend isolation, but it should not own the full branch/worktree lifecycle.

Smallest useful behavior:
- Decide when a worktree is warranted.
- Verify parent directory and ignore rules.
- Create or select an isolated branch/worktree.
- Confirm context before edits.
- Cleanly hand back to the normal workflow.

### `orchestrate-agents`

Reason: Safe multi-agent coordination is useful beyond plan execution. `execute-work` covers task execution, but not general dispatch policy for research, review, QA, and independent implementation streams.

Smallest useful behavior:
- Decide whether serial or parallel dispatch is safe.
- Assign non-overlapping scopes.
- Track agent instructions and outputs.
- Reconcile diffs and conflicts before verification.
- Stop on shared-file conflicts or unclear ownership.

## Intentional Exclusions

- Browser visual companion scripts from upstream brainstorming: useful for visual products, but too heavy for this portable offline workflow.
- Mandatory design docs for every creative task: conflicts with fast path for tiny work.
- Mandatory design-doc commits during shaping: commit decisions should stay user-controlled.
- `npm`/`npx` ai-devkit commands: this dev-kit keeps installer and workflows offline-safe.
- External memory databases or CLIs: memory remains local Markdown.
- A separate `implementation-check` skill: currently covered by `review-work` and `finish-work`; create later only if real usage shows routing friction.

## Summary

The current V2 skill set covers most upstream behavior. The two portable gaps worth creating now are worktree isolation and general multi-agent orchestration. Everything else should remain covered by existing skills or intentionally excluded to preserve speed and simplicity.
