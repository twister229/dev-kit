# Agentic Dev System Skills

Combined skillset based on `obra/superpowers` and `codeaholicguy/ai-devkit`.

The point is not to collect every possible workflow. The point is to make an agent behave like a careful developer: scope the work, plan only when useful, execute with clean context, verify with fresh evidence, and store lessons that will save time later.

## How To Use

Install the skills into a project, then ask your coding agent for the workflow you want. You can name a skill directly, or describe the intent and let the routing rules pick the skill.

Quick install from this repository:

```bash
./scripts/install.sh /path/to/project
```

On Windows PowerShell:

```powershell
./scripts/install.ps1 -TargetProject C:\path\to\project
```

The installer is offline-safe. It copies local skill files and updates local instruction files; it does not use package managers, `curl`, or network access.

Use direct skill names when you know the workflow:

```text
start-work add project-level support for OpenCode installs
auto-dev-loop make the installer idempotent and keep going until verified
debug-root-cause why does the install script fail on paths with spaces?
review-work review the current diff against the plan
finish-work prepare this branch for handoff, but do not commit
```

Use intent-based prompts when you want the agent to choose the path:

```text
I want to add a new feature, but help me scope it first.
This test started failing after my last change. Find the root cause before fixing it.
This module works, but it is too complex. Simplify it without changing behavior.
I received these PR comments. Evaluate them and only implement the ones that are technically right.
Check whether this is ready to ship and show fresh verification evidence.
```

Pick the smallest workflow that fits the risk:

| Situation | Start With | Why |
|---|---|---|
| Tiny obvious edit | Direct edit + `verify-work` | Avoid process for typo-level work |
| New feature or unclear task | `start-work` | Classifies risk and chooses the next workflow |
| Vague product or technical idea | `shape-work` | Turns ambiguity into a concrete slice |
| Requirements are ready | `plan-work` | Produces executable tasks with files and commands |
| Written plan exists | `execute-work` | Implements task-by-task with review gates |
| Want everything handled end-to-end | `auto-dev-loop` | Runs the lifecycle until verified complete or blocked |
| Unfamiliar repo or risky subsystem | `codebase-map` | Maps nodes, edges, entry points, and impact before planning or refactoring |
| Need shared project knowledge | `project-knowledge` | Initializes or maintains repo-local architecture, flow, convention, and module knowledge |
| Need isolated workspace | `worktree-work` | Creates or selects a safe branch/worktree context |
| Need multiple agents | `orchestrate-agents` | Coordinates independent workstreams without file conflicts |
| Bug, regression, or failing test | `debug-root-cause` | Proves root cause before any fix |
| Behavior change or bug fix | `tdd-work` | Requires red-green-refactor evidence |
| Diff needs review | `review-work` | Finds correctness risks before handoff |
| Dependency or lockfile work | `dependency-work` | Handles dependency changes with convention checks |
| Docs need review | `docs-review` | Reviews README, install docs, guides, or skill docs |
| Branch is ready to hand off | `finish-work` | Runs final review, verification, and summary |

## Onboarding

After installing, run `onboard-project` in your AI agent to tailor the setup to your project:

```text
onboard-project
```

This reads your project's stack (Node.js, Python, Go, Rust, or detected from config files), installed skills, and existing conventions, then generates:

- **CLAUDE.md / AGENTS.md / copilot-instructions.md** — replaces the generic routing block with project-specific routing rules, your actual test command, and your actual lint command
- **`.claude/config/<skill>.yaml`** — per-skill defaults so skills know your exact commands without asking
- **`.claude/routing.md`** — a human-readable routing map showing which skill handles which task in this project
- **`docs/ai/knowledge/`** — initialized knowledge base (architecture, flows, conventions, module maps) that skills read before planning and debugging

Once generated, commit these files. Teammates who clone and run `install.sh` inherit the full tailored setup automatically — no need to run `onboard-project` again.

Re-run `onboard-project` after major refactors, stack changes, or when the routing map has gone stale.

To preserve a specific config value across re-runs, add `# pin` to that line:

```yaml
# .claude/config/start-work.yaml
test_command: npm run test:ci  # pin
lint_command: eslint src/
```

## Daily Workflow

Use the dev-kit as the default operating rhythm for everyday coding. The goal is not to run every skill every time; the goal is to start with the right amount of structure, keep evidence fresh, and avoid silent scope drift.

