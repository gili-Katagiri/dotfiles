#!/usr/bin/env bash

set -u

DOTFILES_DOT_PATH="$(dirname "${DOTFILES_ETC_PATH}")/dot"
DOTFILES_BIN_PATH="$(dirname "${DOTFILES_ETC_PATH}")/bin"

# Link to ~/.$dotfile*
echo "Create configuration links to ${HOME}:"
for dotfile in $(ls ${DOTFILES_DOT_PATH}); do
    echo -n "  "
    ln -snv "${DOTFILES_DOT_PATH}"/"$dotfile" "${HOME}"/."$dotfile" 2>&1
done

# bin/ setup --------------------------------------------------
# Link to ~/.local/bin/$binfile
echo "Create binary links to ${LOCAL_BIN_PATH}:"
for binfile in $(ls ${DOTFILES_BIN_PATH}); do
    echo -n "  "
    ln -snv "${DOTFILES_BIN_PATH}"/"$binfile" "${LOCAL_BIN_PATH}"/"$binfile" 2>&1
done
# =============================================================

# etc/ setup --------------------------------------------------
# If tool's installer were to create rc-file based on your env at installation,
# it should be written to ~/.local/etc/exinitrc additionaly with some fix.
# Because:
#    1. These settings are parmanent and rarely changed later,
#    2. in addition, default rc-file may contain unwanted settings.

# Create exinitrc
touch "${LOCAL_INIT_RC}"
cat >> "${LOCAL_INIT_RC}" << EOF
# set path to ${LOCAL_BIN_PATH}
case ":\${PATH}:" in
    *:${LOCAL_BIN_PATH}:*)
        ;;
    *)
        export PATH="${LOCAL_BIN_PATH}:\$PATH"
        ;;
esac

# Settings for each Ex-commands are continued ...

EOF

# Create for vim same reasons
mkdir -p "${LOCAL_ETC_PATH}"/vim
cat > "${LOCAL_ETC_PATH}"/vim/exdein.toml << EOF
# These settings written from ${BASH_SOURCE[0]}
# You can set up vim-plugins isntalled without dein.vim for each.

EOF

# Settings for the extended commands should be written separately from initrc
# and managed as sym-links to dotfiles/etc/customrc/*.
# Because:
#    1. These are often required to change flexibly,
#    2. therefore, convenient for immediate reflection of changed settings.

# Link to ~/.local/etc/rclinks
DOTFILES_CUSTOMRC_PATH="${DOTFILES_ETC_PATH}"/customrc
echo -ne "Create customized-config links to ${DOTFILES_CUSTOMRC_PATH}:\n  "
ln -snv "${DOTFILES_CUSTOMRC_PATH}" "${LOCAL_ETC_PATH}"/"rclinks" 2>&1
# =============================================================

# .zshrc
ZSH_RC_FILE="${ZDOTDIR:-$HOME}"/.zshrc
touch "${ZSH_RC_FILE}"
cat >> "${ZSH_RC_FILE}" << EOF
# ----------------------------------------------------
# These settings written from ${BASH_SOURCE[0]}

# Ex-commands setup
source ${LOCAL_INIT_RC}

# Additional configuration for Ex-commands
for rcfile in \$(ls ${LOCAL_ETC_PATH}/rclinks); do
    source ${LOCAL_ETC_PATH}/rclinks/"\$rcfile"
done
# ----------------------------------------------------

EOF

