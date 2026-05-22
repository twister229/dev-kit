# Skill System Shape

## Goals

- Keep the skill system lifecycle-first and easy to route.
- Preserve evidence-before-claims, root-cause debugging, TDD for behavior changes, and offline-safe defaults.
- Add only daily developer workflows that do not fit existing skills cleanly.
- Avoid domain-specific skill sprawl in the core set.

## Current Skill Set

Keep all existing local skills in this slice. The current set already covers shaping, planning, execution, TDD, debugging, review, verification, simplification, durable learning, docs review, agent orchestration, worktrees, finishing, and skill authoring.

No existing local skill is removed because each has a distinct job. The improvement is clearer routing plus three missing workflows.

## Target Categories

Core workflow:
- `start-work`, `shape-work`, `plan-work`, `execute-work`, `finish-work`, `auto-dev-loop`

Quality gates:
- `tdd-work`, `debug-root-cause`, `review-work`, `verify-work`, `review-feedback`, `security-review`

Maintenance and knowledge:
- `simplify-work`, `capture-learning`, `codebase-map`, `project-knowledge`, `docs-review`, `writing-skills`, `release-notes`, `dependency-work`

Coordination and isolation:
- `worktree-work`, `orchestrate-agents`, `context-handoff`

Setup and onboarding:
- `onboard-project`

## Skills

`context-handoff` saves or restores one-off working context for paused tasks, long sessions, context-limit handoffs, and agent transfers. It is separate from `capture-learning`, which stores durable reusable project knowledge, and from `finish-work`, which prepares completed work for final handoff.

`dependency-work` handles dependency add, remove, update, audit, and diagnosis workflows. It is separate because dependency changes affect lockfiles, supply-chain risk, package-manager conventions, and verification strategy.

`release-notes` turns completed changes into changelog entries, release notes, migration notes, and upgrade guidance. It is separate from `finish-work` because release communication is not the same as final branch readiness, and separate from `docs-review` because it is generated from evidence about shipped changes.

`codebase-map` produces a lightweight, evidence-backed map of a repo or subsystem — nodes, edges, entry points, impact boundaries — before planning, refactoring, reviewing, or handing work to another agent. It is separate from `start-work` because mapping is an analysis step that produces a durable artifact; it is separate from `capture-learning` because mapping is a precondition for storing knowledge, not a knowledge-storage action.

`project-knowledge` initializes and maintains `docs/ai/knowledge/` — a repo-local knowledge base of architecture, flows, conventions, decisions, failure patterns, and module maps. It is separate from `capture-learning` because project knowledge is broadly shared context (architecture, module boundaries, conventions) while `capture-learning` stores narrow reusable lessons. It is separate from `codebase-map` because knowledge is curated, persistent, and referenced by multiple skills; a codebase map is a step in the analysis that knowledge builds on.

`onboard-project` runs after `install.sh` and tailors the installed dev-kit to the target project: detects stack and test/lint commands, generates project-specific routing in all three agent instruction files (CLAUDE.md, AGENTS.md, copilot-instructions.md), writes per-skill YAML configs, creates a routing map, and initializes the project knowledge base via `codebase-map` and `project-knowledge`.

## Skills Not Added

Do not add more domain-specific skills in this slice for frontend, backend, database, deployment, cloud providers, performance, API design, or QA. Add those later only if repeated real workflows justify them.

`security-review` is included because installer, prompt, plugin, and release-packaging changes are a recurring dev-kit risk surface.

Do not add a separate commit skill yet. `finish-work` already handles commit, push, and PR preparation when explicitly requested.

## Routing Table

| User Intent | Skill |
|---|---|
| Build, add, implement, or create non-trivial work | `start-work` |
| Think through an unclear idea | `shape-work` |
| Write an implementation plan | `plan-work` |
| Execute an existing plan | `execute-work` |
| Debug a bug, failing test, regression, or error | `debug-root-cause` |
| Add or change behavior safely | `tdd-work` |
| Review a diff, PR, or implementation | `review-work` |
| Review security-sensitive code, prompts, installers, configs, or release candidates | `security-review` |
| Evaluate received review comments | `review-feedback` |
| Prove work is done, fixed, or passing | `verify-work` |
| Simplify or refactor for maintainability | `simplify-work` |
| Review or improve documentation | `docs-review` |
| Store verified reusable project knowledge | `capture-learning` |
| Map an unfamiliar repo or subsystem before changing it | `codebase-map` |
| Initialize, update, or query the repo-local knowledge base | `project-knowledge` |
| Save or restore paused session context | `context-handoff` |
| Add, remove, update, audit, or diagnose dependencies | `dependency-work` |
| Write changelog, release notes, migration notes, or upgrade guidance | `release-notes` |
| Finish branch, final review, commit, PR, or handoff prep | `finish-work` |
| Create or improve skills | `writing-skills` |
| Run the lifecycle autonomously until verified or blocked | `auto-dev-loop` |
| Tailor dev-kit to this project after install | `onboard-project` |

## Acceptance Signals

- A developer can start with `build X` and the agent routes through `start-work`.
- Bugs go through root-cause analysis before fixes.
- Behavior changes use TDD unless explicitly exempted.
- Completion claims include fresh verification evidence.
- Paused work can be resumed without polluting durable memory.
- Dependency changes have explicit lockfile and supply-chain guardrails.
- Release communication is evidence-based and does not invent shipped behavior.
- The core skill set stays compact and general-purpose.
