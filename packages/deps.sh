#! /bin/bash

deps() {
    sudo apt-get update && sudo apt-get install -y wget gpg
    sudo apt update && sudo apt install -y whiptail curl
}