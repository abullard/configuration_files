function vimp {
    ls -p | grep -v / | \
            fzf --layout=reverse \
                --pointer="→" \
                --header="vim preview - $(pwd | rev | cut -d/ -f1-3 | rev)" \
                --preview 'batcat --color=always {}' \
                --bind 'enter:become(vim {})'
}