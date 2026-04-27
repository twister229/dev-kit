#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST_ROOT="$ROOT/references/upstream"

usage() {
  cat <<'USAGE'
Sync reference skills and commands from upstream repositories.

Usage:
  ./scripts/sync-upstream-references.sh

What it syncs:
  - obra/superpowers: skills/, commands/, agents/, hooks/, plugin metadata, install docs
  - codeaholicguy/ai-devkit: skills/, commands/, .agent/workflows/, tool command/prompt folders, registry metadata
  - forrestchang/andrej-karpathy-skills: CLAUDE.md, skill, examples, Cursor rule, plugin metadata

This is a reference snapshot only. Files under references/upstream/ are not installed by scripts/install.sh or scripts/install.ps1.
USAGE
}

info() {
  printf '%s\n' "$1"
}

die() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

case "${1:-}" in
  -h|--help)
    usage
    exit 0
    ;;
  "") ;;
  *) die "unknown argument: $1" ;;
esac

command -v git >/dev/null 2>&1 || die "git is required"
command -v rsync >/dev/null 2>&1 || die "rsync is required"

TMPDIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMPDIR"
}
trap cleanup EXIT

copy_if_exists() {
  local src="$1"
  local dest="$2"

  if [ -e "$src" ]; then
    mkdir -p "$(dirname "$dest")"
    rm -rf "$dest"
    rsync -a "$src" "$dest"
  fi
}

write_metadata() {
  local repo_dir="$1"
  local dest_dir="$2"
  local repo_url="$3"

  local commit
  commit="$(git -C "$repo_dir" rev-parse HEAD)"
  local synced_at
  synced_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

  cat > "$dest_dir/SOURCE.md" <<EOF
# Upstream Source

Repository: $repo_url
Commit: $commit
Synced at: $synced_at

This directory is a reference snapshot for future skill/workflow design. It is not part of the installable dev-kit skillset.
EOF
}

sync_superpowers() {
  local repo_url="https://github.com/obra/superpowers.git"
  local repo_dir="$TMPDIR/superpowers"
  local dest="$DEST_ROOT/superpowers"

  info "Cloning $repo_url"
  git clone --depth 1 "$repo_url" "$repo_dir" >/dev/null 2>&1

  rm -rf "$dest"
  mkdir -p "$dest"

  copy_if_exists "$repo_dir/skills/" "$dest/skills"
  copy_if_exists "$repo_dir/commands/" "$dest/commands"
  copy_if_exists "$repo_dir/agents/" "$dest/agents"
  copy_if_exists "$repo_dir/hooks/" "$dest/hooks"
  copy_if_exists "$repo_dir/.claude-plugin/" "$dest/.claude-plugin"
  copy_if_exists "$repo_dir/.codex-plugin/" "$dest/.codex-plugin"
  copy_if_exists "$repo_dir/.cursor-plugin/" "$dest/.cursor-plugin"
  copy_if_exists "$repo_dir/.opencode/" "$dest/.opencode"
  copy_if_exists "$repo_dir/.codex/" "$dest/.codex"
  copy_if_exists "$repo_dir/gemini-extension.json" "$dest/gemini-extension.json"
  copy_if_exists "$repo_dir/CLAUDE.md" "$dest/CLAUDE.md"
  copy_if_exists "$repo_dir/AGENTS.md" "$dest/AGENTS.md"
  copy_if_exists "$repo_dir/GEMINI.md" "$dest/GEMINI.md"
  copy_if_exists "$repo_dir/README.md" "$dest/README.md"
  copy_if_exists "$repo_dir/docs/README.codex.md" "$dest/docs/README.codex.md"
  copy_if_exists "$repo_dir/docs/README.opencode.md" "$dest/docs/README.opencode.md"

  write_metadata "$repo_dir" "$dest" "$repo_url"
  info "Synced superpowers -> $dest"
}

sync_ai_devkit() {
  local repo_url="https://github.com/codeaholicguy/ai-devkit.git"
  local repo_dir="$TMPDIR/ai-devkit"
  local dest="$DEST_ROOT/ai-devkit"

  info "Cloning $repo_url"
  git clone --depth 1 "$repo_url" "$repo_dir" >/dev/null 2>&1

  rm -rf "$dest"
  mkdir -p "$dest"

  copy_if_exists "$repo_dir/skills/" "$dest/skills"
  copy_if_exists "$repo_dir/commands/" "$dest/commands"
  copy_if_exists "$repo_dir/.agent/workflows/" "$dest/.agent/workflows"
  copy_if_exists "$repo_dir/.claude/commands/" "$dest/.claude/commands"
  copy_if_exists "$repo_dir/.codex/commands/" "$dest/.codex/commands"
  copy_if_exists "$repo_dir/.cursor/commands/" "$dest/.cursor/commands"
  copy_if_exists "$repo_dir/.cursor/AGENTS.md" "$dest/.cursor/AGENTS.md"
  copy_if_exists "$repo_dir/.github/prompts/" "$dest/.github/prompts"
  copy_if_exists "$repo_dir/.gemini/commands/" "$dest/.gemini/commands"
  copy_if_exists "$repo_dir/.claude-plugin/" "$dest/.claude-plugin"
  copy_if_exists "$repo_dir/.codex-plugin/" "$dest/.codex-plugin"
  copy_if_exists "$repo_dir/.cursor-plugin/" "$dest/.cursor-plugin"
  copy_if_exists "$repo_dir/.ai-devkit.json" "$dest/.ai-devkit.json"
  copy_if_exists "$repo_dir/README.md" "$dest/README.md"

  write_metadata "$repo_dir" "$dest" "$repo_url"
  info "Synced ai-devkit -> $dest"
}

sync_andrej_karpathy_skills() {
  local repo_url="https://github.com/forrestchang/andrej-karpathy-skills.git"
  local repo_dir="$TMPDIR/andrej-karpathy-skills"
  local dest="$DEST_ROOT/andrej-karpathy-skills"
  local notes_backup="$TMPDIR/andrej-karpathy-skills-DEV-KIT-NOTES.md"

  info "Cloning $repo_url"
  git clone --depth 1 "$repo_url" "$repo_dir" >/dev/null 2>&1

  if [ -f "$dest/DEV-KIT-NOTES.md" ]; then
    cp "$dest/DEV-KIT-NOTES.md" "$notes_backup"
  fi

  rm -rf "$dest"
  mkdir -p "$dest"

  copy_if_exists "$repo_dir/skills/" "$dest/skills"
  copy_if_exists "$repo_dir/.claude-plugin/" "$dest/.claude-plugin"
  copy_if_exists "$repo_dir/.cursor/" "$dest/.cursor"
  copy_if_exists "$repo_dir/CLAUDE.md" "$dest/CLAUDE.md"
  copy_if_exists "$repo_dir/CURSOR.md" "$dest/CURSOR.md"
  copy_if_exists "$repo_dir/EXAMPLES.md" "$dest/EXAMPLES.md"
  copy_if_exists "$repo_dir/README.md" "$dest/README.md"
  copy_if_exists "$repo_dir/README.zh.md" "$dest/README.zh.md"

  if [ -f "$notes_backup" ]; then
    cp "$notes_backup" "$dest/DEV-KIT-NOTES.md"
  fi

  write_metadata "$repo_dir" "$dest" "$repo_url"
  info "Synced andrej-karpathy-skills -> $dest"
}

mkdir -p "$DEST_ROOT"
sync_superpowers
sync_ai_devkit
sync_andrej_karpathy_skills

info "Done. Reference snapshots are in $DEST_ROOT"
