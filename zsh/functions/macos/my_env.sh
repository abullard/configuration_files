function my_env {
    env |  sed 's/=/\t/' | \
            fzf --delimiter="\t" \
                --with-nth=1 \
                --layout=reverse \
                --highlight-line \
                --pointer="→" \
                --ghost="input search term" \
                --header="$(pwd | rev | cut -d/ -f1-3 | rev)" \
                --footer="Environment Variables" \
                --preview="echo {2..}"
}