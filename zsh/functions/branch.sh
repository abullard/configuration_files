function branch {
    git branch |  \
        fzf --layout=reverse \
            --pointer="→" \
            --header="$(pwd | rev | cut -d/ -f1-3 | rev)" \
            --preview 'git show --pretty=fuller --no-patch --color=always {-1}' \
            --bind 'enter:become(git checkout {-1})' \
}