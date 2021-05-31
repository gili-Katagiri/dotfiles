#!/usr/bin/env bash

set -u
BLACK_DOTFILES=".git"
TEST_RUN=${1:-"false"} # "true": debug-mode

main() {
    # cd root-dotfiles directory
    local wd_dot=$(get_repod_name $0)
    cd "$wd_dot"

    deploy_dotfiles ${HOME}
    deploy_bin_links ${LOCAL_BIN_PATH:-""}
}

check_deploy_link() {
    [[ " $BLACK_DOTFILES " =~ " $1 " ]] || return 1
}
get_repod_name() {
    local absf=$(realpath $0)
    echo ${absf%/etc/deploy.sh}
}
deploy_dotfiles() {
    # create link $_dest/.* to dotfiles/.*
    local _dest=${1:-"$HOME"}
    for f in .??*; do
        if check_deploy_link $f; then
            if [ $TEST_RUN = "true" ]; then
                echo "${wd_dot}/$f -> ${_dest}/$f"
            else
                ln -snv "${wd_dot}/$f" "${_dest}/$f"
            fi
        fi
    done
}
deploy_bin_links() {
    # create link ${LOCAL_BIN_PATH}/* to dotfiles/bin/*
    local _dest=${1:-"$HOME/.local/bin"}
    for b in bin/*; do
        if [ $TEST_RUN = "true" ]; then
            echo "${wd_dot}/$b -> ${_dest}/$(basename $b)"
        else
            ln -snv "${wd_dot}/$b" "${_dest}/$(basename $b)"
        fi
    done
}

main "$@" || exit 1
