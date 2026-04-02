function deck {
    alias | sed "s/='/\t/" |  \
            sed "s/'$//" | \
            sed "s/=/\t/" | \
            fzf --delimiter="\t" \
                --preview 'echo {2..}' \
                --layout=reverse \
                --pointer="→" \
                --highlight-line \
                --with-nth=1 \
                --ghost="input search term" \
                --header="$(pwd | rev | cut -d/ -f1-3 | rev)" \
                --footer="Command Deck - [Enter] to run" \
                --bind 'enter:become(zsh -i -c {2..})'
}

