function fls() {
  if [[ "$1" == "-h" || "$1" == "--help" || -z "$1" ]]; then
    cat <<'EOF'
fls - fuzzy-find a file under the cwd and run a command on it

Usage:
  fls <command...>     Fuzzy-list files under the current directory in fzf.
                        On Enter, runs <command> with the picked file spliced
                        in via fzf's own --bind execute(...) + {} placeholder,
                        then exits fzf.
  fls -h | --help       Show this help.

Examples:
  pal t 'ls -lha $1'
  fls t                 # pick a file, fzf runs:  t {}

  fls bat               # no pal involved:        bat {}
  fls open -a Preview   # multi-word command:     open -a Preview {}

Requires:
  fzf on PATH.

Note:
  {} is fzf's placeholder for the selected line, substituted and shell-
  escaped by fzf itself (not by pal/fls) at execute time.
EOF
    return
  fi

  if ! command -v fzf >/dev/null 2>&1; then
    echo "fls: fzf is not installed" >&2
    return 1
  fi

  local cmd="$*"
  # todo: may still want to update the cli options on this
  find . -type f 2>/dev/null | fzf --bind "enter:execute(${cmd} {})+abort"
}