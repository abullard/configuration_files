# ADR 0001 - 10/18/2026 - abullard
# This executes a pushd from your most recently used directories using fzf.
# Tradeoff: You can't pushd ANYWHERE on the PC, just your most recently used directories.

function pushz {
  local dir=$(
    _z 2>&1 |
      fzf --nth 2.. \
          --no-sort \
          --accept-nth 2..\
          --layout=reverse \
          --highlight-line \
          --pointer="→" \
          --ghost="input search term" \
          --header="$(pwd | rev | cut -d/ -f1-3 | rev)" \
          --footer="Recent Directories - [Enter] to pushd" \
          --preview 'ls -gha --color=always {2}'
  ) && pushd "$dir"
}
