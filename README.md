# Agentic Dev System Skills

V2 combined skillset based on `obra/superpowers` and `codeaholicguy/ai-devkit`.

The point is not to collect every possible workflow. The point is to make an agent behave like a careful developer: scope the work, plan only when useful, execute with clean context, verify with fresh evidence, and store lessons that will save time later.

## How To Use

Install the skills into a project, then ask your coding agent for the workflow you want. You can name a skill directly, or describe the intent and let the routing rules pick the skill.

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
| Bug, regression, or failing test | `debug-root-cause` | Proves root cause before any fix |
| Behavior change or bug fix | `tdd-work` | Requires red-green-refactor evidence |
| Diff needs review | `review-work` | Finds correctness risks before handoff |
| Branch is ready to hand off | `finish-work` | Runs final review, verification, and summary |

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
| `debug-root-cause` | Bug, regression, failing test, unexpected behavior | Superpowers systematic-debugging + AI DevKit debug/memory |
| `verify-work` | About to claim something is done, fixed, passing, or ready | Superpowers verification-before-completion + AI DevKit verify |
| `simplify-work` | Refactor, reduce complexity, clean up, improve maintainability | AI DevKit simplify-implementation + Superpowers YAGNI/TDD discipline |
| `capture-learning` | Document code, store reusable knowledge, preserve decisions | AI DevKit memory/capture-knowledge + branch finish learnings |
| `finish-work` | Branch is ready for final review, commit, or PR | Superpowers finish branch + code review workflows |
| `review-work` | Reviewing diffs or implementation against requirements before finishing | Superpowers requesting-code-review + AI DevKit code review |
| `writing-skills` | Creating or improving skills | Superpowers writing-skills retained as a first-class skill |
| `tdd-work` | New behavior, bug fixes, or behavior refactors | Superpowers TDD + AI DevKit TDD |
| `review-feedback` | Receiving PR comments, outside review, or user critique | Superpowers receiving-code-review |
| `docs-review` | Reviewing README, install docs, guides, or skill docs | AI DevKit technical-writer |

## Routing

Add this to an agent instruction file such as `AGENTS.md`:

```markdown
## Skill Routing

- New feature, vague product request, multi-step build -> `start-work`
- Vague product or technical direction needs shaping -> `shape-work`
- Requirements or design already exist -> `plan-work`
- Written implementation plan ready -> `execute-work`
- Autonomous end-to-end lifecycle until verified complete or blocked -> `auto-dev-loop`
- New behavior, bug fix, or behavior refactor -> `tdd-work`
- Bug, failing test, regression, production issue -> `debug-root-cause`
- Any done/fixed/passing/ready claim -> `verify-work`
- Refactor, simplify, reduce complexity -> `simplify-work`
- Understand, document, or remember code/project knowledge -> `capture-learning`
- Received code review feedback -> `review-feedback`
- Review README, install docs, guides, or skill docs -> `docs-review`
- Code review, diff review, implementation check -> `review-work`
- Branch ready for final review, commit, or PR -> `finish-work`
- Create or revise skills -> `writing-skills`
```

## Golden Path

```text
start-work -> shape-work when needed -> plan-work -> execute-work -> review-work -> verify-work -> capture-learning -> finish-work
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

## Upstream References

Reference snapshots from the source projects live under `references/upstream/`:

- `references/upstream/superpowers/`
- `references/upstream/ai-devkit/`

These folders are for future skill and workflow design. They are not installed into target projects.

Refresh them with:

```bash
./scripts/sync-upstream-references.sh
```

## Install

Install the skills into another project:

```bash
./scripts/install.sh /path/to/project
```

On Windows PowerShell:

```powershell
./scripts/install.ps1 -TargetProject C:\path\to\project
```

By default this installs provider-native files:

- Claude: `.claude/skills/` plus `CLAUDE.md`
- OpenCode: `.opencode/skills/` plus `AGENTS.md`
- GitHub Copilot: `.github/prompts/*.prompt.md` plus `.github/copilot-instructions.md`

Registry files are copied next to each provider target:

- Claude: `.claude/registry.json`
- OpenCode: `.opencode/registry.json`
- GitHub Copilot: `.github/dev-kit-registry.json`

Install only selected instruction targets:

```bash
./scripts/install.sh /path/to/project --claude --opencode
```

```powershell
./scripts/install.ps1 -TargetProject C:\path\to\project -Claude -OpenCode
```

Advanced: install selected skill folders to a custom project-relative skills directory instead of provider-native skill folders:

```bash
./scripts/install.sh /path/to/project --skills-dir .claude/skills
```

```powershell
./scripts/install.ps1 -TargetProject C:\path\to\project -SkillsDir .claude/skills
```

Replace an existing installed skill copy:

```bash
./scripts/install.sh /path/to/project --force
```

```powershell
./scripts/install.ps1 -TargetProject C:\path\to\project -Force
```
