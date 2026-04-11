function my_ssh {
    grep -E "^Host\s+" $HOME/.ssh/config | awk '{print $2}' |  \
        fzf --layout=reverse \
            --pointer="→" \
            --header="Secure Shell" \
            --preview 'ssh -G {} | batcat --color=always' \
            --bind 'enter:become(ssh {})' 
}
