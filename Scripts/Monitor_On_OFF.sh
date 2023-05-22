#!/bin/bash
# Get Devices Firmware Information Script

# Check if the user has root privileges
if [ "$(whoami)" != "root" ]
  then
    echo "Please run as root.\n"
    exit
fi

# Function to display the current mode of a wireless card
display_card_mode() {
  local card=$1

  echo "Current mode of $card:"
  echo "-----------------------"
  iwconfig $card 2>/dev/null | grep "Mode:" | awk '{print $4}'
  echo "-----------------------"
}

# Function to display the available wireless cards
display_wifi_cards() {
  echo "Available wireless cards:"
  echo "------------------------"
  iwconfig 2>/dev/null | grep -E "^[[:alnum:]]+" | awk '{print $1}'
  echo "------------------------"
}

# Function to change the mode of a wireless card
change_mode() {
  local card=$1
  local mode=$2

  # Check if the mode is valid
  if [[ $mode != "monitor" && $mode != "managed" ]]; then
    echo "Invalid mode. Please enter 'monitor' or 'managed'."
    return
  fi

  # Change the mode of the wireless card
  echo "Changing mode of $card to $mode..."
  if [[ $mode == "monitor" ]]; then
    sudo ifconfig $card down
    sudo iwconfig $card mode monitor
    sudo ifconfig $card up
  else
    sudo ifconfig $card down
    sudo iwconfig $card mode managed
    sudo ifconfig $card up
  fi

  echo "Mode changed successfully!"
}

# Display available wireless cards
display_wifi_cards

# Prompt for the card to change mode
read -p "Enter the wireless card you want to change mode: " selected_card

# Display the current mode of the selected wireless card
display_card_mode $selected_card

# Prompt for the mode to change to
read -p "Enter the mode ('monitor' or 'managed'): " selected_mode

# Change the mode of the selected wireless card
change_mode $selected_card $selected_mode
