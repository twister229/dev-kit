#!/usr/bin/env bash
# Regenerate every file derived from skills/registry.json.
# Run this whenever registry.json changes, then commit the diff.
# CI guard: tests/test-sync-derived-files.sh re-runs this and fails on git drift.
#
# v1 consumers (hard-coded list, per /plan-eng-review D9):
#   - .claude-plugin/plugin.json   (PR 1, this script)
#
# Planned PR 2 consumers (will be appended here, not via a YAML manifest):
#   - AGENTS.md routing block
#   - README.md skill table
#   - skills/onboard-project/SKILL.md golden-path block
#
# Requires jq.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"$ROOT/scripts/generate-plugin-manifest.sh"

printf 'sync-derived-files: all consumers up to date.\n'
