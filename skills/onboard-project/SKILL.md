---
name: onboard-project
description: Tailors the installed dev-kit to this project. Detects the stack, reads installed skills, and generates project-specific CLAUDE.md content, per-skill configs, and a routing map. Re-run after major refactors.
---

# Onboard Project

## Purpose

Make the installed dev-kit actually know your project. After `install.sh` puts generic skills in place, `onboard-project` reads your codebase and writes tailored configuration: the right test command, the right lint command, routing rules for installed skills, and per-skill defaults. Teammates who clone and run `install.sh` inherit the full tailored setup automatically.

## When To Use

- Right after running `install.sh` for the first time
- After a major refactor that changes the stack, test runner, or directory structure
- When the routing map or per-skill configs have gone stale

## When Not To Use

- The project was just installed and you haven't written any code yet. Run it after there is something to detect.
- You want to edit the managed block manually. Edit outside the managed markers instead, or use `# pin` in YAML config files to preserve specific values.

## Hard Rules

- Never modify content outside the `<!-- agentic-dev-system:begin -->` / `<!-- agentic-dev-system:end -->` markers in agent instruction files. User content outside those markers is untouchable.
- Never invent skill names not present in the registry. Only installed skills get routing rows.
- If a file write fails, print `Could not write [filepath]: [reason]` and continue to the next file. Do not abort the entire skill run.
- Never execute test or lint commands during onboarding. Write the commands as strings; do not run them.
- Only invoke `codebase-map` and `project-knowledge` if they appear in the installed `.claude/registry.json`. If not present, skip that step and note it in the summary.

## Workflow

### Step 1: Read the installed skills registry

Look for `.claude/registry.json` in the project root. If absent, look for `.opencode/registry.json`. If neither exists, print:

```
No registry found. Run install.sh first, then re-run onboard-project.
```

Exit with no file changes.

Parse the `skills` array. Each entry has a `name` and `description` field. These are the only skills that get routing rows.

### Step 2: Detect the project stack

Read the following files if present. Stop at the first match for language detection; continue for all to find commands.

**Language detection (first match wins):**

- `package.json` present → **Node.js**
  - Read `scripts.test` → `test_command`
  - Read `scripts.lint` → `lint_command`
  - Read `scripts.build` → `build_command`
  - If no `scripts.test`, `test_command` is omitted (not a placeholder)
- `pyproject.toml` or `setup.py` present → **Python**
  - Default `test_command: pytest`
  - Check `[tool.ruff]` or `ruff` in deps → `lint_command: ruff check .`
  - Else check `black` in deps → `lint_command: black --check .`
  - Else omit `lint_command`
- `go.mod` present → **Go**
  - Default `test_command: go test ./...`
  - Default `lint_command: golangci-lint run`
- `Cargo.toml` present → **Rust**
  - Default `test_command: cargo test`
  - Default `lint_command: cargo clippy`
- No match → **unknown** (omit test and lint commands entirely)

**Branch prefix detection (all stacks):**

Run `git log --format='%D' --decorate-refs=refs/heads -20` or read recent branch names from git. Infer `branch_prefix` from the most common prefix pattern (e.g., `feat/`, `fix/`, `feature/`). If no pattern is clear, omit `branch_prefix`.

**Deploy target detection (all stacks):**

- `fly.toml` present → `deploy_target: fly`
- `vercel.json` or `.vercel/` present → `deploy_target: vercel`
- `render.yaml` present → `deploy_target: render`
- `.github/workflows/deploy*.yml` present → `deploy_target: github-actions`
- Else omit `deploy_target`

### Step 3: Generate managed block content

Construct the content that will replace the managed block in each agent instruction file.

The managed block content is the project-specific routing section. It replaces the generic routing block that `install.sh` wrote. Structure:

```
<!-- agentic-dev-system:begin -->
## Agentic Dev System — [Project Name]

Stack: [detected language]
Test: [test_command or "not detected"]
Lint: [lint_command or "not detected"]

When the user's request matches one of these workflows, use the matching skill:

[one row per installed skill from the registry, format: - [intent description] -> `[skill-name]`]

Golden path: `start-work -> codebase-map/project-knowledge when context is missing -> shape-work when needed -> plan-work -> execute-work -> review-work -> verify-work -> capture-learning/project-knowledge -> finish-work`

Fast path: for tiny low-risk tasks, make the change, run `verify-work`, and report evidence.

Core rules:
- No fixes without root cause for bugs.
- No completion claims without fresh command output.
- No production code for behavior changes without a failing test first unless explicitly approved.
- Spec compliance review comes before code quality review.
- Store only reusable, verified knowledge. Never store secrets, transcripts, or one-off progress.
- Some duplication beats the wrong abstraction.

See .claude/routing.md for the full routing map with notes.
<!-- agentic-dev-system:end -->
```

For **project name**: use the value of `name` from `package.json`, or the directory basename if absent.

For **routing rows**: generate one row per skill in the registry. Use the skill's `description` field as the intent, and its `name` as the skill name. Example:
```
- New feature, unclear request, or multi-step task -> `start-work`
- Vague or exploratory product/technical request -> `shape-work`
```

### Step 4: Write agent instruction files

Apply the managed block to each agent instruction file that exists or should exist:

**Targets:**
- `CLAUDE.md` (always — create if absent)
- `.opencode/AGENTS.md` (only if `.opencode/` directory exists)
- `.github/copilot-instructions.md` (only if `.github/` directory exists)

**For each target file:**

