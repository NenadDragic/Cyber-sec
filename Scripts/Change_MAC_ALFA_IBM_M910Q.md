# Change MAC Address Script
This script (`change_mac.sh`) is designed to change the MAC address of the `wlan0` interface to a random one.

## Usage
Make sure you have permission to execute the script. If not, run the following command to grant permission:

```console
sudo ./change_mac.sh
```

Execute the script by running the following command with sudo privileges:

```console
sudo ./change_mac.sh
```

The script will perform the following actions:

1. Bring down the `wlan0` interface using `ifconfig` and `sudo`
2. Use `macchanger` and `sudo` to change the MAC address of the `wlan0` interface to a random one
3. Bring up the `wlan0` interface using `ifconfig` and `sudo`
4. Display the current configuration of the `wlan0` interface using `ifconfig`

## Explanation
The script uses the `ifconfig` and `macchanger` commands to change the MAC address of the `wlan0` interface. The script performs the following actions:

1. `sudo ifconfig wlan0 down`: This command brings down the `wlan0` interface by disabling it.
2. `sudo macchanger -r wlan0`: This command uses the `macchanger` tool to change the MAC address of the `wlan0` interface to a random one.
3. `sudo ifconfig wlan0 up`: This command brings up the `wlan0` interface by enabling it again.
4. `ifconfig wlan0`: This command displays the current configuration of the `wlan0` interface.
