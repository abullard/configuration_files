#!/bin/bash
# --- author: @abullard
# --- date: 03/31/2026
# please check this script for compatibility with your system before running it

function install_homebrew() {
    # --- homebrew zsh setup
    if [ ! type brew >/dev/null 2>&1 ]; then
        echo 'homebrew installation not found. Installing...'
        echo ''
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo >> $HOME/.zprofile
        echo '# --- homebrew zsh setup' >> $HOME/.zprofile
        echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> $HOME/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv zsh)"
    else
        echo 'homebrew installation found.'
    fi
}

# --- Install Dependencies
function imprint() {
    if echo $(uname -s) | grep -q "Linux"; then
        echo "Linux installation detected: "
        echo ""
        apt install zsh
        apt install fzf
        curl https://raw.githubusercontent.com/rupa/z/master/z.sh -o $HOME/.z.sh
        apt install bat
        curl -fsSL https://herdr.dev/install.sh | sh
        apt install jq # used for herdr multi-plexing
        curl -sS https://starship.rs/install.sh | sh
        apt install ripgrep
    elif echo $(uname -s) | grep -q "Darwin"; then
        echo "MacOS installation detected: "
        echo ""
        install_homebrew
        brew install zsh
        chsh -s $(which zsh) # for m1 macs, this may need to be updated
        brew install fzf
        brew install z
        brew install bat
        brew install herdr
        brew install jq # used for herdr multi-plexing
        brew install starship
        brew install ripgrep
    else
        echo "ERROR: OS not detected, review script to correct"
        exit
    fi

    # --- copy starship.toml to ~/.config
    CONFIG_DIR="$HOME/.config"
    if [ ! -d "$CONFIG_DIR" ]; then
        mkdir -p $CONFIG_DIR
    fi
    cp ./zsh/install/config/starship.toml $CONFIG_DIR/

    # --- add to zsh
    echo "Impriting command deck signature..."
    cat ./zsh/install/zsh.txt >> $HOME/.zshrc

    sleep 3
    echo "Imprint complete."
    echo ""

    sleep 1
    echo "execute 'reload' command to apply changes."
}

# --- get user consent
echo "Have you read this install script & do you trust it's contents–[y/n]?"
select strictreply in "Yes" "No"; do
    relaxedreply=${strictreply:-$REPLY}
    case $relaxedreply in
        Yes | yes | y ) break;;
        No  | no  | n ) exit;;
    esac
done

echo ''
echo "Have you backed up your existing .zshrc|.zprofile–[y/n]?"
select strictreply in "Yes" "No"; do
    relaxedreply=${strictreply:-$REPLY}
    case $relaxedreply in
        Yes | yes | y ) imprint; break;;
        No  | no  | n ) echo "Do that first. This program will append it's own configuration to these files."; exit;;
    esac
done
