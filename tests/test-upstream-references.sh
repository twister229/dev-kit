#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REF="$ROOT/references/upstream"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_file() {
  [ -f "$1" ] || fail "expected file: $1"
}

assert_dir() {
  [ -d "$1" ] || fail "expected directory: $1"
}

assert_dir "$REF/superpowers/skills"
assert_file "$REF/superpowers/SOURCE.md"
assert_file "$REF/superpowers/skills/writing-skills/SKILL.md"

assert_dir "$REF/ai-devkit/skills"
assert_dir "$REF/ai-devkit/commands"
assert_file "$REF/ai-devkit/SOURCE.md"
assert_file "$REF/ai-devkit/skills/dev-lifecycle/SKILL.md"

assert_dir "$REF/andrej-karpathy-skills/skills"
assert_file "$REF/andrej-karpathy-skills/SOURCE.md"
assert_file "$REF/andrej-karpathy-skills/DEV-KIT-NOTES.md"
assert_file "$REF/andrej-karpathy-skills/skills/karpathy-guidelines/SKILL.md"

printf 'PASS: upstream references\n'
