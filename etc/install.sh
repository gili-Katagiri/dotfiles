#!/usr/bin/env bash

set -u

# use xdg as default config file, but not use actually.
export XDG_CONFIG_HOME="${LOCAL_CONFIG_PATH}"

# pre-installed commands check
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

# INSTALL ==========

# FZF -----
# install fzf as ${LOCAL_OPT_PATH}/fzf from GitHub
if [ ! -d "${LOCAL_OPT_PATH}/fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "${LOCAL_OPT_PATH}"/fzf
    # Init
    # create ~/fzf.zsh but not update zshrc.
    "${LOCAL_OPT_PATH}"/fzf/install\
      --xdg --key-bindings --completion --no-update-rc \
      --no-bash --no-fish
    # fzf.zsh would be created as ${XDG_CONFIG_HOME}/fzf/fzf.zsh
    # Write to ${LOCAL_INIT_RC} extraction lines on and after "# Auto-completion".
    tmp_number=$(sed -n '/Auto-completion/=' ${XDG_CONFIG_HOME}/fzf/fzf.zsh)
    cat >> "${LOCAL_INIT_RC}" << EOF
# fzf config -----
$(tail -n +${tmp_number} ${XDG_CONFIG_HOME}/fzf/fzf.zsh | sed '/^$/d')

EOF
fi
# add .local/bin
echo -e "\nCreate sym-link (force):"
for binfile in $(ls "${LOCAL_OPT_PATH}"/fzf/bin); do
    echo -n "  "
    ln -sfnv "${LOCAL_OPT_PATH}"/fzf/bin/"$binfile" "${LOCAL_BIN_PATH}"/"$binfile"
done
## use as vim-plugin
## fuzzy finder
#cat >> ${HOME}/.vim/dein.toml << EOF
#[[plugin]]
#repo = '${default_conf_strage}/fzf'
#[[plugin]]
#repo = 'junegunn/fzf.vim'
#EOF
