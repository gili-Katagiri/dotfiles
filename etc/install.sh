#!/usr/bin/env bash

set -u

# use xdg as default config file, but not use actually.
export XDG_CONFIG_HOME="${LOCAL_CONFIG_PATH}"

# pre-installed commands check
dependency_commands=("git" "docker" "curl")
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
# Node.js: ref https://github.com/vercel/install-node
if !(type node > /dev/null 2>&1); then
    echo "Install node into ${LOCAL_PATH}."
    curl -Ls install-node.now.sh | bash -s -- --prefix=${LOCAL_PATH} --version=lts --yes
fi

# install jq for to process json
if !(type jq > /dev/null 2>&1); then
    # binary install to .local/bin
    (
	temp_version=1.6
	echo "Install jq v$temp_version ..."
	# .local/opt/jq
	mkdir -p "$LOCAL_OPT_PATH"/jq && cd $_
	echo -n "Download ... "
	( curl -sLO https://github.com/stedolan/jq/releases/download/jq-$temp_version/jq-linux64 && \
	    curl -sLO https://raw.githubusercontent.com/stedolan/jq/master/sig/v$temp_version/sha256sum.txt ) || \
	# failuer to download, exit this sub-shell
	( echo "Error: Failed to download from $_" && false ) || exit 1 && \
	# complete download
	echo "Complete!"
	# checksum and chmod and link
	echo -n "Validation ... "
	grep jq-linux64 sha256sum.txt | shasum -qa 256 -c - || \
	( echo "Error: Not match SHA256SUM." && false ) || exit 1 && \
	echo "checksum 256: Complete!"
	# post process
	chmod 755 jq-linux64 && \
	ln -sfnv $(pwd)/jq-linux64 "$LOCAL_BIN_PATH"/jq
    )
    if [ $? -ne 0 ]; then
	echo "Fetal Error: Failed to install 'jq'."
	exit 1
    else
	echo -e "jq installation accomplished!\n"
    fi
fi

# Sytra -----
if !(type sytra > /dev/null 2>&1); then
    echo "Install sytra."
    # clone from github
    git clone https://github.com/gili-Katagiri/sytra-docker "${LOCAL_OPT_PATH}"/sytra-docker
    # build as sytra:latest
    docker build -t sytra:latest "${LOCAL_OPT_PATH}/sytra-docker"
    # set local waypoint path
    cat >> "${LOCAL_INIT_RC}" << EOF
# sytra waypoint
export SYTRA_WAYPOINT=${LOCAL_OPT_PATH}/sytra-docker

EOF
    # enable to call sytra-entry as .local/bin/sytra
    ln -sfnv "${LOCAL_OPT_PATH}"/sytra-docker/sytra-entry.sh "${LOCAL_BIN_PATH}"/sytra
    echo "You may need to call bellow command for extraction stock data,
    which should be prepared as backup-file (e.g. backup.tar.gz) in previous environment."
    echo "Command:    \'sytra extract -f backup.tar.gz\'"
fi

# FZF -----
# install fzf as ${LOCAL_OPT_PATH}/fzf from GitHub
if !(type fzf > /dev/null 2>&1); then
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
    # add .local/bin
    echo -e "\nCreate fzf sym-links:"
    for binfile in $(ls "${LOCAL_OPT_PATH}"/fzf/bin); do
	echo -n "  "
	ln -sfnv "${LOCAL_OPT_PATH}"/fzf/bin/"$binfile" "${LOCAL_BIN_PATH}"/"$binfile"
    done
fi
# use as vim-plugin
echo -e "\nAdd sentence to 'exdein.toml' to use as vim-plugin."
cat > "${LOCAL_ETC_PATH}"/vim/exdein.toml << EOF
# fuzzy finder
[[plugins]]
repo = '${LOCAL_OPT_PATH}/fzf'
[[plugins]]
repo = 'junegunn/fzf.vim'

EOF

# EXA -----
if !(type exa > /dev/null 2>&1); then
    (
	echo "Install exa ."
	mkdir -p "$LOCAL_OPT_PATH"/exa && cd $_
	curl -sH "Accept: application/vnd.github.v3+json" \
	    https://api.github.com/repos/ogham/exa/releases/latest \
	    -o release_info.json
	
	zipurl=$(cat release_info.json | jq -r '.assets | map(select( .name | contains("linux-x86_64") )) | .[].browser_download_url')
	shasumurl=$(cat release_info.json | jq -r '.assets | map(select( .name | contains("SHA1SUMS") )) | .[].browser_download_url')
	
	echo -n "Download ... "
	( curl -sL "$zipurl" -o exa.zip && curl -sL "$shasumurl" -o sha1sum.txt ) || \
	( echo "Failed to download from $_"; false ) || exit 1 && \
	echo "Complete!"
	
	# get filename from exa.zip: *assumed to be included binary only*
	echo -n "Validation ... "
	fname=$(unzip -Z -1 exa.zip)
	unzip -oq exa.zip && grep $fname sha1sum.txt | shasum -qa 1 -c - || \
	( echo "Error: Not match SHA1SUM."; false ) || exit 1 && \
	echo "checksum 1: Complete!"
	
	chmod 755 $fname && \
	ln -sfnv $(pwd)/"$fname" "$LOCAL_BIN_PATH"/exa
    )
    if [ $? -ne 0 ]; then
	echo "Error: Failed to install 'exa'."
	echo "You should install manually or via package manager."
    else
	echo -e "exa installation accomplished!\n"
    fi
fi
