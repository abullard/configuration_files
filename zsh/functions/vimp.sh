function vimp {
    ls -p | grep -v / | \
            fzf --layout=reverse \
                --highlight-line \
                --pointer="→" \
                --ghost="input search term" \
                --header="$(pwd | rev | cut -d/ -f1-3 | rev)" \
                --footer="vim preview - [Enter] to open" \
                --preview 'bat --color=always {}' \
                --bind 'enter:become(vim {})'
}