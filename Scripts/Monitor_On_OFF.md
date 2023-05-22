# Get Devices Firmware Information Script

This Bash script provides a way for users to display and manipulate the operating mode of their wireless network interfaces. To be used properly, it must be run with root privileges.

Here's a breakdown of how this script works:

1. **Root Privilege Check:** The script checks if the user has root privileges. It's important to run this script as root because changing network interface settings typically requires administrative permissions. If the script is not run as root, it will output a message asking to do so and will then exit.

2. **Functions:** This script has several functions defined to encapsulate different operations. The functions are:
   - `display_card_mode`: This function takes a network card name as an argument and outputs the current mode of operation of the card.
   - `display_wifi_cards`: This function displays a list of all available wireless network cards on the system.
   - `change_mode`: This function changes the operating mode of a given network card to a specified mode. Before proceeding, it validates the input to make sure it's either "monitor" or "managed" as these are the only two modes it can handle. If the mode is valid, it will bring down the network interface, change the mode, and then bring the interface back up.

3. **User Interaction:** The script then interacts with the user in the following ways:
   - It displays a list of all available wireless network cards.
   - It prompts the user to enter the name of the network card they want to manipulate.
   - It displays the current operating mode of the selected network card.
   - It prompts the user to enter the new operating mode they want to set for the card.
   - It changes the operating mode of the selected network card to the selected mode.

**Note**: Please be aware that this script uses the commands `iwconfig` and `ifconfig` which are considered deprecated in some Linux distributions. Depending on your system, you might want to modify this script to use the `ip` and `iw` commands instead.
