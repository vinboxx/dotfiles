#!/bin/bash

create_or_replace_symlink() {
    local source=$1
    local destination=$2

    if [ -L $destination ]; then
        rm $destination
    fi

    ln -nfs $source $destination
}

print_info() {
    # Print output in purple
    printf "\n\e[0;35m $1\e[0m\n\n"
}

print_success() {
    # Print output in green
    printf "\e[0;32m  [✔] $1\e[0m\n"
}
