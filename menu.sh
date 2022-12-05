if (( $EUID != 0 )); then
    echo -e "${CYAN}Run script as root"
    exit
fi

clear



portuguese(){
    bash <(curl https://raw.githubusercontent.com/CatValentine-Dev/pterodactylthemes/main/instaladorportugues.sh)
}

german(){
    bash <(curl https://raw.githubusercontent.com/CatValentine-Dev/pterodactylthemes/main/instaladorgerman.sh)
}

english(){
    bash <(curl https://raw.githubusercontent.com/CatValentine-Dev/pterodactylthemes/main/instaladorenglish.sh)
}

    CYAN='\033[0;36m'
    echo -e "${CYAN}Copyright (c) 2022 TemuxOS"
    echo -e "${CYAN}This Software is opensource."
    echo -e "Theme Instalator"
    echo -e "${CYAN}Discord: https://discord.gg/WkVVtTaBRh/"
    echo -e "Select your Language"
    echo -e "${CYAN}[1] Portuguese"
    echo -e "${CYAN}[2] German"
    echo -e "${CYAN}[3] English"
    echo -e "${CYAN}[4] Exit"
    
read -p "Insira um numero: " choice
if [ $choice == "1" ]
    then
    portuguese
fi
if [ $choice == "2" ]
    then
    german
fi
if [ $choice == "3" ]
    then
    english
fi
if [ $choice == "4" ]
    then
    exit
fi
