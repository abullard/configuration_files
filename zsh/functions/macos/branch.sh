function branch {
    git branch |  \
        fzf --highlight-line \
            --layout=reverse \
            --pointer="→" \
            --ghost="input search term" \
            --header="$(pwd | rev | cut -d/ -f1-3 | rev)" \
            --footer="git branch - [Enter] to checkout" \
            --preview 'git show --pretty=fuller --no-patch --color=always {-1}' \
            --bind 'enter:become(git checkout {-1})' \
}