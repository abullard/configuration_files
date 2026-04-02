function my_z {
  local dir=$(
    _z 2>&1 |
      fzf --nth 2.. \
          --no-sort \
          --layout=reverse \
          --pointer="→" \
          --header="Recent Directories - $(pwd | rev | cut -d/ -f1-3 | rev)" \
          --preview 'ls -gha --color=always {2}'
  ) && cd "$dir"
}
