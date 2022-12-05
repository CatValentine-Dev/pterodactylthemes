#!/bin/bash
CYAN='\033[0;36m'
echo -e "${CYAN}Mudando Linguagem...."

if (( $EUID != 0 )); then
    echo -e "${CYAN}Rode esse script usando root"
    exit
fi

clear

instalartema(){
    cd /var/www/
    tar -cvf pterodactylbackup.tar.gz pterodactyl
    echo -e "${CYAN}Instalando temas..."
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
        read -p "Tem certeza de que deseja instalar o tema [y/n]? " yn
        case $yn in
            [Yy]* ) instalartema; break;;
            [Nn]* ) exit;;
            * ) echo "Por favor responda yes ou no.";;
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
    echo "Restaurando Backup..."
    cd /var/www/
    tar -xvf pterodactylbackup.tar.gz
    rm pterodactylthemes.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}

    CYAN='\033[0;36m'
    echo -e "${CYAN}Copyright (c) 2022 TemuxOS"
    echo -e "${CYAN}Esse progama e um software livre, você pode modificar e distribuir sem problemas"
    echo -e ""
    echo -e "${CYAN}Discord: https://discord.gg/WkVVtTaBRh/"
    echo -e ""
    echo -e "${CYAN} [1] Instalar o Tema"
    echo -e "${CYAN} [2] Restaurar backup"
    echo -e "${CYAN} [3] Reparar Painel (Use caso tenha algo problema na instalação do temas)"
    echo -e "${CYAN} [4] Voltar"
    echo -e "${CYAN} [5] Sair"

read -p "Insira um numero: " choice
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
if [ $choice == "5" ]
    then
    exit
fi