1. If the file contains `<!-- agentic-dev-system:begin -->`: replace everything between the begin and end markers with the new managed block content. Preserve all content before the begin marker and after the end marker exactly.
2. If the file exists but has no markers: append the managed block after a blank line.
3. If the file does not exist: create it containing only the managed block.
4. If the write fails: print `Could not write [filepath]: [reason]` and continue to the next file.

After writing, print: `Updated [filepath]`

### Step 5: Write per-skill config files

For each skill in the registry, write `.claude/config/[skill-name].yaml`.

Create `.claude/config/` if it does not exist.

Config file format:
```yaml
# Generated by onboard-project. Edit values freely.
# Add "  # pin" to any value to preserve it on re-run.
# Example: test_command: npm test  # pin
test_command: [value]
lint_command: [value]
```

Rules:
- Only write keys that have detected values. Do not write `test_command: ~` or empty placeholders.
- If the config file already exists, check each key: if the line ends with `# pin`, preserve that key's current value exactly. Regenerate all other keys.
- If the write fails: print `Could not write [filepath]: [reason]` and continue.

### Step 6: Write .claude/routing.md

Write `.claude/routing.md` with a full routing table. Create `.claude/` if needed.

Format:
```markdown
# Skill Routing

Generated by onboard-project. Re-run to update.

| Intent | Skill | When |
|--------|-------|------|
[one row per installed skill]
```

For each row: use the skill's `name` as the Skill column, the `description` as the Intent column, and a short contextual note in the When column (inferred from the description — e.g., "debug-root-cause" gets "Bug, regression, or unexpected behavior").

### Step 7: Print summary

Print a structured summary:

```
onboard-project complete
  Stack:         [detected language]
  Test:          [test_command or "not detected"]
  Lint:          [lint_command or "not detected"]
  Skills:        [N] installed
  Updated:       CLAUDE.md [, .opencode/AGENTS.md] [, .github/copilot-instructions.md]
  Configs:       .claude/config/ ([N] files)
  Routing map:   .claude/routing.md ([N] rows)
  Codebase map:  docs/ai/implementation/map-codebase.md [or "skipped (codebase-map not installed)"]
  Knowledge:     docs/ai/knowledge/ ([N] docs initialized) [or "skipped (project-knowledge not installed)"]
```

If any file write failed, add: `Warnings: [N] write error(s) — see above for details`

### Step 8: Run codebase-map

Check if `codebase-map` appears in the installed skills (read `.claude/registry.json`, look for an entry with `"name": "codebase-map"`). If absent, print `Codebase map: skipped (codebase-map not installed)` in the summary and continue to step 9.

If present, invoke the `codebase-map` skill inline as a sub-step:
- Scope: whole repo
- Question: "What are the main components, entry points, data flows, and risk areas of this project?"
- Output: write the durable map to `docs/ai/implementation/map-codebase.md`
  - Create `docs/ai/implementation/` if it does not exist
  - If the file already exists, replace it with the fresh map

If `codebase-map` produces no output or errors out: print a warning in the summary line (`Codebase map: warning — codebase-map ran but produced no output. architecture.md will be empty.`) and continue to step 9 without `architecture.md` content.

### Step 9: Initialize project-knowledge

Check if `project-knowledge` appears in the installed skills (`.claude/registry.json`). If absent, print `Knowledge: skipped (project-knowledge not installed)` and end.

If present, invoke the `project-knowledge` skill inline to initialize the knowledge base:
- Action: initialize (or update if `docs/ai/knowledge/` already exists)
- Use the codebase-map output from step 8 as input for `architecture.md` (if available)
- Follow `project-knowledge`'s initialize workflow exactly:
  - Create `docs/ai/knowledge/` and `docs/ai/knowledge/modules/`
  - Create `index.md` with last-verified date, repo purpose, coverage table, and recommended read order
  - Create `architecture.md` from the codebase-map output (if step 8 ran and succeeded)
  - Create `conventions.md` from detected stack patterns and existing code conventions
  - Create starter module docs for key components identified in the codebase map
  - Mark unknown areas as "Unknown / not mapped yet" — no speculation

If `docs/ai/knowledge/` already exists (re-run behavior):
- Update `index.md` freshness date
- Update `architecture.md` if codebase-map produced new output
- Add new module docs for newly detected components
- Do NOT overwrite any doc that was manually modified — leave manual content untouched

## Output

- `CLAUDE.md`: managed block replaced with project-specific routing and commands
- `.opencode/AGENTS.md`: same (if .opencode/ exists)
- `.github/copilot-instructions.md`: same (if .github/ exists)
- `.claude/config/[skill].yaml`: per-skill defaults for each installed skill
- `.claude/routing.md`: human-readable routing table
- `docs/ai/implementation/map-codebase.md`: whole-repo codebase map (if codebase-map installed)
- `docs/ai/knowledge/`: initialized knowledge base with index, architecture, conventions, and module docs (if project-knowledge installed)

## Evaluation Notes

- Trigger test: "onboard-project" or "tailor this setup" should invoke this skill.
- Registry test: routing map contains only skills from `.claude/registry.json`.
- Idempotency test: running twice produces the same output (no duplicated markers, no lost content).
- Pin test: a YAML key with `# pin` is preserved after re-run.
- Error test: a write failure prints a message and the skill continues.
- Stack test: a project with `package.json` containing `scripts.test` gets the exact value in its YAML config.
- Golden path test: generated CLAUDE.md managed block includes `codebase-map/project-knowledge` in the golden path.
- Knowledge test: `docs/ai/knowledge/index.md` exists and contains the project purpose after onboard-project runs.
- Graceful skip test: with codebase-map and project-knowledge absent from registry, steps 8-9 are skipped and summary says "skipped".
