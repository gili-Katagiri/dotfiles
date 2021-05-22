#!/usr/bin/env bash

set -u
BLACK_DOTFILES=".git"
TEST_RUN=${1:-"false"} # "true": debug-mode

main() {
    # cd root-dotfiles directory
    local wd_dot=$(get_repod_name $0)
    cd "$wd_dot"

    # create link $HOME/.* to dotfiles/.*
    for f in .??*; do
        if check_deploy_link $f; then
            if [ $TEST_RUN = "true" ]; then
                echo "${wd_dot}/$f -> $HOME/$f"
            else
                ln -snv "${wd_dot}/$f" "$HOME/$f"
            fi
        fi
    done
}

check_deploy_link() {
    if [[ " $BLACK_DOTFILES " =~ " $1 " ]]; then
        return 1
    fi
}

get_repod_name() {
    local absf=$(realpath $0)
    echo ${absf%/etc/deploy.sh}
}

main "$@" || exit 1
