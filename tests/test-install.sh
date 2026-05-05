#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMPDIR"
}
trap cleanup EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_file() {
  [ -f "$1" ] || fail "expected file: $1"
}

assert_not_file() {
  [ ! -f "$1" ] || fail "unexpected file: $1"
}

assert_marker_once() {
  file="$1"
  count="$(grep -c '<!-- agentic-dev-system:begin -->' "$file" || true)"
  [ "$count" = "1" ] || fail "expected one routing marker in $file, got $count"
}

PROJECT="$TMPDIR/project"
mkdir -p "$PROJECT"

"$ROOT/scripts/install.sh" "$PROJECT"

assert_file "$PROJECT/CLAUDE.md"
assert_file "$PROJECT/AGENTS.md"
assert_file "$PROJECT/.github/copilot-instructions.md"
assert_file "$PROJECT/.claude/skills/start-work/SKILL.md"
assert_file "$PROJECT/.claude/skills/tdd-work/SKILL.md"
assert_file "$PROJECT/.claude/skills/codebase-map/SKILL.md"
assert_file "$PROJECT/.claude/skills/project-knowledge/SKILL.md"
assert_file "$PROJECT/.claude/registry.json"
assert_file "$PROJECT/.opencode/skills/review-feedback/SKILL.md"
assert_file "$PROJECT/.opencode/skills/review-work/SKILL.md"
assert_file "$PROJECT/.opencode/skills/docs-review/SKILL.md"
assert_file "$PROJECT/.opencode/registry.json"
assert_file "$PROJECT/.github/prompts/start-work.prompt.md"
assert_file "$PROJECT/.github/prompts/docs-review.prompt.md"
assert_file "$PROJECT/.github/prompts/review-work.prompt.md"
assert_file "$PROJECT/.github/prompts/project-knowledge.prompt.md"
assert_file "$PROJECT/.github/dev-kit-registry.json"
assert_marker_once "$PROJECT/CLAUDE.md"
assert_marker_once "$PROJECT/AGENTS.md"
assert_marker_once "$PROJECT/.github/copilot-instructions.md"

"$ROOT/scripts/install.sh" "$PROJECT" --force
assert_marker_once "$PROJECT/CLAUDE.md"
assert_marker_once "$PROJECT/AGENTS.md"
assert_marker_once "$PROJECT/.github/copilot-instructions.md"

SELECTIVE="$TMPDIR/selective"
mkdir -p "$SELECTIVE"
"$ROOT/scripts/install.sh" "$SELECTIVE" --claude
assert_file "$SELECTIVE/CLAUDE.md"
assert_not_file "$SELECTIVE/AGENTS.md"
assert_not_file "$SELECTIVE/.github/copilot-instructions.md"
assert_file "$SELECTIVE/.claude/skills/start-work/SKILL.md"
assert_file "$SELECTIVE/.claude/registry.json"
assert_not_file "$SELECTIVE/.opencode/registry.json"
assert_not_file "$SELECTIVE/.github/dev-kit-registry.json"

CUSTOM="$TMPDIR/custom"
mkdir -p "$CUSTOM"
"$ROOT/scripts/install.sh" "$CUSTOM" --claude --skills-dir .custom/skills
assert_file "$CUSTOM/CLAUDE.md"
assert_file "$CUSTOM/.custom/skills/start-work/SKILL.md"
assert_file "$CUSTOM/.custom/skills/project-knowledge/SKILL.md"
assert_file "$CUSTOM/.custom/registry.json"
assert_not_file "$CUSTOM/.claude/skills/start-work/SKILL.md"

if "$ROOT/scripts/install.sh" "$TMPDIR/bad-abs" --skills-dir /tmp/dev-kit-skills >/dev/null 2>&1; then
  fail "absolute --skills-dir should fail"
fi

mkdir -p "$TMPDIR/bad-rel"
if "$ROOT/scripts/install.sh" "$TMPDIR/bad-rel" --skills-dir ../bad >/dev/null 2>&1; then
  fail "parent traversal --skills-dir should fail"
fi

printf 'PASS: install.sh offline installer\n'
