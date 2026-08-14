#!/usr/bin/env bash
# Regenerate ./Brewfile with PUBLIC Homebrew packages only.
#   Keeps: homebrew/core formulae, homebrew/cask casks, and the public
#          third-party taps listed in PUBLIC_TAPS below (plus their packages).
#   Drops: every other tap and its packages, and non-brew entries
#          (mas/vscode/cargo/npm). Only allowlisted lines are emitted.
# Update with:  make brew   (from the repo root)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"
command -v brew >/dev/null 2>&1 || { echo "brew not found on PATH" >&2; exit 1; }

# Public third-party taps to include ('|'-separated). Extend as needed.
PUBLIC_TAPS='nikitabobko/tap|michel-kraemer/zsh-patina'

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle dump --force --no-vscode --file="$tmp"

{
	echo "# Brewfile — public Homebrew packages for this setup."
	echo "# Regenerate with: make brew"
	echo "# Install with:    make brew-install"
	echo
	awk -v taps="$PUBLIC_TAPS" '
		BEGIN { n = split(taps, T, "|"); for (i = 1; i <= n; i++) allow[T[i]] = 1 }
		/^#/                        { next }
		/^(mas|vscode|cargo|npm) /  { next }
		/^tap "/ {
			name = $0; sub(/^tap "/, "", name); sub(/".*/, "", name)
			if (name in allow) print
			next
		}
		/^(brew|cask) "/ {
			q = $0; sub(/^(brew|cask) "/, "", q); sub(/".*/, "", q)
			if (q !~ /\//) { print; next }              # unqualified core/cask
			split(q, P, "/"); if ((P[1] "/" P[2]) in allow) print
			next
		}
	' "$tmp"
} > Brewfile

echo "Wrote $REPO_DIR/Brewfile"
echo "  taps: $(grep -c '^tap '  Brewfile)   formulae: $(grep -c '^brew ' Brewfile)   casks: $(grep -c '^cask ' Brewfile)"
