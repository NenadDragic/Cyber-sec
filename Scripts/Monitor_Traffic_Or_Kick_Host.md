# Select and Run Wireless Network Commands with a Custom MAC Address

This bash script (`Monitor_Traffic_Or_Kick_Host.sh`) is designed to prompt the user to select a command to run and asks for a MAC address as an input parameter. The script then runs the corresponding command with the provided MAC address.

## Usage
Make sure you have permission to execute the script. If not, run the following command to grant permission:

```console
chmod +x run_commands.sh
```

Execute the script by running the following command:

```console
./Monitor_Traffic_Or_Kick_Host.sh -m <MAC_ADDRESS> -c <COMMAND>
```
The script requires two options to be passed: `-m` for the MAC address and `-c` for the command. The user needs to replace `<MAC_ADDRESS>` with the actual MAC address and `<COMMAND>` with one of the available commands - KILL, Traffic_On_BSSID, All_Traffic.

## Explanation
The script starts by defining default values for the mac and command variables:

The script starts by defining default values for the `mac` and `command` variables:

```console
mac=""
command=""
```

Next, it uses the `getopts` function to parse command-line options:

```console
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
```

The `getopts` function takes two arguments: a list of valid options, and the name of a variable to hold the selected option. In this script, `m`: and `c`: indicate that the script expects two options: `-m` for the MAC address and `-c` for the command. The `OPTARG` variable holds the value of the selected option.

The script then checks whether the MAC address and command are provided and prints an error message if either is missing:

```console
if [ -z "$mac" ]; then
  echo "MAC address not provided eg. ./script_name.sh -m <MAC_ADDRESS> -c <COMMAND> - Commands KILL - Traffic_On_BSSID - All_Traffic"
  exit 1
fi

if [ -z "$command" ]; then
  echo "Command not provided eg. ./script_name.sh -m <MAC_ADDRESS> -c <COMMAND> - Commands KILL - Traffic_On_BSSID - All_Traffic"
  exit 1
fi
```

If both the MAC address and command are provided, the script runs the selected command with the provided MAC address using a `case` statement:

```console
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
```
The `case` statement checks the value of the `command` variable and runs the corresponding command with the provided MAC address.
