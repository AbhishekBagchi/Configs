#!/usr/bin/env bash
# Update this dotfiles repo to latest:
#   - all git submodules (to the latest commit on their tracked branch)
#   - vendored plugin dirs re-copied from upstream monorepos (no standalone repo exists)
# Operates on the repo this script lives in; does NOT touch $HOME (run sync.sh for that).
# Review results with `git status` afterwards.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

echo "==> Syncing + updating all submodules to latest..."
git submodule sync --recursive
git submodule update --init --recursive
git submodule update --remote --recursive

# Subdirectories of upstream monorepos that have no standalone repo, so they are
# copied in rather than submoduled. Grouped by URL so each upstream clones once.
# Format: <dest under repo>|<url>|<subpath in upstream>
VENDORED=(
    "home/.zsh/plugins/git|git@github.com:ohmyzsh/ohmyzsh.git|plugins/git"
    "home/.zsh/plugins/taskwarrior|git@github.com:ohmyzsh/ohmyzsh.git|plugins/taskwarrior"
    "home/.zsh/plugins/command-not-found|git@github.com:ohmyzsh/ohmyzsh.git|plugins/command-not-found"
)

echo "==> Re-vendoring plugin directories from upstream..."
last_url=""
tmp=""
cleanup() { [ -n "$tmp" ] && rm -rf "$tmp"; }
trap cleanup EXIT

for entry in "${VENDORED[@]}"; do
    dest="${entry%%|*}"; rest="${entry#*|}"
    url="${rest%%|*}"; subpath="${rest##*|}"
    if [ "$url" != "$last_url" ]; then
        [ -n "$tmp" ] && rm -rf "$tmp"
        tmp="$(mktemp -d)"
        git clone --depth 1 --filter=blob:none --sparse "$url" "$tmp" >/dev/null 2>&1
        last_url="$url"
    fi
    git -C "$tmp" sparse-checkout add "$subpath" >/dev/null 2>&1
    rm -rf "$REPO_DIR/$dest"
    mkdir -p "$(dirname "$REPO_DIR/$dest")"
    cp -R "$tmp/$subpath" "$REPO_DIR/$dest"
    rm -rf "$REPO_DIR/$dest/.git"
    echo "    vendored $dest  <- ${url##*/}/$subpath"
done

echo "==> Done. Review with: git -C \"$REPO_DIR\" status"
