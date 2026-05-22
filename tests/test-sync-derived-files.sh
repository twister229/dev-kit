#!/usr/bin/env bash
# CI guard: re-run sync-derived-files.sh and assert no git drift.
# Failure means a derived file in the tree disagrees with what the generators produce.
# Fix: run scripts/sync-derived-files.sh and commit the diff.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

"$ROOT/scripts/sync-derived-files.sh" >/dev/null

# List of files that sync-derived-files may regenerate.
# Keep this in sync with scripts/sync-derived-files.sh consumers.
DERIVED_FILES=(
  ".claude-plugin/plugin.json"
)

for f in "${DERIVED_FILES[@]}"; do
  [ -f "$ROOT/$f" ] || fail "expected derived file missing: $f"
  if ! git diff --exit-code -- "$f" >/dev/null 2>&1; then
    printf 'DRIFT: %s\n' "$f" >&2
    git diff -- "$f" >&2 || true
    fail "derived file out of sync: $f. Run scripts/sync-derived-files.sh and commit."
  fi
done

printf 'PASS: sync-derived-files (%d consumer(s) checked)\n' "${#DERIVED_FILES[@]}"