### 1. Start The Day Or A New Task

Begin with the smallest prompt that captures the outcome you want.

```text
start-work add support for installing selected skills only
```

For routine low-risk edits, skip planning and ask for the direct change plus verification.

```text
Fix the typo in the install docs and run verify-work for the README diff.
```

### 2. Shape Before Planning When The Request Is Fuzzy

If the work is ambiguous, use `shape-work` before writing a plan. This is useful for product decisions, workflow changes, API shape, or competing implementation approaches.

```text
shape-work think through the best daily workflow for using these skills in a real project
```

Stop shaping when the desired user outcome, constraints, out-of-scope boundaries, and acceptance signals are clear.

### 3. Plan Only When Sequencing Matters

Use `plan-work` for multi-file changes, risky behavior, or work you want another agent to execute from a clean context.

```text
plan-work turn this shaping brief into implementation tasks with files, tests, and commands
```

Do not create lifecycle docs for typo-level work, simple docs edits, or changes with one obvious verification command.

### 4. Execute With Tests And Review Gates

Use `execute-work` when a plan exists. Use `tdd-work` directly when you are implementing a small behavior change.

```text
execute-work implement task 1 from docs/ai/planning/feature-selected-skills.md
tdd-work add regression coverage for paths with spaces in the installer
```

For broken behavior, switch to `debug-root-cause` before changing code.

```text
debug-root-cause the install script fails when the target project path contains spaces
```

Use `worktree-work` before implementation when the work needs an isolated filesystem context.

```text
worktree-work create an isolated worktree for the selected-skills installer feature
```

Use `codebase-map` before planning/refactoring when the repo or subsystem is unfamiliar.

```text
codebase-map map the auth flow before we refactor session handling
```

Use `project-knowledge` when that map should become durable context other skills can reuse.

```text
project-knowledge initialize repo-local knowledge and promote the auth map into docs/ai/knowledge
```

Use `orchestrate-agents` when multiple independent streams can safely run without touching the same files.

```text
orchestrate-agents split reference analysis and README updates into non-overlapping workstreams
```

### 5. Verify Before You Believe The Work

Run `verify-work` before saying anything is done, fixed, passing, ready, or complete.

```text
verify-work prove the installer still works for Claude and OpenCode targets
```

Good daily habit: make the agent report the command, exit code, key output, and result. If verification fails, keep working or report the blocker instead of softening the claim.

### 6. Review Before Handoff

Use `review-work` before finishing a meaningful diff, especially if an agent wrote the code.

```text
review-work review the current diff for correctness, missed requirements, and test gaps
```

If review comments arrive later, use `review-feedback` instead of blindly applying them.

```text
review-feedback evaluate these PR comments and implement only the accepted items
```

### 7. Keep Project Knowledge Useful

Use `project-knowledge` for the shared repo knowledge base: architecture, flows, module maps, conventions, decisions, and verified failure patterns under `docs/ai/knowledge/`.

```text
project-knowledge update the module map for the installer after this refactor
```

Use `capture-learning` for a specific verified reusable lesson that should be stored in local memory or promoted into project knowledge.

```text
capture-learning store the verified installer path-handling convention
```

Do not store transcripts, raw logs, secrets, speculation, or one-off progress.

### 8. Finish The Work Cleanly

End with `finish-work` when the branch or task is ready for handoff.

```text
finish-work prepare a final summary with verification evidence. Do not commit or push.
```

Only ask for commit, push, PR, or deploy when you actually want those actions.

### Common Daily Loops

| Loop | Use |
|---|---|
| Tiny docs fix | Direct edit -> `verify-work` |
| Small behavior change | `tdd-work` -> `review-work` -> `verify-work` |
| Planned feature | `start-work` -> `plan-work` -> `execute-work` -> `finish-work` |
| Ambiguous product work | `start-work` -> `shape-work` -> `plan-work` |
| Regression | `debug-root-cause` -> `tdd-work` -> `verify-work` |
| Isolated feature | `worktree-work` -> `start-work` -> `execute-work` |
| Parallel workstreams | `orchestrate-agents` -> `review-work` -> `verify-work` |
| Agent-written diff | `review-work` -> fixes -> `verify-work` |
| Unattended implementation | `auto-dev-loop` until complete or blocked |

## Use Cases

### Build A Feature End-To-End

