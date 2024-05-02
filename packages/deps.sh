#! /bin/bash


check_deps_installed() {
    for dependency in "wget" "gpg" "whiptail" "curl"; do
        if ! apt -qq list $dependency 2>/dev/null | grep -q "\[installed\]"; then
            return 1
        fi
    done
    return 0
}

install_deps() {
    sudo apt-get update && sudo apt-get install -y wget gpg
    sudo apt update && sudo apt install -y whiptail curl
}