## Dotfiles
### Why?
I need a place to store my dotfiles, so that I don't go crazy trying to reconfigure everything. :)

### Installation
The bash configs are finnicky. I haven't sorted out a proper way to call the scripts anywhere and have them work properly. For now, the installation location is hardcoded in the bashrc file and installation is expected to be in ```$HOME```.

```shell
git clone https://github.com/jbrogers63/dotfiles $HOME/.dotfiles
```

### Sections
##### Bash Configs
Bash configs are broken out into different files to facilitate ease of management:
* .bashrc
    * Main entry point
    * Modified from standard Debian fare. May not be portable across *nix-type systems.
* .bash_aliases
    * Contains aliases to save on typing. :)
* .bash_prompt
    * Modifications to the bash prompt
* .bash_variables
    * Variables needed for a variety of things, including exporting standard tooling directories that are used across my various machines.
* .bash_path
    * adjustments to my shell path

##### Vim
* .vimrc
    * For quickly configuring vim to my liking

##### Tmux
* .tmux.conf
* workday.conf
    * Simple tmux-up setup

