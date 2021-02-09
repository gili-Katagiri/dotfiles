#!/usr/bin/env bash

set -u
# path to ~/.local/*
LOCAL_PATH="${HOME}"/.local
LOCAL_BIN_PATH="${LOCAL_PATH}"/bin
LOCAL_ETC_PATH="${LOCAL_PATH}"/etc
LOCAL_OPT_PATH="${LOCAL_PATH}"/opt
mkdir -p "${LOCAL_ETC_PATH}" "${LOCAL_BIN_PATH}" "${LOCAL_OPT_PATH}"

# path to ???/dotfiles/*
DOTFILES_ETC_PATH="$(realpath $(dirname "${BASH_SOURCE[0]}"))"
DOTFILES_DOT_PATH="$(dirname "${DOTFILES_ETC_PATH}")/dot"
DOTFILES_BIN_PATH="$(dirname "${DOTFILES_ETC_PATH}")/bin"
DOTFILES_CUSTOMRC_PATH="${DOTFILES_ETC_PATH}"/customrc
# rcfile path
ZSH_RC_FILE="${ZDOTDIR:-$HOME}"/.zshrc

# Link to ~/.*
echo "Create configuration links to ${HOME}:"
for dotfile in $(ls ${DOTFILES_DOT_PATH}); do
    echo -n "  "
    ln -snv "${DOTFILES_DOT_PATH}"/"$dotfile" "${HOME}"/."$dotfile" 2>&1
done
# Link to ~/.local/bin/*
echo "Create binary links to ${LOCAL_BIN_PATH}:"
for binfile in $(ls ${DOTFILES_BIN_PATH}); do
    echo -n "  "
    ln -snv "${DOTFILES_BIN_PATH}"/"$binfile" "${LOCAL_BIN_PATH}"/"$binfile" 2>&1
done

# If tool's installer were to create rc-file based on your env at installation,
#    1. it is additionaly written to ~/.local/etc/initrc.zsh,
#    2. and these basically do not rewritten .
# Create initrc.zsh -----
touch "${LOCAL_ETC_PATH}"/initrc.zsh
cat >> "${LOCAL_ETC_PATH}"/initrc.zsh << EOF
# Written only once when the tools are installed.

EOF

# Settings for using the extended commands are written separately from those,
#    1. these are placed under ~/.local/etc/customrc/,
#    2. and it is sym-link because reflect your changes instantly.
# Link to ~/.local/etc/customrc -----
echo -ne "Create customized-config links to ${DOTFILES_CUSTOMRC_PATH}:\n  "
ln -snv "${DOTFILES_CUSTOMRC_PATH}" "${LOCAL_ETC_PATH}"/"customrc" 2>&1

# prepare .zshrc
touch "${ZSH_RC_FILE}"
cat >> "${ZSH_RC_FILE}" << EOF
# These settings written from ${BASH_SOURCE[0]}
# ----------------------------------------------------
case ":\${PATH}:" in
    *:"\${HOME}/.local/bin":*)
        ;;
    *)
        export PATH="\$HOME/.local/bin:\$PATH"
        ;;
esac
# Read settings added during installation.
source "${LOCAL_ETC_PATH}"/initrc.zsh
# Read customized config
for rcfile in \$(ls "${LOCAL_ETC_PATH}"/customrc); do
    source "${LOCAL_ETC_PATH}"/customrc/"\$rcfile"
done
# ----------------------------------------------------

EOF
