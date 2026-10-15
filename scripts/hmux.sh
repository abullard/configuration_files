#!/usr/bin/env bash
# Stop on errors, unset variables, or a failed step in a pipeline.
set -euo pipefail

# Default commands. Quoted command-line arguments override these for one run.
# Leave unused commands empty.
PANE_1_COMMAND='' # Server (left / top-left).
PANE_2_COMMAND='' # Client (right / top-right).
PANE_3_COMMAND='' # Bottom-left; 2x2 only.
PANE_4_COMMAND='' # Bottom-right; 2x2 only.

# No argument means two panes. Pass 2x2 for four panes.
layout="${1:-1x2}"
case "$layout" in
    -h|--help)
        cat <<'EOF'
Usage: bash herdr-dev.sh [1x2|2x2] [command1] [command2] [command3] [command4]

Edit the PANE_*_COMMAND defaults above, or pass each command as one quoted argument.
Omitted commands use the defaults. Pass '' to leave a pane idle instead.

  1x2 (default):  1 | 2       2x2:  1 | 2
                                   3 | 4

Run from a single shell pane inside Herdr. Every run adds new splits.
Commands start in this script's directory; focus stays in the original pane.
Requires herdr and jq (a command-line JSON reader; install with brew install jq).

Alias example:
  alias app="bash /absolute/path/to/herdr-dev.sh 1x2 'your-server-command' 'your-client-command'"

Examples:
  bash herdr-dev.sh 1x2 'pnpm api run dev:local' 'pnpm ui run dev:local'
  bash herdr-dev.sh 2x2 '' 'your-client-command' 'your-worker-command' ''
EOF
        exit 0
        ;;
    1x2) max_commands=2 ;;
    2x2) max_commands=4 ;;
    *)
        printf 'Invalid layout: %s (expected 1x2 or 2x2)\n' "$layout" >&2
        exit 1
        ;;
esac

# Remove the layout argument so $1 is now pane 1's command, $2 is pane 2's, etc.
if (( $# > 0 )); then
    shift
fi

if (( $# > max_commands )); then
    printf 'Layout %s accepts at most %s commands.\n' "$layout" "$max_commands" >&2
    exit 1
fi

# ${1-default} uses the default only when the argument is missing.
# An explicitly empty argument ('') stays empty, leaving that pane idle.
PANE_1_COMMAND="${1-$PANE_1_COMMAND}"
PANE_2_COMMAND="${2-$PANE_2_COMMAND}"
PANE_3_COMMAND="${3-$PANE_3_COMMAND}"
PANE_4_COMMAND="${4-$PANE_4_COMMAND}"

if [[ "${HERDR_ENV:-}" != 1 || -z "${HERDR_PANE_ID:-}" ]]; then
    printf 'Run this script from a shell prompt inside Herdr.\n' >&2
    exit 1
fi

# jq reads JSON, the structured text Herdr returns after creating a pane.
# It is required here to extract the new pane's ID reliably, so we can send
# commands to that exact pane instead of guessing IDs or using keyboard focus.
for dependency in herdr jq; do
    if ! command -v "$dependency" >/dev/null 2>&1; then
        printf 'Required command not found: %s\n' "$dependency" >&2
        exit 1
    fi
done

# Resolve the script's directory so the alias works from any directory.
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

split_pane() {
    # $1 is the pane to split; $2 is "right" or "down".
    # --no-focus keeps the user's cursor in the original pane.
    herdr pane split "$1" --direction "$2" --cwd "$PWD" --no-focus |
        jq -er '.result.pane.pane_id | select(type == "string" and length > 0)'
}

run_command() {
    # $1 is the destination pane; $2 is its command. Skip empty commands.
    if [[ -n "$2" ]]; then
        herdr pane run "$1" "$2"
    fi
}

# Build the layout before starting any commands.
pane_1="$HERDR_PANE_ID"
pane_2="$(split_pane "$pane_1" right)"
if [[ "$layout" == '2x2' ]]; then
    pane_3="$(split_pane "$pane_1" down)"
    pane_4="$(split_pane "$pane_2" down)"
    run_command "$pane_3" "$PANE_3_COMMAND"
    run_command "$pane_4" "$PANE_4_COMMAND"
fi
run_command "$pane_2" "$PANE_2_COMMAND"

# This script occupies pane 1, so run its command here, not via Herdr.
# exec replaces the script with your shell; -i loads interactive aliases.
if [[ -n "$PANE_1_COMMAND" ]]; then
    exec "${SHELL:-/bin/bash}" -ic "$PANE_1_COMMAND"
fi
