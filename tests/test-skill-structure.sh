#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$ROOT/skills"
REGISTRY="$SKILLS_DIR/registry.json"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

[ -f "$REGISTRY" ] || fail "missing skills/registry.json"

for skill_dir in "$SKILLS_DIR"/*; do
  [ -d "$skill_dir" ] || continue
  skill_name="$(basename "$skill_dir")"
  skill_file="$skill_dir/SKILL.md"

  [ -f "$skill_file" ] || fail "$skill_name missing SKILL.md"
  first_line="$(sed -n '1p' "$skill_file")"
  [ "$first_line" = "---" ] || fail "$skill_name missing frontmatter start"
  grep -q '^name: ' "$skill_file" || fail "$skill_name missing name frontmatter"
  grep -q '^description: ' "$skill_file" || fail "$skill_name missing description frontmatter"
  grep -q '^# ' "$skill_file" || fail "$skill_name missing title"
  grep -q "\"name\": \"$skill_name\"" "$REGISTRY" || fail "$skill_name missing from registry"
  grep -q "\"path\": \"skills/$skill_name\"" "$REGISTRY" || fail "$skill_name path missing from registry"
done

for required in start-work plan-work execute-work debug-root-cause verify-work simplify-work capture-learning finish-work writing-skills tdd-work review-feedback docs-review; do
  [ -f "$SKILLS_DIR/$required/SKILL.md" ] || fail "missing required skill: $required"
done

grep -q '"offline": true' "$REGISTRY" || fail "registry must declare offline true"

printf 'PASS: skill structure\n'
