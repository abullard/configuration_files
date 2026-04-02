# --- author: @abullard 
# --- date: 03/31/2026

# --- Install Dependencies
sudo apt install fzf
curl https://raw.githubusercontent.com/rupa/z/master/z.sh -o $HOME/.z.sh
sudo apt install bat

# --- add to zsh
echo "Impriting command deck signature..."
cat ./zsh/install/zsh.txt >> $HOME/.zshrc

sleep 3
echo "Imprint complete."
echo ""

sleep 1
echo "execute 'reload' command to apply changes."
 