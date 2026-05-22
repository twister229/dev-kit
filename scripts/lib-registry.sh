#!/usr/bin/env bash
# Shared helpers for parsing skills/registry.json.
# Sourced by generator scripts.
# Requires jq.

require_jq() {
  command -v jq >/dev/null 2>&1 || {
    printf 'ERROR: jq is required for build-time generators.\n' >&2
    printf '  macOS:  brew install jq\n' >&2
    printf '  Linux:  apt-get install jq  (or your distro equivalent)\n' >&2
    return 1
  }
}

validate_registry() {
  local file="${1:-}"
  [ -n "$file" ] || { printf 'ERROR: validate_registry needs a file path\n' >&2; return 1; }
  require_jq || return 1
  [ -f "$file" ] || { printf 'ERROR: registry not found: %s\n' "$file" >&2; return 1; }
  jq -e 'has("name") and has("skills") and (.skills | type == "array")' "$file" >/dev/null 2>&1 || {
    printf 'ERROR: registry malformed: %s (must have top-level "name" and "skills" array)\n' "$file" >&2
    return 1
  }
}

get_registry_name() {
  local file="${1:-}"
  validate_registry "$file" || return 1
  jq -r '.name' "$file"
}

get_skill_names() {
  local file="${1:-}"
  validate_registry "$file" || return 1
  jq -r '.skills[].name' "$file"
}

get_skill_description() {
  local skill_name="$1"
  local file="$2"
  [ -n "$skill_name" ] || { printf 'ERROR: skill name required\n' >&2; return 1; }
  validate_registry "$file" || return 1
  jq -r --arg name "$skill_name" '.skills[] | select(.name == $name) | .description // ""' "$file"
}

get_skill_paths() {
  local file="${1:-}"
  validate_registry "$file" || return 1
  jq -r '.skills[].path' "$file"
}
