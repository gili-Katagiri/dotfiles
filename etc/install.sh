#!/usr/bin/env bash

set -u

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

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
  XDG-config Home: ${XDG_CONFIG_HOME}

Are you OK? (Y/n): "
read confirm
case $confirm in 
    [Yy]|[Yy][Ee][Ss])
	echo START!
	;;
    *)
	echo QUIT
	exit 1
	;;
esac

# INSTALL ==========
cd ${XDG_CONFIG_HOME}
xdg_path=$(pwd)
LOCAL_BIN_PATH="${HOME}"/.local/bin
INITIAL_SETTING_RC="${HOME}"/.local/etc/initrc.zsh

# FZF -----
# install fzf as ${XDG_CONFIG_HOME}/fzf from GitHub
git clone --depth 1 https://github.com/junegunn/fzf.git ./fzf

# Init
# create ${XDG_CONFIG_HOME}/fzf/fzf.zsh but not update zshrc.
./fzf/install\
  --xdg --key-bindings --completion --no-update-rc \
  --no-bash --no-fish
# add .local/bin/fzf
ln -snv "${xdg_path}"/fzf/bin/fzf "${LOCAL_BIN_PATH}"/fzf
# extract the lines after "# Auto-completion"
cat >> "${INITIAL_SETTING_RC}" << EOF
#fzf basic config
$(tail -n +$(sed -n '/Auto-completion/=' ./fzf/fzf.zsh) ./fzf/fzf.zsh)
EOF

## use as vim-plugin
## fuzzy finder
#cat >> ${HOME}/.vim/dein.toml << EOF
#[[plugin]]
#repo = '${xdg_path}/fzf'
#[[plugin]]
#repo = 'junegunn/fzf.vim'
#EOF
