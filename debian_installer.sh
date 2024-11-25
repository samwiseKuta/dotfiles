echo "==============================================="
echo "STARTING INSTALL"
echo "==============================================="

echo "==============================================="
echo "Sym->linking dotfiles"
echo "==============================================="
stow .


echo "==============================================="
echo "Installing prerequisites"
echo "==============================================="
sudo apt-get install git
sudo apt-get install ninja-build gettext cmake unzip curl build-essential pip
# pip install pylatexenc
#pip install requests pint simpleeval parsedatetime
set -e

echo "==============================================="
echo "Installing Neofetch"
echo "==============================================="
sudo apt install neofetch




echo "==============================================="
echo "Installing Neovim"
echo "==============================================="
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt install neovim
echo "==============================================="
echo "Installing Ulauncher"
echo "==============================================="
sudo add-apt-repository universe -y 
sudo add-apt-repository ppa:agornostal/ulauncher -y 
sudo apt update 
sudo apt install ulauncher
