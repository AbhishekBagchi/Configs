#!/usr/bin/env bash
# Smart-merge dotfiles from ./home into $HOME.
# - Third-party submodule trees are rsynced wholesale.
# - Own tracked files use the committed blob (HEAD:home/<f>) as a 3-way base:
#     ~ == repo            -> skip (in sync)
#     ~ == base, repo new  -> apply update (no local edits to lose)
#     repo == base, ~ new  -> preserve (local/work-specific only)
#     both diverged / new  -> show diff and prompt [y/N/m/d]
# Set DRYRUN=1 to report actions without writing.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$REPO_DIR/home"
DEST="${HOME}"
DRYRUN="${DRYRUN:-0}"

n_new=0 n_update=0 n_preserve=0 n_sync=0 n_overwrite=0 n_kept=0 n_merged=0 n_skip=0

log()  { printf '%s\n' "$*"; }
act()  { [ "$DRYRUN" = 1 ] && printf '[dry] %s\n' "$*" || true; }

copy() {
	local s="$1" d="$2"
	if [ "$DRYRUN" = 1 ]; then act "cp $s -> $d"; return; fi
	mkdir -p "$(dirname "$d")"
	cp -p "$s" "$d"
}

# --- submodule trees: wholesale rsync ---------------------------------------
while IFS= read -r sm; do
	rel="${sm#home/}"
	[ -d "$SRC/$rel" ] || continue
	if [ "$DRYRUN" = 1 ]; then
		act "rsync -a --exclude=.git $SRC/$rel/ -> $DEST/$rel/"
	else
		mkdir -p "$DEST/$rel"
		rsync -a --exclude=.git "$SRC/$rel/" "$DEST/$rel/"
	fi
done < <(git -C "$REPO_DIR" config --file "$REPO_DIR/.gitmodules" --get-regexp '\.path$' | awk '{print $2}')

is_submodule() {
	git -C "$REPO_DIR" config --file "$REPO_DIR/.gitmodules" --get-regexp '\.path$' \
		| awk '{print $2}' | grep -qxF "$1"
}

# --- own tracked files: 3-way-base decision ---------------------------------
merge_file() {
	local gpath="$1" rel="${1#home/}"
	local src="$SRC/$rel" dst="$DEST/$rel"

	[ -f "$src" ] || return 0

	if [ ! -e "$dst" ]; then
		copy "$src" "$dst"; log "new        $rel"; n_new=$((n_new+1)); return 0
	fi
	if cmp -s "$src" "$dst"; then
		n_sync=$((n_sync+1)); return 0
	fi

	local base; base="$(mktemp)"
	local have_base=0
	git -C "$REPO_DIR" show "HEAD:$gpath" > "$base" 2>/dev/null && have_base=1

	if [ "$have_base" = 1 ] && cmp -s "$base" "$dst"; then
		copy "$src" "$dst"; log "update     $rel"; n_update=$((n_update+1)); rm -f "$base"; return 0
	fi
	if [ "$have_base" = 1 ] && cmp -s "$base" "$src"; then
		log "preserve   $rel  (local-only changes kept)"; n_preserve=$((n_preserve+1)); rm -f "$base"; return 0
	fi

	# divergence (or untracked): interactive resolution
	if [ ! -t 0 ]; then
		log "skip       $rel  (conflict, non-interactive)"; n_skip=$((n_skip+1)); rm -f "$base"; return 0
	fi

	log ""
	log "=== conflict: $rel (repo vs ~) ==="
	diff -u "$dst" "$src" || true
	while true; do
		printf 'Overwrite ~/%s? [y]es / [N]o keep / [m]erge / [d]iff: ' "$rel"
		local ans; read -r ans </dev/tty || ans=n
		case "${ans:-n}" in
			y|Y) copy "$src" "$dst"; log "overwrite  $rel"; n_overwrite=$((n_overwrite+1)); break ;;
			m|M)
				if [ "$have_base" != 1 ]; then log "  (no base; cannot 3-way merge, keeping local)"; n_kept=$((n_kept+1)); break; fi
				local out; out="$(mktemp)"
				if git merge-file -p "$dst" "$base" "$src" > "$out"; then
					if [ "$DRYRUN" = 1 ]; then act "merge -> $dst"; else mkdir -p "$(dirname "$dst")"; cp "$out" "$dst"; fi
					log "merged     $rel  (clean)"; n_merged=$((n_merged+1)); rm -f "$out"; break
				else
					log "  merge has conflicts; wrote markers to a preview. Apply anyway? [y/N]: "
					local a2; read -r a2 </dev/tty || a2=n
					if [ "${a2:-n}" = y ] || [ "${a2:-n}" = Y ]; then
						if [ "$DRYRUN" = 1 ]; then act "merge(conflict) -> $dst"; else cp "$out" "$dst"; fi
						log "merged     $rel  (with conflict markers)"; n_merged=$((n_merged+1)); rm -f "$out"; break
					fi
					rm -f "$out"
				fi
				;;
			d|D) diff -u "$dst" "$src" || true ;;
			*) log "kept       $rel"; n_kept=$((n_kept+1)); break ;;
		esac
	done
	rm -f "$base"
}

while IFS= read -r f; do
	is_submodule "$f" && continue
	merge_file "$f"
done < <(git -C "$REPO_DIR" ls-files home)

log ""
log "Summary: ${n_new} new, ${n_update} updated, ${n_merged} merged, ${n_overwrite} overwritten, ${n_preserve} preserved, ${n_kept} kept, ${n_skip} skipped, ${n_sync} in-sync"
[ "$DRYRUN" = 1 ] && log "(dry run — no files written)" || true
