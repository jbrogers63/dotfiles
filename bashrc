HISTCONTROL=ignoreboth
HISTSIZE=1000000
HISTFILESIZE=2000000

# Keep user config from polluting the whole system.
# All configs, apps, toolchains, etc will be confined
# to the user's home folder.
BASH_CONFIG_FILES=(
bash_aliases
bash_prompt
bash_variables
bash_path
)

# Hardcode the config directory, with the expectation
# that installation will follow a known configuration.
SOURCE_DIR=$HOME/.dotfiles

for file in ${BASH_CONFIG_FILES[@]}; do
  if [ -f ${SOURCE_DIR}/${file} ]; then
    . ${SOURCE_DIR}/${file}
  fi
done

