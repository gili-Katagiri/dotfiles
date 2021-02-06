#!/usr/bin/env bash
SCRIPT_DIR="$(diraname "${BASH_SOURCE[0]}")"

# Link to ~/.*
# These are directories or files that are usually not created during installation.
ln -s "$SCRIPT_DIR"/vim ~/.vim
ln -s "$SCRIPT_DIR"/gitconfig ~/.gitconfig

# Set to load additional configuration.
# The files read here is placed under 'dotfiles/customrc/'.
# If tool's installer were to create rc-file based on your env at installation,
# this makes it easier to manage and apply extensions.
CUSTOMRC_DIR="${SCRIPT_DIR}"/customrc
ZSH_RC_FILE="${ZDOTDIR:-$HOME}"/.zshrc

[ -f $ZSH_RC_FILE ] && echo >> "$ZSH_RC_FILE"
    cat >> ${ZSH_RC_FILE} << EOF
# Load config from dotfiles/customrc
for rcfile in \$(ls ${CUSTOMRC_DIR}); do
    source ${CUSTOMRC_DIR}/"\$rcfile"
done
EOF