Use `auto-dev-loop` when you want the agent to keep moving without asking for every phase approval.

```text
auto-dev-loop add a docs-only install verification command and update README usage examples. Keep going until verified.
```

Expected behavior: the agent scopes the request, plans only if useful, implements the smallest correct change, reviews the diff, runs verification, captures durable learning only if warranted, and stops when complete or blocked.

### Plan Before Coding

Use `start-work` followed by `plan-work` when the task has enough risk that sequencing matters.

```text
start-work add support for installing only selected skills
```

Expected behavior: the agent produces a start brief with goal, scope, risk, baseline, and recommended next skill. If requirements are ready, continue with `plan-work` to produce exact tasks.

### Fix A Regression Safely

Use `debug-root-cause` for broken behavior, failing tests, build failures, or production issues.

```text
debug-root-cause the PowerShell installer stopped updating AGENTS.md routing blocks
```

Expected behavior: the agent reproduces or gathers evidence, traces the root cause, writes or identifies a failing signal, fixes the root cause, and uses `verify-work` before claiming the fix.

### Handle Review Feedback

Use `review-feedback` when another reviewer, model, or teammate suggested changes.

```text
review-feedback address these PR comments, but push back on anything that adds unnecessary abstraction
```

Expected behavior: the agent lists all feedback, classifies each item as accepted, rejected, clarification needed, or deferred, then implements accepted items with verification.

### Finish Without Shipping

Use `finish-work` when implementation is complete but you want a clean handoff instead of an automatic commit or PR.

```text
finish-work prepare the branch summary and verification evidence. Do not commit or push.
```

Expected behavior: the agent inspects the worktree, reviews the diff if needed, runs final verification, reports risks, and prepares a handoff. It does not commit, push, or create a PR unless explicitly asked.

## Skills

| Skill | Use When | Combines |
|---|---|---|
| `start-work` | Starting a feature, unclear request, or multi-step task | Superpowers brainstorming/worktrees + AI DevKit lifecycle |
| `shape-work` | Vague product or technical request needs shaping before planning | Superpowers brainstorming + AI DevKit requirement/design review |
| `plan-work` | Requirements exist and implementation needs sequencing | Superpowers writing-plans + AI DevKit requirements/design review |
| `execute-work` | A written plan is ready to implement | Superpowers subagent-driven-development + AI DevKit agent orchestration |
| `auto-dev-loop` | User wants the full lifecycle to run autonomously until verified complete or blocked | Agentic Dev System golden path loop |
| `worktree-work` | Creating, selecting, or verifying isolated git worktrees and branches | Superpowers using-git-worktrees |
| `orchestrate-agents` | Coordinating multiple agents or parallel workstreams | Superpowers dispatching-parallel-agents + AI DevKit agent orchestration |
| `debug-root-cause` | Bug, regression, failing test, unexpected behavior | Superpowers systematic-debugging + AI DevKit debug/memory |
| `verify-work` | About to claim something is done, fixed, passing, or ready | Superpowers verification-before-completion + AI DevKit verify |
| `simplify-work` | Refactor, reduce complexity, clean up, improve maintainability | AI DevKit simplify-implementation + Superpowers YAGNI/TDD discipline |
| `codebase-map` | Map a repo or subsystem before refactoring, planning, or handing to another agent | Knowledge-graph workflows adapted for Markdown-first offline use |
| `project-knowledge` | Initialize or maintain `docs/ai/knowledge/` so all skills share verified architecture and convention context | Understand-Anything patterns, offline and Markdown-first |
| `capture-learning` | Document code, store reusable knowledge, preserve decisions | AI DevKit memory/capture-knowledge + branch finish learnings |
| `context-handoff` | Saving or restoring one-off working context for paused work or another agent | Safe local handoff discipline |
| `onboard-project` | Tailors dev-kit to a project after install: detects stack, writes configs, generates knowledge base | Combines stack detection, skill routing, and knowledge initialization |
| `finish-work` | Branch is ready for final review, commit, or PR | Superpowers finish branch + code review workflows |
| `review-work` | Reviewing diffs or implementation against requirements before finishing | Superpowers requesting-code-review + AI DevKit code review |
| `writing-skills` | Creating or improving skills | Superpowers writing-skills retained as a first-class skill |
| `tdd-work` | New behavior, bug fixes, or behavior refactors | Superpowers TDD + AI DevKit TDD |
| `review-feedback` | Receiving PR comments, outside review, or user critique | Superpowers receiving-code-review |
| `docs-review` | Reviewing README, install docs, guides, or skill docs | AI DevKit technical-writer |
| `dependency-work` | Adding, removing, updating, auditing, or diagnosing dependencies and lockfiles | Dependency convention and verification workflow |
| `release-notes` | Writing changelog entries, release notes, migration notes, or upgrade guidance | Evidence-based release communication |

