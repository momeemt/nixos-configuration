#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

orig_path="$(pwd)"
repo_root="$(git rev-parse --show-toplevel)"
WORKTREE_DIR="$(mktemp -d /tmp/growth-collect.XXXXXX)"

cleanup() {
  local status=$?
  cd "$orig_path" 2>/dev/null || true
  if git -C "$repo_root" worktree list --porcelain | grep -q "worktree $WORKTREE_DIR"; then
    git -C "$repo_root" worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
  fi
  rm -rf "$WORKTREE_DIR" 2>/dev/null || true
  if [ "$status" -ne 0 ]; then
    printf '\n[collect] ERROR: failed (exit code %s). Worktree has been cleaned up.\n' "$status" >&2
  else
    printf '\n[collect] SUCCESS: worktree removed cleanly.\n'
  fi
  exit $status
}

trap cleanup EXIT

git worktree add "$WORKTREE_DIR" HEAD
cd "$WORKTREE_DIR"
cp "$SCRIPT_DIR/.clocignore.template" "$WORKTREE_DIR/.clocignore-generated"

orig_ref=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || git rev-parse HEAD)

out_csv="cloc-history.csv"
tmp_json="$(mktemp)"

echo 'commit,date,language,code,comment,blank' >"$out_csv"

for rev in $(git rev-list --reverse --first-parent HEAD); do
  printf 'processing %s\n' "$rev" >&2
  git checkout -q "$rev"
  date=$(git show -s --format=%ci "$rev")
  cloc --vcs=git --exclude-list-file=.clocignore-generated --json --quiet . >"$tmp_json"
  jq -r --arg rev "$rev" --arg date "$date" '
    to_entries[]
    | select(.key != "header")
    | .value as $v
    | [$rev, $date, .key, $v.code, $v.comment, $v.blank]
    | @csv
  ' "$tmp_json" >>"$out_csv"
done

git checkout -q "$orig_ref"
rm "$tmp_json"
cp "$WORKTREE_DIR/$out_csv" "$SCRIPT_DIR/$out_csv"
cd "$orig_path"
printf 'cloc history collected in %s\n' "$out_csv" >&2
