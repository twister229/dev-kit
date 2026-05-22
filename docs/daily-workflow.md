# Daily Workflow

Use dev-kit as the default operating rhythm for everyday coding. The goal is not to run every skill every time; the goal is to start with the right amount of structure, keep evidence fresh, and avoid silent scope drift.

## Start The Day Or A New Task

Begin with the smallest prompt that captures the outcome you want.

```text
start-work add support for installing selected skills only
```

For routine low-risk edits, skip planning and ask for the direct change plus verification.

```text
Fix the typo in the install docs and run verify-work for the README diff.
```

## Shape Before Planning When The Request Is Fuzzy

If the work is ambiguous, use `shape-work` before writing a plan. This is useful for product decisions, workflow changes, API shape, or competing implementation approaches.

```text
shape-work think through the best daily workflow for using these skills in a real project
```

Stop shaping when the desired user outcome, constraints, out-of-scope boundaries, and acceptance signals are clear.

## Plan Only When Sequencing Matters

Use `plan-work` for multi-file changes, risky behavior, or work you want another agent to execute from a clean context.

```text
plan-work turn this shaping brief into implementation tasks with files, tests, and commands
```

Do not create lifecycle docs for typo-level work, simple docs edits, or changes with one obvious verification command.

## Execute With Tests And Review Gates

Use `execute-work` when a plan exists. Use `tdd-work` directly when you are implementing a small behavior change.

```text
execute-work implement task 1 from the implementation plan
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

Use `codebase-map` before planning or refactoring when the repo or subsystem is unfamiliar.

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

## Verify Before You Believe The Work

Run `verify-work` before saying anything is done, fixed, passing, ready, or complete.

```text
verify-work prove the installer still works for Claude and OpenCode targets
```

Good daily habit: make the agent report the command, exit code, key output, and result. If verification fails, keep working or report the blocker instead of softening the claim.

## Review Before Handoff

Use `review-work` before finishing a meaningful diff, especially if an agent wrote the code.

```text
review-work review the current diff for correctness, missed requirements, and test gaps
```

Use `security-review` when the diff touches prompts, tools, installers, config, secrets, auth, data exposure, or release packaging.

```text
security-review review this installer and prompt diff before release
```

If review comments arrive later, use `review-feedback` instead of blindly applying them.

```text
review-feedback evaluate these PR comments and implement only the accepted items
```

## Keep Project Knowledge Useful

Use `project-knowledge` for the shared repo knowledge base: architecture, flows, module maps, conventions, decisions, and verified failure patterns under `docs/ai/knowledge/`.

```text
project-knowledge update the module map for the installer after this refactor
```

Use `capture-learning` for a specific verified reusable lesson that should be stored in local memory or promoted into project knowledge.

```text
capture-learning store the verified installer path-handling convention
```

Do not store transcripts, raw logs, secrets, speculation, or one-off progress.

## Finish The Work Cleanly

End with `finish-work` when the branch or task is ready for handoff.

```text
finish-work prepare a final summary with verification evidence. Do not commit or push.
```

Only ask for commit, push, PR, or deploy when you actually want those actions.

## Common Loops

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