## Routing

Add this to an agent instruction file such as `AGENTS.md`:

```markdown
## Skill Routing

- New feature, vague product request, multi-step build -> `start-work`
- Vague product or technical direction needs shaping -> `shape-work`
- Requirements or design already exist -> `plan-work`
- Written implementation plan ready -> `execute-work`
- Autonomous end-to-end lifecycle until verified complete or blocked -> `auto-dev-loop`
- Isolated git worktree or branch context needed -> `worktree-work`
- Multiple agents or parallel workstreams need coordination -> `orchestrate-agents`
- New behavior, bug fix, or behavior refactor -> `tdd-work`
- Bug, failing test, regression, production issue -> `debug-root-cause`
- Any done/fixed/passing/ready claim -> `verify-work`
- Refactor, simplify, reduce complexity -> `simplify-work`
- Understand or map an unfamiliar repo/subsystem before changing it -> `codebase-map`
- Initialize, update, query, or maintain repo-local knowledge for future agents -> `project-knowledge`
- Document or remember a specific verified reusable lesson -> `capture-learning`
- Save or restore one-off working context -> `context-handoff`
- Received code review feedback -> `review-feedback`
- Review README, install docs, guides, or skill docs -> `docs-review`
- Add, remove, update, audit, or diagnose dependencies -> `dependency-work`
- Code review, diff review, implementation check -> `review-work`
- Branch ready for final review, commit, or PR -> `finish-work`
- Changelog, release notes, migration notes, or upgrade guidance -> `release-notes`
- Create or revise skills -> `writing-skills`
- Tailor dev-kit to this project after install -> `onboard-project`
```

## Golden Path

```text
start-work -> codebase-map/project-knowledge when context is missing -> shape-work when needed -> plan-work -> execute-work -> review-work -> verify-work -> capture-learning/project-knowledge -> finish-work
```

## Fast Path

For tiny low-risk tasks, do not create lifecycle docs. Make the change, run `verify-work`, and report the evidence.

## Core Rules

- Default to speed. Escalate to rigor when risk appears.
- No fixes without root cause for bugs.
- No completion claims without fresh command output.
- Use fresh implementation context for non-trivial tasks.
- Spec compliance review comes before code quality review.
- Store only reusable, verified knowledge. Do not store transcripts, secrets, or one-off progress.
- Some duplication beats the wrong abstraction.

## Offline Guarantee

Installers do not use `npm`, `npx`, `curl`, package managers, or network access. They copy files from this repository into the target project and update local instruction files.

Project memory is plain Markdown under `docs/ai/memory/` or `.agentic-dev-system/memory/`. No database or external CLI is required.

## Project Layout

| Path | Purpose |
|---|---|
| `skills/` | Source skills installed into target projects |
| `skills/registry.json` | Offline skill registry copied next to provider targets |
| `scripts/install.sh` | macOS/Linux installer |
| `scripts/install.ps1` | Windows PowerShell installer |
| `tests/` | Shell and PowerShell smoke tests for installer and skill structure |
| `docs/ai/evals/` | Skill routing eval prompts for testing skill behavior |
| `docs/project-knowledge.md` | User guide for the `project-knowledge` skill |
| `references/upstream/` | Local source-project snapshots, not installed into target projects |

## Upstream References

Reference snapshots from the source projects live under `references/upstream/`:

- `references/upstream/superpowers/`
- `references/upstream/ai-devkit/`
- `references/upstream/andrej-karpathy-skills/`

These folders are for skill and workflow design. They are not installed into target projects.

Refresh them with:

```bash
./scripts/sync-upstream-references.sh
```

## Verify This Repository

Run the local checks before changing installer or skill structure behavior:

```bash
./tests/test-skill-structure.sh
./tests/test-install.sh
./tests/test-upstream-references.sh
```

On Windows PowerShell, run the installer smoke test:

```powershell
./tests/test-install.ps1
```
