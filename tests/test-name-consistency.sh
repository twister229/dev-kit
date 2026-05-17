#!/usr/bin/env bash
# Enforce the brand-vs-marker distinction from /plan-ceo-review D10:
#   User-facing brand = "dev-kit".
#   Private marker tokens stay as "agentic-dev-system" inside install scripts
#   and the test/skill files that reference those markers.
#
# This test fails if "agentic-dev-system" or "Agentic Dev System" appears outside
# the explicit allowlist below.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

# Files allowed to contain "agentic-dev-system" / "Agentic Dev System".
# Markers live in install scripts; tests and skills reference them by name.
ALLOWLIST=(
  "scripts/install.sh"
  "scripts/install.ps1"
  "tests/test-install.sh"
  "tests/test-install.ps1"
  "tests/test-name-consistency.sh"
  "skills/onboard-project/SKILL.md"
  "docs/ai/evals/skill-routing-evals.md"
  "AGENTS.md"
  "CLAUDE.md"
  ".github/copilot-instructions.md"
)

is_allowlisted() {
  local path="$1"
  local entry
  for entry in "${ALLOWLIST[@]}"; do
    [ "$path" = "$entry" ] && return 0
  done
  return 1
}

# Scan repo for the brand-string hits, excluding upstream references and node_modules.
HITS=$(
  grep -rln 'agentic-dev-system\|Agentic Dev System' \
    --include='*.md' --include='*.sh' --include='*.ps1' --include='*.json' \
    "$ROOT" 2>/dev/null \
  | sed "s|^$ROOT/||" \
  | grep -v '^references/upstream/' \
  | grep -v '^node_modules/' \
  | grep -v '^\.opencode/' \
  | grep -v '^\.claude/' \
  | grep -v '^\.github/prompts/' \
  | sort -u
)

FAILED=0
while IFS= read -r relpath; do
  [ -z "$relpath" ] && continue
  if ! is_allowlisted "$relpath"; then
    printf 'NAME-CONSISTENCY VIOLATION: %s\n' "$relpath" >&2
    FAILED=1
  fi
done <<< "$HITS"

if [ "$FAILED" = "1" ]; then
  printf '\nBrand name is "dev-kit". Marker tokens stay "agentic-dev-system" in:\n' >&2
  printf '  %s\n' "${ALLOWLIST[@]}" >&2
  exit 1
fi

printf 'PASS: name-consistency (%d allowlisted files have references; rest are clean)\n' "${#ALLOWLIST[@]}"
