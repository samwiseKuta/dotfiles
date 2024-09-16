# Dotfiles / System and Application configuration files

Files containing my preffered software configurations just the way I like them.

This Readme should serve as a guide how to transfer my dotfiles, preffered system configurations or
even apps from one machine to another.

For now only focused on moving configurations through Linux machines, might make windows later.

## Installation
### Linux
**1)** Create a directory in your $HOME folder, call it dotfiles for example. Then navigate into it
```cd ~/ && mkdir dotfiles && cd dotfiles```
**2)** Clone this repo
```git clone https://github.com/dantolas/dotfiles```
**3)** Now u can either run the installer to do everything for u, including installing applications,
or if you just want the dotfiles then install GNU stow and use it to symlink the dotfiles directory.
- **Be aware** that this will overwrite any of the dotfiles with the same name that already exist
in the $HOME ( ~/. ) directory such as .bashrc or .config

- **Run installer**
```bash debian_installer.sh```
- **Symlink dotfiles**
```stow .```

Afterwards you should see that the dotfiles in your $HOME directory (~/) are symlinked and pointing
to this dotfiles directory and it's content. ($HOME dotfiles -> ./dotfiles/...)


