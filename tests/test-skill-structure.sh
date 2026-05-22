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

  # Spec compliance — Agent Skills spec (anthropic template + superpowers/ai-devkit/karpathy consensus).
  # Required frontmatter: name, description.
  # name: kebab-case, ^[a-z][a-z0-9-]*$
  # description: non-empty, <= 1024 chars (warn-only above; assert non-empty here).
  # Folder name must match frontmatter name.
  fm_name="$(sed -n '/^name: /{s/^name: //; p; q;}' "$skill_file")"
  fm_desc="$(sed -n '/^description: /{s/^description: //; p; q;}' "$skill_file")"

  [ -n "$fm_name" ] || fail "$skill_name missing name frontmatter"
  [ -n "$fm_desc" ] || fail "$skill_name missing description frontmatter"

  [[ "$fm_name" =~ ^[a-z][a-z0-9-]*$ ]] || fail "$skill_name frontmatter name '$fm_name' does not match ^[a-z][a-z0-9-]*$"

  [ "$fm_name" = "$skill_name" ] || fail "$skill_name frontmatter name '$fm_name' != folder name"

  desc_len="${#fm_desc}"
  [ "$desc_len" -le 1024 ] || fail "$skill_name description is $desc_len chars (max 1024)"

  grep -q '^# ' "$skill_file" || fail "$skill_name missing title"
  grep -q "\"name\": \"$skill_name\"" "$REGISTRY" || fail "$skill_name missing from registry"
  grep -q "\"path\": \"skills/$skill_name\"" "$REGISTRY" || fail "$skill_name path missing from registry"
done

for required in start-work shape-work plan-work execute-work auto-dev-loop worktree-work orchestrate-agents debug-root-cause verify-work simplify-work capture-learning codebase-map project-knowledge onboard-project context-handoff finish-work review-work security-review writing-skills tdd-work review-feedback docs-review dependency-work release-notes seed-data-work; do
  [ -f "$SKILLS_DIR/$required/SKILL.md" ] || fail "missing required skill: $required"
done

grep -q '"offline": true' "$REGISTRY" || fail "registry must declare offline true"

printf 'PASS: skill structure\n'
