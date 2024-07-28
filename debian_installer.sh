echo "STARTING INSTALL"
echo "==============================================="

echo "Sym->linking dotfiles"
echo "==============================================="
stow .


echo "Installing prerequisites"
echo "==============================================="
sudo apt-get install git
sudo apt-get install ninja-build gettext cmake unzip curl build-essential

set -e

echo "Installing Neovim"
echo "==============================================="
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo 
git checkout stable
sudo make install
