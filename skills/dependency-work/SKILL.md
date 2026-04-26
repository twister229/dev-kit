---
name: dependency-work
description: Use when adding, removing, updating, auditing, or diagnosing project dependencies and lockfiles. Detect project conventions first, avoid silent major upgrades, and verify resulting behavior.
---

# Dependency Work

## Purpose

Change dependencies safely by respecting project conventions, minimizing lockfile churn, checking supply-chain risk, and proving the project still works.

## When To Use

- Add a new package or library.
- Remove an unused dependency.
- Update a dependency version.
- Diagnose install, resolution, peer dependency, or lockfile issues.
- Review dependency audit or vulnerability remediation options.

## When Not To Use

- Ordinary feature implementation where dependencies are not changing.
- Bugs unrelated to dependency installation, resolution, or versions: use `debug-root-cause`.
- Production deploys or release operations.
- Broad security audits beyond dependency and lockfile risk.
- Package-manager commands that require credentials or private registries without user approval.

## Hard Rules

- Detect the project package manager and lockfile before running dependency commands.
- Prefer the smallest dependency change that solves the problem.
- Do not perform silent major upgrades.
- Do not rewrite lockfiles wholesale unless that is the explicit, reviewed goal.
- Inspect manifest and lockfile diffs before claiming success.
- Treat install scripts, unexpected transitive changes, private registries, and secret-bearing config files as risk signals.
- If install or regression root cause is unknown, use `debug-root-cause` before changing more dependencies.
- Use `verify-work` before claiming dependency work is complete.

## Workflow

1. Identify the dependency goal: add, remove, update, audit, or diagnose.
2. Detect project conventions.
   - Package manager and lockfile.
   - Workspace layout.
   - Existing dependency grouping and version style.
3. Inspect current state.
   - Manifest files.
   - Lockfiles.
   - Existing tests or build commands.
4. Choose the minimal change.
   - Patch/minor update before major update when possible.
   - Existing dependency before new dependency when feasible.
   - Removal before replacement when dependency is unused.
5. Stop and ask for explicit approval before major version upgrades, credential-dependent installs, private registry access, or destructive lockfile rewrites.
6. Apply the dependency change using the project-local package manager command when approved and available.
7. Inspect manifest and lockfile diffs.
8. Check supply-chain risk.
   - New install scripts.
   - Unexpected package count or source changes.
   - Sensitive config files changed.
9. Run targeted verification.
10. Use `verify-work` for the final completion claim.

## Output Template

```markdown
## Dependency Work

Goal: add | remove | update | audit | diagnose
Package manager: ...
Changed dependencies: ...
Manifest/lockfile changes: ...
Risk checks: ...
Verification: command, exit code, key output
Status: DONE | BLOCKED | NEEDS_DECISION
```

## Evaluation Notes

- Trigger test: "Update lodash to the latest safe patch" should invoke `dependency-work`.
- Negative trigger test: "Implement the settings page" should invoke `start-work` or `tdd-work`, not `dependency-work`.
- Workflow test: A fresh agent detects package manager and lockfile before changing dependencies.
- Failure-mode test: A major version update stops for explicit approval instead of proceeding silently.
- Output test: The report includes package manager, changed dependencies, lockfile impact, risk checks, and verification.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "Just update everything" | Broad updates create avoidable regressions | Make the smallest useful change |
| "The lockfile changed, probably fine" | Lockfiles hide transitive risk | Inspect and summarize lockfile impact |
| "Major versions are usually compatible" | Breaking changes are common | Stop for approval and migration review |
