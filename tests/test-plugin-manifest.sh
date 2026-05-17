#!/usr/bin/env bash
# Validate .claude-plugin/plugin.json shape + failure modes of the generator.
# Asserts: manifest exists, required fields present, name + skill count match registry.
# Also exercises generator failure modes against a sandboxed registry.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$ROOT/.claude-plugin/plugin.json"
REGISTRY="$ROOT/skills/registry.json"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

command -v jq >/dev/null || fail "jq required for this test"

[ -f "$MANIFEST" ] || fail "manifest missing: $MANIFEST (run scripts/sync-derived-files.sh)"

# Required fields
for field in name version description homepage repository keywords skills; do
  jq -e "has(\"$field\")" "$MANIFEST" >/dev/null || fail "manifest missing field: $field"
done

# Name matches registry top-level name (i.e., 'dev-kit' post-C3)
MANIFEST_NAME="$(jq -r '.name' "$MANIFEST")"
REGISTRY_NAME="$(jq -r '.name' "$REGISTRY")"
[ "$MANIFEST_NAME" = "$REGISTRY_NAME" ] || fail "manifest name '$MANIFEST_NAME' != registry name '$REGISTRY_NAME'"
[ "$MANIFEST_NAME" = "dev-kit" ] || fail "manifest name '$MANIFEST_NAME' != 'dev-kit'"

# Skill count matches registry
REGISTRY_SKILLS="$(jq '.skills | length' "$REGISTRY")"
MANIFEST_SKILLS="$(jq '.skills | length' "$MANIFEST")"
[ "$REGISTRY_SKILLS" = "$MANIFEST_SKILLS" ] || fail "skill count mismatch: registry=$REGISTRY_SKILLS manifest=$MANIFEST_SKILLS"

# Every manifest skill path points to a real directory
while IFS= read -r path; do
  rel="${path#./}"
  [ -d "$ROOT/$rel" ] || fail "manifest references missing skill path: $path"
  [ -f "$ROOT/$rel/SKILL.md" ] || fail "manifest path $path missing SKILL.md"
done < <(jq -r '.skills[]' "$MANIFEST")

# --- failure-mode tests against sandboxed registry ---

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Generator should fail on malformed registry
echo 'not json' > "$TMP/registry.json"
if REGISTRY_OVERRIDE="$TMP/registry.json" \
   bash -c '
     ROOT="$1"; shift
     . "$ROOT/scripts/lib-registry.sh"
     validate_registry "$1"
   ' _ "$ROOT" "$TMP/registry.json" 2>/dev/null; then
  fail "validate_registry should reject non-JSON registry"
fi

# Generator should fail on missing required keys
echo '{"name":"test"}' > "$TMP/no-skills.json"
if bash -c '
  . "$1/scripts/lib-registry.sh"
  validate_registry "$2"
' _ "$ROOT" "$TMP/no-skills.json" 2>/dev/null; then
  fail "validate_registry should reject registry without skills"
fi

printf 'PASS: plugin-manifest (%d skills, all paths verified, failure modes covered)\n' "$MANIFEST_SKILLS"
