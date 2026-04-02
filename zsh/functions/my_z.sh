function my_z {
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
          --footer="Recent Directories - [Enter] to navigate" \
          --preview 'ls -gha --color=always {2}'
  ) && cd "$dir"
}
