#!/usr/bin/env bash

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTS_HOME="$SCRIPT_DIR/home"
HOSTS_DIR="$SCRIPT_DIR/hosts"

# ---------------------------------------------------------------------------
# Options
# ---------------------------------------------------------------------------
MODE=""          # "" | "skip" | "overwrite"
DRY_RUN=false
TARGET_FILES=()  # specific files to sync (relative to home/)
HOST=""          # optional host under hosts/, layered over home/

# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------
STATUS_WIDTH=10

log() {
    local status="$1"
    local path="$2"
    local reason="${3:-}"
    if [[ -n "$reason" ]]; then
        printf "  %-${STATUS_WIDTH}s %s  (%s)\n" "$status" "$path" "$reason"
    else
        printf "  %-${STATUS_WIDTH}s %s\n" "$status" "$path"
    fi
}

err() {
    echo "error: $*" >&2
    exit 1
}

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
# Source roots in order; later roots override earlier ones per file
ROOTS=()

rel_path() {
    local src="$1" root
    for root in "${ROOTS[@]}"; do
        if [[ "$src" == "$root"/* ]]; then
            echo "${src#"$root"/}"
            return
        fi
    done
}

get_target() {
    echo "$HOME/$(rel_path "$1")"
}

# Path of a home-relative file in the highest-priority root that has it
resolve_file() {
    local rel="$1" i
    for (( i=${#ROOTS[@]}-1; i>=0; i-- )); do
        if [[ -e "${ROOTS[i]}/$rel" ]]; then
            echo "${ROOTS[i]}/$rel"
            return
        fi
    done
}

display_path() {
    echo "${1/#$HOME/\~}"
}

is_correct_symlink() {
    local target="$1" src="$2"
    [[ -L "$target" && "$(readlink "$target")" == "$src" ]]
}

next_backup_path() {
    local target="$1"
    local bak="${target}.bak"
    if [[ ! -e "$bak" ]]; then
        echo "$bak"
        return
    fi
    local i=1
    while [[ -e "${bak}.${i}" ]]; do
        (( i++ ))
    done
    echo "${bak}.${i}"
}

do_link() {
    local src="$1" target="$2"
    $DRY_RUN && return
    mkdir -p "$(dirname "$target")"
    ln -sf "$src" "$target"
}

do_backup() {
    local target="$1" dest="$2"
    $DRY_RUN && return
    mv "$target" "$dest"
}

do_remove() {
    local target="$1"
    $DRY_RUN && return
    rm -f "$target"
}

# ---------------------------------------------------------------------------
# Sync a single file
# ---------------------------------------------------------------------------
sync_file() {
    local src="$1"
    local target
    target="$(get_target "$src")"
    local disp
    disp="$(display_path "$target")"
    local dry_prefix=""
    $DRY_RUN && dry_prefix="[dry] "

    # Already the correct symlink — nothing to do
    if is_correct_symlink "$target" "$src"; then
        log "ok" "$disp" "already linked"
        return
    fi

    # Target exists (regular file, dir, or wrong symlink)
    if [[ -e "$target" || -L "$target" ]]; then
        case "$MODE" in
            skip)
                log "skipped" "$disp" "${dry_prefix}file exists"
                return
                ;;
            overwrite)
                do_remove "$target"
                do_link "$src" "$target"
                log "linked" "$disp" "${dry_prefix}overwrote existing"
                ;;
            *)
                # Default: backup if content differs, else just replace
                if diff -q "$src" "$target" &>/dev/null 2>&1; then
                    do_remove "$target"
                    do_link "$src" "$target"
                    log "linked" "$disp" "${dry_prefix}replaced identical file"
                else
                    local bak
                    bak="$(next_backup_path "$target")"
                    do_backup "$target" "$bak"
                    do_link "$src" "$target"
                    log "linked" "$disp" "${dry_prefix}backed up to $(basename "$bak")"
                fi
                ;;
        esac
        return
    fi

    # Target does not exist — fresh link
    do_link "$src" "$target"
    log "linked" "$disp" "${dry_prefix}new"
}

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] [HOST]

Sync dotfiles from the repo's home/ directory to \$HOME via symlinks.
With HOST, hosts/HOST/home/ is synced too, overriding files from home/.
Available hosts: $(ls "$HOSTS_DIR" 2>/dev/null | tr '\n' ' ')

Options:
  -s, --skip-existing   Skip files that already exist (mutually exclusive with -o)
  -o, --overwrite       Overwrite existing files without backup (mutually exclusive with -s)
  -f, --files PATHS...  Only sync specific files (paths relative to home/)
  -n, --dry-run         Show what would be done without making changes
  -h, --help            Show this help

Examples:
  $(basename "$0")
  $(basename "$0") drpepper-t14s
  $(basename "$0") --skip-existing
  $(basename "$0") --overwrite --dry-run
  $(basename "$0") --files .zshrc .config/nvim/init.lua
EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -s|--skip-existing)
                [[ "$MODE" == "overwrite" ]] && err "-s and -o are mutually exclusive"
                MODE="skip"
                shift
                ;;
            -o|--overwrite)
                [[ "$MODE" == "skip" ]] && err "-s and -o are mutually exclusive"
                MODE="overwrite"
                shift
                ;;
            -f|--files)
                shift
                [[ $# -eq 0 ]] && err "--files requires at least one path argument"
                while [[ $# -gt 0 && "$1" != -* ]]; do
                    TARGET_FILES+=("$1")
                    shift
                done
                ;;
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -*)
                err "unknown option: $1"
                ;;
            *)
                [[ -n "$HOST" ]] && err "only one host allowed (got '$HOST' and '$1')"
                HOST="$1"
                shift
                ;;
        esac
    done
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
    parse_args "$@"

    [[ ! -d "$DOTS_HOME" ]] && err "home/ directory not found at $DOTS_HOME"
    ROOTS=("$DOTS_HOME")

    if [[ -n "$HOST" ]]; then
        if [[ -d "$HOSTS_DIR/$HOST/home" ]]; then
            ROOTS+=("$HOSTS_DIR/$HOST/home")
        else
            echo "warning: no host '$HOST' in hosts/, syncing common files only" >&2
            HOST=""
        fi
    fi

    local files=()

    if [[ ${#TARGET_FILES[@]} -gt 0 ]]; then
        for f in "${TARGET_FILES[@]}"; do
            local src
            src="$(resolve_file "$f")"
            [[ -z "$src" ]] && err "'$f' not found in repo"
            files+=("$src")
        done
    else
        # Index by home-relative path so later roots override earlier ones
        local -A by_rel=()
        local root f
        for root in "${ROOTS[@]}"; do
            while IFS= read -r -d '' f; do
                by_rel["${f#"$root"/}"]="$f"
            done < <(find "$root" -type f -print0)
        done
        while IFS= read -r -d '' f; do
            files+=("${by_rel[$f]}")
        done < <(printf '%s\0' "${!by_rel[@]}" | sort -z)
    fi

    if [[ ${#files[@]} -eq 0 ]]; then
        echo "No files found in $DOTS_HOME"
        exit 0
    fi

    local header="Syncing dotfiles -> \$HOME"
    [[ -n "$HOST" ]] && header="$header  (host: $HOST)"
    $DRY_RUN && header="$header  [dry run]"
    echo "$header"
    echo ""

    for f in "${files[@]}"; do
        sync_file "$f"
    done

    echo ""
    echo "Done."
}

main "$@"
