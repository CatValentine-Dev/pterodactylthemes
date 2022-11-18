#!/bin/bash

if (( $EUID != 0 )); then
    echo -e "${CYAN}Run this script using root"
    exit
fi

clear

instalartema(){
    cd /var/www/
    tar -cvf pterodactylbackup.tar.gz pterodactyl
    echo -e "${CYAN}Installing themes..."
    cd /var/www/pterodactyl
    rm -r pterodactylthemes
    git clone https://github.com/CatValentine-Dev/pterodactylthemes.git
    cd pterodactylthemes
    rm /var/www/pterodactyl/resources/scripts/pterodactylthemes.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv pterodactylthemes.css /var/www/pterodactyl/resources/scripts/pterodactylthemes.css
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

voltar(){
bash <(curl https://raw.githubusercontent.com/CatValentine-Dev/pterodactylthemes/main/menu.sh)
}

instaladordetemas(){
    while true; do
        read -p "Are you sure you want to install the theme [y/n]? " yn
        case $yn in
            [Yy]* ) instalartema; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

reparar(){
    bash <(curl https://raw.githubusercontent.com/CatValentine-Dev/pterodactylthemes/main/reparar.sh)
}

restaurarbackup(){
    echo "Restoring Backup..."
    cd /var/www/
    tar -xvf pterodactylbackup.tar.gz
    rm pterodactylthemes.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}

    CYAN='\033[0;36m'
    echo -e "${CYAN}Copyright 2022 TemuxOS"
    echo -e "${CYAN}This program is free software, you can modify and distribute it without any problems."
    echo -e ""
    echo -e "${CYAN}Discord: https://discord.gg/WkVVtTaBRh/"
    echo -e ""
    echo -e "${CYAN} [1] Install Theme"
    echo -e "${CYAN} [2] Restore Backup"
    echo -e "${CYAN} [3] Repair Panel (Use if you have a problem installing the themes)"
    echo -e "${CYAN} [4] Back"
    echo -e "${CYAN} [5] Exit"

read -p "Enter a number: " choice
if [ $choice == "1" ]
    then
    instaladordetemas
fi
if [ $choice == "2" ]
    then
    restaurarbackup
fi
if [ $choice == "3" ]
    then
    reparar
fi
if [ $choice == "4" ]
    then
    voltar
fi
 
if [ $choice == "5"]
    then
    exit
fi
