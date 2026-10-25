function deck {
    local docs_dir="${ZSH_FUNC_PATH:h}/docs"
    alias | sed "s/='/\t/" |  \
            sed "s/'$//" | \
            sed "s/=/\t/" | \
            fzf --delimiter="\t" \
                --preview "test -f ${docs_dir}/{1}.md && snap run glow -s dark -w \${FZF_PREVIEW_COLUMNS:-80} ${docs_dir}/{1}.md || echo {2..}" \
                --layout=reverse \
                --pointer="→" \
                --with-nth=1 \
                --header="Command Deck @ $(pwd | rev | cut -d/ -f1-3 | rev)" \
                --bind 'enter:become(zsh -i -c {2..})'
}
