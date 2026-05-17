#!/usr/bin/env bash
# Generate .claude-plugin/plugin.json from skills/registry.json.
# Plugin-level metadata (version, repository, keywords) is hardcoded here;
# skill list + name come from registry.json (single source of truth for skills).
#
# Run via scripts/sync-derived-files.sh (preferred) or directly to regenerate.
# Requires jq.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
. "$ROOT/scripts/lib-registry.sh"

REGISTRY="$ROOT/skills/registry.json"
OUTPUT="${1:-$ROOT/.claude-plugin/plugin.json}"

validate_registry "$REGISTRY"

PLUGIN_VERSION="0.1.0"
REPOSITORY="https://github.com/twister229/dev-kit"
HOMEPAGE="$REPOSITORY"
DESCRIPTION="Offline-first agentic dev kit: lifecycle skills, multi-tool support (Claude, OpenCode, Copilot), per-project tailoring via onboard-project, and a durable repo-local knowledge layer."

mkdir -p "$(dirname "$OUTPUT")"

jq -n \
  --slurpfile reg "$REGISTRY" \
  --arg version "$PLUGIN_VERSION" \
  --arg desc "$DESCRIPTION" \
  --arg homepage "$HOMEPAGE" \
  --arg repository "$REPOSITORY" \
  '{
    name: $reg[0].name,
    version: $version,
    description: $desc,
    homepage: $homepage,
    repository: $repository,
    keywords: ["agentic", "skills", "claude-code", "opencode", "copilot", "lifecycle", "offline", "tdd", "debugging", "code-review", "knowledge-base"],
    skills: ($reg[0].skills | map("./" + .path))
  }' > "$OUTPUT"

printf 'Wrote %s (%d skills)\n' "$OUTPUT" "$(jq '.skills | length' "$OUTPUT")"
