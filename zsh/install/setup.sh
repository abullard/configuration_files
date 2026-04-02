# --- author: @abullard 
# --- date: 03/31/2026

# --- Install Dependencies

if echo $(uname -s) | grep -q "Linux"; then
    echo "Linux installation detected: "
    echo ""
    sudo apt install fzf
    curl https://raw.githubusercontent.com/rupa/z/master/z.sh -o $HOME/.z.sh
    sudo apt install bat
elif echo $(uname -s) | grep -q "Darwin"; then
    echo "MacOS installation detected: "
    echo ""
    brew install fzf
    brew install z
    brew install bat
else
    echo "OS not detected, review script to correct"
    exit
fi

# --- add to zsh
echo "Impriting command deck signature..."
cat ./zsh/install/zsh.txt >> $HOME/.zshrc

sleep 3
echo "Imprint complete."
echo ""

sleep 1
echo "execute 'reload' command to apply changes."
 