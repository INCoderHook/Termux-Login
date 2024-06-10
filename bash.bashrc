#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Set the path for the Account.txt file
ACCOUNT_FILE_PATH="../usr/etc/Account.txt"

check_network() {
    ping -c 1 google.com > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}INCoder is online!${NC}"
        return 0
    else
        echo -e "${RED}INCoder is offline!${NC}"
        return 1
    fi
}

create_credentials() {
    echo -e "${YELLOW}Creating new Account:${NC}"
    echo -e "${YELLOW}Enter New Username: ${NC}"
    read new_username
    echo -e "${YELLOW}Enter New Password: ${NC}"
    read -sp "Password: " new_password
    echo
    mkdir -p $(dirname "$ACCOUNT_FILE_PATH")
    echo "$new_username:$new_password" > "$ACCOUNT_FILE_PATH"
    echo -e "${GREEN}Account created successfully.${NC}"
}

change_credentials() {
    echo -e "${YELLOW}Enter New Username: ${NC}"
    read new_username
    echo -e "${YELLOW}Enter New Password: ${NC}"
    read -sp "Password: " new_password
    echo
    sed -i "s/$USERNAME:$PASSWORD/$new_username:$new_password/" "$ACCOUNT_FILE_PATH"
    echo -e "${GREEN}Username and password changed successfully.${NC}"
    USERNAME="$new_username"
    PASSWORD="$new_password"
}

verify_credentials() {
    echo -e "${YELLOW}Enter Username: ${NC}\c"
    read input_username
    echo -e "${YELLOW}Enter Password: ${NC}\c"
    read -sp "" input_password
    echo
    saved_credentials=$(cat "$ACCOUNT_FILE_PATH")
    while IFS= read -r line; do
        username=$(echo "$line" | cut -d':' -f1)
        password=$(echo "$line" | cut -d':' -f2)
        if [ "$input_username" == "$username" ] && [ "$input_password" == "$password" ]; then
            echo -e "${GREEN}Access granted${NC}"
            echo "Welcome, $input_username!"
            return 0
        fi
    done <<< "$saved_credentials"
    echo -e "${RED}Access denied${NC}"
    cmatrix -L
    exit 1
}

if [ ! -f "$ACCOUNT_FILE_PATH" ]; then
    create_credentials
fi

read_credentials() {
    saved_credentials=$(cat "$ACCOUNT_FILE_PATH")
    USERNAME=$(echo "$saved_credentials" | cut -d':' -f1)
    PASSWORD=$(echo "$saved_credentials" | cut -d':' -f2)
}


prompt_change_credentials() {
    echo -e "${YELLOW}Do you want to change your username and password? (yes/no): ${NC}"
    read -t 5 change_option
    if [ "$change_option" == "yes" ] || [ "$change_option" == "y" ]; then
        change_credentials
    elif [ "$change_option" == "no" ] || [ "$change_option" == "n" ]; then
        echo "Thik hai, koi baat nahi."
    fi
}



clear

check_network
if [ $? -ne 0 ]; then
    echo -e "${RED}Network is offline. Please check your network connection.${NC}"
    exit 1
fi

while true; do
    verify_credentials
    if [ $? -eq 0 ]; then
        break
    else
        echo "Please enter valid credentials!"
    fi
done

clear

check_network
if [ $? -ne 0 ]; then
    echo -e "${RED}Network is offline. Please check your network connection.${NC}"
    exit 1
fi

read_credentials

export PROMPT_COMMAND='
if [ $? -eq 0 ]; then
    PS1="\033[1m\[\e[32m\]\033[1m┌─[\[\e[37m\]\T\[\e[32m\]\033[1m]───\033[1m\e[1;98m\[[\[\e[32m\]\033[1m\e[5m$(check_network)\033[0m\033[32m]\033[1m\e[0;32m\033[1m───[\033[38;5;209m\#\033[32m]\n|\n\033[1m\e[0;32m\033[1m└─[\[\e[32m\]\e[1;33m\W\[\e[1m\033[32m]\033[1m──► \e[1;93m\033[1m"
else
    PS1="\033[1m\[\e[31m\]\033[1m┌─[\[\e[37m\]\T\[\e[31m\]\033[1m]───\033[1m\e[1;98m\[[\[\e[31m\]\033[1m\e[5m$(check_network)\033[0m\033[31m]\033[1m\e[0;31m\033[1m───[\033[38;5;209m\#\033[31m]\n|\n\033[1m\e[0;31m\033[1m└─[\[\e[31m\]\e[1;33m\W\[\e[1m\033[31m]\033[1m──► \e[1;93m\033[1m"
fi
'

prompt_change_credentials
