# Portable Dev Workflow Design

## Problem

The repo has strong individual skills, but the upstream references include two portable workflows that are only partially represented: isolated worktree development and safe multi-agent orchestration. Developers using this dev-kit across projects need those workflows without importing heavyweight lifecycle ceremony.

## Goals

- Preserve the current fast path for tiny, low-risk work.
- Keep the V2 skill set as the core workflow.
- Add only missing, non-overlapping skills.
- Keep all workflows offline-safe and installable without package managers.
- Require `writing-skills` before every skill creation or update.
- Keep routing clear for daily development across projects.

## Non-Goals

- Do not import upstream skills verbatim.
- Do not add browser companion tooling.
- Do not require `npm`, `npx`, network access, or external CLIs.
- Do not create a separate full lifecycle system parallel to `auto-dev-loop`.
- Do not create mandatory design docs for small work.

## Skill Surface

Current skills that stay unchanged:
- `auto-dev-loop`
- `capture-learning`
- `debug-root-cause`
- `docs-review`
- `execute-work`
- `finish-work`
- `plan-work`
- `review-feedback`
- `review-work`
- `shape-work`
- `simplify-work`
- `start-work`
- `tdd-work`
- `verify-work`
- `writing-skills`

New skills to create:
- `worktree-work`: isolated branch/worktree setup and context checks.
- `orchestrate-agents`: safe serial/parallel agent dispatch and reconciliation.

## Daily Workflow Routing

- New task: `start-work`.
- Need isolation: `worktree-work`.
- Vague idea: `shape-work`.
- Written requirements: `plan-work`.
- Plan execution: `execute-work`.
- Need multiple agents outside a single plan task: `orchestrate-agents`.
- Bug or regression: `debug-root-cause`.
- Behavior change: `tdd-work`.
- Completion claim: `verify-work`.
- Diff review: `review-work`.
- Review comments: `review-feedback`.
- Handoff: `finish-work`.

## New Skill Candidates

### `worktree-work`

Trigger: user asks for worktree, isolated branch, safe workspace, or `start-work` recommends isolation for non-trivial work.

Non-overlap: does not implement features. It only creates, selects, verifies, or documents isolation context.

### `orchestrate-agents`

Trigger: user asks to use multiple agents, parallelize work, dispatch subagents, or coordinate independent workstreams.

Non-overlap: does not replace `execute-work`; it can support `execute-work` but also handles research/review/QA dispatch outside a plan.

## Existing Skill Upgrades

No existing skill needs another behavior update in this feature. Recent `shape-work` updates already merged the useful upstream brainstorming pieces.

## Offline And Install Impact

- Add `skills/worktree-work/SKILL.md` and `skills/orchestrate-agents/SKILL.md`.
- Add both skills to `skills/registry.json`.
- Add routing lines to `README.md`, `AGENTS.md`, `scripts/install.sh`, and `scripts/install.ps1`.
- Update `tests/test-skill-structure.sh` required skill list.
- No installer behavior change is required because installers already copy every skill directory.

## Verification Strategy

- `tests/test-upstream-references.sh`
- `tests/test-skill-structure.sh`
- `tests/test-install.sh`
- `python3 -m json.tool skills/registry.json`
- `git diff --check`

## Risks

- Routing overlap between `execute-work` and `orchestrate-agents`: avoid by defining `execute-work` as plan execution and `orchestrate-agents` as coordination policy.
- Worktree commands can be destructive if misused: `worktree-work` must forbid destructive cleanup without explicit approval.
- Too much process: both new skills must route only when their workflow is directly needed.
