# dev-kit

The default agentic dev kit: lifecycle skills, offline-first installer, multi-tool support for Claude, OpenCode, GitHub Copilot, and Codex, project tailoring via `onboard-project`, and a durable repo-local knowledge layer.

25 skills make an AI coding agent behave like a careful developer: scope the work, plan only when useful, execute with clean context, verify with fresh evidence, review security-sensitive changes, and store lessons that save time later.

The skills are sharpened from `obra/superpowers`, `codeaholicguy/ai-devkit`, and `forrestchang/andrej-karpathy-skills`. The lifecycle integration, installer, knowledge layer, and per-project tailoring are dev-kit's own.

## Quick Start

Install into a project:

```bash
./scripts/install.sh /path/to/project
```

On Windows PowerShell:

```powershell
./scripts/install.ps1 -TargetProject C:\path\to\project
```

Then run this in your coding agent inside the target project:

```text
onboard-project
```

The installer is offline-safe. It copies local skill files and updates local instruction files; it does not use package managers, `curl`, or network access.

## Daily Use

Name a skill directly when you know the workflow:

```text
start-work add project-level support for OpenCode installs
auto-dev-loop make the installer idempotent and keep going until verified
debug-root-cause why does the install script fail on paths with spaces?
review-work review the current diff against the plan
finish-work prepare this branch for handoff, but do not commit
```

Or describe intent and let routing rules pick the skill:

```text
I want to add a new feature, but help me scope it first.
This test started failing after my last change. Find the root cause before fixing it.
Check whether this is ready to ship and show fresh verification evidence.
```

For the full operating rhythm, see [`docs/daily-workflow.md`](docs/daily-workflow.md).

## Choose The Right Skill

| Situation | Start With |
|---|---|
| Tiny obvious edit | Direct edit + `verify-work` |
| New feature or unclear task | `start-work` |
| Vague product or technical idea | `shape-work` |
| Requirements are ready | `plan-work` |
| Written plan exists | `execute-work` |
| Want everything handled end-to-end | `auto-dev-loop` |
| Unfamiliar repo or risky subsystem | `codebase-map` |
| Need shared project knowledge | `project-knowledge` |
| Need isolated workspace | `worktree-work` |
| Need multiple agents | `orchestrate-agents` |
| Bug, regression, or failing test | `debug-root-cause` |
| Behavior change or bug fix | `tdd-work` |
| Diff needs review | `review-work` |
| Security-sensitive diff or release | `security-review` |
| Dependency or lockfile work | `dependency-work` |
| Local seed/test data needed | `seed-data-work` |
| Docs need review | `docs-review` |
| Branch is ready to hand off | `finish-work` |

## Onboarding

`onboard-project` tailors the installed dev-kit to your project. It detects stack and commands, then generates:

- `CLAUDE.md`, `AGENTS.md`, and `copilot-instructions.md` routing rules
- `.claude/config/<skill>.yaml` per-skill defaults
- `.claude/routing.md` human-readable routing map
- `docs/ai/knowledge/` project knowledge base

Commit those generated files in the target project. Re-run `onboard-project` after major refactors, stack changes, or stale routing.

To preserve a config value across re-runs, add `# pin` to that line:

```yaml
# .claude/config/start-work.yaml
test_command: npm run test:ci  # pin
lint_command: eslint src/
```

## Updating An Installed Project

When this dev-kit source repo has new commits:

```bash
cd /path/to/dev-kit
git pull
./scripts/install.sh /path/to/project --force
```

On Windows PowerShell:

```powershell
git pull
./scripts/install.ps1 -TargetProject C:\path\to\project -Force
```

`--force` replaces installed skill files and registry entries. It does not touch custom content outside managed markers in `CLAUDE.md`, `AGENTS.md`, or `copilot-instructions.md`, and it does not overwrite `.claude/config/`.

After updating, re-run `onboard-project` so routing reflects new or changed skills.

## Skills

| Skill | Use When |
|---|---|
| `start-work` | Starting a feature, unclear request, or multi-step task |
| `shape-work` | Vague product or technical request needs shaping before planning |
| `plan-work` | Requirements exist and implementation needs sequencing |
| `execute-work` | A written plan is ready to implement |
| `auto-dev-loop` | User wants the full lifecycle to run autonomously until verified complete or blocked |
| `worktree-work` | Creating, selecting, or verifying isolated git worktrees and branches |
| `orchestrate-agents` | Coordinating multiple agents or parallel workstreams |
| `debug-root-cause` | Bug, regression, failing test, unexpected behavior |
| `verify-work` | About to claim something is done, fixed, passing, or ready |
| `simplify-work` | Refactor, reduce complexity, clean up, improve maintainability |
| `codebase-map` | Map a repo or subsystem before refactoring, planning, or handing to another agent |
| `project-knowledge` | Initialize or maintain `docs/ai/knowledge/` so skills share verified project context |
| `capture-learning` | Document code, store reusable knowledge, preserve decisions |
| `context-handoff` | Save or restore one-off working context for paused work or another agent |
| `onboard-project` | Tailor dev-kit to a project after install |
| `finish-work` | Branch is ready for final review, commit, or PR |
| `review-work` | Review diffs or implementation against requirements before finishing |
| `security-review` | Review code, diffs, skills, prompts, installers, configs, or release candidates for security risks |
| `writing-skills` | Create or improve skills |
| `tdd-work` | New behavior, bug fixes, or behavior refactors |
| `review-feedback` | Receiving PR comments, outside review, or user critique |
| `docs-review` | Reviewing README, install docs, guides, or skill docs |
| `dependency-work` | Adding, removing, updating, auditing, or diagnosing dependencies and lockfiles |
| `seed-data-work` | Creating or verifying local dev/test seed data, fixtures, or sample backend rows |
| `release-notes` | Writing changelog entries, release notes, migration notes, or upgrade guidance |

Detailed routing design lives in [`docs/skill-system-shape.md`](docs/skill-system-shape.md).

## Claude Plugin Manifest

This repo includes `.claude-plugin/plugin.json` generated from `skills/registry.json`.

For local plugin testing before marketplace publication:

```bash
claude code plugin add ./dev-kit
```

Marketplace publishing is not automatic. See [`docs/marketplace-publish.md`](docs/marketplace-publish.md) for the checklist.

## Project Layout

| Path | Purpose |
|---|---|
| `skills/` | Source skills installed into target projects |
| `skills/registry.json` | Offline skill registry copied next to provider targets |
| `scripts/install.sh` | macOS/Linux installer |
| `scripts/install.ps1` | Windows PowerShell installer |
| `.github/workflows/ci.yml` | Ubuntu shell checks and Windows PowerShell installer check |
| `tests/` | Smoke tests for installer, manifests, references, and skill structure |
| `docs/ai/evals/` | Skill routing eval prompts for testing skill behavior |
| `docs/daily-workflow.md` | Practical day-to-day usage guide |
| `docs/project-knowledge.md` | User guide for the `project-knowledge` skill |
| `docs/skill-system-shape.md` | Skill taxonomy, routing table, and design decisions |
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
./tests/test-lib-registry.sh
./tests/test-plugin-manifest.sh
./tests/test-sync-derived-files.sh
./tests/test-name-consistency.sh
./tests/test-install.sh
./tests/test-upstream-references.sh
```

On Windows PowerShell, run the installer smoke test:

```powershell
./tests/test-install.ps1
```

GitHub Actions runs the shell suite on Ubuntu and the PowerShell installer smoke test on Windows.

Before tagging a release, wait for the latest `main` CI run to pass on both Ubuntu and Windows.
