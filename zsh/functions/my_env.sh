function my_env {
    env |  sed 's/=/\t/' | \
            fzf --delimiter="\t" \
                --with-nth=1 \
                --layout=reverse \
                --pointer="→" \
                --header="env - $(pwd | rev | cut -d/ -f1-3 | rev)" \
                --preview="echo {2..}"
}