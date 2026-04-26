#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Install Agentic Dev System skills at project level.

Usage:
  ./scripts/install.sh [target-project] [options]

Options:
  --all              Install routing for Claude, OpenCode, and GitHub Copilot (default)
  --claude           Install Claude project instructions
  --opencode         Install OpenCode project instructions
  --copilot          Install GitHub Copilot project instructions
  --skills-dir DIR   Project-relative skill install directory (default: .agentic-dev-system/skills)
  --force            Replace existing installed skill files
  -h, --help         Show help

Examples:
  ./scripts/install.sh /path/to/project
  ./scripts/install.sh . --claude --opencode
  ./scripts/install.sh ~/app --skills-dir .claude/skills --force
USAGE
}

die() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

info() {
  printf '%s\n' "$1"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_SKILLS_DIR="$REPO_ROOT/skills"

[ -d "$SOURCE_SKILLS_DIR" ] || die "skills directory not found: $SOURCE_SKILLS_DIR"

TARGET_PROJECT="."
INSTALL_CLAUDE=0
INSTALL_OPENCODE=0
INSTALL_COPILOT=0
EXPLICIT_TARGETS=0
SKILLS_DIR_REL=".agentic-dev-system/skills"
FORCE=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --all)
      INSTALL_CLAUDE=1
      INSTALL_OPENCODE=1
      INSTALL_COPILOT=1
      EXPLICIT_TARGETS=1
      shift
      ;;
    --claude)
      INSTALL_CLAUDE=1
      EXPLICIT_TARGETS=1
      shift
      ;;
    --opencode)
      INSTALL_OPENCODE=1
      EXPLICIT_TARGETS=1
      shift
      ;;
    --copilot)
      INSTALL_COPILOT=1
      EXPLICIT_TARGETS=1
      shift
      ;;
    --skills-dir)
      [ "$#" -ge 2 ] || die "--skills-dir requires a value"
      SKILLS_DIR_REL="$2"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --*)
      die "unknown option: $1"
      ;;
    *)
      TARGET_PROJECT="$1"
      shift
      ;;
  esac
done

if [ "$EXPLICIT_TARGETS" -eq 0 ]; then
  INSTALL_CLAUDE=1
  INSTALL_OPENCODE=1
  INSTALL_COPILOT=1
fi

TARGET_PROJECT="$(cd "$TARGET_PROJECT" && pwd)"
[ -d "$TARGET_PROJECT" ] || die "target project does not exist: $TARGET_PROJECT"

case "$SKILLS_DIR_REL" in
  /*) die "--skills-dir must be project-relative, got: $SKILLS_DIR_REL" ;;
  *..*) die "--skills-dir must not contain '..', got: $SKILLS_DIR_REL" ;;
esac

DEST_SKILLS_DIR="$TARGET_PROJECT/$SKILLS_DIR_REL"
MARKER_BEGIN="<!-- agentic-dev-system:begin -->"
MARKER_END="<!-- agentic-dev-system:end -->"

ROUTING_BLOCK="${MARKER_BEGIN}
## Agentic Dev System Skills

Project-level skills are installed in \`${SKILLS_DIR_REL}\`.

When the user's request matches one of these workflows, use the matching skill before answering directly:

- New feature, vague product request, multi-step build -> \`start-work\`
- Requirements or design already exist -> \`plan-work\`
- Written implementation plan ready -> \`execute-work\`
- Bug, failing test, regression, production issue -> \`debug-root-cause\`
- Any done/fixed/passing/ready claim -> \`verify-work\`
- Refactor, simplify, reduce complexity -> \`simplify-work\`
- Understand, document, or remember code/project knowledge -> \`capture-learning\`
- Branch ready for final review, commit, or PR -> \`finish-work\`
- Create or revise skills -> \`writing-skills\`

Golden path: \`start-work -> plan-work -> execute-work -> verify-work -> capture-learning -> finish-work\`.

Fast path: for tiny low-risk tasks, make the change, run \`verify-work\`, and report evidence. Do not create lifecycle docs for typo-level work.

Core rules:

- No fixes without root cause for bugs.
- No completion claims without fresh command output.
- Spec compliance review comes before code quality review.
- Store only reusable, verified knowledge. Never store secrets, transcripts, or one-off progress.
- Some duplication beats the wrong abstraction.
${MARKER_END}"

ensure_parent_dir() {
  mkdir -p "$(dirname "$1")"
}

append_or_replace_block() {
  local file="$1"
  local title="$2"
  ensure_parent_dir "$file"

  if [ -f "$file" ] && grep -q "$MARKER_BEGIN" "$file"; then
    awk -v begin="$MARKER_BEGIN" -v end="$MARKER_END" -v block="$ROUTING_BLOCK" '
      $0 == begin { print block; inside=1; next }
      $0 == end { inside=0; next }
      !inside { print }
    ' "$file" > "$file.tmp"
    mv "$file.tmp" "$file"
    info "Updated $title: $file"
  else
    {
      if [ -s "$file" ]; then
        printf '\n\n'
      fi
      printf '%s\n' "$ROUTING_BLOCK"
    } >> "$file"
    info "Installed $title: $file"
  fi
}

install_skills() {
  mkdir -p "$DEST_SKILLS_DIR"

  for skill_dir in "$SOURCE_SKILLS_DIR"/*; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    dest="$DEST_SKILLS_DIR/$skill_name"

    if [ -e "$dest" ] && [ "$FORCE" -ne 1 ]; then
      die "skill already exists: $dest. Re-run with --force to replace installed skills."
    fi

    rm -rf "$dest"
    cp -R "$skill_dir" "$dest"
  done

  info "Installed skills: $DEST_SKILLS_DIR"
}

install_claude() {
  append_or_replace_block "$TARGET_PROJECT/CLAUDE.md" "Claude instructions"
}

install_opencode() {
  append_or_replace_block "$TARGET_PROJECT/AGENTS.md" "OpenCode instructions"
}

install_copilot() {
  append_or_replace_block "$TARGET_PROJECT/.github/copilot-instructions.md" "GitHub Copilot instructions"
}

install_skills

if [ "$INSTALL_CLAUDE" -eq 1 ]; then
  install_claude
fi

if [ "$INSTALL_OPENCODE" -eq 1 ]; then
  install_opencode
fi

if [ "$INSTALL_COPILOT" -eq 1 ]; then
  install_copilot
fi

info "Done. Installed Agentic Dev System at project level."
