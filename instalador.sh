#!/bin/bash

if (( $EUID != 0 )); then
    echo "Rode esse script usando root"
    exit
fi

clear

instalartema(){
    cd /var/www/
    tar -cvf pterodactylbackup.tar.gz pterodactyl
    echo "Instalando temas..."
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

output(){
    echo -e '\e[36m'$1'\e[0m';
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
output "Copyright (c) 2022 TemuxOS"
output "Esse progama e um software livre, você pode modificar e distribuir sem problemas"
output ""
output "Discord: https://discord.gg/WkVVtTaBRh/"
output ""
output "[1] Instalar o Tema"
output "[2] Restaurar backup"
output "[3] Reparar Painel (Use caso tenha algo problema na instalação do temas)"
output "[4] Sair"

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
    exit
fi
