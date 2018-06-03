# For additional configuration options, see bash(1)

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

shopt -s histappend
shopt -s checkwinsize
#shopt -s globstar

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

HISTCONTROL=ignoreboth
HISTSIZE=1000000
HISTFILESIZE=2000000

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Keep user config from polluting the whole system.
# All configs, apps, toolchains, etc will be confined
# to the user's home folder.
BASH_CONFIG_FILES=(
$HOME/.bash_aliases
$HOME/.bash_prompt
$HOME/.bash_variables
$HOME/.bash_path
)

for file in ${BASH_CONFIG_FILES[@]}; do
  if [ -f $file ]; then
    . $file
  fi
done

