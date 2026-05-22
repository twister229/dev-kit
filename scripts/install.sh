#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Install dev-kit skills at project level.

Usage:
  ./scripts/install.sh [target-project] [options]

Options:
  --all              Install Claude, OpenCode, and GitHub Copilot targets (default)
  --claude           Install Claude skills to .claude/skills and CLAUDE.md
  --opencode         Install OpenCode skills to .opencode/skills and AGENTS.md
  --copilot          Install GitHub Copilot prompts to .github/prompts and instructions
  --skills-dir DIR   Advanced: install all selected skill folders to one custom project-relative directory
  --force            Replace existing installed skill files
  --skip-onboard     Skip the onboard-project post-install prompt
  -h, --help         Show help

Examples:
  ./scripts/install.sh /path/to/project
  ./scripts/install.sh . --claude --opencode
  ./scripts/install.sh ~/app --force
  ./scripts/install.sh ~/app --skills-dir .custom/skills --force

Offline: this script only copies local files. It does not use npm, npx, curl, or network access.
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
SOURCE_REGISTRY_FILE="$SOURCE_SKILLS_DIR/registry.json"

[ -d "$SOURCE_SKILLS_DIR" ] || die "skills directory not found: $SOURCE_SKILLS_DIR"

TARGET_PROJECT="."
INSTALL_CLAUDE=0
INSTALL_OPENCODE=0
INSTALL_COPILOT=0
EXPLICIT_TARGETS=0
SKILLS_DIR_REL=""
FORCE=0
SKIP_ONBOARD=0

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
    --skip-onboard)
      SKIP_ONBOARD=1
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

MARKER_BEGIN="<!-- agentic-dev-system:begin -->"
MARKER_END="<!-- agentic-dev-system:end -->"

ROUTING_BLOCK="${MARKER_BEGIN}
## dev-kit Skills

Provider-native files are installed for the selected tools:

