#!/usr/bin/env bash
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
echo -n "Confirm installation environment.

XDG_CONFIG_HOME: ${XDG_CONFIG_HOME}

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

# install fzf as ${XDG_CONFIG_HOME}/fzf from GitHub
git clone --depth 1 https://github.com/junegunn/fzf.git ${XDG_CONFIG_HOME}/fzf
# create ${XDG_CONFIG_HOME}/fzf/fzf.zsh and update .zshrc
${XDG_CONFIG_HOME}/fzf/install --xdg --all --no-bash --no-fish
