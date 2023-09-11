#!/bin/bash
# Installs hcl2json, sets $PATH
# Tested on Ubuntu 20.04 running on WSL2
# @git-cgallagher https://github.com/git-cgallagher

GREEN='\e[32m'
RED='\e[31m'
BLUE='\e[34m'
YELLOW='\e[33m'
RESET='\e[0m'

success() {
    echo -e "${GREEN}$1${RESET}"
}
failure() {
    echo -e "${RED}$1${RESET}"
}
warning() {
    echo -e "${YELLOW}$1${RESET}"
}
prompt() {
    echo -e "${BLUE}$1${RESET}"
}

compare_versions() {
    version1=$(echo $1 | awk -F. '{ printf("%03d%03d", $1,$2); }')
    version2=$(echo $2 | awk -F. '{ printf("%03d%03d", $1,$2); }')
    if [ $version1 -ge $version2 ]; then
        return 0
    else
        return 1
    fi
}

if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    if [ "$DISTRIB_ID" == "Ubuntu" ]; then
        if compare_versions "$DISTRIB_RELEASE" "20.04"; then
            :
        else
            echo -e "${RED}Ubuntu version $DISTRIB_RELEASE is not 20.04 or higher. Exiting...${RESET}"
            exit 1
        fi
    else
        echo -e "${RED}Target distribution is not Ubuntu. Exiting...${RESET}"
        exit 1
    fi
else
    echo -e "${RED}Unable to determine the distribution. Exiting...${RESET}"
    exit 1
fi

if command -v hcl2json &>/dev/null; then
    success "hcl2json is already installed."
else
    warning "hcl2json is not installed. Installing..."
    mkdir -p ~/.local/bin
    export PATH=$PATH:~/.local/bin
    echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
    wget https://github.com/tmccombs/hcl2json/releases/download/v0.6.0/hcl2json_linux_amd64 -O ~/.local/bin/hcl2json
    chmod +x ~/.local/bin/hcl2json
    success "hcl2json has been installed to ~/.local/bin."
fi