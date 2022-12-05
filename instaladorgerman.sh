#!/bin/bash

if (( $EUID != 0 )); then
    echo -e "${CYAN}Führen Sie dieses Skript mit root aus"
    exit
fi

clear

instalartema(){
    cd /var/www/
    tar -cvf pterodactylbackup.tar.gz pterodactyl
    echo -e "${CYAN}Themen installieren..."
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

instaladordetemas(){
    while true; do
        read -p "Sind Sie sicher, dass Sie das Design installieren möchten [y/n]? " yn
        case $yn in
            [Yy]* ) instalartema; break;;
            [Nn]* ) exit;;
            * ) echo "Bitte antworte yes oder no.";;
        esac
    done
}

reparar(){
    bash <(curl https://raw.githubusercontent.com/CatValentine-Dev/pterodactylthemes/main/reparar.sh)
}

voltar(){
 bash <(curl https://raw.githubusercontent.com/CatValentine-Dev/pterodactylthemes/main/menu.sh)
}
 
restaurarbackup(){
    echo "Sicherung wiederherstellen..."
    cd /var/www/
    tar -xvf pterodactylbackup.tar.gz
    rm pterodactylthemes.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}

    CYAN='\033[0;36m'
    echo -e "${CYAN}Copyright (c) 2022 TemuxOS"
    echo -e "${CYAN}Dieses Programm ist freie Software, Sie können es ohne Probleme modifizieren und verteilen."
    echo -e ""
    echo -e "${CYAN}Discord: https://discord.gg/WkVVtTaBRh/"
    echo -e ""
    echo -e "${CYAN} [1] Theme installieren"
    echo -e "${CYAN} [2] Backup wiederherstellen"
    echo -e "${CYAN} [3] Reparaturbereich (Verwenden Sie diese Option, wenn Sie Probleme beim Installieren der Designs haben)"
    echo -e "${CYAN} [4] Rückgabe "
    echo -e "${CYAN} [5] Hinausgehen"

read -p "Geben Sie eine Zahl ein: " choice
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
