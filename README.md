# Dotfiles / System and Application configuration files
**So that I can easily transport my setup to any machine (running linux and maybe windows...)**

## Installation
### Linux
**1)** Create a directory in your $HOME folder, call it dotfiles for example. Then navigate into it
```cd ~/ && mkdir dotfiles && cd dotfiles```
**2)** Clone this repo
```git clone https://github.com/dantolas/dotfiles```
**3)** Now u can either run the installer to do everything for u, including installing applications,
or if you just want the config files then install GNU stow and use it to symlink the config files.
- **Be aware** that this will overwrite any of the dotfiles with the same name that already exist
in the $HOME ( ~/. ) directory such as .bashrc or .config
**Run installer**
```bash debian_installer.sh```
**Symlink dotfiles**
```stow .```

U should then see symlink files pointing to the ~/dotfiles/* config files in your $HOME directory.