- Claude: \`.claude/skills\`
- OpenCode: \`.opencode/skills\`
- GitHub Copilot: \`.github/prompts\`

When the user's request matches one of these workflows, use the matching skill before answering directly:

- New feature, vague product request, multi-step build -> \`start-work\`
- Vague product or technical direction needs shaping -> \`shape-work\`
- Requirements or design already exist -> \`plan-work\`
- Written implementation plan ready -> \`execute-work\`
- Autonomous end-to-end lifecycle until verified complete or blocked -> \`auto-dev-loop\`
- Isolated git worktree or branch context needed -> \`worktree-work\`
- Multiple agents or parallel workstreams need coordination -> \`orchestrate-agents\`
- New behavior, bug fix, or behavior refactor -> \`tdd-work\`
- Bug, failing test, regression, production issue -> \`debug-root-cause\`
- Any done/fixed/passing/ready claim -> \`verify-work\`
- Refactor, simplify, reduce complexity -> \`simplify-work\`
- Understand or map an unfamiliar repo/subsystem before changing it -> \`codebase-map\`
- Initialize, update, query, or maintain repo-local knowledge for future agents -> \`project-knowledge\`
- Document or remember a specific verified reusable lesson -> \`capture-learning\`
- Save or restore one-off working context -> \`context-handoff\`
- Received code review feedback -> \`review-feedback\`
- Review README, install docs, guides, or skill docs -> \`docs-review\`
- Add, remove, update, audit, or diagnose dependencies -> \`dependency-work\`
- Create or verify local dev/test seed data, fixtures, or sample SQL rows -> \`seed-data-work\`
- Code review, diff review, implementation check -> \`review-work\`
- Branch ready for final review, commit, or PR -> \`finish-work\`
- Changelog, release notes, migration notes, or upgrade guidance -> \`release-notes\`
- Create or revise skills -> \`writing-skills\`
- Tailor dev-kit to this project after install -> \`onboard-project\`

Golden path: \`start-work -> codebase-map/project-knowledge when context is missing -> shape-work when needed -> plan-work -> execute-work -> review-work -> verify-work -> capture-learning/project-knowledge -> finish-work\`.

Fast path: for tiny low-risk tasks, make the change, run \`verify-work\`, and report evidence. Do not create lifecycle docs for typo-level work.

Core rules:

- No fixes without root cause for bugs.
- No completion claims without fresh command output.
- No production code for behavior changes without a failing test first unless explicitly approved.
- Spec compliance review comes before code quality review.
- Store only reusable, verified knowledge in local Markdown. Never store secrets, transcripts, or one-off progress.
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
    block_file="$(mktemp)"
    printf '%s\n' "$ROUTING_BLOCK" > "$block_file"
    awk -v begin="$MARKER_BEGIN" -v end="$MARKER_END" -v block_file="$block_file" '
      $0 == begin { while ((getline line < block_file) > 0) print line; close(block_file); inside=1; next }
      $0 == end { inside=0; next }
      !inside { print }
    ' "$file" > "$file.tmp"
    rm -f "$block_file"
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
  local dest_skills_dir="$1"
  local registry_dest_dir
  registry_dest_dir="$(dirname "$dest_skills_dir")"

  mkdir -p "$dest_skills_dir"

  for skill_dir in "$SOURCE_SKILLS_DIR"/*; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    dest="$dest_skills_dir/$skill_name"

    if [ -e "$dest" ] && [ "$FORCE" -ne 1 ]; then
      die "skill already exists: $dest. Re-run with --force to replace installed skills."
    fi

    rm -rf "$dest"
    cp -R "$skill_dir" "$dest"
  done

  if [ -f "$SOURCE_REGISTRY_FILE" ]; then
    registry_dest="$registry_dest_dir/registry.json"
    cp "$SOURCE_REGISTRY_FILE" "$registry_dest"
    info "Installed registry: $registry_dest"
  fi

  info "Installed skills: $dest_skills_dir"
}

install_custom_skills() {
  DEST_SKILLS_DIR="$TARGET_PROJECT/$SKILLS_DIR_REL"
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

  if [ -f "$SOURCE_REGISTRY_FILE" ]; then
    registry_dest="$(dirname "$DEST_SKILLS_DIR")/registry.json"
    cp "$SOURCE_REGISTRY_FILE" "$registry_dest"
    info "Installed registry: $registry_dest"
  fi

  info "Installed skills: $DEST_SKILLS_DIR"
}

install_copilot_prompts() {
  local prompts_dir="$TARGET_PROJECT/.github/prompts"
  mkdir -p "$prompts_dir"

  for skill_dir in "$SOURCE_SKILLS_DIR"/*; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    prompt_file="$prompts_dir/$skill_name.prompt.md"

    if [ -e "$prompt_file" ] && [ "$FORCE" -ne 1 ]; then
      die "prompt already exists: $prompt_file. Re-run with --force to replace installed prompts."
    fi

    {
      printf '# %s\n\n' "$skill_name"
      printf 'Use this workflow when the user request matches this prompt. Source skill: `%s`.\n\n' "$skill_name"
      cat "$skill_dir/SKILL.md"
    } > "$prompt_file"
  done

  if [ -f "$SOURCE_REGISTRY_FILE" ]; then
    cp "$SOURCE_REGISTRY_FILE" "$TARGET_PROJECT/.github/dev-kit-registry.json"
    info "Installed registry: $TARGET_PROJECT/.github/dev-kit-registry.json"
  fi

  info "Installed Copilot prompts: $prompts_dir"
}

install_claude() {
  if [ -z "$SKILLS_DIR_REL" ]; then
    install_skills "$TARGET_PROJECT/.claude/skills"
  fi
  append_or_replace_block "$TARGET_PROJECT/CLAUDE.md" "Claude instructions"
}

install_opencode() {
  if [ -z "$SKILLS_DIR_REL" ]; then
    install_skills "$TARGET_PROJECT/.opencode/skills"
  fi
  append_or_replace_block "$TARGET_PROJECT/AGENTS.md" "OpenCode instructions"
}

install_copilot() {
  if [ -z "$SKILLS_DIR_REL" ]; then
    install_copilot_prompts
  fi
  append_or_replace_block "$TARGET_PROJECT/.github/copilot-instructions.md" "GitHub Copilot instructions"
}

if [ -n "$SKILLS_DIR_REL" ]; then
  install_custom_skills
fi

if [ "$INSTALL_CLAUDE" -eq 1 ]; then
  install_claude
fi

if [ "$INSTALL_OPENCODE" -eq 1 ]; then
  install_opencode
fi

if [ "$INSTALL_COPILOT" -eq 1 ]; then
  install_copilot
fi

info "Done. Installed dev-kit at project level."

if [ "$SKIP_ONBOARD" -eq 0 ]; then
  info ""
  info "Next step: run the 'onboard-project' skill in your AI agent to tailor this"
  info "setup to your project's stack, test commands, and conventions."
  info ""
  info "  onboard-project"
  info ""
  info "This generates a project-specific CLAUDE.md, per-skill configs, and a routing"
  info "map. Skip with --skip-onboard if you prefer to configure manually."
  info ""
  info "To update later when dev-kit has new commits: re-run with --force, then"
  info "run 'onboard-project' again to pick up new skills in the routing map."
fi
