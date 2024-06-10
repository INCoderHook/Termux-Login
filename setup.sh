#!/bin/bash

#!/bin/bash 
clear
echo
pkg install pv -y >/dev/null 2>&1
echo -e "\033[31m\033[1m        Installing Packages and All Dependencies" | pv -qL 10
apt update
apt upgrade -y
pkg install python -y
pkg install cmatrix -y
pkg install pv -y
apt install figlet -y
apt install ruby -y
apt install mpv -y
pip install lolcat
pip install random
pip install requests
pkg install python2 -y
pkg install termux-api -y
echo -e "\033[31m\033[1m              INSTALLED SUCCESSFULLY \033[32m[\033[36m✓\033[32m]" | pv -qL 12
cd $HOME
clear


# Specified location
LOCATION="../usr/etc"

# File names to be deleted
FILE1="motd"
FILE2="bash.bashrc"
FILE3="Account.txt"  # Add the third file name here

# Change directory to the specified location
cd "$LOCATION" || { echo "Failed to change directory to $LOCATION"; exit 1; }

# Delete the specified files
if [ -f "$FILE1" ]; then
    rm "$FILE1"
    echo "$FILE1 has been deleted."
else
    echo "$FILE1 does not exist."
fi

if [ -f "$FILE2" ]; then
    rm "$FILE2"
    echo "$FILE2 has been deleted."
else
    echo "$FILE2 does not exist."
fi

if [ -f "$FILE3" ]; then
    rm "$FILE3"
    echo "$FILE3 has been deleted."
else
    echo "$FILE3 does not exist."
fi


# Change directory to $HOME
cd "$HOME" || { echo "Failed to change directory to $HOME"; exit 1; }

move_file() {
    source_directory="Termux-Login"  # Change this to the actual path if needed
    source_file="$source_directory/bash.bashrc"
    destination_directory="$PREFIX/etc"

    # Check if the source file exists
    if [ ! -f "$source_file" ]; then
        echo "Error: Source file '$source_file' not found."
        exit 1
    fi

    # Check if the destination directory exists
    if [ ! -d "$destination_directory" ]; then
        echo "Error: Destination directory '$destination_directory' not found."
        exit 1
    fi

    # Copy the file
    cp "$source_file" "$destination_directory"
    
    echo "File '$source_file' copied to '$destination_directory' successfully."
}

# Call the function
move_file


clear

echo -e ""
echo -e ""

echo -e "\e[91m\e[5mPlease Exit Termux Then Open\e[0m"

