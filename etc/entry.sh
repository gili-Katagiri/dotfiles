#!/usr/bin/env bash

# path to ~/.local/*
LOCAL_PATH="${HOME}"/.local
export LOCAL_BIN_PATH="${LOCAL_PATH}"/bin
export LOCAL_ETC_PATH="${LOCAL_PATH}"/etc
export LOCAL_OPT_PATH="${LOCAL_PATH}"/opt
export LOCAL_CONFIG_PATH="${LOCAL_PATH}"/config
export LOCAL_INIT_RC="${LOCAL_ETC_PATH}"/exinitrc

# path to ???/dotfiles/etc
export DOTFILES_ETC_PATH="$(realpath $(dirname "${BASH_SOURCE[0]}"))"

# Check setup env
echo -n "
Confirm setup environment:
  Setup root directory: ${LOCAL_PATH}
  Actual config directories: ${LOCAL_ETC_PATH}
  Ex-commands bainary file path: ${LOCAL_BIN_PATH}
  Ex-commands installation path: ${LOCAL_OPT_PATH}
  Ex-commands default config storehouse: ${LOCAL_CONFIG_PATH}

Are you OK? (y/N): "
read confirm
case $confirm in 
    [Yy]|[Yy][Ee][Ss])
	mkdir -p "${LOCAL_ETC_PATH}" "${LOCAL_BIN_PATH}" \
		 "${LOCAL_OPT_PATH}" "${LOCAL_CONFIG_PATH}"
	;;
    *)
	exit 1
	;;
esac

# setup
"${DOTFILES_ETC_PATH}"/setup.sh
# install Ex-commands
"${DOTFILES_ETC_PATH}"/install.sh
