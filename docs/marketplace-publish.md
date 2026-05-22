# Claude Code Plugin Marketplace Publishing

`dev-kit` now has `.claude-plugin/plugin.json`, but a manifest in the repo does not publish the plugin by itself.

## Current Install Paths

### Local Clone

Use this before marketplace publication:

```bash
claude code plugin add ./dev-kit
```

Then verify a fresh project receives the expected skills and routing files.

### Marketplace Pattern Observed Upstream

`obra/superpowers` documents two Claude Code marketplace paths:

```bash
/plugin install superpowers@claude-plugins-official
```

and a repository-backed marketplace:

```bash
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

For `dev-kit`, this implies two possible publication routes:

1. Official Anthropic marketplace listing, if submissions are available.
2. Repository-backed marketplace, if Claude Code supports third-party marketplace registration for this repo.

## Publish Checklist

1. Confirm the current Claude Code plugin CLI surface:

```bash
claude code plugin --help
```

Look for publish, submit, marketplace, or registry commands.

2. Confirm manifest freshness:

```bash
./scripts/sync-derived-files.sh
./tests/test-plugin-manifest.sh
./tests/test-sync-derived-files.sh
```

3. Verify the local install path from a clean checkout:

```bash
claude code plugin add ./dev-kit
```

4. If official submission exists, publish using the documented command and record the listing URL in `README.md`.

5. If only repository-backed marketplaces are supported, create the marketplace metadata in this repo and document:

```bash
/plugin marketplace add twister229/dev-kit
/plugin install dev-kit@dev-kit
```

6. If no publish path exists yet, document that users should install from a local clone until Anthropic exposes marketplace submission.

## Acceptance Criteria

- A clean project can install `dev-kit` through the documented path.
- The installed plugin exposes every skill listed in `skills/registry.json`.
- README has one install command for Claude Code users.
- `tests/test-plugin-manifest.sh` and `tests/test-sync-derived-files.sh` pass after any registry change.

## Notes

- Do not add network access to `scripts/install.sh` or `scripts/install.ps1`. The offline installer remains a separate supported path.
- Keep `.claude-plugin/plugin.json` generated from `skills/registry.json`; do not hand-edit the skill list.
