# TODOS

## P1: Document the Claude Code marketplace publishing process

**What:** Figure out and document the path from "we have `.claude-plugin/plugin.json` in tree" to "dev-kit is listed in the Claude Code plugin marketplace." Research, then write `docs/marketplace-publish.md`.

**Why:** A plugin manifest in a repo doesn't auto-publish. The publish step is currently unknown to this team — could be a PR to anthropic's plugin index, a marketplace API call, a discovery crawler, or "not yet supported, plugin-add only." Without docs, the post-PR-1 publish attempt stalls while someone reverse-engineers.

**Research path:**
1. Run `claude code plugin --help` and look for publish/submit subcommands.
2. Check https://docs.anthropic.com (or wherever Claude Code docs live) for "plugin marketplace."
3. Check anthropic's GitHub orgs for a plugin index / marketplace registry repo.
4. If no documented path exists, file an issue / ask in the appropriate channel and document the answer.

**When:** Immediately after PR 1 (plugin manifest) lands. Block on shipping the marketplace listing.

**Effort:** S (human: ~1-2h research / CC: ~15min if docs exist online)
**Priority:** P1
**Depends on / blocked by:** PR 1 landing (need a real manifest to test publishing against)

## P2: Config schema documentation

**What:** Write `docs/skill-config-schema.md` documenting the per-skill YAML config convention.

**Why:** onboard-project introduces `.claude/config/<skill>.yaml` as a new standard. Without a spec, the second skill to adopt config-reading will invent its own variant. Fragmentation becomes permanent.

**What to include:**
- Resolution order: `.claude/config/<skill-name>.yaml` relative to git root, skip silently if absent
- Standard keys: `test_command`, `lint_command`, `build_command`, `deploy_target`, `branch_prefix`
- Pin syntax: `test_command: npm test  # pin` — pinned keys are skipped on re-run
- Forward-compatibility: unknown keys are ignored
- Extension pattern: how a skill author adds new keys without breaking older configs

**When:** Before the second skill adopts config support. start-work is the first. Log this and close it when a second skill adds `.claude/config/<skill>.yaml` reading.

**Effort:** S (human: ~2 hours / CC: ~10 min)
**Priority:** P2
**Blocked by:** start-work actually reading its config file (validates schema in practice)

## P3: Extract stack detection to shared shell script

**What:** When building `onboard.sh` (the shell-based offline fallback for onboard-project), extract the stack-detection logic into `scripts/detect-stack.sh` so both the AI skill instruction and the shell fallback use the same detection heuristics.

**Why:** onboard-project's AI skill will implement stack detection (Node.js, Python, Go, Rust, etc.). When onboard.sh is built, it will need the same detection. Two separate implementations diverge.

**Detection heuristics (from design doc):**
- `package.json` → Node.js; read `scripts.test` and `scripts.lint`
- `pyproject.toml` or `setup.py` → Python; check for pytest, ruff, black
- `go.mod` → Go; default to `go test ./...` and `golangci-lint run`
- `Cargo.toml` → Rust; default to `cargo test` and `cargo clippy`
- `Makefile` → parse `test:` and `lint:` targets

**When:** Before building onboard.sh. Not needed for onboard-project v1.

**Effort:** S (human: ~1 hour / CC: ~10 min)
**Priority:** P3
**Blocked by:** onboard.sh being scoped for implementation
