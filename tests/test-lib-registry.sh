#!/usr/bin/env bash
# Unit tests for scripts/lib-registry.sh.
# Covers happy paths and failure modes (missing file, malformed json, missing keys).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
. "$ROOT/scripts/lib-registry.sh"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

REGISTRY="$ROOT/skills/registry.json"

# --- happy paths ---

validate_registry "$REGISTRY" || fail "validate_registry failed on real registry"

NAME="$(get_registry_name "$REGISTRY")"
[ "$NAME" = "dev-kit" ] || fail "get_registry_name returned '$NAME', expected 'dev-kit'"

COUNT="$(get_skill_names "$REGISTRY" | wc -l | tr -d ' ')"
[ "$COUNT" -ge 20 ] || fail "get_skill_names returned $COUNT names, expected >=20"

DESC="$(get_skill_description start-work "$REGISTRY")"
[ -n "$DESC" ] || fail "get_skill_description start-work returned empty"

PATHS_COUNT="$(get_skill_paths "$REGISTRY" | wc -l | tr -d ' ')"
[ "$PATHS_COUNT" = "$COUNT" ] || fail "get_skill_paths returned $PATHS_COUNT, expected $COUNT"

UNKNOWN="$(get_skill_description nonexistent-skill "$REGISTRY")"
[ -z "$UNKNOWN" ] || fail "get_skill_description for unknown skill returned '$UNKNOWN', expected empty"

# --- failure modes ---

# Missing file
if validate_registry "$TMP/does-not-exist.json" 2>/dev/null; then
  fail "validate_registry should reject missing file"
fi

# Non-JSON content
echo 'not json' > "$TMP/bad-not-json.json"
if validate_registry "$TMP/bad-not-json.json" 2>/dev/null; then
  fail "validate_registry should reject non-JSON content"
fi

# JSON missing 'skills' key
echo '{"name":"test"}' > "$TMP/bad-no-skills.json"
if validate_registry "$TMP/bad-no-skills.json" 2>/dev/null; then
  fail "validate_registry should reject registry missing 'skills' array"
fi

# JSON missing 'name' key
echo '{"skills":[]}' > "$TMP/bad-no-name.json"
if validate_registry "$TMP/bad-no-name.json" 2>/dev/null; then
  fail "validate_registry should reject registry missing 'name'"
fi

# JSON where 'skills' is not an array
echo '{"name":"test","skills":"not-an-array"}' > "$TMP/bad-skills-type.json"
if validate_registry "$TMP/bad-skills-type.json" 2>/dev/null; then
  fail "validate_registry should reject non-array 'skills'"
fi

# Missing file path argument
if validate_registry 2>/dev/null; then
  fail "validate_registry should reject missing file argument"
fi

# get_skill_description with no skill name
if get_skill_description "" "$REGISTRY" 2>/dev/null; then
  fail "get_skill_description should reject empty skill name"
fi

# Empty-skills registry: empty 'skills' array is structurally valid but yields zero names
echo '{"name":"empty","skills":[]}' > "$TMP/empty-skills.json"
validate_registry "$TMP/empty-skills.json" || fail "empty skills array should pass validation"
EMPTY_COUNT="$(get_skill_names "$TMP/empty-skills.json" | wc -l | tr -d ' ')"
[ "$EMPTY_COUNT" -eq 0 ] || fail "empty registry should yield 0 names, got $EMPTY_COUNT"

printf 'PASS: lib-registry (%d names, %d failure modes covered)\n' "$COUNT" 8
