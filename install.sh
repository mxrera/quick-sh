#!/bin/bash

. packages/import.sh

green_color="\e[0;32m"
reset_color="\e[0m"

welcome() {
    install_dependencies
    whiptail --title "Welcome" --msgbox "Welcome to QuickSH, a package installation assistant!\n\nYou can select packages with <Space>, press <Enter> to continue and <Tab> to switch between buttons." 10 60
    main
}

install_dependencies(){
    if check_deps_installed; then
        return 0
    fi
    echo -e "${green_color}[ INFO ]${reset_color} This script requires the following dependencies: wget, gpg, whiptail, curl"
    echo -ne "${green_color}[ INFO ]${reset_color} Do you want to proceed? [y/n]: "
    read -r
    if [[ ! $REPLY =~ ^[Yy]$ ]] then
        exit 1
    fi
    deps
}

main() {
    general_packages=($(whiptail --title "SELECT GENERAL PACKAGES TO INSTALL" --checklist \
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
    dev_packages=($(whiptail --title "SELECT DEV PACKAGES TO INSTALL" --checklist \
                "List of packages" 20 100 10 \
                "net-tools" "networking tools" OFF \
                "docker" "container development" OFF \
                "vscode" "code editor" OFF \
                "neovim" "code editor" OFF \
                "tmux" "terminal multiplexer" OFF \
                "nodejs" "javascript runtime" OFF \
                "npm" "nodejs package manager" OFF \
                "foxglove-studio" "ROS visualizer" OFF \
                 3>&1 1>&2 2>&3))

    whiptail --title "CONFIRMATION" --yesno "The following packages will be installed: \n ${general_packages[@]} ${dev_packages[@]} \n\nDo you want to proceed?" 20 60
    if [[ $? -eq 0 ]]; then
        clear
        install_packages "General" ${general_packages[@]}
        install_packages "Dev" ${dev_packages[@]}
    elif [[ $? -eq 1 ]]; then 
        whiptail --title "MESSAGE" --msgbox "Exiting the script without installing any packages!" 8 78
        exit 1
    fi
}

install_packages() {
    for package in $@; do
        if [ $package == "General" ] || [ $package == "Dev" ]; then
            continue
        fi
        echo -e "${green_color}[ INFO ]${reset_color} Installing $package ..."
        case $package in
            \"brave\") brave;;
            \"gimp\")gimp;;
            \"inkscape\")inkscape;;
            \"vlc\")vlc;;
            \"audacity\")audacity;;
            \"obs-studio\") obs-studio ;;
            \"spotify\")spotify ;;
            \"discord\") discord ;;
            \"net-tools\") net-tools ;;
            \"docker\") docker ;;
            \"vscode\") vscode ;;
            \"neovim\") neovim ;;
            \"tmux\") tmux ;;
            \"nodejs\") nodejs ;;
            \"npm\") npm ;;
            \"foxglove-studio\") foxglove-studio ;;
        esac
    done
}

welcome
