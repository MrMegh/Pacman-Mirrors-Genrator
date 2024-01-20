#!/bin/bash

#####################################################
#     ____  _           _ _ _                       #
#    |  _ \(_)         (_) | |                      #
#    | |_) |_ _ __ ___  _| | |_ _   _               #
#    |  _ <| | '_ ` _ \| | | __| | | |              #
#    | |_) | | | | | | | | | |_| |_| |              #
#    |____/|_|_| |_| |_|_|_|\__|\__, |              #
#                                __/ |              #
#                               |___/               #
#   Arch Linux Mirrorlist Updater Script             #
#                                                   #
# Author: YourNameHere                               #
# Date: 2024-01-20                                    #
#####################################################

echo -e "\n$(tput setaf 6)╔══════════════════════════════════════════════════╗"
echo "║       Arch Linux Mirrorlist Updater Script       ║"
echo "╚══════════════════════════════════════════════════╝$(tput sgr0)"

# Prompt user for the country code
read -p "Enter the country code (default is IN): " country

if [ -z "$country" ]; then
  country="IN"  # Default country code
fi

echo -e "\nUpdating mirrorlist for country: $country"

# Fetch the Arch Linux mirrorlist and uncomment all servers
mirrorlist_url="https://archlinux.org/mirrorlist/?country=$country&protocol=https&ip_version=6"
mirrorlist=$(curl -s "$mirrorlist_url")

# Check if mirrorlist retrieval was successful
if [ $? -ne 0 ]; then
  echo -e "\nError: Unable to retrieve mirrorlist. Please check your internet connection."
  exit 1
fi

# Check if the country is found
if [[ $mirrorlist == *"Server = https://archlinux.org/mirrorlist/"* ]]; then
  echo -e "\nError: Country code '$country' not found. Please enter a valid country code."
  exit 1
fi

# Uncomment all servers and save the mirrorlist
echo "$mirrorlist" | sed -e 's/^#Server/Server/' -e '/^#/d' > /etc/pacman.d/mirrorlist

# Check if the save operation was successful
if [ $? -ne 0 ]; then
  echo -e "\nError: Unable to save mirrorlist. Please check your permissions or try again."
  exit 1
fi

echo -e "\nMirrorlist updated successfully!"
echo "Run 'pacman -Syu' to refresh your package databases."

# Wait for user input before closing the terminal
read -p "Press Enter to exit..."
