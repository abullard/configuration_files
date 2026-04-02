function deck {
    alias | sed "s/='/\t/" |  \
            sed "s/'$//" | \
            sed "s/=/\t/" | \
            fzf --delimiter="\t" \
                --preview 'echo {2..}' \
                --layout=reverse \
                --pointer="→" \
                --with-nth=1 \
                --header="Command Deck @ $(pwd | rev | cut -d/ -f1-3 | rev)" \
                --bind 'enter:become(zsh -i -c {2..})'
}

