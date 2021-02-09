#!/usr/bin/env bash

set -u

XDG_PATH=$(realpath ${XDG_CONFIG_HOME:-$HOME/.config})
INSTALL_PATH="${HOME}"/.local/opt

# ENVIRONMENT ==========
dependency_commands=("git")
echo "Dependency commands:"
for dcom in ${dependency_commands[@]}; do
    message=$($dcom --version 2>/dev/null)
    if [ "${message}" = "" ]; then
	echo " !$dcom: Not Found."
	exit 1
    fi
    echo "  ${message:0:32} ... "
done

echo -n "
Confirm installation environment:
  XDG config Home: ${XDG_PATH}
  install to: ${INSTALL_PATH}

Are you OK? (Y/n): "
read confirm
case $confirm in 
    [Yy]|[Yy][Ee][Ss])
	;;
    *)
	exit 1
	;;
esac

# INSTALL ==========
# after setup.sh
lbp="${HOME}"/.local/bin
isrc="${HOME}"/.local/etc/initrc.zsh

# FZF -----
# install fzf as ${XDG_CONFIG_HOME}/fzf from GitHub
if [ ! -d "${INSTALL_PATH}/fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "${INSTALL_PATH}"/fzf
    # Init
    # create ~/fzf.zsh but not update zshrc.
    "${INSTALL_PATH}"/fzf/install\
      --key-bindings --completion --no-update-rc \
      --no-bash --no-fish

    # cp "${XDG_PATH}/fzf/fzf.zsh "${INSTALL_PATH}/fzf/ ???
    mv "${HOME}"/.fzf.zsh "${INSTALL_PATH}"/fzf/fzf.zsh
    # extract the lines after "# Auto-completion"
    tmp_number=$(sed -n '/Auto-completion/=' ${INSTALL_PATH}/fzf/fzf.zsh)
    cat >> "${isrc}" << EOF
# fzf basic config
$(tail -n +${tmp_number} ${INSTALL_PATH}/fzf/fzf.zsh | sed '/^$/d')

EOF
fi
# add .local/bin
echo -e "\nCreate sym-link (force):"
for binfile in $(ls "${INSTALL_PATH}"/fzf/bin); do
    echo -n "  "
    ln -sfnv "${INSTALL_PATH}"/fzf/bin/"$binfile" "${lbp}"/"$binfile"
done
## use as vim-plugin
## fuzzy finder
#cat >> ${HOME}/.vim/dein.toml << EOF
#[[plugin]]
#repo = '${XDG_PATH}/fzf'
#[[plugin]]
#repo = 'junegunn/fzf.vim'
#EOF
