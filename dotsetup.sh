#!/usr/bin/env sh
SCRIPT_DIR=$(realpath $(dirname $0))
CUSTOMRC_DIR="$SCRIPT_DIR"/customrc
ZSH_RC_FILE="${ZDOTDIR:-$HOME}"/.zshrc

# Link to ~
# These are directories or files that are usually not created during installation.
ln -s "$SCRIPT_DIR"/vim ~/.vim
ln -s "$SCRIPT_DIR"/gitconfig ~/.gitconfig

# Set to load additional configuration.
# The files read here is placed under 'dotfiles/customrc/'.
# If tool's installer were to create rc-file based on your env at the time of installation,
# this makes it easier to manage and apply extensions.
[ -f $ZSH_RC_FILE ] && echo >> "$ZSH_RC_FILE"
    cat >> ${ZSH_RC_FILE} << EOF
# load config from dotfiles/customrc
for rcfile in \$(ls $CUSTOMRC_DIR); do
    source $CUSTOMRC_DIR/"\$rcfile"
done
EOF
