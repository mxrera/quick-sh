#!/bin/bash

. packages/import.sh

green_color="\e[0;32m"
reset_color="\e[0m"

handle_dependencies(){
    if check_deps_installed; then
        return 0
    fi
    echo -e "${green_color}[ INFO ]${reset_color} This script requires the following dependencies: wget, gpg, whiptail, curl"
    echo -ne "${green_color}[ INFO ]${reset_color} Do you want to proceed? [y/n]: "
    read -r
    if [[ ! $REPLY =~ ^[Yy]$ ]] then
        exit 1
    fi
    install_deps
}

main() {
    dynamic_import
    handle_dependencies
    
    whiptail --title "Welcome" --backtitle "<Tab> moves; <Space> select; <Enter> continue;" --msgbox "Welcome to QuickSH, a package installation assistant!\n\n" 8 60

    general_packages=($(whiptail --title  "SELECT GENERAL PACKAGES TO INSTALL" --backtitle "<Tab> moves; <Space> select; <Enter> continue;" --checklist \
                "List of packages" 20 100 10 \
                "brave" "browser" OFF \
                "gimp" "image editor" OFF \
                "inkscape" "vector graphics editor" OFF \
                "vlc" "media player" OFF \
                "audacity" "audio editor" OFF \
                "obs-studio" "screen casting and streaming app" OFF \
                "spotify" "music player" OFF \
                "discord" "chat" OFF \
                 3>&1 1>&2 2>&3))
    dev_packages=($(whiptail --title "SELECT DEV PACKAGES TO INSTALL" --backtitle "<Tab> moves; <Space> select; <Enter> continue;" --checklist \
                "List of packages" 20 100 10 \
                "net-tools" "networking tools" OFF \
                "docker" "container development" OFF \
                "vscode" "code editor" OFF \
                "nodejs" "javascript runtime" OFF \
                "npm" "nodejs package manager" OFF \
                "wireshark" "network protocol analyzer" OFF \
                "foxglove-studio" "ROS visualizer" OFF \
                 3>&1 1>&2 2>&3))
    terminal_packages=($(whiptail --title "SELECT TERMINAL PACKAGES TO INSTALL" --backtitle "<Tab> moves; <Space> select; <Enter> continue;" --checklist \
                "List of packages" 20 100 10 \
                "neovim" "code editor" OFF \
                "tmux" "terminal multiplexer" OFF \
                "neofetch" "system information" OFF \
                "tree" "directory tree" OFF \
                "netcat" "network utility" OFF \
                "tcpdump" "network packet analyzer" OFF \
                "iputils" "network utility" OFF \
                 3>&1 1>&2 2>&3))

    packages=${general_packages[@]}${dev_packages[@]}${terminal_packages[@]}

    if [[ ${#packages[@]} -eq 0 ]]; then
        whiptail --title "MESSAGE" --backtitle "<Tab> moves; <Space> select; <Enter> continue;" --msgbox "No packages selected. Exiting the script!" 8 78
        exit 1
    fi

    whiptail --title "CONFIRMATION" --backtitle "<Tab> moves; <Space> select; <Enter> continue;" --yesno "The following packages will be installed: \n ${packages[@]}\n\nDo you want to proceed?" 20 60
    if [[ $? -eq 0 ]]; then
        clear
        install_packages ${packages[@]}
    elif [[ $? -eq 1 ]]; then 
        whiptail --title "MESSAGE" --backtitle "<Tab> moves; <Space> select; <Enter> continue;" --msgbox "Exiting the script without installing any packages!" 8 78
        exit 1
    fi
}

install_packages() {
    for package in $@; do
        echo -e "${green_color}[ INFO ]${reset_color} Installing $package ..."
        package=$(echo $package | tr -d '"') # extract the package name from the quotes
        $package
        echo -e "${green_color}[ INFO ]${reset_color} End of $package installation."
    done
}

main
