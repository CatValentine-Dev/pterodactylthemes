#!/bin/bash

if (( $EUID != 0 )); then
    echo "Rode o script com root"
    exit
fi

repararPainel(){
    cd /var/www/pterodactyl

    php artisan down

    rm -r /var/www/pterodactyl/resources

    curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv

    chmod -R 755 storage/* bootstrap/cache

    composer install --no-dev --optimize-autoloader

    php artisan view:clear

    php artisan config:clear

    php artisan migrate --seed --force

    chown -R www-data:www-data /var/www/pterodactyl/*

    php artisan queue:restart

    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

    apt update

    apt install -y nodejs

    npm i -g yarn

    yarn

    yarn build:production

    sudo php artisan optimize:clear

    php artisan up
    
    chown -R www-data:www-data /var/www/pterodactyl/*
}

while true; do
    read -p "Tem certeza que quer restaurar o painel? [y/n]? " yn
    case $yn in
        [Yy]* ) repararPainel; break;;
        [Nn]* ) exit;;
        * ) echo "Por favor responda yes ou no.";;
    esac
done
