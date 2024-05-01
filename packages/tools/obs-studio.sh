#!/bin/bash

obs-studio() {
    sudo add-apt-repository ppa:obsproject/obs-studio
    sudo apt update && apt install -y obs-studio
}